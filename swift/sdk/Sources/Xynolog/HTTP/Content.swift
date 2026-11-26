import AsyncHTTPClient
import Foundation
import NIOCore
import OpenTelemetryApi
import Synchronization

/// Awaited, an upload gives the resource it created; iterated, what it reports as it goes:
/// `started` with its size before any bytes are sent, `progress` as they are sent, and `finished`
/// with the resource made, once the knowledge base has answered. Its size is every byte sent for
/// it: over HTTP, the whole request. An upload that fails throws to its awaiter, and its reports
/// end without `finished`.
public final class Upload: AsyncSequence, Sendable {
  public typealias Element = UploadProgress
  public typealias AsyncIterator = Events<UploadProgress>.AsyncIterator
  private let progress: Events<UploadProgress>
  private let task: Task<CreateResourceResponse, any Error>
  public init(task: Task<CreateResourceResponse, any Error>, progress: Events<UploadProgress>) {
    self.task = task
    self.progress = progress
  }
  public func makeAsyncIterator() -> AsyncIterator { progress.makeAsyncIterator() }
  public func completed() async throws -> CreateResourceResponse {
    try await withTaskCancellationHandler {
      try await task.value
    } onCancel: {
      task.cancel()
    }
  }
  public func dispose() {
    task.cancel()
    progress.dispose()
  }
}
public final class ContentStream: AsyncSequence, Sendable {
  public typealias Element = Data
  public typealias AsyncIterator = Events<Data>.AsyncIterator
  public let contentType: String
  private let bytes: Events<Data>
  public init(contentType: String, bytes: Events<Data>) {
    self.contentType = contentType
    self.bytes = bytes
  }
  convenience init(
    response: HTTPClientResponse, lifetime: Lifetime,
    onEnd: @escaping @Sendable () async -> Void = {}
  ) throws {
    guard let contentType = response.headers.first(name: "Content-Type") else {
      throw TransportError(.error, "Content response has no Content-Type")
    }
    let (demands, demand) = AsyncStream<Void>.makeStream(bufferingPolicy: .unbounded)
    let (stream, continuation) = AsyncThrowingStream<Data, any Error>.makeStream(
      bufferingPolicy: .unbounded)
    let id = UUID()
    let task = spawn {
      defer {
        lifetime.forget(id)
        demand.finish()
      }
      var failure: (any Error)?
      do {
        var source = response.body.makeAsyncIterator()
        for await _ in demands {
          guard let buffer = try await source.next() else { break }
          continuation.yield(Data(buffer.readableBytesView))
        }
      } catch { failure = error }
      await onEnd()
      continuation.finish(throwing: failure)
    }
    lifetime.keep(task, id: id)
    self.init(
      contentType: contentType,
      bytes: Events(
        stream, demand: { demand.yield(()) },
        stop: {
          demand.finish()
          task.cancel()
          continuation.finish()
        }))

  }
  public func makeAsyncIterator() -> AsyncIterator { bytes.makeAsyncIterator() }
  public func dispose() { bytes.dispose() }
}

private struct Multipart: Sendable {
  let boundary = "xynolog-" + UUID().uuidString
  let data: Data
  init(_ request: PutBinaryRequest) throws {
    guard !request.format.contains("\r"), !request.format.contains("\n") else {
      throw TransportError(.error, "Invalid multipart content type")
    }
    func json<Value: Encodable>(_ value: Value) throws -> String {
      String(decoding: try JSONEncoder().encode(value), as: UTF8.self)
    }
    let form = ResourceUpload(
      name: request.name, file: Data(), format: request.format, storageUri: request.storageUri,
      language: request.language,
      entityTypes: try request.entityTypes.flatMap { $0.isEmpty ? nil : try json($0) },
      sourceAnnotationId: request.sourceAnnotationId, sourceResourceId: request.sourceResourceId,
      generationPrompt: request.generationPrompt,
      generator: try request.generator.map { try json($0) },
      jobId: request.jobId, isDraft: request.isDraft.map(String.init),
      cloneToken: request.cloneToken, archiveOriginal: request.archiveOriginal.map(String.init))
    let fields = try JSONDecoder().decode(
      [String: JSONValue].self, from: JSONEncoder().encode(form))
    var data = Data()
    for name in fields.keys.sorted() where name != UploadField.file.rawValue {
      guard case .string(let value) = fields[name] else {
        throw TransportError(.error, "Multipart field \(name) is not text")
      }
      data.append(
        Data(
          "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(quoted(name))\"\r\n\r\n\(value)\r\n"
            .utf8))
    }
    data.append(
      Data(
        "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(UploadField.file.rawValue)\"; filename=\"\(quoted(request.name))\"\r\nContent-Type: \(request.format)\r\n\r\n"
          .utf8))
    data.append(request.file)
    data.append(Data("\r\n--\(boundary)--\r\n".utf8))
    self.data = data
  }
}
extension GatewayRoute {
  /// The route's path for `resource`: its `{id}`, the id as it is, which the rule an id is held to
  /// keeps to one segment.
  fileprivate func path(for resource: ResourceId) -> String {
    path.replacingOccurrences(of: "{id}", with: resource.value)
  }
}
private func quoted(_ value: String) -> String {
  value.replacingOccurrences(of: "\"", with: "%22").replacingOccurrences(of: "\r", with: "%0D")
    .replacingOccurrences(of: "\n", with: "%0A")
}
private struct UploadBytes: AsyncSequence, Sendable {
  typealias Element = ByteBuffer
  let data: Data
  let report: @Sendable (Int) -> Void
  struct AsyncIterator: AsyncIteratorProtocol {
    let data: Data
    let report: @Sendable (Int) -> Void
    var offset = 0
    mutating func next() async throws -> ByteBuffer? {
      try Task.checkCancellation()
      guard offset < data.count else { return nil }
      let end = Swift.min(offset + 64 * 1024, data.count)
      let chunk = ByteBuffer(bytes: data[offset..<end])
      offset = end
      report(offset)
      return chunk
    }
  }
  func makeAsyncIterator() -> AsyncIterator { AsyncIterator(data: data, report: report) }
}
extension HttpTransport: ContentTransport {
  public nonisolated func putBinary(_ request: PutBinaryRequest) -> Upload {
    let (stream, continuation) = AsyncThrowingStream<UploadProgress, any Error>.makeStream(
      bufferingPolicy: .unbounded)
    let life = lifetime
    let id = UUID()
    let task = spawn(on: self) { transport in
      defer {
        continuation.finish()
        life.forget(id)
      }
      return try await transport.sendUpload(request, progress: continuation)
    }
    life.keep(task, id: id)
    return Upload(
      task: task,
      progress: Events(
        stream,
        stop: {
          task.cancel()
          continuation.finish()
        }))
  }
  private func sendUpload(
    _ request: PutBinaryRequest,
    progress: AsyncThrowingStream<UploadProgress, any Error>.Continuation
  ) async throws -> CreateResourceResponse {
    let upload = transportSpan(
      .contentPut,
      attributes: [
        attributeContentFormat: .string(request.format),
        attributeContentSizeBytes: .int(request.file.count),
      ])
    defer { upload.end() }
    let form = try Multipart(request)
    let http = self.http
    let highWater = Mutex(-1)
    let report: @Sendable (Int) -> Void = { sent in
      let newer = highWater.withLock { previous in
        if sent <= previous { return false }
        previous = sent
        return true
      }
      if newer {
        progress.yield(
          .progress(UploadProgressProgress(bytesUploaded: sent, totalBytes: form.data.count)))
      }
    }
    progress.yield(.started(UploadProgressStarted(totalBytes: form.data.count)))
    BusLog.line(
      "PUT", channel: "content",
      payload: [
        "name": .string(request.name), "format": .string(request.format),
        "storageUri": .string(request.storageUri), "sizeBytes": .number(Double(request.file.count)),
      ], scope: nil, correlationID: nil)
    let idempotencyKey = UUID().uuidString
    var credential = token
    var renewed = false
    let route = GatewayRoute.uploadResource
    var resend = OneResend(method: route.method, keyed: true, clock: clock)
    while true {
      try Task.checkCancellation()
      if lifetime.ended { throw CancellationError() }
      var wire = HTTPClientRequest(url: baseUrl + route.path)
      wire.method = .RAW(value: route.method)
      for (key, value) in traceCarrier(upload) { wire.headers.add(name: key, value: value) }
      wire.headers.add(
        name: "Content-Type",
        value: GatewayMedia.uploadResourceSends + "; boundary=" + form.boundary)
      wire.headers.add(name: GatewayHeader.idempotencyKey, value: idempotencyKey)
      if let credential { wire.headers.add(name: "Authorization", value: "Bearer " + credential) }
      wire.body = .stream(
        UploadBytes(data: form.data, report: report), length: .known(Int64(form.data.count)))
      do {
        let response: HTTPClientResponse
        do {
          response = try await http.execute(wire, deadline: .distantFuture)
        } catch {
          if Task.isCancelled || lifetime.ended { throw CancellationError() }
          if try await resend.afterNoAnswer() { continue }
          throw TransportError(
            .unavailable, "\(route.method) \(route.path) got no answer: \(error)")
        }
        if !(200..<300).contains(Int(response.status.code)) {
          let failure = await Self.refusal(
            response, path: route.path, deadlineMs: timing.httpRequestMs, clock: clock)
          if failure.reason == .unauthorized {
            if !renewed {
              renewed = true
              if let newToken = try await renew(refused: credential) {
                credential = newToken
                continue
              }
            }
          } else if try await resend.after(failure) {
            continue
          }
          throw failure
        }
        var data = Data()
        for try await chunk in response.body { data.append(contentsOf: chunk.readableBytesView) }
        let created = try JSONDecoder().decode(CreateResourceResponse.self, from: data)
        progress.yield(.finished(UploadProgressFinished(resourceId: created.resourceId)))
        return created
      } catch {
        if Task.isCancelled || lifetime.ended { throw CancellationError() }
        let failure =
          (error as? TransportError) ?? TransportError(.error, "Upload failed: \(error)")
        failureEvents.yield(failure)
        throw failure
      }
    }
  }
  public func getBinaryStream(_ resource: ResourceId) async throws -> ContentStream {
    try await owned { owner in
      let read = StreamingReadTrace(resource)
      do {
        BusLog.line(
          "GET", channel: "content", payload: ["resourceId": .string(resource.value)], scope: nil,
          correlationID: nil)
        let exchange = try await owner.begin(
          method: GatewayRoute.getResourceRepresentation.method,
          path: GatewayRoute.getResourceRepresentation.path(for: resource), trace: read.headers())
        return try ContentStream(
          response: exchange.response, lifetime: owner.lifetime, onEnd: { await read.end() })
      } catch {
        await read.end()
        throw error
      }
    }
  }
  public func getBinary(_ resource: ResourceId) async throws -> ResourceRepresentation {
    try await owned { owner in
      let read = transportSpan(
        .contentGet, attributes: [attributeResourceId: .string(resource.value)])
      defer { read.end() }
      BusLog.line(
        "GET", channel: "content", payload: ["resourceId": .string(resource.value)], scope: nil,
        correlationID: nil)
      let exchange = try await owner.begin(
        method: GatewayRoute.getResourceRepresentation.method,
        path: GatewayRoute.getResourceRepresentation.path(for: resource), trace: traceCarrier(read))
      do {
        let stream = try ContentStream(response: exchange.response, lifetime: owner.lifetime)
        defer { stream.dispose() }
        return try await within(exchange.remaining(), on: owner.clock) {
          var data = Data()
          for try await chunk in stream { data.append(chunk) }
          return ResourceRepresentation(data: data, contentType: stream.contentType)
        }
      } catch {
        if Task.isCancelled || owner.lifetime.ended { throw CancellationError() }
        let failure = TransportError(
          .unavailable,
          "\(GatewayRoute.getResourceRepresentation.method) "
            + "\(GatewayRoute.getResourceRepresentation.path(for: resource)) could not finish: \(error)"
        )
        owner.failureEvents.yield(failure)
        throw failure
      }
    }
  }
  public func getResourceGraph(_ resource: ResourceId) async throws -> GetResourceResponse {
    let read = transportSpan(
      .contentGetGraph, attributes: [attributeResourceId: .string(resource.value)])
    defer { read.end() }
    return try await answer(
      GetResourceResponse.self, method: GatewayRoute.getResourceJsonLd.method,
      path: GatewayRoute.getResourceJsonLd.path(for: resource),
      trace: traceCarrier(read))
  }
  public func getAnnotations(_ resource: ResourceId) async throws -> GetAnnotationsResponse {
    let read = transportSpan(
      .contentGetAnnotations, attributes: [attributeResourceId: .string(resource.value)])
    defer { read.end() }
    return try await answer(
      GetAnnotationsResponse.self, method: GatewayRoute.getResourceAnnotations.method,
      path: GatewayRoute.getResourceAnnotations.path(for: resource),
      trace: traceCarrier(read))
  }
  public func getAnchoredText(_ resource: ResourceId) async throws -> AnchoredTextAnswer {
    let read = transportSpan(
      .contentGetAnchoredText, attributes: [attributeResourceId: .string(resource.value)])
    defer { read.end() }
    return try await answer(
      AnchoredTextAnswer.self, method: GatewayRoute.getResourceAnchoredText.method,
      path: GatewayRoute.getResourceAnchoredText.path(for: resource),
      trace: traceCarrier(read))
  }
}

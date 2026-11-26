import AsyncHTTPClient
import Foundation

public let discoveryInterval: Duration = .milliseconds(Timings.discoveryIntervalMs)

public protocol DiscoveryTransport: Sendable {
  func read() async -> DiscoveryRead
}

private func discoveryRead(of state: DiscoveryState) -> DiscoveryRead {
  switch state {
  case .discoveryAbsent(let absent): .discoveryAbsent(absent)
  case .discoveryManaged(let managed): .discoveryManaged(managed)
  }
}

private func foundState(in read: DiscoveryRead) -> DiscoveryState? {
  switch read {
  case .discoveryAbsent(let absent): .discoveryAbsent(absent)
  case .discoveryManaged(let managed): .discoveryManaged(managed)
  case .discoveryUnchanged: nil
  }
}

public func parseDiscoveryDocument(_ text: String) -> DiscoveryState {
  let data = Data(text.utf8)
  let decoder = JSONDecoder()
  let parsed: JSONValue
  do {
    parsed = try decoder.decode(JSONValue.self, from: data)
  } catch {
    return .discoveryAbsent(
      DiscoveryAbsent(reason: .notJson, diagnostic: String(describing: error)))
  }
  guard case .object(let fields) = parsed,
    case .number(let version) = fields["version"], version.rounded() == version
  else {
    return .discoveryAbsent(
      DiscoveryAbsent(reason: .invalid, diagnostic: "Missing a numeric discovery version"))
  }
  guard let encodedVersion = try? JSONEncoder().encode(version),
    (try? decoder.decode(DiscoveryDocumentVersion.self, from: encodedVersion)) != nil
  else {
    return .discoveryAbsent(
      DiscoveryAbsent(
        reason: .unsupportedVersion, diagnostic: "Unsupported discovery version \(version)"))
  }
  if let fault = faultOf("DiscoveryDocument", parsed) {
    return .discoveryAbsent(DiscoveryAbsent(reason: .invalid, diagnostic: String(describing: fault)))
  }
  do {
    let document = try decoder.decode(DiscoveryDocument.self, from: data)
    return .discoveryManaged(DiscoveryManaged(kbs: document.kbs))
  } catch {
    return .discoveryAbsent(
      DiscoveryAbsent(reason: .invalid, diagnostic: String(describing: error)))
  }
}

private struct TextDiscovery: DiscoveryTransport {
  let text: @Sendable () async throws -> String

  func read() async -> DiscoveryRead {
    do {
      return discoveryRead(of: parseDiscoveryDocument(try await text()))
    } catch let error as CocoaError
      where error.code == .fileReadNoSuchFile || error.code == .fileNoSuchFile
    {
      return .discoveryAbsent(DiscoveryAbsent(reason: .notFound))
    } catch {
      return .discoveryAbsent(
        DiscoveryAbsent(reason: .unreadable, diagnostic: String(describing: error)))
    }
  }
}

public func textDiscovery(_ read: @escaping @Sendable () async throws -> String)
  -> any DiscoveryTransport
{
  TextDiscovery(text: read)
}

private actor HTTPDiscovery: DiscoveryTransport {
  let url: String
  let http: HTTPClient
  let clock: any Clock<Duration>
  var tag: String?

  init(url: String, http: HTTPClient, clock: any Clock<Duration>) {
    self.url = url
    self.http = http
    self.clock = clock
  }

  func read() async -> DiscoveryRead {
    var request = HTTPClientRequest(url: url)
    if let tag { request.headers.add(name: "If-None-Match", value: tag) }
    do {
      let http = http
      let (found, etag) = try await within(
        .milliseconds(Timings.httpRequestTimeoutMs), on: clock
      ) { [request] in
        let response = try await http.execute(request, deadline: .distantFuture)
        if response.status.code == 304 {
          return (DiscoveryRead.discoveryUnchanged(DiscoveryUnchanged()), nil as String?)
        }
        guard (200..<300).contains(response.status.code),
          response.headers.first(name: "Content-Type")?.lowercased().contains("json") == true
        else {
          return (
            .discoveryAbsent(
              DiscoveryAbsent(reason: .notFound, diagnostic: "HTTP \(response.status.code)")),
            nil
          )
        }
        var data = Data()
        for try await chunk in response.body { data.append(contentsOf: chunk.readableBytesView) }
        return (
          discoveryRead(of: parseDiscoveryDocument(String(decoding: data, as: UTF8.self))),
          response.headers.first(name: "ETag")
        )
      }
      if case .discoveryManaged = found { tag = etag }
      return found
    } catch {
      return .discoveryAbsent(
        DiscoveryAbsent(reason: .unreadable, diagnostic: String(describing: error)))
    }
  }
}

public func httpDiscovery(
  _ url: String, httpClient: HTTPClient, clock: any Clock<Duration> = ContinuousClock()
) -> any DiscoveryTransport {
  HTTPDiscovery(url: url, http: httpClient, clock: clock)
}

private func address(_ kb: DiscoveredKB) -> String { "\(kb.host):\(kb.port)" }

private func entries(_ state: DiscoveryState?) -> [DiscoveredKB] {
  if case .discoveryManaged(let managed) = state { return managed.kbs }
  return []
}

private func reason(_ state: DiscoveryState?) -> DiscoveryAbsentReason? {
  if case .discoveryAbsent(let absent) = state { return absent.reason }
  return nil
}

private func discoveryDiff(from previous: DiscoveryState?, to next: DiscoveryState)
  -> DiscoveryDiff?
{
  let before = entries(previous)
  let after = entries(next)
  let was = Dictionary(grouping: before, by: address)
  let now = Dictionary(grouping: after, by: address)
  let added = after.filter { was[address($0)] == nil }
  let removed = before.filter { now[address($0)] == nil }
  let updated = after.filter { kb in
    guard let previous = was[address(kb)] else { return false }
    let value = try? wirePayload(kb)
    return !previous.contains { (try? wirePayload($0)) == value }
  }
  var seen: Set<String> = []
  let duplicates = after.map(address).filter {
    (now[$0]?.count ?? 0) > 1 && seen.insert($0).inserted
  }
  let changedDuplicates = Set(was.filter { $0.value.count > 1 }.keys) != Set(duplicates)
  guard
    previous == nil || reason(previous) != reason(next) || changedDuplicates
      || !added.isEmpty || !removed.isEmpty || !updated.isEmpty
  else { return nil }
  return DiscoveryDiff(
    state: next, added: added, updated: updated, removed: removed, duplicated: duplicates)
}

private actor DiscoveryWatcher {
  let transport: any DiscoveryTransport
  let interval: Duration
  let clock: any Clock<Duration>
  var last: DiscoveryState?
  var readOnce = false

  init(transport: any DiscoveryTransport, interval: Duration, clock: any Clock<Duration>) {
    self.transport = transport
    self.interval = interval
    self.clock = clock
  }

  func next() async -> DiscoveryDiff? {
    while !Task.isCancelled {
      if readOnce {
        do { try await clock.sleep(for: interval) } catch { return nil }
      }
      readOnce = true
      if let state = foundState(in: await transport.read()), !Task.isCancelled,
        let changed = discoveryDiff(from: last, to: state)
      {
        last = state
        return changed
      }
    }
    return nil
  }
}

public func subscribeDiscovery(
  _ transport: any DiscoveryTransport, interval: Duration = discoveryInterval,
  clock: any Clock<Duration> = ContinuousClock()
) -> AsyncStream<DiscoveryDiff> {
  let watcher = DiscoveryWatcher(transport: transport, interval: interval, clock: clock)
  return AsyncStream(unfolding: { await watcher.next() })
}

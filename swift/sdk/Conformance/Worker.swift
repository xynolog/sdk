import AsyncHTTPClient
import Foundation
import Xynolog

extension Dictionary where Key == String, Value == JSONValue {
  fileprivate func decoded<T: Decodable>(_ key: String, as type: T.Type) throws -> T {
    guard let value = self[key] else { throw Misuse(description: "\(key) is required") }
    do {
      return try JSONDecoder().decode(type, from: JSONEncoder().encode(value))
    } catch {
      throw Misuse(description: "\(key) is invalid: \(error)")
    }
  }

  fileprivate func optional<T: Decodable>(_ key: String, as type: T.Type) throws -> T? {
    guard self[key] != nil else { return nil }
    return try decoded(key, as: type)
  }
}

actor WorkerDriver {
  static let operations: Set<String> = [
    "open", "close", "subscribe-resource", "claim", "start", "progress", "checkpoint", "commit",
    "complete", "fail", "cancel", "vitals", "sync",
  ]
  static let immediate: Set<String> = ["claim", "vitals"]

  let output: Output
  let http: HTTPClient
  var client: XynologClient?
  var transport: HttpTransport?
  /// Ends the failures `transport` told, once it is disposed.
  var telling: AsyncStream<TransportError>.Continuation?
  /// The waits `open` named of those its claims keep, as `ClaimOptions` members.
  var claimWaits: [String: JSONValue] = [:]
  var claims: Claims?
  var held: (any HeldJob)?
  var scopes: [ResourceHold] = []
  var reporters: [Task<Void, Never>] = []

  init(output: Output, http: HTTPClient) {
    self.output = output
    self.http = http
  }

  private func open(_ args: [String: JSONValue]) async throws {
    guard client == nil else { throw Misuse(description: "The worker is already open") }
    var transportTiming = TransportTiming()
    var claimWaits: [String: JSONValue] = [:]
    if args["timing"] != nil {
      let timing = try args.object("timing")
      for (name, held) in timing {
        let value = try timing.integer(name)
        guard value >= 0 else { throw Misuse(description: "Negative timing \(name)") }
        switch name {
        case "reconnectMs": transportTiming.reconnectMs = value
        case "lazyRemoveMs": transportTiming.lazyRemoveMs = value
        case "lingerMs": transportTiming.lingerMs = value
        default: claimWaits[name] = held
        }
      }
    }
    self.claimWaits = claimWaits
    var channels = jobClaimChannels
    if try args.optionalBool("commits") == true { channels += jobCommitChannels }
    let transport = HttpTransport(
      baseUrl: try args.text("baseUrl"), httpClient: http, token: try args.text("token"),
      channels: channels.sorted(), timing: transportTiming)
    let (failures, telling) = failuresTold(by: transport)
    do {
      client = try await XynologClient(transport: transport)
    } catch {
      transport.dispose()
      throw error
    }
    self.transport = transport
    self.telling = telling
    let output = output
    reporters.append(
      Task {
        for await state in transport.state {
          await output.say(.state(ConformanceDriverLineState(state: state.rawValue)))
        }
      })
    reporters.append(
      Task {
        for await error in failures {
          await output.say(.errorStream(ConformanceDriverLineErrorStream(error: failure(error))))
        }
      })
  }

  private func claimed(_ job: any HeldJob) async {
    held = job
    await output.say(.claimed(ConformanceDriverLineClaimed(claimed: job.record)))
    let output = output
    reporters.append(
      Task {
        for await signal in job.cancelled where signal {
          await output.say(.signalled(ConformanceDriverLineSignalled(signalled: job.jobId.value)))
          break
        }
      })
  }

  /// The options a claim of what `args` accepts is given: those accepts, and the waits `open` named.
  private func claimOptions(_ args: [String: JSONValue]) throws -> ClaimOptions {
    var options = claimWaits
    options["accepts"] = args["accepts"]
    do {
      return try JSONDecoder().decode(ClaimOptions.self, from: JSONEncoder().encode(options))
    } catch { throw Misuse(description: "The claim's options are invalid: \(error)") }
  }

  private func startClaims(_ options: ClaimOptions) throws {
    guard let client else { throw Misuse(description: "The worker is closed") }
    guard claims == nil else { throw Misuse(description: "The worker is already claiming") }
    let claims = client.job.claim(options)
    self.claims = claims
    let output = output
    let refused = claims.refused()
    reporters.append(
      Task {
        do {
          for try await error in refused {
            await output.say(
              .refused(
                ConformanceDriverLineRefused(
                  refused: ConformanceFailure(code: error.code?.rawValue, detail: error.message))))
          }
        } catch {}
      })
    let stalled = claims.stalled()
    reporters.append(
      Task {
        do {
          for try await stall in stalled {
            await output.say(.stalled(ConformanceDriverLineStalled(stalled: stall.jobId.value)))
          }
        } catch {}
      })
    reporters.append(
      Task { [weak self] in
        for await job in claims { await self?.claimed(job) }
      })
  }

  private func working() throws -> any HeldJob {
    guard let held else { throw Misuse(description: "The worker has held no job") }
    return held
  }

  private func vitals() async throws -> JSONValue {
    guard let claims else { throw Misuse(description: "The worker is not claiming") }
    return try encoded(await claims.vitals)
  }

  func run(_ op: String, args: [String: JSONValue]) async throws -> JSONValue {
    switch op {
    case "open": try await open(args)
    case "close":
      await claims?.stop()
      client?.dispose()
      telling?.finish()
      for reporter in reporters { await reporter.value }
      reporters.removeAll()
      scopes.removeAll()
    case "claim": try startClaims(claimOptions(args))
    case "subscribe-resource":
      guard let transport else { throw Misuse(description: "The worker is closed") }
      let resource = try ResourceId(args.text("resource"))
      scopes.append(await transport.subscribeToResource(resource))
    case "start": try await working().start()
    case "progress":
      let percentage = try args.decoded("percentage", as: Double.self)
      let message = try args.optional("message", as: JobProgressMessage.self)
      try await working().progress(JobProgress(percentage: percentage, message: message))
    case "checkpoint":
      try await working().checkpoint(
        JobCheckpoint(
          completedUnits: args.texts("completedUnits"),
          unitCursors: args.optional("unitCursors", as: [String: UnitCursor].self)))
    case "commit":
      try await working().commit(
        resourceId: ResourceId(args.text("resourceId")),
        annotations: args.decoded("annotations", as: [Annotation].self))
    case "complete":
      let job = try working()
      if let mark = job as? any HeldMarkJob {
        try await mark.complete(args.decoded("result", as: MarkJobResult.self))
      } else if let yield = job as? any HeldYieldJob {
        try await yield.complete(args.decoded("result", as: YieldJobResult.self))
      } else {
        throw Misuse(description: "The held job has no supported verb")
      }
    case "fail":
      try await working().fail(
        args.text("error"),
        failure: JobFailure(
          completedUnits: args.optional("completedUnits", as: [String].self),
          unitCursors: args.optional("unitCursors", as: [String: UnitCursor].self),
          failureClass: args.optional("failureClass", as: FailureClass.self)))
    case "cancel":
      try await working().cancel(
        JobReached(
          completedUnits: args.optional("completedUnits", as: [String].self),
          unitCursors: args.optional("unitCursors", as: [String: UnitCursor].self)))
    case "vitals": return try await vitals()
    case "sync": break
    default: throw Misuse(description: "Unknown worker operation \(op)")
    }
    return .null
  }

  func finish() async {
    // EOF ends the driver without settling an owned job.
    client?.dispose()
    for reporter in reporters { reporter.cancel() }
    for reporter in reporters { await reporter.value }
    held = nil
  }
}

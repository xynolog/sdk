import Synchronization

extension MatchResourcesRequest {
  /// The request a search for `search` sends: `filters`, each member only as its caller states
  /// it. Each search is kept by it, so searches that send the same request share one.
  init(_ search: String, filters: ResourceSearchFilters) {
    self.init(
      search: search, archived: filters.archived, entityType: filters.entityType,
      offset: filters.offset, limit: filters.limit)
  }
}

/// What the key holders reported of their engines' limits when the engines were last asked for.
final class ReportedLimits: Sendable {
  private let reported = Mutex<[EngineLimits]>([])

  func keep(_ limits: [EngineLimits]) { reported.withLock { $0 = limits } }

  /// `engines`, in their order, each with the limits reported for its provider and model.
  func joined(_ engines: [EngineEntry]) -> EnginesWithLimits {
    let reports = reported.withLock { $0 }
    return engines.map { entry in
      let limits = reports.first {
        $0.engine.provider == entry.engine.provider && $0.engine.model == entry.engine.model
      }?.limits
      return EngineWithLimits(engine: entry.engine, jobs: entry.jobs, limits: limits)
    }
  }
}

/// The knowledge base's engines, asked for first, and each key holder's report of its engines'
/// limits after it, which `limits` keeps.
func browseEngines(_ wire: Bus, keeping limits: ReportedLimits) async throws -> [EngineEntry] {
  let (queued, sent) = AsyncStream<Void>.makeStream()
  async let catalog: BrowseEnginesResult = {
    defer { sent.finish() }
    return try await wire.request(
      Operations.browseEnginesRequested, BrowseEnginesRequest(), enqueued: { sent.yield() })
  }()
  var waiting = queued.makeAsyncIterator()
  guard await waiting.next() != nil else {
    // A request that could not be sent cannot have any engine entries to join.
    _ = try await catalog
    throw CancellationError()
  }
  async let reports = engineLimits(wire)
  let entries = try await catalog.response.engines
  let reported = await reports
  try Task.checkCancellation()
  limits.keep(reported)
  return entries
}

private func engineLimits(_ wire: Bus) async -> [EngineLimits] {
  await withTaskGroup(of: (Int, [EngineLimits]).self) { group in
    for (index, operation) in Operations.limits.enumerated() {
      group.addTask {
        let answer = try? await wire.request(operation, InferenceLimitsRequest())
        return (index, answer?.response.limits ?? [])
      }
    }
    var received: [(Int, [EngineLimits])] = []
    for await report in group { received.append(report) }
    return received.sorted { $0.0 < $1.0 }.flatMap { $0.1 }
  }
}

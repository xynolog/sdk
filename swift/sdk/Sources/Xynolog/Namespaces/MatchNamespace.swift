public struct MatchNamespace: Sendable {
  let wire: Bus
  let bus: EventBus
  let lifetime: Lifetime
  let live: LiveQueries

  public func resources(
    _ search: String, filters: ResourceSearchFilters = ResourceSearchFilters()
  ) -> Cached<MatchResourcesResponse> {
    live.matchedResources.observe(MatchResourcesRequest(search, filters: filters))
  }
  public func search(
    resourceId: ResourceId, referenceId: AnnotationId, context: GatheredContext,
    options: MatchSearchOptions = MatchSearchOptions()
  ) -> Running<MatchSearchResult> {
    search(
      MatchSearchRequest(
        resourceId: resourceId, referenceId: referenceId, context: context, limit: options.limit,
        useSemanticScoring: options.useSemanticScoring))
  }

  /// The search `request` asks for, its limit filled where it leaves it out, as
  /// client/surface.json's `match.search` cases state it.
  func search(_ request: MatchSearchRequest) -> Running<MatchSearchResult> {
    var request = request
    if request.limit == nil { request.limit = 10 }
    return Running(lifetime: lifetime) { [request] _ in
      try await wire.request(Operations.matchSearchRequested, request)
    }
  }
  public func requestSearch(_ input: MatchSearchRequest, correlationId: String) throws {
    try bus.emit(Channels.matchSearchRequested, input, correlationId: correlationId)
  }
}

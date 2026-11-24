public struct MatchNamespace: Sendable {
  let wire: Bus
  let bus: EventBus
  let lifetime: Lifetime
  let live: LiveQueries

  public func resources(
    _ search: String, filters: ResourceSearchFilters = ResourceSearchFilters()
  ) -> Cached<MatchResourcesResponse> {
    live.matchedResources.observe(MatchResourcesRequest(search, paging: filters))
  }
  public func search(
    resourceId: ResourceId, referenceId: AnnotationId, context: GatheredContext,
    options: MatchSearchOptions = MatchSearchOptions()
  ) -> Running<MatchSearchResult> {
    search(
      MatchSearchRequest(
        context: context, limit: options.limit, referenceId: referenceId, resourceId: resourceId,
        useSemanticScoring: options.useSemanticScoring))
  }

  /// The search `request` asks for, its limit and scoring filled where it leaves them out, as
  /// client/surface.json's `match.search` cases state them.
  func search(_ request: MatchSearchRequest) -> Running<MatchSearchResult> {
    var request = request
    if request.limit == nil { request.limit = 10 }
    if request.useSemanticScoring == nil { request.useSemanticScoring = true }
    return Running(lifetime: lifetime) { [request] _ in
      try await wire.request(Operations.matchSearchRequested, request)
    }
  }
  public func requestSearch(_ input: MatchSearchRequest, correlationId: String) throws {
    try bus.emit(Channels.matchSearchRequested, input, correlationId: correlationId)
  }
}

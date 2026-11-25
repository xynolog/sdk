public struct GatherNamespace: Sendable {
  let wire: Bus
  let lifetime: Lifetime
  let live: LiveQueries

  public func referencedBy(_ resourceId: ResourceId) -> Cached<
    [GetReferencedByResponseReferencedByItem]
  > {
    live.referencedBy.observe(resourceId)
  }
  public func annotation(
    resourceId: ResourceId, annotationId: AnnotationId, options: GatherAnnotationOptions? = nil
  ) -> Running<GatherAnnotationComplete> {
    var options = options ?? GatherAnnotationOptions()
    if options.contextWindow == nil { options.contextWindow = 2000 }
    let request = GatherAnnotationRequest(
      annotationId: annotationId, resourceId: resourceId, options: options)
    return Running(lifetime: lifetime) { _ in
      try await wire.request(Operations.gatherRequested, request)
    }
  }
  public func resource(_ resourceId: ResourceId, options: GatherResourceOptions? = nil) async throws
    -> GatheredContext
  {
    let excluded = options?.excludeEntityTypes.flatMap { $0.isEmpty ? nil : $0 }
    let options = GatherResourceRequestOptions(
      depth: options?.depth ?? 2, maxResources: options?.maxResources ?? 10,
      includeContent: options?.includeContent ?? true,
      includeSummary: options?.includeSummary ?? false,
      excludeEntityTypes: excluded)
    return try await wire.request(
      Operations.gatherResourceRequested,
      GatherResourceRequest(resourceId: resourceId, options: options)
    ).response
  }
}

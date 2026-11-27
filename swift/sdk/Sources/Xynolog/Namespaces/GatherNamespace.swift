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
      depth: options?.depth ?? OptionDefaults.gatherResourceDepth,
      maxResources: options?.maxResources ?? OptionDefaults.gatherResourceMaxResources,
      includeContent: options?.includeContent ?? OptionDefaults.gatherResourceIncludeContent,
      includeSummary: options?.includeSummary ?? OptionDefaults.gatherResourceIncludeSummary,
      excludeEntityTypes: excluded)
    return try await wire.request(
      Operations.gatherResourceRequested,
      GatherResourceRequest(resourceId: resourceId, options: options)
    ).response
  }
}

public struct MarkNamespace: Sendable {
  let wire: Bus
  let bus: EventBus
  let lifetime: Lifetime
  let timing: ClientTiming
  let clock: any Clock<Duration>
  public func annotation(_ request: CreateAnnotationRequest) async throws -> MarkCreateOkResponse {
    try await wire.request(
      Operations.markCreateRequest,
      MarkCreateRequest(resourceId: request.target.source, request: request)
    ).response
  }
  public func delete(resourceId: ResourceId, annotationId: AnnotationId) async throws {
    _ = try await wire.request(
      Operations.markDelete, MarkDeleteCommand(annotationId: annotationId, resourceId: resourceId))
  }
  public func archive(_ resourceId: ResourceId) async throws {
    _ = try await wire.request(Operations.markArchive, MarkArchiveCommand(resourceId: resourceId))
  }
  public func unarchive(_ resourceId: ResourceId) async throws {
    _ = try await wire.request(
      Operations.markUnarchive, MarkUnarchiveCommand(resourceId: resourceId))
  }
  public func updateEntityTypes(resourceId: ResourceId, current: [String], updated: [String])
    async throws
  {
    _ = try await wire.request(
      Operations.markUpdateEntityTypes,
      MarkUpdateEntityTypesCommand(
        resourceId: resourceId, currentEntityTypes: current, updatedEntityTypes: updated))
  }
  public func delegate(resourceId: ResourceId, params: MarkJobParams) -> Delegation<
    MarkJobCompleteCommand
  > {
    let clock = clock
    return follow(
      create: .markJobCreateCommand(MarkJobCreateCommand(resourceId: resourceId, params: params)),
      resource: resourceId, wire: wire, bus: bus, lifetime: lifetime, timing: timing,
      clock: clock, completion: MarkJobCompleteCommand.self)
  }
  public func request(source: ResourceId, selector: AnnotationSelector, motivation: Motivation)
    throws
  {
    try bus.emit(
      Channels.markRequested,
      MarkRequestedEvent(source: source, selector: selector, motivation: motivation))
  }
  public func submit(_ input: MarkSubmitEvent) throws { try bus.emit(Channels.markSubmit, input) }
  public func reportDeleteError(_ input: ResourceErrorEvent) throws {
    try bus.emit(Channels.markDeleteError, input)
  }
}

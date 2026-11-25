import Foundation
import Testing

@testable import Xynolog

func statusFixture(
  _ job: String = "job-1", kind: JobType = .mark, status: JobStatusResponseStatus = .complete,
  error: String? = nil
) throws -> JobStatusResponse {
  JobStatusResponse(
    jobId: try JobId(job), type: kind, status: status,
    userId: try UserId("did:web:kb.test:users:person"), created: "2026-11-03T00:00:00Z",
    error: error)
}
func contextFixture() throws -> GatheredContext {
  let table = try Spec.read("client/surface.json").object
  return try decoded(GatheredContext.self, required(required(table, "fixtures").object, "context"))
}
func jobCreatedFixture(_ job: String = "job-1") throws -> [String: JSONValue] {
  try wirePayload(JobCreatedResult(response: JobCreatedResultResponse(jobId: JobId(job))))
}
func jobClaimedFixture(_ job: String = "job-1") throws -> [String: JSONValue] {
  try wirePayload(
    JobClaimedResult(
      response: JobRunning(
        metadata: JobMetadata(
          id: JobId(job), type: .mark, userId: UserId("did:web:kb.test:users:person"),
          created: "2026-11-04T00:00:00Z", retryCount: 0, maxRetries: 1),
        params: JobParams(resourceId: ResourceId("res-1")),
        startedAt: "2026-11-04T00:00:00Z", progress: .empty(JobStoredProgressEmpty()))))
}
func completionFixture(_ create: JobCreateCommand, job: String = "job-1") throws
  -> JobCompleteCommand
{
  let job = try JobId(job)
  switch create {
  case .markJobCreateCommand(let command):
    return .markJobCompleteCommand(
      MarkJobCompleteCommand(resourceId: command.resourceId, jobId: job))
  case .yieldJobCreateCommand(let command):
    let resource: ResourceId
    switch command.params.context.focus {
    case .resource(let focus): resource = focus.resource.id
    case .annotation(let focus): resource = focus.sourceResource.id
    }
    return .yieldJobCompleteCommand(YieldJobCompleteCommand(resourceId: resource, jobId: job))
  }
}
func annotationReply(_ annotation: Annotation) throws -> [String: JSONValue] {
  try wirePayload(
    BrowseAnnotationResult(
      response: GetAnnotationResponse(annotation: annotation, resource: nil, resolvedResource: nil))
  )
}

func surfaceReplies(_ probe: ProbeTransport, cloneAnswer: JSONValue?) {
  probe.handle { [weak probe] name, payload in
    switch name {
    case Operations.browseEntityTypesRequested.request.name:
      return try wirePayload(
        BrowseEntityTypesResult(
          response: GetEntityTypesResponse(entityTypes: ["Person"])))
    case Operations.browseTagSchemasRequested.request.name:
      return try wirePayload(
        BrowseTagSchemasResult(response: GetTagSchemasResponse(tagSchemas: [])))
    case Operations.browseResourcesRequested.request.name:
      return try wirePayload(
        BrowseResourcesResult(
          response: ListResourcesResponse(resources: [], total: 0, offset: 0, limit: 100)))
    case Operations.matchResourcesRequested.request.name:
      return try wirePayload(
        MatchResourcesResult(
          response: MatchResourcesResponse(
            resources: [], total: 0, offset: 0, limit: 100, matchKind: .lexical)))
    case Operations.browseEnginesRequested.request.name:
      return try wirePayload(
        BrowseEnginesResult(response: BrowseEnginesResultResponse(engines: [])))
    case let name where Operations.limits.contains(where: { $0.request.name == name }):
      return try wirePayload(
        InferenceLimitsResult(response: InferenceLimitsResultResponse(limits: [])))
    case Operations.browseResourceRequested.request.name:
      guard case .resource(let focus) = try contextFixture().focus else {
        throw SpecFailure.shape("resource focus")
      }
      return try wirePayload(
        BrowseResourceResult(
          response: BrowseResourceResultResponse(resource: focus.resource, lastSequence: 1)))
    case Operations.gatherReferencedByRequested.request.name:
      return try wirePayload(
        GatherReferencedByResult(
          response: GetReferencedByResponse(referencedBy: [])))
    case Operations.browseEventsRequested.request.name:
      let request = try decoded(BrowseEventsRequest.self, .object(payload))
      return try wirePayload(
        BrowseEventsResult(
          response: GetEventsResponse(
            events: [], total: 0, resourceId: request.resourceId)))
    case Operations.browseAnnotationRequested.request.name:
      let request = try decoded(BrowseAnnotationRequest.self, .object(payload))
      return try annotationReply(
        Annotation(
          id: request.annotationId, motivation: .commenting,
          target: .resourceId(request.resourceId), created: "2026-11-03T00:00:00Z"))
    case Operations.browseAnnotationHistoryRequested.request.name:
      let request = try decoded(BrowseAnnotationHistoryRequest.self, .object(payload))
      return try wirePayload(
        BrowseAnnotationHistoryResult(
          response: GetAnnotationHistoryResponse(
            events: [], total: 0, annotationId: request.annotationId, resourceId: request.resourceId
          )))
    case Operations.browseDirectoryRequested.request.name:
      let request = try decoded(BrowseDirectoryRequest.self, .object(payload))
      return try wirePayload(
        BrowseDirectoryResult(
          response: BrowseDirectoryResultResponse(
            path: request.path, entries: [])))
    case Operations.browseKbRequested.request.name:
      return try wirePayload(
        BrowseKbResult(response: KbDescription(name: "Test", domain: "kb.test")))
    case Operations.jobCreate.request.name:
      let completion = try completionFixture(decoded(JobCreateCommand.self, .object(payload)))
      probe?.deliver(
        .frame(
          ReceivedFrame(channel: Channels.jobComplete.name, payload: try wirePayload(completion))))
      return try jobCreatedFixture()
    case Operations.jobClaim.request.name:
      return try jobClaimedFixture()
    case Operations.jobStatusRequested.request.name:
      return try wirePayload(JobStatusResult(response: statusFixture()))
    case Operations.jobCancelRequested.request.name:
      return try wirePayload(ResponseEnvelope(response: JobCancelResult(cancelled: true)))
    case Operations.markDelete.request.name:
      let request = try decoded(MarkDeleteCommand.self, .object(payload))
      return try wirePayload(
        MarkDeleteOk(response: MarkDeleteOkResponse(annotationId: request.annotationId)))
    case Operations.markCreateRequest.request.name:
      return try wirePayload(
        ResponseEnvelope(response: MarkCreateOkResponse(annotationId: AnnotationId("ann-1"))))
    case Operations.gatherRequested.request.name:
      let request = try decoded(GatherAnnotationRequest.self, .object(payload))
      return try wirePayload(
        GatherAnnotationComplete(annotationId: request.annotationId, response: contextFixture()))
    case Operations.gatherResourceRequested.request.name:
      let request = try decoded(GatherResourceRequest.self, .object(payload))
      return try wirePayload(
        GatherResourceComplete(resourceId: request.resourceId, response: contextFixture()))
    case Operations.matchSearchRequested.request.name:
      let request = try decoded(MatchSearchRequest.self, .object(payload))
      return try wirePayload(MatchSearchResult(referenceId: request.referenceId, response: []))
    case Operations.yieldCloneResourceRequested.request.name,
      Operations.yieldCloneTokenRequested.request.name:
      guard case .resource(let focus) = try contextFixture().focus else {
        throw SpecFailure.shape("resource focus")
      }
      if name == Operations.yieldCloneTokenRequested.request.name {
        return try wirePayload(
          ResponseEnvelope(
            response: CloneResourceWithTokenResponse(
              token: "token", expiresAt: "2030-01-01T00:00:00Z", resource: focus.resource)))
      }
      if let cloneAnswer {
        return try wirePayload(
          ResponseEnvelope(response: decoded(GetResourceByTokenResponse.self, cloneAnswer)))
      }
      return try wirePayload(
        ResponseEnvelope(
          response: GetResourceByTokenResponse(
            sourceResource: focus.resource, expiresAt: "2030-01-01T00:00:00Z")))
    case Operations.frameAddEntityType.request.name, Operations.frameAddTagSchema.request.name,
      Operations.markArchive.request.name, Operations.markUnarchive.request.name,
      Operations.markUpdateEntityTypes.request.name:
      return try wirePayload(BusEmptyPayload())
    case Operations.bindUpdateBody.request.name:
      return try wirePayload(BindBodyUpdated())
    default: throw SpecFailure.shape("Unscripted surface operation: \(name)")
    }
  }
}

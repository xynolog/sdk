// Generated from protocol/specs/src/bus/registry.json; do not edit.
// Regenerate: make generate (codegen/lib/bus/kotlin.ml)

package xynolog.channels

import xynolog.Generated
import xynolog.types.BeckonFocusEvent
import xynolog.types.BeckonHoverEvent
import xynolog.types.BeckonSparkleEvent
import xynolog.types.BindBodyUpdated
import xynolog.types.BindInitiateCommand
import xynolog.types.BindUpdateBodyCommand
import xynolog.types.BrowseAnnotationHistoryRequest
import xynolog.types.BrowseAnnotationHistoryResult
import xynolog.types.BrowseAnnotationRequest
import xynolog.types.BrowseAnnotationResult
import xynolog.types.BrowseClickEvent
import xynolog.types.BrowseDirectoryFailed
import xynolog.types.BrowseDirectoryRequest
import xynolog.types.BrowseDirectoryResult
import xynolog.types.BrowseEnginesRequest
import xynolog.types.BrowseEnginesResult
import xynolog.types.BrowseEntityTypeClickedEvent
import xynolog.types.BrowseEntityTypesRequest
import xynolog.types.BrowseEntityTypesResult
import xynolog.types.BrowseEventsRequest
import xynolog.types.BrowseEventsResult
import xynolog.types.BrowseExternalNavigateEvent
import xynolog.types.BrowseKbRequest
import xynolog.types.BrowseKbResult
import xynolog.types.BrowseLinkClickedEvent
import xynolog.types.BrowsePanelOpenEvent
import xynolog.types.BrowsePanelToggleEvent
import xynolog.types.BrowseProfilesRequest
import xynolog.types.BrowseProfilesResult
import xynolog.types.BrowseResourceCloseEvent
import xynolog.types.BrowseResourceOpenEvent
import xynolog.types.BrowseResourceReorderEvent
import xynolog.types.BrowseResourceRequest
import xynolog.types.BrowseResourceResult
import xynolog.types.BrowseResourceViewedEvent
import xynolog.types.BrowseResourcesRequest
import xynolog.types.BrowseResourcesResult
import xynolog.types.BrowseRouterPushEvent
import xynolog.types.BrowseTagSchemasRequest
import xynolog.types.BrowseTagSchemasResult
import xynolog.types.BusResumeGap
import xynolog.types.CloneResourceWithTokenResponse
import xynolog.types.CommandError
import xynolog.types.ContextualSummaryResponse
import xynolog.types.EmptyObject
import xynolog.types.EnrichedResourceEvent
import xynolog.types.FrameAddEntityTypeCommand
import xynolog.types.FrameAddTagSchemaCommand
import xynolog.types.GatherAnnotationComplete
import xynolog.types.GatherAnnotationRequest
import xynolog.types.GatherFailed
import xynolog.types.GatherReferencedByRequest
import xynolog.types.GatherReferencedByResult
import xynolog.types.GatherResourceComplete
import xynolog.types.GatherResourceFailed
import xynolog.types.GatherResourceRequest
import xynolog.types.GatherSummaryRequest
import xynolog.types.GetResourceByTokenResponse
import xynolog.types.InferenceLimitsRequest
import xynolog.types.InferenceLimitsResult
import xynolog.types.JobAssignCommand
import xynolog.types.JobCancelCommand
import xynolog.types.JobCancelRequest
import xynolog.types.JobCancelResult
import xynolog.types.JobCheckpointCommand
import xynolog.types.JobClaimCommand
import xynolog.types.JobClaimedResult
import xynolog.types.JobCompleteCommand
import xynolog.types.JobCreateCommand
import xynolog.types.JobCreatedResult
import xynolog.types.JobFailCommand
import xynolog.types.JobQueuedEvent
import xynolog.types.JobReportProgressCommand
import xynolog.types.JobStartCommand
import xynolog.types.JobStatusRequest
import xynolog.types.JobStatusResult
import xynolog.types.MarkArchiveCommand
import xynolog.types.MarkCommitCommand
import xynolog.types.MarkCommitOk
import xynolog.types.MarkCreateOk
import xynolog.types.MarkCreateRequest
import xynolog.types.MarkDelegateTimeoutEvent
import xynolog.types.MarkDeleteCommand
import xynolog.types.MarkDeleteOk
import xynolog.types.MarkRequestedEvent
import xynolog.types.MarkSubmitEvent
import xynolog.types.MarkUnarchiveCommand
import xynolog.types.MarkUpdateBodyCommand
import xynolog.types.MarkUpdateEntityTypesCommand
import xynolog.types.MatchResourcesRequest
import xynolog.types.MatchResourcesResult
import xynolog.types.MatchSearchFailed
import xynolog.types.MatchSearchRequest
import xynolog.types.MatchSearchResult
import xynolog.types.PrincipalProfileCommand
import xynolog.types.ResourceErrorEvent
import xynolog.types.SessionJoinedEvent
import xynolog.types.SessionLeftEvent
import xynolog.types.SettingsHoverDelayChangedEvent
import xynolog.types.SettingsLocaleChangedEvent
import xynolog.types.SettingsThemeChangedEvent
import xynolog.types.SmeltRebuildAnchorsCommand
import xynolog.types.SmeltSettled
import xynolog.types.StoredEventResponse
import xynolog.types.WeaveApplied
import xynolog.types.WeaveRebuildCommand
import xynolog.types.YieldCloneCreateCommand
import xynolog.types.YieldCloneCreated
import xynolog.types.YieldClonePersistCommand
import xynolog.types.YieldClonePersistOk
import xynolog.types.YieldCloneResourceRequest
import xynolog.types.YieldCloneTokenRequest
import xynolog.types.YieldCreateCommand
import xynolog.types.YieldCreateOk
import xynolog.types.YieldUpdateCommand
import xynolog.types.YieldUpdateOk

/**
 * The field of a relayed frame's payload its trace rides in (the bus registry's `trace`).
 */
@Generated
public const val TRACE_FIELD: String = "_trace"

/**
 * The member a gateway stamps a payload's emitter under: no part of what was asked.
 */
@Generated
internal const val USER_FIELD: String = "_userId"

/** Every channel of the bus, by name, each typed by the payload a frame on it carries; a channel a resource's scope carries is a `ScopedChannel`. */
@Generated
public object Channels {
    @JvmField
    public val YIELD_CREATED: Channel<StoredEventResponse> = Channel("yield:created", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONED: Channel<StoredEventResponse> = Channel("yield:cloned", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_UPDATED: Channel<StoredEventResponse> = Channel("yield:updated", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_MOVED: Channel<StoredEventResponse> = Channel("yield:moved", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_REPRESENTATION_ADDED: ScopedChannel<StoredEventResponse> = ScopedChannel("yield:representation-added", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_REPRESENTATION_REMOVED: ScopedChannel<StoredEventResponse> = ScopedChannel("yield:representation-removed", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val YIELD_CREATE: Channel<YieldCreateCommand> = Channel("yield:create", YieldCreateCommand.serializer(), setOf("_roles", "_userId"))

    @JvmField
    public val YIELD_CLONE_PERSIST: Channel<YieldClonePersistCommand> = Channel("yield:clone-persist", YieldClonePersistCommand.serializer(), setOf("_userId"))

    @JvmField
    public val YIELD_UPDATE: Channel<YieldUpdateCommand> = Channel("yield:update", YieldUpdateCommand.serializer(), setOf("_userId"))

    @JvmField
    public val YIELD_CLONE: Channel<EmptyObject> = Channel("yield:clone", EmptyObject.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_TOKEN_REQUESTED: Channel<YieldCloneTokenRequest> = Channel("yield:clone-token-requested", YieldCloneTokenRequest.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_RESOURCE_REQUESTED: Channel<YieldCloneResourceRequest> = Channel("yield:clone-resource-requested", YieldCloneResourceRequest.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_CREATE: Channel<YieldCloneCreateCommand> = Channel("yield:clone-create", YieldCloneCreateCommand.serializer(), setOf("_userId"))

    @JvmField
    public val YIELD_CREATE_OK: Channel<YieldCreateOk> = Channel("yield:create-ok", YieldCreateOk.serializer(), emptySet())

    @JvmField
    public val YIELD_CREATE_FAILED: Channel<CommandError> = Channel("yield:create-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_PERSIST_OK: Channel<YieldClonePersistOk> = Channel("yield:clone-persist-ok", YieldClonePersistOk.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_PERSIST_FAILED: Channel<CommandError> = Channel("yield:clone-persist-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val YIELD_UPDATE_OK: Channel<YieldUpdateOk> = Channel("yield:update-ok", YieldUpdateOk.serializer(), emptySet())

    @JvmField
    public val YIELD_UPDATE_FAILED: Channel<CommandError> = Channel("yield:update-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_TOKEN_GENERATED: Channel<Response<CloneResourceWithTokenResponse>> = Channel("yield:clone-token-generated", Response.serializer(CloneResourceWithTokenResponse.serializer()), emptySet())

    @JvmField
    public val YIELD_CLONE_TOKEN_FAILED: Channel<CommandError> = Channel("yield:clone-token-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_RESOURCE_RESULT: Channel<Response<GetResourceByTokenResponse>> = Channel("yield:clone-resource-result", Response.serializer(GetResourceByTokenResponse.serializer()), emptySet())

    @JvmField
    public val YIELD_CLONE_RESOURCE_FAILED: Channel<CommandError> = Channel("yield:clone-resource-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_CREATED: Channel<YieldCloneCreated> = Channel("yield:clone-created", YieldCloneCreated.serializer(), emptySet())

    @JvmField
    public val YIELD_CLONE_CREATE_FAILED: Channel<CommandError> = Channel("yield:clone-create-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_ADDED: ScopedChannel<EnrichedResourceEvent> = ScopedChannel("mark:added", EnrichedResourceEvent.serializer(), emptySet())

    @JvmField
    public val MARK_REMOVED: ScopedChannel<StoredEventResponse> = ScopedChannel("mark:removed", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val MARK_BODY_UPDATED: ScopedChannel<EnrichedResourceEvent> = ScopedChannel("mark:body-updated", EnrichedResourceEvent.serializer(), emptySet())

    @JvmField
    public val MARK_ENTITY_TAG_ADDED: ScopedChannel<StoredEventResponse> = ScopedChannel("mark:entity-tag-added", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val MARK_ENTITY_TAG_REMOVED: ScopedChannel<StoredEventResponse> = ScopedChannel("mark:entity-tag-removed", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val MARK_ARCHIVED: ScopedChannel<StoredEventResponse> = ScopedChannel("mark:archived", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val MARK_UNARCHIVED: ScopedChannel<StoredEventResponse> = ScopedChannel("mark:unarchived", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val MARK_CREATE_REQUEST: Channel<MarkCreateRequest> = Channel("mark:create-request", MarkCreateRequest.serializer(), emptySet())

    @JvmField
    public val MARK_DELETE: Channel<MarkDeleteCommand> = Channel("mark:delete", MarkDeleteCommand.serializer(), setOf("_userId"))

    @JvmField
    public val MARK_UPDATE_BODY: Channel<MarkUpdateBodyCommand> = Channel("mark:update-body", MarkUpdateBodyCommand.serializer(), setOf("_userId"))

    @JvmField
    public val MARK_ARCHIVE: Channel<MarkArchiveCommand> = Channel("mark:archive", MarkArchiveCommand.serializer(), setOf("_userId"))

    @JvmField
    public val MARK_UNARCHIVE: Channel<MarkUnarchiveCommand> = Channel("mark:unarchive", MarkUnarchiveCommand.serializer(), setOf("_userId"))

    @JvmField
    public val MARK_UPDATE_ENTITY_TYPES: Channel<MarkUpdateEntityTypesCommand> = Channel("mark:update-entity-types", MarkUpdateEntityTypesCommand.serializer(), setOf("_userId"))

    @JvmField
    public val MARK_CREATE_OK: Channel<MarkCreateOk> = Channel("mark:create-ok", MarkCreateOk.serializer(), emptySet())

    @JvmField
    public val MARK_CREATE_FAILED: Channel<CommandError> = Channel("mark:create-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_COMMIT: Channel<MarkCommitCommand> = Channel("mark:commit", MarkCommitCommand.serializer(), setOf("_roles", "_userId"))

    @JvmField
    public val MARK_COMMIT_OK: Channel<MarkCommitOk> = Channel("mark:commit-ok", MarkCommitOk.serializer(), emptySet())

    @JvmField
    public val MARK_COMMIT_FAILED: Channel<CommandError> = Channel("mark:commit-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_DELETE_OK: Channel<MarkDeleteOk> = Channel("mark:delete-ok", MarkDeleteOk.serializer(), emptySet())

    @JvmField
    public val MARK_DELETE_FAILED: Channel<CommandError> = Channel("mark:delete-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_ARCHIVE_OK: Channel<EmptyObject> = Channel("mark:archive-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val MARK_ARCHIVE_FAILED: Channel<CommandError> = Channel("mark:archive-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_UNARCHIVE_OK: Channel<EmptyObject> = Channel("mark:unarchive-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val MARK_UNARCHIVE_FAILED: Channel<CommandError> = Channel("mark:unarchive-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_UPDATE_ENTITY_TYPES_OK: Channel<EmptyObject> = Channel("mark:update-entity-types-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val MARK_UPDATE_ENTITY_TYPES_FAILED: Channel<CommandError> = Channel("mark:update-entity-types-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_BODY_UPDATE_FAILED: Channel<CommandError> = Channel("mark:body-update-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MARK_REQUESTED: Channel<MarkRequestedEvent> = Channel("mark:requested", MarkRequestedEvent.serializer(), emptySet())

    @JvmField
    public val MARK_SUBMIT: Channel<MarkSubmitEvent> = Channel("mark:submit", MarkSubmitEvent.serializer(), emptySet())

    @JvmField
    public val MARK_DELEGATE_TIMEOUT: Channel<MarkDelegateTimeoutEvent> = Channel("mark:delegate-timeout", MarkDelegateTimeoutEvent.serializer(), emptySet())

    @JvmField
    public val MARK_CREATE_ERROR: Channel<ResourceErrorEvent> = Channel("mark:create-error", ResourceErrorEvent.serializer(), emptySet())

    @JvmField
    public val MARK_DELETE_ERROR: Channel<ResourceErrorEvent> = Channel("mark:delete-error", ResourceErrorEvent.serializer(), emptySet())

    @JvmField
    public val BIND_BODY_ERROR: Channel<ResourceErrorEvent> = Channel("bind:body-error", ResourceErrorEvent.serializer(), emptySet())

    @JvmField
    public val FRAME_ENTITY_TYPE_ADDED: Channel<StoredEventResponse> = Channel("frame:entity-type-added", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val FRAME_TAG_SCHEMA_ADDED: Channel<StoredEventResponse> = Channel("frame:tag-schema-added", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val FRAME_ADD_ENTITY_TYPE: Channel<FrameAddEntityTypeCommand> = Channel("frame:add-entity-type", FrameAddEntityTypeCommand.serializer(), setOf("_userId"))

    @JvmField
    public val FRAME_ADD_TAG_SCHEMA: Channel<FrameAddTagSchemaCommand> = Channel("frame:add-tag-schema", FrameAddTagSchemaCommand.serializer(), setOf("_userId"))

    @JvmField
    public val FRAME_ENTITY_TYPE_ADD_OK: Channel<EmptyObject> = Channel("frame:entity-type-add-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val FRAME_ENTITY_TYPE_ADD_FAILED: Channel<CommandError> = Channel("frame:entity-type-add-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val FRAME_TAG_SCHEMA_ADD_OK: Channel<EmptyObject> = Channel("frame:tag-schema-add-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val FRAME_TAG_SCHEMA_ADD_FAILED: Channel<CommandError> = Channel("frame:tag-schema-add-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val PRINCIPAL_PROFILED: Channel<StoredEventResponse> = Channel("principal:profiled", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val PRINCIPAL_PROFILE: Channel<PrincipalProfileCommand> = Channel("principal:profile", PrincipalProfileCommand.serializer(), setOf("_userId"))

    @JvmField
    public val BIND_INITIATE: Channel<BindInitiateCommand> = Channel("bind:initiate", BindInitiateCommand.serializer(), emptySet())

    @JvmField
    public val BIND_UPDATE_BODY: Channel<BindUpdateBodyCommand> = Channel("bind:update-body", BindUpdateBodyCommand.serializer(), setOf("_userId"))

    @JvmField
    public val BIND_BODY_UPDATED: Channel<BindBodyUpdated> = Channel("bind:body-updated", BindBodyUpdated.serializer(), emptySet())

    @JvmField
    public val BIND_BODY_UPDATE_FAILED: Channel<CommandError> = Channel("bind:body-update-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MATCH_SEARCH_REQUESTED: Channel<MatchSearchRequest> = Channel("match:search-requested", MatchSearchRequest.serializer(), emptySet())

    @JvmField
    public val MATCH_SEARCH_RESULTS: Channel<MatchSearchResult> = Channel("match:search-results", MatchSearchResult.serializer(), emptySet())

    @JvmField
    public val MATCH_SEARCH_FAILED: Channel<MatchSearchFailed> = Channel("match:search-failed", MatchSearchFailed.serializer(), emptySet())

    @JvmField
    public val MATCH_RESOURCES_REQUESTED: Channel<MatchResourcesRequest> = Channel("match:resources-requested", MatchResourcesRequest.serializer(), emptySet())

    @JvmField
    public val MATCH_RESOURCES_RESULT: Channel<MatchResourcesResult> = Channel("match:resources-result", MatchResourcesResult.serializer(), emptySet())

    @JvmField
    public val MATCH_RESOURCES_FAILED: Channel<CommandError> = Channel("match:resources-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val MATCH_LIMITS_REQUESTED: Channel<InferenceLimitsRequest> = Channel("match:limits-requested", InferenceLimitsRequest.serializer(), emptySet())

    @JvmField
    public val MATCH_LIMITS_RESULT: Channel<InferenceLimitsResult> = Channel("match:limits-result", InferenceLimitsResult.serializer(), emptySet())

    @JvmField
    public val MATCH_LIMITS_FAILED: Channel<CommandError> = Channel("match:limits-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val GATHER_REQUESTED: Channel<GatherAnnotationRequest> = Channel("gather:requested", GatherAnnotationRequest.serializer(), emptySet())

    @JvmField
    public val GATHER_COMPLETE: Channel<GatherAnnotationComplete> = Channel("gather:complete", GatherAnnotationComplete.serializer(), emptySet())

    @JvmField
    public val GATHER_FAILED: Channel<GatherFailed> = Channel("gather:failed", GatherFailed.serializer(), emptySet())

    @JvmField
    public val GATHER_RESOURCE_REQUESTED: Channel<GatherResourceRequest> = Channel("gather:resource-requested", GatherResourceRequest.serializer(), emptySet())

    @JvmField
    public val GATHER_RESOURCE_COMPLETE: Channel<GatherResourceComplete> = Channel("gather:resource-complete", GatherResourceComplete.serializer(), emptySet())

    @JvmField
    public val GATHER_RESOURCE_FAILED: Channel<GatherResourceFailed> = Channel("gather:resource-failed", GatherResourceFailed.serializer(), emptySet())

    @JvmField
    public val GATHER_SUMMARY_REQUESTED: Channel<GatherSummaryRequest> = Channel("gather:summary-requested", GatherSummaryRequest.serializer(), emptySet())

    @JvmField
    public val GATHER_SUMMARY_RESULT: Channel<Response<ContextualSummaryResponse>> = Channel("gather:summary-result", Response.serializer(ContextualSummaryResponse.serializer()), emptySet())

    @JvmField
    public val GATHER_SUMMARY_FAILED: Channel<CommandError> = Channel("gather:summary-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val GATHER_REFERENCED_BY_REQUESTED: Channel<GatherReferencedByRequest> = Channel("gather:referenced-by-requested", GatherReferencedByRequest.serializer(), emptySet())

    @JvmField
    public val GATHER_REFERENCED_BY_RESULT: Channel<GatherReferencedByResult> = Channel("gather:referenced-by-result", GatherReferencedByResult.serializer(), emptySet())

    @JvmField
    public val GATHER_REFERENCED_BY_FAILED: Channel<CommandError> = Channel("gather:referenced-by-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val GATHER_LIMITS_REQUESTED: Channel<InferenceLimitsRequest> = Channel("gather:limits-requested", InferenceLimitsRequest.serializer(), emptySet())

    @JvmField
    public val GATHER_LIMITS_RESULT: Channel<InferenceLimitsResult> = Channel("gather:limits-result", InferenceLimitsResult.serializer(), emptySet())

    @JvmField
    public val GATHER_LIMITS_FAILED: Channel<CommandError> = Channel("gather:limits-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCE_REQUESTED: Channel<BrowseResourceRequest> = Channel("browse:resource-requested", BrowseResourceRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCE_RESULT: Channel<BrowseResourceResult> = Channel("browse:resource-result", BrowseResourceResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCE_FAILED: Channel<CommandError> = Channel("browse:resource-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCES_REQUESTED: Channel<BrowseResourcesRequest> = Channel("browse:resources-requested", BrowseResourcesRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCES_RESULT: Channel<BrowseResourcesResult> = Channel("browse:resources-result", BrowseResourcesResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCES_FAILED: Channel<CommandError> = Channel("browse:resources-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_REQUESTED: Channel<BrowseAnnotationRequest> = Channel("browse:annotation-requested", BrowseAnnotationRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_RESULT: Channel<BrowseAnnotationResult> = Channel("browse:annotation-result", BrowseAnnotationResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_FAILED: Channel<CommandError> = Channel("browse:annotation-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_EVENTS_REQUESTED: Channel<BrowseEventsRequest> = Channel("browse:events-requested", BrowseEventsRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_EVENTS_RESULT: Channel<BrowseEventsResult> = Channel("browse:events-result", BrowseEventsResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_EVENTS_FAILED: Channel<CommandError> = Channel("browse:events-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_HISTORY_REQUESTED: Channel<BrowseAnnotationHistoryRequest> = Channel("browse:annotation-history-requested", BrowseAnnotationHistoryRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_HISTORY_RESULT: Channel<BrowseAnnotationHistoryResult> = Channel("browse:annotation-history-result", BrowseAnnotationHistoryResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_ANNOTATION_HISTORY_FAILED: Channel<CommandError> = Channel("browse:annotation-history-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENTITY_TYPES_REQUESTED: Channel<BrowseEntityTypesRequest> = Channel("browse:entity-types-requested", BrowseEntityTypesRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENTITY_TYPES_RESULT: Channel<BrowseEntityTypesResult> = Channel("browse:entity-types-result", BrowseEntityTypesResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENTITY_TYPES_FAILED: Channel<CommandError> = Channel("browse:entity-types-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_TAG_SCHEMAS_REQUESTED: Channel<BrowseTagSchemasRequest> = Channel("browse:tag-schemas-requested", BrowseTagSchemasRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_TAG_SCHEMAS_RESULT: Channel<BrowseTagSchemasResult> = Channel("browse:tag-schemas-result", BrowseTagSchemasResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_TAG_SCHEMAS_FAILED: Channel<CommandError> = Channel("browse:tag-schemas-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENGINES_REQUESTED: Channel<BrowseEnginesRequest> = Channel("browse:engines-requested", BrowseEnginesRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENGINES_RESULT: Channel<BrowseEnginesResult> = Channel("browse:engines-result", BrowseEnginesResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENGINES_FAILED: Channel<CommandError> = Channel("browse:engines-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_PROFILES_REQUESTED: Channel<BrowseProfilesRequest> = Channel("browse:profiles-requested", BrowseProfilesRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_PROFILES_RESULT: Channel<BrowseProfilesResult> = Channel("browse:profiles-result", BrowseProfilesResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_PROFILES_FAILED: Channel<CommandError> = Channel("browse:profiles-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_KB_REQUESTED: Channel<BrowseKbRequest> = Channel("browse:kb-requested", BrowseKbRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_KB_RESULT: Channel<BrowseKbResult> = Channel("browse:kb-result", BrowseKbResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_KB_FAILED: Channel<CommandError> = Channel("browse:kb-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val BROWSE_DIRECTORY_REQUESTED: Channel<BrowseDirectoryRequest> = Channel("browse:directory-requested", BrowseDirectoryRequest.serializer(), emptySet())

    @JvmField
    public val BROWSE_DIRECTORY_RESULT: Channel<BrowseDirectoryResult> = Channel("browse:directory-result", BrowseDirectoryResult.serializer(), emptySet())

    @JvmField
    public val BROWSE_DIRECTORY_FAILED: Channel<BrowseDirectoryFailed> = Channel("browse:directory-failed", BrowseDirectoryFailed.serializer(), emptySet())

    @JvmField
    public val BROWSE_CLICK: Channel<BrowseClickEvent> = Channel("browse:click", BrowseClickEvent.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCE_OPEN: Channel<BrowseResourceOpenEvent> = Channel("browse:resource-open", BrowseResourceOpenEvent.serializer(), emptySet())

    @JvmField
    public val BROWSE_RESOURCE_VIEWED: Channel<BrowseResourceViewedEvent> = Channel("browse:resource-viewed", BrowseResourceViewedEvent.serializer(), emptySet())

    @JvmField
    public val BROWSE_ENTITY_TYPE_CLICKED: Channel<BrowseEntityTypeClickedEvent> = Channel("browse:entity-type-clicked", BrowseEntityTypeClickedEvent.serializer(), emptySet())

    @JvmField
    public val PANEL_TOGGLE: Channel<BrowsePanelToggleEvent> = Channel("panel:toggle", BrowsePanelToggleEvent.serializer(), emptySet())

    @JvmField
    public val PANEL_OPEN: Channel<BrowsePanelOpenEvent> = Channel("panel:open", BrowsePanelOpenEvent.serializer(), emptySet())

    @JvmField
    public val PANEL_CLOSE: Channel<EmptyObject> = Channel("panel:close", EmptyObject.serializer(), emptySet())

    @JvmField
    public val SHELL_SIDEBAR_TOGGLE: Channel<EmptyObject> = Channel("shell:sidebar-toggle", EmptyObject.serializer(), emptySet())

    @JvmField
    public val TABS_CLOSE: Channel<BrowseResourceCloseEvent> = Channel("tabs:close", BrowseResourceCloseEvent.serializer(), emptySet())

    @JvmField
    public val TABS_REORDER: Channel<BrowseResourceReorderEvent> = Channel("tabs:reorder", BrowseResourceReorderEvent.serializer(), emptySet())

    @JvmField
    public val NAV_LINK_CLICKED: Channel<BrowseLinkClickedEvent> = Channel("nav:link-clicked", BrowseLinkClickedEvent.serializer(), emptySet())

    @JvmField
    public val NAV_PUSH: Channel<BrowseRouterPushEvent> = Channel("nav:push", BrowseRouterPushEvent.serializer(), emptySet())

    @JvmField
    public val NAV_EXTERNAL: Channel<BrowseExternalNavigateEvent> = Channel("nav:external", BrowseExternalNavigateEvent.serializer(), emptySet())

    @JvmField
    public val BECKON_HOVER: Channel<BeckonHoverEvent> = Channel("beckon:hover", BeckonHoverEvent.serializer(), emptySet())

    @JvmField
    public val BECKON_FOCUS: Channel<BeckonFocusEvent> = Channel("beckon:focus", BeckonFocusEvent.serializer(), emptySet())

    @JvmField
    public val BECKON_SPARKLE: Channel<BeckonSparkleEvent> = Channel("beckon:sparkle", BeckonSparkleEvent.serializer(), emptySet())

    @JvmField
    public val JOB_STARTED: ScopedChannel<StoredEventResponse> = ScopedChannel("job:started", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val JOB_ASSIGNED: ScopedChannel<StoredEventResponse> = ScopedChannel("job:assigned", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val JOB_COMPLETED: ScopedChannel<StoredEventResponse> = ScopedChannel("job:completed", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val JOB_FAILED: ScopedChannel<StoredEventResponse> = ScopedChannel("job:failed", StoredEventResponse.serializer(), emptySet())

    @JvmField
    public val JOB_START: Channel<JobStartCommand> = Channel("job:start", JobStartCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_ASSIGN: Channel<JobAssignCommand> = Channel("job:assign", JobAssignCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_REPORT_PROGRESS: Channel<JobReportProgressCommand> = Channel("job:report-progress", JobReportProgressCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_COMPLETE: Channel<JobCompleteCommand> = Channel("job:complete", JobCompleteCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_FAIL: Channel<JobFailCommand> = Channel("job:fail", JobFailCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_CHECKPOINT: Channel<JobCheckpointCommand> = Channel("job:checkpoint", JobCheckpointCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_QUEUED: Channel<JobQueuedEvent> = Channel("job:queued", JobQueuedEvent.serializer(), emptySet())

    @JvmField
    public val JOB_CANCEL_REQUESTED: Channel<JobCancelRequest> = Channel("job:cancel-requested", JobCancelRequest.serializer(), emptySet())

    @JvmField
    public val JOB_CANCEL: Channel<JobCancelCommand> = Channel("job:cancel", JobCancelCommand.serializer(), setOf("_userId"))

    @JvmField
    public val JOB_LIMITS_REQUESTED: Channel<InferenceLimitsRequest> = Channel("job:limits-requested", InferenceLimitsRequest.serializer(), emptySet())

    @JvmField
    public val JOB_LIMITS_RESULT: Channel<InferenceLimitsResult> = Channel("job:limits-result", InferenceLimitsResult.serializer(), emptySet())

    @JvmField
    public val JOB_LIMITS_FAILED: Channel<CommandError> = Channel("job:limits-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val JOB_STATUS_REQUESTED: Channel<JobStatusRequest> = Channel("job:status-requested", JobStatusRequest.serializer(), emptySet())

    @JvmField
    public val JOB_CREATE: Channel<JobCreateCommand> = Channel("job:create", JobCreateCommand.serializer(), setOf("_roles", "_userId"))

    @JvmField
    public val JOB_CLAIM: Channel<JobClaimCommand> = Channel("job:claim", JobClaimCommand.serializer(), setOf("_roles", "_userId"))

    @JvmField
    public val JOB_STATUS_RESULT: Channel<JobStatusResult> = Channel("job:status-result", JobStatusResult.serializer(), emptySet())

    @JvmField
    public val JOB_STATUS_FAILED: Channel<CommandError> = Channel("job:status-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val JOB_CREATED: Channel<JobCreatedResult> = Channel("job:created", JobCreatedResult.serializer(), emptySet())

    @JvmField
    public val JOB_CREATE_FAILED: Channel<CommandError> = Channel("job:create-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val JOB_CLAIMED: Channel<JobClaimedResult> = Channel("job:claimed", JobClaimedResult.serializer(), emptySet())

    @JvmField
    public val JOB_CLAIM_FAILED: Channel<CommandError> = Channel("job:claim-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val JOB_CANCEL_OK: Channel<Response<JobCancelResult>> = Channel("job:cancel-ok", Response.serializer(JobCancelResult.serializer()), emptySet())

    @JvmField
    public val JOB_CANCEL_FAILED: Channel<CommandError> = Channel("job:cancel-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val WEAVE_APPLIED: Channel<WeaveApplied> = Channel("weave:applied", WeaveApplied.serializer(), emptySet())

    @JvmField
    public val SMELT_SETTLED: Channel<SmeltSettled> = Channel("smelt:settled", SmeltSettled.serializer(), emptySet())

    @JvmField
    public val WEAVE_REBUILD: Channel<WeaveRebuildCommand> = Channel("weave:rebuild", WeaveRebuildCommand.serializer(), setOf("_userId"))

    @JvmField
    public val WEAVE_REBUILD_OK: Channel<EmptyObject> = Channel("weave:rebuild-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val WEAVE_REBUILD_FAILED: Channel<CommandError> = Channel("weave:rebuild-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val SMELT_REBUILD_ANCHORS: Channel<SmeltRebuildAnchorsCommand> = Channel("smelt:rebuild-anchors", SmeltRebuildAnchorsCommand.serializer(), setOf("_userId"))

    @JvmField
    public val SMELT_REBUILD_ANCHORS_OK: Channel<EmptyObject> = Channel("smelt:rebuild-anchors-ok", EmptyObject.serializer(), emptySet())

    @JvmField
    public val SMELT_REBUILD_ANCHORS_FAILED: Channel<CommandError> = Channel("smelt:rebuild-anchors-failed", CommandError.serializer(), emptySet())

    @JvmField
    public val SETTINGS_THEME_CHANGED: Channel<SettingsThemeChangedEvent> = Channel("settings:theme-changed", SettingsThemeChangedEvent.serializer(), emptySet())

    @JvmField
    public val SETTINGS_LINE_NUMBERS_TOGGLED: Channel<EmptyObject> = Channel("settings:line-numbers-toggled", EmptyObject.serializer(), emptySet())

    @JvmField
    public val SETTINGS_LOCALE_CHANGED: Channel<SettingsLocaleChangedEvent> = Channel("settings:locale-changed", SettingsLocaleChangedEvent.serializer(), emptySet())

    @JvmField
    public val SETTINGS_HOVER_DELAY_CHANGED: Channel<SettingsHoverDelayChangedEvent> = Channel("settings:hover-delay-changed", SettingsHoverDelayChangedEvent.serializer(), emptySet())

    @JvmField
    public val BUS_RESUME_GAP: Channel<BusResumeGap> = Channel("bus:resume-gap", BusResumeGap.serializer(), emptySet())

    @JvmField
    public val SESSION_JOINED: Channel<SessionJoinedEvent> = Channel("session:joined", SessionJoinedEvent.serializer(), emptySet())

    @JvmField
    public val SESSION_LEFT: Channel<SessionLeftEvent> = Channel("session:left", SessionLeftEvent.serializer(), emptySet())
}

/** Every channel's name, in the registry's order. */
@Generated
public val CHANNEL_NAMES: List<String> = listOf("yield:created", "yield:cloned", "yield:updated", "yield:moved", "yield:representation-added", "yield:representation-removed", "yield:create", "yield:clone-persist", "yield:update", "yield:clone", "yield:clone-token-requested", "yield:clone-resource-requested", "yield:clone-create", "yield:create-ok", "yield:create-failed", "yield:clone-persist-ok", "yield:clone-persist-failed", "yield:update-ok", "yield:update-failed", "yield:clone-token-generated", "yield:clone-token-failed", "yield:clone-resource-result", "yield:clone-resource-failed", "yield:clone-created", "yield:clone-create-failed", "mark:added", "mark:removed", "mark:body-updated", "mark:entity-tag-added", "mark:entity-tag-removed", "mark:archived", "mark:unarchived", "mark:create-request", "mark:delete", "mark:update-body", "mark:archive", "mark:unarchive", "mark:update-entity-types", "mark:create-ok", "mark:create-failed", "mark:commit", "mark:commit-ok", "mark:commit-failed", "mark:delete-ok", "mark:delete-failed", "mark:archive-ok", "mark:archive-failed", "mark:unarchive-ok", "mark:unarchive-failed", "mark:update-entity-types-ok", "mark:update-entity-types-failed", "mark:body-update-failed", "mark:requested", "mark:submit", "mark:delegate-timeout", "mark:create-error", "mark:delete-error", "bind:body-error", "frame:entity-type-added", "frame:tag-schema-added", "frame:add-entity-type", "frame:add-tag-schema", "frame:entity-type-add-ok", "frame:entity-type-add-failed", "frame:tag-schema-add-ok", "frame:tag-schema-add-failed", "principal:profiled", "principal:profile", "bind:initiate", "bind:update-body", "bind:body-updated", "bind:body-update-failed", "match:search-requested", "match:search-results", "match:search-failed", "match:resources-requested", "match:resources-result", "match:resources-failed", "match:limits-requested", "match:limits-result", "match:limits-failed", "gather:requested", "gather:complete", "gather:failed", "gather:resource-requested", "gather:resource-complete", "gather:resource-failed", "gather:summary-requested", "gather:summary-result", "gather:summary-failed", "gather:referenced-by-requested", "gather:referenced-by-result", "gather:referenced-by-failed", "gather:limits-requested", "gather:limits-result", "gather:limits-failed", "browse:resource-requested", "browse:resource-result", "browse:resource-failed", "browse:resources-requested", "browse:resources-result", "browse:resources-failed", "browse:annotation-requested", "browse:annotation-result", "browse:annotation-failed", "browse:events-requested", "browse:events-result", "browse:events-failed", "browse:annotation-history-requested", "browse:annotation-history-result", "browse:annotation-history-failed", "browse:entity-types-requested", "browse:entity-types-result", "browse:entity-types-failed", "browse:tag-schemas-requested", "browse:tag-schemas-result", "browse:tag-schemas-failed", "browse:engines-requested", "browse:engines-result", "browse:engines-failed", "browse:profiles-requested", "browse:profiles-result", "browse:profiles-failed", "browse:kb-requested", "browse:kb-result", "browse:kb-failed", "browse:directory-requested", "browse:directory-result", "browse:directory-failed", "browse:click", "browse:resource-open", "browse:resource-viewed", "browse:entity-type-clicked", "panel:toggle", "panel:open", "panel:close", "shell:sidebar-toggle", "tabs:close", "tabs:reorder", "nav:link-clicked", "nav:push", "nav:external", "beckon:hover", "beckon:focus", "beckon:sparkle", "job:started", "job:assigned", "job:completed", "job:failed", "job:start", "job:assign", "job:report-progress", "job:complete", "job:fail", "job:checkpoint", "job:queued", "job:cancel-requested", "job:cancel", "job:limits-requested", "job:limits-result", "job:limits-failed", "job:status-requested", "job:create", "job:claim", "job:status-result", "job:status-failed", "job:created", "job:create-failed", "job:claimed", "job:claim-failed", "job:cancel-ok", "job:cancel-failed", "weave:applied", "smelt:settled", "weave:rebuild", "weave:rebuild-ok", "weave:rebuild-failed", "smelt:rebuild-anchors", "smelt:rebuild-anchors-ok", "smelt:rebuild-anchors-failed", "settings:theme-changed", "settings:line-numbers-toggled", "settings:locale-changed", "settings:hover-delay-changed", "bus:resume-gap", "session:joined", "session:left")

/** What a full client gives its transport to name on no scope: the channels every client hears, and every operation's reply channels. */
@Generated
public val BRIDGED_CHANNELS: List<String> = listOf("job:report-progress", "job:complete", "job:fail", "smelt:settled", "frame:entity-type-added", "frame:tag-schema-added", "yield:created", "yield:updated", "yield:cloned", "yield:moved", "beckon:focus", "beckon:sparkle", "bus:resume-gap", "browse:resource-open", "browse:resource-viewed", "session:joined", "session:left", "browse:click", "bind:body-updated", "bind:body-update-failed", "browse:resource-result", "browse:resource-failed", "browse:resources-result", "browse:resources-failed", "browse:annotation-result", "browse:annotation-failed", "browse:annotation-history-result", "browse:annotation-history-failed", "browse:events-result", "browse:events-failed", "browse:entity-types-result", "browse:entity-types-failed", "browse:tag-schemas-result", "browse:tag-schemas-failed", "browse:engines-result", "browse:engines-failed", "browse:profiles-result", "browse:profiles-failed", "browse:kb-result", "browse:kb-failed", "browse:directory-result", "browse:directory-failed", "frame:entity-type-add-ok", "frame:entity-type-add-failed", "frame:tag-schema-add-ok", "frame:tag-schema-add-failed", "gather:complete", "gather:failed", "gather:resource-complete", "gather:resource-failed", "gather:summary-result", "gather:summary-failed", "gather:referenced-by-result", "gather:referenced-by-failed", "gather:limits-result", "gather:limits-failed", "job:created", "job:create-failed", "job:status-result", "job:status-failed", "job:limits-result", "job:limits-failed", "job:cancel-ok", "job:cancel-failed", "job:claimed", "job:claim-failed", "mark:create-ok", "mark:create-failed", "mark:commit-ok", "mark:commit-failed", "mark:delete-ok", "mark:delete-failed", "mark:archive-ok", "mark:archive-failed", "mark:unarchive-ok", "mark:unarchive-failed", "mark:update-entity-types-ok", "mark:update-entity-types-failed", "match:search-results", "match:search-failed", "match:resources-result", "match:resources-failed", "match:limits-result", "match:limits-failed", "weave:rebuild-ok", "weave:rebuild-failed", "smelt:rebuild-anchors-ok", "smelt:rebuild-anchors-failed", "yield:create-ok", "yield:create-failed", "yield:clone-persist-ok", "yield:clone-persist-failed", "yield:update-ok", "yield:update-failed", "yield:clone-created", "yield:clone-create-failed", "yield:clone-resource-result", "yield:clone-resource-failed", "yield:clone-token-generated", "yield:clone-token-failed")

/** The channels a resource's scope carries. */
@Generated
public val RESOURCE_SCOPED_CHANNELS: List<String> = listOf("mark:body-updated", "yield:representation-added", "yield:representation-removed", "mark:added", "mark:removed", "mark:entity-tag-added", "mark:entity-tag-removed", "mark:archived", "mark:unarchived", "job:started", "job:assigned", "job:completed", "job:failed")

/** The type of every event of the record. */
internal val PERSISTED: List<String> = listOf("yield:created", "yield:cloned", "yield:updated", "yield:moved", "yield:representation-added", "yield:representation-removed", "mark:added", "mark:removed", "mark:body-updated", "mark:entity-tag-added", "mark:entity-tag-removed", "mark:archived", "mark:unarchived", "frame:entity-type-added", "frame:tag-schema-added", "principal:profiled", "job:started", "job:assigned", "job:completed", "job:failed")

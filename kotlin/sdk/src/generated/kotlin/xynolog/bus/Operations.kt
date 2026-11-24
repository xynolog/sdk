// Generated from protocol/specs/src/bus/registry.json; do not edit.
// Regenerate: make generate (codegen/lib/bus/kotlin.ml)

package xynolog.bus

import xynolog.Generated
import xynolog.channels.Channels
import xynolog.channels.Response
import xynolog.types.BindBodyUpdated
import xynolog.types.BindUpdateBodyCommand
import xynolog.types.BrowseAnnotationHistoryRequest
import xynolog.types.BrowseAnnotationHistoryResult
import xynolog.types.BrowseAnnotationRequest
import xynolog.types.BrowseAnnotationResult
import xynolog.types.BrowseDirectoryFailed
import xynolog.types.BrowseDirectoryRequest
import xynolog.types.BrowseDirectoryResult
import xynolog.types.BrowseEnginesRequest
import xynolog.types.BrowseEnginesResult
import xynolog.types.BrowseEntityTypesRequest
import xynolog.types.BrowseEntityTypesResult
import xynolog.types.BrowseEventsRequest
import xynolog.types.BrowseEventsResult
import xynolog.types.BrowseKbRequest
import xynolog.types.BrowseKbResult
import xynolog.types.BrowseProfilesRequest
import xynolog.types.BrowseProfilesResult
import xynolog.types.BrowseResourceRequest
import xynolog.types.BrowseResourceResult
import xynolog.types.BrowseResourcesRequest
import xynolog.types.BrowseResourcesResult
import xynolog.types.BrowseTagSchemasRequest
import xynolog.types.BrowseTagSchemasResult
import xynolog.types.CloneResourceWithTokenResponse
import xynolog.types.CommandError
import xynolog.types.ContextualSummaryResponse
import xynolog.types.EmptyObject
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
import xynolog.types.JobCancelRequest
import xynolog.types.JobCancelResult
import xynolog.types.JobClaimCommand
import xynolog.types.JobClaimedResult
import xynolog.types.JobCreateCommand
import xynolog.types.JobCreatedResult
import xynolog.types.JobStatusRequest
import xynolog.types.JobStatusResult
import xynolog.types.MarkArchiveCommand
import xynolog.types.MarkCommitCommand
import xynolog.types.MarkCommitOk
import xynolog.types.MarkCreateOk
import xynolog.types.MarkCreateRequest
import xynolog.types.MarkDeleteCommand
import xynolog.types.MarkDeleteOk
import xynolog.types.MarkUnarchiveCommand
import xynolog.types.MarkUpdateEntityTypesCommand
import xynolog.types.MatchResourcesRequest
import xynolog.types.MatchResourcesResult
import xynolog.types.MatchSearchFailed
import xynolog.types.MatchSearchRequest
import xynolog.types.MatchSearchResult
import xynolog.types.SmeltRebuildAnchorsCommand
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

/** Every operation of the registry, named for its request's channel, each typed by what it sends and what each reply carries. */
@Generated
public object Operations {
    @JvmField
    public val BIND_UPDATE_BODY: Operation<BindUpdateBodyCommand, BindBodyUpdated, CommandError> =
        Operation(Channels.BIND_UPDATE_BODY, Channels.BIND_BODY_UPDATED, Channels.BIND_BODY_UPDATE_FAILED, emptyList())

    @JvmField
    public val BROWSE_RESOURCE_REQUESTED: Operation<BrowseResourceRequest, BrowseResourceResult, CommandError> =
        Operation(Channels.BROWSE_RESOURCE_REQUESTED, Channels.BROWSE_RESOURCE_RESULT, Channels.BROWSE_RESOURCE_FAILED, emptyList())

    @JvmField
    public val BROWSE_RESOURCES_REQUESTED: Operation<BrowseResourcesRequest, BrowseResourcesResult, CommandError> =
        Operation(Channels.BROWSE_RESOURCES_REQUESTED, Channels.BROWSE_RESOURCES_RESULT, Channels.BROWSE_RESOURCES_FAILED, emptyList())

    @JvmField
    public val BROWSE_ANNOTATION_REQUESTED: Operation<BrowseAnnotationRequest, BrowseAnnotationResult, CommandError> =
        Operation(Channels.BROWSE_ANNOTATION_REQUESTED, Channels.BROWSE_ANNOTATION_RESULT, Channels.BROWSE_ANNOTATION_FAILED, emptyList())

    @JvmField
    public val BROWSE_ANNOTATION_HISTORY_REQUESTED: Operation<BrowseAnnotationHistoryRequest, BrowseAnnotationHistoryResult, CommandError> =
        Operation(Channels.BROWSE_ANNOTATION_HISTORY_REQUESTED, Channels.BROWSE_ANNOTATION_HISTORY_RESULT, Channels.BROWSE_ANNOTATION_HISTORY_FAILED, emptyList())

    @JvmField
    public val BROWSE_EVENTS_REQUESTED: Operation<BrowseEventsRequest, BrowseEventsResult, CommandError> =
        Operation(Channels.BROWSE_EVENTS_REQUESTED, Channels.BROWSE_EVENTS_RESULT, Channels.BROWSE_EVENTS_FAILED, emptyList())

    @JvmField
    public val BROWSE_ENTITY_TYPES_REQUESTED: Operation<BrowseEntityTypesRequest, BrowseEntityTypesResult, CommandError> =
        Operation(Channels.BROWSE_ENTITY_TYPES_REQUESTED, Channels.BROWSE_ENTITY_TYPES_RESULT, Channels.BROWSE_ENTITY_TYPES_FAILED, emptyList())

    @JvmField
    public val BROWSE_TAG_SCHEMAS_REQUESTED: Operation<BrowseTagSchemasRequest, BrowseTagSchemasResult, CommandError> =
        Operation(Channels.BROWSE_TAG_SCHEMAS_REQUESTED, Channels.BROWSE_TAG_SCHEMAS_RESULT, Channels.BROWSE_TAG_SCHEMAS_FAILED, emptyList())

    @JvmField
    public val BROWSE_ENGINES_REQUESTED: Operation<BrowseEnginesRequest, BrowseEnginesResult, CommandError> =
        Operation(Channels.BROWSE_ENGINES_REQUESTED, Channels.BROWSE_ENGINES_RESULT, Channels.BROWSE_ENGINES_FAILED, emptyList())

    @JvmField
    public val BROWSE_PROFILES_REQUESTED: Operation<BrowseProfilesRequest, BrowseProfilesResult, CommandError> =
        Operation(Channels.BROWSE_PROFILES_REQUESTED, Channels.BROWSE_PROFILES_RESULT, Channels.BROWSE_PROFILES_FAILED, emptyList())

    @JvmField
    public val BROWSE_KB_REQUESTED: Operation<BrowseKbRequest, BrowseKbResult, CommandError> =
        Operation(Channels.BROWSE_KB_REQUESTED, Channels.BROWSE_KB_RESULT, Channels.BROWSE_KB_FAILED, emptyList())

    @JvmField
    public val BROWSE_DIRECTORY_REQUESTED: Operation<BrowseDirectoryRequest, BrowseDirectoryResult, BrowseDirectoryFailed> =
        Operation(Channels.BROWSE_DIRECTORY_REQUESTED, Channels.BROWSE_DIRECTORY_RESULT, Channels.BROWSE_DIRECTORY_FAILED, emptyList())

    @JvmField
    public val FRAME_ADD_ENTITY_TYPE: Operation<FrameAddEntityTypeCommand, EmptyObject, CommandError> =
        Operation(Channels.FRAME_ADD_ENTITY_TYPE, Channels.FRAME_ENTITY_TYPE_ADD_OK, Channels.FRAME_ENTITY_TYPE_ADD_FAILED, emptyList())

    @JvmField
    public val FRAME_ADD_TAG_SCHEMA: Operation<FrameAddTagSchemaCommand, EmptyObject, CommandError> =
        Operation(Channels.FRAME_ADD_TAG_SCHEMA, Channels.FRAME_TAG_SCHEMA_ADD_OK, Channels.FRAME_TAG_SCHEMA_ADD_FAILED, emptyList())

    @JvmField
    public val GATHER_REQUESTED: Operation<GatherAnnotationRequest, GatherAnnotationComplete, GatherFailed> =
        Operation(Channels.GATHER_REQUESTED, Channels.GATHER_COMPLETE, Channels.GATHER_FAILED, listOf("annotationId"))

    @JvmField
    public val GATHER_RESOURCE_REQUESTED: Operation<GatherResourceRequest, GatherResourceComplete, GatherResourceFailed> =
        Operation(Channels.GATHER_RESOURCE_REQUESTED, Channels.GATHER_RESOURCE_COMPLETE, Channels.GATHER_RESOURCE_FAILED, listOf("resourceId"))

    @JvmField
    public val GATHER_SUMMARY_REQUESTED: Operation<GatherSummaryRequest, Response<ContextualSummaryResponse>, CommandError> =
        Operation(Channels.GATHER_SUMMARY_REQUESTED, Channels.GATHER_SUMMARY_RESULT, Channels.GATHER_SUMMARY_FAILED, emptyList())

    @JvmField
    public val GATHER_REFERENCED_BY_REQUESTED: Operation<GatherReferencedByRequest, GatherReferencedByResult, CommandError> =
        Operation(Channels.GATHER_REFERENCED_BY_REQUESTED, Channels.GATHER_REFERENCED_BY_RESULT, Channels.GATHER_REFERENCED_BY_FAILED, emptyList())

    @JvmField
    public val GATHER_LIMITS_REQUESTED: Operation<InferenceLimitsRequest, InferenceLimitsResult, CommandError> =
        Operation(Channels.GATHER_LIMITS_REQUESTED, Channels.GATHER_LIMITS_RESULT, Channels.GATHER_LIMITS_FAILED, emptyList())

    @JvmField
    public val JOB_CREATE: Operation<JobCreateCommand, JobCreatedResult, CommandError> =
        Operation(Channels.JOB_CREATE, Channels.JOB_CREATED, Channels.JOB_CREATE_FAILED, emptyList())

    @JvmField
    public val JOB_STATUS_REQUESTED: Operation<JobStatusRequest, JobStatusResult, CommandError> =
        Operation(Channels.JOB_STATUS_REQUESTED, Channels.JOB_STATUS_RESULT, Channels.JOB_STATUS_FAILED, emptyList())

    @JvmField
    public val JOB_LIMITS_REQUESTED: Operation<InferenceLimitsRequest, InferenceLimitsResult, CommandError> =
        Operation(Channels.JOB_LIMITS_REQUESTED, Channels.JOB_LIMITS_RESULT, Channels.JOB_LIMITS_FAILED, emptyList())

    @JvmField
    public val JOB_CANCEL_REQUESTED: Operation<JobCancelRequest, Response<JobCancelResult>, CommandError> =
        Operation(Channels.JOB_CANCEL_REQUESTED, Channels.JOB_CANCEL_OK, Channels.JOB_CANCEL_FAILED, emptyList())

    @JvmField
    public val JOB_CLAIM: Operation<JobClaimCommand, JobClaimedResult, CommandError> =
        Operation(Channels.JOB_CLAIM, Channels.JOB_CLAIMED, Channels.JOB_CLAIM_FAILED, emptyList())

    @JvmField
    public val MARK_CREATE_REQUEST: Operation<MarkCreateRequest, MarkCreateOk, CommandError> =
        Operation(Channels.MARK_CREATE_REQUEST, Channels.MARK_CREATE_OK, Channels.MARK_CREATE_FAILED, emptyList())

    @JvmField
    public val MARK_COMMIT: Operation<MarkCommitCommand, MarkCommitOk, CommandError> =
        Operation(Channels.MARK_COMMIT, Channels.MARK_COMMIT_OK, Channels.MARK_COMMIT_FAILED, emptyList())

    @JvmField
    public val MARK_DELETE: Operation<MarkDeleteCommand, MarkDeleteOk, CommandError> =
        Operation(Channels.MARK_DELETE, Channels.MARK_DELETE_OK, Channels.MARK_DELETE_FAILED, emptyList())

    @JvmField
    public val MARK_ARCHIVE: Operation<MarkArchiveCommand, EmptyObject, CommandError> =
        Operation(Channels.MARK_ARCHIVE, Channels.MARK_ARCHIVE_OK, Channels.MARK_ARCHIVE_FAILED, emptyList())

    @JvmField
    public val MARK_UNARCHIVE: Operation<MarkUnarchiveCommand, EmptyObject, CommandError> =
        Operation(Channels.MARK_UNARCHIVE, Channels.MARK_UNARCHIVE_OK, Channels.MARK_UNARCHIVE_FAILED, emptyList())

    @JvmField
    public val MARK_UPDATE_ENTITY_TYPES: Operation<MarkUpdateEntityTypesCommand, EmptyObject, CommandError> =
        Operation(Channels.MARK_UPDATE_ENTITY_TYPES, Channels.MARK_UPDATE_ENTITY_TYPES_OK, Channels.MARK_UPDATE_ENTITY_TYPES_FAILED, emptyList())

    @JvmField
    public val MATCH_SEARCH_REQUESTED: Operation<MatchSearchRequest, MatchSearchResult, MatchSearchFailed> =
        Operation(Channels.MATCH_SEARCH_REQUESTED, Channels.MATCH_SEARCH_RESULTS, Channels.MATCH_SEARCH_FAILED, listOf("referenceId"))

    @JvmField
    public val MATCH_RESOURCES_REQUESTED: Operation<MatchResourcesRequest, MatchResourcesResult, CommandError> =
        Operation(Channels.MATCH_RESOURCES_REQUESTED, Channels.MATCH_RESOURCES_RESULT, Channels.MATCH_RESOURCES_FAILED, emptyList())

    @JvmField
    public val MATCH_LIMITS_REQUESTED: Operation<InferenceLimitsRequest, InferenceLimitsResult, CommandError> =
        Operation(Channels.MATCH_LIMITS_REQUESTED, Channels.MATCH_LIMITS_RESULT, Channels.MATCH_LIMITS_FAILED, emptyList())

    @JvmField
    public val WEAVE_REBUILD: Operation<WeaveRebuildCommand, EmptyObject, CommandError> =
        Operation(Channels.WEAVE_REBUILD, Channels.WEAVE_REBUILD_OK, Channels.WEAVE_REBUILD_FAILED, emptyList())

    @JvmField
    public val SMELT_REBUILD_ANCHORS: Operation<SmeltRebuildAnchorsCommand, EmptyObject, CommandError> =
        Operation(Channels.SMELT_REBUILD_ANCHORS, Channels.SMELT_REBUILD_ANCHORS_OK, Channels.SMELT_REBUILD_ANCHORS_FAILED, emptyList())

    @JvmField
    public val YIELD_CREATE: Operation<YieldCreateCommand, YieldCreateOk, CommandError> =
        Operation(Channels.YIELD_CREATE, Channels.YIELD_CREATE_OK, Channels.YIELD_CREATE_FAILED, emptyList())

    @JvmField
    public val YIELD_CLONE_PERSIST: Operation<YieldClonePersistCommand, YieldClonePersistOk, CommandError> =
        Operation(Channels.YIELD_CLONE_PERSIST, Channels.YIELD_CLONE_PERSIST_OK, Channels.YIELD_CLONE_PERSIST_FAILED, emptyList())

    @JvmField
    public val YIELD_UPDATE: Operation<YieldUpdateCommand, YieldUpdateOk, CommandError> =
        Operation(Channels.YIELD_UPDATE, Channels.YIELD_UPDATE_OK, Channels.YIELD_UPDATE_FAILED, emptyList())

    @JvmField
    public val YIELD_CLONE_CREATE: Operation<YieldCloneCreateCommand, YieldCloneCreated, CommandError> =
        Operation(Channels.YIELD_CLONE_CREATE, Channels.YIELD_CLONE_CREATED, Channels.YIELD_CLONE_CREATE_FAILED, emptyList())

    @JvmField
    public val YIELD_CLONE_RESOURCE_REQUESTED: Operation<YieldCloneResourceRequest, Response<GetResourceByTokenResponse>, CommandError> =
        Operation(Channels.YIELD_CLONE_RESOURCE_REQUESTED, Channels.YIELD_CLONE_RESOURCE_RESULT, Channels.YIELD_CLONE_RESOURCE_FAILED, emptyList())

    @JvmField
    public val YIELD_CLONE_TOKEN_REQUESTED: Operation<YieldCloneTokenRequest, Response<CloneResourceWithTokenResponse>, CommandError> =
        Operation(Channels.YIELD_CLONE_TOKEN_REQUESTED, Channels.YIELD_CLONE_TOKEN_GENERATED, Channels.YIELD_CLONE_TOKEN_FAILED, emptyList())
}

/** Each operation of the registry, by its request's channel. */
@Generated
public val OPERATIONS: Map<String, Operation<*, *, *>> = mapOf(
    "bind:update-body" to Operations.BIND_UPDATE_BODY,
    "browse:resource-requested" to Operations.BROWSE_RESOURCE_REQUESTED,
    "browse:resources-requested" to Operations.BROWSE_RESOURCES_REQUESTED,
    "browse:annotation-requested" to Operations.BROWSE_ANNOTATION_REQUESTED,
    "browse:annotation-history-requested" to Operations.BROWSE_ANNOTATION_HISTORY_REQUESTED,
    "browse:events-requested" to Operations.BROWSE_EVENTS_REQUESTED,
    "browse:entity-types-requested" to Operations.BROWSE_ENTITY_TYPES_REQUESTED,
    "browse:tag-schemas-requested" to Operations.BROWSE_TAG_SCHEMAS_REQUESTED,
    "browse:engines-requested" to Operations.BROWSE_ENGINES_REQUESTED,
    "browse:profiles-requested" to Operations.BROWSE_PROFILES_REQUESTED,
    "browse:kb-requested" to Operations.BROWSE_KB_REQUESTED,
    "browse:directory-requested" to Operations.BROWSE_DIRECTORY_REQUESTED,
    "frame:add-entity-type" to Operations.FRAME_ADD_ENTITY_TYPE,
    "frame:add-tag-schema" to Operations.FRAME_ADD_TAG_SCHEMA,
    "gather:requested" to Operations.GATHER_REQUESTED,
    "gather:resource-requested" to Operations.GATHER_RESOURCE_REQUESTED,
    "gather:summary-requested" to Operations.GATHER_SUMMARY_REQUESTED,
    "gather:referenced-by-requested" to Operations.GATHER_REFERENCED_BY_REQUESTED,
    "gather:limits-requested" to Operations.GATHER_LIMITS_REQUESTED,
    "job:create" to Operations.JOB_CREATE,
    "job:status-requested" to Operations.JOB_STATUS_REQUESTED,
    "job:limits-requested" to Operations.JOB_LIMITS_REQUESTED,
    "job:cancel-requested" to Operations.JOB_CANCEL_REQUESTED,
    "job:claim" to Operations.JOB_CLAIM,
    "mark:create-request" to Operations.MARK_CREATE_REQUEST,
    "mark:commit" to Operations.MARK_COMMIT,
    "mark:delete" to Operations.MARK_DELETE,
    "mark:archive" to Operations.MARK_ARCHIVE,
    "mark:unarchive" to Operations.MARK_UNARCHIVE,
    "mark:update-entity-types" to Operations.MARK_UPDATE_ENTITY_TYPES,
    "match:search-requested" to Operations.MATCH_SEARCH_REQUESTED,
    "match:resources-requested" to Operations.MATCH_RESOURCES_REQUESTED,
    "match:limits-requested" to Operations.MATCH_LIMITS_REQUESTED,
    "weave:rebuild" to Operations.WEAVE_REBUILD,
    "smelt:rebuild-anchors" to Operations.SMELT_REBUILD_ANCHORS,
    "yield:create" to Operations.YIELD_CREATE,
    "yield:clone-persist" to Operations.YIELD_CLONE_PERSIST,
    "yield:update" to Operations.YIELD_UPDATE,
    "yield:clone-create" to Operations.YIELD_CLONE_CREATE,
    "yield:clone-resource-requested" to Operations.YIELD_CLONE_RESOURCE_REQUESTED,
    "yield:clone-token-requested" to Operations.YIELD_CLONE_TOKEN_REQUESTED,
)

/** The operations that report the limits of the models a service holds credentials for. */
@Generated
public val LIMITS_OPERATIONS: List<Operation<InferenceLimitsRequest, InferenceLimitsResult, CommandError>> = listOf(Operations.GATHER_LIMITS_REQUESTED, Operations.JOB_LIMITS_REQUESTED, Operations.MATCH_LIMITS_REQUESTED)

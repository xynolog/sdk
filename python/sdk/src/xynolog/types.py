# Generated from the component schemas of protocol/specs/src/openapi.json, the records of its tables, its client types, the services' tables' schemas and client/discovery-absent.json; do not edit.
# Regenerate: make generate (codegen/lib/python_types/python_types.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The protocol's shapes: a model for every component schema, table record and service table that is an object, and a type for every other."""

from __future__ import annotations

from typing import Annotated, Literal
from pydantic import JsonValue, Field
from xynolog.model import WireModel
from xynolog.identifiers import AnnotationId, JobId, ResourceId, UserId
from xynolog.error_codes import BusRequestErrorCode, ControlErrorCode

__all__ = [
    "AboutParams",
    "AboutResult",
    "AccessToken",
    "Agent",
    "AgentOrganization",
    "AgentPerson",
    "AgentSoftware",
    "AnchorMethod",
    "AnchorRect",
    "AnchoredText",
    "AnchoredTextAbsent",
    "AnchoredTextAnswer",
    "AnchoredTextDeclinedEntry",
    "AnchoredTextEntries",
    "AnchoredTextEntry",
    "AnchoredTextExtractedEntry",
    "AnchoredTextExtractedEntryLinesItem",
    "AnchoredTextStamp",
    "AnchoredTextWrite",
    "Annotation",
    "AnnotationAddedPayload",
    "AnnotationBodies",
    "AnnotationBody",
    "AnnotationBodyUpdatedPayload",
    "AnnotationRemovedPayload",
    "AnnotationSelector",
    "AnnotationTarget",
    "ApiVersion",
    "ArchivistConfig",
    "ArchivistConfigStaging",
    "ArchivistDefaultEntityTypes",
    "ArchivistEngines",
    "ArchivistEnginesActors",
    "ArchivistEnginesJobs",
    "ArchivistEnginesJobsMark",
    "ArchivistEventsResponse",
    "ArchivistHealth",
    "ArchivistHealthActorsItem",
    "ArchivistLayout",
    "ArchivistLayoutAnchoredTextEntry",
    "ArchivistLayoutAnchoredTextEntryTree",
    "ArchivistLayoutAnchoredTextStamp",
    "ArchivistLayoutAnchoredTextStampTree",
    "ArchivistLayoutEventFile",
    "ArchivistLayoutEventStream",
    "ArchivistLayoutEventStreamTree",
    "ArchivistLayoutStorageUriIndex",
    "ArchivistLayoutStorageUriIndexTree",
    "ArchivistLayoutSystemProjections",
    "ArchivistLayoutSystemProjectionsFilesItem",
    "ArchivistLayoutSystemProjectionsTree",
    "ArchivistLayoutSystemStream",
    "ArchivistLayoutSystemStreamTree",
    "ArchivistLayoutView",
    "ArchivistLayoutViewTree",
    "ArchivistMessages",
    "ArchivistMessagesBootItem",
    "ArchivistMessagesHttpItem",
    "ArchivistMessagesHttpItemMethod",
    "ArchivistMessagesLoggedItem",
    "ArchivistMessagesRefusalsItem",
    "ArchivistMessagesRefusalsItemCode",
    "ArchivistMessagesUnauthorized",
    "ArchivistMessagesUnsentItem",
    "ArchivistStream",
    "ArchivistStreamsResponse",
    "AssessingJobParams",
    "AssessingJobParamsTone",
    "AttributedEvent",
    "AuthLoginParams",
    "AuthLoginResult",
    "AuthLogoutParams",
    "AuthLogoutResult",
    "BeckonFocusEvent",
    "BeckonHoverEvent",
    "BeckonSparkleEvent",
    "BeginAuthorizationOptions",
    "Binary",
    "BindBodyOperation",
    "BindBodyOperationOp",
    "BindBodyUpdated",
    "BindInitiateCommand",
    "BindUpdateBodyCommand",
    "BodyOperation",
    "BodyOperationAdd",
    "BodyOperationRemove",
    "BodyOperationReplace",
    "BodyPurpose",
    "BrowseAnnotationHistoryRequest",
    "BrowseAnnotationHistoryResult",
    "BrowseAnnotationRequest",
    "BrowseAnnotationResult",
    "BrowseClickEvent",
    "BrowseDirectoryFailed",
    "BrowseDirectoryRequest",
    "BrowseDirectoryRequestSort",
    "BrowseDirectoryResult",
    "BrowseDirectoryResultResponse",
    "BrowseEnginesRequest",
    "BrowseEnginesResult",
    "BrowseEnginesResultResponse",
    "BrowseEntityTypeClickedEvent",
    "BrowseEntityTypesRequest",
    "BrowseEntityTypesResult",
    "BrowseEventsRequest",
    "BrowseEventsResult",
    "BrowseExternalNavigateEvent",
    "BrowseFilesResponse",
    "BrowseKbRequest",
    "BrowseKbResult",
    "BrowseLinkClickedEvent",
    "BrowsePanelOpenEvent",
    "BrowsePanelToggleEvent",
    "BrowseProfilesRequest",
    "BrowseProfilesResult",
    "BrowseProfilesResultResponse",
    "BrowseResourceCloseEvent",
    "BrowseResourceOpenEvent",
    "BrowseResourceReorderEvent",
    "BrowseResourceRequest",
    "BrowseResourceResult",
    "BrowseResourceResultResponse",
    "BrowseResourceViewedEvent",
    "BrowseResourcesRequest",
    "BrowseResourcesResult",
    "BrowseRouterPushEvent",
    "BrowseTagSchemasRequest",
    "BrowseTagSchemasResult",
    "Browser",
    "BrowserSpec",
    "BusEmitAccepted",
    "BusEmitRequest",
    "BusEventMessage",
    "BusFrame",
    "BusPingMessage",
    "BusReplyBounds",
    "BusReplyBoundsRepliesValueValueBy",
    "BusReplyBoundsRepliesValueValueGrows",
    "BusResumeGap",
    "BusResumeGapReason",
    "BusStreamMessage",
    "BusSubscribeRequest",
    "BusSubscribeRequestScopedItem",
    "CacheStatus",
    "Cancelled",
    "ClaimOptions",
    "ClaimRefusal",
    "ClientSecretForm",
    "CloneResourceWithTokenResponse",
    "CommandError",
    "CommandErrorCode",
    "CommentingJobParams",
    "CommentingJobParamsTone",
    "ConformanceBusFetch",
    "ConformanceCase",
    "ConformanceCasePlanesItem",
    "ConformanceCaseTier",
    "ConformanceDriverLine",
    "ConformanceDriverLineAbandoned",
    "ConformanceDriverLineClaimed",
    "ConformanceDriverLineCompleted",
    "ConformanceDriverLineEmission",
    "ConformanceDriverLineEmissionEmission",
    "ConformanceDriverLineEmissionEmissionStateFailed",
    "ConformanceDriverLineEmissionEmissionStatePending",
    "ConformanceDriverLineEmissionEmissionStateReady",
    "ConformanceDriverLineErrorStream",
    "ConformanceDriverLineFailed",
    "ConformanceDriverLineFrame",
    "ConformanceDriverLineFrameFrame",
    "ConformanceDriverLineMisuse",
    "ConformanceDriverLineOk",
    "ConformanceDriverLineProgress",
    "ConformanceDriverLineProgressProgress",
    "ConformanceDriverLineReady",
    "ConformanceDriverLineRefused",
    "ConformanceDriverLineSignalled",
    "ConformanceDriverLineStalled",
    "ConformanceDriverLineState",
    "ConformanceDriverLineUnsupported",
    "ConformanceFailure",
    "ConformanceHttpFetch",
    "ConformanceImplementations",
    "ConformanceImplementationsSdksValue",
    "ConformanceImplementationsSdksValueLive",
    "ConformanceImplementationsSdksValueLiveTier",
    "ConformanceStep",
    "ConformanceStepAbandon",
    "ConformanceStepBackend",
    "ConformanceStepBackendBackend",
    "ConformanceStepCarried",
    "ConformanceStepClaimed",
    "ConformanceStepClosed",
    "ConformanceStepCompletes",
    "ConformanceStepDriver",
    "ConformanceStepError",
    "ConformanceStepFetches",
    "ConformanceStepFetchesFetchesItem",
    "ConformanceStepFrame",
    "ConformanceStepFrames",
    "ConformanceStepHolds",
    "ConformanceStepLeave",
    "ConformanceStepLet",
    "ConformanceStepObserve",
    "ConformanceStepObserveObserve",
    "ConformanceStepProgress",
    "ConformanceStepQuiet",
    "ConformanceStepReaches",
    "ConformanceStepRefused",
    "ConformanceStepScopes",
    "ConformanceStepSettles",
    "ConformanceStepSignalled",
    "ConformanceStepStalled",
    "ConformanceStepState",
    "ConformanceStepStays",
    "ConformanceStepWire",
    "ConformanceStepWireAt",
    "ConnectionIdentity",
    "ConnectionState",
    "ContentFormat",
    "ContextualSummaryResponse",
    "ContextualSummaryResponseContext",
    "ContextualSummaryResponseRelevantFields",
    "ControlSender",
    "CreateAnnotationRequest",
    "CreateFromTokenOptions",
    "CreateResourceResponse",
    "CursorsPath",
    "DeviceCode",
    "DirEntry",
    "DirectoryEntry",
    "DiscoveredKB",
    "DiscoveryAbsent",
    "DiscoveryAbsentReason",
    "DiscoveryDiff",
    "DiscoveryDocument",
    "DiscoveryManaged",
    "DiscoveryRead",
    "DiscoveryState",
    "DiscoveryUnchanged",
    "DispatcherConfig",
    "DispatcherConfigQueue",
    "DispatcherConfigTiming",
    "DispatcherHealth",
    "DispatcherMessages",
    "DispatcherMessagesErrorsItem",
    "DispatcherMessagesRefusalsItem",
    "DispatcherMessagesRefusalsItemCode",
    "DurabilityEvidence",
    "EmbeddingConfig",
    "EmbeddingRequests",
    "EmbeddingRequestsBusy",
    "EmbeddingRequestsProvidersValue",
    "Engine",
    "EngineEntry",
    "EngineLimits",
    "EnrichedResourceEvent",
    "EntityTagChangedPayload",
    "EntityTypeAddedPayload",
    "EntityTypesProjection",
    "EphemeralEventId",
    "ErrorData",
    "ErrorResponse",
    "EventMetadata",
    "Expected",
    "ExtractedText",
    "ExtractionDeclined",
    "ExtractionDeclinedReason",
    "ExtractionMethod",
    "ExtractionOutcome",
    "FailureClass",
    "Fault",
    "FieldFault",
    "FileEntry",
    "FollowerFollowing",
    "FollowerFollowingSweep",
    "FragmentSelector",
    "FrameAddEntityTypeCommand",
    "FrameAddTagSchemaCommand",
    "FrameRefusal",
    "FrameRefusalReason",
    "GatewayConfig",
    "GatewayConfigCapacity",
    "GatewayConfigIdentity",
    "GatewayConfigSignal",
    "GatewayConfigSignalType",
    "GatewayMediaToken",
    "GatewayMediaTokenClaims",
    "GatewayMediaTokenHeader",
    "GatewayMessages",
    "GatewayMessagesChallenges",
    "GatewayMessagesFailuresItem",
    "GatewayMessagesMessagesItem",
    "GatewayResponseHeaders",
    "GatewayResponseHeadersEveryItem",
    "GatewayResponseHeadersPreflight",
    "GatewayResponseHeadersPreflightEchoesItem",
    "GatewayResponseHeadersPreflightHeadersItem",
    "GatherAnnotationComplete",
    "GatherAnnotationOptions",
    "GatherAnnotationRequest",
    "GatherFailed",
    "GatherReferencedByRequest",
    "GatherReferencedByResult",
    "GatherResourceComplete",
    "GatherResourceFailed",
    "GatherResourceOptions",
    "GatherResourceRequest",
    "GatherResourceRequestOptions",
    "GatherSummaryRequest",
    "GatheredContext",
    "GatheredContextFocusAnnotation",
    "GatheredContextFocusAnnotationSelected",
    "GatheredContextFocusAnnotationTargetContext",
    "GatheredContextFocusResource",
    "GatheredContextFocusResourceContent",
    "GatheredContextMetadata",
    "GatheredContextSemanticContext",
    "GenerationJobParams",
    "GenerationJobRequest",
    "GetAnnotationHistoryResponse",
    "GetAnnotationResponse",
    "GetAnnotationsResponse",
    "GetEntityTypesResponse",
    "GetEventsResponse",
    "GetReferencedByResponse",
    "GetReferencedByResponseReferencedByItem",
    "GetReferencedByResponseReferencedByItemTarget",
    "GetReferencedByResponseReferencedByItemTargetSelector",
    "GetResourceByTokenResponse",
    "GetResourceResponse",
    "GetTagSchemasResponse",
    "GraphAnnotationNode",
    "GraphConfig",
    "GraphResourceNode",
    "GraphSchema",
    "GraphSchemaNodes",
    "GraphSchemaNodesAnnotation",
    "GraphSchemaNodesEntityType",
    "GraphSchemaNodesResource",
    "GraphSchemaRelationships",
    "GraphSchemaRelationshipsBelongsTo",
    "GraphSchemaRelationshipsReferences",
    "GraphSchemaRelationshipsTaggedAs",
    "GraphSchemaStub",
    "HealthResponse",
    "HeldJobRecord",
    "HeldJobStall",
    "HighlightingJobParams",
    "HostPort",
    "HttpEndpoint",
    "HttpEndpointProtocol",
    "HttpStatus",
    "IdentityUser",
    "IdentityUseraddParams",
    "IdentityUseraddResult",
    "IdentityUsersListParams",
    "IdentityUsersListResult",
    "Image",
    "Inference",
    "InferenceLimits",
    "InferenceLimitsRequest",
    "InferenceLimitsResult",
    "InferenceLimitsResultResponse",
    "InferenceProvider",
    "InferenceSpec",
    "IssuedTokens",
    "Issuer",
    "IssuerSpec",
    "IssuerSpecDatabase",
    "IssuerSpecDatabaseExternal",
    "JanusGraphConfig",
    "Job",
    "JobAssignCommand",
    "JobAssignedPayload",
    "JobCancelCommand",
    "JobCancelRequest",
    "JobCancelResult",
    "JobCancelled",
    "JobCheckpoint",
    "JobCheckpointCommand",
    "JobClaimCommand",
    "JobClaimedResult",
    "JobComplete",
    "JobCompleteCommand",
    "JobCompletedPayload",
    "JobCreateCommand",
    "JobCreatedResult",
    "JobCreatedResultResponse",
    "JobDeclined",
    "JobDeclinedReason",
    "JobFailCommand",
    "JobFailed",
    "JobFailedPayload",
    "JobFailure",
    "JobFilter",
    "JobMetadata",
    "JobParams",
    "JobPending",
    "JobPollOptions",
    "JobProgress",
    "JobProgressAnalyzing",
    "JobProgressAnalyzingTags",
    "JobProgressCompleteCreated",
    "JobProgressCompleteGenerated",
    "JobProgressCompletedItemsItem",
    "JobProgressCompletedItemsItemUnderReported",
    "JobProgressCreatingAnnotations",
    "JobProgressCreatingResource",
    "JobProgressCreatingTagAnnotations",
    "JobProgressCurrent",
    "JobProgressCurrentKind",
    "JobProgressDetectingEntities",
    "JobProgressGeneratingResource",
    "JobProgressLoading",
    "JobProgressMessage",
    "JobProgressRequestParamsItem",
    "JobProgressRequestParamsItemLabel",
    "JobQueuedEvent",
    "JobReached",
    "JobRecord",
    "JobReportProgressCommand",
    "JobResult",
    "JobRunning",
    "JobStartCommand",
    "JobStartedPayload",
    "JobStatusRequest",
    "JobStatusResponse",
    "JobStatusResponseStatus",
    "JobStatusResult",
    "JobStoredProgress",
    "JobStoredProgressEmpty",
    "JobStoredResult",
    "JobStoredResultEmpty",
    "JobType",
    "JobsBudgets",
    "JobsBudgetsBudgetsItem",
    "JobsStorage",
    "JobsStorageBucket",
    "JobsStorageConsumer",
    "JobsStorageStream",
    "KbDescription",
    "KbDid",
    "KbEndpoint",
    "KbIdentity",
    "KbIdentityConflict",
    "KbPlacement",
    "KbRead",
    "KbReadKind",
    "KbReadVerdict",
    "KbReadVerdictConflict",
    "KbReadVerdictNoVerdict",
    "KbReadVerdictRecorded",
    "KbSessionStatus",
    "KbTarget",
    "KnowledgeBase",
    "KnowledgeBaseStatus",
    "KnowledgeGraph",
    "KnowledgeGraphEdgesItem",
    "KnowledgeGraphNodesItem",
    "KnowledgeIndex",
    "KnowledgeIndexSpec",
    "KnowledgeIndexSpecEmbedding",
    "KnowledgeIndexSpecEmbeddingChunking",
    "KnowledgeIndexSpecGraph",
    "KnowledgeIndexSpecGraphExternal",
    "KnowledgeIndexSpecLibrarian",
    "KnowledgeIndexSpecLibrarianGather",
    "KnowledgeIndexSpecLibrarianSearch",
    "KnowledgeIndexSpecSmelter",
    "KnowledgeIndexSpecVectors",
    "KnowledgeIndexSpecVectorsExternal",
    "KnowledgeIndexSpecVectorsShared",
    "KnowledgeIndexSpecWeaver",
    "LastEventIds",
    "LibrarianConfig",
    "LibrarianConfigGather",
    "LibrarianConfigSearch",
    "LibrarianEngineConfig",
    "LibrarianHealth",
    "LibrarianHealthActorsItem",
    "LibrarianPromptScore",
    "LimitRefusal",
    "LimitRefusalCode",
    "LinkingJobParams",
    "ListResourcesResponse",
    "LocalEndpoint",
    "LocalTarget",
    "LogFormat",
    "LogLevel",
    "LogRecord",
    "LogsFollowParams",
    "LogsFollowResult",
    "MarkArchiveCommand",
    "MarkCommitCommand",
    "MarkCommitOk",
    "MarkCommitOkResponse",
    "MarkCreateOk",
    "MarkCreateOkResponse",
    "MarkCreateRequest",
    "MarkDelegateTimeoutEvent",
    "MarkDeleteCommand",
    "MarkDeleteOk",
    "MarkDeleteOkResponse",
    "MarkJobCompleteCommand",
    "MarkJobCreateCommand",
    "MarkJobDone",
    "MarkJobFilter",
    "MarkJobFilterParams",
    "MarkJobParams",
    "MarkJobQueuedEvent",
    "MarkJobResult",
    "MarkRequestedEvent",
    "MarkSubmitEvent",
    "MarkUnarchiveCommand",
    "MarkUpdateBodyCommand",
    "MarkUpdateEntityTypesCommand",
    "MatchQuality",
    "MatchResourcesRequest",
    "MatchResourcesResponse",
    "MatchResourcesResponseMatchKind",
    "MatchResourcesResult",
    "MatchSearchFailed",
    "MatchSearchOptions",
    "MatchSearchRequest",
    "MatchSearchResult",
    "MediaTokenRequest",
    "MediaTokenResponse",
    "MemoryGraphConfig",
    "MemoryVectorsConfig",
    "Metadata",
    "Motivation",
    "Neo4jGraphConfig",
    "NeptuneGraphConfig",
    "NewKnowledgeBase",
    "OcrConfidence",
    "OllamaEmbeddingConfig",
    "OneOrMoreAgents",
    "OneOrMoreStrings",
    "OneOrMoreUris",
    "OpenResource",
    "OutputStream",
    "PdfClass",
    "PdfCoordinate",
    "PdfTextItem",
    "PendingAnnotation",
    "PendingAuthorization",
    "PendingAuthorizationIssuer",
    "PermissionDenied",
    "PersistedEventId",
    "PrincipalProfileCommand",
    "PrincipalProfiledPayload",
    "Profile",
    "ProfilesProjection",
    "Progress",
    "ProgressKind",
    "ProjectConfig",
    "ProjectConfigGit",
    "ProjectConfigProject",
    "ProjectConfigSite",
    "ProtectedResourceMetadata",
    "Provider",
    "QdrantVectorsConfig",
    "QuotedText",
    "ReconciledSpan",
    "ReconciledSpanContextRecovered",
    "ReconciledSpanFirstOfMany",
    "ReconciledSpanFuzzyMatch",
    "ReconciledSpanUniqueMatch",
    "ReplyEventId",
    "Representation",
    "RepresentationAddedPayload",
    "RepresentationNotFound",
    "RepresentationNotFoundCode",
    "RepresentationRel",
    "RepresentationRemovedPayload",
    "RequestId",
    "ResourceAnnotations",
    "ResourceArchivedPayload",
    "ResourceClonedPayload",
    "ResourceCreatedPayload",
    "ResourceCreatedPayloadGeneratedFrom",
    "ResourceDescriptor",
    "ResourceDescriptorContextItem",
    "ResourceDescriptorIdentifierObject",
    "ResourceErrorEvent",
    "ResourceMovedPayload",
    "ResourceSearchFilters",
    "ResourceUnarchivedPayload",
    "ResourceUpdatedPayload",
    "ResourceUpload",
    "ResourceView",
    "Resources",
    "ResourcesLimits",
    "RetryBudget",
    "Root",
    "RootCurrent",
    "RootsForgetParams",
    "RootsForgetResult",
    "RootsInitParams",
    "RootsInitParamsInference",
    "RootsInitResult",
    "RootsListParams",
    "RootsListResult",
    "RunInstance",
    "RunService",
    "Runner",
    "Runtime",
    "RuntimeState",
    "ScoredResource",
    "SecretRef",
    "Selector",
    "SemanticMatch",
    "ServiceAddress",
    "ServiceEnvironmentBootRefusals",
    "ServiceEnvironmentBootRefusalsMembersItem",
    "ServiceEnvironmentBootRefusalsRefusalsItem",
    "ServiceEnvironmentBootRefusalsServicesItem",
    "ServiceEnvironmentVariables",
    "ServiceEnvironmentVariablesVariablesItem",
    "ServiceEnvironmentVariablesVariablesItemProvidedBy",
    "ServiceEnvironmentVariablesVariablesItemReadBy",
    "ServiceEnvironmentVariablesVariablesItemServicesItem",
    "ServiceGroup",
    "ServiceHostParams",
    "ServiceHostResult",
    "ServiceIdentity",
    "ServiceOutput",
    "ServiceRunParams",
    "ServiceRunResult",
    "ServiceSignalParams",
    "ServiceSignalParamsSignal",
    "ServiceSignalResult",
    "ServiceStarted",
    "ServiceStatus",
    "ServiceStatusState",
    "ServiceTelemetryLogLines",
    "ServiceTelemetryLogLinesBus",
    "ServiceTelemetryLogLinesBusPartsItem",
    "ServiceTelemetryLogLinesLogger",
    "ServiceTelemetryLogLinesLoggerJson",
    "ServiceTelemetryLogLinesLoggerServicesItem",
    "ServiceTelemetryLogLinesSupervisor",
    "ServiceTelemetryTelemetry",
    "ServiceTelemetryTelemetryMetricsItem",
    "ServiceTelemetryTelemetryMetricsItemAttributesItem",
    "ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem",
    "ServiceTelemetryTelemetryMetricsItemInstrument",
    "ServiceTelemetryTelemetryMetricsItemPlanesItem",
    "ServiceTelemetryTelemetryMetricsItemServicesItem",
    "ServiceTelemetryTelemetryMetricsItemWhen",
    "ServiceTelemetryTelemetryResourceItem",
    "ServiceTelemetryTelemetryResourceItemServicesItem",
    "ServiceTelemetryTelemetrySpansItem",
    "ServiceTelemetryTelemetrySpansItemAttributesItem",
    "ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem",
    "ServiceTelemetryTelemetrySpansItemKind",
    "ServiceTelemetryTelemetrySpansItemServicesItem",
    "ServiceTelemetryTelemetrySpansItemWhen",
    "Session",
    "SessionEndReason",
    "SessionEnded",
    "SessionJoinedEvent",
    "SessionLeftEvent",
    "SessionState",
    "Setting",
    "SettingAppliesTo",
    "SettingLine",
    "SettingsGetParams",
    "SettingsHoverDelayChangedEvent",
    "SettingsListParams",
    "SettingsListResult",
    "SettingsLocaleChangedEvent",
    "SettingsPathParams",
    "SettingsPathParamsDocument",
    "SettingsPathResult",
    "SettingsSetParams",
    "SettingsThemeChangedEvent",
    "SettingsThemeChangedEventTheme",
    "SettingsUnsetParams",
    "SignInOutcome",
    "SignedIn",
    "SmeltRebuildAnchorsCommand",
    "SmeltSettled",
    "SmeltSettledOutcome",
    "SmeltSettledReason",
    "SmelterChunking",
    "SmelterConfig",
    "SmelterHealth",
    "SmelterHealthIndex",
    "SmelterHealthIndexStamp",
    "SmelterHealthIndexStampEmbedding",
    "SmelterHealthReconcile",
    "SmelterHealthReconcilePhase",
    "SmelterMessages",
    "SmelterMessagesLoggedItem",
    "SmelterMessagesRefusalsItem",
    "SmelterReconcileSummary",
    "SpecificResource",
    "StackApiVersion",
    "StackKnowledgeBase",
    "StackKnowledgeBaseSpec",
    "StackKnowledgeBaseSpecArchivist",
    "StackKnowledgeBaseSpecDispatcher",
    "StackKnowledgeBaseSpecGateway",
    "StackKnowledgeBaseSpecIssuer",
    "StackKnowledgeBaseSpecIssuerExternal",
    "StackKnowledgeBaseSpecIssuerShared",
    "StackKnowledgeBaseSpecMessaging",
    "StackKnowledgeBaseSpecMessagingExternal",
    "StackKnowledgeBaseSpecMessagingJobs",
    "StackKnowledgeBaseSpecMessagingSignal",
    "StackStartParams",
    "StackStartParamsOllamaCache",
    "StackStartResult",
    "StackStopParams",
    "StackStopResult",
    "StatusResponse",
    "StatusResponseFeatures",
    "StatusSnapshotParams",
    "StatusSnapshotResult",
    "StorageUriEntry",
    "StoredEventResponse",
    "StoredSession",
    "SupportedMediaType",
    "SvgSelector",
    "System",
    "TabCheck",
    "TabCheckGone",
    "TabCheckReady",
    "TabCheckUnknown",
    "TabVerdict",
    "TagCategory",
    "TagSchema",
    "TagSchemaAddedPayload",
    "TagSchemasProjection",
    "TaggingJobParams",
    "Target",
    "TextPositionSelector",
    "TextQuoteSelector",
    "TextSpan",
    "TextualBody",
    "TraceCarrier",
    "UnitCursor",
    "UpdateAnnotationBodyRequest",
    "UploadProgress",
    "UploadProgressFinished",
    "UploadProgressProgress",
    "UploadProgressStarted",
    "UserAction",
    "UserResponse",
    "VectorStore",
    "VectorStoreSpec",
    "VectorsConfig",
    "VoyageEmbeddingConfig",
    "WeaveApplied",
    "WeaveRebuildCommand",
    "WeaverConfig",
    "WeaverHealth",
    "WeaverHealthReconcile",
    "WeaverHealthReconcilePhase",
    "WeaverHealthReconcileSummary",
    "WorkerActiveJob",
    "WorkerAnswerFormats",
    "WorkerAnswerFormatsFormatsItem",
    "WorkerConfig",
    "WorkerEngineConfig",
    "WorkerEngineHealth",
    "WorkerHealth",
    "WorkerKnowledgeBaseConfig",
    "WorkerKnowledgeBaseConfigIdentity",
    "WorkerKnowledgeBaseHealth",
    "WorkerKnowledgeBaseHealthState",
    "WorkerMessages",
    "WorkerMessagesBootItem",
    "WorkerMessagesBootItemOwnBootRefusal",
    "WorkerMessagesBootItemSharedBootRefusal",
    "WorkerMessagesDetailsItem",
    "WorkerMessagesErrorsItem",
    "WorkerMessagesJob",
    "WorkerMessagesLoggedItem",
    "WorkerMessagesReasonsItem",
    "WorkerMessagesWaitsItem",
    "WorkerPool",
    "WorkerPoolSpec",
    "WorkerPoolSpecWorker",
    "WorkerVitals",
    "WorkloadStatus",
    "WorkloadStatusLedger",
    "WorkloadStatusQueue",
    "YieldCloneCreateCommand",
    "YieldCloneCreated",
    "YieldClonePersistCommand",
    "YieldClonePersistOk",
    "YieldCloneResourceRequest",
    "YieldCloneTokenRequest",
    "YieldCreateCommand",
    "YieldCreateCommandGeneratedFrom",
    "YieldCreateOk",
    "YieldJobCompleteCommand",
    "YieldJobCreateCommand",
    "YieldJobDone",
    "YieldJobFilter",
    "YieldJobQueuedEvent",
    "YieldJobResult",
    "YieldUpdateCommand",
    "YieldUpdateOk",
    "YieldedResource",
]

type ApiVersion = Annotated[
    Literal["control.xynolog.org/v1alpha1"],
    Field(
        description="The group and version of the control API. Every request's params state it; a launcher refuses a version it does not speak with control.unsupported-api-version, and names the ones it does."
    ),
]


class AboutParams(WireModel, frozen=True, extra="forbid"):
    """
    launcher.about's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]


type Runtime = Annotated[
    Literal["container", "docker", "podman"],
    Field(description="A container runtime the launcher drives, as --runtime names it: Apple container, Docker or Podman."),
]


class RuntimeState(WireModel, frozen=True, extra="forbid"):
    """
    One container runtime the launcher drives, and whether this machine has it.
    """

    name: Runtime
    found: Annotated[bool, Field(description="Whether it is on the launcher's PATH.")]


class AboutResult(WireModel, frozen=True, extra="forbid"):
    """
    What the launcher is. A client asks this first, to learn whether it speaks to the launcher it found.
    """

    version: Annotated[
        str | None, Field(description="The version stamped into the launcher at build. Absent from a development build, which states none.")
    ] = None
    development: Annotated[bool, Field(description="Whether this is a development build: one with no version stamped.")]
    commit: Annotated[str | None, Field(description="The commit it was built from, when stamped.")] = None
    built: Annotated[str | None, Field(description="When it was built, when stamped.")] = None
    api_versions: Annotated[
        list[str],
        Field(alias="apiVersions", description="Each version of the control API it speaks. A client that speaks none of them stops here."),
    ]
    image_registry: Annotated[str, Field(alias="imageRegistry", description="The registry its catalog's images come from.")]
    runtimes: Annotated[
        list[RuntimeState],
        Field(description="Each container runtime it drives, in the order it prefers them, and whether this machine has it."),
    ]


type AccessToken = Annotated[
    str,
    Field(
        description="An access token, as its issuer issued it: short-lived, and what a session's transport sends as a Bearer token. Opaque to a client, which reads nothing in it but its expiry."
    ),
]


class AgentPerson(WireModel, frozen=True, extra="allow"):
    """
    A human participant — the Person branch of Agent.
    """

    type: Annotated[Literal["Person"], Field(alias="@type")]
    id: Annotated[str | None, Field(alias="@id", description="DID-shaped identifier (e.g. did:web:host:users:email%40host)")] = None
    name: Annotated[
        str | None,
        Field(
            description="Display name. ABSENT until resolved: a Person is identified by `@id` and nothing else, and what they are called is recorded once per change on the knowledge base's own log and filled in when a record is read. An artifact therefore never freezes a name, which is what lets a correction reach every artifact its subject ever wrote. Absent also means genuinely unknown — a DID this knowledge base has no profile for."
        ),
    ] = None
    nickname: str | None = None
    email: str | None = None
    email_sha1: str | None = None
    homepage: str | None = None


class AgentOrganization(WireModel, frozen=True, extra="allow"):
    """
    An organization — the Organization branch of Agent.
    """

    type: Annotated[Literal["Organization"], Field(alias="@type")]
    id: Annotated[str | None, Field(alias="@id")] = None
    name: str
    homepage: str | None = None


class AgentSoftware(WireModel, frozen=True, extra="allow"):
    """
    A software peer, the Software branch of Agent: an agent, which is an account as a person is. Its `provider` and `model` are what it says of itself, attributed to it and not checked; the knowledge base reads neither from its DID. Its `name` is no part of what it writes: what it last said it is called is its profile, and readers fill it in, as they do a person's. A generator the knowledge base supplies, for an agent that supplied none, carries `@type` and `@id` alone.
    """

    type: Annotated[Literal["Software"], Field(alias="@type")]
    id: Annotated[
        str | None,
        Field(alias="@id", description="The agent's DID: did:web:<domain>:agents:<subject>, its account at the knowledge base's issuer"),
    ] = None
    name: Annotated[
        str | None,
        Field(
            description="What the agent last said it is called. ABSENT until resolved: filled in from its profile when a record is read, as a Person's name is. Absent also where it has said nothing. Not parsed."
        ),
    ] = None
    provider: Annotated[str | None, Field(description="Inference provider (e.g. ollama, anthropic)")] = None
    model: Annotated[str | None, Field(description="Model identifier (e.g. gemma2:27b, claude-3-5-sonnet)")] = None
    parameters: Annotated[
        dict[str, JsonValue] | None,
        Field(description="Inference parameters (temperature, maxTokens, systemPrompt, etc.). Runtime metadata, not part of identity."),
    ] = None


type Agent = Annotated[
    AgentPerson | AgentOrganization | AgentSoftware,
    Field(
        description="Web Annotation / W3C PROV Agent. Discriminated by @type — Person, Organization, or Software (named member schemas: AgentPerson, AgentOrganization, AgentSoftware). Software peers are first-class participants, not a sub-class of Person.",
        discriminator="type",
    ),
]

type AnchorMethod = Annotated[
    Literal["unique-match", "context-recovered", "first-of-many", "fuzzy-match"],
    Field(
        description="How a quoted selection was found in a text. Which word a span is found by is reconcile's rule (specs/src/annotations/reconcile-cases.json)."
    ),
]


class AnchorRect(WireModel, frozen=True):
    """
    Where a clicked annotation's element is on the viewer's screen: its rectangle in viewport pixels, as a DOM rectangle states it. A viewer's own geometry: it rides a viewer's local frames, and a frame another participant's screen receives carries none.
    """

    x: Annotated[float, Field(description="The rectangle's horizontal origin.")]
    y: Annotated[float, Field(description="The rectangle's vertical origin.")]
    width: Annotated[float, Field(description="The rectangle's width.")]
    height: Annotated[float, Field(description="The rectangle's height.")]
    top: Annotated[float, Field(description="The rectangle's top edge.")]
    right: Annotated[float, Field(description="The rectangle's right edge.")]
    bottom: Annotated[float, Field(description="The rectangle's bottom edge.")]
    left: Annotated[float, Field(description="The rectangle's left edge.")]


class PdfTextItem(WireModel, frozen=True):
    """
    One positioned text run. Coordinates are PDF points with the origin at the bottom-left of the page, Y increasing upward; the flip to canvas pixels happens in the browser.
    """

    start: Annotated[int, Field(description="Offset into AnchoredText.text, in Unicode code points from its start, inclusive.")]
    end: Annotated[int, Field(description="Offset into AnchoredText.text, in Unicode code points from its start, exclusive.")]
    page: Annotated[int, Field(description="1-indexed page number.")]
    x: float
    y: float
    width: float
    height: float


class AnchoredText(WireModel, frozen=True):
    """
    Text paired with the geometry that indexes it — the minimum needed to turn a range of the text, two offsets counted in Unicode code points, into a selection, or a rectangle into a quote. Whole-resource: a producer iterates page by page, but every consumer wants one map.
    """

    text: Annotated[str, Field(description="Reading-order text of the whole resource.")]
    items: Annotated[list[PdfTextItem], Field(description="Positioned runs indexing `text`, roughly one per word.")]


class AnchoredTextAbsent(WireModel, frozen=True):
    """
    There is no coordinate map to serve, and WHY — the distinction a bare null could not carry.

    One member covers all three absences because none carries a payload; `kind` alone is the fact. Retryability is legible from the name, deliberately: a caller must not need a lookup table to decide whether to come back.
    """

    kind: Annotated[
        Literal["not-yet", "no-map", "unknown"],
        Field(
            description="Discriminant, sharing the `kind` field with the ExtractedText/ExtractionDeclined members so the whole answer is one flat union.\n\n`not-yet` — the resource's media type has text that is derived by reading its content, and the store holds no entry for this content: the Smelter has not read it yet, or the entry was lost (a loss the Smelter's reconcile pass re-derives). RETRY.\n\n`no-map` — the resource's media type has no derived text, so no entry exists and none will until the type is given a reader. Decided by the media type alone, and answered at once. TERMINAL.\n\n`unknown` — no content identity to look up: the resource is not in the view store, or its primary representation carries no checksum. TERMINAL."
        ),
    ]


type ExtractionMethod = Annotated[
    Literal["text-passthrough", "pdf-text-layer", "table", "form", "ocr"],
    Field(
        description="How a text was extracted: a plain text taken as it is, a PDF's text layer read, a grid written as rows, a filled form's values read, or pixels read by OCR."
    ),
]

type PdfClass = Annotated[
    Literal["A", "B", "C", "D", "E", "F", "G"],
    Field(
        description="The class a PDF is sorted into, which decides how its text is read. smelter/extraction-cases.json states what each class is."
    ),
]


class OcrConfidence(WireModel, frozen=True):
    """
    How well an OCR engine read the pixels.
    """

    mean: Annotated[float, Field(description="Mean per-word confidence, 0-100.")]
    low_confidence_words: Annotated[int, Field(alias="lowConfidenceWords", description="Words the engine was unsure of.")]
    total_words: Annotated[int, Field(alias="totalWords")]


class ExtractedText(AnchoredText, frozen=True):
    """
    A successful extraction: the anchored text plus its provenance. The 'extracted' member of ExtractionOutcome, the record the anchored-text store holds.
    """

    kind: Annotated[
        Literal["extracted"],
        Field(
            description="Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `method`."
        ),
    ]
    method: Annotated[ExtractionMethod, Field(description="How the text was extracted.")]
    pdf_class: Annotated[PdfClass | None, Field(alias="pdfClass", description="PDF classification, when the source was a PDF.")] = None
    ocr_confidence: Annotated[
        OcrConfidence | None,
        Field(alias="ocrConfidence", description="How well the engine read the pixels, when any of this text came from OCR."),
    ] = None
    unread_pages: Annotated[
        list[int] | None,
        Field(
            alias="unreadPages",
            description="1-indexed pages this extraction could not read — present only for partially covered documents (class C).",
        ),
    ] = None


type ExtractionDeclinedReason = Annotated[
    Literal["no-text-layer", "encrypted", "corrupt", "too-large"], Field(description="Why extraction yielded nothing, by class.")
]


class ExtractionDeclined(WireModel, frozen=True):
    """
    A named decline: extraction ran and yielded nothing, by class. A first-class, cacheable outcome — 'we ran and there was nothing' costs a full recognition pass to discover.
    """

    kind: Annotated[
        Literal["declined"],
        Field(
            description="Discriminant — both ExtractionOutcome members carry `kind`, single-valued: the category here, the detail in `declined`."
        ),
    ]
    declined: Annotated[ExtractionDeclinedReason, Field(description="Why extraction yielded nothing, by class.")]


type AnchoredTextAnswer = Annotated[
    ExtractedText | ExtractionDeclined | AnchoredTextAbsent,
    Field(
        description="What a reader gets when it asks for a resource's coordinate map: the map, a stored decline, or a named absence.\n\nDistinct from `ExtractionOutcome` on purpose. That type is what the STORE holds and what an extractor RETURNS — neither of which can ever be 'not yet'. This is the read answer, which can, so widening ExtractionOutcome itself would have put an impossible state into the store's own type.\n\nFlat, one discriminant: every member carries `kind`, rather than nesting an outcome inside a status envelope and giving the wire two `kind` fields at different depths.",
        discriminator="kind",
    ),
]


class AnchoredTextDeclinedEntry(WireModel, frozen=True, extra="forbid"):
    """
    The bytes were declined: no text is extracted from them.
    """

    v: Annotated[Literal[3], Field(description="The entry format.")]
    stamp: Annotated[
        str,
        Field(
            description="The stamp the entry was derived under: the PDF reader's and the OCR engine's. A reader takes the entry only when it equals the stamp the Smelter last stated."
        ),
    ]
    declined: Annotated[ExtractionDeclinedReason, Field(description="Why extraction yielded nothing, by class.")]


class AnchoredTextEntries(WireModel, frozen=True, extra="forbid"):
    """
    The keys of the entries the anchored-text store holds under the stamp last stated: one checksum for each set of bytes whose text is stored, in no order.
    """

    checksums: list[str]


class AnchoredTextExtractedEntryLinesItem(WireModel, frozen=True, extra="forbid"):
    """
    One line of text: the words that share a page, a baseline and a height.
    """

    p: Annotated[int, Field(description="The page, counted from 1.")]
    y: Annotated[float, Field(description="The line's vertical position in PDF points, from the bottom of the page.")]
    h: Annotated[float, Field(description="The line's height in PDF points.")]
    words: Annotated[
        list[list[float]],
        Field(
            description="Each word as `[x, width, start, end]`: its horizontal position and width in PDF points, and the offsets of its text in `text`, which are whole numbers of Unicode code points from the start of `text`."
        ),
    ]


class AnchoredTextExtractedEntry(WireModel, frozen=True, extra="forbid"):
    """
    The text extracted from the bytes, where each word is on the page, and how it was extracted.
    """

    v: Annotated[Literal[3], Field(description="The entry format.")]
    stamp: Annotated[
        str,
        Field(
            description="The stamp the entry was derived under: the PDF reader's and the OCR engine's. A reader takes the entry only when it equals the stamp the Smelter last stated."
        ),
    ]
    text: Annotated[str, Field(description="The extracted text.")]
    lines: Annotated[
        list[AnchoredTextExtractedEntryLinesItem], Field(description="Where each word of `text` is, line by line, in reading order.")
    ]
    method: Annotated[ExtractionMethod, Field(description="How the text was extracted.")]
    pdf_class: Annotated[PdfClass | None, Field(alias="pdfClass", description="PDF classification, when the source was a PDF.")] = None
    ocr_confidence: Annotated[
        OcrConfidence | None,
        Field(alias="ocrConfidence", description="How well the engine read the pixels, when any of this text came from OCR."),
    ] = None
    unread_pages: Annotated[
        list[int] | None,
        Field(
            alias="unreadPages",
            description="1-indexed pages this extraction could not read — present only for partially covered documents (class C).",
        ),
    ] = None


type AnchoredTextEntry = Annotated[
    AnchoredTextExtractedEntry | AnchoredTextDeclinedEntry,
    Field(
        description="One entry of the anchored-text store: the file `<ab>/<cd>/<key>.json` under the store's directory, where the key is the SHA-256 of the bytes the text was extracted from, in hex. The Smelter derives it and stores it over the Archivist's HTTP surface (`AnchoredTextWrite`); the Archivist writes it, as compact JSON with `v` and `stamp` first, to a sibling temporary file renamed onto the path. The stamp the Smelter states (`AnchoredTextStamp`) is kept, followed by a newline, in the file `STAMP` at the store's root."
    ),
]


class AnchoredTextStamp(WireModel, frozen=True, extra="forbid"):
    """
    The stamp an anchored-text store's entries are taken under: which PDF reader and which OCR engine derived them. Its writer states it before it writes or lists an entry; an entry stored under another stamp is answered to no reader.
    """

    stamp: Annotated[str, Field(description="The stamp: no white space, since it is held in a file of one line.")]


class AnchoredTextWrite(WireModel, frozen=True, extra="forbid"):
    """
    A write of an anchored-text entry for the bytes of one resource: what the Smelter derived from them, and their checksum. The Archivist files the entry under the checksum, so every resource whose bytes those are has it, and refuses the write when the resource's first representation has other bytes.
    """

    content_checksum: Annotated[
        str,
        Field(
            alias="contentChecksum",
            description="The SHA-256 of the bytes the text was derived from, as 64 lower-case hexadecimal digits: the key the entry is filed under.",
        ),
    ]
    entry: AnchoredTextEntry


type Motivation = Annotated[
    Literal["assessing", "commenting", "highlighting", "linking", "tagging"],
    Field(description="Xynolog-supported W3C Web Annotation motivations - https://www.w3.org/TR/annotation-vocab/#motivation"),
]


class TextPositionSelector(WireModel, frozen=True):
    type: Literal["TextPositionSelector"]
    start: Annotated[
        int,
        Field(
            description="Offset into the resource's decoded text, exactly as decoded, in Unicode code points from its start: where the selected text starts."
        ),
    ]
    end: Annotated[
        int,
        Field(
            description="Offset into the resource's decoded text, exactly as decoded, in Unicode code points from its start: just past where the selected text ends."
        ),
    ]


class TextQuoteSelector(WireModel, frozen=True):
    type: Literal["TextQuoteSelector"]
    exact: str
    prefix: str | None = None
    suffix: str | None = None


class SvgSelector(WireModel, frozen=True):
    type: Literal["SvgSelector"]
    value: Annotated[str, Field(description="SVG markup defining the region (must include xmlns attribute)")]


class FragmentSelector(WireModel, frozen=True):
    """
    W3C Web Annotation FragmentSelector for media fragment identifiers (RFC 3778 for PDFs)
    """

    type: Literal["FragmentSelector"]
    value: Annotated[str, Field(description="Media fragment identifier (e.g., 'page=1&viewrect=100,200,50,30' for PDF)")]
    conforms_to: Annotated[str | None, Field(alias="conformsTo", description="URI identifying the fragment syntax specification")] = None


type Selector = Annotated[
    TextPositionSelector | TextQuoteSelector | SvgSelector | FragmentSelector,
    Field(
        description="One W3C selector: a way of finding a segment of a resource. Tell them apart by `type`, which is required on each and single-valued.",
        discriminator="type",
    ),
]

type AnnotationSelector = Annotated[
    Selector | list[Selector], Field(description="What a target's `selector` holds: one W3C selector, or several of the same segment.")
]


class AnnotationTarget(WireModel, frozen=True):
    """
    W3C Web Annotation target object - source is required, selector is optional
    """

    type: Annotated[
        Literal["SpecificResource"] | None,
        Field(
            description="Stated by the annotation of a span: the target is a part of its source, which the selector picks out. An annotation of a resource as a whole states none."
        ),
    ] = None
    source: Annotated[ResourceId, Field(description="The id of the resource being annotated")]
    selector: Annotated[
        AnnotationSelector | None, Field(description="Optional selector to identify a specific segment of the source resource")
    ] = None


type BodyPurpose = Annotated[
    Literal[
        "assessing",
        "bookmarking",
        "classifying",
        "commenting",
        "describing",
        "editing",
        "highlighting",
        "identifying",
        "linking",
        "moderating",
        "questioning",
        "replying",
        "tagging",
    ],
    Field(description="W3C Web Annotation body purpose vocabulary - https://www.w3.org/TR/annotation-vocab/#motivation"),
]


class TextualBody(WireModel, frozen=True):
    type: Literal["TextualBody"]
    value: Annotated[str, Field(description="The text content (e.g., entity type name)")]
    purpose: Annotated[BodyPurpose | None, Field(description="Why this body is included")] = None
    format: Annotated[str | None, Field(description="MIME type (defaults to text/plain)")] = None
    language: Annotated[str | None, Field(description="BCP 47 language tag")] = None


class SpecificResource(WireModel, frozen=True):
    type: Literal["SpecificResource"]
    source: Annotated[ResourceId, Field(description="The id of the resource this body leads to")]
    purpose: Annotated[BodyPurpose | None, Field(description="Why this body is included")] = None


type AnnotationBody = Annotated[
    TextualBody | SpecificResource,
    Field(
        description="An annotation's body: a TextualBody carries text the annotation states (entity tags, descriptions, comments), a SpecificResource points at what it links to. Tell them apart by `type`, which is required on both and single-valued — a consumer never has to probe for which fields happen to be present.",
        discriminator="type",
    ),
]

type AnnotationBodies = Annotated[
    AnnotationBody | list[AnnotationBody],
    Field(
        description="What an annotation's `body` holds: one body, or a non-empty list of them. There is no empty list: an annotation with nothing to say has no `body`."
    ),
]

type OneOrMoreAgents = Annotated[
    Agent | list[Agent],
    Field(
        description="One Agent, or a non-empty list of them: the parties PROV-O and the Web Annotation model let a resource or an annotation name in one place, as one agent or several."
    ),
]


class Annotation(WireModel, frozen=True):
    context: Annotated[
        Literal["http://www.w3.org/ns/anno.jsonld"], Field(alias="@context", description="W3C Web Annotation JSON-LD context")
    ]
    type: Annotated[Literal["Annotation"], Field(description="W3C Annotation type")]
    id: AnnotationId
    motivation: Motivation
    target: Annotated[
        ResourceId | AnnotationTarget,
        Field(
            description="W3C Web Annotation target: the id of the resource annotated, when the whole of it is, or an object with source and optional selector (fragment)"
        ),
    ]
    body: Annotated[
        AnnotationBodies | None,
        Field(
            description="W3C Web Annotation body. Optional per the W3C spec — annotations whose motivation alone is meaningful (highlighting) legitimately omit it. Present values are either a single body or a non-empty array of bodies; there is no empty array."
        ),
    ] = None
    creator: Annotated[
        Agent | None,
        Field(
            description="Web Annotation creator — who requested the annotation. DERIVED by the knowledge base at write time, never accepted from an emitter (a payload carrying it is refused): the verified emitter of the write, or, when the write cites a job, the verified emitter of the job:create that produced it. A Person for human-requested work; a Software peer for autonomous-agent work."
        ),
    ] = None
    created: Annotated[
        str,
        Field(
            description="When the annotation was MADE — the authoring moment, carried from the event that created it. Not when a projection happened to write it: a store that rebuilds from the log must preserve this value, never restamp it."
        ),
    ]
    modified: str | None = None
    generator: Annotated[
        OneOrMoreAgents | None,
        Field(
            description="Web Annotation generator — the Software peer that produced the annotation, when software did. Absent for a person's own annotation. An emitter may supply it to carry the model's parameters, but its identity must be the emitter's own: the knowledge base refuses a generator naming anyone else, and supplies it from the verified emitter when omitted. One producer per write — a write carrying the array form is refused."
        ),
    ] = None
    was_attributed_to: Annotated[
        OneOrMoreAgents | None,
        Field(
            alias="wasAttributedTo",
            description="PROV-O wasAttributedTo — every party responsible for this annotation, DERIVED by the knowledge base from `creator` and the verified executor of the write: `[creator, generator]` when one agent requested the work and software produced it; collapsed to the one agent when requester and producer are the same. Never accepted from an emitter.",
        ),
    ] = None


class AnnotationAddedPayload(WireModel, frozen=True):
    """
    Payload for mark:added domain event
    """

    annotation: Annotation
    content_checksum: Annotated[
        str | None, Field(alias="contentChecksum", description="SHA-256 of resource content at annotation time")
    ] = None


class BodyOperationAdd(WireModel, frozen=True):
    op: Literal["add"]
    item: AnnotationBody


class BodyOperationRemove(WireModel, frozen=True):
    op: Literal["remove"]
    item: AnnotationBody


class BodyOperationReplace(WireModel, frozen=True):
    op: Literal["replace"]
    old_item: Annotated[AnnotationBody, Field(alias="oldItem")]
    new_item: Annotated[AnnotationBody, Field(alias="newItem")]


type BodyOperation = Annotated[
    BodyOperationAdd | BodyOperationRemove | BodyOperationReplace,
    Field(description="One change to an annotation's bodies: a body added, a body removed, or one body replaced by another."),
]


class AnnotationBodyUpdatedPayload(WireModel, frozen=True):
    """
    Payload for mark:body-updated domain event
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    operations: list[BodyOperation]


class AnnotationRemovedPayload(WireModel, frozen=True):
    """
    Payload for mark:removed domain event
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


class ServiceIdentity(WireModel, frozen=True, extra="forbid"):
    """
    The identity provider a service's account signs in at, by its issuer.
    """

    issuer: Annotated[str, Field(description="The issuer URL, exactly as tokens carry it in `iss`.")]


type InferenceProvider = Annotated[
    Literal["anthropic", "google", "llamacpp", "ollama", "openai", "together", "vllm"],
    Field(
        description="The inference provider: who serves the model. `anthropic`, `google`, `openai` and `together` are those companies' own APIs. `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches, each named for the server's software."
    ),
]


class Engine(WireModel, frozen=True, extra="forbid"):
    """
    An engine: an inference provider and a model, which software does a job or an actor's step with. An engine is not a principal: the principal that used one names it on each write it produced with it (`generator`). A person who does a job uses none.
    """

    provider: InferenceProvider
    model: Annotated[str, Field(description="The model identifier, as the provider names it.")]


class ArchivistEnginesJobsMark(WireModel, frozen=True, extra="forbid"):
    """
    The engine for `mark` jobs of each motivation.
    """

    highlighting: Engine | None = None
    commenting: Engine | None = None
    assessing: Engine | None = None
    linking: Engine | None = None
    tagging: Engine | None = None


class ArchivistEnginesJobs(WireModel, frozen=True, extra="forbid"):
    """
    The engine each job is done with when software does it, keyed as a job description is: by `jobType`, and for `mark` by motivation.
    """

    mark: ArchivistEnginesJobsMark | None = None
    yield_: Annotated[Engine | None, Field(alias="yield")] = None


class ArchivistEnginesActors(WireModel, frozen=True, extra="forbid"):
    """
    The engine each Librarian actor that calls a model asks.
    """

    gatherer: Engine | None = None
    matcher: Engine | None = None


class ArchivistEngines(WireModel, frozen=True, extra="forbid"):
    """
    The engine for each job and each Librarian actor, behind `browse:engines`: a provider and a model, and no credential. It is the knowledge base's Inference document's `engines` as they stand, with no fallback, so a job or an actor absent here has no engine.
    """

    jobs: ArchivistEnginesJobs
    actors: ArchivistEnginesActors


class ArchivistConfigStaging(WireModel, frozen=True, extra="forbid"):
    """
    The bounds on how far the staging driver may run behind the working tree, in milliseconds. A knowledge base that does not sync git stages nothing, and reads neither.
    """

    flush_ms: Annotated[
        int, Field(alias="flushMs", description="The quiet period after the last change before pending changes are staged.")
    ]
    max_wait_ms: Annotated[
        int,
        Field(
            alias="maxWaitMs",
            description="The longest a change waits to be staged while others keep arriving, measured from the oldest pending change.",
        ),
    ]


type LogLevel = Annotated[
    Literal["error", "warn", "info", "http", "debug"],
    Field(description="How much a service logs: the least severe level it writes, from error, the most severe, to debug."),
]

type LogFormat = Annotated[
    Literal["json", "simple"],
    Field(
        description="How each log line is written to stdout (service-telemetry/log-lines.json): `json`, one JSON object per line; or `simple`, a line of words followed by any metadata as JSON."
    ),
]


class ArchivistConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything the Archivist reads at boot: nothing in it is defaulted by the Archivist. The launcher writes it for the Archivist it starts, from the knowledge base's stack documents, and the Archivist reads it from the path its `--config` flag names (its image passes `/etc/xynolog/archivist.json`). Started without `--config`, or with a path that names no file, the Archivist refuses to start and says which. No secret is a value here. What the knowledge base says of itself is not here either: its name, its `site.domain` and its `git.sync` are read from the committed `.xynolog/config.yaml` of the tree at `root`. The Archivist's other inputs are the environment variables specs/src/service-environment/variables.json lists for it. A document that does not validate is refused at boot, naming each failing field.
    """

    gateway_url: Annotated[
        str, Field(alias="gatewayUrl", description="The URL the Archivist reaches the gateway at: its only route to the bus.")
    ]
    identity: Annotated[
        ServiceIdentity,
        Field(
            description="The issuer the Archivist's service account signs in at, and whose tokens it admits callers of its HTTP surface by."
        ),
    ]
    root: Annotated[
        str,
        Field(
            description="The knowledge base's working tree: the directory holding `.xynolog/`. The event log, the content and the committed config are under it."
        ),
    ]
    state_home: Annotated[
        str,
        Field(
            alias="stateHome",
            description="The state volume, this knowledge base's alone: the Archivist keeps the knowledge base's views and projections in it, at its top.",
        ),
    ]
    anchored_text_dir: Annotated[
        str,
        Field(
            alias="anchoredTextDir",
            description="The anchored-text store, which only the Archivist mounts: the Smelter stores each entry in it over HTTP, and the Archivist serves it.",
        ),
    ]
    engines: ArchivistEngines
    port: Annotated[int, Field(description="The port the Archivist's HTTP surface answers on, `/health` included.")]
    skip_rebuild: Annotated[
        bool,
        Field(
            alias="skipRebuild",
            description="Whether the Archivist serves the views it finds at boot instead of rebuilding them from the event log first.",
        ),
    ]
    staging: ArchivistConfigStaging
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


class ArchivistDefaultEntityTypes(WireModel, frozen=True, extra="forbid"):
    """
    archivist/default-entity-types.json: the entity types an Archivist seeds, in the order it seeds them.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    entity_types: Annotated[list[str], Field(alias="entityTypes", description="The default entity types, in seed order.")]


class EventMetadata(WireModel, frozen=True):
    """
    Metadata added at persistence time. Part of every StoredEvent. Integrity is provided by git at the commit level (when gitSync is enabled), not by in-event metadata fields.
    """

    sequence_number: Annotated[int, Field(alias="sequenceNumber", description="Monotonic position in the event log (ordering authority)")]


class StoredEventResponse(WireModel, frozen=True):
    """
    A persisted domain event with metadata. Flat shape — event fields and metadata are peers.
    """

    id: Annotated[str, Field(description="Unique event ID (UUID)")]
    type: Annotated[str, Field(description="Event type (flow verb name, e.g. mark:added)")]
    timestamp: Annotated[str, Field(description="When the event occurred")]
    user_id: Annotated[UserId, Field(alias="userId", description="DID of the user who triggered the event")]
    resource_id: Annotated[
        ResourceId | None, Field(alias="resourceId", description="Resource this event affects (absent for system events)")
    ] = None
    version: Annotated[int, Field(description="Event schema version")]
    payload: Annotated[dict[str, JsonValue], Field(description="Event-type-specific payload")]
    metadata: EventMetadata


class ArchivistEventsResponse(WireModel, frozen=True):
    """
    A page of one stream's events from one sequence number, inclusive, in log order, and the sequence number of the stream's last event: the Archivist's answer to `GET /events/{resourceId}`.
    """

    events: list[StoredEventResponse]
    last_sequence: Annotated[
        int,
        Field(
            alias="lastSequence",
            description="The sequence number of the stream's last event when it was read: 0 for a stream with none. More events follow the page while its last event's number is below it.",
        ),
    ]


type ArchivistHealthActorsItem = Literal["stower", "browser", "cloneTokenManager"]


class ArchivistHealth(WireModel, frozen=True):
    """
    The Archivist's liveness answer: it serves, and the actors it hosts.
    """

    status: Literal["ok"]
    actors: Annotated[
        list[ArchivistHealthActorsItem],
        Field(description="The record actors this process hosts: each of the enum's, once, in the order the enum lists them."),
    ]


type ArchivistLayoutEventStreamTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutEventStream(WireModel, frozen=True, extra="forbid"):
    """
    A resource's event stream: a directory of event files.
    """

    tree: ArchivistLayoutEventStreamTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]


type ArchivistLayoutSystemStreamTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutSystemStream(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's own stream, of the events that name no resource. It is not sharded.
    """

    tree: ArchivistLayoutSystemStreamTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]


class ArchivistLayoutEventFile(WireModel, frozen=True, extra="forbid"):
    """
    The files of a stream.
    """

    name: Annotated[str, Field(description="A file's name, `{number}` its number in `digits` decimal digits.")]
    digits: Annotated[int, Field(description="How many decimal digits a file's number is written in, with leading zeros.")]
    first: Annotated[int, Field(description="The first file's number. It is created, empty, with the stream's directory.")]
    max_events: Annotated[int, Field(alias="maxEvents", description="The most events a file holds.")]


type ArchivistLayoutViewTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutView(WireModel, frozen=True, extra="forbid"):
    """
    A resource's view, in the state directory.
    """

    tree: ArchivistLayoutViewTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]
    schema_: Annotated[JsonValue, Field(alias="schema", description="The schema a view is.")]


type ArchivistLayoutSystemProjectionsTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutSystemProjectionsFilesItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The file's name.")]
    schema_: Annotated[JsonValue, Field(alias="schema", description="The schema the projection is.")]


class ArchivistLayoutSystemProjections(WireModel, frozen=True, extra="forbid"):
    """
    The projections of what the `__system__` stream adds up to, in the state directory.
    """

    tree: ArchivistLayoutSystemProjectionsTree
    path: Annotated[str, Field(description="The directory that holds them, in its tree, `/`-separated.")]
    files: Annotated[list[ArchivistLayoutSystemProjectionsFilesItem], Field(description="Each projection's file.")]


type ArchivistLayoutStorageUriIndexTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutStorageUriIndex(WireModel, frozen=True, extra="forbid"):
    """
    An entry of the storage-uri index, which names the resource whose content is at a storage URI.
    """

    tree: ArchivistLayoutStorageUriIndexTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]
    schema_: Annotated[JsonValue, Field(alias="schema", description="The schema an entry is.")]


type ArchivistLayoutAnchoredTextEntryTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutAnchoredTextEntry(WireModel, frozen=True, extra="forbid"):
    """
    An entry of the anchored-text store, keyed by the checksum of the content it was extracted from.
    """

    tree: ArchivistLayoutAnchoredTextEntryTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]
    schema_: Annotated[JsonValue, Field(alias="schema", description="The schema an entry is.")]


type ArchivistLayoutAnchoredTextStampTree = Annotated[
    Literal["root", "stateHome", "anchoredTextDir"],
    Field(
        description="The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store."
    ),
]


class ArchivistLayoutAnchoredTextStamp(WireModel, frozen=True, extra="forbid"):
    """
    The file holding the stamp the anchored-text store's entries are taken under: the stamp, followed by a newline.
    """

    tree: ArchivistLayoutAnchoredTextStampTree
    path: Annotated[str, Field(description="Its path in its tree, `/`-separated.")]


class ArchivistLayout(WireModel, frozen=True, extra="forbid"):
    """
    archivist/layout.json: where the Archivist keeps the record on disk.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    event_stream: Annotated[ArchivistLayoutEventStream, Field(alias="eventStream")]
    system_stream: Annotated[ArchivistLayoutSystemStream, Field(alias="systemStream")]
    event_file: Annotated[ArchivistLayoutEventFile, Field(alias="eventFile")]
    stored_event: Annotated[JsonValue, Field(alias="storedEvent", description="The schema a stored event, one line of an event file, is.")]
    view: ArchivistLayoutView
    system_projections: Annotated[ArchivistLayoutSystemProjections, Field(alias="systemProjections")]
    storage_uri_index: Annotated[ArchivistLayoutStorageUriIndex, Field(alias="storageUriIndex")]
    anchored_text_entry: Annotated[ArchivistLayoutAnchoredTextEntry, Field(alias="anchoredTextEntry")]
    anchored_text_stamp: Annotated[ArchivistLayoutAnchoredTextStamp, Field(alias="anchoredTextStamp")]


class ArchivistMessagesBootItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    refusal: Annotated[
        str,
        Field(
            description="The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class ArchivistMessagesUnsentItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    message: Annotated[
        str,
        Field(
            description="The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


type ArchivistMessagesRefusalsItemCode = Annotated[
    Literal["peer-unavailable", "not-found", "unauthorized", "none-pending"],
    Field(
        description="Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'."
    ),
]


class ArchivistMessagesRefusalsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    operations: Annotated[
        list[str],
        Field(
            description="The operations it refuses: requests of bus/registry.json's operations that the Archivist answers. `{channel}` in the message is the one refused."
        ),
    ]
    code: ArchivistMessagesRefusalsItemCode | None = None
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    message: Annotated[
        str,
        Field(
            description="The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


type HttpStatus = Annotated[
    int, Field(description="An HTTP response's status code, as the tables state one. No API states it, so it is no component.")
]


class ArchivistMessagesUnauthorized(WireModel, frozen=True, extra="forbid"):
    """
    The refusal of every route of the HTTP surface but `/health`: a token that is missing, or not of the knowledge base's issuer and audience, or without the service role.
    """

    status: HttpStatus
    error: Annotated[str, Field(description="The body's `error`.")]
    presented: Annotated[str, Field(description="The `WWW-Authenticate` header when a token was presented.")]
    absent: Annotated[str, Field(description="The `WWW-Authenticate` header when none was.")]


type ArchivistMessagesHttpItemMethod = Annotated[Literal["GET", "PUT", "POST"], Field(description="The route's method.")]


class ArchivistMessagesHttpItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    method: ArchivistMessagesHttpItemMethod
    route: Annotated[str, Field(description="The route, as the Archivist's API names its path.")]
    status: HttpStatus
    code: Annotated[str | None, Field(description="The body's `code`, where it carries one.")] = None
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    error: Annotated[
        str,
        Field(
            description="The body's `error`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class ArchivistMessagesLoggedItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    level: LogLevel
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    message: Annotated[str, Field(description="The line's message, word for word.")]
    fields: Annotated[
        dict[str, str],
        Field(
            description="The fields the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. The line may carry others."
        ),
    ]


class ArchivistMessages(WireModel, frozen=True, extra="forbid"):
    """
    archivist/messages.json: the words of the Archivist's own refusals, and of the messages it logs that a reader relies on.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    boot: Annotated[
        list[ArchivistMessagesBootItem],
        Field(description="Each refusal to start of the Archivist's own, written in service-environment/boot-refusals.json's `line`."),
    ]
    unsent: Annotated[
        list[ArchivistMessagesUnsentItem],
        Field(description="The failure a reply that cannot be sent is answered with instead, on the operation's failure channel."),
    ]
    refusals: Annotated[
        list[ArchivistMessagesRefusalsItem], Field(description="Each refusal of an operation, on the operation's failure channel.")
    ]
    unauthorized: ArchivistMessagesUnauthorized
    http: Annotated[list[ArchivistMessagesHttpItem], Field(description="Each other error a route of the HTTP surface answers with.")]
    logged: Annotated[
        list[ArchivistMessagesLoggedItem], Field(description="Each message the Archivist logs that a reader of its output relies on.")
    ]


class ArchivistStream(WireModel, frozen=True, extra="forbid"):
    """
    One stream of the event log, and where it stands: the resource it is of, or `__system__` for the knowledge base's own, and the sequence number of its last event.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    last_sequence: Annotated[
        int,
        Field(
            alias="lastSequence", description="The sequence number of the stream's last event when it was read: 0 for a stream with none."
        ),
    ]


class ArchivistStreamsResponse(WireModel, frozen=True, extra="forbid"):
    """
    Every stream of the event log, `__system__` among them, each with the sequence number of its last event, in no order: the Archivist's answer to `GET /events`.
    """

    streams: list[ArchivistStream]


type AssessingJobParamsTone = Annotated[
    Literal["analytical", "critical", "balanced", "constructive"], Field(description="The stance the assessments are written from.")
]


class AssessingJobParams(WireModel, frozen=True, extra="forbid"):
    """
    What an assessing job takes: passages of the resource are marked, each with an assessment the model writes.
    """

    motivation: Literal["assessing"]
    instructions: Annotated[str | None, Field(description="What to look for, in the caller's words. Added to the prompt.")] = None
    tone: AssessingJobParamsTone | None = None
    density: Annotated[float | None, Field(description="How many annotations to aim for per 2000 words of the resource.")] = None
    language: Annotated[str | None, Field(description="The language the annotations' own text is written in. BCP 47.")] = None
    source_language: Annotated[
        str | None, Field(alias="sourceLanguage", description="The language of the resource being read. BCP 47.")
    ] = None


class AttributedEvent(StoredEventResponse, frozen=True):
    """
    A persisted event as a history reply carries it: the stored event, and the agent its `userId` identifies. The agent is derived when the reply is made — the DID read into a Person or a Software agent, and a Person's name filled in from the knowledge base's profiles — and is stored nowhere. A Person the record does not name carries no `name`.
    """

    agent: Annotated[Agent, Field(description="Who `userId` is.")]


type KbPlacement = Annotated[
    Literal["local", "codespace"],
    Field(
        description="Where a knowledge base's stack runs: on this machine (local), or in a GitHub codespace whose knowledge base is forwarded here (codespace)."
    ),
]


class Target(WireModel, frozen=True, extra="forbid"):
    """
    Which knowledge base an operation acts on: a local clone's stack, or a codespace's. The launcher resolves it as the command line resolves --root and --repo, and refuses a choice it would have to guess.
    """

    kind: Annotated[
        KbPlacement,
        Field(
            description="Where the stack runs: on this machine (local), or on a GitHub codespace whose knowledge base is forwarded here (codespace)."
        ),
    ]
    root: Annotated[
        str | None,
        Field(
            description="For a local target: the knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the local stack the command line chooses with --runtime, standing where the control server was started."
        ),
    ] = None
    repo: Annotated[str | None, Field(description="For a codespace target: the GitHub repository, as --repo takes it.")] = None


class AuthLoginParams(WireModel, frozen=True, extra="forbid"):
    """
    auth.login's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[Runtime | None, Field(description="Keep to the local stacks, as --runtime does.")] = None


class AuthLoginResult(WireModel, frozen=True, extra="forbid"):
    """
    A completed sign-in, kept in the launcher's sign-in store. No token is in it.
    """

    key: Annotated[str, Field(description="The stack's key in the sign-in store.")]
    who: Annotated[str, Field(description="Who the gateway says is signed in: their email, else their DID.")]
    issuer: Annotated[str, Field(description="The issuer the knowledge base named, where the person signed in.")]


class AuthLogoutParams(WireModel, frozen=True, extra="forbid"):
    """
    auth.logout's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[Runtime | None, Field(description="Keep to the local stacks, as --runtime does.")] = None


class AuthLogoutResult(WireModel, frozen=True, extra="forbid"):
    """
    The launcher's session for a stack, ended. Desktop's own session is not touched.
    """

    key: Annotated[str | None, Field(description="The stack's key in the sign-in store. Absent when no stack is recorded.")] = None
    was_signed_in: Annotated[bool, Field(alias="wasSignedIn", description="Whether a session was stored. false: nothing was done.")]
    revoked: Annotated[
        bool,
        Field(
            description="Whether the issuer revoked the session's refresh token. false with wasSignedIn: the local token is forgotten, and the refresh token stays valid at the issuer until it expires."
        ),
    ]


class BeckonFocusEvent(WireModel, frozen=True):
    """
    Emitted to draw attention to a resource: to one of its annotations, or, with no annotation, to the resource as a whole. The resource is always named. A focus on an annotation scrolls a viewer showing that resource to it, and a viewer showing a different resource ignores it — a deliberate ignore rather than a silent no-op. A focus on the resource as a whole brings that resource forward, opened if it is not open, at its top.
    """

    annotation_id: Annotated[AnnotationId | None, Field(alias="annotationId")] = None
    resource_id: Annotated[
        ResourceId,
        Field(
            alias="resourceId",
            description="The resource this focus applies to, always named. With an annotation it is a guard: a viewer showing a different resource ignores the event. With none it is the resource the focus brings forward.",
        ),
    ]


class BeckonHoverEvent(WireModel, frozen=True):
    """
    Emitted when an annotation is hovered over for beckoning
    """

    annotation_id: Annotated[AnnotationId | None, Field(alias="annotationId")]


class BeckonSparkleEvent(WireModel, frozen=True):
    """
    Emitted when a sparkle effect is triggered on an annotation
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


type HttpEndpointProtocol = Annotated[Literal["http", "https"], Field(description="What the gateway is reached over.")]


class HttpEndpoint(WireModel, frozen=True):
    """
    A knowledge base reached through its gateway, over HTTP. The gateway's origin is the protocol, the host in lowercase and the port; a host that is not a host's name is refused before it is put into a URL (specs/src/session/gateway-url-cases.json).
    """

    kind: Annotated[Literal["http"], Field(description="Discriminant: the endpoint is a gateway reached over HTTP.")]
    host: Annotated[str, Field(description="The gateway's host, as a person or a discovery document gave it.")]
    port: Annotated[int, Field(description="The gateway's port.")]
    protocol: HttpEndpointProtocol


class BeginAuthorizationOptions(WireModel, frozen=True, extra="forbid"):
    """
    What starting an authorization-code grant is told: the knowledge base to sign in to, where the issuer sends the person back, and, re-authenticating, which registered knowledge base it is and what the person believed they chose.
    """

    target: HttpEndpoint
    redirect_uri: Annotated[str, Field(alias="redirectUri", description="Where the issuer sends the person back to.")]
    kb_id: Annotated[
        str | None,
        Field(alias="kbId", description="The registered knowledge base being re-authenticated, rather than a new address connected to."),
    ] = None
    expected_did: Annotated[
        str | None,
        Field(alias="expectedDid", description="The knowledge base's DID the person believed they chose: verified after, never assumed."),
    ] = None
    expected_name: Annotated[
        str | None,
        Field(alias="expectedName", description="The knowledge base's name the person believed they chose: verified after, never assumed."),
    ] = None


type Binary = Annotated[bytes, Field(description="Bytes held whole: all of them at once, read as often as wanted.")]

type BindBodyOperationOp = Annotated[Literal["add", "remove", "replace"], Field(description="The type of body operation")]


class BindBodyOperation(WireModel, frozen=True):
    """
    One edit to a linking annotation's body list: add or remove a body item, or replace an existing one.
    """

    op: BindBodyOperationOp
    item: Annotated[AnnotationBody | None, Field(description="Body item for add operations")] = None
    old_item: Annotated[AnnotationBody | None, Field(alias="oldItem", description="Previous body item for replace operations")] = None
    new_item: Annotated[AnnotationBody | None, Field(alias="newItem", description="Replacement body item for replace operations")] = None


class BindBodyUpdated(WireModel, frozen=True):
    """
    Void success reply emitted on the bind:body-updated channel after bind:update-body has been applied, matched to the originating command by correlationId.
    """


class BindInitiateCommand(WireModel, frozen=True):
    """
    Command payload sent on the bind:initiate bus channel to start a bind flow.
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId", description="Branded AnnotationId of the annotation being bound")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="Branded ResourceId of the resource being bound to")]
    default_title: Annotated[str, Field(alias="defaultTitle", description="Default title for the bound annotation")]
    entity_types: Annotated[list[str], Field(alias="entityTypes", description="Entity types to associate with the annotation")]


class BindUpdateBodyCommand(WireModel, frozen=True):
    """
    Command payload sent on the bind:update-body bus channel to modify annotation bodies.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    annotation_id: Annotated[
        AnnotationId, Field(alias="annotationId", description="Branded AnnotationId of the annotation whose body is being updated")
    ]
    resource_id: Annotated[
        ResourceId, Field(alias="resourceId", description="Branded ResourceId of the resource the annotation belongs to")
    ]
    operations: Annotated[list[BindBodyOperation], Field(description="Ordered body-list edits to apply.")]


class BrowseAnnotationHistoryRequest(WireModel, frozen=True):
    """
    Request to browse the history of an annotation
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


class GetAnnotationHistoryResponse(WireModel, frozen=True):
    events: list[AttributedEvent]
    total: float
    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseAnnotationHistoryResult(WireModel, frozen=True):
    """
    Result of browsing annotation history
    """

    response: GetAnnotationHistoryResponse


class BrowseAnnotationRequest(WireModel, frozen=True):
    """
    Request to browse a single annotation
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


type ResourceDescriptorContextItem = str | dict[str, JsonValue]

type OneOrMoreStrings = Annotated[
    str | list[str], Field(description="One string, or a non-empty list of them: a JSON-LD term that may take one value or several.")
]


class ResourceDescriptorIdentifierObject(WireModel, frozen=True, extra="allow"):
    id: Annotated[str | None, Field(alias="@id")] = None
    value: str | None = None
    scheme: str | None = None


type OneOrMoreUris = Annotated[
    str | list[str], Field(description="One URI, or a non-empty list of them: a JSON-LD term that may name one resource or several.")
]

type RepresentationRel = Annotated[
    Literal["original", "thumbnail", "preview", "optimized", "derived", "other"],
    Field(description="Semantics of this rendition relative to the resource (e.g., original, thumbnail, preview, derived)."),
]


class Representation(WireModel, frozen=True, extra="allow"):
    """
    A specific, byte-addressable rendition of a resource (file/asset/variant).
    """

    id: Annotated[str | None, Field(alias="@id", description="Stable ID for this representation.")] = None
    type: Annotated[OneOrMoreStrings | None, Field(alias="@type", description="Type(s), e.g., schema:MediaObject.")] = None
    media_type: Annotated[str, Field(alias="mediaType", description="MIME/media type (e.g., text/markdown, image/png).")]
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="Working-tree URI identifying where this rendition's bytes live. Only file:// is supported (e.g. file://docs/overview.md). The single home of the storage location: maintained across moves (yield:moved relocates it), absent when the resource has no stored bytes.",
        ),
    ] = None
    filename: str | None = None
    byte_size: Annotated[int | None, Field(alias="byteSize", description="Size of the payload in bytes.")] = None
    checksum: Annotated[
        str | None,
        Field(
            description="The SHA-256 of the bytes, as 64 lower-case hexadecimal digits with nothing before them. Whatever compares the checksums of two representations compares this text."
        ),
    ] = None
    encoding: Annotated[str | None, Field(description="Compression/transfer encoding if applicable.")] = None
    language: Annotated[str | None, Field(description="IETF BCP 47 language tag (e.g., en, es-ES).")] = None
    width: Annotated[int | None, Field(description="Pixels (images/video).")] = None
    height: Annotated[int | None, Field(description="Pixels (images/video).")] = None
    duration: Annotated[float | None, Field(description="Seconds (audio/video).")] = None
    created: str | None = None
    modified: str | None = None
    conforms_to: Annotated[
        OneOrMoreUris | None,
        Field(alias="conformsTo", description="Profile/shape the bytes conform to (e.g., a JSON profile or SVG profile)."),
    ] = None
    tags: list[str] | None = None
    rel: RepresentationRel | None = None


class ResourceDescriptor(WireModel, frozen=True, extra="allow"):
    """
    Metadata about a resource (1:1 with its URI). JSON-LD subject is @id. Link to concrete bytes via representations.
    """

    context: Annotated[
        str | dict[str, JsonValue] | list[ResourceDescriptorContextItem],
        Field(alias="@context", description="JSON-LD context; URI, object, or array of these."),
    ]
    id: Annotated[ResourceId, Field(alias="@id", description="The id of the resource being described.")]
    type: Annotated[OneOrMoreStrings | None, Field(alias="@type", description="Type(s) of the resource (IRIs/CURIEs via @context).")] = None
    name: str
    description: str | None = None
    identifier: Annotated[
        str | list[str] | ResourceDescriptorIdentifierObject | None, Field(description="Persistent identifiers (e.g., DOI, URN).")
    ] = None
    about: Annotated[OneOrMoreStrings | None, Field(description="Topics (IRIs or strings).")] = None
    same_as: Annotated[list[str] | None, Field(alias="sameAs", description="Equivalent/authoritative references.")] = None
    is_part_of: Annotated[list[str] | None, Field(alias="isPartOf")] = None
    has_part: Annotated[list[str] | None, Field(alias="hasPart")] = None
    license: str | None = None
    version: str | None = None
    date_created: Annotated[str | None, Field(alias="dateCreated")] = None
    date_modified: Annotated[str | None, Field(alias="dateModified")] = None
    was_derived_from: Annotated[
        ResourceId | list[ResourceId] | None,
        Field(alias="wasDerivedFrom", description="W3C PROV: the resource, or resources, this one was derived from, each by its id"),
    ] = None
    was_attributed_to: Annotated[
        OneOrMoreAgents | None,
        Field(
            alias="wasAttributedTo",
            description="W3C PROV — every party responsible for this resource, derived by the knowledge base at creation from verified identities: `[requester, generator]` for a resource a job produced, collapsed to the one agent when the requester produced it. Never accepted from an emitter.",
        ),
    ] = None
    generator: Annotated[
        OneOrMoreAgents | None,
        Field(
            description="Software peer that produced this resource (W3C Web Annotation model). Its identity is the verified emitter of the create; the parameters are the producer's to state."
        ),
    ] = None
    conforms_to: Annotated[
        OneOrMoreUris | None, Field(alias="conformsTo", description="Profile/shape URI this resource description conforms to.")
    ] = None
    available_formats: Annotated[
        list[str] | None, Field(alias="availableFormats", description="Convenience set summarizing media types across representations.")
    ] = None
    representations: Annotated[
        Representation | list[Representation], Field(description="Managed or referenced byte-level renditions of this resource.")
    ]
    archived: Annotated[bool | None, Field(description="Application-specific: Whether this resource is archived")] = None
    entity_types: Annotated[
        list[str] | None, Field(alias="entityTypes", description="Application-specific: Entity types for this resource")
    ] = None
    is_draft: Annotated[bool | None, Field(alias="isDraft", description="Application-specific: Whether this resource is a draft")] = None
    source_annotation_id: Annotated[
        AnnotationId | None,
        Field(alias="sourceAnnotationId", description="Application-specific: ID of annotation that triggered generation"),
    ] = None
    source_resource_id: Annotated[
        ResourceId | None, Field(alias="sourceResourceId", description="Application-specific: ID of source resource for clones/derivatives")
    ] = None
    originated_from: Annotated[
        str | None, Field(alias="originatedFrom", description="Original URI from a source knowledge base when this resource was imported")
    ] = None


class GetAnnotationResponse(WireModel, frozen=True):
    annotation: Annotation
    resource: ResourceDescriptor | None
    resolved_resource: Annotated[ResourceDescriptor | None, Field(alias="resolvedResource")]


class BrowseAnnotationResult(WireModel, frozen=True):
    """
    Result of browsing a single annotation
    """

    response: GetAnnotationResponse


class BrowseClickEvent(WireModel, frozen=True):
    """
    An annotation was clicked — open it: the viewer selects its entry in the annotations panel and relays a focus signal to scroll to it. The annotation id is the whole address; it identifies exactly one annotation on exactly one resource, so no resource field is carried and none is needed to scope the event. Motivation is NOT on the wire either: the viewer derives it from the annotation the id names, so the wire states the fact once. A viewer that has not loaded that annotation finds nothing and does nothing. Emitted locally by every clickable annotation surface, and over the wire by a driver opening an annotation on another participant's screen.
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    anchor_rect: Annotated[AnchorRect | None, Field(alias="anchorRect")] = None


type CommandErrorCode = Annotated[
    Literal["peer-unavailable", "not-found", "unauthorized", "none-pending"],
    Field(
        description="Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'."
    ),
]


class CommandError(WireModel, frozen=True):
    """
    Error response for failed bus commands. Replaces native Error objects on the EventBus so payloads are serializable and OpenAPI-typed.
    """

    code: CommandErrorCode | None = None
    message: Annotated[str, Field(description="Human-readable error message")]
    details: Annotated[str | None, Field(description="Optional additional context (stack trace, field name, etc.)")] = None


class BrowseDirectoryFailed(CommandError, frozen=True):
    """
    The payload of `browse:directory-failed`: a CommandError that names the directory that could not be read.
    """

    path: Annotated[str, Field(description="The path the read was asked for.")]


type BrowseDirectoryRequestSort = Literal["name", "mtime", "annotationCount"]


class BrowseDirectoryRequest(WireModel, frozen=True):
    """
    Request to browse a directory listing
    """

    path: str
    sort: BrowseDirectoryRequestSort | None = None


class FileEntry(WireModel, frozen=True, extra="forbid"):
    type: Literal["file"]
    name: Annotated[str, Field(description="Entry name (basename)")]
    path: Annotated[str, Field(description="Path relative to project root")]
    size: Annotated[int, Field(description="File size in bytes")]
    mtime: Annotated[str, Field(description="Last modified time (ISO 8601)")]
    tracked: Annotated[bool, Field(description="True if this file is a tracked resource in the Knowledge Base")]
    resource_id: Annotated[ResourceId | None, Field(alias="resourceId", description="Resource ID (only when tracked is true)")] = None
    entity_types: Annotated[
        list[str] | None, Field(alias="entityTypes", description="Entity types assigned to this resource (only when tracked is true)")
    ] = None
    annotation_count: Annotated[
        int | None, Field(alias="annotationCount", description="Number of annotations on this resource (only when tracked is true)")
    ] = None
    creator: Annotated[
        str | None,
        Field(
            description="DID of the resource's creator — the first of its derived `wasAttributedTo`, the requester as the knowledge base recorded it (only when tracked is true)"
        ),
    ] = None


class DirEntry(WireModel, frozen=True, extra="forbid"):
    type: Literal["dir"]
    name: Annotated[str, Field(description="Entry name (basename)")]
    path: Annotated[str, Field(description="Path relative to project root")]
    mtime: Annotated[str, Field(description="Last modified time (ISO 8601)")]


type DirectoryEntry = Annotated[
    FileEntry | DirEntry,
    Field(
        description="One entry in a directory listing: a file, which may carry the resource it was ingested as, or a subdirectory. Tell them apart by `type`, which is required on both and single-valued.",
        discriminator="type",
    ),
]


class BrowseDirectoryResultResponse(WireModel, frozen=True):
    path: str
    entries: list[DirectoryEntry]


class BrowseDirectoryResult(WireModel, frozen=True):
    """
    Result of browsing a directory listing
    """

    response: BrowseDirectoryResultResponse


class BrowseEnginesRequest(WireModel, frozen=True):
    """
    Request for the knowledge base's engines: those its Inference document names
    """


class MarkJobFilterParams(WireModel, frozen=True, extra="forbid"):
    motivation: Motivation


class MarkJobFilter(WireModel, frozen=True, extra="forbid"):
    """
    `mark` jobs of one motivation.
    """

    job_type: Annotated[Literal["mark"], Field(alias="jobType")]
    params: MarkJobFilterParams


class YieldJobFilter(WireModel, frozen=True, extra="forbid"):
    """
    `yield` jobs.
    """

    job_type: Annotated[Literal["yield"], Field(alias="jobType")]


type JobFilter = Annotated[
    MarkJobFilter | YieldJobFilter,
    Field(
        description="Some jobs, named by fields of the job description: a partial description, at the description's own paths. A job matches when every field stated here equals the job's. A `mark` filter always states its motivation.",
        discriminator="job_type",
    ),
]


class EngineEntry(WireModel, frozen=True, extra="forbid"):
    """
    One of the knowledge base's engines: a provider and a model its Inference document names, and the jobs the document has it used for. An engine is not a principal: whichever worker claims a job does it, under its own account, and names on each write the engine it used, if any. Carries no inference limits: the services that hold the inference credentials report those (InferenceLimitsResult).
    """

    engine: Engine
    jobs: Annotated[
        list[JobFilter] | None,
        Field(
            description="The jobs the knowledge base's Inference document has this engine used for, as a claim names them. Absent for an engine only Librarian actors ask."
        ),
    ] = None


class BrowseEnginesResultResponse(WireModel, frozen=True):
    engines: list[EngineEntry]


class BrowseEnginesResult(WireModel, frozen=True):
    """
    The knowledge base's engines: those its Inference document names, and the jobs it has each used for
    """

    response: BrowseEnginesResultResponse


class BrowseEntityTypeClickedEvent(WireModel, frozen=True):
    """
    Emitted when an entity type is clicked in the browse panel
    """

    entity_type: Annotated[str, Field(alias="entityType")]


class BrowseEntityTypesRequest(WireModel, frozen=True):
    """
    Request to browse available entity types
    """


class GetEntityTypesResponse(WireModel, frozen=True):
    entity_types: Annotated[list[str], Field(alias="entityTypes")]


class BrowseEntityTypesResult(WireModel, frozen=True):
    """
    Result of browsing entity types
    """

    response: GetEntityTypesResponse


class BrowseEventsRequest(WireModel, frozen=True):
    """
    Request to browse events for a resource
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    type: str | None = None
    user_id: Annotated[UserId | None, Field(alias="userId")] = None
    limit: int | None = None


class GetEventsResponse(WireModel, frozen=True):
    events: list[AttributedEvent]
    total: float
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseEventsResult(WireModel, frozen=True):
    """
    Result of browsing events for a resource
    """

    response: GetEventsResponse


class BrowseExternalNavigateEvent(WireModel, frozen=True):
    """
    Emitted when navigation to an external URL is requested
    """

    url: str
    resource_id: Annotated[ResourceId | None, Field(alias="resourceId")] = None


class BrowseFilesResponse(WireModel, frozen=True, extra="forbid"):
    path: Annotated[str, Field(description="The directory path that was listed, relative to project root")]
    entries: list[DirectoryEntry]


class BrowseKbRequest(WireModel, frozen=True):
    """
    Request for the knowledge base's description of itself
    """


class KbDescription(WireModel, frozen=True):
    """
    What a knowledge base says about itself, answered by the Archivist from the committed .xynolog/config.yaml and the working tree it holds. The only source clients use for a knowledge base's name and domain.
    """

    name: Annotated[
        str,
        Field(description="The committed project.name, or the knowledge base directory's name when it commits no .xynolog/config.yaml."),
    ]
    domain: Annotated[
        str,
        Field(
            description="The committed site.domain: the knowledge base's permanent identity. Its did is 'did:web:' + this domain (kbDid in @xynolog/core). It names WHICH knowledge base this is, not which running copy: a local clone and a codespace of one repo report the same domain, so use it to verify what you connected to, never to select among copies. A knowledge base that commits no .xynolog/config.yaml declares none, and is refused with browse:kb-failed."
        ),
    ]
    git_branch: Annotated[
        str | None,
        Field(
            alias="gitBranch",
            description="The working tree's current git branch. Absent when the knowledge base does not sync git (`git.sync` in its committed .xynolog/config.yaml), and when its tree is not a git checkout.",
        ),
    ] = None


class BrowseKbResult(WireModel, frozen=True):
    """
    Result of browse:kb-requested
    """

    response: KbDescription


class BrowseLinkClickedEvent(WireModel, frozen=True):
    """
    Emitted when a link is clicked in the browse panel
    """

    href: str
    label: str | None = None


class BrowsePanelOpenEvent(WireModel, frozen=True):
    """
    Emitted when a browse panel is opened
    """

    panel: str
    scroll_to_annotation_id: Annotated[AnnotationId | None, Field(alias="scrollToAnnotationId")] = None
    motivation: Motivation | None = None


class BrowsePanelToggleEvent(WireModel, frozen=True):
    """
    Emitted when a browse panel is toggled
    """

    panel: str


class BrowseProfilesRequest(WireModel, frozen=True, extra="forbid"):
    """
    Request for the profiles of some principals: the DIDs a reply mentions. Bounded by the question: a reader that has more asks in parts.
    """

    dids: Annotated[list[UserId], Field(description="The principals asked after.")]


class Profile(WireModel, frozen=True, extra="forbid"):
    """
    What a principal last said it is called, and when: the profile a `principal:profiled` event gives.
    """

    name: Annotated[str, Field(description="The name the principal last gave.")]
    since: Annotated[str, Field(description="The timestamp of the event that gave it.")]


class BrowseProfilesResultResponse(WireModel, frozen=True, extra="forbid"):
    profiles: Annotated[dict[str, Profile], Field(description="Each profile, keyed by DID.")]


class BrowseProfilesResult(WireModel, frozen=True):
    """
    The profiles of the principals asked after: each that has one, keyed by DID. A DID with no profile is absent, and is named by no one.
    """

    response: BrowseProfilesResultResponse


class BrowseResourceCloseEvent(WireModel, frozen=True):
    """
    Emitted when a resource is closed in the browse panel
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseResourceOpenEvent(WireModel, frozen=True):
    """
    Domain intent to open a resource in the viewer: emitted locally by in-app link handlers and remotely by the launcher's tour verbs; the viewer translates it to host routing (nav:push), which never crosses the wire. Deliberately not named 'navigate' — that word and the nav:* prefix belong to the host-local framework layer.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseResourceReorderEvent(WireModel, frozen=True):
    """
    Emitted when resources are reordered in the browse panel
    """

    old_index: Annotated[int, Field(alias="oldIndex")]
    new_index: Annotated[int, Field(alias="newIndex")]


class BrowseResourceRequest(WireModel, frozen=True):
    """
    Request to browse a single resource
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseResourceResultResponse(WireModel, frozen=True, extra="forbid"):
    resource: ResourceDescriptor
    last_sequence: Annotated[
        int,
        Field(
            alias="lastSequence",
            description="The sequence number of the resource's last event. A graph read that follows a write waits for the graph projection to reach it.",
        ),
    ]


class BrowseResourceResult(WireModel, frozen=True):
    """
    A resource's descriptor, and the sequence number of the last of its events the descriptor reflects. Its annotations are not here: their number follows the document's, so they are read over HTTP (`GET /resources/{id}/annotations`).
    """

    response: BrowseResourceResultResponse


class BrowseResourceViewedEvent(WireModel, frozen=True):
    """
    REPORT that a resource has loaded in a viewer — emitted on arrival by ANY means: a followed cue, an in-app link, the back button, a typed URL. Deliberately distinct from the imperative browse:resource-open: drive and report never share a channel, or the driver hears its own commands and one viewer's arrival steers another's page.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class BrowseResourcesRequest(WireModel, frozen=True):
    """
    Request to browse resources with optional filtering and pagination
    """

    archived: bool | None = None
    entity_type: Annotated[str | None, Field(alias="entityType")] = None
    offset: Annotated[
        int | None, Field(description="How many of the resources the filters admit are passed over before the page begins.")
    ] = None
    limit: Annotated[int | None, Field(description="The most resources a page has.")] = None


class ListResourcesResponse(WireModel, frozen=True):
    resources: list[ResourceDescriptor]
    total: float
    offset: float
    limit: float


class BrowseResourcesResult(WireModel, frozen=True):
    """
    Result of browsing resources
    """

    response: ListResourcesResponse


class BrowseRouterPushEvent(WireModel, frozen=True):
    """
    Emitted when the browse panel requests a router navigation
    """

    path: str
    reason: str | None = None


class BrowseTagSchemasRequest(WireModel, frozen=True):
    """
    Request to browse registered tag schemas
    """


class TagCategory(WireModel, frozen=True):
    """
    A single category within a tag schema (e.g. 'Issue' in IRAC, 'distinguished' in legal-citation-treatment). Each category carries methodology-bound semantics: a name, a description, and examples used in the LLM prompt.
    """

    name: str
    description: str
    examples: list[str]


class TagSchema(WireModel, frozen=True):
    """
    A structural-analysis schema (e.g. legal-irac, scientific-imrad, argument-toulmin). Defines a methodology framework as an id, name, description, domain hint, and an ordered list of categories. KBs and their skills register schemas with the runtime registry via `frame.addTagSchema(...)` at session start.
    """

    id: str
    name: str
    description: str
    domain: Annotated[
        str,
        Field(
            description="Free-form domain hint (e.g. 'legal', 'scientific', 'general'). Used in the LLM prompt to tune the model's analysis voice. KB authors choose."
        ),
    ]
    tags: list[TagCategory]


class GetTagSchemasResponse(WireModel, frozen=True):
    tag_schemas: Annotated[list[TagSchema], Field(alias="tagSchemas")]


class BrowseTagSchemasResult(WireModel, frozen=True):
    """
    Result of browsing tag schemas
    """

    response: GetTagSchemasResponse


type StackApiVersion = Annotated[
    Literal["xynolog.org/v1alpha1"],
    Field(
        description="The group and version of Xynolog's kinds. The group names who defines a kind, under the domain the knowledge bases' DIDs use; which knowledge base a document is about is said inside it."
    ),
]


class Metadata(WireModel, frozen=True, extra="forbid"):
    """
    What names a document, as Kubernetes names an object. Documents refer to one another by `name`.
    """

    name: Annotated[
        str,
        Field(
            description="The document's name: lower-case letters, digits and `-`, beginning and ending with a letter or digit. It names the document, never the knowledge base."
        ),
    ]
    namespace: Annotated[str | None, Field(description="The Kubernetes namespace the document belongs in. The launcher reads none.")] = None
    labels: Annotated[dict[str, str] | None, Field(description="Kubernetes labels. The launcher reads none.")] = None
    annotations: Annotated[dict[str, str] | None, Field(description="Kubernetes annotations. The launcher reads none.")] = None


type Image = Annotated[
    str, Field(description="The container image a service runs, as a registry names it: `ghcr.io/xynolog/xynolog-gateway:latest`.")
]


class ResourcesLimits(WireModel, frozen=True, extra="forbid"):
    """
    The most a container may use.
    """

    memory: Annotated[str, Field(description="The memory ceiling: a whole number of gigabytes or megabytes, `8G` or `512M`.")]


class Resources(WireModel, frozen=True, extra="forbid"):
    """
    What a container is given, in Kubernetes' spelling.
    """

    limits: ResourcesLimits


class BrowserSpec(WireModel, frozen=True, extra="forbid"):
    """
    How the Browser runs.
    """

    image: Image
    resources: Resources
    port: Annotated[
        int,
        Field(
            description="The port the Browser is published on, on this machine's loopback: where a person opens it, and the origin the issuer's realm allows its sign-in from."
        ),
    ]


class Browser(WireModel, frozen=True, extra="forbid"):
    """
    The shared Browser: one viewer for every knowledge base the machine reaches. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/browser.yaml`, not in a knowledge base's repository.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["Browser"]
    metadata: Metadata
    spec: BrowserSpec


class BusEmitAccepted(WireModel, frozen=True):
    """
    Result of publishing one event. `subscribers` is the number of observers attached to the target subject at dispatch — the GLOBAL subject for an unscoped emit, the scoped one when `scope` is set. Zero means the signal reached nobody: /bus/subscribe enforces no channel allowlist and the emit handler publishes unconditionally, so a client can emit a channel no participant subscribes to and otherwise receive a clean 202 with no way to tell. Deliberately NOT named `delivered`: this is the count at dispatch, and a subscriber may still drop the frame downstream, so the field is named after what the server can actually observe.
    """

    subscribers: Annotated[
        int | None,
        Field(
            description="Observers on the target subject when the event was dispatched. ABSENT means the gateway could not count: under a broker signal plane (the KnowledgeBase document's `spec.messaging.signal.type: nats`) the event is published to a fabric whose observers the gateway cannot see. The one zero a broker plane states is a registry operation's request with a `correlationId` that reached nobody, which the broker itself reports (no responders). Never defaulted: a zero here is the claim that nobody was listening, and a gateway that did not observe that never makes it."
        ),
    ] = None


class BusEmitRequest(WireModel, frozen=True):
    """
    One event for the bus. `channel` names a channel of the bus registry (specs/src/bus/registry.json) and `payload` must match the schema the registry's `validate` names for it. `scope` publishes a resource-bound broadcast to that resource's subscribers only; everything else is unscoped. `clientId` and `correlationId` are routing facts beside the payload, never inside it.
    """

    channel: Annotated[str, Field(description="A channel of the bus registry.")]
    payload: Annotated[
        dict[str, JsonValue],
        Field(
            description="The channel's payload, validated against the schema its registry entry names. `_userId` and `_roles` are the gateway's to write: whatever a caller puts there is replaced."
        ),
    ]
    scope: Annotated[
        ResourceId | None,
        Field(
            description="The resource scope of a resource-bound broadcast. Publishers of those broadcasts only; a command or request never carries one."
        ),
    ] = None
    client_id: Annotated[
        str | None,
        Field(
            alias="clientId",
            description="The address this request's reply is delivered to: the emit claims `correlationId` for this clientId and the verified principal. Required when `channel` is a registry operation's request and a correlationId is present; ignored otherwise. An empty string counts as absent.",
        ),
    ] = None
    correlation_id: Annotated[
        str | None,
        Field(
            alias="correlationId",
            description="Pairs a reply with its request. On a registry operation's request it claims the id: a second claim of a live id is refused with 409. Replies carry it back on the frame, never in the payload.",
        ),
    ] = None


type PersistedEventId = Annotated[
    str,
    Field(
        description="`p-<scope>-<sequenceNumber>` — the id of a persisted event delivered on a scoped subscription. Resumable: send it back as that scope's `lastEventId`. Stable across connections, so a client dedups by it."
    ),
]

type ReplyEventId = Annotated[
    str,
    Field(
        description="`e-<channel>:<correlationId>` — the id of a frame that carries a correlationId. Deterministic: the same reply has the same id on every connection, so a copy arriving on two connections (a reconnect overlap, or a replay of a retained reply) dedups. Never a resumption watermark."
    ),
]

type EphemeralEventId = Annotated[
    str,
    Field(
        description="`e-<publishId>` — the id of any other frame, given once when the frame is published: the same on every connection that carries it, through every replica, so a copy arriving on two connections (a reconnect overlap) dedups. Never a resumption watermark."
    ),
]


class BusFrame(WireModel, frozen=True, extra="forbid"):
    """
    One frame of the bus stream, as the `data` line of a `bus-event` message carries it (JSON-serialised on one line). `payload` is the channel's payload as its registry entry declares it. A frame on a scoped subscription carries the scope it was published on; a correlated reply carries the `correlationId` of the request it answers.
    """

    channel: Annotated[str, Field(description="A channel of the bus registry (specs/src/bus/registry.json).")]
    correlation_id: Annotated[
        str | None,
        Field(alias="correlationId", description="The request this frame answers. Present on correlated replies; absent otherwise."),
    ] = None
    payload: Annotated[
        dict[str, JsonValue],
        Field(
            description="The channel's payload. A replayed persisted event is the stored event itself, whose `metadata.sequenceNumber` the message id carries."
        ),
    ]
    scope: Annotated[
        ResourceId | None,
        Field(
            description="The resource scope the frame was published on. Present exactly when it arrived through a `scoped` entry of the subscription."
        ),
    ] = None


class BusEventMessage(WireModel, frozen=True, extra="forbid"):
    """
    A bus frame on the stream: `event: bus-event`, an `id:` line, and one `data:` line holding the JSON-serialised BusFrame. This schema describes the message with `data` already parsed.
    """

    event: Literal["bus-event"]
    id: PersistedEventId | ReplyEventId | EphemeralEventId
    data: BusFrame


class BusPingMessage(WireModel, frozen=True, extra="forbid"):
    """
    The heartbeat: `event: ping` with an empty `data:` line. The first is written once the stream has caught up (after any replay), then one every `x-xynolog-limits.heartbeatSeconds`. It carries no id, so it never disturbs a client's last-seen ids.
    """

    event: Literal["ping"]
    data: str


class BusReplyBoundsRepliesValueValueBy(WireModel, frozen=True, extra="forbid"):
    """
    A list or map bounded by a member of the request.
    """

    by: Annotated[str, Field(description="The member of the request that bounds it: an array, or an integer with a maximum.")]


class BusReplyBoundsRepliesValueValueGrows(WireModel, frozen=True, extra="forbid"):
    """
    A list or map not yet bounded, which grows.
    """

    grows: Annotated[str, Field(description="What it grows with.")]


class BusReplyBounds(WireModel, frozen=True, extra="forbid"):
    """
    bus/reply-bounds.json: each list or map an operation's reply carries that its own schema does not bound, and what bounds it.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    replies: Annotated[
        dict[str, dict[str, BusReplyBoundsRepliesValueValueBy | BusReplyBoundsRepliesValueValueGrows]],
        Field(description="Each operation, by its request's channel."),
    ]


type BusResumeGapReason = Annotated[
    Literal["unparseable-last-event-id", "scope-mismatch", "retention-exceeded", "query-error"],
    Field(
        description="`unparseable-last-event-id`: the watermark is not a PersistedEventId. `scope-mismatch`: it names another scope. `retention-exceeded`: the record no longer holds the events after it (what it still holds is replayed first). `query-error`: the record could not be read."
    ),
]


class BusResumeGap(WireModel, frozen=True, extra="forbid"):
    """
    The payload of `bus:resume-gap`: a scope's `lastEventId` could not be honoured, so the client cannot trust that it has every persisted event of that scope and must refetch what it caches for it. Written by the gateway, never by a participant.
    """

    scope: Annotated[ResourceId, Field(description="The scope of the subscription entry whose watermark failed.")]
    last_seen_id: Annotated[str, Field(alias="lastSeenId", description="The watermark the entry carried.")]
    reason: BusResumeGapReason


type BusStreamMessage = Annotated[
    BusEventMessage | BusPingMessage,
    Field(description="Every message the bus stream carries. A client ignores an `event` it does not know; the gateway writes no other."),
]


class BusSubscribeRequestScopedItem(WireModel, frozen=True, extra="forbid"):
    scope: Annotated[ResourceId, Field(description="Resource scope (a resourceId).")]
    channels: Annotated[list[str], Field(description="Channels to subscribe within this scope.")]
    last_event_id: Annotated[
        str | None,
        Field(
            alias="lastEventId",
            description="This scope's last-seen PersistedEventId. The gateway replays this scope's persisted events after it — those on the entry's channels — before the live tail, and writes a scoped `bus:resume-gap` (BusResumeGap) when it cannot cover the gap.",
        ),
    ] = None


class BusSubscribeRequest(WireModel, frozen=True, extra="forbid"):
    """
    Subscription matrix for the bus stream. `global` channels are delivered unscoped; each `scoped` entry subscribes the connection to one resource scope's channels, optionally resuming from that scope's last-seen persisted event id. At least one global channel or one scoped entry is required, and no scope may appear in two entries.
    """

    global_: Annotated[list[str] | None, Field(alias="global", description="Unscoped channels to subscribe to.")] = None
    pending_replies: Annotated[
        list[str] | None,
        Field(
            alias="pendingReplies",
            description="Correlation ids of requests this client still awaits a reply to. The gateway writes every reply it still retains for them (for `x-xynolog-limits.replyRetentionSeconds` after it was published) as an ordinary frame with its ReplyEventId, so a reply that also arrived live dedups client-side. A client can have no more pending than it may have unanswered requests, so this bound is also the number of unanswered requests `POST /bus/emit` allows a client.",
        ),
    ] = None
    scoped: Annotated[
        list[BusSubscribeRequestScopedItem] | None,
        Field(description="Per-resource-scope subscriptions, at most 512 on one connection. Scopes must be unique across entries."),
    ] = None
    client_id: Annotated[
        str,
        Field(
            alias="clientId",
            description="Routing address for correlated replies: a UUID minted once per bus-client lifetime — per actor, not per connection, so it survives a reconnect and two overlapping connections share it. A correlated reply is delivered to a connection only when its request was emitted under the same clientId by the same principal. Not authentication — the bearer token stays that — and never echoed into any payload or broadcast frame.",
        ),
    ]


type CacheStatus = Annotated[
    Literal["pending", "ready", "failed"],
    Field(
        description="Where a live query's key stands (contract/CACHE-SEMANTICS.md): pending, with no value yet; ready, with a stored value; or failed, a value-less key's failure, which is an emission and not the stream's end."
    ),
]

type RequestId = Annotated[
    str | int, Field(description="The request a notification is about: the JSON-RPC id its client gave it, as the client gave it.")
]


class Cancelled(WireModel, frozen=True, extra="forbid"):
    """
    The client gives up on one of its requests. The launcher answers that request with control.cancelled, unless it has answered it already; a cancellation of a request it does not know is ignored.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    reason: Annotated[str | None, Field(description="Why, for the launcher's diagnostics.")] = None


class ClaimOptions(WireModel, frozen=True, extra="forbid"):
    """
    What a worker's claiming of jobs is told: the jobs it takes, and how long it waits for what it waits on. A wait left out is client/timing.json's of the same name.
    """

    accepts: Annotated[
        list[JobFilter], Field(description="The jobs this claim takes. A job is handed over when it matches any one of them.")
    ]
    job_claim_timeout_ms: Annotated[
        int | None, Field(alias="jobClaimTimeoutMs", description="How long it waits for the answer to one claim, in milliseconds.")
    ] = None
    held_job_stall_ms: Annotated[
        int | None,
        Field(alias="heldJobStallMs", description="How long a held job may show no activity before it is called stalled, in milliseconds."),
    ] = None
    held_job_stall_check_ms: Annotated[
        int | None,
        Field(alias="heldJobStallCheckMs", description="How often it looks at how long a held job has shown no activity, in milliseconds."),
    ] = None
    mark_commit_timeout_ms: Annotated[
        int | None,
        Field(
            alias="markCommitTimeoutMs",
            description="How long it waits for the record to acknowledge a commit of annotations, in milliseconds.",
        ),
    ] = None


class ClaimRefusal(WireModel, frozen=True, extra="forbid"):
    """
    A claim refused for a reason other than that nothing is pending, which is no fault: what a worker's claims say on `refused` (contract/WORKER-CONTRACT.md § Claiming). `bus.unauthorized` means the credential cannot claim, and will not be able to later.
    """

    code: Annotated[
        BusRequestErrorCode | None,
        Field(
            description="The bus code the reply was read as, or null when the refusal was the worker's own: a reply its schema does not allow. Never a code the reply did not state, and never `bus.none-pending`."
        ),
    ]
    message: Annotated[str, Field(description="What the refusal said.")]


class ClientSecretForm(WireModel, frozen=True):
    """
    The form a service account that holds a client secret posts to its issuer's token endpoint for a client-credentials grant: its client id and secret in the body (RFC 6749 §2.3.1). An account that holds a key proves itself by the client assertion of client-assertion-cases.json instead.
    """

    grant_type: Annotated[Literal["client_credentials"], Field(description="The grant, client-assertion-cases.json's grantType.")]
    client_id: Annotated[str, Field(description="The account's client id.")]
    client_secret: Annotated[str, Field(description="The account's client secret.")]


class CloneResourceWithTokenResponse(WireModel, frozen=True):
    token: Annotated[str, Field(description="Generated clone token")]
    expires_at: Annotated[str, Field(alias="expiresAt", description="ISO 8601 timestamp when token expires")]
    resource: ResourceDescriptor


type CommentingJobParamsTone = Annotated[
    Literal["scholarly", "explanatory", "conversational", "technical"], Field(description="The voice the comments are written in.")
]


class CommentingJobParams(WireModel, frozen=True, extra="forbid"):
    """
    What a commenting job takes: passages of the resource are marked, each with a comment the model writes.
    """

    motivation: Literal["commenting"]
    instructions: Annotated[str | None, Field(description="What to look for, in the caller's words. Added to the prompt.")] = None
    tone: CommentingJobParamsTone | None = None
    density: Annotated[float | None, Field(description="How many annotations to aim for per 2000 words of the resource.")] = None
    language: Annotated[str | None, Field(description="The language the annotations' own text is written in. BCP 47.")] = None
    source_language: Annotated[
        str | None, Field(alias="sourceLanguage", description="The language of the resource being read. BCP 47.")
    ] = None


class ConformanceBusFetch(WireModel, frozen=True, extra="forbid"):
    """
    A request on the bus a live case expects the client to make, on this channel; `as` names its correlation id, for the backend to answer.
    """

    fetch: Annotated[str, Field(description="The request's channel, a request of specs/src/bus/registry.json.")]
    payload: JsonValue | None = None
    as_: Annotated[str, Field(alias="as", description="The request's correlation id, for the backend's answer.")]


type ConformanceCasePlanesItem = Literal["in-process", "nats"]

type ConformanceCaseTier = Annotated[
    Literal["fleet", "parity"],
    Field(
        description="A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does."
    ),
]


class ConformanceStepLet(WireModel, frozen=True, extra="forbid"):
    """
    Name values for later steps.
    """

    let: Annotated[dict[str, JsonValue], Field(description="Each name, and the value it takes.")]


class ConformanceStepDriver(WireModel, frozen=True, extra="forbid"):
    """
    Ask the driver for an operation. It must succeed, with `returns` when given, or fail with `fails`. With `as`, the step does not wait: a later `settles` step does.
    """

    driver: Annotated[str, Field(description='The operation (conformance/sdk/README.md, "Operations").')]
    with_: Annotated[dict[str, JsonValue] | None, Field(alias="with", description="The operation's arguments.")] = None
    returns: JsonValue | None = None
    fails: JsonValue | None = None
    as_: Annotated[str | None, Field(alias="as", description="The operation's name, for the `settles` or `abandon` step that ends it.")] = (
        None
    )


class ConformanceStepAbandon(WireModel, frozen=True, extra="forbid"):
    """
    Abandon an operation started with `as`, as its caller would.
    """

    abandon: Annotated[str, Field(description="The operation.")]


class ConformanceStepSettles(WireModel, frozen=True, extra="forbid"):
    """
    An operation started with `as` settles: it succeeded, with `returns` when given; or failed with `fails`; or, `abandoned`, it ended because the case abandoned it and reported nothing.
    """

    settles: Annotated[str, Field(description="The operation.")]
    returns: JsonValue | None = None
    fails: JsonValue | None = None
    abandoned: Annotated[Literal[True] | None, Field(description="It ended because the case abandoned it.")] = None


type ConformanceStepWireAt = Annotated[
    Literal["arrival", "answer", "live"],
    Field(description="When it is read: on arrival, once answered (the default), or once its stream has caught up."),
]


class ConformanceStepWire(WireModel, frozen=True, extra="forbid"):
    """
    The next request the client put on the wire is this operation, with each field given.
    """

    wire: Annotated[str, Field(description="The operation of the gateway's API, by its method and path.")]
    at: ConformanceStepWireAt | None = None
    status: Annotated[int | None, Field(description="The status it was answered with.")] = None
    params: JsonValue | None = None
    body: JsonValue | None = None
    token: JsonValue | None = None
    headers: Annotated[
        dict[str, JsonValue] | None,
        Field(description="The request's headers named here, each as a pattern; headers not named are not compared."),
    ] = None
    answer: JsonValue | None = None
    as_: Annotated[str | None, Field(alias="as", description="The request's name, for a later step.")] = None
    follows: Annotated[str | None, Field(description="A request named earlier, which was answered before this one arrived.")] = None
    waited: Annotated[str | None, Field(description="A request named earlier, answered with a Retry-After, which this one waited out.")] = (
        None
    )


class ConformanceStepCarried(WireModel, frozen=True, extra="forbid"):
    """
    The stream a wire step named has carried this frame to the client.
    """

    carried: Annotated[str, Field(description="The stream.")]
    is_: Annotated[JsonValue, Field(alias="is")]


class ConformanceStepClosed(WireModel, frozen=True, extra="forbid"):
    """
    The request a `wire` step named has ended with no answer reaching the client: the client closed it, or the proxy kept the gateway's answer from it (`answer-lost`).
    """

    closed: Annotated[str, Field(description="The request.")]


class ConformanceStepProgress(WireModel, frozen=True, extra="forbid"):
    """
    An upload started with `as`, and not yet settled, has reported all of it sent: every report states the same total, none states less than the one before, and the last states the total.
    """

    progress: Annotated[str, Field(description="The upload.")]


type ConnectionState = Annotated[
    Literal["initial", "connecting", "open", "reconnecting", "degraded", "unauthenticated", "closed"],
    Field(
        description="Where a client's stream is: one of the states of client/connection-states.json, which says what each means and where it moves."
    ),
]


class ConformanceStepState(WireModel, frozen=True, extra="forbid"):
    """
    The transport comes to report this state.
    """

    state: Annotated[ConnectionState, Field(description="The state.")]


class ConformanceStepStays(WireModel, frozen=True, extra="forbid"):
    """
    The transport is in this state and has reported no other since the case last read its state.
    """

    stays: Annotated[ConnectionState, Field(description="The state.")]


class ConformanceStepFrame(WireModel, frozen=True, extra="forbid"):
    """
    The next frame the client delivers on this channel is this one.
    """

    frame: Annotated[str, Field(description="The channel.")]
    is_: Annotated[JsonValue, Field(alias="is")]


class ConformanceStepFrames(WireModel, frozen=True, extra="forbid"):
    """
    The client delivers this many more frames on this channel. What they are is held, as every frame is, to what the gateway sent.
    """

    frames: Annotated[str, Field(description="The channel.")]
    count: Annotated[int, Field(description="How many more.")]


class ConformanceStepError(WireModel, frozen=True, extra="forbid"):
    """
    The next failure on the client's error stream is this one.
    """

    error: JsonValue


type ConformanceStepBackendBackend = Annotated[
    Literal[
        "listen",
        "emit",
        "record",
        "content",
        "description",
        "annotations",
        "anchored-text",
        "uploaded",
        "refuse",
        "unanswered",
        "answer-lost",
        "hold",
        "release",
        "rechunk",
        "carry",
        "cut",
        "down",
        "up",
        "archivist",
    ],
    Field(description="The directive."),
]


class ConformanceStepBackend(WireModel, frozen=True, extra="forbid"):
    """
    The backend does something (conformance/sdk/README.md, "Backend directives").
    """

    backend: ConformanceStepBackendBackend
    with_: Annotated[dict[str, JsonValue] | None, Field(alias="with", description="The directive's arguments.")] = None


class ConformanceStepQuiet(WireModel, frozen=True, extra="forbid"):
    """
    The client puts nothing more on the wire for this many milliseconds.
    """

    quiet: Annotated[int, Field(description="How long, in milliseconds.")]


class ConformanceStepObserveObserve(WireModel, frozen=True, extra="forbid"):
    """
    The live query.
    """

    query: Annotated[str, Field(description="The live query, by its name in specs/src/client/refresh.json.")]
    resource: JsonValue | None = None
    annotation: JsonValue | None = None
    search: JsonValue | None = None
    filters: JsonValue | None = None


class ConformanceStepObserve(WireModel, frozen=True, extra="forbid"):
    """
    Live: an observer, named by `as`, begins observing a live query.
    """

    observe: ConformanceStepObserveObserve
    as_: Annotated[str, Field(alias="as", description="The observer.")]


class ConformanceStepLeave(WireModel, frozen=True, extra="forbid"):
    """
    Live: the observer stops observing.
    """

    leave: Annotated[str, Field(description="The observer.")]


class ConformanceStepReaches(WireModel, frozen=True, extra="forbid"):
    """
    Live: the observer comes to hold this state.
    """

    reaches: Annotated[str, Field(description="The observer.")]
    state: JsonValue


class ConformanceStepHolds(WireModel, frozen=True, extra="forbid"):
    """
    Live: the state the observer holds now is this one.
    """

    holds: Annotated[str, Field(description="The observer.")]
    state: JsonValue


class ConformanceStepCompletes(WireModel, frozen=True, extra="forbid"):
    """
    Live: the observer's live query completes.
    """

    completes: Annotated[str, Field(description="The observer.")]


class ConformanceHttpFetch(WireModel, frozen=True, extra="forbid"):
    """
    A read over HTTP a live case expects the client to make: an operation of the gateway's API by its method and path, with the values its path carries. The stand-in Archivist answers it from what the case seeded.
    """

    fetch: Annotated[str, Field(description="The operation, by its method and path.")]
    params: JsonValue | None = None


type ConformanceStepFetchesFetchesItem = ConformanceBusFetch | ConformanceHttpFetch


class ConformanceStepFetches(WireModel, frozen=True, extra="forbid"):
    """
    Live: the next requests the client makes of a service are these, in whatever order it makes them.
    """

    fetches: Annotated[list[ConformanceStepFetchesFetchesItem], Field(description="The requests.")]


class ConformanceStepScopes(WireModel, frozen=True, extra="forbid"):
    """
    Live: the client's stream comes to name exactly these scopes.
    """

    scopes: Annotated[list[JsonValue], Field(description="The scopes.")]


class ConformanceStepClaimed(WireModel, frozen=True, extra="forbid"):
    """
    A worker case: the next job the worker reports as claimed, as it read the record.
    """

    claimed: JsonValue


class ConformanceStepRefused(WireModel, frozen=True, extra="forbid"):
    """
    A worker case: the next refusal of a claim the worker reports.
    """

    refused: JsonValue


class ConformanceStepSignalled(WireModel, frozen=True, extra="forbid"):
    """
    A worker case: the next held job whose cancellation the worker says was signalled.
    """

    signalled: JsonValue


class ConformanceStepStalled(WireModel, frozen=True, extra="forbid"):
    """
    A worker case: the next held job the worker says has stalled.
    """

    stalled: JsonValue


type ConformanceStep = Annotated[
    ConformanceStepLet
    | ConformanceStepDriver
    | ConformanceStepAbandon
    | ConformanceStepSettles
    | ConformanceStepWire
    | ConformanceStepCarried
    | ConformanceStepClosed
    | ConformanceStepProgress
    | ConformanceStepState
    | ConformanceStepStays
    | ConformanceStepFrame
    | ConformanceStepFrames
    | ConformanceStepError
    | ConformanceStepBackend
    | ConformanceStepQuiet
    | ConformanceStepObserve
    | ConformanceStepLeave
    | ConformanceStepReaches
    | ConformanceStepHolds
    | ConformanceStepCompletes
    | ConformanceBusFetch
    | ConformanceHttpFetch
    | ConformanceStepFetches
    | ConformanceStepScopes
    | ConformanceStepClaimed
    | ConformanceStepRefused
    | ConformanceStepSignalled
    | ConformanceStepStalled,
    Field(
        description='One step of a case of the conformance corpus (ConformanceCase.json): each is told apart by the member only it requires. conformance/sdk/README.md, "A case", says what each does.'
    ),
]


class ConformanceCase(WireModel, frozen=True, extra="forbid"):
    """
    One case of the conformance corpus: a scenario every SDK's driver is put through, a JSON file of conformance/sdk/wire, conformance/sdk/live or conformance/worker/cases named by the case. What the client is asked to do, what the backend does around it, and the transcript a conforming client produces. conformance/sdk/README.md explains each step; the reader reads every file of the corpus through this schema.
    """

    about: Annotated[str, Field(description="What the case holds a client to, in a sentence.")]
    source: Annotated[str, Field(description="Where the protocol or the spec states it.")]
    planes: Annotated[
        list[ConformanceCasePlanesItem] | None, Field(description="The signal planes the case runs on. Absent, it runs on both.")
    ] = None
    tier: ConformanceCaseTier | None = None
    telemetry: Annotated[
        Literal[True] | None,
        Field(
            description="Run the client exporting to an OTLP receiver, and once it has exited hold what it exported to specs/src/sdk-telemetry/telemetry.json. A worker case also holds the worker to a trace of its own for each job it ran (conformance/worker/README.md)."
        ),
    ] = None
    steps: Annotated[list[ConformanceStep], Field(description="The steps, run in order.")]


class ConformanceDriverLineReady(WireModel, frozen=True, extra="forbid"):
    """
    The driver can take operations.
    """

    ready: Annotated[Literal[True], Field(description="Written once.")]


class ConformanceDriverLineOk(WireModel, frozen=True, extra="forbid"):
    """
    The operation succeeded.
    """

    id: Annotated[int, Field(description="The operation's id.")]
    ok: JsonValue


type FailureClass = Annotated[
    Literal["transient", "deterministic", "withheld"],
    Field(
        description="The class of a job's failure, stated by the worker, where the failure is still typed: at the gateway it is already text, and classing a failure by its text is what this exists to avoid. A job no worker concluded, because its worker stopped reporting, is classed by the dispatcher, as 'transient'. Each value is a claim. 'transient': nothing about the request was judged (the worker's own bound ran out, the provider said not now), so another attempt may succeed. 'deterministic': the same request cannot succeed on a second attempt. 'withheld': the model's provider had the request and withheld its answer, by a refusal or a content filter, and the same request is withheld again; nothing broke. A 'deterministic' or a 'withheld' failure is not retried, whatever retry budget is left. ABSENT means the failure was not classified, which is not the claim 'transient' makes; it is retried as a transient one is. Only a failure known to be deterministic or withheld is called so: calling a transient failure either one halves reliability, where the reverse costs one wasted attempt."
    ),
]


class ConformanceFailure(WireModel, frozen=True, extra="forbid"):
    """
    A failure as an SDK reports it to the suite (conformance/sdk/README.md, "The driver protocol"): its code, the status when a server stated one, and a job failure's class when it has one; and the SDK's own words for it.
    """

    code: Annotated[str | None, Field(description="The SDK's code for it, from specs/src/errors/codes.json.")] = None
    status: Annotated[int | None, Field(description="The HTTP status, when a server stated one.")] = None
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass", description="A job failure's class, when it has one.")] = None
    detail: Annotated[str, Field(description="The SDK's words, for a person; nothing compares it.")]


class ConformanceDriverLineFailed(WireModel, frozen=True, extra="forbid"):
    """
    The SDK failed the operation.
    """

    id: Annotated[int, Field(description="The operation's id.")]
    error: Annotated[ConformanceFailure, Field(description="The failure.")]


class ConformanceDriverLineAbandoned(WireModel, frozen=True, extra="forbid"):
    """
    The suite abandoned the operation, and the SDK reported nothing else.
    """

    id: Annotated[int, Field(description="The operation's id.")]
    abandoned: Annotated[Literal[True], Field(description="It was abandoned.")]


class ConformanceDriverLineUnsupported(WireModel, frozen=True, extra="forbid"):
    """
    The driver has no such operation. It says so at once, before it reads its next operation.
    """

    id: Annotated[int, Field(description="The operation's id.")]
    unsupported: Annotated[Literal[True], Field(description="It has none.")]


class ConformanceDriverLineMisuse(WireModel, frozen=True, extra="forbid"):
    """
    The suite's arguments made no sense: the suite's mistake, never the SDK's.
    """

    id: Annotated[int, Field(description="The operation's id.")]
    misuse: Annotated[str, Field(description="What made no sense.")]


class ConformanceDriverLineState(WireModel, frozen=True, extra="forbid"):
    """
    The transport's connection state changed.
    """

    state: Annotated[
        str,
        Field(
            description="The state it is in now: one a case's `state` step names (ConformanceStep.json), or another the case never waits for."
        ),
    ]


class ConformanceDriverLineFrameFrame(WireModel, frozen=True, extra="forbid"):
    """
    The frame.
    """

    channel: Annotated[str, Field(description="The channel.")]
    payload: JsonValue | None = None
    correlation_id: Annotated[str | None, Field(alias="correlationId", description="The frame's correlation id, when it has one.")] = None
    scope: Annotated[ResourceId | None, Field(description="The frame's scope, when it has one.")] = None


class ConformanceDriverLineFrame(WireModel, frozen=True, extra="forbid"):
    """
    A frame was delivered on a channel the driver listens to.
    """

    frame: ConformanceDriverLineFrameFrame


class ConformanceDriverLineErrorStream(WireModel, frozen=True, extra="forbid"):
    """
    The error stream carried a failure.
    """

    error: Annotated[ConformanceFailure, Field(description="The failure.")]


class ConformanceDriverLineProgressProgress(WireModel, frozen=True, extra="forbid"):
    """
    The report.
    """

    upload: Annotated[int, Field(description="The `upload` operation's id.")]
    bytes_uploaded: Annotated[int, Field(alias="bytesUploaded", description="How many bytes it has sent.")]
    total_bytes: Annotated[
        int | None, Field(alias="totalBytes", description="How many it will send. Absent for an upload whose source states no length.")
    ] = None


class ConformanceDriverLineProgress(WireModel, frozen=True, extra="forbid"):
    """
    An upload reported how much of it has been sent.
    """

    progress: ConformanceDriverLineProgressProgress


class ConformanceDriverLineEmissionEmissionStatePending(WireModel, frozen=True, extra="forbid"):
    status: Annotated[Literal["pending"], Field(description="Nothing to show yet.")]


class ConformanceDriverLineEmissionEmissionStateReady(WireModel, frozen=True, extra="forbid"):
    status: Annotated[Literal["ready"], Field(description="A value to show.")]
    value: JsonValue


class ConformanceDriverLineEmissionEmissionStateFailed(WireModel, frozen=True, extra="forbid"):
    status: Annotated[Literal["failed"], Field(description="The query failed.")]
    error: Annotated[ConformanceFailure, Field(description="The failure.")]


class ConformanceDriverLineEmissionEmission(WireModel, frozen=True, extra="forbid"):
    """
    The emission.
    """

    observer: Annotated[str, Field(description="The observer.")]
    state: Annotated[
        ConformanceDriverLineEmissionEmissionStatePending
        | ConformanceDriverLineEmissionEmissionStateReady
        | ConformanceDriverLineEmissionEmissionStateFailed,
        Field(description="The state."),
    ]


class ConformanceDriverLineEmission(WireModel, frozen=True, extra="forbid"):
    """
    The live driver: an observer was given a state.
    """

    emission: ConformanceDriverLineEmissionEmission


class ConformanceDriverLineCompleted(WireModel, frozen=True, extra="forbid"):
    """
    The live driver: the observer's live query completed.
    """

    completed: Annotated[str, Field(description="The observer.")]


type JobType = Annotated[
    Literal["mark", "yield"],
    Field(
        description="What a job does, as the verb that asks for it: `mark` annotates a resource, `yield` makes one. A job description is its `jobType` and the parameters that verb takes; a `mark` job's parameters state its motivation."
    ),
]


class JobParams(WireModel, frozen=True, extra="allow"):
    """
    A job's parameters as the Dispatcher holds them: the `params` of its `job:create`, and what the Dispatcher adds. It adds `resourceId`, the resource the job is about: a `mark` job's own, and for a `yield` job the one its context focuses on. For a tagging job it adds `schema`, the tag schema its `schemaId` names, so that whoever holds the job needs no registry. Nothing the caller sent is changed or removed.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    schema_: Annotated[
        TagSchema | None,
        Field(
            alias="schema",
            description="The tag schema a tagging job's `schemaId` names, as the knowledge base registered it when the job was created. On a tagging job, and on no other.",
        ),
    ] = None


class UnitCursor(WireModel, frozen=True):
    """
    The furthest a single unit got, and what it had counted when it got there. A unit left partway is resumed from its cursor rather than redone. A finished unit keeps its cursor: `next` at the length of the text, `size` the size its last piece was cut at, and its final `found`, `emitted` and `errors`, so that an attempt that skips the unit still counts it. A cursor never says a unit is finished, wherever it stands: `completedUnits` does. A unit is an entity type for a linking job, a category for a tagging job, and the job's own motivation for every other — which is why a unit-grain checkpoint alone is too coarse: those three have exactly one unit, so nothing could be recorded until the whole document was done.

    MERGE IS MONOTONE PER UNIT, not a union. `completedUnits` is a set and converges under concurrent snapshots because a set only grows; a cursor converges only if a stale snapshot can never move it backward.

    IT CARRIES THE UNIT'S RUNNING TALLIES TOO, and they are required. A resumed unit counts only the chunks it actually runs, so without them a retry's terminal record reports the remainder of the document as if it were the whole — measured at a `found` of 19 where the document yielded 25. The position and the tallies are ONE observation of the same committed chunk; splitting them would let a resume take the saving and still report a number nobody can trust.
    """

    next: Annotated[
        int,
        Field(
            description="Unicode code points of the text consumed once the last COMMITTED chunk completed — the resume position, and the length of the text for a unit whose last chunk it was. Deliberately the chunk's `next`, never its `at`: the checkpoint must not lead the log, so it records where a chunk that is already durable ended, not where the in-flight one began. Recording `at` would make a resume re-run the chunk it already paid for."
        ),
    ]
    size: Annotated[
        int,
        Field(
            description="The token size that last committed chunk was cut at — the calibration the attempt paid for over the chunks before it. A resume seeds from this and then takes ONE adaptive step, as if the last outcome were a failure, which it was: the job died. Seeding alone would re-cut the failing piece identically; opening at the default would discard the calibration."
        ),
    ]
    found: Annotated[
        int,
        Field(
            description="Items detection has returned for this unit through the last committed chunk — the numerator a resumed attempt continues from rather than restarting at zero. Counts what the model reported, before dedupe."
        ),
    ]
    emitted: Annotated[
        int,
        Field(
            description="Annotations actually committed for this unit through the last committed chunk, after dedupe. With `found` and `errors` it is what the job's terminal result reports, so a resumed unit seeds all three and its record describes the whole document rather than one attempt's share."
        ),
    ]
    errors: Annotated[
        int,
        Field(
            description="Items detection returned for this unit through the last committed chunk that could not be anchored in the text. Carried with the other two tallies so that a resumed job reports the whole document's, and not only its last attempt's."
        ),
    ]


class HeldJobRecord(WireModel, frozen=True, extra="forbid"):
    """
    The job a worker holds, as its claim hands it: read from the `JobRunning` that `job:claimed` carries, its metadata's id, type, units, cursors and retries, and its params with the resource they name. A unit the job has not reached is no member of `completedUnits` and no key of `unitCursors`.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    params: JobParams
    completed_units: Annotated[
        list[str],
        Field(alias="completedUnits", description="The units a worker has finished, merged across checkpoints and failures as a set."),
    ]
    unit_cursors: Annotated[
        dict[str, UnitCursor],
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.",
        ),
    ]
    retry_count: Annotated[int, Field(alias="retryCount")]
    max_retries: Annotated[
        int,
        Field(
            alias="maxRetries",
            description="How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.",
        ),
    ]


class ConformanceDriverLineClaimed(WireModel, frozen=True, extra="forbid"):
    """
    A worker driver: its worker claimed a job.
    """

    claimed: Annotated[HeldJobRecord, Field(description="The job, as the worker read the record.")]


class ConformanceDriverLineRefused(WireModel, frozen=True, extra="forbid"):
    """
    A worker driver: a claim was refused.
    """

    refused: Annotated[
        ConformanceFailure, Field(description="The refusal: with a code when the bus refused it, with none when the worker did.")
    ]


class ConformanceDriverLineSignalled(WireModel, frozen=True, extra="forbid"):
    """
    A worker driver: a held job's cancellation was signalled.
    """

    signalled: Annotated[str, Field(description="The job's id.")]


class ConformanceDriverLineStalled(WireModel, frozen=True, extra="forbid"):
    """
    A worker driver: a held job stalled.
    """

    stalled: Annotated[str, Field(description="The job's id.")]


type ConformanceDriverLine = Annotated[
    ConformanceDriverLineReady
    | ConformanceDriverLineOk
    | ConformanceDriverLineFailed
    | ConformanceDriverLineAbandoned
    | ConformanceDriverLineUnsupported
    | ConformanceDriverLineMisuse
    | ConformanceDriverLineState
    | ConformanceDriverLineFrame
    | ConformanceDriverLineErrorStream
    | ConformanceDriverLineProgress
    | ConformanceDriverLineEmission
    | ConformanceDriverLineCompleted
    | ConformanceDriverLineClaimed
    | ConformanceDriverLineRefused
    | ConformanceDriverLineSignalled
    | ConformanceDriverLineStalled,
    Field(
        description='A line a conformance driver writes on its standard output, one JSON object each (conformance/sdk/README.md, "The driver protocol"; conformance/worker/README.md, "The worker driver"): that it is ready, an operation\'s outcome, or what its client observed as it happened. The suite refuses any other line.'
    ),
]


class LocalTarget(WireModel, frozen=True, extra="forbid"):
    """
    A local knowledge base, named explicitly: the operations that act on one local stack and never resolve one for the caller (identity administration, a service's run).
    """

    kind: Annotated[Literal["local"], Field(description="Only a local stack.")]
    root: Annotated[str, Field(description="The knowledge base's clone, by its path.")]


type ConformanceImplementationsSdksValueLiveTier = Annotated[
    Literal["fleet", "parity"],
    Field(
        description="A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does."
    ),
]


class ConformanceImplementationsSdksValueLive(WireModel, frozen=True, extra="forbid"):
    """
    How its live driver is started, and the tier of the live corpus the SDK is held to.
    """

    command: Annotated[
        list[str],
        Field(
            description="How its live driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written."
        ),
    ]
    tier: ConformanceImplementationsSdksValueLiveTier


class ConformanceImplementationsSdksValue(WireModel, frozen=True, extra="forbid"):
    """
    One SDK's drivers.
    """

    wire: Annotated[
        list[str] | None,
        Field(
            description="How its wire driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written."
        ),
    ] = None
    live: ConformanceImplementationsSdksValueLive | None = None
    worker: Annotated[
        list[str] | None,
        Field(
            description="How its worker driver is started, when the SDK has a worker's surface (conformance/worker/README.md). A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written."
        ),
    ] = None
    exempt: Annotated[
        dict[str, str] | None,
        Field(
            description="The wire cases its driver cannot be put through, by the case's name, each with why. The suite holds an exemption as it holds a case: the driver must answer unsupported to what the case asks, or the exemption is stale."
        ),
    ] = None


class ConformanceImplementations(WireModel, frozen=True, extra="forbid"):
    """
    The implementations manifest: the file a run of the conformance harness is given with --implementations, naming what the run holds to Protocol. Every service is run by the xynolog launcher, from the image the knowledge base's stack documents name (contract/LAUNCHER-CONTROL.md, service.run): an implementation is a knowledge base whose documents name its images, and another implementation is another manifest. Each SDK's drivers are programs the harness starts itself, since none is a service. There is no default manifest. The reader reads this schema in the table dialect and derives its model (Tables.Conformance_implementations), for the harness to decode a manifest by.
    """

    launcher: Annotated[
        list[str],
        Field(
            description="How the launcher's control API is served: the xynolog command, run with control. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written."
        ),
    ]
    target: Annotated[
        LocalTarget,
        Field(
            description="The knowledge base whose stack documents name each service's image, and whose stack runs the record and index the suites need. A relative root is resolved against the manifest's own directory."
        ),
    ]
    sdks: Annotated[
        dict[str, ConformanceImplementationsSdksValue],
        Field(
            description="Each SDK's drivers, by the SDK's name: the programs the SDK and worker suites talk to in its place (conformance/sdk/README.md, \"The driver protocol\")."
        ),
    ]
    model_catalogue: Annotated[
        str | None,
        Field(
            alias="modelCatalogue",
            description="The model catalogue the implementation supplies, by its path; a relative one is resolved against the manifest's own directory. The Librarian's and the worker service's documents name one, so a run of either suite without it refuses to start.",
        ),
    ] = None


class ConnectionIdentity(WireModel, frozen=True, extra="forbid"):
    """
    Who the knowledge base at an address says it is, asked with a token just issued, before any entry is made for it.
    """

    did: Annotated[UserId, Field(description="The did it reports for itself.")]
    description: Annotated[KbDescription, Field(description="What it says of itself.")]


type ContentFormat = Annotated[
    str,
    Field(
        description="Content format as a MIME type, optionally with parameters. The base type (everything before the first ';') MUST be a SupportedMediaType; parameters such as charset are preserved as metadata. Semantic validation happens in code at the create/yield boundary — there is deliberately no pattern here, the vocabulary lives in SupportedMediaType. Examples: text/plain, text/plain; charset=iso-8859-1, text/markdown; charset=windows-1252, image/png, application/pdf"
    ),
]


class ContextualSummaryResponseRelevantFields(WireModel, frozen=True, extra="forbid"):
    """
    What the summary is of: the resource the annotation is on, and the annotation's entity types.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    resource_name: Annotated[str, Field(alias="resourceName")]
    entity_types: Annotated[list[str], Field(alias="entityTypes")]


class ContextualSummaryResponseContext(WireModel, frozen=True):
    before: str | None = None
    selected: str
    after: str | None = None


class ContextualSummaryResponse(WireModel, frozen=True):
    summary: str
    relevant_fields: Annotated[ContextualSummaryResponseRelevantFields, Field(alias="relevantFields")]
    context: ContextualSummaryResponseContext


type ControlSender = Annotated[
    Literal["client", "launcher"],
    Field(
        description="Which side of the control API sends a message: the client, whose notifications arrive on the launcher's stdin, or the launcher, whose notifications leave on its stdout (LAUNCHER-CONTROL.md F1)."
    ),
]


class CreateAnnotationRequest(WireModel, frozen=True):
    motivation: Motivation
    target: AnnotationTarget
    body: Annotated[
        AnnotationBodies | None,
        Field(
            description="Optional body. Omit for annotations whose motivation alone is meaningful (highlighting) or whose user-supplied content is empty. Shape matches Annotation.body."
        ),
    ] = None


class CreateFromTokenOptions(WireModel, frozen=True, extra="forbid"):
    """
    What creating a resource from a clone token is told: the token, the clone's name and text, and whether the source is archived once the clone exists.
    """

    token: str
    name: str
    content: Annotated[str, Field(description="The clone's text, uploaded as its content.")]
    archive_original: Annotated[bool | None, Field(alias="archiveOriginal")] = None


class CreateResourceResponse(WireModel, frozen=True):
    """
    The id of the resource an upload created. The Archivist answers it (200) once it has stored the bytes and recorded the resource, and the gateway forwards it (202), so the id is the one the record minted and its creation event is persisted. What remains asynchronous is downstream projection: graph, views and vectors settle afterwards.
    """

    resource_id: Annotated[
        ResourceId, Field(alias="resourceId", description="The id of the newly created resource, as the record minted it.")
    ]


type CursorsPath = Annotated[
    str,
    Field(
        description="The file a follower of the record keeps its cursors in: for each log of the record it follows, the sequence number of the last event of it taken (contract/TRANSPORT-CONTRACT.md § What repairs a passing frame). A file of the service's own disk, never of the knowledge base: a service that finds none starts each log as it starts one with no cursor, so losing it costs time and never correctness."
    ),
]


class DeviceCode(WireModel, frozen=True, extra="forbid"):
    """
    What a device-authorization grant (RFC 8628) shows the person signing in: the code they enter, and where.
    """

    user_code: Annotated[str, Field(alias="userCode", description="The code the person enters at the issuer.")]
    verification_uri: Annotated[str, Field(alias="verificationUri", description="Where the person enters it.")]
    verification_uri_complete: Annotated[
        str | None,
        Field(
            alias="verificationUriComplete",
            description="Where the person goes to sign in with the code already entered, when the issuer gives one.",
        ),
    ] = None
    expires_in: Annotated[int, Field(alias="expiresIn", description="How many seconds the code stays good for.")]


class DiscoveredKB(WireModel, frozen=True):
    """
    One knowledge base the Xynolog launcher manages on this machine, as published in the discovery document (see DiscoveryDocument). Endpoints and identity only — never credentials; login remains the consumer's per-KB business.
    """

    host: Annotated[
        str,
        Field(
            description='Hostname the KB is reachable on from this machine (always "localhost" — local stacks bind locally and codespace KBs arrive through a local port forward)'
        ),
    ]
    port: Annotated[
        int,
        Field(
            description="Local TCP port of the KB's API (the gateway port for a local stack; the allocated forward port for a codespace stack)"
        ),
    ]
    placement: Annotated[
        KbPlacement,
        Field(
            description='Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here.'
        ),
    ]
    repo: Annotated[
        str | None, Field(description="owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity")
    ] = None
    did: Annotated[
        str,
        Field(
            description='The KB\'s did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.'
        ),
    ]
    site_name: Annotated[
        str | None,
        Field(alias="siteName", description="Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display"),
    ] = None
    managed_by: Annotated[
        str,
        Field(
            alias="managedBy",
            description='The agent that owns this entry\'s lifecycle (the launcher writes "xynolog-launcher"). Consumers treat managed entries as authoritative for themselves — upsert on appearance, remove on disappearance — and never touch entries they did not write.',
        ),
    ]


type DiscoveryAbsentReason = Annotated[
    Literal["not-found", "not-json", "invalid", "unsupported-version", "unreadable"],
    Field(
        description="Why a client that read a launcher's discovery document found no launcher: one of the reasons of client/discovery-absent.json, which says what each means."
    ),
]


class DiscoveryAbsent(WireModel, frozen=True, extra="forbid"):
    """
    No launcher was found, and why.
    """

    kind: Literal["absent"]
    reason: Annotated[DiscoveryAbsentReason, Field(description="Why.")]
    diagnostic: Annotated[str | None, Field(description="What was wrong, in words, when there is more to say.")] = None


class DiscoveryManaged(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge bases a launcher manages: none is a launcher that manages nothing.
    """

    kind: Literal["managed"]
    kbs: Annotated[list[DiscoveredKB], Field(description="Each knowledge base, as the document lists it.")]


type DiscoveryState = Annotated[
    DiscoveryAbsent | DiscoveryManaged,
    Field(
        description="What a launcher's discovery document says, told apart by `kind`: no launcher was found, or the knowledge bases one manages. A launcher that manages none is not an absent one.",
        discriminator="kind",
    ),
]


class DiscoveryDiff(WireModel, frozen=True, extra="forbid"):
    """
    How one poll's knowledge bases changed since the last state it gave.
    """

    state: Annotated[DiscoveryState, Field(description="The state the poll found.")]
    added: Annotated[list[DiscoveredKB], Field(description="Each knowledge base the last state did not have.")]
    updated: Annotated[list[DiscoveredKB], Field(description="Each knowledge base the last state had at the same address, now otherwise.")]
    removed: Annotated[list[DiscoveredKB], Field(description="Each knowledge base the last state had, and this one does not.")]
    duplicated: Annotated[
        list[str],
        Field(
            description="Each address, as host:port, that more than one of the state's knowledge bases is at. At most one of them is true: `added` and `removed` count each address once, and every one is in `state`."
        ),
    ]


class DiscoveryDocument(WireModel, frozen=True):
    """
    The launcher's KB discovery document — the schema authority for <stateDir>/discovery/kbs.json, which the Xynolog CLI (xynolog/cli) regenerates on every stack mutation and the Browser container mounts read-only at /discovery. NOT an API endpoint: a static document fetched same-origin by browsers (via the Browser's static server). An empty kbs list is meaningful ("the launcher manages nothing right now") and distinct from an absent file.
    """

    version: Annotated[
        Literal[1], Field(description="Document schema version. Consumers MUST check it and ignore documents they do not understand.")
    ]
    kbs: Annotated[list[DiscoveredKB], Field(description="Every KB the launcher currently manages, local and forwarded")]


class DiscoveryUnchanged(WireModel, frozen=True, extra="forbid"):
    """
    Nothing changed since the last read of a launcher's discovery document.
    """

    kind: Literal["unchanged"]


type DiscoveryRead = Annotated[
    DiscoveryAbsent | DiscoveryManaged | DiscoveryUnchanged,
    Field(
        description="What one read of a launcher's discovery document gave: a DiscoveryState's absent or managed, or that nothing changed since the last read. Told apart by `kind`, as DiscoveryState's are.",
        discriminator="kind",
    ),
]


class KbIdentity(WireModel, frozen=True, extra="forbid"):
    """
    A knowledge base's committed identity (`project.name` and `site.domain` in its .xynolog/config.yaml), as a service's document names the knowledge base it serves. Its telemetry names it by its DID (`xynolog.kb`, specs/src/service-telemetry/telemetry.json).
    """

    name: Annotated[str, Field(description="Its name. The gateway publishes it as its resource metadata's `resource_name`.")]
    domain: Annotated[
        str,
        Field(
            description="Its did:web domain: its permanent identity, the source of the audience its tokens must carry, and the authority its people and agents are named under."
        ),
    ]


class DispatcherConfigQueue(WireModel, frozen=True, extra="forbid"):
    """
    The JetStream broker holding the job queue, whose layout is specs/src/jobs/storage.json.
    """

    servers: Annotated[str, Field(description="The broker's address (`host:port`, or several, comma-separated).")]
    user_env: Annotated[
        str | None, Field(alias="userEnv", description="The environment variable holding the broker user, when the broker requires one.")
    ] = None
    password_env: Annotated[
        str | None,
        Field(alias="passwordEnv", description="The environment variable holding the broker password, when the broker requires one."),
    ] = None


class DispatcherConfigTiming(WireModel, frozen=True, extra="forbid"):
    """
    The queue's clocks, in milliseconds. The launcher writes the values a deployment runs with; a test harness shrinks them.
    """

    tick_ms: Annotated[
        int,
        Field(
            alias="tickMs",
            description="How often the queue re-announces pending jobs and sweeps for dead workers. The re-announcement is insurance against a lost wake-up, not dispatch.",
        ),
    ]
    stale_running_ms: Annotated[
        int,
        Field(
            alias="staleRunningMs",
            description="How long a running job may go without progress, a checkpoint or a claim before its worker is presumed dead.",
        ),
    ]
    ack_wait_ms: Annotated[
        int,
        Field(
            alias="ackWaitMs",
            description="How long the broker waits, after this dispatcher stops renewing a job's lease, before redelivering its message.",
        ),
    ]
    retention_ms: Annotated[int, Field(alias="retentionMs", description="How long a concluded job is kept before it is deleted.")]
    retention_sweep_ms: Annotated[
        int, Field(alias="retentionSweepMs", description="How often concluded jobs past `retentionMs` are deleted.")
    ]
    progress_write_interval_ms: Annotated[
        int,
        Field(
            alias="progressWriteIntervalMs",
            description="The least time between two progress writes for one job; reports closer together than this are not written.",
        ),
    ]
    boot_deadline_ms: Annotated[
        int,
        Field(
            alias="bootDeadlineMs",
            description="How long the dispatcher waits at boot for the broker before it exits, so that a restart policy can retry.",
        ),
    ]


class DispatcherConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything the dispatcher reads at boot: nothing in it is defaulted by the dispatcher. The launcher writes it for the dispatcher it starts, from the knowledge base's stack documents, and the dispatcher reads it from the path its `--config` flag names (its image passes `/etc/xynolog/dispatcher.json`). Started without `--config`, or with a path that names no file, the dispatcher refuses to start and says which. Secrets are never values here: a field that needs one names the environment variable holding it. The dispatcher's other inputs are the environment variables specs/src/service-environment/variables.json lists for it, and the ones this document names. A document that does not validate is refused at boot, naming each failing field.
    """

    kb: KbIdentity
    gateway_url: Annotated[
        str, Field(alias="gatewayUrl", description="The URL the dispatcher reaches the gateway at: its only route to the bus.")
    ]
    identity: Annotated[ServiceIdentity, Field(description="The issuer the dispatcher's service account signs in at.")]
    queue: DispatcherConfigQueue
    port: Annotated[int, Field(description="The port the dispatcher answers `/health` on.")]
    timing: DispatcherConfigTiming
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


class DispatcherHealth(WireModel, frozen=True, extra="forbid"):
    """
    The dispatcher's liveness answer. It answers only once its queue has connected and its bus pumps are attached, so a 200 means it can take work.
    """

    status: Literal["ok"]
    queue: Annotated[Literal["jetstream"], Field(description="The queue it holds.")]


type DispatcherMessagesRefusalsItemCode = Annotated[
    Literal["peer-unavailable", "not-found", "unauthorized", "none-pending"],
    Field(
        description="Machine-readable failure class, for consumers that must BRANCH on why a command failed rather than log it. Optional and deliberately sparse: absent means 'no class declared', and every existing failure stays that way. An enum rather than a free string so the vocabulary has an owner — an unconstrained code is a mirror with no gate, and adding one should be a deliberate spec change. `message` remains the human-readable text and is unaffected. Members: `peer-unavailable` — the channel this command was sent on has no subscriber, i.e. the service that answers it has not connected yet. Transient by nature (a peer still starting), which is what distinguishes it from a refusal: retrying is the correct response. `not-found` — the resource this command addressed does not exist in this knowledge base. A verdict, not a symptom: it is emitted only where the answer comes from the event store, which is the system of record, and never from a projection that may merely be lagging. Deterministic, so unlike `peer-unavailable` retrying is pointless — and consumers may act destructively on it (the SDK deletes a restored tab). Absence is not denial: a future 'exists, but not for you' must travel as its own code, never as this one. `unauthorized` — that code: the caller is authenticated but not permitted to do what it asked. A verdict about the CALLER, not the resource, so retrying under the same credential cannot succeed and a consumer must never spin on it; emitted by `job:claim` for a caller whose token carries no worker role. `none-pending` — a declined claim, not an error: the queue holds no pending job of the requested types. Nothing went wrong; the one code a consumer PARKS on, meaning 'nothing to do until a wake-up'. Emitted by `job:claim` only. A `job:claim` refusal carrying neither is unclassified — a malformed record or a missing injection — and a consumer treats it as 'log it, assume nothing'."
    ),
]


class DispatcherMessagesRefusalsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    operation: Annotated[
        str, Field(description="The operation it refuses: a request of bus/registry.json's operations that the dispatcher answers.")
    ]
    code: DispatcherMessagesRefusalsItemCode | None = None
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    message: Annotated[
        str,
        Field(
            description="The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class DispatcherMessagesErrorsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    error: Annotated[
        str,
        Field(
            description="The `error` it writes into the job. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]
    failure_class: Annotated[FailureClass, Field(alias="failureClass")]


class DispatcherMessages(WireModel, frozen=True, extra="forbid"):
    """
    dispatcher/messages.json: the words of the dispatcher's own refusals, and of the errors it writes into a job.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    refusals: Annotated[
        list[DispatcherMessagesRefusalsItem],
        Field(description="Each refusal the dispatcher makes itself, on the operation's failure channel."),
    ]
    errors: Annotated[
        list[DispatcherMessagesErrorsItem],
        Field(description="Each error the dispatcher writes into a job on its own, as a `job:fail` would."),
    ]


type DurabilityEvidence = Annotated[
    Literal["acknowledged", "probe-confirmed", "probe-refused", "probe-unreachable"],
    Field(
        description="How a job's annotations were established as durable — the OBSERVATION, never a conclusion drawn from it. 'acknowledged': the event log confirmed the batch (mark:commit-ok). 'probe-confirmed': the acknowledgement was lost and a later read found the batch's last annotation present — true, but a weaker claim than an ack, since it rests on the log appending a batch in order and stopping at the first failure. 'probe-refused': the read returned a failure reply; note this does NOT assert the annotations are absent, because a read that failed for its own reasons answers on the same channel. 'probe-unreachable': no answer came at all, so nothing was established either way. ABSENT means the question never arose — a job that committed no annotations. Never defaulted: a manufactured value here is a claim nobody made, in a log nobody can rewrite."
    ),
]


class OllamaEmbeddingConfig(WireModel, frozen=True, extra="forbid"):
    """
    An embedding model served by an Ollama.
    """

    type: Literal["ollama"]
    model: Annotated[str, Field(description="The model asked for, by the name the Ollama serves it under.")]
    base_url: Annotated[str, Field(alias="baseUrl", description="The address the Ollama's API is reached at (`http://host:11434`).")]


class VoyageEmbeddingConfig(WireModel, frozen=True, extra="forbid"):
    """
    An embedding model served by Voyage AI. No service has been run against Voyage itself.
    """

    type: Literal["voyage"]
    model: Annotated[str, Field(description="The model asked for, by Voyage's name for it.")]
    endpoint: Annotated[str, Field(description="The whole address of Voyage's embeddings call (`https://api.voyageai.com/v1/embeddings`).")]
    api_key_env: Annotated[
        str, Field(alias="apiKeyEnv", description="The environment variable holding the Voyage API key. The key is never a value here.")
    ]


type EmbeddingConfig = Annotated[
    OllamaEmbeddingConfig | VoyageEmbeddingConfig,
    Field(
        description="The embedding provider a service asks for vectors, and what that kind of provider needs to be asked: one of the providers `xynolog-vectors` has, told apart by `type`. Two services that share an index name the same provider and the same model: a vector is compared only with vectors of the model that made it. A secret is never a value here: a provider's key is named by the environment variable that holds it.",
        discriminator="type",
    ),
]


class EmbeddingRequestsProvidersValue(WireModel, frozen=True, extra="forbid"):
    texts_per_request: Annotated[
        int,
        Field(
            alias="textsPerRequest",
            description="How many texts one request carries, at most: a batch is cut into slices of this many, each one request, in the order of the texts.",
        ),
    ]
    at_once: Annotated[
        int,
        Field(alias="atOnce", description="How many requests are made of the provider at once, however many resources are being indexed."),
    ]


class EmbeddingRequestsBusy(WireModel, frozen=True, extra="forbid"):
    """
    A request for the vectors of documents that the provider answers busy is asked again, after each wait in turn, while the request's own time allows the wait. A provider busy at every asking fails the request with that status. A query is asked once.
    """

    statuses: Annotated[list[int], Field(description="The statuses by which a provider says it is busy.")]
    again_after_seconds: Annotated[list[int], Field(alias="againAfterSeconds", description="The wait before each asking again, in order.")]


class EmbeddingRequests(WireModel, frozen=True, extra="forbid"):
    """
    embedding/requests.json: how a service asks its embedding provider for the vectors of many texts.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    providers: Annotated[
        dict[str, EmbeddingRequestsProvidersValue],
        Field(description="How each kind of provider is asked, by its `type` (EmbeddingConfig): every kind, and no other."),
    ]
    request_seconds: Annotated[
        int,
        Field(
            alias="requestSeconds",
            description="How long each request has, counted from when it is sent and not from when its batch began. Asking a busy provider again is within it.",
        ),
    ]
    busy: EmbeddingRequestsBusy
    start_again: Annotated[
        int,
        Field(
            alias="startAgain",
            description="How many times, at most, a starting service asks again a provider that answered 404, taken to be still fetching the model, or could not be reached, taken to be still starting: within the time the service has to start.",
        ),
    ]


class InferenceLimits(WireModel, frozen=True):
    """
    A provider's actual ceilings for a model, discovered from the provider itself (Anthropic Models API; Ollama /api/show) — never hand-maintained constants. Semantics differ by provider shape: Anthropic reports maximum input tokens in contextTokens with a separate output ceiling in maxOutputTokens; Ollama reports the shared input+output window and mirrors it into both fields (there is no separate output ceiling), so maxOutputTokens === contextTokens signals a shared window.
    """

    context_tokens: Annotated[
        float,
        Field(
            alias="contextTokens",
            description="The context window in tokens. Anthropic: maximum input tokens (output has its own ceiling). Ollama: the shared input+output window.",
        ),
    ]
    max_output_tokens: Annotated[
        float,
        Field(
            alias="maxOutputTokens",
            description="Maximum output tokens per generation. Equal to contextTokens when the provider has a single shared window.",
        ),
    ]
    accepts_temperature: Annotated[
        bool | None,
        Field(
            alias="acceptsTemperature",
            description="Whether this engine accepts a caller-supplied sampling temperature, measured against the provider (Anthropic: an active probe at discovery, because some models reject the parameter outright and the Models API does not say; Ollama: always true). Consumers treat only an explicit false as 'hide temperature controls' — absence means no claim.",
        ),
    ] = None


class EngineLimits(WireModel, frozen=True, extra="forbid"):
    """
    The discovered limits of one engine.
    """

    engine: Engine
    limits: InferenceLimits


class EnrichedResourceEvent(StoredEventResponse, frozen=True):
    """
    Wire format for persisted events delivered over the bus SSE stream (GET /bus/subscribe). Extends StoredEventResponse with optional enrichment fields the EventStore populates from the materialized view at publish time (persistence → view → enrich → notification). Subscribers read the enrichment fields directly to update local caches without an additional fetch.
    """

    annotation: Annotated[
        Annotation | None,
        Field(
            description="Populated for events that mutate an annotation (mark:added, mark:body-updated, mark:removed). Carries the post-materialization annotation as it exists in the view, so subscribers can update local caches in-place without refetching. Absent for events that don't touch annotations."
        ),
    ] = None


class EntityTagChangedPayload(WireModel, frozen=True):
    """
    Payload for mark:entity-tag-added and mark:entity-tag-removed domain events
    """

    entity_type: Annotated[str, Field(alias="entityType")]


class EntityTypeAddedPayload(WireModel, frozen=True):
    """
    Payload for frame:entity-type-added domain event (system-level, no resourceId — fan-out is global)
    """

    entity_type: Annotated[str, Field(alias="entityType")]


class EntityTypesProjection(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's entity-type vocabulary: the file `projections/__system__/entitytypes.json` under the state directory, the sum of the `frame:entity-type-added` events. Written as JSON indented by two spaces.
    """

    entity_types: Annotated[list[str], Field(alias="entityTypes", description="Every entity type added, each once, sorted.")]


class FieldFault(WireModel, frozen=True, extra="forbid"):
    """
    One fault in a request's params, named where it is.
    """

    field: Annotated[
        str, Field(description="Where in the params the fault is, as a JSON pointer (RFC 6901); empty for the params as a whole.")
    ]
    message: Annotated[str, Field(description="What is wrong there.")]


class ErrorData(WireModel, frozen=True, extra="forbid"):
    """
    The data of a control error: the launcher's code for the failure, one of specs/src/errors/codes.json's control group, and what a client can act on. A request's failure is never only a message.
    """

    code: Annotated[
        ControlErrorCode, Field(description="Why the request failed: a code of the control group of specs/src/errors/codes.json.")
    ]
    retryable: Annotated[
        bool,
        Field(
            description="Whether the same request can succeed sent again unchanged, once something outside it changes: a start finishes, a runtime is installed, a stack comes up."
        ),
    ]
    fields: Annotated[list[FieldFault] | None, Field(description="For params the contract refuses: each fault, where it is.")] = None
    choices: Annotated[
        list[Target] | None,
        Field(
            description="For control.target-required and control.target-ambiguous: each target the request could have meant, to send again with one."
        ),
    ] = None
    supported: Annotated[list[str] | None, Field(description="For control.unsupported-api-version: each version this launcher speaks.")] = (
        None
    )
    may_still_run: Annotated[
        bool | None,
        Field(
            alias="mayStillRun",
            description="For a cancelled stack.start: whether services the start launched may still be running. The launcher stops waiting, and stops nothing.",
        ),
    ] = None


class ErrorResponse(WireModel, frozen=True):
    """
    The body of every error the gateway answers, whatever the status and whatever the route — including a path it does not serve.
    """

    error: Annotated[str, Field(description="What went wrong, in a sentence.")]
    code: Annotated[str | None, Field(description="A machine-readable class, when the route defines one.")] = None
    hint: Annotated[str | None, Field(description="What the caller can do about it, when there is something to say.")] = None
    details: JsonValue | None = None


class Expected(WireModel, frozen=True, extra="forbid"):
    """
    What a person believed they were signing in to: the did and the name of the row they clicked, or of the entry they signed in to again.
    """

    did: Annotated[str, Field(description="The did they believed it has.")]
    name: Annotated[str | None, Field(description="The name they believed it has. Absent when they had none.")] = None


type ExtractionOutcome = Annotated[
    ExtractedText | ExtractionDeclined,
    Field(
        description="The full outcome of text extraction for one representation — the record the anchored-text store holds and the wire serves. Discriminated on `kind`: 'extracted' — the anchored text with its provenance; 'declined' — a named decline. ocrConfidence is extraction quality for operators, deliberately not anchor confidence.",
        discriminator="kind",
    ),
]

type FrameRefusalReason = Annotated[
    Literal["lacks", "malformed"],
    Field(
        description="Why a reader refused a frame, for its first fault: `lacks`, a member it lacks; `malformed`, a member that is not of its shape. A reader's rule (specs/src/bus/frame-cases.json)."
    ),
]


class Fault(WireModel, frozen=True, extra="forbid"):
    """
    The first fault a value has as its schema allows: where it is, and why (contract/TRANSPORT-CONTRACT.md § Identity). What a refusal of a frame, a payload or an answer names.
    """

    member: Annotated[
        str,
        Field(
            description="The way from the value to its first fault: the names of the members it is within, and its own, joined by dots; empty for the value itself."
        ),
    ]
    reason: Annotated[FrameRefusalReason, Field(description="Why it is at fault.")]


type FollowerFollowingSweep = Annotated[
    Literal["pending", "running", "done", "due"],
    Field(
        description="The latest sweep's phase: `pending` before its stream first opens, `running`, `done`, or `due` where the record could not be listed and the sweep is tried again."
    ),
]


class FollowerFollowing(WireModel, frozen=True, extra="forbid"):
    """
    How far a follower of the record has followed it, as every follower says it at its health port (WEAVER.md § Health, SMELTER.md § Health).
    """

    sweep: FollowerFollowingSweep
    stopped: Annotated[int, Field(description="How many resources' logs a failed taking has stopped until the next sweep.")]
    refused: Annotated[int, Field(description="How many events it refused as recorded since it started.")]
    stream_drops: Annotated[int, Field(alias="streamDrops", description="How many times its stream has dropped since it started.")]


class FrameAddEntityTypeCommand(WireModel, frozen=True):
    """
    Bus command to add a new entity type to the KB's vocabulary. Carried on the `frame:add-entity-type` channel — Frame is the schema-layer flow that owns vocabulary writes.
    """

    tag: str
    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None


class FrameAddTagSchemaCommand(WireModel, frozen=True):
    """
    Bus command to register a tag schema with the KB's runtime registry. Carried on the `frame:add-tag-schema` channel — Frame is the schema-layer flow that owns vocabulary writes. Most-recent registration of a given `schema.id` wins; the projection reflects the latest content. Identical re-registrations are silent; differing content overwrites and logs a warning.
    """

    schema_: Annotated[TagSchema, Field(alias="schema")]
    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None


class FrameRefusal(WireModel, frozen=True, extra="forbid"):
    """
    A frame refused, given to its readers in its place: by its transport, for its first fault as BusFrame, or by its channel's typed read, for its payload's first fault as its channel's (contract/TRANSPORT-CONTRACT.md § Frames). A transport's own, never on the wire.
    """

    channel: Annotated[str, Field(description="The channel the frame names.")]
    member: Annotated[str, Field(description="The way from the frame to its first fault; a fault of its payload is within `payload`.")]
    reason: Annotated[FrameRefusalReason, Field(description="Why it is at fault.")]
    payload: JsonValue | None = None
    scope: Annotated[ResourceId | None, Field(description="The resource whose scope it was delivered on; absent when it names none.")] = (
        None
    )
    correlation_id: Annotated[
        str | None,
        Field(
            alias="correlationId",
            description="The frame's correlation id, when it carries one BusFrame allows: a request awaiting the reply it names is told of the refusal at once.",
        ),
    ] = None


class GatewayConfigIdentity(WireModel, frozen=True, extra="forbid"):
    """
    The issuer this knowledge base trusts.
    """

    issuer: Annotated[str, Field(description="The issuer URL, exactly as tokens carry it in `iss`.")]
    subject_claim: Annotated[
        str, Field(alias="subjectClaim", description="The claim a person's DID is built from: `did:web:<domain>:users:<its value>`.")
    ]


class ServiceAddress(WireModel, frozen=True, extra="forbid"):
    """
    The host and port a service listens at.
    """

    host: str
    port: int


type GatewayConfigSignalType = Literal["in-process", "nats"]


class GatewayConfigSignal(WireModel, frozen=True, extra="forbid"):
    """
    The signal plane: `in-process`, one gateway on its own fabric; or `nats`, the fabric every replica on one broker shares, which requires `servers` and a broker with JetStream.
    """

    type: GatewayConfigSignalType
    servers: Annotated[
        str | None, Field(description="The broker's address (`host:port`, or several, comma-separated). Required for `nats`.")
    ] = None
    user_env: Annotated[
        str | None, Field(alias="userEnv", description="The environment variable holding the broker user, when the broker requires one.")
    ] = None
    password_env: Annotated[
        str | None,
        Field(alias="passwordEnv", description="The environment variable holding the broker password, when the broker requires one."),
    ] = None


class GatewayConfigCapacity(WireModel, frozen=True, extra="forbid"):
    """
    What this gateway process can hold, from the memory its deployment gives it. `queuedBytes`: the bytes queued for all its streams together; at it, a new stream is refused with 503 (`AtCapacity`, code `capacity`) until the queues drain — each stream's own bound is `x-xynolog-limits.pendingWriteBytes`. `connections`: the connections it holds open at once; one past it is closed unanswered. The launcher derives both from the memory it gives the gateway's container.
    """

    queued_bytes: Annotated[int, Field(alias="queuedBytes")]
    connections: int


class GatewayConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything the gateway reads at boot: nothing in it is defaulted by the gateway. The launcher writes it for the gateway it starts — from the knowledge base's committed identity and its stack documents — and a gateway started any other way is given the same document at the path its `--config` flag names (the image passes `/etc/xynolog/gateway.json`). Started without `--config`, or with a path that names no file, the gateway refuses to start and says which. Secrets are never values here: a field that needs one names the environment variable holding it. The gateway's other inputs are the environment variables specs/src/service-environment/variables.json lists for it, and the ones this document names. A document that does not validate is refused at boot — the gateway exits without serving — and the refusal names each failing field by its JSON pointer.
    """

    kb: KbIdentity
    port: Annotated[int, Field(description="The port the gateway listens on, on every address the host has: IPv4 and IPv6.")]
    public_url: Annotated[
        str,
        Field(
            alias="publicUrl", description="The URL clients reach this gateway at: the `servers` entry of the OpenAPI document it serves."
        ),
    ]
    identity: GatewayConfigIdentity
    archivist: Annotated[ServiceAddress, Field(description="Where the Archivist listens.")]
    signal: GatewayConfigSignal
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]
    capacity: GatewayConfigCapacity


class GatewayMediaTokenHeader(WireModel, frozen=True, extra="forbid"):
    """
    Its JOSE header, exactly.
    """

    alg: Literal["HS256"]
    typ: Literal["JWT"]


class GatewayMediaTokenClaims(WireModel, frozen=True, extra="forbid"):
    """
    Its claims beside `iat` and `exp`, each filled as the table says.
    """

    purpose: Literal["media"]
    iss: Literal["{domain}"]
    sub: Literal["{resourceId}"]


class GatewayMediaToken(WireModel, frozen=True, extra="forbid"):
    """
    gateway/media-token.json: what a media token is.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    header: GatewayMediaTokenHeader
    claims: GatewayMediaTokenClaims
    lifetime_seconds: Annotated[int, Field(alias="lifetimeSeconds", description="`exp` less `iat`.")]


class GatewayMessagesMessagesItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    status: HttpStatus
    code: Annotated[
        str | None,
        Field(
            description="Its `code`, where it carries one: a LimitRefusal's, or the transport code errors/codes.json names for its status."
        ),
    ] = None
    situation: Annotated[str, Field(description="When the gateway answers it, and what fills each `{name}` of its texts.")]
    error: Annotated[
        str, Field(description="Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.")
    ]
    hint: Annotated[str | None, Field(description="Its `hint`, where it carries one.")] = None


class GatewayMessagesFailuresItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    code: Annotated[str, Field(description="Its `code`.")]
    situation: Annotated[str, Field(description="When the gateway answers it, and what fills each `{name}` of its texts.")]
    message: Annotated[
        str, Field(description="Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.")
    ]


class GatewayMessagesChallenges(WireModel, frozen=True, extra="forbid"):
    """
    The `WWW-Authenticate` of a 401.
    """

    no_credential: Annotated[
        str,
        Field(
            alias="noCredential",
            description="For a request that presents no credential. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`.",
        ),
    ]
    refused: Annotated[
        str,
        Field(
            description="For a request whose credential, a bearer token or a media token, is refused. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`."
        ),
    ]


class GatewayMessages(WireModel, frozen=True, extra="forbid"):
    """
    gateway/messages.json: the words of the gateway's own refusals.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    messages: Annotated[list[GatewayMessagesMessagesItem], Field(description="Each refusal the gateway makes itself.")]
    failures: Annotated[
        list[GatewayMessagesFailuresItem],
        Field(description="Each failure frame the gateway delivers itself, on the stream of the client whose request it answers."),
    ]
    challenges: GatewayMessagesChallenges


class GatewayResponseHeadersEveryItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="A header's name, as HTTP spells it; a receiver reads it in any case.")]
    value: Annotated[str, Field(description="Its value, exactly.")]


class GatewayResponseHeadersPreflightHeadersItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="A header's name, as HTTP spells it; a receiver reads it in any case.")]
    value: Annotated[str, Field(description="Its value, exactly.")]


class GatewayResponseHeadersPreflightEchoesItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="A header's name, as HTTP spells it; a receiver reads it in any case.")]
    of: Annotated[str, Field(description="The request's header whose value it carries.")]


class GatewayResponseHeadersPreflight(WireModel, frozen=True, extra="forbid"):
    """
    How the gateway answers an `OPTIONS` request.
    """

    status: HttpStatus
    headers: Annotated[
        list[GatewayResponseHeadersPreflightHeadersItem],
        Field(description="Each header it carries beside those of `every`, and its value."),
    ]
    echoes: Annotated[
        list[GatewayResponseHeadersPreflightEchoesItem],
        Field(description="Each header it carries when the request carries the header it echoes, with that header's value."),
    ]
    vary: Annotated[str, Field(description="The value of the `Vary` it carries when it echoes a header: the request headers it echoes.")]


class GatewayResponseHeaders(WireModel, frozen=True, extra="forbid"):
    """
    gateway/response-headers.json: the headers on every response the gateway sends.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    every: Annotated[list[GatewayResponseHeadersEveryItem], Field(description="Each header every response carries, and its value.")]
    request_id: Annotated[str, Field(alias="requestId", description="The header that names the request.")]
    absent: Annotated[list[str], Field(description="Each header no response carries.")]
    preflight: GatewayResponseHeadersPreflight


class GatheredContextFocusAnnotationSelected(WireModel, frozen=True):
    """
    Text context around the annotation target
    """

    before: Annotated[str | None, Field(description="Text appearing before the selected passage")] = None
    text: Annotated[str, Field(description="The selected text passage (the annotation target)")]
    after: Annotated[str | None, Field(description="Text appearing after the selected passage")] = None


class GatheredContextFocusAnnotationTargetContext(WireModel, frozen=True):
    """
    Context about the annotation's link target. Dormant — produced/exposed but not yet consumed.
    """

    content: str
    summary: str | None = None


class GatheredContextFocusAnnotation(WireModel, frozen=True):
    """
    Annotation-anchored focus.
    """

    kind: Literal["annotation"]
    annotation: Annotated[Annotation, Field(description="The annotation this context was gathered for")]
    source_resource: Annotated[ResourceDescriptor, Field(alias="sourceResource", description="The resource containing the annotation")]
    selected: GatheredContextFocusAnnotationSelected | None = None
    user_hint: Annotated[
        str | None,
        Field(alias="userHint", description="User-provided hint to supplement or replace the selected text for search and generation"),
    ] = None
    target_resource: Annotated[
        ResourceDescriptor | None,
        Field(
            alias="targetResource",
            description="The resource the annotation links to, if it is a resolved reference. Dormant capability — produced/exposed but not yet consumed.",
        ),
    ] = None
    target_context: Annotated[GatheredContextFocusAnnotationTargetContext | None, Field(alias="targetContext")] = None


class GatheredContextFocusResourceContent(WireModel, frozen=True):
    """
    Resource content (included when requested)
    """

    main: Annotated[str | None, Field(description="Content of the focal resource")] = None
    related: Annotated[dict[str, str] | None, Field(description="Map of related resource IDs to their content")] = None


class GatheredContextFocusResource(WireModel, frozen=True):
    """
    Whole-resource focus.
    """

    kind: Literal["resource"]
    resource: Annotated[ResourceDescriptor, Field(description="The resource this context was gathered for")]
    summary: str | None = None
    suggested_references: Annotated[list[str] | None, Field(alias="suggestedReferences")] = None
    content: GatheredContextFocusResourceContent | None = None


class GraphResourceNode(WireModel, frozen=True):
    """
    A resource's presence in the gathered knowledge graph.
    """

    id: Annotated[ResourceId, Field(description="The resource's ResourceId")]
    type: Literal["resource"]
    label: Annotated[str, Field(description="The resource's display name — its raw id when the resource's view was missing at build time")]
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes", description="Entity types on the resource")] = None
    metadata: dict[str, JsonValue] | None = None


class GraphAnnotationNode(WireModel, frozen=True):
    """
    An annotation's graph presence. The node IS the annotation, so the full W3C object is required — selectors and body included, which is what lets a client place context annotations without a second fetch. Citations ride here too: an inbound reference is its linking annotation, anchored by an `annotation-of` edge to the resource it lives on and a `cites` edge to the focal resource.
    """

    id: Annotated[AnnotationId, Field(description="The AnnotationId — the same value as annotation.id")]
    type: Literal["annotation"]
    label: Annotated[str, Field(description="The annotation's motivation, as a display label")]
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes", description="Entity types carried by the annotation")] = None
    annotation: Annotation
    metadata: dict[str, JsonValue] | None = None


type KnowledgeGraphNodesItem = Annotated[GraphResourceNode | GraphAnnotationNode, Field(discriminator="type")]


class KnowledgeGraphEdgesItem(WireModel, frozen=True):
    source: str
    target: str
    type: Annotated[
        str,
        Field(
            description="Edge kind: `annotation-of` (an annotation → the resource it lives on), `cites` (a citing linking annotation → the focal resource), or `link` (a resource → a resource it links to)"
        ),
    ]
    bidirectional: Annotated[
        bool | None,
        Field(
            description="Whether the connection goes both ways. Absent on a `link` edge found through what cites a resource, which says nothing of the way back"
        ),
    ] = None
    metadata: dict[str, JsonValue] | None = None


class KnowledgeGraph(WireModel, frozen=True):
    """
    Knowledge graph gathered for an LLM context — a shared backbone in which resources AND annotations are typed nodes, connected by typed (optionally bidirectional) edges. Flattened views the matcher/generation read (connections, citedBy, siblings) are derived from these nodes/edges.
    """

    nodes: list[KnowledgeGraphNodesItem]
    edges: list[KnowledgeGraphEdgesItem]
    truncated: Annotated[
        bool | None,
        Field(
            description="Whether the graph stopped taking resources at its ceiling of 200 resource nodes, so that a resource within the depth asked for is not in it. Present, and true, only then"
        ),
    ] = None


class SemanticMatch(WireModel, frozen=True):
    text: Annotated[str, Field(description="The chunk text that matched")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="Source resource ID")]
    resource_name: Annotated[
        str,
        Field(
            alias="resourceName",
            description="The source resource's display name, resolved from its view at gather time. Required: a match card must name its source, and corpus matches routinely come from outside the graph neighborhood, so there is no node to borrow a name from. A match whose source no longer resolves to a view is dropped by the producer rather than served nameless.",
        ),
    ]
    annotation_id: Annotated[
        AnnotationId | None, Field(alias="annotationId", description="Source annotation ID, if the match is from an annotation")
    ] = None
    score: Annotated[float, Field(description="Cosine similarity score (0-1)")]
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes", description="Entity types on the matched passage")] = None
    machine_read: Annotated[
        bool | None,
        Field(
            alias="machineRead",
            description="True when this passage's text was recognized from pixels (OCR of a scanned page) rather than read from the document. Absent means read directly — the common case — so the flag is only present where it changes how the text should be trusted. It travels with the passage because a consumer receives the chunk with no document attached and cannot recompute how the text was obtained.",
        ),
    ] = None


class GatheredContextSemanticContext(WireModel, frozen=True):
    """
    Semantically similar passages from across the knowledge base, found via vector search
    """

    similar: Annotated[list[SemanticMatch], Field(description="Passages ranked by cosine similarity to the focal text")]
    excluded_entity_types: Annotated[
        list[str] | None,
        Field(
            alias="excludedEntityTypes",
            description="Entity types excluded from this recall — a record of how `similar` was filtered (e.g. ['Question'] so answer-generation never surfaces prior questions). Absent when no exclusion was applied.",
        ),
    ] = None


class GatheredContextMetadata(WireModel, frozen=True):
    """
    Context metadata about the focal anchor and its source
    """

    resource_type: Annotated[
        str | None, Field(alias="resourceType", description="Type of source resource (e.g., 'document', 'image', 'video')")
    ] = None
    language: Annotated[str | None, Field(description="BCP 47 language tag of source content")] = None
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes", description="Entity types associated with the focal anchor")] = (
        None
    )
    entity_type_frequencies: Annotated[
        dict[str, int] | None,
        Field(
            alias="entityTypeFrequencies",
            description="Global frequency counts for entity types (for IDF-like weighting). A KB-wide statistic, not a neighborhood property — kept here rather than on the graph.",
        ),
    ] = None


class GatheredContext(WireModel, frozen=True):
    """
    Context gathered for a gather.* call — consumed by yield.* (generation) and the matcher. A shared base (graph, semanticContext, metadata, inferredRelationshipSummary) plus a discriminated `focus` that names the anchor: an annotation or a whole resource.
    """

    focus: Annotated[
        GatheredContextFocusAnnotation | GatheredContextFocusResource, Field(description="The gather anchor. Discriminated on `kind`.")
    ]
    graph: Annotated[
        KnowledgeGraph,
        Field(
            description="Knowledge graph backbone — resources AND annotations as typed nodes. The flattened views (connections, citedBy, siblings) are derived from this."
        ),
    ]
    semantic_context: Annotated[GatheredContextSemanticContext | None, Field(alias="semanticContext")] = None
    metadata: GatheredContextMetadata
    inferred_relationship_summary: Annotated[
        str | None,
        Field(
            alias="inferredRelationshipSummary",
            description="LLM-generated summary of the focal anchor's relationships in the knowledge graph",
        ),
    ] = None


class GatherAnnotationComplete(WireModel, frozen=True):
    """
    Completion payload emitted on the gather:annotation-complete bus channel when annotation context gathering finishes.
    """

    annotation_id: Annotated[
        AnnotationId, Field(alias="annotationId", description="Branded AnnotationId of the annotation whose context was gathered")
    ]
    response: Annotated[
        GatheredContext, Field(description="The gathered annotation context (unified GatheredContext, focus.kind:'annotation')")
    ]


class GatherAnnotationOptions(WireModel, frozen=True):
    """
    Optional configuration for an annotation-focus gather, which windows text around a mark. Distinct from the resource-focus options (depth / maxResources / includeContent / includeSummary), which traverse the resource graph.
    """

    include_source_context: Annotated[
        bool | None, Field(alias="includeSourceContext", description="Whether to include source context in the gathered result")
    ] = None
    include_target_context: Annotated[
        bool | None, Field(alias="includeTargetContext", description="Whether to include target context in the gathered result")
    ] = None
    context_window: Annotated[
        int | None,
        Field(
            alias="contextWindow",
            description="How much of the text on each side of the annotation to include, counted in Unicode code points",
        ),
    ] = None


class GatherAnnotationRequest(WireModel, frozen=True):
    """
    Request payload sent on the gather:requested bus channel to gather context for an annotation.
    """

    annotation_id: Annotated[
        AnnotationId, Field(alias="annotationId", description="Branded AnnotationId of the annotation to gather context for")
    ]
    resource_id: Annotated[
        ResourceId, Field(alias="resourceId", description="Branded ResourceId of the resource the annotation belongs to")
    ]
    options: GatherAnnotationOptions | None = None


class GatherFailed(CommandError, frozen=True):
    """
    The payload of `gather:failed`: a CommandError that names the annotation whose context could not be gathered.
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId", description="The annotation the gather was asked for.")]


class GatherReferencedByRequest(WireModel, frozen=True):
    """
    Request for the annotations elsewhere that refer to a resource. The Librarian answers from the graph.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    motivation: Annotated[
        Motivation | None,
        Field(
            description="The one motivation the annotations answered have. Every annotation that refers to the resource is answered where none is stated."
        ),
    ] = None


class GetReferencedByResponseReferencedByItemTargetSelector(WireModel, frozen=True):
    exact: Annotated[str, Field(description="The selected text that references this resource")]


class GetReferencedByResponseReferencedByItemTarget(WireModel, frozen=True):
    source: Annotated[ResourceId, Field(description="ID of resource containing the reference")]
    selector: GetReferencedByResponseReferencedByItemTargetSelector


class GetReferencedByResponseReferencedByItem(WireModel, frozen=True):
    id: Annotated[AnnotationId, Field(description="Reference annotation ID")]
    resource_name: Annotated[
        str | None,
        Field(
            alias="resourceName",
            description="Name of the resource containing the reference. Absent where no description of that resource is held, and where its name is empty.",
        ),
    ] = None
    target: GetReferencedByResponseReferencedByItemTarget


class GetReferencedByResponse(WireModel, frozen=True):
    referenced_by: Annotated[list[GetReferencedByResponseReferencedByItem], Field(alias="referencedBy")]


class GatherReferencedByResult(WireModel, frozen=True):
    """
    The annotations elsewhere that refer to a resource
    """

    response: GetReferencedByResponse


class GatherResourceComplete(WireModel, frozen=True):
    """
    Completion payload emitted on the gather:resource-complete bus channel when resource context gathering finishes.
    """

    resource_id: Annotated[
        ResourceId, Field(alias="resourceId", description="Branded ResourceId of the resource whose context was gathered")
    ]
    response: Annotated[
        GatheredContext, Field(description="The gathered resource context (unified GatheredContext, focus.kind:'resource')")
    ]


class GatherResourceFailed(CommandError, frozen=True):
    """
    The payload of `gather:resource-failed`: a CommandError that names the resource whose context could not be gathered.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource the gather was asked for.")]


class GatherResourceOptions(WireModel, frozen=True, extra="forbid"):
    """
    What gathering the context of a resource is told beside the resource: GatherResourceRequestOptions, each member of which a caller may leave out. client/surface.json's `gather.resource` cases state what is sent for one left out.
    """

    depth: Annotated[
        int | None,
        Field(
            description="How many links out from the resource the knowledge graph reaches, nearest first: 1 is what the resource links to and what cites it, and each further link out adds what those link to and what cites them"
        ),
    ] = None
    max_resources: Annotated[int | None, Field(alias="maxResources", description="Maximum number of related resources to include")] = None
    include_content: Annotated[
        bool | None, Field(alias="includeContent", description="Whether to include resource content in the gathered result")
    ] = None
    include_summary: Annotated[
        bool | None, Field(alias="includeSummary", description="Whether to include resource summaries in the gathered result")
    ] = None
    exclude_entity_types: Annotated[
        list[str] | None,
        Field(
            alias="excludeEntityTypes",
            description="Entity types to exclude from the semantic recall built into this context (caller-supplied; e.g. a chat consumer passes ['Question'] so prior questions never ground answer generation). Optional; default none.",
        ),
    ] = None


class GatherResourceRequestOptions(WireModel, frozen=True):
    """
    Gathering configuration
    """

    depth: Annotated[
        int,
        Field(
            description="How many links out from the resource the knowledge graph reaches, nearest first: 1 is what the resource links to and what cites it, and each further link out adds what those link to and what cites them"
        ),
    ]
    max_resources: Annotated[int, Field(alias="maxResources", description="Maximum number of related resources to include")]
    include_content: Annotated[
        bool, Field(alias="includeContent", description="Whether to include resource content in the gathered result")
    ]
    include_summary: Annotated[
        bool, Field(alias="includeSummary", description="Whether to include resource summaries in the gathered result")
    ]
    exclude_entity_types: Annotated[
        list[str] | None,
        Field(
            alias="excludeEntityTypes",
            description="Entity types to exclude from the semantic recall built into this context (caller-supplied; e.g. a chat consumer passes ['Question'] so prior questions never ground answer generation). Optional; default none.",
        ),
    ] = None


class GatherResourceRequest(WireModel, frozen=True):
    """
    Request payload sent on the gather:resource-requested bus channel to gather context for a resource.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="Branded ResourceId of the resource to gather context for")]
    options: GatherResourceRequestOptions


class GatherSummaryRequest(WireModel, frozen=True):
    """
    Request to generate an AI summary of an annotation
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


type SupportedMediaType = Annotated[
    Literal[
        "text/plain",
        "text/markdown",
        "text/html",
        "text/css",
        "text/csv",
        "text/xml",
        "application/json",
        "application/xml",
        "application/yaml",
        "application/x-yaml",
        "application/pdf",
        "application/msword",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.ms-excel",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.ms-powerpoint",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "application/zip",
        "application/gzip",
        "application/x-tar",
        "application/x-7z-compressed",
        "application/octet-stream",
        "application/wasm",
        "image/png",
        "image/jpeg",
        "image/gif",
        "image/webp",
        "image/svg+xml",
        "image/bmp",
        "image/tiff",
        "image/x-icon",
        "video/mp4",
        "video/mpeg",
        "video/webm",
        "video/ogg",
        "video/quicktime",
        "video/x-msvideo",
        "audio/mpeg",
        "audio/wav",
        "audio/ogg",
        "audio/webm",
        "audio/aac",
        "audio/flac",
        "text/javascript",
        "application/javascript",
        "text/x-typescript",
        "application/typescript",
        "text/x-python",
        "text/x-java",
        "text/x-c",
        "text/x-c++",
        "text/x-csharp",
        "text/x-go",
        "text/x-rust",
        "text/x-ruby",
        "text/x-php",
        "text/x-swift",
        "text/x-kotlin",
        "text/x-shell",
        "font/woff",
        "font/woff2",
        "font/ttf",
        "font/otf",
    ],
    Field(
        description="Base MIME types (no parameters) admitted by Xynolog. Membership is the create/yield gate — every member is storable, nameable, and uploadable. What more the system can do with a type (render, annotate, extract text, author) is curated per type in @xynolog/core's media-type registry, which is keyed by this enum."
    ),
]


class GenerationJobRequest(WireModel, frozen=True):
    """
    What a `yield` job is asked to make: every parameter of GenerationJobParams but its `context`, the input the resource is made from. It is what an announcement of the job carries.
    """

    title: Annotated[
        str, Field(description="Title of the generated resource. Not empty: the gateway refuses a `job:create` whose title is.")
    ]
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="Storage URI for the generated resource's content — AUTHORITATIVE: the worker writes exactly here and never derives a location from the title. Not empty, and there is no fallback: the gateway refuses a `job:create` whose storageUri is.",
        ),
    ]
    prompt: Annotated[str | None, Field(description="Refining instruction, composed with `task` (task = what, prompt = how).")] = None
    entity_types: Annotated[
        list[str] | None,
        Field(
            alias="entityTypes",
            description="Entity-type tags to stamp on the synthesized resource. Used both as a prompt bias for the generation worker and as the `entityTypes` set on the resulting resource.",
        ),
    ] = None
    language: Annotated[
        str | None,
        Field(
            description="Annotation/resource body locale — language the generated resource is written in (typically the user's UI locale). BCP-47."
        ),
    ] = None
    source_language: Annotated[
        str | None,
        Field(
            alias="sourceLanguage",
            description="Source-resource locale — language of the resource being referenced, used in the prompt so the LLM understands embedded source-context snippets when source ≠ target language. BCP-47.",
        ),
    ] = None
    temperature: Annotated[float | None, Field(description="Sampling temperature forwarded to the model.")] = None
    max_tokens: Annotated[
        float | None, Field(alias="maxTokens", description="Output token budget forwarded to the model. Length never determines structure.")
    ] = None
    output_media_type: Annotated[
        SupportedMediaType | None,
        Field(
            alias="outputMediaType",
            description="Requested media type of the generated resource's content. Default `text/markdown` at the worker, which validates it against its supported output set and FAILS the job for anything it can't write — not a silent fallback.",
        ),
    ] = None
    task: Annotated[
        str | None,
        Field(
            description="What the model is asked to produce — the prompt's framing verb. Canonical values ('resource', 'answer', 'summary') map to the worker's tested framings; any other string is used VERBATIM as the framing instruction (loud degrade: the worker warns, never silently falls back). Unset ⇒ 'resource' (article framing)."
        ),
    ] = None
    structure: Annotated[
        str | None,
        Field(
            description="How the output is internally segmented — shape for text-bearing media, subordinate to `outputMediaType` (never its peer). Canonical values: 'prose' (flowing paragraphs), 'sections' (titled sections + title), 'chat' (speaker-labeled turns); any other string becomes a freeform \"organize as: …\" directive (loud degrade). Unset ⇒ NO structure directive at all — the task framing and the model determine shape."
        ),
    ] = None
    cite: Annotated[
        bool | None,
        Field(
            description="Ask the model to cite its sources, by the ids the gathered context labels its passages with. The model wraps the words a source supports as `[[<id>: <claim>]]`, the ids of several sources separated by commas; a bare `[[<id>]]` is replaced by the source's name. The worker checks every id against the gathered context (an id it did not show is dropped, with a warning), takes every token out of the stored content, and mints a W3C linking annotation on the new resource over exactly the words each token cites."
        ),
    ] = None


class GenerationJobParams(GenerationJobRequest, frozen=True):
    """
    The parameters of a `yield` job: what it is asked to make (GenerationJobRequest) and the gathered context it is made from. The job's resource is derived from `context.focus` by the dispatcher (resource focus → focus.resource; annotation focus → focus.sourceResource, with the worker binding to focus.annotation), and the dispatcher refuses a parameter this schema does not name.
    """

    context: Annotated[
        GatheredContext,
        Field(
            description="The gathered context that grounds the generation. Its `focus` names the anchor: the DISPATCHER derives the job's resourceId from it (resource focus → focus.resource; annotation focus → focus.sourceResource, with the worker auto-binding to focus.annotation) and REJECTS a caller-supplied id — the context is authoritative. Under `cite`, the ids its embedding carries are the only valid citation targets."
        ),
    ]


class GetAnnotationsResponse(WireModel, frozen=True):
    annotations: list[Annotation]
    total: Annotated[float, Field(description="Total number of annotations")]
    motivation: Annotated[Motivation | None, Field(description="Motivation filter applied (if any)")] = None


class GetResourceByTokenResponse(WireModel, frozen=True):
    source_resource: Annotated[ResourceDescriptor, Field(alias="sourceResource")]
    expires_at: Annotated[str, Field(alias="expiresAt", description="ISO 8601 timestamp when token expires")]


class GetResourceResponse(WireModel, frozen=True):
    resource: ResourceDescriptor
    annotations: Annotated[
        list[Annotation], Field(description="All annotations for the resource (highlights, references, assessments, etc.)")
    ]


class Neo4jGraphConfig(WireModel, frozen=True, extra="forbid"):
    """
    A graph kept in a Neo4j database.
    """

    type: Literal["neo4j"]
    uri: Annotated[str, Field(description="Where the database is reached (`bolt://host:7687`).")]
    username: Annotated[str, Field(description="The user the service connects as.")]
    password_env: Annotated[
        str,
        Field(
            alias="passwordEnv", description="The environment variable holding that user's password. The password is never a value here."
        ),
    ]
    database: Annotated[str, Field(description="Which of the server's databases holds the graph.")]


class JanusGraphConfig(WireModel, frozen=True, extra="forbid"):
    """
    A graph kept in a JanusGraph server, asked in Gremlin. No service has been run against one.
    """

    type: Literal["janusgraph"]
    host: Annotated[str, Field(description="The server's host.")]
    port: Annotated[int, Field(description="The port its Gremlin endpoint listens on.")]


class NeptuneGraphConfig(WireModel, frozen=True, extra="forbid"):
    """
    A graph kept in Amazon Neptune, asked in Gremlin. No service has been run against one.
    """

    type: Literal["neptune"]
    endpoint: Annotated[str, Field(description="The cluster's endpoint: its host name.")]
    port: Annotated[int, Field(description="The port its Gremlin endpoint listens on.")]


class MemoryGraphConfig(WireModel, frozen=True, extra="forbid"):
    """
    A graph held in the memory of the one process that is given it: for a test. It cannot be shared between processes, so a service that writes the graph for another to read, or reads what another wrote, refuses it.
    """

    type: Literal["memory"]


type GraphConfig = Annotated[
    Neo4jGraphConfig | JanusGraphConfig | NeptuneGraphConfig | MemoryGraphConfig,
    Field(
        description="The graph database a service writes or reads, and what that kind of database needs to be reached: one of the kinds `xynolog-graph` has a store for, told apart by `type`. A secret is never a value here: a database's password is named by the environment variable that holds it.",
        discriminator="type",
    ),
]


class GraphSchemaNodesResource(WireModel, frozen=True, extra="forbid"):
    """
    A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    """

    label: Annotated[str, Field(description="Its label.")]
    row: Annotated[
        str | None,
        Field(
            description="The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone."
        ),
    ] = None
    key: Annotated[str, Field(description="The property no two nodes of its kind share.")]
    lookups: Annotated[list[str], Field(description="The properties other than its key that a reader finds a node of its kind by.")]


class GraphSchemaNodesAnnotation(WireModel, frozen=True, extra="forbid"):
    """
    A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    """

    label: Annotated[str, Field(description="Its label.")]
    row: Annotated[
        str | None,
        Field(
            description="The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone."
        ),
    ] = None
    key: Annotated[str, Field(description="The property no two nodes of its kind share.")]
    lookups: Annotated[list[str], Field(description="The properties other than its key that a reader finds a node of its kind by.")]


class GraphSchemaNodesEntityType(WireModel, frozen=True, extra="forbid"):
    """
    A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by.
    """

    label: Annotated[str, Field(description="Its label.")]
    row: Annotated[
        str | None,
        Field(
            description="The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone."
        ),
    ] = None
    key: Annotated[str, Field(description="The property no two nodes of its kind share.")]
    lookups: Annotated[list[str], Field(description="The properties other than its key that a reader finds a node of its kind by.")]


class GraphSchemaNodes(WireModel, frozen=True, extra="forbid"):
    """
    Each kind of node the graph holds.
    """

    resource: GraphSchemaNodesResource
    annotation: GraphSchemaNodesAnnotation
    entity_type: Annotated[GraphSchemaNodesEntityType, Field(alias="entityType")]


class GraphSchemaRelationshipsBelongsTo(WireModel, frozen=True, extra="forbid"):
    """
    A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    """

    type: Annotated[str, Field(description="Its type.")]
    from_: Annotated[str, Field(alias="from", description="The kind of node it goes from, by its name under `nodes`.")]
    to: Annotated[str, Field(description="The kind of node it goes to, by its name under `nodes`.")]
    says: Annotated[str, Field(description="What one says.")]


class GraphSchemaRelationshipsReferences(WireModel, frozen=True, extra="forbid"):
    """
    A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    """

    type: Annotated[str, Field(description="Its type.")]
    from_: Annotated[str, Field(alias="from", description="The kind of node it goes from, by its name under `nodes`.")]
    to: Annotated[str, Field(description="The kind of node it goes to, by its name under `nodes`.")]
    says: Annotated[str, Field(description="What one says.")]


class GraphSchemaRelationshipsTaggedAs(WireModel, frozen=True, extra="forbid"):
    """
    A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says.
    """

    type: Annotated[str, Field(description="Its type.")]
    from_: Annotated[str, Field(alias="from", description="The kind of node it goes from, by its name under `nodes`.")]
    to: Annotated[str, Field(description="The kind of node it goes to, by its name under `nodes`.")]
    says: Annotated[str, Field(description="What one says.")]


class GraphSchemaRelationships(WireModel, frozen=True, extra="forbid"):
    """
    Each kind of relationship the graph holds.
    """

    belongs_to: Annotated[GraphSchemaRelationshipsBelongsTo, Field(alias="belongsTo")]
    references: GraphSchemaRelationshipsReferences
    tagged_as: Annotated[GraphSchemaRelationshipsTaggedAs, Field(alias="taggedAs")]


class GraphSchemaStub(WireModel, frozen=True, extra="forbid"):
    """
    A link's target the graph has not been given yet: a node of its kind that holds its key and the marker, `true`, and nothing else. A node without the marker is no stub.
    """

    node: Annotated[str, Field(description="The kind of node a stub is, by its name under `nodes`.")]
    marker: Annotated[str, Field(description="The property that marks a stub.")]


class GraphSchema(WireModel, frozen=True, extra="forbid"):
    """
    graph/schema.json: the shape of the graph a store keeps, as a reader of the store finds it.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    nodes: GraphSchemaNodes
    relationships: GraphSchemaRelationships
    stub: GraphSchemaStub


class HealthResponse(WireModel, frozen=True):
    """
    Liveness: the process is up and serving. It asks nothing of the Archivist or the broker — a gateway that cannot reach them refuses to start, so one that answers here got past both at boot.
    """

    status: str
    message: str
    version: str
    timestamp: str


class HeldJobStall(WireModel, frozen=True, extra="forbid"):
    """
    A held job that showed no activity for `heldJobStallMs` (contract/WORKER-CONTRACT.md V2): what a worker's claims say on `stalled`. What its host does then is the host's.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    held_since: Annotated[str, Field(alias="heldSince", description="When the worker was handed the job.")]
    last_activity_at: Annotated[
        str,
        Field(
            alias="lastActivityAt", description="When the job last showed activity: its claim, a progress report, a checkpoint or a commit."
        ),
    ]
    silent_for_ms: Annotated[int, Field(alias="silentForMs", description="How long it has shown none, in milliseconds.")]
    threshold_ms: Annotated[int, Field(alias="thresholdMs", description="The `heldJobStallMs` it was held to, in milliseconds.")]


class HighlightingJobParams(WireModel, frozen=True, extra="forbid"):
    """
    What a highlighting job takes: passages of the resource worth a reader's attention are marked, with no text of the job's own.
    """

    motivation: Literal["highlighting"]
    instructions: Annotated[str | None, Field(description="What to look for, in the caller's words. Added to the prompt.")] = None
    density: Annotated[float | None, Field(description="How many annotations to aim for per 2000 words of the resource.")] = None
    source_language: Annotated[
        str | None, Field(alias="sourceLanguage", description="The language of the resource being read. BCP 47.")
    ] = None


class HostPort(WireModel, frozen=True, extra="forbid"):
    """
    Where somebody else's daemon listens.
    """

    host: Annotated[str, Field(description="A host name or address the stack's containers can reach.")]
    port: Annotated[int, Field(description="The port it listens on.")]


class IdentityUser(WireModel, frozen=True, extra="forbid"):
    """
    An account in a knowledge base's launcher-managed identity realm. Passwords and tokens are never included.
    """

    email: Annotated[str, Field(description="The account's sign-in name, normally its email address.")]
    identity: Annotated[str, Field(description="The identity the account acts under in Xynolog.")]
    enabled: Annotated[bool, Field(description="Whether the identity provider currently allows this account to sign in.")]


class IdentityUseraddParams(WireModel, frozen=True, extra="forbid"):
    """
    Create one account in the launcher-managed Keycloak realm for a specific local knowledge base.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion")]
    target: LocalTarget
    email: Annotated[str, Field(description="The email address that will sign in to this knowledge base.")]
    password: Annotated[
        str | None,
        Field(
            description="The user's password. Secret: carried only in this local control request, never in progress, diagnostics, or persistent state."
        ),
    ] = None
    generate_password: Annotated[
        bool, Field(alias="generatePassword", description="Generate a random password in the launcher and return it once in the result.")
    ]


class IdentityUseraddResult(WireModel, frozen=True, extra="forbid"):
    """
    The created account's sign-in identity. A generated password is present only in this one answer and is not stored by the launcher.
    """

    email: Annotated[str, Field(description="The account's email address.")]
    identity: Annotated[str, Field(description="The identity the account acts under in Xynolog.")]
    created: Annotated[bool, Field(description="Whether a new account was created.")]
    generated_password: Annotated[
        str | None,
        Field(
            alias="generatedPassword",
            description="The generated password, returned once so the operator can share it with the user. Absent when the operator supplied the password.",
        ),
    ] = None


class IdentityUsersListParams(WireModel, frozen=True, extra="forbid"):
    """
    List accounts in one local knowledge base's launcher-managed Keycloak realm.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion")]
    target: LocalTarget


class IdentityUsersListResult(WireModel, frozen=True, extra="forbid"):
    """
    Accounts in the selected knowledge base's launcher-managed identity realm.
    """

    users: Annotated[list[IdentityUser], Field(description="Accounts, sorted by sign-in name.")]


class SecretRef(WireModel, frozen=True, extra="forbid"):
    """
    A secret the document names and does not hold. The launcher hands it to the service that needs it, from where the reference says it is.
    """

    from_env: Annotated[
        str,
        Field(
            alias="fromEnv",
            description="The environment variable that holds the secret where the launcher runs. Unset, the start that needs it is refused.",
        ),
    ]


class Provider(WireModel, frozen=True, extra="forbid"):
    """
    How an inference provider is reached.
    """

    base_url: Annotated[
        str | None,
        Field(
            alias="baseURL",
            description="Where the provider's API is reached. Anthropic's own API, and the shared Ollama, are stated by no baseURL.",
        ),
    ] = None
    api_key: Annotated[SecretRef | None, Field(alias="apiKey")] = None


class InferenceSpec(WireModel, frozen=True, extra="forbid"):
    """
    The providers, and the engine for each job and each Librarian actor.
    """

    providers: Annotated[dict[str, Provider], Field(description="Each provider an engine names, and how it is reached.")]
    engines: Annotated[
        ArchivistEngines,
        Field(description="The engine each job is done with when software does it, and the engine each Librarian actor asks."),
    ]


class Inference(WireModel, frozen=True, extra="forbid"):
    """
    The engines a machine uses for a knowledge base: the providers it reaches, and the provider and model each job and each Librarian actor is done with. A knowledge base's repository may carry several, one for each provider, and a machine chooses one.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["Inference"]
    metadata: Metadata
    spec: InferenceSpec


class InferenceLimitsRequest(WireModel, frozen=True):
    """
    Request for the inference limits of the engines one service holds a client for. Answered on job:limits-requested by the worker, and on gather:limits-requested and match:limits-requested by the librarian: each service that holds an inference credential reports for its own engines, so no other service needs one.
    """


class InferenceLimitsResultResponse(WireModel, frozen=True):
    limits: list[EngineLimits]


class InferenceLimitsResult(WireModel, frozen=True):
    """
    The inference limits one service discovered for the engines it holds a client for. An engine whose discovery is currently unavailable is absent.
    """

    response: InferenceLimitsResultResponse


class IssuedTokens(WireModel, frozen=True, extra="forbid"):
    """
    The tokens an issuer issued at the end of a sign-in.
    """

    access: Annotated[str, Field(description="The access token: short-lived, sent as a Bearer token.")]
    refresh: Annotated[str, Field(description="The refresh token: what renews the access token without another sign-in.")]


class Runner(WireModel, frozen=True):
    """
    Who runs a daemon: the launcher, from `image` with `resources`, or somebody else, reached at `external`. Exactly one of the two.
    """


class IssuerSpecDatabaseExternal(WireModel, frozen=True, extra="forbid"):
    """
    A database somebody else runs.
    """

    host: Annotated[str, Field(description="A host name or address the issuer can reach.")]
    port: Annotated[int, Field(description="The port it listens on.")]
    password: SecretRef


class IssuerSpecDatabase(Runner, frozen=True):
    """
    The database the issuer keeps its realms in.
    """

    type: Annotated[str, Field(description="The database's driver: `postgres`.")]
    name: Annotated[
        str,
        Field(
            description="The database the issuer keeps its realms in: a lowercase PostgreSQL identifier, as PostgreSQL itself names an unquoted one. On a PostgreSQL the launcher runs, the launcher creates it; on one somebody else runs (`external`), it must already exist there."
        ),
    ]
    user: Annotated[str, Field(description="The user the issuer signs in as.")]
    image: Image | None = None
    resources: Resources | None = None
    port: Annotated[
        int | None,
        Field(
            description="The port a PostgreSQL the launcher runs is published on, on this machine, where the issuer reaches it. One somebody else runs is reached at `external`."
        ),
    ] = None
    external: IssuerSpecDatabaseExternal | None = None


class IssuerSpec(WireModel, frozen=True, extra="forbid"):
    """
    The issuer, where it is published, and the database it keeps its realms in.
    """

    type: Annotated[str, Field(description="The issuer's driver: `keycloak`.")]
    image: Image
    resources: Resources
    port: Annotated[
        int,
        Field(
            description="The port the issuer is published on, on this machine: the origin of every realm's `iss`, so the one number wherever the issuer is reached."
        ),
    ]
    database: IssuerSpecDatabase


class Issuer(WireModel, frozen=True, extra="forbid"):
    """
    The issuer the launcher runs for the knowledge bases on a machine, with a realm for each, and the database it keeps their realms in. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/issuer.yaml`, not in a knowledge base's repository. A knowledge base trusts it by naming `shared`; one trusting somebody else's issuer names it at `external`.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["Issuer"]
    metadata: Metadata
    spec: IssuerSpec


class JobMetadata(WireModel, frozen=True, extra="forbid"):
    """
    What the dispatcher records about a job beside its parameters. `completedUnits` and `unitCursors` appear once a worker has checkpointed. `retryCount` counts the times the queue has put the job back to pending after a failure it classes as transient.
    """

    id: Annotated[
        JobId, Field(description="The job's id: `job-` followed by a version 4 UUID written as 32 lowercase hex digits, without dashes.")
    ]
    type: JobType
    user_id: Annotated[UserId, Field(alias="userId", description="The DID of the principal whose `job:create` created the job.")]
    created: Annotated[str, Field(description="When the job was created, as an ISO 8601 timestamp.")]
    retry_count: Annotated[int, Field(alias="retryCount")]
    max_retries: Annotated[
        int,
        Field(
            alias="maxRetries",
            description="How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.",
        ),
    ]
    completed_units: Annotated[
        list[str] | None,
        Field(alias="completedUnits", description="The units a worker has finished, merged across checkpoints and failures as a set."),
    ] = None
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.",
        ),
    ] = None


class JobPending(WireModel, frozen=True, extra="forbid"):
    """
    A job waiting for a worker to claim it.
    """

    status: Literal["pending"]
    metadata: JobMetadata
    params: JobParams


class JobProgressLoading(WireModel, frozen=True):
    """
    Loading the resource content.
    """

    code: Literal["loading"]


class JobProgressAnalyzing(WireModel, frozen=True):
    """
    Analyzing the content.
    """

    code: Literal["analyzing"]


class JobProgressAnalyzingTags(WireModel, frozen=True):
    """
    Analyzing the content against the tag schema.
    """

    code: Literal["analyzing-tags"]


class JobProgressGeneratingResource(WireModel, frozen=True):
    """
    The model is generating the resource.
    """

    code: Literal["generating-resource"]


class JobProgressCreatingResource(WireModel, frozen=True):
    """
    Writing the generated resource.
    """

    code: Literal["creating-resource"]


class JobProgressCompleteGenerated(WireModel, frozen=True):
    """
    Generation's terminal success. Deliberately generic — the client already holds the title it typed, and the outcome (name + resource link) travels on job:complete, not on progress. `truncated` qualifies the completion: the same bit `YieldJobDone.truncated` carries, so the two surfaces cannot drift.
    """

    code: Literal["complete-generated"]
    truncated: Annotated[
        bool, Field(description="True when the model stopped at the maxTokens ceiling — the artifact is cut off, not complete.")
    ]


class JobProgressDetectingEntities(WireModel, frozen=True):
    """
    Entity detection, one entity type at a time.
    """

    code: Literal["detecting-entities"]
    entity_type: Annotated[str, Field(alias="entityType", description="Entity type currently being detected")]


class JobProgressCreatingAnnotations(WireModel, frozen=True):
    """
    Writing detected annotations back to the resource.
    """

    code: Literal["creating-annotations"]
    count: Annotated[int, Field(description="How many annotations are being created")]


class JobProgressCreatingTagAnnotations(WireModel, frozen=True):
    """
    Writing detected tag annotations back to the resource.
    """

    code: Literal["creating-tag-annotations"]
    count: Annotated[int, Field(description="How many annotations are being created")]


class JobProgressCompleteCreated(WireModel, frozen=True):
    """
    Terminal success summary.
    """

    code: Literal["complete-created"]
    count: Annotated[int, Field(description="How many annotations were created")]
    motivation: Annotated[
        Motivation, Field(description="The motivation of the job, and so of what it created. A client words it in its own language.")
    ]


type JobProgressMessage = Annotated[
    JobProgressLoading
    | JobProgressAnalyzing
    | JobProgressAnalyzingTags
    | JobProgressGeneratingResource
    | JobProgressCreatingResource
    | JobProgressCompleteGenerated
    | JobProgressDetectingEntities
    | JobProgressCreatingAnnotations
    | JobProgressCreatingTagAnnotations
    | JobProgressCompleteCreated,
    Field(
        description="What a running job is doing right now, as a code plus typed params — never a prose sentence. The producer reports what happened; each client renders it in the user's language (react-ui from its translations, the Go launcher from its English map). One named schema per code, discriminated on `code`, so generated clients get typed variants and copy-map completeness is statically checkable. The vocabulary is every report Xynolog's worker makes (contract/WORKER-SERVICE.md, D16 to D19 and Y8); extending it means adding a named variant here and copy in every client, gated by the locale-completeness check.",
        discriminator="code",
    ),
]

type JobProgressCurrentKind = Annotated[
    Literal["entity-type", "category"],
    Field(description="What sort of thing `value` is. Adding a variant means adding client copy for it in every locale."),
]


class JobProgressCurrent(WireModel, frozen=True):
    """
    What the run is working on right now. `kind` is a CODE the client renders a localized name for; `value` is KB data (an entity type, a tag category) shown verbatim — the same split as `requestParams`. Absent on flows that iterate nothing, such as generation.
    """

    kind: JobProgressCurrentKind
    value: Annotated[str, Field(description="The item itself, shown verbatim and never translated.")]


class JobProgressCompletedItemsItemUnderReported(WireModel, frozen=True):
    """
    Present only when pieces of this unit were accepted at the subdivision floor while a count call said more was present. The unit completed, but incompletely — this carries the EVIDENCE (found vs counted, over how many pieces), never a judgment against any expected yield. Absent means complete: genuinely absent, not defaulted.
    """

    pieces: Annotated[int, Field(description="Floor-accepted pieces in this unit.")]
    found: Annotated[int, Field(description="Annotations extraction did find on those pieces — every span write-time-verified.")]
    counted: Annotated[int, Field(description="Mentions the count calls reported across those pieces (approximate by nature).")]


class JobProgressCompletedItemsItem(WireModel, frozen=True):
    value: Annotated[str, Field(description="The item, shown verbatim.")]
    found_count: Annotated[int, Field(alias="foundCount", description="Annotations found for it.")]
    persisted_count: Annotated[
        int | None,
        Field(
            alias="persistedCount",
            description="Annotations actually persisted for it — post-dedupe and post-durability-acknowledgement, so it counts what the event log holds, not what the model proposed. Beside foundCount this is the per-unit yield the sizing work is judged by. Present on flows whose units persist as they complete (a linking job); the tagging flow reports the same fact as byCategory on its result, because its annotations are built after the per-category loop.",
        ),
    ] = None
    under_reported: Annotated[JobProgressCompletedItemsItemUnderReported | None, Field(alias="underReported")] = None


type JobProgressRequestParamsItemLabel = Annotated[
    Literal["entity-types", "instructions", "tone", "density"],
    Field(description="Which parameter this is. The client renders a localized name for it."),
]


class JobProgressRequestParamsItem(WireModel, frozen=True):
    label: JobProgressRequestParamsItemLabel
    value: Annotated[str, Field(description="The user's own input, shown verbatim.")]


class JobProgress(WireModel, frozen=True):
    """
    Progress report from a running job. The required field is `percentage`; `message` carries the coded phase and the rest are optional job-shape fields. This is the single progress shape for every job type — annotation workers and generation alike. Terminality is signalled on `job:complete` / `job:fail`, not here. A flow that iterates a user-chosen list (entity types for references, categories for tags) reports its position as one `current`/`processed`/`total` triple, the same shape for both, so a client never needs to know which flow it is drawing.
    """

    percentage: Annotated[float, Field(description="Completion percentage (0-100)")]
    message: Annotated[
        JobProgressMessage | None,
        Field(
            description="What the job is doing right now, as a code plus typed params; the client renders the sentence. Optional: pure percentage heartbeats carry none, and consumers render nothing message-shaped when it is absent."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="Annotation this job is attached to, when applicable. Echoed inside JobProgress (in addition to the outer command envelope) so consumers that only see the inner progress object (e.g. what `yield.delegate` returns) can still route visual feedback to a specific annotation.",
        ),
    ] = None
    current: JobProgressCurrent | None = None
    processed: Annotated[
        int | None,
        Field(description="Items completed so far, zero-based — the item in `current` is the one after these. Paired with `total`."),
    ] = None
    total: Annotated[int | None, Field(description="Items this run will process in all.")] = None
    entities_found: Annotated[int | None, Field(alias="entitiesFound", description="Entities found so far (a linking job)")] = None
    entities_expected: Annotated[
        int | None,
        Field(
            alias="entitiesExpected",
            description="Cumulative mentions the count-verifier priced across the pieces accepted so far — the denominator for a real progress bar (found of ~expected). Approximate by nature (the count saturates on very large pieces) and monotonically growing within a run. ABSENT when the provider does not verify detection yield, or before any piece has been priced: no claim, never zero.",
        ),
    ] = None
    entities_emitted: Annotated[int | None, Field(alias="entitiesEmitted", description="Annotations emitted so far (a linking job)")] = None
    completed_items: Annotated[
        list[JobProgressCompletedItemsItem] | None,
        Field(
            alias="completedItems",
            description="Per-item results for the items already finished, for the UI's completed log. Generic across flows for the same reason `current` is.",
        ),
    ] = None
    request_params: Annotated[
        list[JobProgressRequestParamsItem] | None,
        Field(
            alias="requestParams",
            description="Echoed job parameters for display in the progress UI. `label` is a CODE, not a sentence — the client owns the wording, same rule as the progress message. `value` is the user's own input (an entity-type list, their instructions) and is deliberately NOT translated: it is their words, not ours.",
        ),
    ] = None


class JobStoredProgressEmpty(WireModel, frozen=True, extra="forbid"):
    pass


type JobStoredProgress = Annotated[
    JobProgress | JobStoredProgressEmpty,
    Field(
        description="A running job's progress as the dispatcher stores it: the last JobProgress its worker reported with `job:report-progress`, or an empty object before the first report."
    ),
]


class JobRunning(WireModel, frozen=True, extra="forbid"):
    """
    A job a worker has claimed and not yet concluded.
    """

    status: Literal["running"]
    metadata: JobMetadata
    params: JobParams
    started_at: Annotated[str, Field(alias="startedAt", description="When the claim that holds it was made, as an ISO 8601 timestamp.")]
    progress: JobStoredProgress


class MarkJobDone(WireModel, frozen=True, extra="forbid"):
    """
    What a `mark` job reports when it has done its work, whatever its motivation.
    """

    found: Annotated[int, Field(description="What the model proposed, before anything was checked against the text.")]
    persisted: Annotated[
        int,
        Field(
            description="What the log holds: the annotations committed, after the ones that could not be anchored were dropped and repeats were collapsed."
        ),
    ]
    errors: Annotated[int | None, Field(description="How many of the proposed could not be anchored in the text. Absent means none.")] = (
        None
    )
    by_category: Annotated[
        dict[str, int] | None,
        Field(alias="byCategory", description="The annotations persisted per category. A tagging job's; absent from every other."),
    ] = None
    under_reported_pieces: Annotated[
        int | None,
        Field(
            alias="underReportedPieces",
            description="Total floor-accepted under-reported pieces across the job's units. Absent means none — the per-unit evidence rides the terminal progress frame's completedItems; this keeps the result self-describing without the progress stream.",
        ),
    ] = None
    unchecked_pieces: Annotated[
        int | None,
        Field(
            alias="uncheckedPieces",
            description="Pieces whose yield was to be checked against a count and was not: the count failed, was cut off, or answered no count. What they found was kept unchecked. Absent means none: every piece that was to be checked was. A job whose provider checks no yield has none.",
        ),
    ] = None


class YieldJobDone(WireModel, frozen=True, extra="forbid"):
    """
    What a `yield` job reports when it has made its resource. The worker creates the resource first (the create round trip returns its id), then emits job:complete carrying it, so resourceId is always present on the wire.
    """

    resource_id: Annotated[
        ResourceId,
        Field(
            alias="resourceId",
            description="ID of the generated resource, obtained by the worker from the create round-trip before job:complete is emitted",
        ),
    ]
    resource_name: Annotated[str, Field(alias="resourceName", description="Name of the generated resource")]
    truncated: Annotated[
        bool,
        Field(
            description="True when the model stopped at the maxTokens ceiling — the artifact is cut off, not complete. Derived at the producer from the provider's stopReason ('max_tokens' → true); required because the worker always knows."
        ),
    ]


type JobDeclinedReason = Annotated[
    Literal["no-text-layer", "encrypted", "corrupt", "too-large", "empty"],
    Field(
        description="Why the resource could not be read. A CODE, not a sentence: the client owns the wording, so a browser renders it in the user's language and the CLI renders English terminal copy from the same value. A prose `message` composed server-side would be English everywhere."
    ),
]


class JobDeclined(WireModel, frozen=True, extra="forbid"):
    """
    Result of a job that completed without doing its work because the resource could not be read. Distinct from a failure: nothing went wrong, there was simply no text to work with — an encrypted or damaged PDF, a scan whose text could not be recognized, or a document that yielded nothing. The reasons are the extraction vocabulary the Smelter reports on `smelt:settled`, MINUS `no-extractor`: a media type that can never yield text (a zip, an image) is a bad request rather than a decline, so a worker asked to detect over one throws and the job reports `job:fail`. Everything here is a resource-specific outcome — the same media type would have succeeded on a different document.
    """

    declined: Annotated[
        Literal[True],
        Field(description="Always true. It is what tells a decline from the result of a job that did its work, which never carries it."),
    ]
    reason: JobDeclinedReason


type JobResult = Annotated[
    MarkJobDone | YieldJobDone | JobDeclined,
    Field(
        description="What a job reports when it concludes without failing: a `mark` job's counts, the resource a `yield` job made, or a decline from either. A result has no discriminant of its own: the job description beside it says which job it answers, and the three share no member, so each is told from the others by what it alone carries."
    ),
]


class JobStoredResultEmpty(WireModel, frozen=True, extra="forbid"):
    pass


type JobStoredResult = Annotated[
    JobResult | JobStoredResultEmpty,
    Field(
        description="A completed job's result as the dispatcher stores it: the result its worker reported with `job:complete`, or an empty object when it reported none."
    ),
]


class JobComplete(WireModel, frozen=True, extra="forbid"):
    """
    A job its worker completed.
    """

    status: Literal["complete"]
    metadata: JobMetadata
    params: JobParams
    started_at: Annotated[str, Field(alias="startedAt", description="When the claim that completed it was made.")]
    completed_at: Annotated[str, Field(alias="completedAt", description="When it completed.")]
    result: JobStoredResult


class JobFailed(WireModel, frozen=True, extra="forbid"):
    """
    A job that failed and will not be retried.
    """

    status: Literal["failed"]
    metadata: JobMetadata
    params: JobParams
    started_at: Annotated[
        str | None, Field(alias="startedAt", description="When the last claim was made; absent when it failed without one.")
    ] = None
    completed_at: Annotated[str, Field(alias="completedAt", description="When it failed.")]
    error: Annotated[str, Field(description="The failure's message.")]
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass")] = None


class JobCancelled(WireModel, frozen=True, extra="forbid"):
    """
    A job cancelled before it concluded.
    """

    status: Literal["cancelled"]
    metadata: JobMetadata
    params: JobParams
    started_at: Annotated[
        str | None, Field(alias="startedAt", description="When its claim was made; absent when it was cancelled while pending.")
    ] = None
    completed_at: Annotated[str, Field(alias="completedAt", description="When it was cancelled.")]


type Job = Annotated[
    JobPending | JobRunning | JobComplete | JobFailed | JobCancelled,
    Field(
        description="A job as the dispatcher holds it. Its `status` decides which timestamps and outcome fields it carries. It is what a claim returns (`job:claimed`, always `running`) and what the queue stores, inside a JobRecord.",
        discriminator="status",
    ),
]


class JobAssignCommand(WireModel, frozen=True):
    """
    Bus command the dispatcher emits, under its own service identity, immediately after it accepts a job:claim — the correlated job:claimed reply is unchanged. The Stower persists it as job:assigned. It is the one fact only the dispatcher can vouch for: which holder took which job, and who requested it. A later write citing `jobId` is checked against the holder and its `creator` derived from the requester by reading the resource's own log, with nothing outside the record.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="The dispatcher's service DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    resource_id: Annotated[
        ResourceId,
        Field(
            alias="resourceId",
            description="The job's resource — for a generation, the source it generates from. The assignment is persisted on this resource's log.",
        ),
    ]
    holder: Annotated[
        UserId,
        Field(
            description="DID of the claimant whose claim was accepted — the `_userId` the gateway stamped on the job:claim, restated by the dispatcher."
        ),
    ]
    requester: Annotated[
        UserId,
        Field(
            description="DID of the emitter of the job:create that produced this job — the `_userId` the gateway stamped on that create, restated by the dispatcher."
        ),
    ]


class JobAssignedPayload(WireModel, frozen=True):
    """
    Payload for job:assigned — the dispatcher's own record that it accepted a claim. Emitted by the dispatcher under its service identity after a successful job:claim (the correlated job:claimed reply is unchanged). This is the one fact only the dispatcher can vouch for: which holder took which job, and who requested it. The Stower persists it beside job:started so that a write citing `jobId` can be checked against the holder and its `creator` derived from the requester with no read outside the event log.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    resource_id: Annotated[
        ResourceId,
        Field(
            alias="resourceId",
            description="The job's resource — for a generation, the source it generates from. Job events are scoped here.",
        ),
    ]
    holder: Annotated[
        UserId,
        Field(
            description="DID of the emitter whose claim the dispatcher accepted. The bus stamped it on the job:claim as `_userId`; the dispatcher restates it here under its own identity."
        ),
    ]
    requester: Annotated[
        UserId,
        Field(
            description="DID of the emitter of the job:create that produced this job. The dispatcher restates the `_userId` the gateway stamped on that create."
        ),
    ]


class JobCancelCommand(WireModel, frozen=True):
    """
    A worker's settling of a running job it holds whose work it has stopped for a cancellation — the queue moves the job to cancelled/. Distinct from JobCancelRequest (the client→worker REQUEST to stop): this is the worker announcing it did, so the running job is never yanked to cancelled/ out from under a live worker (the roach-motel race).
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="Annotation this job is attached to, when applicable. Lets the UI route cancellation feedback to a specific annotation.",
        ),
    ] = None
    completed_units: Annotated[
        list[str] | None,
        Field(
            alias="completedUnits",
            description="The units the worker had finished when it stopped. Recorded on the cancelled job's metadata so the work already done stays visible.",
        ),
    ] = None
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None


class JobCancelRequest(WireModel, frozen=True):
    """
    Request to cancel one job, named by its id. A pending job is cancelled immediately by the dispatcher. A running job is cancelled only by the worker that holds it: the worker stops its work and settles the job with `job:cancel` (JobCancelCommand). The queue is never made to yank a running job out from under a live worker.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]


class JobCancelResult(WireModel, frozen=True):
    """
    What a cancel did, in the `response` of `job:cancel-ok`: whether the queue acted on the job it named. A pending job is cancelled outright; a running one is left to its worker, so for it true means accepted, not stopped.
    """

    cancelled: Annotated[bool, Field(description="True when the queue acted on the job; false when the job is unknown or already over.")]


class JobCheckpoint(WireModel, frozen=True, extra="forbid"):
    """
    What a held job states when it checkpoints (`job:checkpoint`, contract/JOBS.md § Checkpoints): the units finished, and the furthest each unit begun got.
    """

    completed_units: Annotated[
        list[str],
        Field(
            alias="completedUnits",
            description="Entity-type units whose annotations have been fully emitted so far. Unioned into the running job's metadata checkpoint; a retry after recovery skips them.",
        ),
    ]
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None


class JobCheckpointCommand(WireModel, frozen=True):
    """
    Command to persist a running job's completed-unit checkpoint AT unit completion. Distinct from JobFailCommand's checkpoint, which lands only on a clean failure: a worker that dies (crash/OOM/kill) never emits job:fail, so this durable, unthrottled write is what lets the janitor's stale-running recovery resume a dead worker's job rather than redo its finished units.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    job_id: Annotated[JobId, Field(alias="jobId")]
    completed_units: Annotated[
        list[str],
        Field(
            alias="completedUnits",
            description="Entity-type units whose annotations have been fully emitted so far. Unioned into the running job's metadata checkpoint; a retry after recovery skips them.",
        ),
    ]
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None


class JobClaimCommand(WireModel, frozen=True):
    """
    Claim the NEXT pending job that matches one of `accepts` (atomic: pending → running). A job:queued announcement is a WAKE-UP, not a reservation: the claimed job may differ from the announced one, and two claims after one announcement both succeed on different jobs instead of racing for one. job:claimed carries the claimed job; job:claim-failed reports that nothing matching is pending.
    """

    accepts: Annotated[
        list[JobFilter], Field(description="The jobs this claim takes. A job is handed over when it matches any one of them.")
    ]
    user_id: Annotated[
        UserId | None,
        Field(
            alias="_userId",
            description="Authenticated claimant's DID, injected by the /bus/emit gateway. Clients do not set this. The dispatcher records it as the holder on job:assigned.",
        ),
    ] = None
    roles: Annotated[
        list[str] | None,
        Field(
            alias="_roles",
            description="The claimant's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. The dispatcher authorizes the claim by capability — it admits the claim only when this carries the worker role — so a claimant that is not a worker for this knowledge base is refused before the queue is consulted.",
        ),
    ] = None


class JobClaimedResult(WireModel, frozen=True, extra="forbid"):
    """
    The reply to a successful `job:claim`: the claimed job, now running under the claimant.
    """

    response: JobRunning


type MarkJobResult = Annotated[
    MarkJobDone | JobDeclined,
    Field(
        description="What a `mark` job reports when it concludes without failing: its counts, or a decline. Neither names its kind: a decline is the one with `declined`."
    ),
]


class MarkJobCompleteCommand(WireModel, frozen=True):
    """
    A `mark` job's worker says the job is complete, with what a `mark` job reports.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[Literal["mark"], Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    result: MarkJobResult | None = None
    durability: DurabilityEvidence | None = None


type YieldJobResult = Annotated[
    YieldJobDone | JobDeclined,
    Field(
        description="What a `yield` job reports when it concludes without failing: the resource it made, or a decline. Neither names its kind: a decline is the one with `declined`."
    ),
]


class YieldJobCompleteCommand(WireModel, frozen=True):
    """
    A `yield` job's worker says the job is complete, with what a `yield` job reports.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[Literal["yield"], Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="The annotation the job's context was focused on, when it was focused on one. Lets a client route the completion to that annotation.",
        ),
    ] = None
    result: YieldJobResult | None = None
    durability: DurabilityEvidence | None = None


type JobCompleteCommand = Annotated[
    MarkJobCompleteCommand | YieldJobCompleteCommand,
    Field(
        description="A job's worker says the job is complete. The result it carries is its verb's: a `mark` job's counts or the resource a `yield` job made, or a decline from either. A completion whose result is the other verb's is refused where the command is admitted.",
        discriminator="job_type",
    ),
]


class JobCompletedPayload(WireModel, frozen=True):
    """
    Payload for job:completed domain event
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None, Field(alias="annotationId", description="Annotation this job was attached to, when applicable")
    ] = None
    total_steps: Annotated[int | None, Field(alias="totalSteps")] = None
    found_count: Annotated[int | None, Field(alias="foundCount", description="For detection: total entities found")] = None
    result_resource_id: Annotated[
        ResourceId | None, Field(alias="resultResourceId", description="For generation: ID of generated resource")
    ] = None
    annotation_uri: Annotated[
        str | None, Field(alias="annotationUri", description="For generation: URI of annotation that triggered generation")
    ] = None
    result: Annotated[dict[str, JsonValue] | None, Field(description="Full result object for extensibility")] = None
    durability: DurabilityEvidence | None = None


class LinkingJobParams(WireModel, frozen=True, extra="forbid"):
    """
    What a linking job takes: mentions of the named entity types are marked as references, each unresolved until it is bound to a resource.
    """

    motivation: Literal["linking"]
    entity_types: Annotated[
        list[str], Field(alias="entityTypes", description="The entity types to find mentions of. Each is one the knowledge base registers.")
    ]
    include_descriptive_references: Annotated[
        bool | None,
        Field(
            alias="includeDescriptiveReferences",
            description='Whether a description that stands for an entity ("the wily hero") counts as a mention of it, beside its name.',
        ),
    ] = None
    language: Annotated[str | None, Field(description="The language the annotations' own text is written in. BCP 47.")] = None
    source_language: Annotated[
        str | None, Field(alias="sourceLanguage", description="The language of the resource being read. BCP 47.")
    ] = None


class TaggingJobParams(WireModel, frozen=True, extra="forbid"):
    """
    What a tagging job takes: passages of the resource are marked with categories of one tag schema.
    """

    motivation: Literal["tagging"]
    schema_id: Annotated[str, Field(alias="schemaId", description="The tag schema to tag by. It is one the knowledge base registers.")]
    categories: Annotated[list[str], Field(description="The categories of that schema to tag with.")]
    language: Annotated[str | None, Field(description="The language the annotations' own text is written in. BCP 47.")] = None
    source_language: Annotated[
        str | None, Field(alias="sourceLanguage", description="The language of the resource being read. BCP 47.")
    ] = None


type MarkJobParams = Annotated[
    HighlightingJobParams | CommentingJobParams | AssessingJobParams | LinkingJobParams | TaggingJobParams,
    Field(
        description="The parameters of a `mark` job, told apart by `motivation`. Each motivation takes its own parameters and no others: a parameter a job does not take is refused where the job is created.",
        discriminator="motivation",
    ),
]


class MarkJobCreateCommand(WireModel, frozen=True, extra="forbid"):
    """
    Create a `mark` job: annotate one resource for one motivation.
    """

    user_id: Annotated[
        UserId | None, Field(alias="_userId", description="The emitter's verified DID, injected by the gateway. Clients do not set this.")
    ] = None
    roles: Annotated[
        list[str] | None,
        Field(alias="_roles", description="The emitter's roles, injected by the gateway when it has any. Clients do not set this."),
    ] = None
    job_type: Annotated[Literal["mark"], Field(alias="jobType")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource to annotate.")]
    params: MarkJobParams


class YieldJobCreateCommand(WireModel, frozen=True, extra="forbid"):
    """
    Create a `yield` job: make a resource from a gathered context. It names no resource of its own: the job is about the resource its context focuses on, which the Dispatcher reads from `params.context.focus`.
    """

    user_id: Annotated[
        UserId | None, Field(alias="_userId", description="The emitter's verified DID, injected by the gateway. Clients do not set this.")
    ] = None
    roles: Annotated[
        list[str] | None,
        Field(alias="_roles", description="The emitter's roles, injected by the gateway when it has any. Clients do not set this."),
    ] = None
    job_type: Annotated[Literal["yield"], Field(alias="jobType")]
    params: GenerationJobParams


type JobCreateCommand = Annotated[
    MarkJobCreateCommand | YieldJobCreateCommand,
    Field(
        description="Create a job. A job description is its `jobType` and enough parameters to be well formed: a `mark` job names its resource and, in its parameters, its motivation; a `yield` job names its context.",
        discriminator="job_type",
    ),
]


class JobCreatedResultResponse(WireModel, frozen=True):
    job_id: Annotated[JobId, Field(alias="jobId")]


class JobCreatedResult(WireModel, frozen=True):
    """
    Result of a job:create command
    """

    response: JobCreatedResultResponse


class JobFailCommand(WireModel, frozen=True):
    """
    Command to mark a job as failed
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="Annotation this job is attached to, when applicable. Lets the UI route failure feedback (error toast, revert state) to a specific annotation.",
        ),
    ] = None
    error: str
    completed_units: Annotated[
        list[str] | None,
        Field(
            alias="completedUnits",
            description="Entity-type units whose annotations were fully emitted before this failure (checkpointed resume). The queue records them on the retried job's metadata; a retried claim skips them so completed work is neither redone nor duplicated.",
        ),
    ] = None
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass")] = None
    will_retry: Annotated[
        bool | None,
        Field(
            alias="willRetry",
            description="Whether the queue will re-queue this job for another attempt. Computed by the worker from the SAME rule the queue applies when it takes the failure (specs/src/jobs/retry-cases.json, which every SDK and the dispatcher run) using the retry budget carried on the claimed record. FALSE (or absent) means this failure is TERMINAL: a client's job-watch stream ends here. TRUE means the work continues on a fresh attempt — the failure is an event, not the end, and a stream that terminated on it would report a recovering run as a failed one.",
        ),
    ] = None
    durability: DurabilityEvidence | None = None


class JobFailedPayload(WireModel, frozen=True):
    """
    Payload for the job:failed domain event — a permanent fact of the resource, not operational state. It carries the judgments the worker COMPUTED, not just its message: at the log they are otherwise unrecoverable, the only remaining witness being a flattened English string.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None, Field(alias="annotationId", description="Annotation this job was attached to, when applicable")
    ] = None
    error: str
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass")] = None
    will_retry: Annotated[
        bool | None,
        Field(
            alias="willRetry",
            description="Whether the worker computed that the queue would re-queue this job (same predicate the queue applies, `willRetryAfter`). Absent means the worker stated nothing. Without it a reader of the log cannot tell a run recovering across several job:failed events from that many dead jobs.",
        ),
    ] = None
    durability: DurabilityEvidence | None = None


class JobFailure(WireModel, frozen=True, extra="forbid"):
    """
    What a held job's failure states beside its error (`job:fail`): what it had reached, and the failure's class when the worker knows it. What its commits observed is the held job's own to state.
    """

    completed_units: Annotated[
        list[str] | None,
        Field(
            alias="completedUnits",
            description="Entity-type units whose annotations were fully emitted before this failure (checkpointed resume). The queue records them on the retried job's metadata; a retried claim skips them so completed work is neither redone nor duplicated.",
        ),
    ] = None
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass")] = None


class JobPollOptions(WireModel, frozen=True, extra="forbid"):
    """
    How a job's `pollUntilComplete` asks for the job's status: how long it waits between its asks, and how long it goes on asking. A member left out is client/timing.json's: `jobPollMs` and `jobPollTimeoutMs`.
    """

    every_ms: Annotated[
        int | None, Field(alias="everyMs", description="How long it waits between one ask and the next, in milliseconds.")
    ] = None
    within_ms: Annotated[
        int | None,
        Field(
            alias="withinMs", description="How long it goes on asking, from its first ask, before it fails as timed out, in milliseconds."
        ),
    ] = None


class MarkJobQueuedEvent(WireModel, frozen=True):
    """
    A pending `mark` job, announced with its parameters as it was created.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[Literal["mark"], Field(alias="jobType")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource the job is about.")]
    user_id: Annotated[UserId, Field(alias="userId", description="The DID of the principal whose `job:create` created the job.")]
    params: MarkJobParams


class YieldJobQueuedEvent(WireModel, frozen=True):
    """
    A pending `yield` job, announced with what it is asked to make and without its `context`.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[Literal["yield"], Field(alias="jobType")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource the job is about.")]
    user_id: Annotated[UserId, Field(alias="userId", description="The DID of the principal whose `job:create` created the job.")]
    params: GenerationJobRequest


type JobQueuedEvent = Annotated[
    MarkJobQueuedEvent | YieldJobQueuedEvent,
    Field(
        description="A pending job, announced when it is created and again at each tick while it waits. It carries the job description less the job's input, so that a party deciding whether to claim reads here what its claim would be matched against. It is a wake-up and not an offer of this job: a claim is answered with the next pending job it matches.",
        discriminator="job_type",
    ),
]


class JobReached(WireModel, frozen=True, extra="forbid"):
    """
    What a held job that stops on a cancellation states it had reached (`job:cancel`): the units finished, and the furthest each unit begun got.
    """

    completed_units: Annotated[
        list[str] | None,
        Field(
            alias="completedUnits",
            description="The units the worker had finished when it stopped. Recorded on the cancelled job's metadata so the work already done stays visible.",
        ),
    ] = None
    unit_cursors: Annotated[
        dict[str, UnitCursor] | None,
        Field(
            alias="unitCursors",
            description="The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward.",
        ),
    ] = None


class JobRecord(WireModel, frozen=True, extra="forbid"):
    """
    One job as the queue stores it: the job, and when it last showed life. The dead-worker sweep reads `lastProgressAt`: a running job whose worker has reported nothing for the configured interval is presumed dead. Where the queue keeps these records is the job storage layout, specs/src/jobs/storage.json.
    """

    job: Job
    last_progress_at: Annotated[
        str,
        Field(
            alias="lastProgressAt",
            description="When the job was created, claimed, checkpointed or last reported progress, as an ISO 8601 timestamp.",
        ),
    ]


class JobReportProgressCommand(WireModel, frozen=True):
    """
    Command to report progress on a job
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="Annotation this job is attached to, when applicable. Lets the UI attach progress visuals to a specific annotation (e.g. a reference whose generation is running).",
        ),
    ] = None
    percentage: float
    progress: JobProgress | None = None


class JobStartCommand(WireModel, frozen=True):
    """
    Command to start a job
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="annotationId",
            description="Annotation this job is attached to, when applicable. Set for annotation-scoped jobs like generation (from a specific reference). Unset for resource-scoped jobs like bulk reference/tag/highlight detection.",
        ),
    ] = None
    attempt: Annotated[
        int | None,
        Field(
            description="Which attempt produced this event, 1-based (a first run is 1). ALWAYS present: the queue re-runs a failed job silently, so an operator reading progress or a terminal record has no other way to tell a re-run from a first run — and provider spend, already counted in xynolog_inference_tokens_total, cannot be attributed to a repeated document without it. Stated rather than inferred from absence, because 'attempt 1' is a fact the emitter always knows."
        ),
    ] = None


class JobStartedPayload(WireModel, frozen=True):
    """
    Payload for job:started domain event
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    job_type: Annotated[JobType, Field(alias="jobType")]
    annotation_id: Annotated[
        AnnotationId | None, Field(alias="annotationId", description="Annotation this job is attached to, when applicable")
    ] = None
    total_steps: Annotated[int | None, Field(alias="totalSteps")] = None


class JobStatusRequest(WireModel, frozen=True):
    """
    Request to check the status of a job
    """

    job_id: Annotated[JobId, Field(alias="jobId")]


type JobStatusResponseStatus = Literal["pending", "running", "complete", "failed", "cancelled"]


class JobStatusResponse(WireModel, frozen=True):
    job_id: Annotated[JobId, Field(alias="jobId")]
    type: JobType
    status: JobStatusResponseStatus
    user_id: Annotated[UserId, Field(alias="userId")]
    created: str
    started_at: Annotated[str | None, Field(alias="startedAt")] = None
    completed_at: Annotated[str | None, Field(alias="completedAt")] = None
    error: str | None = None
    failure_class: Annotated[FailureClass | None, Field(alias="failureClass")] = None
    progress: JobStoredProgress | None = None
    result: JobStoredResult | None = None


class JobStatusResult(WireModel, frozen=True):
    """
    Result of a job status request
    """

    response: JobStatusResponse


class JobsBudgetsBudgetsItem(WireModel, frozen=True, extra="forbid"):
    job_type: Annotated[JobType, Field(alias="jobType")]
    max_retries: Annotated[
        int,
        Field(
            alias="maxRetries",
            description="How many times a failed attempt of a job of this type may be retried: its record's `metadata.maxRetries`.",
        ),
    ]


class JobsBudgets(WireModel, frozen=True, extra="forbid"):
    """
    jobs/budgets.json: the retry budget of each job type.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    budgets: Annotated[list[JobsBudgetsBudgetsItem], Field(description="One row for each job type.")]


class JobsStorageStream(WireModel, frozen=True, extra="forbid"):
    """
    The work-queue stream every job is published into.
    """

    name: str
    subject_root: Annotated[
        str,
        Field(
            alias="subjectRoot",
            description="The root of the subjects the stream captures: a job is published on `<subjectRoot>.<jobType>`.",
        ),
    ]


class JobsStorageConsumer(WireModel, frozen=True, extra="forbid"):
    """
    The durable consumer that delivers each job to the dispatcher holding its lease.
    """

    durable_name: Annotated[str, Field(alias="durableName")]


class JobsStorageBucket(WireModel, frozen=True, extra="forbid"):
    """
    The KV bucket that keeps one record per job, keyed by the job's id.
    """

    name: str
    record: Annotated[str, Field(description="The component schema each of the bucket's values is.")]


class JobsStorage(WireModel, frozen=True, extra="forbid"):
    """
    jobs/storage.json: where the job queue keeps its state on the broker.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    stream: JobsStorageStream
    consumer: JobsStorageConsumer
    bucket: JobsStorageBucket


type KbDid = Annotated[
    str, Field(description="A knowledge base's DID: `did:web:` and its domain. No API states one as such, so it is no component.")
]


class LocalEndpoint(WireModel, frozen=True):
    """
    A knowledge base the host process has loaded and reaches through a transport with no wire.
    """

    kind: Annotated[Literal["local"], Field(description="Discriminant: the endpoint is in the host process.")]
    kb_id: Annotated[
        str, Field(alias="kbId", description="Which loaded knowledge base, named by an id that means something to the host process alone.")
    ]


type KbEndpoint = Annotated[
    HttpEndpoint | LocalEndpoint,
    Field(
        description="How a knowledge base is reached: a gateway over HTTP, or a knowledge base the host process has loaded. Told apart by `kind`. Only what builds a transport, or signs in at an issuer, reads it.",
        discriminator="kind",
    ),
]


class KbIdentityConflict(WireModel, frozen=True, extra="forbid"):
    """
    A different knowledge base answers at a registered address. Both dids, because neither alone says what to do: a person has to recognise which knowledge base they registered and which one answers. What the session's signals raise (client/surface.json's `sessionSignals`).
    """

    expected_did: Annotated[str, Field(alias="expectedDid", description="The did the entry records.")]
    observed_did: Annotated[str, Field(alias="observedDid", description="The did the knowledge base that answered reported.")]


class KbRead(WireModel, frozen=True):
    """
    When a knowledge base last described itself, and what it said beyond its name. A client shows it as current only while a session to the knowledge base is live, and as of `at` otherwise.
    """

    at: Annotated[str, Field(description="When the description arrived.")]
    git_branch: Annotated[
        str | None,
        Field(
            alias="gitBranch",
            description="The branch of the knowledge base's working tree then. Absent when the working tree was not a git checkout.",
        ),
    ] = None


type KbReadKind = Annotated[
    Literal["recorded", "conflict", "no-verdict"], Field(description="What reading the active knowledge base against its entry concluded.")
]


class KbReadVerdictRecorded(WireModel, frozen=True, extra="forbid"):
    """
    It answered as that entry, and its name and branch are on the entry now.
    """

    kind: Literal["recorded"]


class KbReadVerdictConflict(WireModel, frozen=True, extra="forbid"):
    """
    A different knowledge base answered. Its did and the name it gave itself are here and nowhere else: the entry is as it was.
    """

    kind: Literal["conflict"]
    observed_did: Annotated[str, Field(alias="observedDid", description="The did the knowledge base that answered reported.")]
    observed_name: Annotated[str, Field(alias="observedName", description="The name the knowledge base that answered gave itself.")]


class KbReadVerdictNoVerdict(WireModel, frozen=True, extra="forbid"):
    """
    It did not answer, or could not say who it is. Evidence of nothing.
    """

    kind: Literal["no-verdict"]


type KbReadVerdict = Annotated[
    KbReadVerdictRecorded | KbReadVerdictConflict | KbReadVerdictNoVerdict,
    Field(
        description="What a knowledge base said when it was asked to describe itself, read against the entry it was asked as.",
        discriminator="kind",
    ),
]

type KbSessionStatus = Annotated[
    Literal["authenticated", "expired", "signed-out"],
    Field(
        description="What the credential stored for a knowledge base says, read without asking anyone: `authenticated`, a token is stored and has not expired; `expired`, a token is stored and has expired; `signed-out`, nothing is stored."
    ),
]


class KbTarget(WireModel, frozen=True):
    """
    Where to connect to a knowledge base: an endpoint, and the labels a client keeps of it. It carries no identity: which knowledge base answers at an address is known only once it has been reached with a token and asked, so a target is what every caller can build before then, and a session's whole input. A client keeps it locally; it is never sent.
    """

    id: Annotated[
        str,
        Field(
            description="The key the client stores a session's credentials under. Two sessions that share one storage have two ids, or each overwrites the other's tokens. Whoever builds the target chooses it; none is made up."
        ),
    ]
    label: Annotated[
        str, Field(description="What a person reads the knowledge base as. Once the knowledge base has described itself, its own name.")
    ]
    endpoint: KbEndpoint


class NewKnowledgeBase(WireModel, frozen=True):
    """
    What registering a knowledge base takes: everything a registered one holds but its id, which the client's list makes. It has a did, because registering follows a sign-in: the knowledge base has already said what it is.
    """

    label: Annotated[
        str, Field(description="What a person reads the knowledge base as. Once the knowledge base has described itself, its own name.")
    ]
    endpoint: KbEndpoint
    did: Annotated[str, Field(description="The did the knowledge base reported of itself.")]
    last_read: Annotated[
        KbRead | None,
        Field(
            alias="lastRead",
            description="The last time the knowledge base described itself. Absent until it has, in an answer that carried this entry's did.",
        ),
    ] = None


class KnowledgeBase(KbTarget, NewKnowledgeBase, frozen=True):
    """
    A registered knowledge base: a target, and what registering it took, the identity the knowledge base reported of itself when it was reached (`did`) among it. What a client's list of knowledge bases holds. A did says which knowledge base, not which running copy: a clone and a codespace of one repository are one knowledge base at two addresses and report one did. So an entry is looked up by its endpoint, and its did is what an answer is verified against; nothing selects by did. Its `label` and `lastRead` are written only from an answer that carried its did.
    """


type SessionState = Annotated[
    Literal["valid", "expired", "unverified", "none"],
    Field(
        description="valid: the stack's gateway accepts the stored token. expired: it refuses it (a refresh, or xynolog login, renews it). unverified: the stack did not answer. none: nothing is stored."
    ),
]


class Session(WireModel, frozen=True, extra="forbid"):
    """
    The launcher's own stored sign-in for a stack (xynolog login), never Desktop's. No token is in it.
    """

    state: SessionState
    email: Annotated[str | None, Field(description="The email the session was signed in as, when the store records one.")] = None


type ServiceGroup = Annotated[
    Literal["record", "index", "issuer", "knowledge-workers", "providers", "telemetry"],
    Field(
        description="A group of services, as xynolog status reports them and --group names them: a knowledge base's record and its index, the issuer that signs its accounts in, the knowledge workers where people and agents work on it, the providers of its models, and the telemetry that watches them all."
    ),
]

type ServiceStatusState = Annotated[
    Literal["running", "stopped", "reachable", "unreachable", "absent", "not-configured"],
    Field(
        description="running: its container runs. stopped: its container exists and does not run (containerState says how). reachable, unreachable: somebody else runs it, and its endpoint answers or does not. absent: there is no container of it. not-configured: the stack's documents ask for none."
    ),
]


class ServiceStatus(WireModel, frozen=True, extra="forbid"):
    """
    One service, as xynolog status reads it: where it runs, its state, and whether it answers. Nothing is reported that the launcher did not observe: an endpoint is named only when the stack's record or the descriptor names one, and a page to open only when the service answers.
    """

    role: Annotated[str, Field(description="The service, as xynolog status names it.")]
    group: Annotated[ServiceGroup, Field(description="The group it belongs to.")]
    product: Annotated[str | None, Field(description="The product its driver names (Neo4j, Keycloak), when its record names a driver.")] = (
        None
    )
    runs_on: Annotated[
        str | None,
        Field(
            alias="runsOn",
            description="Where it runs: the runtime its container runs under, external (somebody else runs it), or host (a process on this machine). Absent when nothing runs it.",
        ),
    ] = None
    state: ServiceStatusState
    container_state: Annotated[
        str | None,
        Field(alias="containerState", description="The runtime's own word for a container that is not running (exited, created)."),
    ] = None
    healthy: Annotated[bool, Field(description="Whether its health endpoint answers.")]
    counted: Annotated[
        bool,
        Field(
            description="Whether its health counts toward its knowledge base's: a service the documents ask for none of, and a telemetry backend --no-observe leaves out, do not."
        ),
    ]
    probe: Annotated[str | None, Field(description="The endpoint the launcher asks its health of: an http URL, or tcp://host:port.")] = None
    page: Annotated[
        str | None,
        Field(
            description="The page a person opens: the Browser, Jaeger's and Prometheus's interfaces, the collector's metrics readout. Present only when the service answers. The collector's OTLP receiver is never one."
        ),
    ] = None
    realm: Annotated[
        str | None, Field(description="For the issuer the knowledge base signs in at, when it is the machine's: its realm there.")
    ] = None
    serves: Annotated[
        list[str] | None,
        Field(description="For a service several knowledge bases share: the name of each it serves, as knowledgeBases names them."),
    ] = None


class WorkloadStatusLedger(WireModel, frozen=True, extra="forbid"):
    """
    The Gateway's request tracking: correlation IDs it currently holds so replies can be routed to the app client that sent each request, and the tracking capacity.
    """

    claims: Annotated[
        int,
        Field(
            description="Number of request IDs currently held to route replies to their requesting app clients. Includes requests still waiting for a reply and recently answered requests still within the tracking window."
        ),
    ]
    capacity: Annotated[int, Field(description="The maximum number of IDs held in this Gateway's local tracking projection.")]


class WorkloadStatusQueue(WireModel, frozen=True, extra="forbid"):
    """
    Current Dispatcher depth and, when the worker has emitted counters, completed and failed work since worker start. These are different measurements and time windows.
    """

    pending: Annotated[int, Field(description="Jobs currently waiting for a worker.")]
    running: Annotated[int, Field(description="Jobs currently claimed by workers.")]
    completed: Annotated[int | None, Field(description="Jobs completed since worker start.")] = None
    failed: Annotated[int | None, Field(description="Jobs finally failed since worker start.")] = None


class WorkloadStatus(WireModel, frozen=True, extra="forbid"):
    """
    A knowledge base's operational readings from Collector metrics. Request-tracking occupancy and queue depth are current gauges; completed and failed are worker counters since that worker process started. Missing readings are unknown, never zero.
    """

    ledger: WorkloadStatusLedger | None = None
    queue: WorkloadStatusQueue | None = None


class KnowledgeBaseStatus(WireModel, frozen=True, extra="forbid"):
    """
    One knowledge base's stack as xynolog status reads it: what it is, where it runs, and each of its own services. The services every knowledge base shares are reported once, in the snapshot's shared list.
    """

    name: Annotated[
        str,
        Field(
            description="What the snapshot calls the knowledge base: the last segment of its DID, or the whole DID where two would share one, or its key."
        ),
    ]
    key: Annotated[str, Field(description="The knowledge base's key on this machine, which names its containers and its state.")]
    recorded: Annotated[bool, Field(description="Whether a stack of it is recorded. When none is, its services are found by name.")]
    placement: KbPlacement
    root: Annotated[str | None, Field(description="Its clone, for a local stack.")] = None
    repo: Annotated[
        str | None, Field(description="owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity")
    ] = None
    did: Annotated[
        str | None,
        Field(
            description='The KB\'s did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.'
        ),
    ] = None
    site_name: Annotated[
        str | None,
        Field(alias="siteName", description="Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display"),
    ] = None
    identity_error: Annotated[
        str | None, Field(alias="identityError", description="Why its identity could not be read from its clone, when it could not.")
    ] = None
    kb: Annotated[DiscoveredKB | None, Field(description="The knowledge base as the discovery document publishes it, when it does.")] = None
    runtime: Annotated[Runtime | None, Field(description="The runtime its record names.")] = None
    gateway: Annotated[str | None, Field(description="The base URL of its gateway, from its record.")] = None
    secret_store: Annotated[
        str | None,
        Field(
            alias="secretStore",
            description="Where the values the launcher generates for it are kept, as xynolog settings secret-store describes it.",
        ),
    ] = None
    lan: Annotated[str | None, Field(description="This machine's address on the network, when the stack is started with network lan.")] = (
        None
    )
    starting: Annotated[
        bool, Field(description="Whether a xynolog start of it holds its start lock: its services are not ready, whatever they report.")
    ]
    session: Session | None = None
    healthy: Annotated[bool, Field(description="Whether each of its counted services, and the issuer it signs in at, answers.")]
    services: Annotated[
        list[ServiceStatus],
        Field(
            description="Its own services, group by group, then the issuer it signs in at. Empty for a codespace's, whose services its own launcher reports."
        ),
    ]
    workload: Annotated[
        WorkloadStatus | None,
        Field(
            description="The ledger and job queue readings the launcher can attribute to this knowledge base. A missing reading means the Collector has not reported that metric, not that its value is zero."
        ),
    ] = None


class KnowledgeIndexSpecGraphExternal(WireModel, frozen=True, extra="forbid"):
    """
    A graph store somebody else runs.
    """

    uri: Annotated[str, Field(description="Where it listens: `bolt://host:port`.")]
    password: SecretRef


class KnowledgeIndexSpecGraph(Runner, frozen=True):
    """
    The graph store the Weaver writes and the Librarian reads. The knowledge base's graph is in the database its DID names (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it when it first starts, and one somebody else runs must already hold it.
    """

    type: Annotated[str, Field(description="The graph store's driver: `neo4j`.")]
    username: Annotated[str, Field(description="The user the services sign in to the store as.")]
    image: Image | None = None
    resources: Resources | None = None
    external: KnowledgeIndexSpecGraphExternal | None = None


class KnowledgeIndexSpecVectorsShared(WireModel, frozen=True, extra="forbid"):
    """
    The vector store the launcher runs for the knowledge bases on a machine (the state home's VectorStore document). Each knowledge base keeps its index in collections of its own there, so nothing is said of it here.
    """


class KnowledgeIndexSpecVectorsExternal(WireModel, frozen=True, extra="forbid"):
    """
    A vector store somebody else runs, with the token each service presents to it: the Smelter's may make, write and delete this knowledge base's collections, and the Librarian's may read them.
    """

    host: Annotated[str, Field(description="A host name or address the stack's containers can reach.")]
    port: Annotated[int, Field(description="The port its REST API listens on.")]
    smelter_token: Annotated[SecretRef, Field(alias="smelterToken")]
    librarian_token: Annotated[SecretRef, Field(alias="librarianToken")]


class KnowledgeIndexSpecVectors(WireModel, frozen=True, extra="forbid"):
    """
    The vector store the Smelter writes and the Librarian reads: the one the launcher runs for the knowledge bases on a machine, at `shared`; one of the knowledge base's own the launcher runs, from `image` with `resources`; or somebody else's, at `external`. Exactly one of the three.
    """

    type: Annotated[str, Field(description="The vector store's driver: `qdrant`.")]
    shared: KnowledgeIndexSpecVectorsShared | None = None
    image: Image | None = None
    resources: Resources | None = None
    external: KnowledgeIndexSpecVectorsExternal | None = None


class KnowledgeIndexSpecEmbeddingChunking(WireModel, frozen=True, extra="forbid"):
    """
    How a text is cut before it is embedded.
    """

    chunk_size: Annotated[int, Field(alias="chunkSize", description="The size of a piece.")]
    overlap: Annotated[int, Field(description="How much of one piece the next repeats.")]


class KnowledgeIndexSpecEmbedding(WireModel, frozen=True, extra="forbid"):
    """
    The model that turns text into vectors. Vectors made by one model are not comparable with another's, so the model is the index's.
    """

    type: Annotated[str, Field(description="Who serves the model: `ollama`, or `voyage`.")]
    model: Annotated[str, Field(description="The model, as its provider names it.")]
    chunking: KnowledgeIndexSpecEmbeddingChunking
    endpoint: Annotated[
        str | None, Field(description="Where the provider's API is reached. The shared Ollama is stated by no endpoint.")
    ] = None
    api_key: Annotated[SecretRef | None, Field(alias="apiKey")] = None


class KnowledgeIndexSpecLibrarianGather(WireModel, frozen=True, extra="forbid"):
    """
    How a gather waits.
    """

    settle_timeout_ms: Annotated[
        int, Field(alias="settleTimeoutMs", description="How long a gather waits for the Smelter to settle a resource, in milliseconds.")
    ]


class KnowledgeIndexSpecLibrarianSearch(WireModel, frozen=True, extra="forbid"):
    """
    What a search by meaning keeps.
    """

    semantic_floor: Annotated[float, Field(alias="semanticFloor", description="The least similarity a hit by meaning must have.")]


class KnowledgeIndexSpecLibrarian(WireModel, frozen=True, extra="forbid"):
    """
    The Librarian: it answers gathers and searches from the indexes.
    """

    image: Image
    resources: Resources
    gather: KnowledgeIndexSpecLibrarianGather
    search: KnowledgeIndexSpecLibrarianSearch


class KnowledgeIndexSpecSmelter(WireModel, frozen=True, extra="forbid"):
    """
    The Smelter: it writes the vectors and the anchored text.
    """

    image: Image
    resources: Resources
    pdfs_at_once: Annotated[
        int,
        Field(
            alias="pdfsAtOnce",
            description="How many PDFs it works on at once. A page of a scan held for OCR is large; one for each 2G of its memory is a reading of what fits.",
        ),
    ]


class KnowledgeIndexSpecWeaver(WireModel, frozen=True, extra="forbid"):
    """
    The Weaver: it writes the graph.
    """

    image: Image
    resources: Resources


class KnowledgeIndexSpec(WireModel, frozen=True, extra="forbid"):
    """
    The indexes, the services that keep and read them, and the knowledge base they index.
    """

    knowledge_base: Annotated[
        str, Field(alias="knowledgeBase", description="The name of the KnowledgeBase document whose record this indexes.")
    ]
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    graph: KnowledgeIndexSpecGraph
    vectors: KnowledgeIndexSpecVectors
    embedding: KnowledgeIndexSpecEmbedding
    librarian: KnowledgeIndexSpecLibrarian
    smelter: KnowledgeIndexSpecSmelter
    weaver: KnowledgeIndexSpecWeaver


class KnowledgeIndex(WireModel, frozen=True, extra="forbid"):
    """
    What a knowledge base's record is indexed into, and the services that keep and read the indexes: the Weaver's graph, the Smelter's vectors and anchored text, and the Librarian that answers from them. Each can be rebuilt from the record.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["KnowledgeIndex"]
    metadata: Metadata
    spec: KnowledgeIndexSpec


type LastEventIds = Annotated[
    dict[ResourceId, PersistedEventId],
    Field(
        description="Where a knowledge base's stream was: for each scope, a resource's id, the id of the last recorded event delivered on it."
    ),
]


class QdrantVectorsConfig(WireModel, frozen=True, extra="forbid"):
    """
    A vector index kept in a Qdrant server, asked over its REST API with a token.
    """

    type: Literal["qdrant"]
    host: Annotated[str, Field(description="The server's host.")]
    port: Annotated[int, Field(description="The port its REST API listens on.")]
    token_env: Annotated[
        str,
        Field(
            alias="tokenEnv",
            description="The environment variable holding the token the service presents to the server on every request, which says what of the index it may read and write. The token is never a value here.",
        ),
    ]


class MemoryVectorsConfig(WireModel, frozen=True, extra="forbid"):
    """
    A vector index held in the memory of the one process that is given it: for a test. It cannot be shared between processes, so a service that writes the index for another to search, or searches what another wrote, refuses it.
    """

    type: Literal["memory"]


type VectorsConfig = Annotated[
    QdrantVectorsConfig | MemoryVectorsConfig,
    Field(
        description="The vector index a service writes or searches, and what that kind of index needs to be reached: one of the kinds `xynolog-vectors` has a store for, told apart by `type`.",
        discriminator="type",
    ),
]


class LibrarianEngineConfig(WireModel, frozen=True, extra="forbid"):
    """
    The engine a Librarian actor asks: which it is, and where its provider is reached.
    """

    engine: Engine
    base_url: Annotated[str, Field(alias="baseUrl", description="The address the provider's API is reached at.")]
    api_key_env: Annotated[
        str | None,
        Field(alias="apiKeyEnv", description="The environment variable holding the provider's API key, when the provider requires one."),
    ] = None


class LibrarianConfigGather(WireModel, frozen=True, extra="forbid"):
    """
    The bound on a gather.
    """

    settle_timeout_ms: Annotated[
        int,
        Field(
            alias="settleTimeoutMs",
            description="How long a gather around a resource waits for the Smelter's decision on it before answering without similar passages, in milliseconds.",
        ),
    ]


class LibrarianConfigSearch(WireModel, frozen=True, extra="forbid"):
    """
    The bound on a search by meaning.
    """

    semantic_floor: Annotated[float, Field(alias="semanticFloor", description="The least similarity a hit by meaning must have.")]


class LibrarianConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything a Librarian reads at boot: nothing in it is defaulted by the Librarian. Whoever starts a Librarian writes it, from the knowledge base's stack documents, and the Librarian reads it from the path its `--config` flag names. This schema is the contract, and a Librarian needs no launcher. Started without `--config`, or with a path that names no file, the Librarian refuses to start and says which. No secret is a value here: the graph database's password, an embedding provider's key and a model provider's key are each named by the environment variable that holds it, and the Librarian's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
    """

    kb: KbIdentity
    gateway_url: Annotated[
        str, Field(alias="gatewayUrl", description="The URL the Librarian reaches the gateway at: its route to the bus.")
    ]
    identity: Annotated[ServiceIdentity, Field(description="The issuer the Librarian's service account signs in at.")]
    archivist: Annotated[
        ServiceAddress,
        Field(description="Where the Archivist listens. The Librarian reads a resource's bytes from it, as its service account."),
    ]
    graph: GraphConfig
    vectors: VectorsConfig
    embedding: EmbeddingConfig
    matcher: LibrarianEngineConfig
    gatherer: LibrarianEngineConfig
    model_catalogue: Annotated[
        str,
        Field(
            alias="modelCatalogue",
            description="The path of a model catalogue file: what each model of a provider can take, for the providers whose own APIs do not say (`google`, `openai`, `together`). A Librarian whose matcher or gatherer is of one of those providers refuses to start where the file cannot be read, and where it states nothing of that model. A Librarian with no such model does not read it.",
        ),
    ]
    gather: LibrarianConfigGather
    search: LibrarianConfigSearch
    port: Annotated[int, Field(description="The port the Librarian answers `/health` on.")]
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


type LibrarianHealthActorsItem = Literal["matcher", "gatherer"]


class LibrarianHealth(WireModel, frozen=True, extra="forbid"):
    """
    The Librarian's health answer (LIBRARIAN.md § Health). Its port opens last, after it has begun to take requests from the bus, so a Librarian whose health answers is answering.
    """

    status: Literal["ok"]
    kb: Annotated[
        KbDid,
        Field(
            description="The DID of the knowledge base it serves: the one its document names, which that knowledge base said it is before the Librarian reached its stores."
        ),
    ]
    actors: Annotated[list[LibrarianHealthActorsItem], Field(description="The two actors it runs, `matcher` and `gatherer`.")]


class LibrarianPromptScore(WireModel, frozen=True, extra="forbid"):
    candidate: float
    score: float


type LimitRefusalCode = Annotated[
    Literal["streams", "emit-rate", "unanswered-requests", "capacity", "refusal-rate"],
    Field(
        description="`streams`: the principal already holds as many streams as its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's emits have used its bucket, whose rate and burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process. `unanswered-requests`: the client already awaits as many replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds as many queued bytes as it can. `refusal-rate`: the request's credential was refused, and the requests its holder has had refused have used their allowance; it answers only a request whose token has already failed verification, so it says what a 401 says, and a client that can renew its token renews it and sends the request again rather than waiting (contract/TRANSPORT-CONTRACT.md § A refused credential)."
    ),
]


class LimitRefusal(WireModel, frozen=True):
    """
    An ErrorResponse that names, in `code`, the limit the request met.
    """

    error: Annotated[str, Field(description="What went wrong, in a sentence.")]
    code: LimitRefusalCode
    hint: Annotated[str | None, Field(description="What the caller can do about it, when there is something to say.")] = None
    details: JsonValue | None = None


type OutputStream = Annotated[Literal["stdout", "stderr"], Field(description="Which of a container's streams a line was on.")]


class LogRecord(WireModel, frozen=True, extra="forbid"):
    """
    One line one of a stack's services wrote. The launcher removes from it each secret value the launcher generated or read; anything else the service wrote is the client's to handle. The launcher keeps no copy.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    service: Annotated[str, Field(description="The role whose container wrote the line, as xynolog status names it.")]
    stream: Annotated[OutputStream, Field(description="Which of the container's streams the line was on.")]
    line: Annotated[str, Field(description="The line, without its newline.")]
    received_at: Annotated[
        str,
        Field(
            alias="receivedAt",
            description="When the launcher read the line, in RFC 3339 with its fraction: a container's own lines carry the time it wrote them, if any.",
        ),
    ]


class LogsFollowParams(WireModel, frozen=True, extra="forbid"):
    """
    logs.follow's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[Runtime | None, Field(description="Keep to the local stacks, as --runtime does.")] = None
    service: Annotated[
        str | None, Field(description="Just this service's container, as --service names it. Absent: each Xynolog service the stack runs.")
    ] = None


class LogsFollowResult(WireModel, frozen=True, extra="forbid"):
    """
    A follow whose every source ended on its own. A follow the client cancels is answered with control.cancelled.
    """

    services: Annotated[list[str], Field(description="The services that were followed.")]


class MarkArchiveCommand(WireModel, frozen=True):
    """
    Bus command to archive a resource and optionally remove its file.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="Optional: where the resource's bytes live, so the archive can act on the file. An instruction to this handler, not a copy of the stored fact (that lives on the primary Representation). Working-tree URI, only file:// is supported.",
        ),
    ] = None
    keep_file: Annotated[bool | None, Field(alias="keepFile")] = None


class MarkCommitCommand(WireModel, frozen=True):
    """
    Bus command to persist a detection unit's annotations as one acknowledged batch. It is answered only after every annotation is in the event log, so a worker can gate unit completion on durability rather than on emission. The batch is the unit: a partial commit is reported as a failure, and the worker retries the whole unit, which is safe because annotation ids are deterministic: content-addressed, so re-emitting one is a no-op.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    roles: Annotated[
        list[str] | None,
        Field(
            alias="_roles",
            description="The emitter's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. An emitter carrying the worker role must cite the job this batch fulfils in `jobId`; the Stower refuses the batch otherwise.",
        ),
    ] = None
    job_id: Annotated[
        JobId | None,
        Field(
            alias="jobId",
            description="The job this batch fulfils. Required when the emitter carries the worker role; absent for self-initiated work (a person, or an agent acting on its own). The knowledge base derives who requested these annotations from the cited job's own events — the emitter never says who the work was for.",
        ),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="Resource every annotation in this batch targets.")]
    annotations: Annotated[
        list[Annotation],
        Field(
            description="The unit's annotations, already built with deterministic ids. Re-committing an identical batch is a no-op rather than a duplicate."
        ),
    ]


class MarkCommitOkResponse(WireModel, frozen=True):
    """
    What the commit persisted.
    """

    persisted: Annotated[
        int,
        Field(
            description="Annotations the command named that are durable in the event log. Equals the batch size on success, on a first commit and on a retry alike — the commit appends only what the resource does not already hold, so a wholly-redundant retry has still succeeded and says so. Not an append tally: a caller must never have to read a 0 as 'all good'."
        ),
    ]
    annotation_ids: Annotated[
        list[AnnotationId], Field(alias="annotationIds", description="Ids the batch covers, whether appended now or already present.")
    ]


class MarkCommitOk(WireModel, frozen=True):
    """
    Durability acknowledgement for a mark:commit batch: every annotation named by the command is in the event log at the moment this is emitted.
    """

    response: MarkCommitOkResponse


class MarkCreateOkResponse(WireModel, frozen=True):
    """
    The created annotation's identity.
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


class MarkCreateOk(WireModel, frozen=True):
    """
    Success reply after creating an annotation, matched to the originating command by correlationId.
    """

    response: MarkCreateOkResponse


class MarkCreateRequest(WireModel, frozen=True):
    """
    Raw annotation creation intent — bus handler assembles the W3C annotation
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    request: CreateAnnotationRequest


class MarkDelegateTimeoutEvent(WireModel, frozen=True):
    """
    The payload of `mark:delegate-timeout`, a client-local signal: a delegated job went silent past its deadline, with no progress, no completion and no `job:fail`. A real job failure arrives as `job:fail` and never produces this.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource the job was delegated for.")]
    motivation: Motivation


class MarkDeleteCommand(WireModel, frozen=True):
    """
    Bus command to delete an annotation.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    resource_id: Annotated[ResourceId | None, Field(alias="resourceId")] = None


class MarkDeleteOkResponse(WireModel, frozen=True):
    """
    The deleted annotation's identity.
    """

    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]


class MarkDeleteOk(WireModel, frozen=True):
    """
    Success reply after deleting an annotation, matched to the originating command by correlationId.
    """

    response: MarkDeleteOkResponse


class MarkRequestedEvent(WireModel, frozen=True):
    """
    Emitted when the user requests a new mark (annotation) on a resource
    """

    source: Annotated[
        ResourceId,
        Field(
            description="The '@id' of the resource the mark belongs to (W3C target.source). Routes the event to the right viewer/state unit when a host mounts many viewers on one session."
        ),
    ]
    selector: Annotated[AnnotationSelector, Field(description="One or more W3C selectors")]
    motivation: Motivation


class MarkSubmitEvent(WireModel, frozen=True):
    """
    Emitted when a mark is submitted with its annotation body
    """

    source: Annotated[
        ResourceId,
        Field(
            description="The '@id' of the resource the mark belongs to (W3C target.source). Routes the submit to the state unit bound to that resource — without it, N mounted units each create the annotation (N copies on N resources)."
        ),
    ]
    motivation: Motivation
    selector: Annotated[AnnotationSelector, Field(description="One or more W3C selectors")]
    body: Annotated[
        AnnotationBodies | None,
        Field(
            description="Optional body. Omit for annotations whose motivation alone is meaningful (e.g. highlighting) or whose user-supplied content is empty (e.g. an assessing annotation saved without comment text). Shape matches Annotation.body."
        ),
    ] = None


class MarkUnarchiveCommand(WireModel, frozen=True):
    """
    Bus command to unarchive a previously archived resource.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="Optional: where the resource's bytes are expected to be. When present the handler VERIFIES the file exists and fails loudly if it does not, rather than succeeding as a no-op. An instruction, not a copy of the stored fact (that lives on the primary Representation). Working-tree URI, only file:// is supported.",
        ),
    ] = None


class MarkUpdateBodyCommand(WireModel, frozen=True):
    """
    Bus command to update an annotation's body with patch operations.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    annotation_id: Annotated[AnnotationId, Field(alias="annotationId")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    operations: list[BodyOperation]


class MarkUpdateEntityTypesCommand(WireModel, frozen=True):
    """
    Bus command to replace the entity types on a resource.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    current_entity_types: Annotated[list[str], Field(alias="currentEntityTypes")]
    updated_entity_types: Annotated[list[str], Field(alias="updatedEntityTypes")]


type MatchQuality = Annotated[
    Literal["normalized", "case-insensitive", "fuzzy"],
    Field(
        description="Which looser search found a quoted selection, stated of a span whose `anchorMethod` is `fuzzy-match` and only then. Which search finds it is reconcile's rule (specs/src/annotations/reconcile-cases.json)."
    ),
]


class MatchResourcesRequest(WireModel, frozen=True):
    """
    Request to search the knowledge base's resources by text. The Librarian answers: it matches the text lexically, and when nothing matches, by meaning.
    """

    search: Annotated[str, Field(description="The text to search for.")]
    archived: bool | None = None
    entity_type: Annotated[str | None, Field(alias="entityType")] = None
    offset: Annotated[
        int | None, Field(description="How many of the resources the search finds are passed over before the page begins.")
    ] = None
    limit: Annotated[int | None, Field(description="The most resources a page has.")] = None


type MatchResourcesResponseMatchKind = Annotated[
    Literal["lexical", "semantic"],
    Field(
        description="What kind of answer this is: 'lexical' — the resources matched the query text; 'semantic' — no lexical match existed, and these resources discuss the query per the vector index. Required so every producer labels its answer; a UI can render semantic results as a different kind of page ('no title matches, but these documents discuss it')."
    ),
]


class MatchResourcesResponse(WireModel, frozen=True):
    """
    One page of the resources a text search found, and which kind of answer it is.
    """

    resources: list[ResourceDescriptor]
    total: Annotated[int, Field(description="How many resources the search found in all, and not only on this page.")]
    offset: Annotated[
        int, Field(description="How many of the resources the search found were passed over before this page, as the request stated.")
    ]
    limit: Annotated[int, Field(description="The limit the search was made with.")]
    match_kind: Annotated[MatchResourcesResponseMatchKind, Field(alias="matchKind")]


class MatchResourcesResult(WireModel, frozen=True):
    """
    Result of searching resources by text
    """

    response: MatchResourcesResponse


class MatchSearchFailed(CommandError, frozen=True):
    """
    The payload of `match:search-failed`: a CommandError that names the reference whose candidates could not be searched for.
    """

    reference_id: Annotated[AnnotationId, Field(alias="referenceId", description="The reference the search was asked for.")]


class MatchSearchOptions(WireModel, frozen=True, extra="forbid"):
    """
    What a search for what a reference could refer to is told beside the reference and its context: MatchSearchRequest's other members. client/surface.json's `match.search` cases state what is sent for one left out.
    """

    limit: Annotated[int | None, Field(description="Maximum number of candidate results to return")] = None
    use_semantic_scoring: Annotated[
        bool | None, Field(alias="useSemanticScoring", description="Enable semantic similarity scoring in addition to keyword matching")
    ] = None


class MatchSearchRequest(WireModel, frozen=True):
    """
    Request payload sent on the match:search-request bus channel to find candidate matches.
    """

    resource_id: Annotated[
        ResourceId,
        Field(
            alias="resourceId",
            description="Resource ID the reference annotation belongs to. Used to scope result events on the EventBus so the events-stream delivers them to participants viewing this resource.",
        ),
    ]
    reference_id: Annotated[AnnotationId, Field(alias="referenceId", description="Annotation ID of the reference to search candidates for")]
    context: Annotated[GatheredContext, Field(description="Gathered context for the reference annotation")]
    limit: Annotated[int | None, Field(description="Maximum number of candidate results to return")] = None
    use_semantic_scoring: Annotated[
        bool | None, Field(alias="useSemanticScoring", description="Enable semantic similarity scoring in addition to keyword matching")
    ] = None


class ScoredResource(ResourceDescriptor, frozen=True):
    """
    A resource returned by a search, carrying its relevance score and the reason it matched.
    """

    score: Annotated[float | None, Field(description="Relevance score assigned by the matcher; higher is a better candidate.")] = None
    match_reason: Annotated[str | None, Field(alias="matchReason", description="Human-readable reason for the match.")] = None


class MatchSearchResult(WireModel, frozen=True):
    """
    Search results payload emitted on match:search-results SSE channel.
    """

    reference_id: Annotated[AnnotationId, Field(alias="referenceId")]
    response: Annotated[list[ScoredResource], Field(description="The scored candidates, best first.")]


class MediaTokenRequest(WireModel, frozen=True):
    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource ID to generate a media token for")]


class MediaTokenResponse(WireModel, frozen=True):
    token: Annotated[str, Field(description="Short-lived media token for use as ?token= query parameter on resource URLs")]


class OpenResource(WireModel, frozen=True):
    """
    A resource open in a knowledge base: which resource, the name it is shown by, when it was opened and its place among the others open there. A registry shows them by their places, and two in one place by when each was opened, first first.
    """

    id: Annotated[ResourceId, Field(description="The resource.")]
    name: Annotated[str, Field(description="The name the resource is shown by.")]
    opened_at: Annotated[
        int,
        Field(
            alias="openedAt",
            description="When the resource was opened, in milliseconds since the Unix epoch. Opening it again while it is open changes neither this nor its place.",
        ),
    ]
    order: Annotated[
        int,
        Field(
            description="The resource's place among those open in the knowledge base. One opened is given the place after the last taken, so a place freed by closing one is not given twice; a move gives each its place in the new order, counted from 0."
        ),
    ]
    media_type: Annotated[
        str | None,
        Field(alias="mediaType", description="The resource's media type, which its icon is chosen by. Absent when it is not known."),
    ] = None
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="Where the resource is in the knowledge base's working tree, as a URI (file://docs/overview.md). Absent when it is not known.",
        ),
    ] = None


class PdfCoordinate(WireModel, frozen=True, extra="forbid"):
    """
    A rectangle on a page of a PDF, in PDF points, from the page's bottom-left corner with y increasing upward: what an RFC 3778 fragment selector names.
    """

    page: Annotated[int, Field(description="The page the rectangle is on.")]
    x: Annotated[float, Field(description="The rectangle's x.")]
    y: Annotated[float, Field(description="The rectangle's y.")]
    width: Annotated[float, Field(description="The rectangle's width.")]
    height: Annotated[float, Field(description="The rectangle's height.")]


class PendingAnnotation(WireModel, frozen=True, extra="forbid"):
    """
    The annotation a mark state unit is composing, from the selection a request asked for, until it is submitted or cancelled.
    """

    selector: AnnotationSelector
    motivation: Motivation


class PendingAuthorizationIssuer(WireModel, frozen=True):
    """
    The issuer the knowledge base trusts, and the endpoints of it a client uses.
    """

    issuer: Annotated[str, Field(description="The issuer's identifier.")]
    authorization: Annotated[str, Field(description="The issuer's authorization endpoint, where the person is sent.")]
    token: Annotated[str, Field(description="The issuer's token endpoint, where the code is exchanged.")]
    device: Annotated[
        str | None, Field(description="The issuer's device authorization endpoint (RFC 8628). Absent when the issuer has none.")
    ] = None
    revocation: Annotated[
        str | None, Field(description="The issuer's revocation endpoint (RFC 7009). Absent when the issuer has none.")
    ] = None


class PendingAuthorization(WireModel, frozen=True):
    """
    What a sign-in by a page redirect remembers across the trip to the issuer and back: the verifier and the state the issuer's response must match, where the person was connecting, what they believed they were connecting to, and the issuer's endpoints, so its completion asks nothing twice.
    """

    state: Annotated[str, Field(description="What the issuer's response must carry back to belong to this sign-in: random, as base64url.")]
    verifier: Annotated[
        str, Field(description="The PKCE code verifier (RFC 7636) the authorization code is exchanged with: random, as base64url.")
    ]
    redirect_uri: Annotated[
        str, Field(alias="redirectUri", description="Where the issuer sends the person back to, named again when the code is exchanged.")
    ]
    target: Annotated[HttpEndpoint, Field(description="Where the person was connecting.")]
    issuer: PendingAuthorizationIssuer
    kb_id: Annotated[
        str | None, Field(alias="kbId", description="The registered knowledge base being signed in to again. Absent when it is none.")
    ] = None
    expected_did: Annotated[
        str | None,
        Field(
            alias="expectedDid",
            description="The did of what the person believed they clicked, checked against the answer and never assumed. Absent when they named nothing.",
        ),
    ] = None
    expected_name: Annotated[
        str | None,
        Field(alias="expectedName", description="The name of what the person believed they clicked. Absent when they named nothing."),
    ] = None


class PermissionDenied(WireModel, frozen=True, extra="forbid"):
    """
    A request was refused for lack of permission. What the session's signals raise (client/surface.json's `sessionSignals`).
    """

    detail: Annotated[str | None, Field(description="The refusal's own message, untranslated; null when it gave none.")]


class PrincipalProfileCommand(WireModel, frozen=True):
    """
    Bus command saying what a principal is called. The gateway emits it when a principal ACTS, carrying the display name it just verified on its token; a principal may also emit it itself, for itself, which is how an agent, whose token carries no name, says what it is called. Either way the gateway stamps `_userId` with the sender's verified DID, so a principal names only itself. The Stower persists it as principal:profiled, and only when the name differs from the latest one recorded for that DID — so the log holds one line per name a principal has had, not one per act. A name is a fact ABOUT an identity, never part of the record of an act: no artifact carries it, and readers resolve it from the profiles projection. Emitted for a person and for an agent alike; never for a request that merely reads.
    """

    user_id: Annotated[
        UserId | None,
        Field(
            alias="_userId",
            description="The principal's DID, injected by the /bus/emit gateway from the verified token. Clients do not set this.",
        ),
    ] = None
    name: Annotated[
        str,
        Field(
            description="The display name: from the issuer's `name` claim, as verified on the token that carried an act, or what the principal said of itself. A token with no name produces no command from the gateway — the issuer is where a person's name is set, and absence is recorded as absence."
        ),
    ]


class PrincipalProfiledPayload(WireModel, frozen=True):
    """
    Payload for principal:profiled — what this principal is called, as the issuer's verified `name` claim said or as the principal said of itself, recorded once per change (system-level, no resourceId). The event's `userId` is the principal's DID; this payload is the fact about it. Provenance never reads it: every artifact joins on the DID alone, and this is projected into profiles.json for readers to resolve against. Two lines for one DID mean the name changed, and the timestamps say when — which is why no artifact ever had to freeze a copy.
    """

    name: Annotated[
        str,
        Field(
            description="The display name as of this event: from the issuer's verified `name` claim, or what the principal said of itself."
        ),
    ]


class ProfilesProjection(WireModel, frozen=True, extra="forbid"):
    """
    What the principals of a knowledge base are called: the file `projections/__system__/profiles.json` under the state directory, the sum of the `principal:profiled` events. The Archivist writes it; the Archivist and the Librarian read it to name the principals a reply mentions. Written as JSON indented by two spaces.
    """

    profiles: Annotated[dict[str, Profile], Field(description="Each principal's current profile, keyed by its DID.")]


type ProgressKind = Annotated[
    Literal["log", "note", "ok", "warn", "fail", "banner", "section", "stamp", "command", "output"],
    Field(
        description="What the line is: narration (log, note), an outcome (ok, warn, fail), a heading (banner, section), a timestamp (stamp), a runtime command about to run (command), or text the operation printed (output)."
    ),
]


class Progress(WireModel, frozen=True, extra="forbid"):
    """
    One line of what an operation is doing, as the command line would tell a person, without colour. A secret value the launcher generated or read never appears in one.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    kind: ProgressKind
    text: Annotated[str, Field(description="The line.")]


class ProjectConfigProject(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's name.
    """

    name: Annotated[str, Field(description="The knowledge base's name, which decides where its state is kept.")]
    version: Annotated[str | None, Field(description="A version the knowledge base's author gives it. Nothing changes it.")] = None


class ProjectConfigGit(WireModel, frozen=True, extra="forbid"):
    """
    How the knowledge base's changes reach git.
    """

    sync: Annotated[bool, Field(description="Whether changes to the working tree and the event log are staged in git as they are made.")]


class ProjectConfigSite(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's identity.
    """

    domain: Annotated[
        str,
        Field(
            description="The knowledge base's permanent identity, in did:web's colon-path form (`owner.github.io:repo`): stamped into every event it records, so never a machine's address and never changed. With no white space in it, which no DID holds (UserId.json)."
        ),
    ]
    site_name: Annotated[str, Field(alias="siteName", description="The name people see for the knowledge base.")]


class ProjectConfig(WireModel, frozen=True, extra="forbid"):
    """
    A knowledge base's committed `.xynolog/config.yaml`: its name, whether its changes are staged in git, and its permanent identity. A deployment's documents never restate any of it.
    """

    project: ProjectConfigProject
    git: ProjectConfigGit
    site: ProjectConfigSite


class ProtectedResourceMetadata(WireModel, frozen=True, extra="forbid"):
    """
    OAuth 2.0 Protected Resource Metadata (RFC 9728): which authorization server this knowledge base trusts, served at /.well-known/oauth-protected-resource so a client — the Browser, an MCP client — learns where to send a user to sign in without configuration. A 401 from any protected route points here in its WWW-Authenticate challenge.
    """

    resource: Annotated[
        str,
        Field(
            description="This knowledge base's resource identifier: its did:web identity resolved to an https URL (did:web:example.github.io:my-kb identifies https://example.github.io/my-kb). This is the exact value a token's aud claim must carry. It is an identifier, not an address — nothing dereferences it, and a knowledge base reached over http in local development still names itself by the https form, which is what makes the value stable across every host, port and proxy it is reached through."
        ),
    ]
    authorization_servers: Annotated[
        list[str], Field(description="Issuer identifiers whose tokens this resource accepts — the configured identity issuer.")
    ]
    bearer_methods_supported: Annotated[
        list[Literal["header"]], Field(description="How a bearer token reaches this resource: the Authorization header only.")
    ]
    resource_name: Annotated[str | None, Field(description="The knowledge base's name, for a client's sign-in prompt.")] = None


class QuotedText(WireModel, frozen=True, extra="forbid"):
    """
    Words of a text, as a selection quotes them: the words themselves, and maybe the text just before and just after them, which tell apart the places they occur.
    """

    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None


class ReconciledSpanUniqueMatch(WireModel, frozen=True, extra="forbid"):
    """
    The text has the words in exactly one place.
    """

    start: Annotated[int, Field(description="The offset the span starts at, in Unicode code points from the text's start.")]
    end: Annotated[int, Field(description="The offset just past the span, in Unicode code points from the text's start.")]
    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None
    anchor_method: Annotated[Literal["unique-match"], Field(alias="anchorMethod")]


class ReconciledSpanContextRecovered(WireModel, frozen=True, extra="forbid"):
    """
    The text has the words in more than one place, and the span is the first that fits every hint the quote gave.
    """

    start: Annotated[int, Field(description="The offset the span starts at, in Unicode code points from the text's start.")]
    end: Annotated[int, Field(description="The offset just past the span, in Unicode code points from the text's start.")]
    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None
    anchor_method: Annotated[Literal["context-recovered"], Field(alias="anchorMethod")]


class ReconciledSpanFirstOfMany(WireModel, frozen=True, extra="forbid"):
    """
    The text has the words in more than one place, and the span is the first, since the quote gave no hint or none fits.
    """

    start: Annotated[int, Field(description="The offset the span starts at, in Unicode code points from the text's start.")]
    end: Annotated[int, Field(description="The offset just past the span, in Unicode code points from the text's start.")]
    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None
    anchor_method: Annotated[Literal["first-of-many"], Field(alias="anchorMethod")]


class ReconciledSpanFuzzyMatch(WireModel, frozen=True, extra="forbid"):
    """
    The text has the words nowhere, and a looser search found the span: `matchQuality` names which.
    """

    start: Annotated[int, Field(description="The offset the span starts at, in Unicode code points from the text's start.")]
    end: Annotated[int, Field(description="The offset just past the span, in Unicode code points from the text's start.")]
    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None
    anchor_method: Annotated[Literal["fuzzy-match"], Field(alias="anchorMethod")]
    match_quality: Annotated[MatchQuality, Field(alias="matchQuality")]


type ReconciledSpan = Annotated[
    ReconciledSpanUniqueMatch | ReconciledSpanContextRecovered | ReconciledSpanFirstOfMany | ReconciledSpanFuzzyMatch,
    Field(
        description="Where a quoted selection was found in a text, and how it was found, told apart by `anchorMethod`, one of AnchorMethod's words: a fuzzy match also names its search, `matchQuality`, and no other states one.",
        discriminator="anchor_method",
    ),
]


class RepresentationAddedPayload(WireModel, frozen=True):
    """
    Payload for yield:representation-added domain event
    """

    representation: Representation


type RepresentationNotFoundCode = Annotated[
    Literal["resource", "representation"], Field(description="A machine-readable class, when the route defines one.")
]


class RepresentationNotFound(WireModel, frozen=True):
    """
    The Archivist's 404 for a resource's bytes: an ErrorResponse whose `code` says which half of the lookup failed — `resource` when the record holds no such resource, `representation` when it holds the resource but not its bytes. Each reader answers the two differently.
    """

    error: Annotated[str, Field(description="What went wrong, in a sentence.")]
    code: RepresentationNotFoundCode
    hint: Annotated[str | None, Field(description="What the caller can do about it, when there is something to say.")] = None
    details: JsonValue | None = None


class RepresentationRemovedPayload(WireModel, frozen=True):
    """
    Payload for yield:representation-removed domain event
    """

    checksum: Annotated[str, Field(description="Checksum of the representation to remove")]


class ResourceAnnotations(WireModel, frozen=True, extra="forbid"):
    """
    The annotations on one resource, as its materialized view holds them.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    annotations: Annotated[
        list[Annotation],
        Field(
            description="Each annotation as the `mark:added` event that recorded it carried it, with the body changes recorded since applied. In the order they were first recorded."
        ),
    ]
    version: Annotated[int, Field(description="How many of the resource's events the view has applied.")]
    updated_at: Annotated[
        str, Field(alias="updatedAt", description="The timestamp of the last event applied; the empty string before any.")
    ]


class ResourceArchivedPayload(WireModel, frozen=True):
    """
    Payload for mark:archived domain event
    """

    reason: str | None = None


class ResourceClonedPayload(WireModel, frozen=True):
    """
    Payload for yield:cloned domain event
    """

    name: str
    format: ContentFormat
    content_checksum: Annotated[str, Field(alias="contentChecksum")]
    content_byte_size: Annotated[int | None, Field(alias="contentByteSize")] = None
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="Where the clone's bytes are, on the resource's primary Representation — the same single home `yield:created` writes to.",
        ),
    ] = None
    parent_resource_id: Annotated[ResourceId, Field(alias="parentResourceId")]
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes")] = None
    language: str | None = None
    creator: Annotated[
        Agent | None,
        Field(
            description="Who made the clone — the emitter, derived at write time. A clone is never job-fulfilling. Absent on events written before derivation existed, whose emitter was their only party."
        ),
    ] = None
    was_attributed_to: Annotated[
        OneOrMoreAgents | None,
        Field(
            alias="wasAttributedTo",
            description="PROV-O wasAttributedTo, derived at write time: the cloner alone. The value the resource view carries.",
        ),
    ] = None


class ResourceCreatedPayloadGeneratedFrom(WireModel, frozen=True):
    """
    What this resource was generated from: the resource, and the annotation on it when the generation was for one. The resource's descriptor names the resource as `wasDerivedFrom`.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    annotation_id: Annotated[AnnotationId | None, Field(alias="annotationId")] = None


class ResourceCreatedPayload(WireModel, frozen=True):
    """
    Payload for yield:created domain event
    """

    name: str
    format: ContentFormat
    content_checksum: Annotated[str, Field(alias="contentChecksum", description="SHA-256 of content")]
    content_byte_size: Annotated[int | None, Field(alias="contentByteSize")] = None
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes")] = None
    storage_uri: Annotated[
        str | None,
        Field(
            alias="storageUri",
            description="The creating instruction's URI, recorded on the event. Append-only, so this value never changes — the LOCATION the projection serves is maintained across moves and lives on the resource's primary Representation, relocated by yield:moved. Optional: a resource may have no bytes. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).",
        ),
    ] = None
    language: str | None = None
    is_draft: Annotated[bool | None, Field(alias="isDraft")] = None
    job_id: Annotated[
        JobId | None,
        Field(
            alias="jobId",
            description="The job this resource was made in fulfilment of, when its create cited one. A write that cites the same job on this resource, by the one who made it, is attributed to that job's requester: the `creator` here.",
        ),
    ] = None
    generated_from: Annotated[ResourceCreatedPayloadGeneratedFrom | None, Field(alias="generatedFrom")] = None
    generation_prompt: Annotated[str | None, Field(alias="generationPrompt")] = None
    generator: OneOrMoreAgents | None = None
    creator: Annotated[
        Agent | None,
        Field(
            description="Who requested this resource — derived by the knowledge base at write time, never sent by the emitter. For a resource created in fulfilment of a job, the requester recorded on that job's job:assigned; otherwise the emitter itself. Absent on events written before derivation existed, whose emitter was their only party."
        ),
    ] = None
    was_attributed_to: Annotated[
        OneOrMoreAgents | None,
        Field(
            alias="wasAttributedTo",
            description="PROV-O wasAttributedTo, derived at write time from `creator` and the executor: both parties when they differ, one when they are the same. The value the resource view carries; readers do not re-derive it.",
        ),
    ] = None


class ResourceErrorEvent(WireModel, frozen=True):
    """
    A client-local notice that a command on a resource failed, for a UI to show: the payload of `mark:create-error`, `mark:delete-error` and `bind:body-error`. Emitted by the caller that awaited the command, which knows whose command failed on which resource. The `*-failed` wire replies are correlation plumbing and are not for this.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource the command addressed.")]
    message: Annotated[str, Field(description="Human-readable error message.")]


class ResourceMovedPayload(WireModel, frozen=True):
    """
    Payload for yield:moved domain event
    """

    from_uri: Annotated[str, Field(alias="fromUri", description="Previous file:// URI")]
    to_uri: Annotated[str, Field(alias="toUri", description="New file:// URI")]


class ResourceSearchFilters(WireModel, frozen=True, extra="forbid"):
    """
    What a text search for resources is told beside its text: MatchResourcesRequest's other members. client/surface.json's `match.resources` cases state what is sent for one left out.
    """

    archived: bool | None = None
    entity_type: Annotated[str | None, Field(alias="entityType")] = None
    offset: Annotated[
        int | None, Field(description="How many of the resources the search finds are passed over before the page begins.")
    ] = None
    limit: Annotated[int | None, Field(description="The most resources a page has.")] = None


class ResourceUnarchivedPayload(WireModel, frozen=True):
    """
    Payload for mark:unarchived domain event (empty payload)
    """


class ResourceUpdatedPayload(WireModel, frozen=True):
    """
    Payload for yield:updated domain event
    """

    content_checksum: Annotated[str, Field(alias="contentChecksum", description="SHA-256 of new content")]
    content_byte_size: Annotated[int | None, Field(alias="contentByteSize")] = None


class ResourceUpload(WireModel, frozen=True):
    """
    The multipart upload that creates a resource. A client sends it to the gateway's `POST /resources`; the gateway forwards it untouched to the Archivist's `POST /resources`, which stores the bytes and records the resource. One body, two hops.
    """

    name: Annotated[str, Field(description="Human-readable resource name")]
    file: Annotated[Binary, Field(description="The bytes, as the part carries them.")]
    format: Annotated[str, Field(description="Media type of the content (e.g. text/plain, text/markdown, image/png)")]
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="Where the content lives (file://... for local). Required — the client names the location; the server does not derive one.",
        ),
    ]
    language: Annotated[str | None, Field(description="ISO 639-1 language code")] = None
    entity_types: Annotated[str | None, Field(alias="entityTypes", description="JSON-stringified array of entity type names")] = None
    source_annotation_id: Annotated[
        AnnotationId | None,
        Field(
            alias="sourceAnnotationId",
            description="For AI-generated resources: the annotation that triggered generation. Nested into generatedFrom.annotationId on the persisted event.",
        ),
    ] = None
    source_resource_id: Annotated[
        ResourceId | None,
        Field(
            alias="sourceResourceId",
            description="For AI-generated resources: the source resource the generating annotation lives on. Nested into generatedFrom.resourceId on the persisted event.",
        ),
    ] = None
    generation_prompt: Annotated[
        str | None, Field(alias="generationPrompt", description="For AI-generated resources: the prompt that drove generation")
    ] = None
    generator: Annotated[
        str | None,
        Field(
            description="For AI-generated resources: JSON-stringified Agent naming the model/worker that produced the content. Its identity must be the uploading agent's own — the knowledge base refuses a generator naming anyone else. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the cited job."
        ),
    ] = None
    job_id: Annotated[
        JobId | None,
        Field(
            alias="jobId",
            description="The job this resource fulfils, when a worker is creating it. Forwarded onto yield:create; the knowledge base derives who requested the resource from the cited job's own events, and refuses a worker-role create that cites none. Absent for a person's own upload.",
        ),
    ] = None
    is_draft: Annotated[str | None, Field(alias="isDraft", description="'true' or 'false' — whether the resource is a draft")] = None
    clone_token: Annotated[
        str | None,
        Field(
            alias="cloneToken",
            description="A clone token from `yield:clone-token-requested`. With it, the resource is created as a clone of the token's source, inheriting its entity types; `language`, `entityTypes` and the generation fields are then not read.",
        ),
    ] = None
    archive_original: Annotated[
        str | None, Field(alias="archiveOriginal", description="With `cloneToken`: 'true' archives the source once the clone exists.")
    ] = None


class ResourceView(WireModel, frozen=True, extra="forbid"):
    """
    A resource's materialized view: the file the Archivist writes at `resources/<ab>/<cd>/<resourceId>.json` under the knowledge base's state directory, and every reader of that file reads. It is what the resource's events add up to, and is rebuilt from the event log whenever it is missing. Written as JSON indented by two spaces, by writing a sibling temporary file and renaming it onto the path, so a reader sees a whole document or none.
    """

    resource: ResourceDescriptor
    annotations: ResourceAnnotations
    last_sequence: Annotated[
        int,
        Field(
            alias="lastSequence",
            description="The sequence number of the last event applied. A graph read that follows a write waits for the graph projection to reach it.",
        ),
    ]


class RetryBudget(WireModel, frozen=True, extra="forbid"):
    """
    A retry budget: how many `attempts` are allowed, with a backoff that starts at `initialDelayMs` and doubles to `maxDelayMs`.
    """

    attempts: Annotated[int, Field(description="How many attempts the budget allows.")]
    initial_delay_ms: Annotated[int, Field(alias="initialDelayMs", description="The delay before the second attempt, in milliseconds.")]
    max_delay_ms: Annotated[int, Field(alias="maxDelayMs", description="The longest delay between attempts, in milliseconds.")]


type RootCurrent = Annotated[
    Literal["cwd", "xynolog-root"],
    Field(
        description="For a local root: how the control server's own directory selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT."
    ),
]


class Root(WireModel, frozen=True, extra="forbid"):
    """
    One knowledge base this machine knows: a registered or running local clone, or a codespace stack recorded here. Registration, the directory, the stack and the forward are separate facts, each stated as it is.
    """

    placement: KbPlacement
    path: Annotated[str | None, Field(description="For a local root: the clone's path.")] = None
    present: Annotated[
        bool | None,
        Field(
            description="For a local root: whether the directory exists. A registered root whose directory is gone is kept, and says so."
        ),
    ] = None
    current: RootCurrent | None = None
    registered: Annotated[bool, Field(description="Whether the registry (roots.json) records it.")]
    running: Annotated[bool, Field(description="Whether a stack of it is recorded on this machine.")]
    last_used: Annotated[
        str | None, Field(alias="lastUsed", description="When a command last used it, in RFC 3339, as the registry records it.")
    ] = None
    did: Annotated[
        str | None,
        Field(
            description='The KB\'s did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy.'
        ),
    ] = None
    site_name: Annotated[
        str | None,
        Field(alias="siteName", description="Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display"),
    ] = None
    identity_error: Annotated[
        str | None, Field(alias="identityError", description="Why its identity could not be read from its clone, when it could not.")
    ] = None
    config: Annotated[str | None, Field(description="The Inference document a start of it runs, as the registry records it.")] = None
    configs: Annotated[
        list[str] | None,
        Field(description="For a present local root: the Inference documents its clone has, as start --config names them."),
    ] = None
    repo: Annotated[
        str | None, Field(description="owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity")
    ] = None
    codespace: Annotated[str | None, Field(description="For a codespace root: the codespace's name.")] = None
    codespace_state: Annotated[
        str | None,
        Field(
            alias="codespaceState",
            description="For a codespace root: GitHub's word for the codespace's state (Available, Shutdown), when gh answered.",
        ),
    ] = None
    forward_port: Annotated[
        int | None,
        Field(
            alias="forwardPort",
            description="For a codespace root: the port on this machine its knowledge base is forwarded to, when one is recorded.",
        ),
    ] = None
    forwarded: Annotated[bool | None, Field(description="For a codespace root: whether the recorded forward is alive.")] = None
    reachable: Annotated[
        bool | None, Field(description="For a codespace root: whether its knowledge base answers through the forward.")
    ] = None


class RootsForgetParams(WireModel, frozen=True, extra="forbid"):
    """
    roots.forget's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    root: Annotated[
        str, Field(description="The registered root to forget: its path, or its basename when only one registered root has it.")
    ]


class RootsForgetResult(WireModel, frozen=True, extra="forbid"):
    """
    A forgotten registry row. Only the row is removed: no file of the clone, and none of its persistent stack state.
    """

    path: Annotated[str, Field(description="The forgotten root's path.")]
    directory_missing: Annotated[bool, Field(alias="directoryMissing", description="Whether its directory was already gone.")]
    persistent_state: Annotated[
        str | None,
        Field(
            alias="persistentState",
            description="The key whose persistent stack state remains, when some does and no surviving root shares its DID: xynolog clean --root <key> removes it.",
        ),
    ] = None


type RootsInitParamsInference = Annotated[
    Literal["anthropic", "ollama"], Field(description="Inference provider for the generated local stack documents.")
]


class RootsInitParams(WireModel, frozen=True, extra="forbid"):
    """
    roots.init's params: the local directory, permanent identity, and optional configuration inputs xynolog init takes.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion")]
    path: Annotated[str, Field(description="Existing local directory in which to create the knowledge base.")]
    domain: Annotated[str, Field(description="The permanent did:web domain, in colon-path form, such as owner.github.io:repo.")]
    name: Annotated[str | None, Field(description="Project name. Absent: the directory basename.")] = None
    site_name: Annotated[str | None, Field(alias="siteName", description="Human-readable site name. Absent: the project name.")] = None
    inference: RootsInitParamsInference | None = None
    model: Annotated[str | None, Field(description="The primary model bound to roles and jobs.")] = None
    model_light: Annotated[str | None, Field(alias="modelLight", description="A light model example emitted in the generated config.")] = (
        None
    )
    embedding: Annotated[str | None, Field(description="Ollama embedding model name, without the ollama: prefix.")] = None
    config_name: Annotated[str | None, Field(alias="configName", description="Inference document name. Absent: the provider name.")] = None
    anthropic_endpoint: Annotated[str | None, Field(alias="anthropicEndpoint", description="Anthropic API base URL.")] = None
    ollama_base: Annotated[str | None, Field(alias="ollamaBase", description="Local Ollama API base URL.")] = None
    ollama_registry: Annotated[str | None, Field(alias="ollamaRegistry", description="Ollama registry base URL.")] = None


class RootsInitResult(WireModel, frozen=True, extra="forbid"):
    """
    The local directory where xynolog init created and registered the knowledge base.
    """

    path: str


class RootsListParams(WireModel, frozen=True, extra="forbid"):
    """
    roots.list's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]


class RootsListResult(WireModel, frozen=True, extra="forbid"):
    """
    Every knowledge base this machine knows, as xynolog roots lists them: the local roots first, then the codespace stacks.
    """

    roots: Annotated[list[Root], Field(description="Each root.")]
    warnings: Annotated[
        list[str] | None,
        Field(description="What xynolog roots warns of without failing: an invalid XYNOLOG_ROOT, a clone whose project file is refused."),
    ] = None


type RunInstance = Annotated[
    str,
    Field(
        description="A run's instance, by the name its caller gave it: unique among the target's instances that run on this machine. A second dispatcher beside the first is another instance. The launcher names the instance's container from the target's key and this name."
    ),
]

type RunService = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(
        description="One of a knowledge base's own services, which service.run runs: the seven Xynolog services, as service-telemetry/telemetry.json names them. The reader holds the two lists to each other."
    ),
]

type ServiceEnvironmentBootRefusalsServicesItem = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(description="A Xynolog service, by its name."),
]


class ServiceEnvironmentBootRefusalsRefusalsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    refusal: Annotated[
        str, Field(description="Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies.")
    ]


class ServiceEnvironmentBootRefusalsMembersItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    line: Annotated[str, Field(description="The line, filled as the row's `situation` says.")]


class ServiceEnvironmentBootRefusals(WireModel, frozen=True, extra="forbid"):
    """
    service-environment/boot-refusals.json: what a service writes when it refuses to start on its configuration document or its environment.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    services: Annotated[list[ServiceEnvironmentBootRefusalsServicesItem], Field(description="The services that refuse to start so.")]
    line: Annotated[
        str, Field(description="The one line the service writes to stderr, its refusal in place of `{refusal}`, before it exits.")
    ]
    exit_code: Annotated[int, Field(alias="exitCode", description="The status it exits with.")]
    refusals: Annotated[list[ServiceEnvironmentBootRefusalsRefusalsItem], Field(description="Each refusal.")]
    members: Annotated[
        list[ServiceEnvironmentBootRefusalsMembersItem],
        Field(description="Each line of the refusal `invalid`: one for each way the document is not its schema's."),
    ]


type ServiceEnvironmentVariablesVariablesItemServicesItem = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(description="A Xynolog service, by its name."),
]

type ServiceEnvironmentVariablesVariablesItemReadBy = Annotated[
    Literal["service", "opentelemetry"], Field(description="What reads it: the service's own code, or the OpenTelemetry SDK.")
]

type ServiceEnvironmentVariablesVariablesItemProvidedBy = Annotated[
    Literal["launcher", "image", "operator"], Field(description="What sets it where the launcher runs the service.")
]


class ServiceEnvironmentVariablesVariablesItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The variable's name.")]
    services: Annotated[list[ServiceEnvironmentVariablesVariablesItemServicesItem], Field(description="The services that read it.")]
    read_by: Annotated[ServiceEnvironmentVariablesVariablesItemReadBy, Field(alias="readBy")]
    provided_by: Annotated[ServiceEnvironmentVariablesVariablesItemProvidedBy, Field(alias="providedBy")]
    required: Annotated[bool, Field(description="Whether the service refuses to start without it.")]
    effect: Annotated[str, Field(description="What it does.")]


class ServiceEnvironmentVariables(WireModel, frozen=True, extra="forbid"):
    """
    service-environment/variables.json: every environment variable a Xynolog service reads, beside its configuration document.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    variables: list[ServiceEnvironmentVariablesVariablesItem]


class ServiceHostParams(WireModel, frozen=True, extra="forbid"):
    """
    service.host's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one."
        ),
    ] = None


class ServiceHostResult(WireModel, frozen=True, extra="forbid"):
    """
    Where this machine and a run's instance meet, under a runtime: the address the launcher publishes an instance's ports on, and the address the instance reaches this machine's listeners at. A caller writes it into a document before the run.
    """

    runtime: Runtime
    address: Annotated[
        str, Field(description="The host address: an IP address or a host name, as the launcher's own stack dials it under this runtime.")
    ]


class ServiceOutput(WireModel, frozen=True, extra="forbid"):
    """
    notifications/serviceOutput: one line a run's instance wrote, from its start, every line, in the order of its stream, as the instance wrote it. The launcher gives an instance none of its own secrets (R2), and keeps no copy.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    instance: RunInstance
    stream: OutputStream
    line: Annotated[str, Field(description="The line, without its newline.")]


class ServiceRunParams(WireModel, frozen=True, extra="forbid"):
    """
    service.run's params: one instance of one of a knowledge base's own services, run once from the image the target's stack documents name, unsupervised, on the caller's document, arguments and environment. contract/LAUNCHER-CONTROL.md, R1-R8.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        LocalTarget,
        Field(
            description="The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too."
        ),
    ]
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one."
        ),
    ] = None
    service: Annotated[RunService, Field(description="The service whose image runs.")]
    instance: RunInstance
    document: Annotated[
        str | None,
        Field(
            description="The configuration document's text, written as it is, at the path the image's own arguments name: it need not be JSON. Absent: no file is at that path."
        ),
    ] = None
    args: Annotated[
        list[str] | None,
        Field(
            description="The arguments the image's program is given in place of the image's own (--config and the document's path). Absent: the image's own."
        ),
    ] = None
    environment: Annotated[
        dict[str, str],
        Field(
            description="Every variable the instance is given beside the image's own, by name: nothing of the launcher's is added (R2). Empty: none."
        ),
    ]
    mounts: Annotated[
        list[str],
        Field(
            description="Directories of this machine, each mounted read-write at its own path, so that a path the document names is the same inside the instance and out (R4). Empty: none."
        ),
    ]
    path_first: Annotated[
        list[str],
        Field(
            alias="pathFirst",
            description="Directories put before the image's PATH, in order, each mounted at its own path. Empty: the image's PATH as it is.",
        ),
    ]
    ports: Annotated[
        list[int],
        Field(description="The ports the instance listens on, each published at the same number on the host address (R3). Empty: none."),
    ]


class ServiceRunResult(WireModel, frozen=True, extra="forbid"):
    """
    A run that ended: its instance exited. Sent once the instance's container has exited, after all of its output.
    """

    instance: RunInstance
    exit_code: Annotated[
        int,
        Field(
            alias="exitCode",
            description="The instance's exit status: the service's own, since nothing supervises it (R1). An instance a signal ended exits with 128 and the signal's number: 143 for SIGTERM, 137 for SIGKILL.",
        ),
    ]
    ran_ms: Annotated[int, Field(alias="ranMs", description="Milliseconds from its container's start to its exit.")]


type ServiceSignalParamsSignal = Annotated[
    Literal["term", "kill"],
    Field(
        description="term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill: SIGKILL, so nothing it would settle on the way out is settled."
    ),
]


class ServiceSignalParams(WireModel, frozen=True, extra="forbid"):
    """
    service.signal's params: a signal for a run's instance.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        LocalTarget,
        Field(
            description="The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too."
        ),
    ]
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one."
        ),
    ] = None
    instance: RunInstance
    signal: ServiceSignalParamsSignal


class ServiceSignalResult(WireModel, frozen=True, extra="forbid"):
    """
    A signal sent, or not needed. The instance's exit is its run's answer, not this one.
    """

    delivered: Annotated[
        bool,
        Field(
            description="Whether the instance still ran when the signal came. false: it has exited, and its run's answer is on its way; nothing was sent."
        ),
    ]


class ServiceStarted(WireModel, frozen=True, extra="forbid"):
    """
    notifications/serviceStarted: a run's instance is running. Sent once, before any of its output.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    instance: RunInstance
    container: Annotated[str, Field(description="The runtime's name for the instance's container.")]
    document_path: Annotated[
        str | None,
        Field(
            alias="documentPath",
            description="Where the instance reads its document: the path the image's own arguments name. Present when the run gave a document.",
        ),
    ] = None
    address: Annotated[
        str, Field(description="The host address the instance's ports are published on, as service.host names it for the run's runtime.")
    ]


type ServiceTelemetryLogLinesLoggerServicesItem = Literal["archivist", "dispatcher", "gateway"]


class ServiceTelemetryLogLinesLoggerJson(WireModel, frozen=True, extra="forbid"):
    """
    A line of the `json` format.
    """

    first: Annotated[list[str], Field(description="Its first members, in order.")]
    request_id: Annotated[str, Field(alias="requestId", description="The member that names the request a line was logged while answering.")]
    trace: Annotated[list[str], Field(description="The members that name the active trace and span, in that order.")]
    last: Annotated[str, Field(description="Its last member: the moment.")]


class ServiceTelemetryLogLinesLogger(WireModel, frozen=True, extra="forbid"):
    """
    The lines of a service's logger.
    """

    services: Annotated[
        list[ServiceTelemetryLogLinesLoggerServicesItem], Field(description="The services whose document names a LogFormat.")
    ]
    json_: Annotated[ServiceTelemetryLogLinesLoggerJson, Field(alias="json")]
    simple: Annotated[str, Field(description="A line of the `simple` format.")]


class ServiceTelemetryLogLinesBusPartsItem(WireModel, frozen=True, extra="forbid"):
    part: Annotated[str, Field(description="What it shows.")]
    text: Annotated[str, Field(description="Its text.")]
    characters: Annotated[int | None, Field(description="How many characters of it are shown, from its first.")] = None


class ServiceTelemetryLogLinesBus(WireModel, frozen=True, extra="forbid"):
    """
    A line of the bus log.
    """

    line: Annotated[str, Field(description="Its head.")]
    parts: Annotated[
        list[ServiceTelemetryLogLinesBusPartsItem], Field(description="What follows the head, in order, each where there is one.")
    ]
    ops: Annotated[list[str], Field(description="Each operation a line names.")]


class ServiceTelemetryLogLinesSupervisor(WireModel, frozen=True, extra="forbid"):
    """
    The line the supervisor writes when it starts a service.
    """

    line: Annotated[str, Field(description="The line.")]
    counted: Annotated[str, Field(description="What a service counts the lines that hold of, for each of its lives.")]


class ServiceTelemetryLogLines(WireModel, frozen=True, extra="forbid"):
    """
    service-telemetry/log-lines.json: the lines a service writes to its log, and the line of its supervisor it counts.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    logger: ServiceTelemetryLogLinesLogger
    bus: ServiceTelemetryLogLinesBus
    supervisor: ServiceTelemetryLogLinesSupervisor


type ServiceTelemetryTelemetryResourceItemServicesItem = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(description="A Xynolog service, by its name."),
]


class ServiceTelemetryTelemetryResourceItem(WireModel, frozen=True, extra="forbid"):
    """
    An attribute of the resource the services' spans and metrics are exported under.
    """

    key: Annotated[str, Field(description="The attribute's key.")]
    services: Annotated[list[ServiceTelemetryTelemetryResourceItemServicesItem], Field(description="The services that export the row.")]
    meaning: Annotated[str, Field(description="What the attribute says.")]
    default: Annotated[str | None, Field(description="Its value when nothing says another, with `{service}` the service's name.")] = None


type ServiceTelemetryTelemetrySpansItemServicesItem = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(description="A Xynolog service, by its name."),
]

type ServiceTelemetryTelemetrySpansItemKind = Annotated[
    Literal["client", "consumer", "internal", "producer", "server"], Field(description="The span's kind, in OTLP's words.")
]

type ServiceTelemetryTelemetrySpansItemWhen = Annotated[
    Literal["export", "traffic", "supervised", "fatal"], Field(description="When the row arrives.")
]

type ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem = str | bool


class ServiceTelemetryTelemetrySpansItemAttributesItem(WireModel, frozen=True, extra="forbid"):
    """
    An attribute a row carries.
    """

    key: Annotated[str, Field(description="The attribute's key.")]
    only: Annotated[
        str | None, Field(description="When alone the attribute is carried: a row's attribute without it is carried every time.")
    ] = None
    values: Annotated[
        list[ServiceTelemetryTelemetrySpansItemAttributesItemValuesItem] | None,
        Field(description="The only values it carries, each of the type it is carried as: a string or a boolean."),
    ] = None


class ServiceTelemetryTelemetrySpansItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type.")]
    services: Annotated[list[ServiceTelemetryTelemetrySpansItemServicesItem], Field(description="The services that export the row.")]
    kind: ServiceTelemetryTelemetrySpansItemKind
    when: ServiceTelemetryTelemetrySpansItemWhen
    meaning: Annotated[str, Field(description="What the row says.")]
    attributes: Annotated[list[ServiceTelemetryTelemetrySpansItemAttributesItem], Field(description="The attributes the span carries.")]


type ServiceTelemetryTelemetryMetricsItemServicesItem = Annotated[
    Literal["archivist", "dispatcher", "gateway", "librarian", "smelter", "weaver", "worker"],
    Field(description="A Xynolog service, by its name."),
]

type ServiceTelemetryTelemetryMetricsItemInstrument = Annotated[
    Literal["counter", "up-down counter", "gauge", "histogram"], Field(description="The metric's instrument.")
]

type ServiceTelemetryTelemetryMetricsItemWhen = Annotated[
    Literal["export", "traffic", "supervised", "fatal"], Field(description="When the row arrives.")
]

type ServiceTelemetryTelemetryMetricsItemPlanesItem = Literal["in-process", "nats"]

type ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem = str | bool


class ServiceTelemetryTelemetryMetricsItemAttributesItem(WireModel, frozen=True, extra="forbid"):
    """
    An attribute a row carries.
    """

    key: Annotated[str, Field(description="The attribute's key.")]
    only: Annotated[
        str | None, Field(description="When alone the attribute is carried: a row's attribute without it is carried every time.")
    ] = None
    values: Annotated[
        list[ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem] | None,
        Field(description="The only values it carries, each of the type it is carried as: a string or a boolean."),
    ] = None


class ServiceTelemetryTelemetryMetricsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type.")]
    services: Annotated[list[ServiceTelemetryTelemetryMetricsItemServicesItem], Field(description="The services that export the row.")]
    instrument: ServiceTelemetryTelemetryMetricsItemInstrument
    when: ServiceTelemetryTelemetryMetricsItemWhen
    planes: Annotated[
        list[ServiceTelemetryTelemetryMetricsItemPlanesItem] | None, Field(description="The only signal planes a gateway row arrives on.")
    ] = None
    meaning: Annotated[str, Field(description="What the row says.")]
    attributes: Annotated[list[ServiceTelemetryTelemetryMetricsItemAttributesItem], Field(description="The attributes the span carries.")]


class ServiceTelemetryTelemetry(WireModel, frozen=True, extra="forbid"):
    """
    service-telemetry/telemetry.json: the telemetry each Xynolog service exports over OTLP: its spans and metrics, the services that export each, and the attributes each carries.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    sdk: Annotated[
        dict[str, list[str]],
        Field(
            description="The services that reach the bus through an SDK, and for each the SDK transports it uses, or of a transport it uses part of, the rows it exports."
        ),
    ]
    resource: list[ServiceTelemetryTelemetryResourceItem]
    spans: list[ServiceTelemetryTelemetrySpansItem]
    metrics: list[ServiceTelemetryTelemetryMetricsItem]


type SessionEndReason = Annotated[
    Literal["expired", "refused"],
    Field(
        description="Why a session ended: `expired`, the issuer refused to renew its token; `refused`, the gateway refused a token its issuer had just issued."
    ),
]


class SessionEnded(WireModel, frozen=True, extra="forbid"):
    """
    A session ended, and why. What the session's signals raise (client/surface.json's `sessionSignals`).
    """

    reason: Annotated[SessionEndReason, Field(description="Why it ended.")]


class SessionJoinedEvent(WireModel, frozen=True):
    """
    A participant opened a live connection to this KB — an SSE stream on /bus/subscribe. Presence is CONNECTION lifecycle, not login: a token can be minted and sit unused, so what this reports is that someone is WATCHING. One person with two tabs produces two of these, which is why connectionId is required — the DID alone cannot tell two connections apart, and a consumer that counts DIDs will undercount viewers.
    """

    participant: Annotated[
        UserId,
        Field(
            description="DID of the authenticated principal on that connection. A person or a software agent — the bus does not distinguish."
        ),
    ]
    connection_id: Annotated[
        str,
        Field(
            alias="connectionId",
            description="Identifies this connection for its lifetime. The matching session:left carries the same value.",
        ),
    ]


class SessionLeftEvent(WireModel, frozen=True):
    """
    A participant's live connection to this KB ended — the SSE stream aborted. Carries the same connectionId as the session:joined that opened it, so a consumer tracking who is present can retire the right connection rather than assuming one per participant.
    """

    participant: Annotated[UserId, Field(description="DID of the authenticated principal on that connection.")]
    connection_id: Annotated[str, Field(alias="connectionId", description="The connectionId announced by the matching session:joined.")]


type SettingAppliesTo = Annotated[
    Literal["machine", "knowledge-base"], Field(description="What it applies to: every knowledge base on this machine, or one.")
]


class SettingLine(WireModel, frozen=True, extra="forbid"):
    """
    One value of a setting, and where it came from, as xynolog settings shows it. A secret's value is never one: a secret setting shows where the value is kept.
    """

    value: Annotated[str, Field(description="The value in effect.")]
    source: Annotated[str, Field(description="Where it came from: a record, a document, the default.")]


class Setting(WireModel, frozen=True, extra="forbid"):
    """
    One setting the launcher keeps, as xynolog settings shows it.
    """

    name: Annotated[str, Field(description="Its name, as xynolog settings takes it.")]
    default: Annotated[
        bool, Field(description="Whether this is the machine-wide form of a knowledge-base setting (secret-store --default).")
    ]
    applies_to: Annotated[SettingAppliesTo, Field(alias="appliesTo")]
    values: Annotated[list[SettingLine], Field(description="The values in effect, one per line xynolog settings shows.")]
    settable: Annotated[bool, Field(description="Whether settings.set and settings.unset change it.")]
    changed_by: Annotated[str | None, Field(alias="changedBy", description="For one they do not: how it is changed instead.")] = None


class SettingsGetParams(WireModel, frozen=True, extra="forbid"):
    """
    settings.get's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    name: Annotated[str, Field(description="The setting, as xynolog settings names it.")]
    default: Annotated[bool | None, Field(description="The machine-wide form of a knowledge-base setting: --default.")] = None
    root: Annotated[
        str | None,
        Field(
            description="A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in."
        ),
    ] = None


class SettingsHoverDelayChangedEvent(WireModel, frozen=True):
    """
    Emitted when the hover delay setting changes
    """

    hover_delay_ms: Annotated[int, Field(alias="hoverDelayMs")]


class SettingsListParams(WireModel, frozen=True, extra="forbid"):
    """
    settings.list's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    root: Annotated[
        str | None,
        Field(
            description="A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in."
        ),
    ] = None


class SettingsListResult(WireModel, frozen=True, extra="forbid"):
    """
    Every setting the launcher keeps: the machine's, then the knowledge base's.
    """

    root: Annotated[str | None, Field(description="The knowledge base whose settings are listed, when one resolved.")] = None
    unresolved: Annotated[str | None, Field(description="Why no knowledge base resolved, when none did: its settings are not listed.")] = (
        None
    )
    settings: Annotated[list[Setting], Field(description="Each setting.")]


class SettingsLocaleChangedEvent(WireModel, frozen=True):
    """
    Emitted when the UI locale setting changes
    """

    locale: str


type SettingsPathParamsDocument = Annotated[
    Literal["browser", "worker", "issuer", "vectors"],
    Field(description="Whose document: the Browser's, the worker's, the issuer's or the vector store's."),
]


class SettingsPathParams(WireModel, frozen=True, extra="forbid"):
    """
    settings.path's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    document: SettingsPathParamsDocument


class SettingsPathResult(WireModel, frozen=True, extra="forbid"):
    """
    Where a machine document is. When there is none, it is written from the launcher's catalog first, as a start writes it; one that does not hold is refused, as a start refuses it.
    """

    path: Annotated[str, Field(description="The document's path.")]


class SettingsSetParams(WireModel, frozen=True, extra="forbid"):
    """
    settings.set's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    name: Annotated[str, Field(description="The setting, as xynolog settings names it.")]
    default: Annotated[bool | None, Field(description="The machine-wide form of a knowledge-base setting: --default.")] = None
    root: Annotated[
        str | None,
        Field(
            description="A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in."
        ),
    ] = None
    value: Annotated[str, Field(description="The value, checked as a start would check it.")]


type SettingsThemeChangedEventTheme = Literal["light", "dark", "system"]


class SettingsThemeChangedEvent(WireModel, frozen=True):
    """
    Emitted when the UI theme setting changes
    """

    theme: SettingsThemeChangedEventTheme


class SettingsUnsetParams(WireModel, frozen=True, extra="forbid"):
    """
    settings.unset's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    name: Annotated[str, Field(description="The setting, as xynolog settings names it.")]
    default: Annotated[bool | None, Field(description="The machine-wide form of a knowledge-base setting: --default.")] = None
    root: Annotated[
        str | None,
        Field(
            description="A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in."
        ),
    ] = None


class SignInOutcome(WireModel, frozen=True, extra="forbid"):
    """
    The entry a sign-in landed on, and what the person believed, so a host can set the two against each other and say when they differ. The sign-in stands either way: the knowledge base that answered is the one reached.
    """

    kb: Annotated[KnowledgeBase, Field(description="The entry the sign-in made or signed in to again.")]
    expected: Annotated[
        Expected | None, Field(description="What the person believed they were signing in to. Absent when they named nothing.")
    ] = None


class StoredSession(WireModel, frozen=True):
    """
    What is kept of a sign-in: the tokens an issuer issued, the client they were issued to, and the issuer's endpoints a renewal and a sign-out need, learned once at sign-in so no session asks again. TOKENS, never a password. A stored value that lacks a member it requires is no session.
    """

    access: Annotated[AccessToken, Field(description="The access token: short-lived, sent as a Bearer token.")]
    refresh: Annotated[str, Field(description="The refresh token: what renews the access token at the issuer without another sign-in.")]
    client_id: Annotated[
        str, Field(alias="clientId", description="The client the tokens were issued to, which a renewal and a revocation name.")
    ]
    token_endpoint: Annotated[
        str, Field(alias="tokenEndpoint", description="The issuer's token endpoint, where the refresh grant is made.")
    ]
    revocation_endpoint: Annotated[
        str | None,
        Field(
            alias="revocationEndpoint",
            description="The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none.",
        ),
    ] = None
    person_key: Annotated[
        str | None,
        Field(
            alias="personKey",
            description="Who the gateway said the sign-in's person is, as the key their caches and stream position are kept under (`lastEventIdKeyPrefix`), never the did itself. Written once the gateway names the person, on the sign-in whose token it was asked about; a renewal keeps it, a new sign-in starts without it, and forgetting the sign-in, however it is forgotten, reads it first to delete what is kept under it. Absent for a sign-in whose gateway has not yet named its person.",
        ),
    ] = None


class SignedIn(WireModel, frozen=True, extra="forbid"):
    """
    What a completed sign-in learned, as a registry is handed it to record: where it was, who the knowledge base there says it is, the tokens, and what the person believed they were signing in to.
    """

    endpoint: Annotated[KbEndpoint, Field(description="Where the sign-in was.")]
    description: Annotated[KbDescription, Field(description="What the knowledge base said of itself, asked with the new token.")]
    session: Annotated[StoredSession, Field(description="The tokens, as a registry keeps them.")]
    kb_id: Annotated[
        str | None, Field(alias="kbId", description="The registered knowledge base the person signed in to again. Absent when it is none.")
    ] = None
    expected_did: Annotated[
        str | None,
        Field(alias="expectedDid", description="The did of what the person believed they clicked. Absent when they named nothing."),
    ] = None
    expected_name: Annotated[
        str | None,
        Field(alias="expectedName", description="The name of what the person believed they clicked. Absent when they named nothing."),
    ] = None


class SmeltRebuildAnchorsCommand(WireModel, frozen=True):
    """
    Bus command to rebuild anchored-text artifacts by re-running extraction — every geometry-capable resource when resourceId is absent, one resource when present. Served by the Smelter, serialized (each unit can be a multi-second OCR pass), and never destructive: nothing is deleted first, stale entries are simply overwritten. Re-anchoring makes zero embedding calls — the vectors are already correct; only the derived map is re-made. Partial completion replies failed, with counts: a rebuild that quietly skipped resources would present exactly like a document with no text.
    """

    resource_id: Annotated[
        ResourceId | None,
        Field(
            alias="resourceId",
            description="When present, re-anchor only this resource; otherwise every geometry-capable resource in the catalog.",
        ),
    ] = None
    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None


type SmeltSettledOutcome = Literal["indexed", "skipped"]

type SmeltSettledReason = Annotated[
    Literal["no-extractor", "empty", "no-text-layer", "encrypted", "corrupt", "too-large"],
    Field(description="Why the content was skipped."),
]


class SmeltSettled(WireModel, frozen=True):
    """
    The payload of `smelt:settled`: the Smelter's decision for one resource's content, keyed by the checksum of the bytes it inspected. `indexed`: the content is in the vector index. `skipped`: it declined, and `reason` says why.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource whose content was inspected.")]
    content_checksum: Annotated[str, Field(alias="contentChecksum", description="The checksum of the bytes inspected.")]
    outcome: SmeltSettledOutcome
    reason: SmeltSettledReason | None = None


class SmelterChunking(WireModel, frozen=True, extra="forbid"):
    """
    The two numbers a text is cut by before it is embedded, both in tokens, a token being taken as four code points.
    """

    chunk_size: Annotated[int, Field(alias="chunkSize", description="The size of a chunk.")]
    overlap: Annotated[int, Field(description="How much of a chunk the next one repeats.")]


class SmelterConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything a Smelter reads at boot: nothing in it is defaulted by the Smelter. Whoever starts a Smelter writes it, from the knowledge base's stack documents, and the Smelter reads it from the path its `--config` flag names. This schema is the contract, and a Smelter needs no launcher. Started without `--config`, or with a path that names no file, the Smelter refuses to start and says which. No secret is a value here: an embedding provider's key is named by the environment variable that holds it, and the Smelter's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
    """

    kb: KbIdentity
    gateway_url: Annotated[str, Field(alias="gatewayUrl", description="The URL the Smelter reaches the gateway at: its route to the bus.")]
    identity: Annotated[ServiceIdentity, Field(description="The issuer the Smelter's service account signs in at.")]
    archivist: Annotated[
        ServiceAddress,
        Field(
            description="Where the Archivist listens. The Smelter reads a resource's bytes from it, and keeps the anchored-text store there, as its service account."
        ),
    ]
    embedding: EmbeddingConfig
    vectors: VectorsConfig
    chunking: SmelterChunking
    pdfs_at_once: Annotated[
        int,
        Field(
            alias="pdfsAtOnce",
            description="How many PDFs the Smelter works on at once. Each one under way holds its bytes, a page of a scan in pixels beside the OCR process reading it, and its text and vectors, so whoever starts a Smelter sizes this with the memory it gives it. Every other resource is indexed beside them.",
        ),
    ]
    cursors_path: Annotated[CursorsPath, Field(alias="cursorsPath")]
    port: Annotated[int, Field(description="The port the Smelter answers `/health` on.")]
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


type SmelterHealthReconcilePhase = Literal["pending", "running", "done", "failed"]


class SmelterReconcileSummary(WireModel, frozen=True, extra="forbid"):
    """
    What a Smelter's reconcile came to (SMELTER.md § Reconcile), as its health reports a pass that is done (SmelterHealth's `reconcile.summary`). The first four add up to how many resources it set out to index, less any whose indexing was no longer wanted when its turn came.
    """

    resources_embedded: Annotated[int, Field(alias="resourcesEmbedded", description="How many resources it set out to index were indexed.")]
    resources_skipped: Annotated[
        dict[str, int],
        Field(
            alias="resourcesSkipped",
            description="How many were skipped, by the reason each was skipped for: a reason `smelt:settled` carries (SmeltSettled).",
        ),
    ]
    resources_unavailable: Annotated[int, Field(alias="resourcesUnavailable", description="How many could not be read.")]
    resources_failed: Annotated[int, Field(alias="resourcesFailed", description="How many failed.")]
    resources_restamped: Annotated[
        int, Field(alias="resourcesRestamped", description="How many resources it planned to rewrite the entity types of.")
    ]
    resources_reanchored: Annotated[
        int, Field(alias="resourcesReanchored", description="How many resources it planned to derive the anchored text of again.")
    ]
    resource_vectors_deleted: Annotated[
        int, Field(alias="resourceVectorsDeleted", description="How many resources it planned to take out of the index.")
    ]
    annotations_embedded: Annotated[int, Field(alias="annotationsEmbedded", description="How many annotations it planned to index.")]
    annotations_restamped: Annotated[
        int, Field(alias="annotationsRestamped", description="How many annotations it planned to rewrite the entity types of.")
    ]
    annotation_vectors_deleted: Annotated[
        int, Field(alias="annotationVectorsDeleted", description="How many annotations it planned to take out of the index.")
    ]
    resources_eligible: Annotated[int, Field(alias="resourcesEligible", description="How many resources of the catalog have text.")]
    resources_indexed: Annotated[int, Field(alias="resourcesIndexed", description="How many resources have points when it ends.")]


class SmelterHealthReconcile(WireModel, frozen=True, extra="forbid"):
    """
    How far the latest reconcile has got: the pass's `summary` when it is done, or its `error` when it failed.
    """

    phase: SmelterHealthReconcilePhase
    summary: Annotated[SmelterReconcileSummary | None, Field(description="What the pass came to.")] = None
    error: Annotated[str | None, Field(description="Why it failed.")] = None


class SmelterHealthIndexStampEmbedding(WireModel, frozen=True, extra="forbid"):
    """
    The embedding provider's kind and model.
    """

    type: str
    model: str


class SmelterHealthIndexStamp(WireModel, frozen=True, extra="forbid"):
    """
    The model and the cut it makes an index by.
    """

    embedding: SmelterHealthIndexStampEmbedding
    chunking: SmelterChunking


class SmelterHealthIndex(WireModel, frozen=True, extra="forbid"):
    """
    What the Smelter holds its index to, and what this start did for that.
    """

    stamp: SmelterHealthIndexStamp
    made_anew: Annotated[
        bool,
        Field(
            alias="madeAnew",
            description="Whether this start made the index again, as it does where the index stated another stamp, or none.",
        ),
    ]


class SmelterHealth(WireModel, frozen=True, extra="forbid"):
    """
    The Smelter's health answer (SMELTER.md § Health): seven members, each from what the Smelter holds, for it asks nothing of the gateway, its embedding provider or its vector database to answer. `status` is `ok` whenever it answers, and says what else is so in the members beside it.
    """

    status: Literal["ok"]
    kb: Annotated[
        KbDid,
        Field(
            description="The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Smelter reached its index."
        ),
    ]
    stream: Annotated[
        ConnectionState,
        Field(
            description="The state of its own stream of the record, one of client/connection-states.json's. Events are delivered to it while it is `open`."
        ),
    ]
    following: Annotated[
        FollowerFollowing,
        Field(description="How far it has followed the record. Its sweep is also `due` where its start's reconcile failed."),
    ]
    events_processed: Annotated[
        int,
        Field(
            alias="eventsProcessed",
            description="How many events it has applied since it started: events of the kinds that do something, and not refused. Neither an event taken as nothing nor the work of a reconcile or a rebuild is counted.",
        ),
    ]
    reconcile: SmelterHealthReconcile
    index: SmelterHealthIndex


class SmelterMessagesRefusalsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    operation: Annotated[
        str, Field(description="The operation it refuses: a request of bus/registry.json's operations that the Smelter answers.")
    ]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    message: Annotated[
        str,
        Field(
            description="The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class SmelterMessagesLoggedItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    level: LogLevel
    situation: Annotated[
        str, Field(description="When it is written, what fills each `{name}` of its fields, and what each fact it carries says.")
    ]
    message: Annotated[str, Field(description="The line's message, word for word.")]
    fields: Annotated[
        dict[str, str],
        Field(
            description="The facts the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. A fact that is a number is its decimal digits."
        ),
    ]
    carries: Annotated[
        list[str],
        Field(
            description="The facts the line is logged with beside `fields`, whose value the row's `situation` says and whose form is not stated. The line may carry others."
        ),
    ]


class SmelterMessages(WireModel, frozen=True, extra="forbid"):
    """
    smelter/messages.json: the words of the Smelter's refusals, and of the messages it logs that a reader relies on.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    refusals: Annotated[
        list[SmelterMessagesRefusalsItem], Field(description="Each refusal of an operation, on the operation's failure channel.")
    ]
    logged: Annotated[
        list[SmelterMessagesLoggedItem], Field(description="Each message the Smelter logs that a reader of its output relies on.")
    ]


class StackKnowledgeBaseSpecGateway(WireModel, frozen=True, extra="forbid"):
    """
    The Gateway: where every client and every service reaches the knowledge base.
    """

    image: Image
    resources: Resources
    port: Annotated[int, Field(description="The port the Gateway is published on.")]
    public_url: Annotated[
        str,
        Field(
            alias="publicURL",
            description="Where clients reach the Gateway: the server its API document names. A service of the stack reaches it where the launcher places it, on `port`.",
        ),
    ]


class StackKnowledgeBaseSpecDispatcher(WireModel, frozen=True, extra="forbid"):
    """
    The Dispatcher: it hands queued jobs to workers.
    """

    image: Image
    resources: Resources


class StackKnowledgeBaseSpecArchivist(WireModel, frozen=True, extra="forbid"):
    """
    The Archivist: it keeps the knowledge base's record in its working tree.
    """

    image: Image
    resources: Resources
    address: Annotated[
        HostPort | None,
        Field(
            description="Where the stack's services reach the Archivist, when that is somewhere the launcher cannot see. Absent, they reach it where the launcher places it."
        ),
    ] = None


class StackKnowledgeBaseSpecMessagingJobs(WireModel, frozen=True, extra="forbid"):
    """
    The Dispatcher's queue.
    """

    type: Annotated[str, Field(description="The queue's driver: `jetstream`.")]


class StackKnowledgeBaseSpecMessagingSignal(WireModel, frozen=True, extra="forbid"):
    """
    The Gateway's signal plane.
    """

    type: Annotated[str, Field(description="`in-process`, one Gateway on its own fabric, or `nats`, on the broker.")]


class StackKnowledgeBaseSpecMessagingExternal(WireModel, frozen=True, extra="forbid"):
    """
    A broker somebody else runs, serving this knowledge base alone: a second knowledge base on it would share the job queue and, on a `nats` signal plane, the frames and the gateway's record of pending replies. The launcher refuses to start a knowledge base whose `servers` another knowledge base on its machine names.
    """

    servers: Annotated[str, Field(description="Where it listens: `host:port`.")]
    user: SecretRef
    password: SecretRef


class StackKnowledgeBaseSpecMessaging(Runner, frozen=True):
    """
    The broker the job queue and the signal plane share: the launcher's, run from `image`, or somebody else's, at `external`.
    """

    jobs: StackKnowledgeBaseSpecMessagingJobs
    signal: StackKnowledgeBaseSpecMessagingSignal
    image: Image | None = None
    resources: Resources | None = None
    external: StackKnowledgeBaseSpecMessagingExternal | None = None


class StackKnowledgeBaseSpecIssuerShared(WireModel, frozen=True, extra="forbid"):
    """
    The issuer the launcher runs for the knowledge bases on a machine (the state home's Issuer document). The launcher creates the knowledge base's realm in it.
    """

    access_token_lifespan: Annotated[
        int,
        Field(
            alias="accessTokenLifespan",
            description="How long a token the realm mints stays valid, in seconds: the window in which a disabled account can still act.",
        ),
    ]


class StackKnowledgeBaseSpecIssuerExternal(WireModel, frozen=True, extra="forbid"):
    """
    An issuer somebody else runs.
    """

    type: Annotated[str, Field(description="`oidc`, or `keycloak`.")]
    url: Annotated[str, Field(description="The URL in its tokens' `iss` claim.")]


class StackKnowledgeBaseSpecIssuer(WireModel, frozen=True, extra="forbid"):
    """
    The issuer the knowledge base trusts: the one the launcher runs for the knowledge bases on a machine, at `shared`, with the knowledge base's own realm in it, or somebody else's, at `external`.
    """

    shared: StackKnowledgeBaseSpecIssuerShared | None = None
    external: StackKnowledgeBaseSpecIssuerExternal | None = None
    subject_claim: Annotated[
        str, Field(alias="subjectClaim", description="The claim a person's DID is built from: did:web:<site domain>:users:<its value>.")
    ]


class StackKnowledgeBaseSpec(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's services, and how each runs.
    """

    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    gateway: StackKnowledgeBaseSpecGateway
    dispatcher: StackKnowledgeBaseSpecDispatcher
    archivist: StackKnowledgeBaseSpecArchivist
    messaging: StackKnowledgeBaseSpecMessaging
    issuer: StackKnowledgeBaseSpecIssuer


class StackKnowledgeBase(WireModel, frozen=True, extra="forbid"):
    """
    A knowledge base's record and the services that keep it: the Gateway, the Dispatcher, the Archivist, and the broker between them. They live and die with the knowledge base.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["KnowledgeBase"]
    metadata: Metadata
    spec: StackKnowledgeBaseSpec


type StackStartParamsOllamaCache = Annotated[
    Literal["host", "volume"],
    Field(
        description="Where a started Ollama keeps its models, as --ollama-cache names it. Absent: the host's ~/.ollama when there is one, else the named volume — what the command line's prompt does when nobody answers it."
    ),
]


class StackStartParams(WireModel, frozen=True, extra="forbid"):
    """
    stack.start's params: what xynolog start takes, but its help and its narration switches.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one."
        ),
    ] = None
    config: Annotated[
        str | None,
        Field(
            description="The Inference document to run, as --config names it. Absent: the knowledge base's recorded preference, else the default."
        ),
    ] = None
    service: Annotated[str | None, Field(description="Just this one service, as --service names it.")] = None
    group: Annotated[ServiceGroup | None, Field(description="Just this one group of services, as --group names it.")] = None
    codespace_name: Annotated[
        str | None,
        Field(alias="codespaceName", description="For a codespace target: which of the repository's codespaces, as --codespace names it."),
    ] = None
    machine: Annotated[str | None, Field(description="For a codespace target being created: its VM class, as --machine names it.")] = None
    idle_timeout: Annotated[
        str | None,
        Field(
            alias="idleTimeout", description="For a codespace target being created: inactivity before it stops, as --idle-timeout takes it."
        ),
    ] = None
    retention_period: Annotated[
        str | None,
        Field(
            alias="retentionPeriod",
            description="For a codespace target being created: how long a stopped codespace is kept, as --retention-period takes it.",
        ),
    ] = None
    observe: Annotated[
        bool | None,
        Field(description="Whether to start the telemetry backends, Jaeger and Prometheus. false is --no-observe. Absent: true."),
    ] = None
    ollama_cache: Annotated[StackStartParamsOllamaCache | None, Field(alias="ollamaCache")] = None
    dry_run: Annotated[
        bool | None,
        Field(
            alias="dryRun",
            description="Whether to run nothing, and report each runtime command a start would run as a command progress line.",
        ),
    ] = None


class StackStartResult(WireModel, frozen=True, extra="forbid"):
    """
    A start that ran to its end: the stack as status reads it afterwards. A start that failed is an error, whatever it started before it did; its progress lines say what it did.
    """

    dry_run: Annotated[bool, Field(alias="dryRun", description="Whether the start ran nothing.")]
    knowledge_base: Annotated[
        KnowledgeBaseStatus | None,
        Field(
            alias="knowledgeBase",
            description="The started knowledge base's stack, as status reads it after the start. Absent from a dry run, and from a start of services no knowledge base owns.",
        ),
    ] = None
    shared: Annotated[
        list[ServiceStatus] | None, Field(description="The shared services, as status reads them after the start. Absent from a dry run.")
    ] = None


class StackStopParams(WireModel, frozen=True, extra="forbid"):
    """
    stack.stop's params: what xynolog stop takes, but its help.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one."
        ),
    ] = None
    service: Annotated[str | None, Field(description="Just this one service, as --service names it.")] = None
    group: Annotated[ServiceGroup | None, Field(description="Just this one group of services, as --group names it.")] = None
    delete: Annotated[
        bool | None,
        Field(
            description="For a codespace target: destroy the codespace, state and all, and forget its record. The command line's --delete. Refused without deleteConfirmed."
        ),
    ] = None
    delete_confirmed: Annotated[
        bool | None,
        Field(
            alias="deleteConfirmed",
            description="That the person confirmed the deletion: delete is refused with control.confirmation-required without it.",
        ),
    ] = None
    dry_run: Annotated[
        bool | None,
        Field(
            alias="dryRun",
            description="Whether to stop nothing, and report each runtime command a stop would run as a command progress line.",
        ),
    ] = None


class StackStopResult(WireModel, frozen=True, extra="forbid"):
    """
    A stop that ran to its end: what status reads afterwards. A stop that failed is an error.
    """

    dry_run: Annotated[bool, Field(alias="dryRun", description="Whether the stop stopped nothing.")]
    knowledge_bases: Annotated[
        list[KnowledgeBaseStatus] | None,
        Field(
            alias="knowledgeBases",
            description="The knowledge bases still recorded, as status reads them after the stop. Absent from a dry run.",
        ),
    ] = None
    shared: Annotated[
        list[ServiceStatus] | None, Field(description="The shared services, as status reads them after the stop. Absent from a dry run.")
    ] = None


class StatusResponseFeatures(WireModel, frozen=True):
    semantic_content: Annotated[str, Field(alias="semanticContent")]
    collaboration: str


class StatusResponse(WireModel, frozen=True):
    status: str
    version: str
    features: StatusResponseFeatures
    message: str
    authenticated_as: Annotated[str | None, Field(alias="authenticatedAs")] = None


class StatusSnapshotParams(WireModel, frozen=True, extra="forbid"):
    """
    status.snapshot's params.
    """

    api_version: Annotated[ApiVersion, Field(alias="apiVersion", description="The version of the control API the request is written to.")]
    target: Annotated[
        Target | None,
        Field(
            description="Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started."
        ),
    ] = None
    runtime: Annotated[
        Runtime | None,
        Field(
            description="The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one."
        ),
    ] = None


class StatusSnapshotResult(WireModel, frozen=True, extra="forbid"):
    """
    What xynolog status reports: each knowledge base with its own services, and each service the knowledge bases share, once, with the knowledge bases it serves.
    """

    knowledge_bases: Annotated[
        list[KnowledgeBaseStatus],
        Field(
            alias="knowledgeBases",
            description="The target's stack; with no target, the stack of the knowledge base the control server stands in, else every recorded one.",
        ),
    ]
    shared: Annotated[
        list[ServiceStatus],
        Field(
            description="The services every knowledge base shares, group by group, and those the machine serves for the knowledge bases that name them."
        ),
    ]


class StorageUriEntry(WireModel, frozen=True, extra="forbid"):
    """
    One entry of the storage-uri index: the file `projections/storage-uri/<ab>/<cd>/<sha256 of the URI, hex>.json` under the state directory. It answers which resource's content is at a place in the working tree. Written as JSON indented by two spaces, `uri` first.
    """

    uri: Annotated[str, Field(description="The `file://` URI of a place in the working tree, relative to the knowledge base's root.")]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


type System = Annotated[
    Literal["macos", "windows", "other"],
    Field(description="What a state home differs by (sign-in-store/README.md): macOS, Windows, and every other system."),
]


class TabCheckGone(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base said the resource does not exist.
    """

    verdict: Literal["gone"]


class TabCheckReady(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base has the resource, and said what it is called now.
    """

    verdict: Literal["ready"]
    name: Annotated[str, Field(description="The name the knowledge base gave the resource.")]
    media_type: Annotated[
        str | None, Field(alias="mediaType", description="The media type of its primary representation. Absent when it said none.")
    ] = None


class TabCheckUnknown(WireModel, frozen=True, extra="forbid"):
    """
    The check found out nothing.
    """

    verdict: Literal["unknown"]


type TabCheck = Annotated[
    TabCheckGone | TabCheckReady | TabCheckUnknown,
    Field(
        description="What checking one open resource against its knowledge base concluded. `gone` is the only verdict that closes it, and it means the knowledge base said the resource does not exist, not that the check failed: a failed transport, a timeout and a peer that is down are each `unknown`, and an unknown resource stays open.",
        discriminator="verdict",
    ),
]

type TabVerdict = Annotated[
    Literal["gone", "ready", "unknown"], Field(description="What checking an open resource against its knowledge base concluded.")
]


class TagSchemaAddedPayload(WireModel, frozen=True):
    """
    Payload for frame:tag-schema-added domain event (system-level, no resourceId — fan-out is global to the KB).
    """

    schema_: Annotated[TagSchema, Field(alias="schema")]


class TagSchemasProjection(WireModel, frozen=True, extra="forbid"):
    """
    The knowledge base's tag schemas: the file `projections/__system__/tagschemas.json` under the state directory, the sum of the `frame:tag-schema-added` events. Written as JSON indented by two spaces.
    """

    tag_schemas: Annotated[
        list[TagSchema],
        Field(
            alias="tagSchemas",
            description="Every tag schema added, sorted by `id`. A schema added again under an `id` replaces the one held.",
        ),
    ]


class TextSpan(WireModel, frozen=True, extra="forbid"):
    """
    A span of a text: the code points from `start` up to but not including `end`, the words they are, and maybe the text just before and just after them.
    """

    start: Annotated[int, Field(description="The offset the span starts at, in Unicode code points from the text's start.")]
    end: Annotated[int, Field(description="The offset just past the span, in Unicode code points from the text's start.")]
    exact: Annotated[str, Field(description="The words quoted.")]
    prefix: Annotated[str | None, Field(description="The text just before them.")] = None
    suffix: Annotated[str | None, Field(description="The text just after them.")] = None


class TraceCarrier(WireModel, frozen=True, extra="forbid"):
    """
    A W3C trace context, as a relayed frame's trace field carries it (bus/registry.json `trace`) and a held job states it as its `trace`: the trace a frame was sent under, so its reader's work is recorded in the same trace.
    """

    traceparent: Annotated[str, Field(description="W3C `traceparent` (`00-<traceId>-<spanId>-<flags>`).")]
    tracestate: Annotated[str | None, Field(description="W3C `tracestate`, when the trace has one.")] = None


class UpdateAnnotationBodyRequest(WireModel, frozen=True):
    resource_id: Annotated[
        ResourceId, Field(alias="resourceId", description="Resource ID containing the annotation (required for O(1) Layer 3 lookup)")
    ]
    operations: Annotated[list[BodyOperation], Field(description="Array of body modification operations to apply")]


class UploadProgressStarted(WireModel, frozen=True, extra="forbid"):
    """
    The upload began.
    """

    phase: Literal["started"]
    total_bytes: Annotated[
        int | None,
        Field(alias="totalBytes", description="How many bytes the upload is: its ByteSource's length. Absent when the source states none."),
    ] = None


class UploadProgressProgress(WireModel, frozen=True, extra="forbid"):
    """
    Bytes were sent.
    """

    phase: Literal["progress"]
    bytes_uploaded: Annotated[int, Field(alias="bytesUploaded", description="How many bytes are sent so far.")]
    total_bytes: Annotated[
        int | None,
        Field(alias="totalBytes", description="How many bytes the upload is: its ByteSource's length. Absent when the source states none."),
    ] = None


class UploadProgressFinished(WireModel, frozen=True, extra="forbid"):
    """
    The upload ended, and the resource is made.
    """

    phase: Literal["finished"]
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


type UploadProgress = Annotated[
    UploadProgressStarted | UploadProgressProgress | UploadProgressFinished,
    Field(
        description="What an upload reports as it goes, told apart by `phase`: that it began, with its size when its ByteSource states one, then the bytes sent so far, then the resource made. An upload whose source states no length reports none: a size it made up would be a size the caller could not tell from a true one.",
        discriminator="phase",
    ),
]


class UserAction(WireModel, frozen=True, extra="forbid"):
    """
    A sign-in waits for a person: open the verification page and enter the code. The code is sent here and nowhere else — in no progress line, no log record and no diagnostic.
    """

    request_id: Annotated[RequestId, Field(alias="requestId")]
    verification_uri: Annotated[str, Field(alias="verificationUri", description="The page where the person enters the code.")]
    verification_uri_complete: Annotated[
        str | None, Field(alias="verificationUriComplete", description="The page with the code already in it, when the issuer offers one.")
    ] = None
    user_code: Annotated[str, Field(alias="userCode", description="The code the person enters.")]
    expires_in_seconds: Annotated[
        int, Field(alias="expiresInSeconds", description="How long the code is good for, from when it was issued.")
    ]


class UserResponse(WireModel, frozen=True):
    """
    The authenticated principal, as this knowledge base names it.

    The `did` is the identity: it is what the bus stamps on every event, what resource creation is attributed to, and what a client must compare against to recognise its own work in the data. It is the only identifier: a row id would appear nowhere else in the system and correlate with nothing.

    The remaining fields exist to be displayed, and all of them come from the token's own claims.
    """

    did: Annotated[
        UserId,
        Field(
            description="The authenticated principal's DID: `did:web:<domain>:agents:<subject>` for an agent, whose token's `kind` claim is `agent`, and `did:web:<domain>:users:<subject>` for a person, where the subject is the issuer claim the knowledge base names its principals by (`identity.subjectClaim`)."
        ),
    ]
    email: Annotated[
        str | None, Field(description="The address the token carries, when it carries one: an agent's account need not have one.")
    ]
    name: str | None
    image: str | None
    domain: Annotated[str, Field(description="The knowledge base's domain: the authority the principal is named under.")]


class VectorStoreSpec(WireModel, frozen=True, extra="forbid"):
    """
    The vector store, and where it is published.
    """

    type: Annotated[str, Field(description="The vector store's driver: `qdrant`.")]
    image: Image
    resources: Resources
    port: Annotated[
        int,
        Field(
            description="The port the vector store is published on, on this machine, where every knowledge base's Smelter and Librarian reach it."
        ),
    ]


class VectorStore(WireModel, frozen=True, extra="forbid"):
    """
    The vector store the launcher runs for the knowledge bases on a machine, each knowledge base's index in collections of its own. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/vectors.yaml`, not in a knowledge base's repository. A knowledge base keeps its index in it by naming `shared` at `spec.vectors`.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["VectorStore"]
    metadata: Metadata
    spec: VectorStoreSpec


class WeaveApplied(WireModel, frozen=True):
    """
    The payload of `weave:applied`: the Weaver has applied a resource's events to the graph up to this sequence number. Emitted after applying an event, or a batch's last event.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId", description="The resource whose events were applied.")]
    sequence_number: Annotated[int, Field(alias="sequenceNumber", description="The resource-stream sequence of the last applied event.")]


class WeaveRebuildCommand(WireModel, frozen=True):
    """
    Bus command to rebuild the graph projection from the event log — the whole graph when resourceId is absent, one resource when present. Served by the Weaver; replaces direct rebuild access, which does not survive the Weaver's container split.
    """

    resource_id: Annotated[
        ResourceId | None,
        Field(alias="resourceId", description="When present, rebuild only this resource; otherwise clear and rebuild the entire graph."),
    ] = None
    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None


class WeaverConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything a Weaver reads at boot: nothing in it is defaulted by the Weaver. The launcher writes it for the Weaver it starts, from the knowledge base's stack documents, and the Weaver reads it from the path its `--config` flag names (its image passes `/etc/xynolog/weaver.json`). Whoever starts a Weaver another way writes the same document: this schema is the contract, and a Weaver needs no launcher. Started without `--config`, or with a path that names no file, the Weaver refuses to start and says which. No secret is a value here: the graph database's password is named by the environment variable that holds it, and the Weaver's own service account is `XYNOLOG_OIDC_CLIENT_ID` and `XYNOLOG_OIDC_CLIENT_SECRET` in its environment. A document that does not validate is refused at boot, naming each failing field.
    """

    kb: KbIdentity
    gateway_url: Annotated[str, Field(alias="gatewayUrl", description="The URL the Weaver reaches the gateway at: its route to the bus.")]
    identity: Annotated[ServiceIdentity, Field(description="The issuer the Weaver's service account signs in at.")]
    archivist: Annotated[
        ServiceAddress,
        Field(
            description="Where the Archivist listens. The Weaver reads the record by position from it, and a resource's annotations, as its service account."
        ),
    ]
    graph: GraphConfig
    cursors_path: Annotated[CursorsPath, Field(alias="cursorsPath")]
    port: Annotated[int, Field(description="The port the Weaver answers `/health` on.")]
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


type WeaverHealthReconcilePhase = Literal["pending", "running", "done", "failed"]


class WeaverHealthReconcileSummary(WireModel, frozen=True, extra="forbid"):
    """
    What the pass found and did.
    """

    resources_checked: Annotated[int, Field(alias="resourcesChecked", description="How many resources it checked.")]
    divergent: Annotated[int, Field(description="How many of them were divergent: the graph held them otherwise than the record.")]
    healed: Annotated[int, Field(description="How many divergent resources it rebuilt.")]
    heal_failures: Annotated[
        int,
        Field(alias="healFailures", description="How many it did not heal, because the rebuild stopped at an event it could not apply."),
    ]
    orphaned: Annotated[
        int,
        Field(
            description="How many orphaned views it found: resources the catalog lists and the record holds no events for. Each is counted, and not healed."
        ),
    ]


class WeaverHealthReconcile(WireModel, frozen=True, extra="forbid"):
    """
    How far the reconcile its first sweep is followed by has got (WEAVER.md § Reconcile): the pass's `summary` when it is done, or its `error` when it failed.
    """

    phase: WeaverHealthReconcilePhase
    summary: WeaverHealthReconcileSummary | None = None
    error: Annotated[str | None, Field(description="Why it failed.")] = None


class WeaverHealth(WireModel, frozen=True, extra="forbid"):
    """
    The Weaver's health answer (WEAVER.md § Health). `status` is `ok` whenever the Weaver answers: it says nothing of whether the Weaver can reach the gateway or the graph.
    """

    status: Literal["ok"]
    kb: Annotated[
        KbDid,
        Field(
            description="The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Weaver connected to the graph database."
        ),
    ]
    following: FollowerFollowing
    reconcile: WeaverHealthReconcile


class WorkerActiveJob(WireModel, frozen=True, extra="forbid"):
    """
    The job an engine holds: which it is, of what type, and since when.
    """

    job_id: Annotated[JobId, Field(alias="jobId")]
    type: JobType
    since: Annotated[str, Field(description="When it was handed the job.")]


class WorkerAnswerFormatsFormatsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="A motivation a `mark` job takes, or `count`.")]
    about: Annotated[str, Field(description="What an element is, in prose.")]
    element: Annotated[JsonValue, Field(description="The JSON Schema of one element of the answer.")]


class WorkerAnswerFormats(WireModel, frozen=True, extra="forbid"):
    """
    worker/answer-formats.json: the element of the array each kind of detection asks a model for.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    formats: list[WorkerAnswerFormatsFormatsItem]


class WorkerKnowledgeBaseConfigIdentity(WireModel, frozen=True, extra="forbid"):
    """
    Where the worker signs in for this knowledge base, and as which client.
    """

    issuer: Annotated[str, Field(description="The issuer URL, exactly as tokens carry it in `iss`.")]
    client_id: Annotated[
        str,
        Field(
            alias="clientId",
            description="The client the issuer holds the public half of the worker's key on: the worker's account at this knowledge base. It is also what the worker says it is called there (`principal:profile`).",
        ),
    ]


class WorkerEngineConfig(WireModel, frozen=True, extra="forbid"):
    """
    One engine a worker runs: which it is, the jobs the worker claims to do with it, and where its provider is reached.
    """

    engine: Engine
    jobs: Annotated[
        list[JobFilter],
        Field(
            description="The jobs the worker claims to do with this engine, as a claim names them (`job:claim`'s `accepts`): it claims with these filters and no other."
        ),
    ]
    base_url: Annotated[str, Field(alias="baseUrl", description="The address the provider's API is reached at.")]
    api_key_env: Annotated[
        str | None,
        Field(alias="apiKeyEnv", description="The environment variable holding the provider's API key, when the provider requires one."),
    ] = None


class WorkerKnowledgeBaseConfig(WireModel, frozen=True, extra="forbid"):
    """
    One knowledge base a worker does jobs for: which it is, where its gateway is, the account the worker signs in as there, and the engines it offers it. The worker signs in, confirms the knowledge base and claims at each knowledge base apart from every other.
    """

    domain: Annotated[
        str,
        Field(
            description="The knowledge base's did:web domain, as it answers `browse:kb-requested`: which knowledge base this is. The worker confirms it there before it claims, and refuses a knowledge base that answers another domain, or none."
        ),
    ]
    gateway_url: Annotated[
        str,
        Field(
            alias="gatewayUrl",
            description="The URL the worker reaches the knowledge base's gateway at: its route to the bus and to a resource's bytes, and the only address of the knowledge base it holds.",
        ),
    ]
    identity: WorkerKnowledgeBaseConfigIdentity
    engines: Annotated[
        list[WorkerEngineConfig],
        Field(
            description="The engines the worker offers this knowledge base, and the jobs it does with each: its own choice, on its own providers' keys. It claims each engine's jobs there for it, so a job no engine here is used for is not claimed at this knowledge base."
        ),
    ]


class WorkerConfig(WireModel, frozen=True, extra="forbid"):
    """
    Everything a worker reads at boot: nothing in it is defaulted by the worker. The launcher writes it for the machine's worker, from the knowledge bases on that worker's list: each local knowledge base as its start places it, from its stack documents, and each added by `xynolog worker kb add`, offered the engines of the local one it was added from. The worker reads it from the path its `--config` flag names (its image passes `/etc/xynolog/worker.json`). Whoever starts a worker another way writes the same document: this schema is the contract, and a worker needs no launcher. Started without `--config`, or with a path that names no file, the worker refuses to start and says which. No secret is a value here: a provider's key is named by the environment variable that holds it, and the key the worker signs in with at every knowledge base is `XYNOLOG_OIDC_CLIENT_KEY` in its environment, an RSA private key; each knowledge base names the client that holds its public half there. A document that does not validate is refused at boot, naming each failing field.
    """

    knowledge_bases: Annotated[
        list[WorkerKnowledgeBaseConfig],
        Field(
            alias="knowledgeBases",
            description="The knowledge bases this worker does jobs for. At each it signs in, confirms which knowledge base it reached and claims for its engines, apart from every other: one knowledge base's trouble stops that knowledge base's work alone (`contract/WORKER-SERVICE.md` § Knowledge bases). No two name one `domain`, which the worker refuses at boot.",
        ),
    ]
    model_catalogue: Annotated[
        str,
        Field(
            alias="modelCatalogue",
            description="The path of a model catalogue file: what each model of a provider can take, for the providers whose own APIs do not say (`google`, `openai`, `together`). A worker with an engine of one of those providers refuses to start where the file cannot be read, and where it states nothing of that engine's model. A worker with no such engine does not read it.",
        ),
    ]
    port: Annotated[int, Field(description="The port the worker answers `/health` on.")]
    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    log_format: Annotated[LogFormat, Field(alias="logFormat")]


class WorkerEngineHealth(WireModel, frozen=True, extra="forbid"):
    """
    One engine at one knowledge base: which it is, the jobs it claims, and what its claims can say of themselves (WORKER-CONTRACT V1).
    """

    engine: Engine
    jobs: Annotated[list[JobFilter], Field(description="The jobs it claims, as its claims state them.")]
    last_queued_event_at: Annotated[
        str | None, Field(alias="lastQueuedEventAt", description="When a `job:queued` last reached it, or null.")
    ]
    last_claim_at: Annotated[
        str | None,
        Field(alias="lastClaimAt", description="When it was last handed a job, or null. A claim answered with none pending is not one."),
    ]
    last_finished_at: Annotated[str | None, Field(alias="lastFinishedAt", description="When a job it held last settled, or null.")]
    last_activity_at: Annotated[str | None, Field(alias="lastActivityAt", description="When it was last active, or null.")]
    active_job: Annotated[WorkerActiveJob | None, Field(alias="activeJob", description="The job it holds, or null.")]
    jobs_completed: Annotated[int, Field(alias="jobsCompleted", description="How many jobs it has completed since the service started.")]


type WorkerKnowledgeBaseHealthState = Annotated[
    Literal["starting", "working", "refused"],
    Field(
        description="`starting`: signing in, opening its stream, confirming it, or waiting to start again. `working`: confirmed, its engines claiming. `refused`: refused, until the service is started again."
    ),
]


class WorkerKnowledgeBaseHealth(WireModel, frozen=True, extra="forbid"):
    """
    One knowledge base the worker serves, as its health says it. `did` and `engines` are there while it is `working`, and only then.
    """

    domain: Annotated[str, Field(description="The entry's `domain`.")]
    state: WorkerKnowledgeBaseHealthState
    did: Annotated[str | None, Field(description="The agent's DID at this knowledge base, as its gateway named it.")] = None
    engines: Annotated[list[WorkerEngineHealth] | None, Field(description="One entry for each of the entry's engines, in its order.")] = (
        None
    )


class WorkerHealth(WireModel, frozen=True, extra="forbid"):
    """
    The Worker service's health answer (WORKER-SERVICE H1). It answers only once a knowledge base of its document is confirmed, so a 200 means it is working somewhere.
    """

    status: Literal["ok"]
    knowledge_bases: Annotated[
        list[WorkerKnowledgeBaseHealth],
        Field(alias="knowledgeBases", description="One entry for each of the document's `knowledgeBases`, in its order."),
    ]


class WorkerMessagesBootItemOwnBootRefusal(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    refusal: Annotated[
        str,
        Field(
            description="The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class WorkerMessagesBootItemSharedBootRefusal(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written. What fills its text is the shared row's.")]
    boot_refusal: Annotated[
        str,
        Field(
            alias="bootRefusal",
            description="The `name` of the row of service-environment/boot-refusals.json's `refusals` that is this refusal, with `{service}` `worker` and `{schema}` `WorkerConfig`.",
        ),
    ]


type WorkerMessagesBootItem = WorkerMessagesBootItemOwnBootRefusal | WorkerMessagesBootItemSharedBootRefusal


class WorkerMessagesReasonsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    line: Annotated[
        str,
        Field(
            description="The line, indented by two spaces. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class WorkerMessagesJob(WireModel, frozen=True, extra="forbid"):
    """
    How an error names the job, by its type, as `{job}`: `{motivation}` is a mark job's motivation.
    """

    mark: str
    yield_: Annotated[str, Field(alias="yield")]


class WorkerMessagesErrorsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    error: Annotated[
        str,
        Field(
            description="The error. `{job}` in it is the job, as `job` names it. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class WorkerMessagesDetailsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    detail: Annotated[
        str,
        Field(description="The detail. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."),
    ]


class WorkerMessagesWaitsItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    situation: Annotated[str, Field(description="When it is written, and what fills each `{name}` of its text.")]
    said: Annotated[
        str,
        Field(
            description="The wait, as the header stated it. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies."
        ),
    ]


class WorkerMessagesLoggedItem(WireModel, frozen=True, extra="forbid"):
    name: Annotated[str, Field(description="The situation's name.")]
    level: LogLevel
    situation: Annotated[
        str, Field(description="When it is written, what fills each `{name}` of its fields, and what each fact it carries says.")
    ]
    message: Annotated[str, Field(description="The line's message, word for word.")]
    fields: Annotated[
        dict[str, str],
        Field(
            description="The facts the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. A fact that is a number is its decimal digits."
        ),
    ]
    carries: Annotated[
        list[str],
        Field(
            description="The facts the line is logged with beside `fields`, whose value the row's `situation` says and whose form is not stated. The line may carry others."
        ),
    ]


class WorkerMessages(WireModel, frozen=True, extra="forbid"):
    """
    worker/messages.json: the words of a Worker service's refusals to start, of the errors it fails a job with, and of the messages it logs that a reader relies on.
    """

    comment: Annotated[str, Field(alias="$comment", description="The rule the table states, in prose.")]
    boot: Annotated[
        list[WorkerMessagesBootItem],
        Field(description="Each refusal to start, written in service-environment/boot-refusals.json's `line`."),
    ]
    reasons: Annotated[list[WorkerMessagesReasonsItem], Field(description="Each line of the `{reasons}` of `invalid`.")]
    job: WorkerMessagesJob
    errors: Annotated[
        list[WorkerMessagesErrorsItem],
        Field(description="Each error a job is failed with that is the worker's own: the `error` of its `job:fail`."),
    ]
    details: Annotated[list[WorkerMessagesDetailsItem], Field(description="Each `{detail}` of `unreadable`.")]
    waits: Annotated[list[WorkerMessagesWaitsItem], Field(description="Each `{said}` of `wait-stated`.")]
    logged: Annotated[
        list[WorkerMessagesLoggedItem], Field(description="Each message a Worker service logs that a reader of its output relies on.")
    ]


class WorkerPoolSpecWorker(WireModel, frozen=True, extra="forbid"):
    """
    The Worker.
    """

    image: Image
    resources: Resources


class WorkerPoolSpec(WireModel, frozen=True, extra="forbid"):
    """
    How the worker runs.
    """

    log_level: Annotated[LogLevel, Field(alias="logLevel")]
    worker: WorkerPoolSpecWorker


class WorkerPool(WireModel, frozen=True, extra="forbid"):
    """
    The shared worker that does knowledge bases' jobs: its image, its memory and its log level. They are shared, not any knowledge base's, so its document is kept in the launcher's state home, in `stack/workers.yaml`, not in a knowledge base's repository. A knowledge base's jobs are done when its Inference document gives a job an engine. A worker needs only the Gateway, and an issuer's token with the worker's role.
    """

    api_version: Annotated[StackApiVersion, Field(alias="apiVersion")]
    kind: Literal["WorkerPool"]
    metadata: Metadata
    spec: WorkerPoolSpec


class WorkerVitals(WireModel, frozen=True, extra="forbid"):
    """
    What a worker can say of itself at any moment (contract/WORKER-CONTRACT.md V1): what a worker's claims hand it as `vitals`, and what the worker service answers of each engine beside the engine and its jobs (worker/WorkerEngineHealth.json).
    """

    last_queued_event_at: Annotated[
        str | None, Field(alias="lastQueuedEventAt", description="When a `job:queued` last reached it, or null.")
    ]
    last_claim_at: Annotated[
        str | None,
        Field(alias="lastClaimAt", description="When it was last handed a job, or null. A claim answered with none pending is not one."),
    ]
    last_finished_at: Annotated[str | None, Field(alias="lastFinishedAt", description="When a job it held last settled, or null.")]
    last_activity_at: Annotated[str | None, Field(alias="lastActivityAt", description="When it was last active, or null.")]
    active_job: Annotated[WorkerActiveJob | None, Field(alias="activeJob", description="The job it holds, or null.")]
    jobs_completed: Annotated[int, Field(alias="jobsCompleted", description="How many jobs it has completed since the service started.")]


class YieldCloneCreateCommand(WireModel, frozen=True):
    """
    Bus command to create a cloned resource from a clone token. Bytes are stored by the upload path BEFORE this command is emitted, because bytes travel over HTTP and never over the bus — the command carries the storage coordinates, never content.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    token: str
    name: str
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="Where the caller already wrote the clone's bytes — an instruction, not a copy of the stored fact (that lives on the primary Representation). Bytes are stored through the byte door BEFORE this command is sent, so this names an existing file. Working-tree URI, only file:// is supported.",
        ),
    ]
    content_checksum: Annotated[str, Field(alias="contentChecksum")]
    byte_size: Annotated[int, Field(alias="byteSize")]
    format: ContentFormat
    archive_original: Annotated[bool | None, Field(alias="archiveOriginal")] = None


class YieldedResource(WireModel, frozen=True):
    """
    The resource a yield command wrote, by its id.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class YieldCloneCreated(WireModel, frozen=True):
    """
    Success response after creating a cloned resource.
    """

    response: YieldedResource


class YieldClonePersistCommand(WireModel, frozen=True):
    """
    Command: stow an already-uploaded clone's bytes and append `yield:cloned`.

    The INNER half of the clone flow. `yield:clone-create` reaches the CloneTokenManager, which alone can validate the token and read the source's entity types; it then emits this so the Stower — the only appendEvent caller — writes the domain event.

    Distinct from `yield:create` because a clone is a distinct operation, not a creation with an extra field. It REQUIRES a parent, and that requirement is what a separate command expresses: an optional `parentResourceId` on the create command could not say that a clone without a parent is not a clone. `ResourceClonedPayload` requires it for the same reason.

    Generated resources are NOT clones: they carry provenance in `generatedFrom` and stay on `yield:create`.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Injected by the gateway from the authenticated principal; never supplied by a wire caller."),
    ] = None
    name: str
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="The caller's instruction for WHERE the bytes are — the uploader wrote them before emitting this. The stored location lives on the clone's primary Representation, the one home of a storage URI.",
        ),
    ]
    content_checksum: Annotated[str, Field(alias="contentChecksum")]
    byte_size: Annotated[int, Field(alias="byteSize")]
    format: ContentFormat
    language: str | None = None
    entity_types: Annotated[
        list[str] | None,
        Field(
            alias="entityTypes",
            description="Inherited from the source resource by the CloneTokenManager, which is the only party that knows the token is valid.",
        ),
    ] = None
    parent_resource_id: Annotated[
        ResourceId,
        Field(
            alias="parentResourceId",
            description="The resource this one is cloned FROM. Required: it is what makes this a clone rather than a creation.",
        ),
    ]


class YieldClonePersistOk(WireModel, frozen=True):
    """
    Success reply after cloning a resource, matched to the originating command by correlationId.
    """

    response: Annotated[YieldedResource, Field(description="The clone's identity — a new resource, distinct from its parent.")]


class YieldCloneResourceRequest(WireModel, frozen=True):
    """
    Bus command to request cloning a resource using a clone token.
    """

    token: str


class YieldCloneTokenRequest(WireModel, frozen=True):
    """
    Bus command to request a clone token for a resource.
    """

    resource_id: Annotated[ResourceId, Field(alias="resourceId")]


class YieldCreateCommandGeneratedFrom(WireModel, frozen=True):
    resource_id: Annotated[ResourceId | None, Field(alias="resourceId")] = None
    annotation_id: Annotated[AnnotationId | None, Field(alias="annotationId")] = None


class YieldCreateCommand(WireModel, frozen=True):
    """
    Bus command to create a yielded resource in the knowledge base.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    roles: Annotated[
        list[str] | None,
        Field(
            alias="_roles",
            description="The emitter's capabilities (the token's `roles`), injected by the /bus/emit gateway. Clients do not set this. An emitter carrying the worker role must cite the job this resource fulfils in `jobId`; the Stower refuses the create otherwise.",
        ),
    ] = None
    job_id: Annotated[
        JobId | None,
        Field(
            alias="jobId",
            description="The job this resource fulfils. Required when the emitter carries the worker role; absent for self-initiated work (a person, or an agent acting on its own). The knowledge base derives who requested this resource from the cited job's own events — the emitter never says who the work was for.",
        ),
    ] = None
    name: str
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="The caller's instruction for WHERE the bytes are — not a copy of the stored fact. The stored location lives on the resource's primary Representation (`Representation.storageUri`), which is its single home; this field is the message that puts it there. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).",
        ),
    ]
    content_checksum: Annotated[str, Field(alias="contentChecksum")]
    byte_size: Annotated[int, Field(alias="byteSize")]
    format: ContentFormat
    language: str | None = None
    entity_types: Annotated[list[str] | None, Field(alias="entityTypes")] = None
    is_draft: Annotated[bool | None, Field(alias="isDraft")] = None
    generated_from: Annotated[YieldCreateCommandGeneratedFrom | None, Field(alias="generatedFrom")] = None
    generation_prompt: Annotated[str | None, Field(alias="generationPrompt")] = None
    generator: Annotated[
        OneOrMoreAgents | None,
        Field(
            description="The Software peer that produced the content, when software did. Its identity must be the emitter's own — the knowledge base refuses a generator naming anyone else, and supplies it from the verified emitter when omitted. `creator` and `wasAttributedTo` are never sent; the knowledge base derives them from the emitter and the cited job."
        ),
    ] = None


class YieldCreateOk(WireModel, frozen=True):
    """
    Success reply after creating a yielded resource, matched to the originating command by correlationId.
    """

    response: Annotated[YieldedResource, Field(description="The created resource's identity.")]


class YieldUpdateCommand(WireModel, frozen=True):
    """
    Bus command to update a yielded resource's storage content.
    """

    user_id: Annotated[
        UserId | None,
        Field(alias="_userId", description="Authenticated user's DID, injected by the /bus/emit gateway. Clients do not set this."),
    ] = None
    resource_id: Annotated[ResourceId, Field(alias="resourceId")]
    storage_uri: Annotated[
        str,
        Field(
            alias="storageUri",
            description="The caller's instruction for WHERE the bytes are — not a copy of the stored fact. The stored location lives on the resource's primary Representation (`Representation.storageUri`), which is its single home; this field is the message that puts it there. Working-tree URI, only file:// is supported (e.g. file://docs/overview.md).",
        ),
    ]
    content_checksum: Annotated[str, Field(alias="contentChecksum")]
    byte_size: Annotated[int, Field(alias="byteSize")]


class YieldUpdateOk(WireModel, frozen=True):
    """
    Success reply after updating a yielded resource, matched to the originating command by correlationId.
    """

    response: Annotated[YieldedResource, Field(description="The updated resource's identity.")]

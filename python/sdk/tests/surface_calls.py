# Generated from protocol/specs/src/client/surface.json; do not edit.
# Regenerate: make generate (codegen/lib/surface/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""Every method of the client's surface, called with a case's arguments: each by its
keyword and as its parameter's type, so a method the client lacks, or one that
takes a parameter under another name or as another type, fails the type checkers.
"""

from collections.abc import Awaitable, Callable
from typing import Final

from pydantic import TypeAdapter

from spec import JsonObject
from surface_arguments import Args, Client, first_payload, fresh, given, maybe, member
from xynolog.identifiers import AnnotationId, JobId, ResourceId
from xynolog.types import (
    AnchorRect,
    AnnotationSelector,
    BindBodyOperation,
    BindInitiateCommand,
    BrowseDirectoryRequestSort,
    ClaimOptions,
    CreateAnnotationRequest,
    CreateFromTokenOptions,
    GatheredContext,
    GenerationJobParams,
    MarkJobParams,
    MarkSubmitEvent,
    MatchSearchRequest,
    Motivation,
    PutBinaryRequest,
    ResourceErrorEvent,
    TagSchema,
)

ANCHOR_RECT: Final = TypeAdapter[AnchorRect](AnchorRect)
ANNOTATION_ID: Final = TypeAdapter[AnnotationId](AnnotationId)
ANNOTATION_ID_OR_NONE: Final = TypeAdapter[AnnotationId | None](AnnotationId | None)
ANNOTATION_SELECTOR: Final = TypeAdapter[AnnotationSelector](AnnotationSelector)
BIND_INITIATE_COMMAND: Final = TypeAdapter[BindInitiateCommand](BindInitiateCommand)
BOOL: Final = TypeAdapter[bool](bool)
BROWSE_DIRECTORY_REQUEST_SORT: Final = TypeAdapter[BrowseDirectoryRequestSort](BrowseDirectoryRequestSort)
CLAIM_OPTIONS: Final = TypeAdapter[ClaimOptions](ClaimOptions)
CREATE_ANNOTATION_REQUEST: Final = TypeAdapter[CreateAnnotationRequest](CreateAnnotationRequest)
CREATE_FROM_TOKEN_OPTIONS: Final = TypeAdapter[CreateFromTokenOptions](CreateFromTokenOptions)
GATHERED_CONTEXT: Final = TypeAdapter[GatheredContext](GatheredContext)
GENERATION_JOB_PARAMS: Final = TypeAdapter[GenerationJobParams](GenerationJobParams)
INT: Final = TypeAdapter[int](int)
JOB_ID: Final = TypeAdapter[JobId](JobId)
LIST_OF_BIND_BODY_OPERATION: Final = TypeAdapter[list[BindBodyOperation]](list[BindBodyOperation])
LIST_OF_STR: Final = TypeAdapter[list[str]](list[str])
MARK_JOB_PARAMS: Final = TypeAdapter[MarkJobParams](MarkJobParams)
MARK_SUBMIT_EVENT: Final = TypeAdapter[MarkSubmitEvent](MarkSubmitEvent)
MATCH_SEARCH_REQUEST: Final = TypeAdapter[MatchSearchRequest](MatchSearchRequest)
MOTIVATION: Final = TypeAdapter[Motivation](Motivation)
PUT_BINARY_REQUEST: Final = TypeAdapter[PutBinaryRequest](PutBinaryRequest)
RESOURCE_ERROR_EVENT: Final = TypeAdapter[ResourceErrorEvent](ResourceErrorEvent)
RESOURCE_ID: Final = TypeAdapter[ResourceId](ResourceId)
STR: Final = TypeAdapter[str](str)
TAG_SCHEMA: Final = TypeAdapter[TagSchema](TagSchema)


def frame_add_entity_type(client: Client, args: Args) -> Awaitable[object] | None:
    return client.frame.add_entity_type(type=given(args, "type", STR))


def frame_add_entity_types(client: Client, args: Args) -> Awaitable[object] | None:
    return client.frame.add_entity_types(types=given(args, "types", LIST_OF_STR))


def frame_add_tag_schema(client: Client, args: Args) -> Awaitable[object] | None:
    return client.frame.add_tag_schema(schema=given(args, "schema", TAG_SCHEMA))


def browse_resource(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.resource(resource_id=given(args, "resourceId", RESOURCE_ID)))


def browse_resources(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(
        client.browse.resources(
            archived=member(args, "filters", "archived", BOOL),
            entity_type=member(args, "filters", "entityType", STR),
            offset=member(args, "filters", "offset", INT),
            limit=member(args, "filters", "limit", INT),
        )
    )


def browse_annotations(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.annotations(resource_id=given(args, "resourceId", RESOURCE_ID)))


def browse_annotation(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(
        client.browse.annotation(
            resource_id=given(args, "resourceId", RESOURCE_ID), annotation_id=given(args, "annotationId", ANNOTATION_ID)
        )
    )


def browse_entity_types(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.entity_types())


def browse_tag_schemas(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.tag_schemas())


def browse_engines(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.engines())


def browse_events(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.browse.events(resource_id=given(args, "resourceId", RESOURCE_ID)))


def browse_resource_content(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_content(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_resource_graph(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_graph(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_resource_anchored_text(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_anchored_text(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_resource_representation(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_representation(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_resource_representation_stream(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_representation_stream(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_resource_events(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.resource_events(resource_id=given(args, "resourceId", RESOURCE_ID))


def browse_annotation_history(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.annotation_history(
        resource_id=given(args, "resourceId", RESOURCE_ID), annotation_id=given(args, "annotationId", ANNOTATION_ID)
    )


def browse_files(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.files(dir_path=maybe(args, "dirPath", STR), sort=maybe(args, "sort", BROWSE_DIRECTORY_REQUEST_SORT))


def browse_kb(client: Client, args: Args) -> Awaitable[object] | None:
    return client.browse.kb()


def browse_click(client: Client, args: Args) -> Awaitable[object] | None:
    client.browse.click(annotation_id=given(args, "annotationId", ANNOTATION_ID), anchor_rect=maybe(args, "anchorRect", ANCHOR_RECT))
    return None


def browse_open_resource(client: Client, args: Args) -> Awaitable[object] | None:
    client.browse.open_resource(resource_id=given(args, "resourceId", RESOURCE_ID))
    return None


def browse_resource_viewed(client: Client, args: Args) -> Awaitable[object] | None:
    client.browse.resource_viewed(resource_id=given(args, "resourceId", RESOURCE_ID))
    return None


def mark_annotation(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.annotation(input=given(args, "input", CREATE_ANNOTATION_REQUEST))


def mark_delete(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.delete(resource_id=given(args, "resourceId", RESOURCE_ID), annotation_id=given(args, "annotationId", ANNOTATION_ID))


def mark_archive(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.archive(resource_id=given(args, "resourceId", RESOURCE_ID))


def mark_unarchive(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.unarchive(resource_id=given(args, "resourceId", RESOURCE_ID))


def mark_update_entity_types(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.update_entity_types(
        resource_id=given(args, "resourceId", RESOURCE_ID),
        current=given(args, "current", LIST_OF_STR),
        updated=given(args, "updated", LIST_OF_STR),
    )


def mark_delegate(client: Client, args: Args) -> Awaitable[object] | None:
    return client.mark.delegate(resource_id=given(args, "resourceId", RESOURCE_ID), params=given(args, "params", MARK_JOB_PARAMS))


def mark_request(client: Client, args: Args) -> Awaitable[object] | None:
    client.mark.request(
        source=given(args, "source", RESOURCE_ID),
        selector=given(args, "selector", ANNOTATION_SELECTOR),
        motivation=given(args, "motivation", MOTIVATION),
    )
    return None


def mark_submit(client: Client, args: Args) -> Awaitable[object] | None:
    client.mark.submit(input=given(args, "input", MARK_SUBMIT_EVENT))
    return None


def mark_report_delete_error(client: Client, args: Args) -> Awaitable[object] | None:
    client.mark.report_delete_error(input=given(args, "input", RESOURCE_ERROR_EVENT))
    return None


def bind_body(client: Client, args: Args) -> Awaitable[object] | None:
    return client.bind.body(
        resource_id=given(args, "resourceId", RESOURCE_ID),
        annotation_id=given(args, "annotationId", ANNOTATION_ID),
        operations=given(args, "operations", LIST_OF_BIND_BODY_OPERATION),
    )


def bind_initiate(client: Client, args: Args) -> Awaitable[object] | None:
    client.bind.initiate(input=given(args, "input", BIND_INITIATE_COMMAND))
    return None


def bind_report_body_error(client: Client, args: Args) -> Awaitable[object] | None:
    client.bind.report_body_error(input=given(args, "input", RESOURCE_ERROR_EVENT))
    return None


def gather_annotation(client: Client, args: Args) -> Awaitable[object] | None:
    return client.gather.annotation(
        resource_id=given(args, "resourceId", RESOURCE_ID),
        annotation_id=given(args, "annotationId", ANNOTATION_ID),
        include_source_context=member(args, "options", "includeSourceContext", BOOL),
        include_target_context=member(args, "options", "includeTargetContext", BOOL),
        context_window=member(args, "options", "contextWindow", INT),
    )


def gather_resource(client: Client, args: Args) -> Awaitable[object] | None:
    return client.gather.resource(
        resource_id=given(args, "resourceId", RESOURCE_ID),
        depth=member(args, "options", "depth", INT),
        max_resources=member(args, "options", "maxResources", INT),
        include_content=member(args, "options", "includeContent", BOOL),
        include_summary=member(args, "options", "includeSummary", BOOL),
        exclude_entity_types=member(args, "options", "excludeEntityTypes", LIST_OF_STR),
    )


def gather_referenced_by(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(client.gather.referenced_by(resource_id=given(args, "resourceId", RESOURCE_ID)))


def match_search(client: Client, args: Args) -> Awaitable[object] | None:
    return client.match.search(
        resource_id=given(args, "resourceId", RESOURCE_ID),
        reference_id=given(args, "referenceId", ANNOTATION_ID),
        context=given(args, "context", GATHERED_CONTEXT),
        limit=member(args, "options", "limit", INT),
        use_semantic_scoring=member(args, "options", "useSemanticScoring", BOOL),
    )


def match_request_search(client: Client, args: Args) -> Awaitable[object] | None:
    client.match.request_search(input=given(args, "input", MATCH_SEARCH_REQUEST), correlation_id=given(args, "correlationId", STR))
    return None


def match_resources(client: Client, args: Args) -> Awaitable[object] | None:
    return fresh(
        client.match.resources(
            search=given(args, "search", STR),
            archived=member(args, "filters", "archived", BOOL),
            entity_type=member(args, "filters", "entityType", STR),
            offset=member(args, "filters", "offset", INT),
            limit=member(args, "filters", "limit", INT),
        )
    )


def yield_resource(client: Client, args: Args) -> Awaitable[object] | None:
    return client.yield_.resource(data=given(args, "data", PUT_BINARY_REQUEST))


def yield_delegate(client: Client, args: Args) -> Awaitable[object] | None:
    return client.yield_.delegate(
        params=given(args, "params", GENERATION_JOB_PARAMS), stall_deadline_ms=maybe(args, "stallDeadlineMs", INT)
    )


def yield_clone_token(client: Client, args: Args) -> Awaitable[object] | None:
    return client.yield_.clone_token(resource_id=given(args, "resourceId", RESOURCE_ID))


def yield_from_token(client: Client, args: Args) -> Awaitable[object] | None:
    return client.yield_.from_token(token=given(args, "token", STR))


def yield_create_from_token(client: Client, args: Args) -> Awaitable[object] | None:
    return client.yield_.create_from_token(options=given(args, "options", CREATE_FROM_TOKEN_OPTIONS))


def yield_clone(client: Client, args: Args) -> Awaitable[object] | None:
    client.yield_.clone()
    return None


def beckon_attention(client: Client, args: Args) -> Awaitable[object] | None:
    return client.beckon.attention(
        resource_id=given(args, "resourceId", RESOURCE_ID), annotation_id=maybe(args, "annotationId", ANNOTATION_ID)
    )


def beckon_click(client: Client, args: Args) -> Awaitable[object] | None:
    return client.beckon.click(annotation_id=given(args, "annotationId", ANNOTATION_ID))


def beckon_open_resource(client: Client, args: Args) -> Awaitable[object] | None:
    return client.beckon.open_resource(resource_id=given(args, "resourceId", RESOURCE_ID))


def beckon_sparkle_all(client: Client, args: Args) -> Awaitable[object] | None:
    return client.beckon.sparkle_all(annotation_id=given(args, "annotationId", ANNOTATION_ID))


def beckon_hover(client: Client, args: Args) -> Awaitable[object] | None:
    client.beckon.hover(annotation_id=given(args, "annotationId", ANNOTATION_ID_OR_NONE))
    return None


def beckon_sparkle(client: Client, args: Args) -> Awaitable[object] | None:
    client.beckon.sparkle(annotation_id=given(args, "annotationId", ANNOTATION_ID))
    return None


def job_queued(client: Client) -> Awaitable[JsonObject]:
    return first_payload(client.job.queued())


def job_progress(client: Client) -> Awaitable[JsonObject]:
    return first_payload(client.job.progress())


def job_complete(client: Client) -> Awaitable[JsonObject]:
    return first_payload(client.job.complete())


def job_fail(client: Client) -> Awaitable[JsonObject]:
    return first_payload(client.job.fail())


def job_status(client: Client, args: Args) -> Awaitable[object] | None:
    return client.job.status(job_id=given(args, "jobId", JOB_ID))


def job_poll_until_complete(client: Client, args: Args) -> Awaitable[object] | None:
    return client.job.poll_until_complete(
        job_id=given(args, "jobId", JOB_ID),
        every_ms=member(args, "options", "everyMs", INT),
        within_ms=member(args, "options", "withinMs", INT),
    )


def job_cancel(client: Client, args: Args) -> Awaitable[object] | None:
    return client.job.cancel(job_id=given(args, "jobId", JOB_ID))


def job_claim(client: Client, args: Args) -> Awaitable[object] | None:
    return anext(client.job.claim(options=given(args, "options", CLAIM_OPTIONS)))


def auth_me(client: Client, args: Args) -> Awaitable[object] | None:
    return client.auth.me()


def auth_media_token(client: Client, args: Args) -> Awaitable[object] | None:
    return client.auth.media_token(resource_id=given(args, "resourceId", RESOURCE_ID))


def auth_protected_resource_metadata(client: Client, args: Args) -> Awaitable[object] | None:
    return client.auth.protected_resource_metadata()


def system_health_check(client: Client, args: Args) -> Awaitable[object] | None:
    return client.system.health_check()


def system_status(client: Client, args: Args) -> Awaitable[object] | None:
    return client.system.status()


CALLS: Final[dict[tuple[str, str], Callable[[Client, Args], Awaitable[object] | None]]] = {
    ("frame", "addEntityType"): frame_add_entity_type,
    ("frame", "addEntityTypes"): frame_add_entity_types,
    ("frame", "addTagSchema"): frame_add_tag_schema,
    ("browse", "resource"): browse_resource,
    ("browse", "resources"): browse_resources,
    ("browse", "annotations"): browse_annotations,
    ("browse", "annotation"): browse_annotation,
    ("browse", "entityTypes"): browse_entity_types,
    ("browse", "tagSchemas"): browse_tag_schemas,
    ("browse", "engines"): browse_engines,
    ("browse", "events"): browse_events,
    ("browse", "resourceContent"): browse_resource_content,
    ("browse", "resourceGraph"): browse_resource_graph,
    ("browse", "resourceAnchoredText"): browse_resource_anchored_text,
    ("browse", "resourceRepresentation"): browse_resource_representation,
    ("browse", "resourceRepresentationStream"): browse_resource_representation_stream,
    ("browse", "resourceEvents"): browse_resource_events,
    ("browse", "annotationHistory"): browse_annotation_history,
    ("browse", "files"): browse_files,
    ("browse", "kb"): browse_kb,
    ("browse", "click"): browse_click,
    ("browse", "openResource"): browse_open_resource,
    ("browse", "resourceViewed"): browse_resource_viewed,
    ("mark", "annotation"): mark_annotation,
    ("mark", "delete"): mark_delete,
    ("mark", "archive"): mark_archive,
    ("mark", "unarchive"): mark_unarchive,
    ("mark", "updateEntityTypes"): mark_update_entity_types,
    ("mark", "delegate"): mark_delegate,
    ("mark", "request"): mark_request,
    ("mark", "submit"): mark_submit,
    ("mark", "reportDeleteError"): mark_report_delete_error,
    ("bind", "body"): bind_body,
    ("bind", "initiate"): bind_initiate,
    ("bind", "reportBodyError"): bind_report_body_error,
    ("gather", "annotation"): gather_annotation,
    ("gather", "resource"): gather_resource,
    ("gather", "referencedBy"): gather_referenced_by,
    ("match", "search"): match_search,
    ("match", "requestSearch"): match_request_search,
    ("match", "resources"): match_resources,
    ("yield", "resource"): yield_resource,
    ("yield", "delegate"): yield_delegate,
    ("yield", "cloneToken"): yield_clone_token,
    ("yield", "fromToken"): yield_from_token,
    ("yield", "createFromToken"): yield_create_from_token,
    ("yield", "clone"): yield_clone,
    ("beckon", "attention"): beckon_attention,
    ("beckon", "click"): beckon_click,
    ("beckon", "openResource"): beckon_open_resource,
    ("beckon", "sparkleAll"): beckon_sparkle_all,
    ("beckon", "hover"): beckon_hover,
    ("beckon", "sparkle"): beckon_sparkle,
    ("job", "status"): job_status,
    ("job", "pollUntilComplete"): job_poll_until_complete,
    ("job", "cancel"): job_cancel,
    ("job", "claim"): job_claim,
    ("auth", "me"): auth_me,
    ("auth", "mediaToken"): auth_media_token,
    ("auth", "protectedResourceMetadata"): auth_protected_resource_metadata,
    ("system", "healthCheck"): system_health_check,
    ("system", "status"): system_status,
}

EVENTS: Final[dict[tuple[str, str], Callable[[Client], Awaitable[JsonObject]]]] = {
    ("job", "queued"): job_queued,
    ("job", "progress"): job_progress,
    ("job", "complete"): job_complete,
    ("job", "fail"): job_fail,
}

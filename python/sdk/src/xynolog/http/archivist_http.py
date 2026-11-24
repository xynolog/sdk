# Generated from protocol/specs/src/archivist/openapi.json and its paths; do not edit.
# Regenerate: make generate (codegen/lib/python_types/python_types.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The Archivist's HTTP surface: each of its operations, with its method and its path."""

from dataclasses import dataclass
from typing import Final, final

__all__ = [
    "ArchivistRoute",
    "GET_HEALTH",
    "GET_RESOURCE_ANCHORED_TEXT",
    "GET_RESOURCE_ANNOTATIONS",
    "GET_RESOURCE_CONTENT",
    "GET_RESOURCE_EVENTS",
    "GET_RESOURCE_JSON_LD",
    "GET_STORED_RESOURCE_ANCHORED_TEXT",
    "LIST_ANCHORED_TEXT_ENTRIES",
    "LIST_STREAMS",
    "PUT_ANCHORED_TEXT_STAMP",
    "PUT_RESOURCE_ANCHORED_TEXT",
    "STORE_RESOURCE",
]


@final
@dataclass(frozen=True, slots=True, kw_only=True)
class ArchivistRoute:
    """An operation of the Archivist: its method, and its path, a `{name}` for each parameter, which the caller fills."""

    method: str
    path: str


# `getHealth`.
GET_HEALTH: Final = ArchivistRoute(method="GET", path="/health")

# `listStreams`.
LIST_STREAMS: Final = ArchivistRoute(method="GET", path="/events")

# `getResourceEvents`.
GET_RESOURCE_EVENTS: Final = ArchivistRoute(method="GET", path="/events/{resourceId}")

# `storeResource`.
STORE_RESOURCE: Final = ArchivistRoute(method="POST", path="/resources")

# `getResourceContent`.
GET_RESOURCE_CONTENT: Final = ArchivistRoute(method="GET", path="/resources/{id}/content")

# `getResourceJsonLd`.
GET_RESOURCE_JSON_LD: Final = ArchivistRoute(method="GET", path="/resources/{id}/jsonld")

# `getResourceAnnotations`.
GET_RESOURCE_ANNOTATIONS: Final = ArchivistRoute(method="GET", path="/resources/{id}/annotations")

# `getResourceAnchoredText`.
GET_RESOURCE_ANCHORED_TEXT: Final = ArchivistRoute(method="GET", path="/resources/{id}/anchored-text")

# `putResourceAnchoredText`.
PUT_RESOURCE_ANCHORED_TEXT: Final = ArchivistRoute(method="PUT", path="/resources/{id}/anchored-text")

# `listAnchoredTextEntries`.
LIST_ANCHORED_TEXT_ENTRIES: Final = ArchivistRoute(method="GET", path="/anchored-text/entries")

# `getStoredResourceAnchoredText`.
GET_STORED_RESOURCE_ANCHORED_TEXT: Final = ArchivistRoute(method="GET", path="/resources/{id}/anchored-text/stored")

# `putAnchoredTextStamp`.
PUT_ANCHORED_TEXT_STAMP: Final = ArchivistRoute(method="PUT", path="/anchored-text/stamp")

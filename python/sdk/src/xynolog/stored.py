# Generated from protocol/specs/src/session/stored.json; do not edit.
# Regenerate: make generate (codegen/lib/stored/stored.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""What a registry of knowledge bases keeps in a `SessionStorage` (`protocol/specs/src/session/stored.json`):
the key each thing it keeps is kept under.
And which queries the sessions it makes keep there. The keys made of
these prefixes are `xynolog.storage_keys`'s; where each stream was is
`xynolog.types.LastEventIds`.
"""

from typing import Final, Literal

__all__ = [
    "ACTIVE_KEY",
    "CACHE_DOCUMENT_VERSION",
    "CACHE_KEY_PREFIX",
    "KEPT_QUERIES",
    "KNOWLEDGE_BASES_KEY",
    "LAST_EVENT_ID_KEY_PREFIX",
    "LAST_VIEWED_RESOURCE_BY_KB_KEY",
    "OPEN_RESOURCES_BY_KB_KEY",
    "PENDING_AUTHORIZATION_KEY",
    "SESSION_KEY_PREFIX",
    "WHOLE_KEY",
    "KeptQuery",
    "WholeKey",
]

# The registered knowledge bases: a JSON list of KnowledgeBase
# (components/schemas/KnowledgeBase.json).
KNOWLEDGE_BASES_KEY: Final = "xynolog.knowledgeBases"

# The id of the active knowledge base. Nothing is kept under it while none is active.
ACTIVE_KEY: Final = "xynolog.activeKnowledgeBaseId"

# What is open in each knowledge base: a JSON object from a knowledge base's id to the list of
# its open resources, each an `openResource`.
OPEN_RESOURCES_BY_KB_KEY: Final = "xynolog.openResourcesByKb"

# Where the person was in each knowledge base: a JSON object from a knowledge base's id to the
# id of the resource last viewed in it.
LAST_VIEWED_RESOURCE_BY_KB_KEY: Final = "xynolog.lastViewedResourceByKb"

# A sign-in by a page redirect that is under way: what it remembers across the trip to the
# issuer and back. It is taken when the sign-in completes, so a callback that is replayed finds
# nothing to complete.
PENDING_AUTHORIZATION_KEY: Final = "xynolog.pendingAuthorization"

# A knowledge base's stored session is kept under this followed by the knowledge base's id.
SESSION_KEY_PREFIX: Final = "xynolog.session."

# Where a knowledge base's stream was, for one person, is kept under this followed by the
# knowledge base's id, a dot and the person's key: the unpadded base64url SHA-256 of the UTF-8
# of the did the gateway answers for the person's token (components/schemas/UserResponse.json),
# never the did itself. What is kept is `lastEventIds`. It is written in the same call as a
# write of one of the caches kept beside it, and only while every kept cache has no fetch in
# flight and owes no save, and the refresher owes no refetch (a window of B19,
# contract/CACHE-SEMANTICS.md, that holds an invalidation it has not yet run); so it never leads
# them. Its own write is never a reason to write a cache. At disposal this is read once, before
# any kept cache or the refresher is disposed. Nothing is kept for a token whose person the
# gateway has not named, and forgetting the knowledge base's stored sign-in, however it is
# forgotten, deletes it.
LAST_EVENT_ID_KEY_PREFIX: Final = "xynolog.lastEventId."

# What a client keeps of a query, for one person, is kept under this followed by the knowledge
# base's id, a dot, the person's key as `lastEventIdKeyPrefix` makes it, a dot and the query's
# name: one `cacheDocument` for each query specs/src/client/refresh.json marks `persisted`.
# Nothing is kept for a token whose person the gateway has not named, and forgetting the
# knowledge base's stored sign-in, however it is forgotten, deletes the key of every kept query.
CACHE_KEY_PREFIX: Final = "xynolog.cache."

# The queries a client keeps across a restart, each by its name in
# protocol/specs/src/client/refresh.json, and each as one document under its
# `xynolog.storage_keys.cache_key`.
type KeptQuery = Literal[
    # Keyed by ResourceId; its value is ResourceDescriptor.
    "resource",
    # Keyed by ResourceId; its value is GetAnnotationsResponse.
    "annotations",
    # Keyed by AnnotationId; its value is Annotation.
    "annotation",
    # Keyed by WHOLE_KEY alone; its value is GetEntityTypesResponse's `entityTypes`.
    "entityTypes",
    # Keyed by WHOLE_KEY alone; its value is GetTagSchemasResponse's `tagSchemas`.
    "tagSchemas",
]

KEPT_QUERIES: Final[tuple[KeptQuery, ...]] = (
    "resource",
    "annotations",
    "annotation",
    "entityTypes",
    "tagSchemas",
)

# The key a kept query that is per nothing (a `queries` row of specs/src/client/refresh.json
# with no `per`) keeps its one entry under.
type WholeKey = Literal["_"]
WHOLE_KEY: Final[WholeKey] = "_"

# The form of the document. A document of another version is read as none.
CACHE_DOCUMENT_VERSION: Final = 1

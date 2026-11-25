// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/stored.json
// Regenerate:  make generate  (codegen/lib/stored/stored.ml)

/** The registered knowledge bases: a JSON list of KnowledgeBase (components/schemas/KnowledgeBase.json). */
export const STORAGE_KEY = 'xynolog.knowledgeBases';

/** The id of the active knowledge base. Nothing is kept under it while none is active. */
export const ACTIVE_KEY = 'xynolog.activeKnowledgeBaseId';

/** What is open in each knowledge base: a JSON object from a knowledge base's id to the list of its open resources, each an `openResource`. */
export const OPEN_RESOURCES_BY_KB_KEY = 'xynolog.openResourcesByKb';

/** Where the person was in each knowledge base: a JSON object from a knowledge base's id to the id of the resource last viewed in it. */
export const LAST_VIEWED_RESOURCE_BY_KB_KEY = 'xynolog.lastViewedResourceByKb';

/** A sign-in by a page redirect that is under way: what it remembers across the trip to the issuer and back. It is taken when the sign-in completes, so a callback that is replayed finds nothing to complete. */
export const PENDING_AUTHORIZATION_KEY = 'xynolog.pendingAuthorization';

/** A knowledge base's stored session is kept under this followed by the knowledge base's id. */
export const SESSION_KEY_PREFIX = 'xynolog.session.';

/** Where a knowledge base's stream was, for one person, is kept under this followed by the knowledge base's id, a dot and the person's key: the unpadded base64url SHA-256 of the UTF-8 of the did the gateway answers for the person's token (components/schemas/UserResponse.json), never the did itself. What is kept is `lastEventIds`. It is written in the same call as a write of one of the caches kept beside it, and only while every kept cache has no fetch in flight and owes no save, and the refresher owes no refetch (a window of B19, contract/CACHE-SEMANTICS.md, that holds an invalidation it has not yet run); so it never leads them. Its own write is never a reason to write a cache. At disposal this is read once, before any kept cache or the refresher is disposed. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes it. */
export const LAST_EVENT_ID_KEY_PREFIX = 'xynolog.lastEventId.';

/** What a client keeps of a query, for one person, is kept under this followed by the knowledge base's id, a dot, the person's key as `lastEventIdKeyPrefix` makes it, a dot and the query's name: one `cacheDocument` for each query specs/src/client/refresh.json marks `persisted`. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes the key of every kept query. */
export const CACHE_KEY_PREFIX = 'xynolog.cache.';

/** The key a kept query that is per nothing (a `queries` row of specs/src/client/refresh.json with no `per`) keeps its one entry under. */
export const WHOLE_KEY = '_';

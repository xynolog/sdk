// Generated from protocol/specs/src/session/stored.json; do not edit.
// Regenerate: make generate (codegen/lib/stored/stored.ml)
/// The registered knowledge bases: a JSON list of KnowledgeBase (components/schemas/KnowledgeBase.json).
pub const KNOWLEDGE_BASES_KEY: &str = "xynolog.knowledgeBases";
/// The id of the active knowledge base. Nothing is kept under it while none is active.
pub const ACTIVE_KEY: &str = "xynolog.activeKnowledgeBaseId";
/// What is open in each knowledge base: a JSON object from a knowledge base's id to the list of its open resources, each an `openResource`.
pub const OPEN_RESOURCES_BY_KB_KEY: &str = "xynolog.openResourcesByKb";
/// Where the person was in each knowledge base: a JSON object from a knowledge base's id to the id of the resource last viewed in it.
pub const LAST_VIEWED_RESOURCE_BY_KB_KEY: &str = "xynolog.lastViewedResourceByKb";
/// A knowledge base's stored session is kept under this followed by the knowledge base's id.
const SESSION_KEY_PREFIX: &str = "xynolog.session.";
/// Where a knowledge base's stream was, for one person, is kept under this followed by the knowledge base's id, a dot and the person's key: the unpadded base64url SHA-256 of the UTF-8 of the did the gateway answers for the person's token (components/schemas/UserResponse.json), never the did itself. What is kept is `lastEventIds`. It is written in the same call as a write of one of the caches kept beside it, and only while every kept cache has no fetch in flight and owes no save, and the refresher owes no refetch (a window of B19, contract/CACHE-SEMANTICS.md, that holds an invalidation it has not yet run); so it never leads them. Its own write is never a reason to write a cache. At disposal this is read once, before any kept cache or the refresher is disposed. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes it.
const LAST_EVENT_ID_KEY_PREFIX: &str = "xynolog.lastEventId.";
/// What a client keeps of a query, for one person, is kept under this followed by the knowledge base's id, a dot, the person's key as `lastEventIdKeyPrefix` makes it, a dot and the query's name: one `cacheDocument` for each query specs/src/client/refresh.json marks `persisted`. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes the key of every kept query.
const CACHE_KEY_PREFIX: &str = "xynolog.cache.";
/// The key a kept query that is per nothing (a `queries` row of specs/src/client/refresh.json with no `per`) keeps its one entry under.
pub(crate) const WHOLE_KEY: &str = "_";
/// The form of the document. A document of another version is read as none.
pub(crate) const CACHE_DOCUMENT_VERSION: u64 = 1;

// Code generated from protocol/specs/src/session/stored.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/stored/stored.ml)

package xynolog

// PendingAuthorizationKey: A sign-in by a page redirect that is under way:
// what it remembers across the trip to the issuer and back. It is taken when
// the sign-in completes, so a callback that is replayed finds nothing to
// complete.
const PendingAuthorizationKey = "xynolog.pendingAuthorization"

// lastEventIdKeyPrefix: Where a knowledge base's stream was, for one person,
// is kept under this followed by the knowledge base's id, a dot and the
// person's key: the unpadded base64url SHA-256 of the UTF-8 of the did the
// gateway answers for the person's token
// (components/schemas/UserResponse.json), never the did itself. What is kept
// is `lastEventIds`. It is written in the same call as a write of one of the
// caches kept beside it, and only while every kept cache has no fetch in
// flight and owes no save, and the refresher owes no refetch (a window of
// B19, contract/CACHE-SEMANTICS.md, that holds an invalidation it has not yet
// run); so it never leads them. Its own write is never a reason to write a
// cache. At disposal this is read once, before any kept cache or the
// refresher is disposed. Nothing is kept for a token whose person the gateway
// has not named, and forgetting the knowledge base's stored sign-in, however
// it is forgotten, deletes it.
const lastEventIdKeyPrefix = "xynolog.lastEventId."

// cacheKeyPrefix: What a client keeps of a query, for one person, is kept
// under this followed by the knowledge base's id, a dot, the person's key as
// `lastEventIdKeyPrefix` makes it, a dot and the query's name: one
// `cacheDocument` for each query specs/src/client/refresh.json marks
// `persisted`. Nothing is kept for a token whose person the gateway has not
// named, and forgetting the knowledge base's stored sign-in, however it is
// forgotten, deletes the key of every kept query.
const cacheKeyPrefix = "xynolog.cache."

// wholeKey: The key a kept query that is per nothing (a `queries` row of
// specs/src/client/refresh.json with no `per`) keeps its one entry under.
const wholeKey = "_"

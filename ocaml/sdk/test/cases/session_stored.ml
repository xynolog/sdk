(* Generated from protocol/specs/src/session/stored.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type keys_item = { member : string; key : string; docs : string }

let keys_item_json (r : keys_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("key", (fun s -> `String s) r.key);
         Option.Some ("docs", (fun s -> `String s) r.docs);
       ])

type session_key_prefix = { prefix : string; docs : string }

let session_key_prefix_json (r : session_key_prefix) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("prefix", (fun s -> `String s) r.prefix);
         Option.Some ("docs", (fun s -> `String s) r.docs);
       ])

type example = { kb_id : string; did : string; key : string }

let example_json (r : example) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("kbId", (fun s -> `String s) r.kb_id);
         Option.Some ("did", (fun s -> `String s) r.did);
         Option.Some ("key", (fun s -> `String s) r.key);
       ])

type last_event_id_key_prefix = {
  prefix : string;
  docs : string;
  example : example;
}

let last_event_id_key_prefix_json (r : last_event_id_key_prefix) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("prefix", (fun s -> `String s) r.prefix);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some ("example", example_json r.example);
       ])

type cache_key_prefix_example = {
  kb_id : string;
  did : string;
  query : string;
  key : string;
}

let cache_key_prefix_example_json (r : cache_key_prefix_example) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("kbId", (fun s -> `String s) r.kb_id);
         Option.Some ("did", (fun s -> `String s) r.did);
         Option.Some ("query", (fun s -> `String s) r.query);
         Option.Some ("key", (fun s -> `String s) r.key);
       ])

type cache_key_prefix = {
  prefix : string;
  docs : string;
  example : cache_key_prefix_example;
}

let cache_key_prefix_json (r : cache_key_prefix) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("prefix", (fun s -> `String s) r.prefix);
         Option.Some ("docs", (fun s -> `String s) r.docs);
         Option.Some ("example", cache_key_prefix_example_json r.example);
       ])

type whole_key = { key : string; docs : string }

let whole_key_json (r : whole_key) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("key", (fun s -> `String s) r.key);
         Option.Some ("docs", (fun s -> `String s) r.docs);
       ])

type t = {
  comment : string;
  keys : keys_item list;
  session_key_prefix : session_key_prefix;
  last_event_id_key_prefix : last_event_id_key_prefix;
  cache_key_prefix : cache_key_prefix;
  whole_key : whole_key;
  stored_session : Yojson.Safe.t;
  pending_authorization : Yojson.Safe.t;
  open_resource : Yojson.Safe.t;
  cache_document : Yojson.Safe.t;
  last_event_ids : Yojson.Safe.t;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("keys", (fun l -> `List (List.map keys_item_json l)) r.keys);
         Option.Some
           ("sessionKeyPrefix", session_key_prefix_json r.session_key_prefix);
         Option.Some
           ( "lastEventIdKeyPrefix",
             last_event_id_key_prefix_json r.last_event_id_key_prefix );
         Option.Some ("cacheKeyPrefix", cache_key_prefix_json r.cache_key_prefix);
         Option.Some ("wholeKey", whole_key_json r.whole_key);
         Option.Some ("storedSession", Fun.id r.stored_session);
         Option.Some ("pendingAuthorization", Fun.id r.pending_authorization);
         Option.Some ("openResource", Fun.id r.open_resource);
         Option.Some ("cacheDocument", Fun.id r.cache_document);
         Option.Some ("lastEventIds", Fun.id r.last_event_ids);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for what a registry of knowledge bases keeps in a \
        SessionStorage, and what the sessions it makes keep there: the key \
        each thing is kept under, the shape of a knowledge base's stored \
        session, the shape of a resource open in one, the shape of a sign-in \
        by a page redirect that is under way, and what a client keeps of its \
        queries and of its stream. A registry in any SDK finds what one in \
        another wrote, over one storage, only if every SDK says these alike. \
        WHO HOLDS IT. TypeScript states it by hand in \
        sdk/typescript/sdk/src/session/storage.ts, oauth.ts and \
        open-resource.ts, held by \
        sdk/typescript/sdk/src/session/__tests__/stored-table.test.ts and \
        oauth.test.ts. Rust in sdk/rust/sdk/src/session/stored.rs and \
        open_resource.rs, held by sdk/rust/sdk/tests/tables.rs, and in \
        sdk/rust/http-transport/src/oauth.rs, held by \
        sdk/rust/http-transport/tests/sign_in.rs. Go in \
        sdk/go/registry/stored.go and openresource.go, held by \
        sdk/go/registry/stored_test.go, and in sdk/go/authorization.go and \
        storage.go, held by sdk/go/stored_test.go. Kotlin in \
        sdk/kotlin/sdk/src/main/kotlin/xynolog/registry/Stored.kt and Open.kt \
        and xynolog/http/Authorization.kt, held by \
        sdk/kotlin/sdk/src/test/kotlin/xynolog/registry/StoredTest.kt and \
        xynolog/http/AuthorizationTest.kt. Swift in \
        sdk/swift/sdk/Sources/Xynolog/Registry/Stored.swift, \
        OpenResources.swift and RedirectSignIn.swift, held by \
        sdk/swift/sdk/Tests/XynologTests/RegistryTablesTests.swift and \
        IssuerTests.swift; the consumer-owned generator writes its stored \
        session, HeldSignIn, of `storedSession` into \
        sdk/swift/sdk/Sources/Xynolog/Generated/Models.swift. C# reads the \
        table, which the consumer-owned generator embeds in \
        sdk/csharp/sdk/src/Xynolog/Generated/ProtocolTables.g.cs, in \
        sdk/csharp/sdk/src/Xynolog/Registry/RegistryStorage.cs, where it \
        states the open resource, and states the pending sign-in in \
        sdk/csharp/sdk/src/Xynolog/Authorization/RedirectSignIn.cs, held by \
        sdk/csharp/sdk/tests/Xynolog.Tests/RegistryTests.cs. Python: the \
        consumer-owned generator writes sdk/python/sdk/src/xynolog/stored.py, \
        and sdk/python/sdk/tests/test_registry_http.py holds the pending \
        sign-in of sdk/python/sdk/src/xynolog/http/oauth.py. Haskell: the \
        consumer-owned generator writes its keys and prefixes \
        (sdk/haskell/sdk/generated/Xynolog/Internal/Generated/Stored.hs) and \
        its stored session, pending sign-in and open resource \
        (Models/StoredSession.hs, PendingAuthorization.hs and OpenResource.hs \
        beside it) from the table. What a client keeps of its queries and of \
        its stream (`wholeKey`, `cacheDocument`, `lastEventIds`) every SDK \
        holds by running specs/src/session/cache-cases.json against its own \
        persister: what it writes, and what it keeps of what another wrote. \
        READING IT. `keys` are the fixed keys, each named as \
        specs/src/client/surface.json names its constant. A knowledge base's \
        session is kept under `sessionKeyPrefix` followed by the knowledge \
        base's id, and `storedSession` names the schema of what is kept there, \
        as JSON (session/StoredSession.json): a flat object whose every member \
        is text. `lastEventIdKeyPrefix` and `cacheKeyPrefix` begin the keys of \
        what a session keeps of its stream and its queries for one person, as \
        each one's `docs` says, and each one's `example` is one key worked out \
        from a knowledge base's id, a person's did and, for a query, its name. \
        The queries a client keeps across a restart are those \
        specs/src/client/refresh.json marks `persisted`, each kept as a \
        `cacheDocument` under `cacheKeyPrefix`, its entries' values what the \
        query's `value` there says its cache holds. An entry's key is a \
        resource's id for a query `per` resource, an annotation's id for one \
        `per` annotation, and `wholeKey` for one per nothing; a query per \
        filters is not kept. A load keeps nothing of a document whose \
        structure is not `cacheDocument`'s (not JSON, not an object, of \
        another version, its `entries` not a list, or an entry not a key, a \
        value and a stamp), and skips an entry whose key or value is not what \
        its query keeps. A load of `lastEventIds` skips a pair that is not a \
        resource's id and a PersistedEventId, and keeps none of a value that \
        is no object. `pendingAuthorization` is what is kept under \
        `pendingAuthorizationKey`, and `openResource` names the schema of each \
        entry of a list kept under `openResourcesByKbKey` \
        (session/OpenResource.json), as JSON; a member either does not require \
        is not written when there is none.";
     keys =
       [
         ({
            member = "knowledgeBasesKey";
            key = "xynolog.knowledgeBases";
            docs =
              "The registered knowledge bases: a JSON list of KnowledgeBase \
               (components/schemas/KnowledgeBase.json).";
          }
           : keys_item);
         ({
            member = "activeKey";
            key = "xynolog.activeKnowledgeBaseId";
            docs =
              "The id of the active knowledge base. Nothing is kept under it \
               while none is active.";
          }
           : keys_item);
         ({
            member = "openResourcesByKbKey";
            key = "xynolog.openResourcesByKb";
            docs =
              "What is open in each knowledge base: a JSON object from a \
               knowledge base's id to the list of its open resources, each an \
               `openResource`.";
          }
           : keys_item);
         ({
            member = "lastViewedResourceByKbKey";
            key = "xynolog.lastViewedResourceByKb";
            docs =
              "Where the person was in each knowledge base: a JSON object from \
               a knowledge base's id to the id of the resource last viewed in \
               it.";
          }
           : keys_item);
         ({
            member = "pendingAuthorizationKey";
            key = "xynolog.pendingAuthorization";
            docs =
              "A sign-in by a page redirect that is under way: what it \
               remembers across the trip to the issuer and back. It is taken \
               when the sign-in completes, so a callback that is replayed \
               finds nothing to complete.";
          }
           : keys_item);
       ];
     session_key_prefix =
       ({
          prefix = "xynolog.session.";
          docs =
            "A knowledge base's stored session is kept under this followed by \
             the knowledge base's id.";
        }
         : session_key_prefix);
     last_event_id_key_prefix =
       ({
          prefix = "xynolog.lastEventId.";
          docs =
            "Where a knowledge base's stream was, for one person, is kept \
             under this followed by the knowledge base's id, a dot and the \
             person's key: the unpadded base64url SHA-256 of the UTF-8 of the \
             did the gateway answers for the person's token \
             (components/schemas/UserResponse.json), never the did itself. \
             What is kept is `lastEventIds`. It is written in the same call as \
             a write of one of the caches kept beside it, and only while every \
             kept cache has no fetch in flight and owes no save, and the \
             refresher owes no refetch (a window of B19, \
             contract/CACHE-SEMANTICS.md, that holds an invalidation it has \
             not yet run); so it never leads them. Its own write is never a \
             reason to write a cache. At disposal this is read once, before \
             any kept cache or the refresher is disposed. Nothing is kept for \
             a token whose person the gateway has not named, and forgetting \
             the knowledge base's stored sign-in, however it is forgotten, \
             deletes it.";
          example =
            ({
               kb_id = "kb-a";
               did = "did:web:kb.example.org:users:jo%40example.org";
               key =
                 "xynolog.lastEventId.kb-a.gqB898gk4Ww_orAHhzDCSVl7yHP9UEsX0DA_xbGbq-I";
             }
              : example);
        }
         : last_event_id_key_prefix);
     cache_key_prefix =
       ({
          prefix = "xynolog.cache.";
          docs =
            "What a client keeps of a query, for one person, is kept under \
             this followed by the knowledge base's id, a dot, the person's key \
             as `lastEventIdKeyPrefix` makes it, a dot and the query's name: \
             one `cacheDocument` for each query specs/src/client/refresh.json \
             marks `persisted`. Nothing is kept for a token whose person the \
             gateway has not named, and forgetting the knowledge base's stored \
             sign-in, however it is forgotten, deletes the key of every kept \
             query.";
          example =
            ({
               kb_id = "kb-a";
               did = "did:web:kb.example.org:users:jo%40example.org";
               query = "annotation";
               key =
                 "xynolog.cache.kb-a.gqB898gk4Ww_orAHhzDCSVl7yHP9UEsX0DA_xbGbq-I.annotation";
             }
              : cache_key_prefix_example);
        }
         : cache_key_prefix);
     whole_key =
       ({
          key = "_";
          docs =
            "The key a kept query that is per nothing (a `queries` row of \
             specs/src/client/refresh.json with no `per`) keeps its one entry \
             under.";
        }
         : whole_key);
     stored_session =
       `Assoc
         [ ("$ref", `String "https://xynolog.org/protocol/StoredSession.json") ];
     pending_authorization =
       `Assoc
         [
           ("title", `String "PendingAuthorization");
           ("type", `String "object");
           ( "description",
             `String
               "What a sign-in by a page redirect remembers across the trip to \
                the issuer and back: the verifier and the state the issuer's \
                response must match, where the person was connecting, what \
                they believed they were connecting to, and the issuer's \
                endpoints, so its completion asks nothing twice." );
           ( "properties",
             `Assoc
               [
                 ( "state",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "What the issuer's response must carry back to \
                            belong to this sign-in: random, as base64url." );
                     ] );
                 ( "verifier",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "The PKCE code verifier (RFC 7636) the \
                            authorization code is exchanged with: random, as \
                            base64url." );
                     ] );
                 ( "redirectUri",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "Where the issuer sends the person back to, named \
                            again when the code is exchanged." );
                     ] );
                 ( "target",
                   `Assoc
                     [
                       ( "$ref",
                         `String
                           "https://xynolog.org/protocol/HttpEndpoint.json" );
                       ( "description",
                         `String "Where the person was connecting." );
                     ] );
                 ( "issuer",
                   `Assoc
                     [
                       ("type", `String "object");
                       ( "description",
                         `String
                           "The issuer the knowledge base trusts, and the \
                            endpoints of it a client uses." );
                       ( "properties",
                         `Assoc
                           [
                             ( "issuer",
                               `Assoc
                                 [
                                   ("type", `String "string");
                                   ( "description",
                                     `String "The issuer's identifier." );
                                 ] );
                             ( "authorization",
                               `Assoc
                                 [
                                   ("type", `String "string");
                                   ( "description",
                                     `String
                                       "The issuer's authorization endpoint, \
                                        where the person is sent." );
                                 ] );
                             ( "token",
                               `Assoc
                                 [
                                   ("type", `String "string");
                                   ( "description",
                                     `String
                                       "The issuer's token endpoint, where the \
                                        code is exchanged." );
                                 ] );
                             ( "device",
                               `Assoc
                                 [
                                   ("type", `String "string");
                                   ( "description",
                                     `String
                                       "The issuer's device authorization \
                                        endpoint (RFC 8628). Absent when the \
                                        issuer has none." );
                                 ] );
                             ( "revocation",
                               `Assoc
                                 [
                                   ("type", `String "string");
                                   ( "description",
                                     `String
                                       "The issuer's revocation endpoint (RFC \
                                        7009). Absent when the issuer has \
                                        none." );
                                 ] );
                           ] );
                       ( "required",
                         `List
                           [
                             `String "issuer";
                             `String "authorization";
                             `String "token";
                           ] );
                     ] );
                 ( "kbId",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "The registered knowledge base being signed in to \
                            again. Absent when it is none." );
                     ] );
                 ( "expectedDid",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "The did of what the person believed they clicked, \
                            checked against the answer and never assumed. \
                            Absent when they named nothing." );
                     ] );
                 ( "expectedName",
                   `Assoc
                     [
                       ("type", `String "string");
                       ( "description",
                         `String
                           "The name of what the person believed they clicked. \
                            Absent when they named nothing." );
                     ] );
               ] );
           ( "required",
             `List
               [
                 `String "state";
                 `String "verifier";
                 `String "redirectUri";
                 `String "target";
                 `String "issuer";
               ] );
         ];
     open_resource =
       `Assoc
         [ ("$ref", `String "https://xynolog.org/protocol/OpenResource.json") ];
     cache_document =
       `Assoc
         [
           ("title", `String "CacheDocument");
           ("type", `String "object");
           ( "description",
             `String
               "What a client keeps of one query: each key it was asked of, \
                the value its answer gave, and when that value was received." );
           ( "properties",
             `Assoc
               [
                 ( "version",
                   `Assoc
                     [
                       ("const", `Int 1);
                       ( "description",
                         `String
                           "The form of the document. A document of another \
                            version is read as none." );
                     ] );
                 ( "entries",
                   `Assoc
                     [
                       ("type", `String "array");
                       ( "description",
                         `String
                           "The query's kept keys. A document larger than \
                            `maxStoredBytesCount` \
                            (specs/src/client/timing.json) loses the entries \
                            received longest ago until it fits." );
                       ( "items",
                         `Assoc
                           [
                             ("type", `String "array");
                             ( "prefixItems",
                               `List
                                 [
                                   `Assoc
                                     [
                                       ( "description",
                                         `String
                                           "The key: a resource's id for a \
                                            query per resource, an \
                                            annotation's id for one per \
                                            annotation, `wholeKey` for one per \
                                            nothing." );
                                     ];
                                   `Assoc
                                     [
                                       ( "description",
                                         `String
                                           "The value: what the query's \
                                            `value` in \
                                            specs/src/client/refresh.json says \
                                            its cache holds." );
                                     ];
                                   `Assoc
                                     [
                                       ("type", `String "integer");
                                       ("minimum", `Int 0);
                                       ( "description",
                                         `String
                                           "When the value was received, in \
                                            milliseconds since the Unix epoch. \
                                            A value received again unchanged \
                                            (its JSON text the text it was \
                                            kept with) keeps the time it was \
                                            first received." );
                                     ];
                                 ] );
                             ("minItems", `Int 3);
                             ("maxItems", `Int 3);
                           ] );
                     ] );
               ] );
           ("required", `List [ `String "version"; `String "entries" ]);
         ];
     last_event_ids =
       `Assoc
         [
           ("title", `String "LastEventIds");
           ("type", `String "object");
           ( "description",
             `String
               "Where a knowledge base's stream was: for each scope, a \
                resource's id, the id of the last recorded event delivered on \
                it." );
           ( "propertyNames",
             `Assoc
               [
                 ("$ref", `String "https://xynolog.org/protocol/ResourceId.json");
               ] );
           ( "additionalProperties",
             `Assoc
               [
                 ( "$ref",
                   `String "https://xynolog.org/protocol/PersistedEventId.json"
                 );
               ] );
         ];
   }
    : t)

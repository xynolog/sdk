// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/stored.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Json =
  null | boolean | number | string | Json[] | { [key: string]: Json };

export type KeysItem = {
  member: string;
  key: string;
  docs: string;
};

export type SessionKeyPrefix = {
  prefix: string;
  docs: string;
};

export type Example = {
  kbId: string;
  did: string;
  key: string;
};

export type LastEventIdKeyPrefix = {
  prefix: string;
  docs: string;
  example: Example;
};

export type CacheKeyPrefixExample = {
  kbId: string;
  did: string;
  query: string;
  key: string;
};

export type CacheKeyPrefix = {
  prefix: string;
  docs: string;
  example: CacheKeyPrefixExample;
};

export type WholeKey = {
  key: string;
  docs: string;
};

export type Table = {
  $comment: string;
  keys: KeysItem[];
  sessionKeyPrefix: SessionKeyPrefix;
  lastEventIdKeyPrefix: LastEventIdKeyPrefix;
  cacheKeyPrefix: CacheKeyPrefix;
  wholeKey: WholeKey;
  storedSession: Json;
  pendingAuthorization: Json;
  openResource: Json;
  cacheDocument: Json;
  lastEventIds: Json;
};

export const table: Table = {
  $comment:
    "AUTHORITY for what a registry of knowledge bases keeps in a SessionStorage, and what the sessions it makes keep there: the key each thing is kept under, the shape of a knowledge base's stored session, the shape of a resource open in one, the shape of a sign-in by a page redirect that is under way, and what a client keeps of its queries and of its stream. A registry in any SDK finds what one in another wrote, over one storage, only if every SDK says these alike. READING IT. `keys` are the fixed keys, each named as specs/src/client/surface.json names its constant. A knowledge base's session is kept under `sessionKeyPrefix` followed by the knowledge base's id, and `storedSession` names the schema of what is kept there, as JSON (session/StoredSession.json): a flat object whose every member is text. `lastEventIdKeyPrefix` and `cacheKeyPrefix` begin the keys of what a session keeps of its stream and its queries for one person, as each one's `docs` says, and each one's `example` is one key worked out from a knowledge base's id, a person's did and, for a query, its name. The queries a client keeps across a restart are those specs/src/client/refresh.json marks `persisted`, each kept as a `cacheDocument` under `cacheKeyPrefix`, its entries' values what the query's `value` there says its cache holds. An entry's key is a resource's id for a query `per` resource, an annotation's id for one `per` annotation, and `wholeKey` for one per nothing; a query per filters is not kept. A load keeps nothing of a document whose structure is not `cacheDocument`'s (not JSON, not an object, of another version, its `entries` not a list, or an entry not a key, a value and a stamp), and skips an entry whose key or value is not what its query keeps. A load of `lastEventIds` skips a pair that is not a resource's id and a PersistedEventId, and keeps none of a value that is no object. `pendingAuthorization` is what is kept under `pendingAuthorizationKey`, and `openResource` names the schema of each entry of a list kept under `openResourcesByKbKey` (session/OpenResource.json), as JSON; a member either does not require is not written when there is none.",
  keys: [
    {
      member: 'knowledgeBasesKey',
      key: 'xynolog.knowledgeBases',
      docs: 'The registered knowledge bases: a JSON list of KnowledgeBase (components/schemas/KnowledgeBase.json).',
    },
    {
      member: 'activeKey',
      key: 'xynolog.activeKnowledgeBaseId',
      docs: 'The id of the active knowledge base. Nothing is kept under it while none is active.',
    },
    {
      member: 'openResourcesByKbKey',
      key: 'xynolog.openResourcesByKb',
      docs: "What is open in each knowledge base: a JSON object from a knowledge base's id to the list of its open resources, each an `openResource`.",
    },
    {
      member: 'lastViewedResourceByKbKey',
      key: 'xynolog.lastViewedResourceByKb',
      docs: "Where the person was in each knowledge base: a JSON object from a knowledge base's id to the id of the resource last viewed in it.",
    },
    {
      member: 'pendingAuthorizationKey',
      key: 'xynolog.pendingAuthorization',
      docs: 'A sign-in by a page redirect that is under way: what it remembers across the trip to the issuer and back. It is taken when the sign-in completes, so a callback that is replayed finds nothing to complete.',
    },
  ],
  sessionKeyPrefix: {
    prefix: 'xynolog.session.',
    docs: "A knowledge base's stored session is kept under this followed by the knowledge base's id.",
  },
  lastEventIdKeyPrefix: {
    prefix: 'xynolog.lastEventId.',
    docs: "Where a knowledge base's stream was, for one person, is kept under this followed by the knowledge base's id, a dot and the person's key: the unpadded base64url SHA-256 of the UTF-8 of the did the gateway answers for the person's token (components/schemas/UserResponse.json), never the did itself. What is kept is `lastEventIds`. It is written in the same call as a write of one of the caches kept beside it, and only while every kept cache has no fetch in flight and owes no save, and the refresher owes no refetch (a window of B19, contract/CACHE-SEMANTICS.md, that holds an invalidation it has not yet run); so it never leads them. Its own write is never a reason to write a cache. At disposal this is read once, before any kept cache or the refresher is disposed. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes it.",
    example: {
      kbId: 'kb-a',
      did: 'did:web:kb.example.org:users:jo%40example.org',
      key: 'xynolog.lastEventId.kb-a.gqB898gk4Ww_orAHhzDCSVl7yHP9UEsX0DA_xbGbq-I',
    },
  },
  cacheKeyPrefix: {
    prefix: 'xynolog.cache.',
    docs: "What a client keeps of a query, for one person, is kept under this followed by the knowledge base's id, a dot, the person's key as `lastEventIdKeyPrefix` makes it, a dot and the query's name: one `cacheDocument` for each query specs/src/client/refresh.json marks `persisted`. Nothing is kept for a token whose person the gateway has not named, and forgetting the knowledge base's stored sign-in, however it is forgotten, deletes the key of every kept query.",
    example: {
      kbId: 'kb-a',
      did: 'did:web:kb.example.org:users:jo%40example.org',
      query: 'annotation',
      key: 'xynolog.cache.kb-a.gqB898gk4Ww_orAHhzDCSVl7yHP9UEsX0DA_xbGbq-I.annotation',
    },
  },
  wholeKey: {
    key: '_',
    docs: 'The key a kept query that is per nothing (a `queries` row of specs/src/client/refresh.json with no `per`) keeps its one entry under.',
  },
  storedSession: {
    $ref: 'https://xynolog.org/protocol/StoredSession.json',
  },
  pendingAuthorization: {
    title: 'PendingAuthorization',
    type: 'object',
    description:
      "What a sign-in by a page redirect remembers across the trip to the issuer and back: the verifier and the state the issuer's response must match, where the person was connecting, what they believed they were connecting to, and the issuer's endpoints, so its completion asks nothing twice.",
    properties: {
      state: {
        type: 'string',
        description:
          "What the issuer's response must carry back to belong to this sign-in: random, as base64url.",
      },
      verifier: {
        type: 'string',
        description:
          'The PKCE code verifier (RFC 7636) the authorization code is exchanged with: random, as base64url.',
      },
      redirectUri: {
        type: 'string',
        description:
          'Where the issuer sends the person back to, named again when the code is exchanged.',
      },
      target: {
        $ref: 'https://xynolog.org/protocol/HttpEndpoint.json',
        description: 'Where the person was connecting.',
      },
      issuer: {
        type: 'object',
        description:
          'The issuer the knowledge base trusts, and the endpoints of it a client uses.',
        properties: {
          issuer: {
            type: 'string',
            description: "The issuer's identifier.",
          },
          authorization: {
            type: 'string',
            description:
              "The issuer's authorization endpoint, where the person is sent.",
          },
          token: {
            type: 'string',
            description:
              "The issuer's token endpoint, where the code is exchanged.",
          },
          device: {
            type: 'string',
            description:
              "The issuer's device authorization endpoint (RFC 8628). Absent when the issuer has none.",
          },
          revocation: {
            type: 'string',
            description:
              "The issuer's revocation endpoint (RFC 7009). Absent when the issuer has none.",
          },
        },
        required: ['issuer', 'authorization', 'token'],
      },
      kbId: {
        type: 'string',
        description:
          'The registered knowledge base being signed in to again. Absent when it is none.',
      },
      expectedDid: {
        type: 'string',
        description:
          'The did of what the person believed they clicked, checked against the answer and never assumed. Absent when they named nothing.',
      },
      expectedName: {
        type: 'string',
        description:
          'The name of what the person believed they clicked. Absent when they named nothing.',
      },
    },
    required: ['state', 'verifier', 'redirectUri', 'target', 'issuer'],
  },
  openResource: {
    $ref: 'https://xynolog.org/protocol/OpenResource.json',
  },
  cacheDocument: {
    title: 'CacheDocument',
    type: 'object',
    description:
      'What a client keeps of one query: each key it was asked of, the value its answer gave, and when that value was received.',
    properties: {
      version: {
        const: 1,
        description:
          'The form of the document. A document of another version is read as none.',
      },
      entries: {
        type: 'array',
        description:
          "The query's kept keys. A document larger than `maxStoredBytesCount` (specs/src/client/timing.json) loses the entries received longest ago until it fits.",
        items: {
          type: 'array',
          prefixItems: [
            {
              description:
                "The key: a resource's id for a query per resource, an annotation's id for one per annotation, `wholeKey` for one per nothing.",
            },
            {
              description:
                "The value: what the query's `value` in specs/src/client/refresh.json says its cache holds.",
            },
            {
              type: 'integer',
              minimum: 0,
              description:
                'When the value was received, in milliseconds since the Unix epoch. A value received again unchanged (its JSON text the text it was kept with) keeps the time it was first received.',
            },
          ],
          minItems: 3,
          maxItems: 3,
        },
      },
    },
    required: ['version', 'entries'],
  },
  lastEventIds: {
    title: 'LastEventIds',
    type: 'object',
    description:
      "Where a knowledge base's stream was: for each scope, a resource's id, the id of the last recorded event delivered on it.",
    propertyNames: {
      $ref: 'https://xynolog.org/protocol/ResourceId.json',
    },
    additionalProperties: {
      $ref: 'https://xynolog.org/protocol/PersistedEventId.json',
    },
  },
};

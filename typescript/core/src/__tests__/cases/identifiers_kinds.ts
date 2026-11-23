// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/identifiers/kinds.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type AcceptsItem = {
  id: string;
  why: string;
};

export type KindsItem = {
  schema: string;
  properties: string[];
  accepts: AcceptsItem[];
  refuses: AcceptsItem[];
};

export type OthersItem = {
  property: string;
  docs: string;
};

export type Table = {
  $comment: string;
  kinds: KindsItem[];
  others: OthersItem[];
};

export const table: Table = {
  $comment:
    "The four kinds of id the protocol names, each a schema under components/schemas with the rule it is held to as its `pattern`. `properties` are the property names that always carry that kind, wherever they appear in the spec; `accepts` and `refuses` are strings the rule takes and does not, each with why. `others` are properties named like an id that carry something else. The reader's Identifiers_rules holds the spec to this file: every property so named refers to its kind, every case agrees with its kind's pattern, and a property whose name ends in `Id` or `Ids` that is in neither list fails. Each SDK's checked constructors run the same cases.",
  kinds: [
    {
      schema: 'ResourceId',
      properties: [
        'resourceId',
        'parentResourceId',
        'sourceResourceId',
        'resultResourceId',
        'scope',
        'wasDerivedFrom',
        'excludeResourceId',
        'resourceIds',
      ],
      accepts: [
        {
          id: '5bcd259ab1464cf68a556bbad21f513f',
          why: 'as the knowledge base mints one',
        },
        {
          id: '__system__',
          why: 'the scope events about the knowledge base itself are logged under',
        },
        {
          id: 'res-one',
          why: 'how an id is made is not part of the rule',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: '128 characters',
        },
      ],
      refuses: [
        {
          id: '',
          why: 'an id names something',
        },
        {
          id: '..',
          why: 'an id is one name in a file system, and this one names the directory above',
        },
        {
          id: '.',
          why: 'and this one the directory itself',
        },
        {
          id: 'a.json',
          why: 'no `.` at all: a store appends an extension to an id to name a file',
        },
        {
          id: 'a/b',
          why: 'an id is one segment of a path',
        },
        {
          id: 'a\\b',
          why: 'on any file system',
        },
        {
          id: 'https://kb.example/resources/5bcd259ab1464cf68a556bbad21f513f',
          why: 'a URI is not an id: the id is its last segment',
        },
        {
          id: 'a b',
          why: 'no whitespace',
        },
        {
          id: 'abc\n',
          why: 'a line end is whitespace too, at the end as anywhere',
        },
        {
          id: 'a%2Fb',
          why: 'nothing that needs encoding, and nothing already encoded',
        },
        {
          id: 'a?b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'a#b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'naïve',
          why: 'ASCII only: one spelling, on every file system',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: "129 characters: a file's name has a limit, and an id is well inside it",
        },
      ],
    },
    {
      schema: 'AnnotationId',
      properties: [
        'annotationId',
        'annotationIds',
        'sourceAnnotationId',
        'scrollToAnnotationId',
        'referenceId',
      ],
      accepts: [
        {
          id: '5bcd259ab1464cf68a556bbad21f513f',
          why: 'as the knowledge base mints one',
        },
        {
          id: 'a-1',
          why: 'how an id is made is not part of the rule',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: '128 characters',
        },
      ],
      refuses: [
        {
          id: '',
          why: 'an id names something',
        },
        {
          id: '..',
          why: 'an id is one name in a file system, and this one names the directory above',
        },
        {
          id: '.',
          why: 'and this one the directory itself',
        },
        {
          id: 'a.json',
          why: 'no `.` at all: a store appends an extension to an id to name a file',
        },
        {
          id: 'a/b',
          why: 'an id is one segment of a path',
        },
        {
          id: 'a\\b',
          why: 'on any file system',
        },
        {
          id: 'https://kb.example/resources/5bcd259ab1464cf68a556bbad21f513f',
          why: 'a URI is not an id: the id is its last segment',
        },
        {
          id: 'a b',
          why: 'no whitespace',
        },
        {
          id: 'abc\n',
          why: 'a line end is whitespace too, at the end as anywhere',
        },
        {
          id: 'a%2Fb',
          why: 'nothing that needs encoding, and nothing already encoded',
        },
        {
          id: 'a?b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'a#b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'naïve',
          why: 'ASCII only: one spelling, on every file system',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: "129 characters: a file's name has a limit, and an id is well inside it",
        },
      ],
    },
    {
      schema: 'JobId',
      properties: ['jobId'],
      accepts: [
        {
          id: 'job-5bcd259ab1464cf68a556bbad21f513f',
          why: 'as the dispatcher mints one',
        },
        {
          id: 'job-1',
          why: 'how an id is made is not part of the rule',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: '128 characters',
        },
      ],
      refuses: [
        {
          id: '',
          why: 'an id names something',
        },
        {
          id: '..',
          why: 'an id is one name in a file system, and this one names the directory above',
        },
        {
          id: '.',
          why: 'and this one the directory itself',
        },
        {
          id: 'a.json',
          why: 'no `.` at all: a store appends an extension to an id to name a file',
        },
        {
          id: 'a/b',
          why: 'an id is one segment of a path',
        },
        {
          id: 'a\\b',
          why: 'on any file system',
        },
        {
          id: 'https://kb.example/resources/5bcd259ab1464cf68a556bbad21f513f',
          why: 'a URI is not an id: the id is its last segment',
        },
        {
          id: 'a b',
          why: 'no whitespace',
        },
        {
          id: 'abc\n',
          why: 'a line end is whitespace too, at the end as anywhere',
        },
        {
          id: 'a%2Fb',
          why: 'nothing that needs encoding, and nothing already encoded',
        },
        {
          id: 'a?b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'a#b',
          why: 'nothing a URL reads as its own',
        },
        {
          id: 'naïve',
          why: 'ASCII only: one spelling, on every file system',
        },
        {
          id: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          why: "129 characters: a file's name has a limit, and an id is well inside it",
        },
      ],
    },
    {
      schema: 'UserId',
      properties: ['_userId', 'userId', 'holder', 'requester', 'participant'],
      accepts: [
        {
          id: 'did:web:kb.example:users:alice',
          why: 'a person',
        },
        {
          id: 'did:web:kb.example:agents:xynolog-worker',
          why: 'a software agent',
        },
        {
          id: 'did:web:localhost%3A4000:users:a%40b.example',
          why: 'a domain with a port, and a subject, both percent-encoded',
        },
        {
          id: "did:web:kb.example:users:o'brien!",
          why: "a subject is the issuer's, and its encoding leaves these as they are",
        },
      ],
      refuses: [
        {
          id: '',
          why: 'an id names someone',
        },
        {
          id: 'alice',
          why: 'a name is not an identity',
        },
        {
          id: 'alice@kb.example',
          why: 'nor is an address',
        },
        {
          id: 'user-123',
          why: 'nor is a row in a table',
        },
        {
          id: 'did:',
          why: 'a DID names something',
        },
        {
          id: 'did:web:kb.example:users:a b',
          why: 'no whitespace',
        },
        {
          id: 'did:web:kb.example:users:alice\n',
          why: 'a line end is whitespace too',
        },
        {
          id: ' did:web:kb.example:users:alice',
          why: 'no whitespace, before it either',
        },
      ],
    },
  ],
  others: [
    {
      property: 'byId',
      docs: "What a graph answers to a read of each resource's description, keyed by the resource's id (librarian/score-cases.json): a map, not an id.",
    },
    {
      property: 'clientId',
      docs: "A connection's own name for itself: a UUID the client makes, which its emits and its stream both carry so the gateway can pair them.",
    },
    {
      property: 'connectionId',
      docs: "The gateway's name for one open stream.",
    },
    {
      property: 'contextAnnotationIds',
      docs: "The ids a worker's context holds of annotations a citation may name, as a case gives them: one that is no AnnotationId drops a citation of it, so not every one is (worker/citation-cases.json).",
    },
    {
      property: 'contextResourceIds',
      docs: "The ids a worker's context holds of resources a citation may name, as a case gives them: one that is no ResourceId drops a citation of it, so not every one is (worker/citation-cases.json).",
    },
    {
      property: 'correlationId',
      docs: 'What pairs a reply with its request: made by whoever asks, and opaque to everything between.',
    },
    {
      property: 'kbId',
      docs: 'Which knowledge base a host process has loaded, named as that process names it (`LocalEndpoint`): it means nothing to anyone else, and is no kind of id the protocol holds to a rule.',
    },
    {
      property: 'lastEventId',
      docs: 'The id of the last event a stream delivered, a PersistedEventId: where a resumed stream begins.',
    },
    {
      property: 'lastEventIds',
      docs: "The JSON Schema of where a knowledge base's stream was, as a session stores it under `lastEventIdKeyPrefix` (session/stored.json): a schema, and no id.",
    },
    {
      property: 'lastSeenId',
      docs: 'The same, as the gateway reports the gap it could not fill.',
    },
    {
      property: 'qdrantId',
      docs: "The id Qdrant keys a point of the vector index by: the MD5 of the point's key, in a UUID's groups (vectors/payload-cases.json).",
    },
    {
      property: 'requestId',
      docs: "Which request of the launcher's control API a notification is about: the JSON-RPC id its client gave the request, a string or an integer (control/RequestId.json).",
    },
    {
      property: 'schemaId',
      docs: "A tag schema's id: a name the knowledge base's vocabulary gives it.",
    },
    {
      property: 'tagSchemaId',
      docs: 'The tag schema a tagging annotation names, read from its body: a schemaId (annotations/reader-cases.json).',
    },
  ],
};

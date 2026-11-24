// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/surface.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Json =
  null | boolean | number | string | Json[] | { [key: string]: Json };

export type Shapes = {
  promise: string;
  stream: string;
  delegation: string;
  upload: string;
  cache: string;
  signal: string;
  count: string;
  events: string;
  claims: string;
};

export type Via = {
  request: string;
  emit: string;
  local: string;
  content: string;
  gateway: string;
  observes: string;
};

export type Fixtures = {
  context: Json;
  selector: Json;
};

export type Shape =
  | 'promise'
  | 'stream'
  | 'delegation'
  | 'upload'
  | 'cache'
  | 'signal'
  | 'count'
  | 'events'
  | 'claims';

export type Request = {
  request: string;
};

export type Emit = {
  emit: string;
};

export type Local = {
  local: string;
};

export type Content = {
  content: string;
};

export type Gateway = {
  gateway: string;
};

export type Observes = {
  observes: string;
};

export type ItemVia = Request | Emit | Local | Content | Gateway | Observes;

export type Reference = {
  $ref: string;
};

export type Type = 'integer' | 'string' | 'boolean';

export type Scalar = {
  type: Type;
  minimum?: number;
  description: string;
};

export type Schema = Reference | Scalar;

export type Value = {
  parameter: string;
  schema: Schema;
  required: boolean;
};

export type Callback = {
  parameter: string;
  calls: Schema;
  required: boolean;
};

export type ParametersItem = Value | Callback;

export type ThenItemRequest = {
  request: string;
  sends: Json;
};

export type ThenItemContent = {
  content: string;
  sends: Json;
};

export type ThenItem = ThenItemRequest | ThenItemContent;

export type CasesItem = {
  why?: string;
  args: Json;
  sends: Json;
  answers?: Json;
  then?: ThenItem[];
  correlationId?: string;
};

export type MethodsItem = {
  method: string;
  shape: Shape;
  via: ItemVia;
  parameters: ParametersItem[];
  returns: Schema | null;
  cases: CasesItem[];
};

export type NamespacesItem = {
  namespace: string;
  docs: string;
  methods: MethodsItem[];
};

export type NamedValue = {
  name: string;
  why: string;
};

export type MembersItem = {
  member: string;
  named?: { [key: string]: NamedValue };
  takes?: { [key: string]: string };
};

export type WorkerItem = {
  handed: string;
  docs: string;
  members: MembersItem[];
};

export type ItemMembersItem = {
  member: string;
};

export type StateUnitsItem = {
  unit: string;
  docs: string;
  made: { [key: string]: string };
  madeBy: { [key: string]: string };
  members: ItemMembersItem[];
};

export type WireMembersItem = {
  member: string;
};

export type Wire = {
  docs: string;
  made: { [key: string]: string };
  members: WireMembersItem[];
};

export type StorageMembersItem = {
  member: string;
};

export type Storage = {
  docs: string;
  made: { [key: string]: string };
  members: StorageMembersItem[];
};

export type Reader = {
  member: string;
  kind: 'reader';
};

export type Function = {
  member: string;
  kind: 'function';
  named?: { [key: string]: string };
};

export type ModulesItemMembersItemType = {
  member: string;
  kind: 'type';
  named?: { [key: string]: string };
  fieldsNamed?: { [key: string]: { [key: string]: string } };
  fields?: string[];
};

export type Constant = {
  member: string;
  kind: 'constant';
  named?: { [key: string]: string };
};

export type ModulesItemMembersItem =
  Reader | Function | ModulesItemMembersItemType | Constant;

export type ModulesItem = {
  module: string;
  docs: string;
  where: { [key: string]: string[] };
  whole?: string[];
  members: ModulesItemMembersItem[];
};

export type ClockItem = {
  source: string;
  docs: string;
  typeWords: string[];
  outside: { [key: string]: string };
  takes: { [key: string]: { [key: string]: string[] } };
};

export type Table = {
  $comment: string;
  shapes: Shapes;
  via: Via;
  fixtures: Fixtures;
  namespaces: NamespacesItem[];
  worker: WorkerItem[];
  stateUnits: StateUnitsItem[];
  wire: Wire;
  storage: Storage;
  modules: ModulesItem[];
  clock: ClockItem[];
};

export const table: Table = {
  $comment:
    "AUTHORITY for the surface of a Xynolog client: every namespace, every method, the shape of what it returns, and what calling it does first. Its behaviour is run: each SDK's surface test calls every method as each of its `cases` states and holds what the call did to the row. Which methods an SDK has is held by its own surface test, where the test keeps a census of them; what each takes and returns is held by no check yet. `parameters` is what a method takes, in order: each parameter by the name its cases' `args` give it, whether a caller must give it, and either its `schema` (a component, a member within one, or a client type of specs/src/client/types, so that every object is named; or a scalar where none states it) or, for a callback, the schema of what each call hands it (`calls`). Protocol's reader holds each case to its method's `parameters` (reader/lib/client_surface.ml): a case gives no argument the method does not take, every one it requires, and each as its parameter's schema says. A null is a value, which a caller gives only where the schema admits it. Every SDK takes each parameter the table states, and none another: an SDK's name for one is the table's, spelled by its language's convention, and how it takes one is its language's (positionally, by keyword, or as a member of a record its writer makes of an object whose members a caller may each leave out), as is the type it holds a count of milliseconds as. A language's own means of cancelling a call (Go's `context.Context`, C#'s `CancellationToken`) is no parameter here. The consumer-owned generator is to write each SDK's namespace types from each method's `parameters` and `shape`. A method name is the table's, in camelCase; an SDK spells it by its language's convention (`resourceContent` is `resource_content` in Rust and `ResourceContent` in Go, whose first letter is a capital), and a namespace whose name is a keyword there takes a trailing underscore (`yield_`, `match_`). Swift keeps both names, including its contextual `yield`. Neither is a keyword in Kotlin, which keeps both names; Java reaches them through their getters (`getYield()`), which Java's contextual `yield` does not touch. An `events` row is a property named `<method>$` in TypeScript. The table names no SDK that lacks part of the surface: which SDK lacks a method, a member, a unit, a module or a clock's maker, or is still to have one, and why, is each SDK repository's to record. Add a row here before adding a method to any SDK. `worker` is the surface of what a worker is handed: the claims `job.claim` returns, and a job the worker holds. Each lists its members by name, and every SDK is to match the list both ways: it lacks no member the list has, and has no public member the list lacks. No check holds an SDK to the list yet. A member is matched by its name alone, spelled as its language spells it, and its form is its language's: what a held job states is a property in TypeScript and Python and a method in Rust, and a property that gives a stream of values is named `<member>$` in TypeScript. What a language's own protocols give a type is no member here: how a type is made, Python's names that begin with an underscore, its `__aenter__` and `__anext__` among them, Rust's trait implementations, and what a TypeScript class inherits from a class the SDK does not declare. `named` gives the name an SDK has the member under where its ecosystem has a name of its own for it, and why: that SDK then has that name, and not the table's as well. `takes` marks a member a held job has as its verb's: for each verb, the schema of what the member takes. What a member does is not held here and these rows have no cases: contract/WORKER-CONTRACT.md states it, and the worker conformance suite (conformance/worker) holds each SDK to it. Add a member here before adding it to any SDK. `stateUnits` lists each state unit: what each SDK makes it as (`made`), and its members by name. Every SDK is to match it both ways, and no check holds one to it yet: it declares every unit, each as a `StateUnit`; every `StateUnit` it declares among its units is one a row makes; and each of its units has every member the list has and no public member the list lacks. A member is matched by its name alone, spelled as its language spells it, and its form is its language's, as for `worker`. `dispose` is no member here: every unit has it, being a `StateUnit`. How a unit is made is stated apart from its members: every unit can be made from outside its SDK, by the type's own public constructor (Rust's `pub fn new` in the type's own `impl`, Python's class), or by the public function that `madeBy` names for that SDK, spelled as that SDK spells it, where the constructor is not what makes it; Go has no constructors, so every Go unit names one. No unit is without a public way to make it, and a `madeBy` names a function its SDK has publicly. Public is reachable from outside the SDK, including what Swift declares `public` or `open`: what TypeScript's entry (sdk/typescript/sdk/src/index.ts) exports, an item a module Rust's crate root reaches declares or re-exports, a name in the `__all__` of a Python module whose path has no private part, what Kotlin declares `public`, and what Go exports from a package that is not internal. What a unit does is not held here: each SDK's tests of its units hold that. Add a unit or a member here before adding it to any SDK. `wire` is the typed bus over a client's transport, which every client hands out as `wire`: what each SDK makes it as (`made`), and its members by name. Every SDK is to match it both ways, as for a state unit, and no check holds one to it yet: it declares a bus, and its bus has every member the list has and no public member the list lacks. A member is matched by its name alone, as for `worker`; how a bus is made is no member. A Go method takes no type parameters, so a member of Go's bus that is generic in its channel is a function of its package that takes the bus (`Emit(ctx, w, bus.MarkSubmit, payload)`). TypeScript's bus is read where @xynolog/core declares it. A transport is no member: a bus hands out none. Add a member here before adding it to any SDK. `storage` is where a client keeps text under a key: the interface an application implements (a trait in Rust, a protocol in Python), what each SDK names it (`made`), and its members by name. Every SDK is to match it both ways, as for `wire`, and no check holds one to it yet: it declares a storage, and its storage has every member the list has and no public member the list lacks. A member is matched by its name alone, as for `worker`. What implements a storage is not read here. Add a member here before adding it to any SDK. `modules` is what each SDK has beside its namespaces: the free functions, types and values of its modules, each module with where each SDK keeps it and its members. A member is named as the table spells it and matched by its `kind`: a `function` is spelled by each language's convention, a `reader` as a function but `get` and its name in TypeScript, a `type` as the table spells it, and a `constant` in capitals with underscores but in Go, as a function, and in Swift, as the table spells it. `named` gives an SDK's own name where the rule does not, and is stale once it is not so. A module whose `whole` names an SDK is that SDK's files alone, and every public member of them is listed. `clock` is what a caller controls of an SDK's time and chance: the clock every wait keeps, and the random source every jitter draws, one row each. For every SDK a row says either how a caller controls the source from outside the SDK (`outside`), or which public makers take it (`takes`): each maker as its SDK spells it (`Type.member`, or `Type::member` in Rust, for a type's function), with the types it takes the source as. Every SDK is to match it both ways, and no check holds one to it yet: every public way of making a listed maker takes each of its types, or is handed another maker of the row that takes them already, and keeps that one's; and no parameter or field of an `outside` SDK has a type the row's `typeWords` name. When a wait ends under a moved clock is specs/src/client/clock-cases.json's.",
  shapes: {
    promise: 'Asked once, answered once: the value, or a failure with a code.',
    stream:
      'A long-running operation: what it reports as it goes, then its final value. Awaited, it gives the final value.',
    delegation:
      "A job another party does: the job's events as it goes, the queue's naming of it the first of them and its completion the last. Awaited, it gives the completion.",
    upload:
      'An upload in flight: its progress, then the id of the resource created.',
    cache:
      'A live query. Building it touches nothing; its one-shot read asks the service now.',
    signal: 'Fire-and-forget. Nothing is returned and nothing is awaited.',
    count:
      'A drive at the other participants: resolves with how many the gateway reached, or with no count when it kept none.',
    events: "The events of one channel of the client's own bus, from now on.",
    claims:
      "A worker's claims: each job it comes to hold, one at a time, from the first claim on. A held job starts, reports and settles itself.",
  },
  via: {
    request:
      'A request of a bus operation, answered on its result or failure channel.',
    emit: 'A frame sent over the wire, with no reply awaited.',
    local: "A frame published on the client's own bus and nowhere else.",
    content:
      'An operation of the content transport: putBinary, getBinary, getBinaryStream, getResourceGraph, getAnnotations or getAnchoredText.',
    gateway:
      "One of the gateway's own operations: getCurrentUser, getMediaToken, getProtectedResourceMetadata, healthCheck or getStatus.",
    observes:
      "The channel of the client's own bus whose frames an `events` row gives.",
  },
  fixtures: {
    context: {
      focus: {
        kind: 'resource',
        resource: {
          '@context': 'https://schema.org',
          '@id': 'res-1',
          name: 'A resource',
          representations: [
            {
              mediaType: 'text/plain',
            },
          ],
        },
      },
      graph: {
        nodes: [],
        edges: [],
      },
      metadata: {},
    },
    selector: {
      type: 'TextQuoteSelector',
      exact: 'hello',
    },
  },
  namespaces: [
    {
      namespace: 'frame',
      docs: "The knowledge base's vocabulary: what kinds of things exist.",
      methods: [
        {
          method: 'addEntityType',
          shape: 'promise',
          via: {
            request: 'frame:add-entity-type',
          },
          parameters: [
            {
              parameter: 'type',
              schema: {
                $ref: 'https://xynolog.org/protocol/FrameAddEntityTypeCommand.json#/properties/tag',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                type: 'Person',
              },
              sends: {
                tag: 'Person',
              },
            },
          ],
        },
        {
          method: 'addEntityTypes',
          shape: 'promise',
          via: {
            request: 'frame:add-entity-type',
          },
          parameters: [
            {
              parameter: 'types',
              schema: {
                $ref: 'https://xynolog.org/protocol/GetEntityTypesResponse.json#/properties/entityTypes',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              why: 'one request per type, in order, each awaited',
              args: {
                types: ['Person', 'Place'],
              },
              sends: {
                tag: 'Person',
              },
              answers: null,
              then: [
                {
                  request: 'frame:add-entity-type',
                  sends: {
                    tag: 'Place',
                  },
                },
              ],
            },
          ],
        },
        {
          method: 'addTagSchema',
          shape: 'promise',
          via: {
            request: 'frame:add-tag-schema',
          },
          parameters: [
            {
              parameter: 'schema',
              schema: {
                $ref: 'https://xynolog.org/protocol/TagSchema.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                schema: {
                  id: 's1',
                  name: 'Structure',
                  description: 'Parts of an argument',
                  domain: 'legal',
                  tags: [],
                },
              },
              sends: {
                schema: {
                  id: 's1',
                  name: 'Structure',
                  description: 'Parts of an argument',
                  domain: 'legal',
                  tags: [],
                },
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'browse',
      docs: "Reads: live queries, one-shot reads, and this viewer's own signals.",
      methods: [
        {
          method: 'resource',
          shape: 'cache',
          via: {
            request: 'browse:resource-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/ResourceDescriptor.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resources',
          shape: 'cache',
          via: {
            request: 'browse:resources-requested',
          },
          parameters: [
            {
              parameter: 'filters',
              schema: {
                $ref: 'https://xynolog.org/protocol/BrowseResourcesRequest.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/ListResourcesResponse.json',
          },
          cases: [
            {
              why: 'no filters: the first hundred',
              args: {},
              sends: {
                limit: 100,
                offset: 0,
              },
            },
            {
              args: {
                filters: {
                  archived: false,
                  entityType: 'Person',
                  limit: 5,
                },
              },
              sends: {
                archived: false,
                entityType: 'Person',
                limit: 5,
                offset: 0,
              },
            },
            {
              why: 'a page further on: the resources before it are passed over',
              args: {
                filters: {
                  limit: 50,
                  offset: 100,
                },
              },
              sends: {
                limit: 50,
                offset: 100,
              },
            },
          ],
        },
        {
          method: 'annotations',
          shape: 'cache',
          via: {
            content: 'getAnnotations',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetAnnotationsResponse.json#/properties/annotations',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'annotation',
          shape: 'cache',
          via: {
            request: 'browse:annotation-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/Annotation.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
              sends: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
            },
          ],
        },
        {
          method: 'entityTypes',
          shape: 'cache',
          via: {
            request: 'browse:entity-types-requested',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetEntityTypesResponse.json#/properties/entityTypes',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'tagSchemas',
          shape: 'cache',
          via: {
            request: 'browse:tag-schemas-requested',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetTagSchemasResponse.json#/properties/tagSchemas',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'engines',
          shape: 'cache',
          via: {
            request: 'browse:engines-requested',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/EnginesWithLimits.json',
          },
          cases: [
            {
              why: "the engines are asked for first; each key holder's limits after it",
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'events',
          shape: 'cache',
          via: {
            request: 'browse:events-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetEventsResponse.json#/properties/events',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceContent',
          shape: 'promise',
          via: {
            content: 'getBinary',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            type: 'string',
            description:
              "The resource's text: its bytes decoded as contract/W3C-SELECTORS.md states, a byte-order mark first, then the charset the content transport answered with, then UTF-8. A media type whose text is not its bytes is refused.",
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceGraph',
          shape: 'promise',
          via: {
            content: 'getResourceGraph',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetResourceResponse.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceAnchoredText',
          shape: 'promise',
          via: {
            content: 'getAnchoredText',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/AnchoredTextAnswer.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceRepresentation',
          shape: 'promise',
          via: {
            content: 'getBinary',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/ResourceRepresentation.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceRepresentationStream',
          shape: 'promise',
          via: {
            content: 'getBinaryStream',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/ResourceRepresentationStream.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceEvents',
          shape: 'promise',
          via: {
            request: 'browse:events-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetEventsResponse.json#/properties/events',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'annotationHistory',
          shape: 'promise',
          via: {
            request: 'browse:annotation-history-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetAnnotationHistoryResponse.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
              sends: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
            },
          ],
        },
        {
          method: 'files',
          shape: 'promise',
          via: {
            request: 'browse:directory-requested',
          },
          parameters: [
            {
              parameter: 'dirPath',
              schema: {
                $ref: 'https://xynolog.org/protocol/BrowseDirectoryRequest.json#/properties/path',
              },
              required: false,
            },
            {
              parameter: 'sort',
              schema: {
                $ref: 'https://xynolog.org/protocol/BrowseDirectoryRequest.json#/properties/sort',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/BrowseDirectoryResultResponse.json',
          },
          cases: [
            {
              why: 'no arguments: the root, by name',
              args: {},
              sends: {
                path: '.',
                sort: 'name',
              },
            },
            {
              args: {
                dirPath: 'docs',
                sort: 'mtime',
              },
              sends: {
                path: 'docs',
                sort: 'mtime',
              },
            },
          ],
        },
        {
          method: 'kb',
          shape: 'promise',
          via: {
            request: 'browse:kb-requested',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/KbDescription.json',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'click',
          shape: 'signal',
          via: {
            local: 'browse:click',
          },
          parameters: [
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
            {
              parameter: 'anchorRect',
              schema: {
                $ref: 'https://xynolog.org/protocol/BrowseClickEvent.json#/properties/anchorRect',
              },
              required: false,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
              },
            },
            {
              why: 'A viewer that knows where the clicked annotation is on screen says so: the anchorRect rides the local frame beside the id.',
              args: {
                annotationId: 'ann-1',
                anchorRect: {
                  x: 10,
                  y: 20,
                  width: 30,
                  height: 40,
                  top: 20,
                  right: 40,
                  bottom: 60,
                  left: 10,
                },
              },
              sends: {
                annotationId: 'ann-1',
                anchorRect: {
                  x: 10,
                  y: 20,
                  width: 30,
                  height: 40,
                  top: 20,
                  right: 40,
                  bottom: 60,
                  left: 10,
                },
              },
            },
          ],
        },
        {
          method: 'openResource',
          shape: 'signal',
          via: {
            local: 'browse:resource-open',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'resourceViewed',
          shape: 'signal',
          via: {
            emit: 'browse:resource-viewed',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              why: 'a report, so it goes over the wire',
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'mark',
      docs: "Annotations: their creation and removal, a resource's own metadata, and the annotating of a resource delegated as a job.",
      methods: [
        {
          method: 'annotation',
          shape: 'promise',
          via: {
            request: 'mark:create-request',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/CreateAnnotationRequest.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/MarkCreateOkResponse.json',
          },
          cases: [
            {
              why: "the resource is the annotation's target",
              args: {
                input: {
                  motivation: 'highlighting',
                  target: {
                    source: 'res-1',
                  },
                },
              },
              sends: {
                resourceId: 'res-1',
                request: {
                  motivation: 'highlighting',
                  target: {
                    source: 'res-1',
                  },
                },
              },
            },
          ],
        },
        {
          method: 'delete',
          shape: 'promise',
          via: {
            request: 'mark:delete',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'archive',
          shape: 'promise',
          via: {
            request: 'mark:archive',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'unarchive',
          shape: 'promise',
          via: {
            request: 'mark:unarchive',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'updateEntityTypes',
          shape: 'promise',
          via: {
            request: 'mark:update-entity-types',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'current',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkUpdateEntityTypesCommand.json#/properties/currentEntityTypes',
              },
              required: true,
            },
            {
              parameter: 'updated',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkUpdateEntityTypesCommand.json#/properties/updatedEntityTypes',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
                current: ['Person'],
                updated: ['Person', 'Place'],
              },
              sends: {
                resourceId: 'res-1',
                currentEntityTypes: ['Person'],
                updatedEntityTypes: ['Person', 'Place'],
              },
            },
          ],
        },
        {
          method: 'delegate',
          shape: 'delegation',
          via: {
            request: 'job:create',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'params',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkJobParams.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/MarkJobCompleteCommand.json',
          },
          cases: [
            {
              why: 'the namespace is the verb, so the job is a mark job; its parameters state its motivation',
              args: {
                resourceId: 'res-1',
                params: {
                  motivation: 'highlighting',
                },
              },
              sends: {
                jobType: 'mark',
                resourceId: 'res-1',
                params: {
                  motivation: 'highlighting',
                },
              },
            },
            {
              args: {
                resourceId: 'res-1',
                params: {
                  motivation: 'linking',
                  entityTypes: ['Person'],
                  includeDescriptiveReferences: true,
                },
              },
              sends: {
                jobType: 'mark',
                resourceId: 'res-1',
                params: {
                  motivation: 'linking',
                  entityTypes: ['Person'],
                  includeDescriptiveReferences: true,
                },
              },
            },
            {
              why: 'a tagging job is given what a tagging job takes, each parameter under its own name',
              args: {
                resourceId: 'res-1',
                params: {
                  motivation: 'tagging',
                  schemaId: 's1',
                  categories: ['claim'],
                  language: 'en',
                  sourceLanguage: 'fr',
                },
              },
              sends: {
                jobType: 'mark',
                resourceId: 'res-1',
                params: {
                  motivation: 'tagging',
                  schemaId: 's1',
                  categories: ['claim'],
                  language: 'en',
                  sourceLanguage: 'fr',
                },
              },
            },
            {
              why: 'an assessing job is given what an assessing job takes',
              args: {
                resourceId: 'res-1',
                params: {
                  motivation: 'assessing',
                  instructions: 'be brief',
                  tone: 'critical',
                  density: 2.5,
                  language: 'en',
                  sourceLanguage: 'fr',
                },
              },
              sends: {
                jobType: 'mark',
                resourceId: 'res-1',
                params: {
                  motivation: 'assessing',
                  instructions: 'be brief',
                  tone: 'critical',
                  density: 2.5,
                  language: 'en',
                  sourceLanguage: 'fr',
                },
              },
            },
            {
              args: {
                resourceId: 'res-1',
                params: {
                  motivation: 'commenting',
                  tone: 'scholarly',
                },
              },
              sends: {
                jobType: 'mark',
                resourceId: 'res-1',
                params: {
                  motivation: 'commenting',
                  tone: 'scholarly',
                },
              },
            },
          ],
        },
        {
          method: 'request',
          shape: 'signal',
          via: {
            local: 'mark:requested',
          },
          parameters: [
            {
              parameter: 'source',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/source',
              },
              required: true,
            },
            {
              parameter: 'selector',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/selector',
              },
              required: true,
            },
            {
              parameter: 'motivation',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkRequestedEvent.json#/properties/motivation',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                source: 'res-1',
                selector: {
                  $fixture: 'selector',
                },
                motivation: 'highlighting',
              },
              sends: {
                source: 'res-1',
                selector: {
                  $fixture: 'selector',
                },
                motivation: 'highlighting',
              },
            },
          ],
        },
        {
          method: 'submit',
          shape: 'signal',
          via: {
            local: 'mark:submit',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/MarkSubmitEvent.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                input: {
                  source: 'res-1',
                  motivation: 'highlighting',
                  selector: {
                    $fixture: 'selector',
                  },
                },
              },
              sends: {
                source: 'res-1',
                motivation: 'highlighting',
                selector: {
                  $fixture: 'selector',
                },
              },
            },
          ],
        },
        {
          method: 'reportDeleteError',
          shape: 'signal',
          via: {
            local: 'mark:delete-error',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceErrorEvent.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                input: {
                  resourceId: 'res-1',
                  message: 'the delete was refused',
                },
              },
              sends: {
                resourceId: 'res-1',
                message: 'the delete was refused',
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'bind',
      docs: 'Linking a reference to what it refers to.',
      methods: [
        {
          method: 'body',
          shape: 'promise',
          via: {
            request: 'bind:update-body',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
            {
              parameter: 'operations',
              schema: {
                $ref: 'https://xynolog.org/protocol/BindUpdateBodyCommand.json#/properties/operations',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
                operations: [
                  {
                    op: 'remove',
                  },
                ],
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
                operations: [
                  {
                    op: 'remove',
                  },
                ],
              },
            },
          ],
        },
        {
          method: 'initiate',
          shape: 'signal',
          via: {
            local: 'bind:initiate',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/BindInitiateCommand.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                input: {
                  annotationId: 'ann-1',
                  resourceId: 'res-1',
                  defaultTitle: 'A title',
                  entityTypes: ['Person'],
                },
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
                defaultTitle: 'A title',
                entityTypes: ['Person'],
              },
            },
          ],
        },
        {
          method: 'reportBodyError',
          shape: 'signal',
          via: {
            local: 'bind:body-error',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceErrorEvent.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                input: {
                  resourceId: 'res-1',
                  message: 'the link was refused',
                },
              },
              sends: {
                resourceId: 'res-1',
                message: 'the link was refused',
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'gather',
      docs: 'Assembling the context a model is given, and what refers to a resource.',
      methods: [
        {
          method: 'annotation',
          shape: 'stream',
          via: {
            request: 'gather:requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/GatherAnnotationOptions.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GatherAnnotationComplete.json',
          },
          cases: [
            {
              why: 'no options: a window of two thousand characters',
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
                options: {
                  contextWindow: 2000,
                },
              },
            },
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
                options: {
                  contextWindow: 500,
                },
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
                options: {
                  contextWindow: 500,
                },
              },
            },
            {
              why: 'a context asked for or left out is sent as stated, false as well as true; the window not stated is two thousand',
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
                options: {
                  includeSourceContext: false,
                  includeTargetContext: true,
                },
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
                options: {
                  includeSourceContext: false,
                  includeTargetContext: true,
                  contextWindow: 2000,
                },
              },
            },
          ],
        },
        {
          method: 'resource',
          shape: 'promise',
          via: {
            request: 'gather:resource-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/GatherResourceOptions.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GatheredContext.json',
          },
          cases: [
            {
              why: 'no options: two hops, ten resources, their content and no summary',
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
                options: {
                  depth: 2,
                  maxResources: 10,
                  includeContent: true,
                  includeSummary: false,
                },
              },
            },
            {
              args: {
                resourceId: 'res-1',
                options: {
                  depth: 1,
                  maxResources: 3,
                  includeContent: false,
                  includeSummary: true,
                  excludeEntityTypes: ['Question'],
                },
              },
              sends: {
                resourceId: 'res-1',
                options: {
                  depth: 1,
                  maxResources: 3,
                  includeContent: false,
                  includeSummary: true,
                  excludeEntityTypes: ['Question'],
                },
              },
            },
            {
              why: 'an empty exclusion is no exclusion, and is not sent',
              args: {
                resourceId: 'res-1',
                options: {
                  excludeEntityTypes: [],
                },
              },
              sends: {
                resourceId: 'res-1',
                options: {
                  depth: 2,
                  maxResources: 10,
                  includeContent: true,
                  includeSummary: false,
                },
              },
            },
          ],
        },
        {
          method: 'referencedBy',
          shape: 'cache',
          via: {
            request: 'gather:referenced-by-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/GetReferencedByResponse.json#/properties/referencedBy',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'match',
      docs: 'Searching: for what a reference could refer to, and for resources by text.',
      methods: [
        {
          method: 'search',
          shape: 'stream',
          via: {
            request: 'match:search-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'referenceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/MatchSearchRequest.json#/properties/referenceId',
              },
              required: true,
            },
            {
              parameter: 'context',
              schema: {
                $ref: 'https://xynolog.org/protocol/MatchSearchRequest.json#/properties/context',
              },
              required: true,
            },
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/MatchSearchOptions.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/MatchSearchResult.json',
          },
          cases: [
            {
              why: 'no options: ten candidates, scored semantically',
              args: {
                resourceId: 'res-1',
                referenceId: 'ann-1',
                context: {
                  $fixture: 'context',
                },
              },
              sends: {
                resourceId: 'res-1',
                referenceId: 'ann-1',
                context: {
                  $fixture: 'context',
                },
                limit: 10,
                useSemanticScoring: true,
              },
            },
            {
              args: {
                resourceId: 'res-1',
                referenceId: 'ann-1',
                context: {
                  $fixture: 'context',
                },
                options: {
                  limit: 3,
                  useSemanticScoring: false,
                },
              },
              sends: {
                resourceId: 'res-1',
                referenceId: 'ann-1',
                context: {
                  $fixture: 'context',
                },
                limit: 3,
                useSemanticScoring: false,
              },
            },
          ],
        },
        {
          method: 'requestSearch',
          shape: 'signal',
          via: {
            local: 'match:search-requested',
          },
          parameters: [
            {
              parameter: 'input',
              schema: {
                $ref: 'https://xynolog.org/protocol/MatchSearchRequest.json',
              },
              required: true,
            },
            {
              parameter: 'correlationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/BusFrame.json#/properties/correlationId',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              why: "the caller's key rides the envelope, never the payload",
              args: {
                input: {
                  resourceId: 'res-1',
                  referenceId: 'ann-1',
                  context: {
                    $fixture: 'context',
                  },
                },
                correlationId: 'cid-1',
              },
              sends: {
                resourceId: 'res-1',
                referenceId: 'ann-1',
                context: {
                  $fixture: 'context',
                },
              },
              correlationId: 'cid-1',
            },
          ],
        },
        {
          method: 'resources',
          shape: 'cache',
          via: {
            request: 'match:resources-requested',
          },
          parameters: [
            {
              parameter: 'search',
              schema: {
                $ref: 'https://xynolog.org/protocol/MatchResourcesRequest.json#/properties/search',
              },
              required: true,
            },
            {
              parameter: 'filters',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceSearchFilters.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/MatchResourcesResponse.json',
          },
          cases: [
            {
              why: 'no filters: the first hundred',
              args: {
                search: 'cat',
              },
              sends: {
                search: 'cat',
                limit: 100,
                offset: 0,
              },
            },
            {
              args: {
                search: 'cat',
                filters: {
                  archived: false,
                  entityType: 'Person',
                  limit: 5,
                },
              },
              sends: {
                search: 'cat',
                archived: false,
                entityType: 'Person',
                limit: 5,
                offset: 0,
              },
            },
            {
              why: 'a page further on: the resources before it are passed over',
              args: {
                search: 'cat',
                filters: {
                  limit: 50,
                  offset: 100,
                },
              },
              sends: {
                search: 'cat',
                limit: 50,
                offset: 100,
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'yield',
      docs: 'Creating resources: by upload, by a generation delegated as a job, by cloning.',
      methods: [
        {
          method: 'resource',
          shape: 'upload',
          via: {
            content: 'putBinary',
          },
          parameters: [
            {
              parameter: 'data',
              schema: {
                $ref: 'https://xynolog.org/protocol/PutBinaryRequest.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/CreateResourceResponse.json',
          },
          cases: [
            {
              args: {
                data: {
                  name: 'Notes',
                  file: 'hello',
                  format: 'text/plain',
                  storageUri: 'file://notes.txt',
                },
              },
              sends: {
                name: 'Notes',
                content: 'hello',
                format: 'text/plain',
                storageUri: 'file://notes.txt',
              },
            },
          ],
        },
        {
          method: 'delegate',
          shape: 'delegation',
          via: {
            request: 'job:create',
          },
          parameters: [
            {
              parameter: 'params',
              schema: {
                $ref: 'https://xynolog.org/protocol/GenerationJobParams.json',
              },
              required: true,
            },
            {
              parameter: 'stallDeadlineMs',
              schema: {
                type: 'integer',
                minimum: 0,
                description:
                  "How long the followed generation may say nothing, in milliseconds, before it is given up on. The follower's own, never sent: left out, it grows with the generation's `maxTokens` as client/timing.json's generationStall timings say.",
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/YieldJobCompleteCommand.json',
          },
          cases: [
            {
              why: "the namespace is the verb, so the job is a yield job; it names no resource: its context's focus does",
              args: {
                params: {
                  title: 'A summary',
                  storageUri: 'file://a-summary.md',
                  context: {
                    $fixture: 'context',
                  },
                },
              },
              sends: {
                jobType: 'yield',
                params: {
                  title: 'A summary',
                  storageUri: 'file://a-summary.md',
                  context: {
                    $fixture: 'context',
                  },
                },
              },
            },
            {
              why: "how long the follower waits is the client's own: it is given beside the job's parameters, and is not sent",
              args: {
                params: {
                  title: 'A summary',
                  storageUri: 'file://a-summary.md',
                  prompt: 'in one line',
                  maxTokens: 200,
                  context: {
                    $fixture: 'context',
                  },
                },
                stallDeadlineMs: 5000,
              },
              sends: {
                jobType: 'yield',
                params: {
                  title: 'A summary',
                  storageUri: 'file://a-summary.md',
                  prompt: 'in one line',
                  maxTokens: 200,
                  context: {
                    $fixture: 'context',
                  },
                },
              },
            },
          ],
        },
        {
          method: 'cloneToken',
          shape: 'promise',
          via: {
            request: 'yield:clone-token-requested',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/CloneResourceWithTokenResponse.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'fromToken',
          shape: 'promise',
          via: {
            request: 'yield:clone-resource-requested',
          },
          parameters: [
            {
              parameter: 'token',
              schema: {
                $ref: 'https://xynolog.org/protocol/YieldCloneResourceRequest.json#/properties/token',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/ResourceDescriptor.json',
          },
          cases: [
            {
              args: {
                token: 'tok-1',
              },
              sends: {
                token: 'tok-1',
              },
            },
          ],
        },
        {
          method: 'createFromToken',
          shape: 'promise',
          via: {
            request: 'yield:clone-resource-requested',
          },
          parameters: [
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/CreateFromTokenOptions.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/CreateResourceResponse.json',
          },
          cases: [
            {
              why: "the source is read first; the clone is uploaded in a format its source's allows, under a name made from its own",
              args: {
                options: {
                  token: 'tok-1',
                  name: 'A Copy',
                  content: 'hello',
                },
              },
              sends: {
                token: 'tok-1',
              },
              answers: {
                sourceResource: {
                  '@context': 'https://schema.org',
                  '@id': 'res-1',
                  name: 'A resource',
                  representations: [
                    {
                      mediaType: 'text/markdown',
                    },
                  ],
                },
                expiresAt: '2030-01-01T00:00:00.000Z',
              },
              then: [
                {
                  content: 'putBinary',
                  sends: {
                    name: 'A Copy',
                    content: 'hello',
                    format: 'text/markdown',
                    storageUri: 'file://a-copy.md',
                    cloneToken: 'tok-1',
                  },
                },
              ],
            },
            {
              why: 'a source in a format nobody authors is cloned as plain text',
              args: {
                options: {
                  token: 'tok-1',
                  name: 'A Copy',
                  content: 'hello',
                },
              },
              sends: {
                token: 'tok-1',
              },
              answers: {
                sourceResource: {
                  '@context': 'https://schema.org',
                  '@id': 'res-1',
                  name: 'A resource',
                  representations: [
                    {
                      mediaType: 'application/pdf',
                    },
                  ],
                },
                expiresAt: '2030-01-01T00:00:00.000Z',
              },
              then: [
                {
                  content: 'putBinary',
                  sends: {
                    name: 'A Copy',
                    content: 'hello',
                    format: 'text/plain',
                    storageUri: 'file://a-copy.txt',
                    cloneToken: 'tok-1',
                  },
                },
              ],
            },
          ],
        },
        {
          method: 'clone',
          shape: 'signal',
          via: {
            local: 'yield:clone',
          },
          parameters: [],
          returns: null,
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
      ],
    },
    {
      namespace: 'beckon',
      docs: "Attention: driving the other participants' viewers, and this viewer's own signals.",
      methods: [
        {
          method: 'attention',
          shape: 'count',
          via: {
            emit: 'beckon:focus',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/BeckonFocusEvent.json#/properties/annotationId',
              },
              required: false,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
                resourceId: 'res-1',
              },
            },
            {
              why: 'no annotation: the focus is on the resource as a whole, and names none',
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'click',
          shape: 'count',
          via: {
            emit: 'browse:click',
          },
          parameters: [
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
              },
            },
          ],
        },
        {
          method: 'openResource',
          shape: 'count',
          via: {
            emit: 'browse:resource-open',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'sparkleAll',
          shape: 'count',
          via: {
            emit: 'beckon:sparkle',
          },
          parameters: [
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
              },
            },
          ],
        },
        {
          method: 'hover',
          shape: 'signal',
          via: {
            local: 'beckon:hover',
          },
          parameters: [
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/BeckonHoverEvent.json#/properties/annotationId',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
              },
            },
            {
              why: 'nothing is hovered: the field says so',
              args: {
                annotationId: null,
              },
              sends: {
                annotationId: null,
              },
            },
          ],
        },
        {
          method: 'sparkle',
          shape: 'signal',
          via: {
            local: 'beckon:sparkle',
          },
          parameters: [
            {
              parameter: 'annotationId',
              schema: {
                $ref: 'https://xynolog.org/protocol/AnnotationId.json',
              },
              required: true,
            },
          ],
          returns: null,
          cases: [
            {
              args: {
                annotationId: 'ann-1',
              },
              sends: {
                annotationId: 'ann-1',
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'job',
      docs: 'Jobs: their lifecycle as it is announced, their status, their cancellation, and, for a worker, the claiming of them.',
      methods: [
        {
          method: 'queued',
          shape: 'events',
          via: {
            observes: 'job:queued',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobQueuedEvent.json',
          },
          cases: [
            {
              why: 'a yield job is announced with what it is asked to make, and without its context',
              args: {},
              sends: {
                jobId: 'job-1',
                jobType: 'yield',
                resourceId: 'res-1',
                userId: 'did:web:example.org:users:alice',
                params: {
                  title: 'A summary',
                  storageUri: 'file://a-summary.md',
                },
              },
            },
            {
              why: 'a mark job is announced with its parameters, its motivation among them',
              args: {},
              sends: {
                jobId: 'job-2',
                jobType: 'mark',
                resourceId: 'res-1',
                userId: 'did:web:example.org:users:alice',
                params: {
                  motivation: 'tagging',
                  schemaId: 's1',
                  categories: ['claim'],
                },
              },
            },
          ],
        },
        {
          method: 'progress',
          shape: 'events',
          via: {
            observes: 'job:report-progress',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobReportProgressCommand.json',
          },
          cases: [
            {
              args: {},
              sends: {
                resourceId: 'res-1',
                jobId: 'job-1',
                jobType: 'yield',
                percentage: 12.5,
              },
            },
          ],
        },
        {
          method: 'complete',
          shape: 'events',
          via: {
            observes: 'job:complete',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobCompleteCommand.json',
          },
          cases: [
            {
              args: {},
              sends: {
                resourceId: 'res-1',
                jobId: 'job-1',
                jobType: 'yield',
              },
            },
          ],
        },
        {
          method: 'fail',
          shape: 'events',
          via: {
            observes: 'job:fail',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobFailCommand.json',
          },
          cases: [
            {
              args: {},
              sends: {
                resourceId: 'res-1',
                jobId: 'job-1',
                jobType: 'yield',
                error: 'the model refused',
              },
            },
          ],
        },
        {
          method: 'status',
          shape: 'promise',
          via: {
            request: 'job:status-requested',
          },
          parameters: [
            {
              parameter: 'jobId',
              schema: {
                $ref: 'https://xynolog.org/protocol/JobId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobStatusResponse.json',
          },
          cases: [
            {
              args: {
                jobId: 'job-1',
              },
              sends: {
                jobId: 'job-1',
              },
            },
          ],
        },
        {
          method: 'pollUntilComplete',
          shape: 'promise',
          via: {
            request: 'job:status-requested',
          },
          parameters: [
            {
              parameter: 'jobId',
              schema: {
                $ref: 'https://xynolog.org/protocol/JobId.json',
              },
              required: true,
            },
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/JobPollOptions.json',
              },
              required: false,
            },
            {
              parameter: 'onStatus',
              calls: {
                $ref: 'https://xynolog.org/protocol/JobStatusResponse.json',
              },
              required: false,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobStatusResponse.json',
          },
          cases: [
            {
              args: {
                jobId: 'job-1',
              },
              sends: {
                jobId: 'job-1',
              },
            },
          ],
        },
        {
          method: 'cancel',
          shape: 'promise',
          via: {
            request: 'job:cancel-requested',
          },
          parameters: [
            {
              parameter: 'jobId',
              schema: {
                $ref: 'https://xynolog.org/protocol/JobId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobCancelResult.json#/properties/cancelled',
          },
          cases: [
            {
              args: {
                jobId: 'job-1',
              },
              sends: {
                jobId: 'job-1',
              },
            },
          ],
        },
        {
          method: 'claim',
          shape: 'claims',
          via: {
            request: 'job:claim',
          },
          parameters: [
            {
              parameter: 'options',
              schema: {
                $ref: 'https://xynolog.org/protocol/ClaimOptions.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/JobRunning.json',
          },
          cases: [
            {
              why: 'a claim carries the filters of the jobs the worker takes, as it was given them',
              args: {
                options: {
                  accepts: [
                    {
                      jobType: 'mark',
                      params: {
                        motivation: 'tagging',
                      },
                    },
                    {
                      jobType: 'yield',
                    },
                  ],
                },
              },
              sends: {
                accepts: [
                  {
                    jobType: 'mark',
                    params: {
                      motivation: 'tagging',
                    },
                  },
                  {
                    jobType: 'yield',
                  },
                ],
              },
            },
          ],
        },
      ],
    },
    {
      namespace: 'auth',
      docs: "The gateway's view of who is signed in. Present when the client was given a gateway.",
      methods: [
        {
          method: 'me',
          shape: 'promise',
          via: {
            gateway: 'getCurrentUser',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/UserResponse.json',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'mediaToken',
          shape: 'promise',
          via: {
            gateway: 'getMediaToken',
          },
          parameters: [
            {
              parameter: 'resourceId',
              schema: {
                $ref: 'https://xynolog.org/protocol/ResourceId.json',
              },
              required: true,
            },
          ],
          returns: {
            $ref: 'https://xynolog.org/protocol/MediaTokenResponse.json',
          },
          cases: [
            {
              args: {
                resourceId: 'res-1',
              },
              sends: {
                resourceId: 'res-1',
              },
            },
          ],
        },
        {
          method: 'protectedResourceMetadata',
          shape: 'promise',
          via: {
            gateway: 'getProtectedResourceMetadata',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/ProtectedResourceMetadata.json',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
      ],
    },
    {
      namespace: 'system',
      docs: 'What the knowledge base says about itself. Present when the client was given a gateway.',
      methods: [
        {
          method: 'healthCheck',
          shape: 'promise',
          via: {
            gateway: 'healthCheck',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/HealthResponse.json',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
        {
          method: 'status',
          shape: 'promise',
          via: {
            gateway: 'getStatus',
          },
          parameters: [],
          returns: {
            $ref: 'https://xynolog.org/protocol/StatusResponse.json',
          },
          cases: [
            {
              args: {},
              sends: {},
            },
          ],
        },
      ],
    },
  ],
  worker: [
    {
      handed: 'claims',
      docs: "What `job.claim` returns: each job the worker comes to hold, one at a time, and what the worker can say of itself meanwhile. How the jobs are read is the language's: subscribed to in TypeScript, iterated in Python, asked for one at a time in Rust and Kotlin (`next`), ranged over in Go.",
      members: [
        {
          member: 'next',
          named: {
            go: {
              name: 'All',
              why: "The claims are ranged over, `for job, err := range claims.All()`, and Go's standard library names the method that gives a sequence of every element `All` (`maps.All`, `slices.All`).",
            },
          },
        },
        {
          member: 'refused',
        },
        {
          member: 'stalled',
        },
        {
          member: 'vitals',
        },
        {
          member: 'stop',
          named: {
            python: {
              name: 'aclose',
              why: 'Python closes an asynchronous iterator with `aclose`: it is what an asynchronous generator has, and what `contextlib.aclosing` calls.',
            },
            go: {
              name: 'Close',
              why: 'Go stops what is held with `Close`, the name `io.Closer` gives it and what a `defer` calls.',
            },
          },
        },
      ],
    },
    {
      handed: 'heldJob',
      docs: "A job a worker holds, from its claim until it settles it. A held job is its verb's, `mark` or `yield`. A member with `takes` is one a held job has as its verb's, and it takes what that verb's entry names; every other member is the same for both verbs, and a job held as either verb's has it without its verb being asked.",
      members: [
        {
          member: 'jobId',
        },
        {
          member: 'jobType',
        },
        {
          member: 'resourceId',
        },
        {
          member: 'params',
        },
        {
          member: 'completedUnits',
        },
        {
          member: 'unitCursors',
        },
        {
          member: 'retryCount',
        },
        {
          member: 'maxRetries',
        },
        {
          member: 'attempt',
        },
        {
          member: 'annotationId',
        },
        {
          member: 'trace',
        },
        {
          member: 'cancelled',
        },
        {
          member: 'settled',
        },
        {
          member: 'start',
        },
        {
          member: 'progress',
        },
        {
          member: 'checkpoint',
        },
        {
          member: 'commit',
        },
        {
          member: 'complete',
          takes: {
            mark: 'MarkJobResult',
            yield: 'YieldJobResult',
          },
        },
        {
          member: 'fail',
        },
        {
          member: 'cancel',
        },
      ],
    },
  ],
  stateUnits: [
    {
      unit: 'mark',
      docs: "The composing and delegating of annotations on one resource: the annotation being composed, the delegated job's motivation, its progress and what that progress is of, why the last job ended without completing, and the job's id. A request and a submission reach it as the signals the mark namespace publishes, which name its resource; a delegation, the cancelling of the annotation being composed and the dismissing of a job's progress are asked of the unit itself, so none reaches a unit of another resource.",
      made: {
        ocaml: 'Mark',
        csharp: 'MarkStateUnit',
        typescript: 'MarkStateUnit',
        rust: 'MarkStateUnit',
        python: 'MarkStateUnit',
        go: 'MarkStateUnit',
        kotlin: 'MarkStateUnit',
        swift: 'MarkStateUnit',
        haskell: 'MarkStateUnit',
      },
      madeBy: {
        typescript: 'createMarkStateUnit',
        go: 'NewMarkStateUnit',
        haskell: 'newMarkStateUnit',
      },
      members: [
        {
          member: 'pendingAnnotation',
        },
        {
          member: 'delegatingMotivation',
        },
        {
          member: 'progress',
        },
        {
          member: 'progressMotivation',
        },
        {
          member: 'failure',
        },
        {
          member: 'jobId',
        },
        {
          member: 'requestDelegate',
        },
        {
          member: 'cancelPending',
        },
        {
          member: 'dismissProgress',
        },
      ],
    },
    {
      unit: 'yield',
      docs: "A generation: whether a run is under way, its progress, what the finished run produced, why the last run ended without a result, and the job's id. It is moved by its own methods.",
      made: {
        ocaml: 'Yield',
        csharp: 'YieldStateUnit',
        typescript: 'YieldStateUnit',
        rust: 'YieldStateUnit',
        python: 'YieldStateUnit',
        go: 'YieldStateUnit',
        kotlin: 'YieldStateUnit',
        swift: 'YieldStateUnit',
        haskell: 'YieldStateUnit',
      },
      madeBy: {
        typescript: 'createYieldStateUnit',
        go: 'NewYieldStateUnit',
        haskell: 'newYieldStateUnit',
      },
      members: [
        {
          member: 'isGenerating',
        },
        {
          member: 'progress',
        },
        {
          member: 'outcome',
        },
        {
          member: 'failure',
        },
        {
          member: 'jobId',
        },
        {
          member: 'generate',
        },
        {
          member: 'dismissProgress',
        },
      ],
    },
    {
      unit: 'gather',
      docs: 'The context gathered around one resource: for the annotation last asked about and for the resource last asked about, the context, whether it is loading and why it failed. Each gather is asked of the unit itself, so none reaches a unit of another resource.',
      made: {
        ocaml: 'Gather',
        csharp: 'GatherStateUnit',
        typescript: 'GatherStateUnit',
        rust: 'GatherStateUnit',
        python: 'GatherStateUnit',
        go: 'GatherStateUnit',
        kotlin: 'GatherStateUnit',
        swift: 'GatherStateUnit',
        haskell: 'GatherStateUnit',
      },
      madeBy: {
        typescript: 'createGatherStateUnit',
        go: 'NewGatherStateUnit',
        haskell: 'newGatherStateUnit',
      },
      members: [
        {
          member: 'context',
        },
        {
          member: 'loading',
        },
        {
          member: 'error',
        },
        {
          member: 'annotationId',
        },
        {
          member: 'resourceContext',
        },
        {
          member: 'resourceLoading',
        },
        {
          member: 'resourceError',
        },
        {
          member: 'gatherAnnotation',
        },
        {
          member: 'gatherResource',
        },
      ],
    },
    {
      unit: 'match',
      docs: "Matching, run for whoever asks on the client's own bus: a search asked for by a signal is run and answered under the asker's correlation id. It holds no state: what it found is what it said.",
      made: {
        ocaml: 'Match',
        csharp: 'MatchStateUnit',
        typescript: 'MatchStateUnit',
        rust: 'MatchStateUnit',
        python: 'MatchStateUnit',
        go: 'MatchStateUnit',
        kotlin: 'MatchStateUnit',
        swift: 'MatchStateUnit',
        haskell: 'MatchStateUnit',
      },
      madeBy: {
        typescript: 'createMatchStateUnit',
        go: 'NewMatchStateUnit',
        haskell: 'newMatchStateUnit',
      },
      members: [],
    },
    {
      unit: 'beckon',
      docs: "Attention on one resource: the annotation this participant hovers, a sparkle for one the moment it is hovered, and a focus, naming the unit's resource, for one clicked here or by another participant.",
      made: {
        ocaml: 'Beckon',
        csharp: 'BeckonStateUnit',
        typescript: 'BeckonStateUnit',
        rust: 'BeckonStateUnit',
        python: 'BeckonStateUnit',
        go: 'BeckonStateUnit',
        kotlin: 'BeckonStateUnit',
        swift: 'BeckonStateUnit',
        haskell: 'BeckonStateUnit',
      },
      madeBy: {
        typescript: 'createBeckonStateUnit',
        go: 'NewBeckonStateUnit',
        haskell: 'newBeckonStateUnit',
      },
      members: [
        {
          member: 'hoveredAnnotationId',
        },
        {
          member: 'focus',
        },
      ],
    },
    {
      unit: 'hoverDwell',
      docs: "A pointer's rest: an annotation is said to be hovered once the pointer has rested on it for a delay, and none at once when it leaves.",
      made: {
        ocaml: 'Hover_dwell',
        csharp: 'HoverDwell',
        typescript: 'HoverDwell',
        rust: 'HoverDwell',
        python: 'HoverDwell',
        go: 'HoverDwell',
        kotlin: 'HoverDwell',
        swift: 'HoverDwell',
        haskell: 'HoverDwell',
      },
      madeBy: {
        typescript: 'createHoverDwell',
        go: 'NewHoverDwell',
        haskell: 'newHoverDwell',
      },
      members: [
        {
          member: 'enter',
        },
        {
          member: 'leave',
        },
      ],
    },
    {
      unit: 'search',
      docs: 'A search that follows a query as it is typed: the query as last set, and the results of the query it last settled on, once that query has stayed the same for a debounce.',
      made: {
        ocaml: 'Search',
        csharp: 'SearchPipeline',
        typescript: 'SearchPipeline',
        rust: 'SearchPipeline',
        python: 'SearchPipeline',
        go: 'SearchPipeline',
        kotlin: 'SearchPipeline',
        swift: 'SearchPipeline',
        haskell: 'SearchPipeline',
      },
      madeBy: {
        typescript: 'createSearchPipeline',
        go: 'NewSearchPipeline',
        haskell: 'newSearchPipeline',
      },
      members: [
        {
          member: 'query',
        },
        {
          member: 'state',
        },
        {
          member: 'setQuery',
        },
      ],
    },
    {
      unit: 'sessionSignals',
      docs: "What a host shows about a session, apart from the session: that it ended and why, that a request was refused for lack of permission, and that a different knowledge base answers at a registered address. Each is a notice while something is raised and none once it is acknowledged; raising it again is a new occurrence, told to every reader even when the notice equals the last. A host builds one beside each live session and wires the session's failures into it.",
      made: {
        ocaml: 'Session_signals',
        csharp: 'SessionSignals',
        typescript: 'SessionSignals',
        rust: 'SessionSignals',
        python: 'SessionSignals',
        go: 'SessionSignals',
        kotlin: 'SessionSignals',
        swift: 'SessionSignals',
        haskell: 'SessionSignals',
      },
      madeBy: {
        typescript: 'createSessionSignals',
        go: 'NewSessionSignals',
        haskell: 'newSessionSignals',
      },
      members: [
        {
          member: 'sessionEnded',
        },
        {
          member: 'permissionDenied',
        },
        {
          member: 'kbIdentityConflict',
        },
        {
          member: 'notifySessionEnded',
        },
        {
          member: 'notifyPermissionDenied',
        },
        {
          member: 'notifyKbIdentityConflict',
        },
        {
          member: 'acknowledgeSessionEnded',
        },
        {
          member: 'acknowledgePermissionDenied',
        },
        {
          member: 'acknowledgeKbIdentityConflict',
        },
      ],
    },
    {
      unit: 'cache',
      docs: "Values the knowledge base answers with, kept by key and held as state: each key's state (pending, ready with its value, or failed), fetched when first observed and again when invalidated, and set, removed or invalidated by its methods. What it does is held by the cache's own tables (specs/src/client/refresh.json and the cache's rules in each SDK), not by the behaviour table.",
      made: {
        ocaml: 'Cache',
        csharp: 'Cache',
        typescript: 'Cache',
        rust: 'Cache',
        python: 'Cache',
        go: 'Cache',
        kotlin: 'Cache',
        swift: 'Cache',
        haskell: 'Cache',
      },
      madeBy: {
        typescript: 'createCache',
        go: 'NewCache',
        haskell: 'newCache',
      },
      members: [
        {
          member: 'observe',
        },
        {
          member: 'fetch',
        },
        {
          member: 'get',
        },
        {
          member: 'known',
        },
        {
          member: 'keys',
        },
        {
          member: 'invalidate',
        },
        {
          member: 'invalidateAll',
        },
        {
          member: 'remove',
        },
        {
          member: 'set',
        },
        {
          member: 'patch',
        },
        {
          member: 'persistencePending',
        },
        {
          member: 'keptFetching',
        },
        {
          member: 'attach',
        },
        {
          member: 'query',
        },
      ],
    },
    {
      unit: 'session',
      docs: "A session with one knowledge base: the token its client's transport sends and who is signed in, the token renewed before it expires and when the gateway refuses it. It writes its token and who is signed in, so it ends them; it only uses its client, so it never ends it, and whoever made the client and the session ends both. Its `errors` are its one stream of what went wrong: its own errors (a SessionError: its sign-in could not be checked or renewed, the gateway refused a token just issued, what its client keeps could not be kept, its storage refused a write of it) and its transport's failures, each said once; a session takes no callback for them. They end when the session ends. Whoever ends both closes the client first, waiting for its closing flush, and then ends the session, so what that flush meets is said before the errors end; what the client meets once its session has ended is said nowhere. What it does is held by the session's own table (specs/src/session/cases.json), not by the behaviour table.",
      made: {
        ocaml: 'Session',
        csharp: 'XynologSession',
        typescript: 'XynologSession',
        rust: 'XynologSession',
        python: 'XynologSession',
        go: 'Session',
        kotlin: 'XynologSession',
        swift: 'XynologSession',
        haskell: 'Session',
      },
      madeBy: {
        go: 'StartSession',
        kotlin: 'sessionFromKept',
        swift: 'sessionFromKept',
        csharp: 'FromKeptAsync',
        haskell: 'newSession',
      },
      members: [
        {
          member: 'id',
        },
        {
          member: 'kb',
        },
        {
          member: 'client',
        },
        {
          member: 'token',
        },
        {
          member: 'user',
        },
        {
          member: 'streamState',
        },
        {
          member: 'errors',
        },
        {
          member: 'ready',
        },
        {
          member: 'expiresAt',
        },
        {
          member: 'refresh',
        },
        {
          member: 'renewer',
        },
      ],
    },
  ],
  wire: {
    docs: "The typed bus over a client's transport, which a client hands out as `wire`: what it emits goes over the wire, and what it reads is what the wire delivers. A read gives each frame with its envelope, who emitted it and the trace it was sent under. A channel of a resource's scope is read for one resource, and the read holds that resource's scope while it is read. The client's own in-process signals are on its own bus, never here. It hands out no transport: a client's transport is the client's `transport`, and only there.",
    made: {
      ocaml: 'Bus',
      haskell: 'Bus',
      csharp: 'Bus',
      swift: 'Bus',
      typescript: 'Bus',
      rust: 'Bus',
      python: 'Bus',
      go: 'Wire',
      kotlin: 'Bus',
    },
    members: [
      {
        member: 'emit',
      },
      {
        member: 'frames',
      },
      {
        member: 'framesOf',
      },
      {
        member: 'request',
      },
      {
        member: 'emitOn',
      },
      {
        member: 'framesOn',
      },
      {
        member: 'requestOf',
      },
    ],
  },
  storage: {
    docs: "Where a client keeps what must outlive it: text under a key, in a store the application supplies (a file, a browser's storage, a platform's store), so nothing above it knows where it runs. A client's sessions, its registry of knowledge bases and its kept caches keep what they keep there. More than one context can write one store, two windows or two processes: what is written from what was read goes through `update`, which a store makes one step, so one writer's change is never lost under another's; and `subscribe` hears what another context writes, and is null where no other context writes.",
    made: {
      ocaml: 'Storage',
      haskell: 'SessionStorage',
      csharp: 'ISessionStorage',
      typescript: 'SessionStorage',
      rust: 'SessionStorage',
      python: 'SessionStorage',
      go: 'SessionStorage',
      kotlin: 'SessionStorage',
      swift: 'SessionStorage',
    },
    members: [
      {
        member: 'get',
      },
      {
        member: 'set',
      },
      {
        member: 'delete',
      },
      {
        member: 'update',
      },
      {
        member: 'subscribe',
      },
    ],
  },
  modules: [
    {
      module: 'annotations',
      docs: "The readers of an annotation, its builders, and the reconciling of a quote: what a program that reads or makes annotations is given, so that none parses or builds one by hand. Held by specs/src/annotations's tables.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/annotations.mli'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Annotations.hs'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Annotations'],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/Annotations/Readers.swift',
          'sdk/swift/sdk/Sources/Xynolog/Annotations/Spans.swift',
          'sdk/swift/sdk/Sources/Xynolog/Annotations/Builders.swift',
        ],
        typescript: [
          'sdk/typescript/core/src/web-annotation-utils.ts',
          'sdk/typescript/core/src/annotation-builders.ts',
        ],
        rust: ['sdk/rust/sdk/src/annotations.rs'],
        python: ['sdk/python/sdk/src/xynolog/annotations.py'],
        go: ['sdk/go/annotations'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/annotations'],
      },
      whole: ['typescript', 'rust', 'python', 'go', 'kotlin'],
      members: [
        {
          member: 'bodySource',
          kind: 'reader',
        },
        {
          member: 'targetSource',
          kind: 'reader',
        },
        {
          member: 'targetSelector',
          kind: 'reader',
        },
        {
          member: 'commentText',
          kind: 'reader',
        },
        {
          member: 'textQuoteSelector',
          kind: 'reader',
        },
        {
          member: 'exactText',
          kind: 'reader',
        },
        {
          member: 'annotationExactText',
          kind: 'reader',
        },
        {
          member: 'entityTypes',
          kind: 'reader',
        },
        {
          member: 'tagCategory',
          kind: 'reader',
        },
        {
          member: 'tagSchemaId',
          kind: 'reader',
        },
        {
          member: 'isBodyResolved',
          kind: 'function',
        },
        {
          member: 'isHighlight',
          kind: 'function',
        },
        {
          member: 'isReference',
          kind: 'function',
        },
        {
          member: 'isAssessment',
          kind: 'function',
        },
        {
          member: 'isComment',
          kind: 'function',
        },
        {
          member: 'isTag',
          kind: 'function',
        },
        {
          member: 'isStubReference',
          kind: 'function',
        },
        {
          member: 'isResolvedReference',
          kind: 'function',
        },
        {
          member: 'textPositionSelector',
          kind: 'reader',
        },
        {
          member: 'svgSelector',
          kind: 'reader',
        },
        {
          member: 'fragmentSelector',
          kind: 'reader',
        },
        {
          member: 'reconcile',
          kind: 'function',
        },
        {
          member: 'annotationOfSpan',
          kind: 'function',
        },
        {
          member: 'annotationOfResource',
          kind: 'function',
        },
        {
          member: 'QuotedText',
          kind: 'type',
        },
        {
          member: 'TextSpan',
          kind: 'type',
        },
        {
          member: 'ReconciledSpan',
          kind: 'type',
        },
        {
          member: 'AnchorMethod',
          kind: 'type',
        },
        {
          member: 'MatchQuality',
          kind: 'type',
        },
        {
          member: 'SpanRefusedError',
          kind: 'type',
        },
        {
          member: 'SpanRefusal',
          kind: 'type',
          named: {
            haskell: 'SpanRefusalCode',
          },
        },
        {
          member: 'Spanned',
          kind: 'type',
        },
        {
          member: 'OfSpan',
          kind: 'type',
        },
        {
          member: 'OfResource',
          kind: 'type',
        },
      ],
    },
    {
      module: 'jobFilter',
      docs: "Whether a job matches a filter: asked by the dispatcher choosing a claim's next job, and by a worker checking an announcement against its claim. Held by specs/src/jobs/filter-cases.json.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/job_filter.mli'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Jobs'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Worker/Claims.swift'],
        typescript: ['sdk/typescript/core/src/job-filter.ts'],
        rust: ['sdk/rust/sdk/src/job_filter.rs'],
        python: ['sdk/python/sdk/src/xynolog/job_filter.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/jobs'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/JobFilter.hs'],
      },
      whole: ['rust', 'python', 'haskell'],
      members: [
        {
          member: 'jobMatchesFilter',
          kind: 'function',
        },
      ],
    },
    {
      module: 'claims',
      docs: "What a worker's stream names, and whether a failed job is run again: the channels claiming reads (the replies of `job:claim`, and the announcements and cancellations a worker hears), the channels committing reads (the replies of `mark:commit`, and of the question whether a batch is recorded), and whether a failed attempt is retried, which a held job reports on `job:fail`. Held by specs/src/jobs/retry-cases.json.",
      where: {
        csharp: ['sdk/csharp/sdk/src/Xynolog/Jobs'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Worker/Claims.swift'],
        typescript: ['sdk/typescript/sdk/src/claims.ts'],
        rust: ['sdk/rust/sdk/src/claims.rs'],
        python: ['sdk/python/sdk/src/xynolog/claims.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/jobs'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Claims.hs'],
        ocaml: ['sdk/ocaml/sdk/lib/claims.mli'],
      },
      whole: ['haskell'],
      members: [
        {
          member: 'jobClaimChannels',
          kind: 'constant',
        },
        {
          member: 'jobCommitChannels',
          kind: 'constant',
        },
        {
          member: 'willRetryAfter',
          kind: 'function',
        },
      ],
    },
    {
      module: 'retry',
      docs: 'Doing work again by a backoff, until it succeeds, it fails as nothing can mend, or the attempts run out.',
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/retry.mli'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Http'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Transport/Retry.swift'],
        typescript: ['sdk/typescript/core/src/retry.ts'],
        rust: ['sdk/rust/sdk/src/retry.rs'],
        python: ['sdk/python/sdk/src/xynolog/retry.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/retry'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Retry.hs'],
      },
      members: [
        {
          member: 'retryWithBackoff',
          kind: 'function',
        },
      ],
    },
    {
      module: 'hostName',
      docs: "Whether a host is one a knowledge base's HTTP endpoint may name. Held by specs/src/session/gateway-url-cases.json.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/host_name.mli'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Session'],
        typescript: ['sdk/typescript/sdk/src/session/storage.ts'],
        rust: ['sdk/rust/sdk/src/session/knowledge_base.rs'],
        python: ['sdk/python/sdk/src/xynolog/http/endpoint.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/http'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Session/Identity.swift'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/HostName.hs'],
      },
      whole: ['haskell'],
      members: [
        {
          member: 'isValidHostname',
          kind: 'function',
        },
      ],
    },
    {
      module: 'tokens',
      docs: 'What a session reads of an access token: a claim it names as text, when it expires, whether it has, and when to renew it. Held by specs/src/session/cases.json.',
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/tokens.mli'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Tokens.hs'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Session'],
        typescript: ['sdk/typescript/sdk/src/session/storage.ts'],
        rust: [
          'sdk/rust/sdk/src/session/mod.rs',
          'sdk/rust/sdk/src/session/stored.rs',
        ],
        python: ['sdk/python/sdk/src/xynolog/session.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/session'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Session/Tokens.swift'],
      },
      members: [
        {
          member: 'textClaim',
          kind: 'function',
        },
        {
          member: 'tokenExpiry',
          kind: 'function',
          named: {
            typescript: 'parseJwtExpiry',
          },
        },
        {
          member: 'isTokenExpired',
          kind: 'function',
          named: {
            typescript: 'isJwtExpired',
          },
        },
        {
          member: 'renewalDelay',
          kind: 'function',
        },
        {
          member: 'refreshDelay',
          kind: 'function',
          named: {
            typescript: 'refreshDelayMs',
          },
        },
      ],
    },
    {
      module: 'storagePersister',
      docs: "Where a client keeps its queries' values: a session storage, one key for each query it keeps for the person signed in, each kept within a size.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/storage_persister.mli'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/StoragePersister.hs'],
        csharp: ['sdk/csharp/sdk/src/Xynolog'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/CachePersistence.swift'],
        typescript: ['sdk/typescript/sdk/src/cache-persister.ts'],
        rust: ['sdk/rust/sdk/src/cache.rs'],
        python: ['sdk/python/sdk/src/xynolog/storage.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/storage'],
      },
      members: [
        {
          member: 'StoragePersister',
          kind: 'type',
          named: {
            typescript: 'sessionStoragePersister',
            csharp: 'CachePersistence',
          },
        },
      ],
    },
    {
      module: 'bus',
      docs: "What the bus's registry gives a program beside its channels: the reply channels of given operations, the refusal of a request whose replies cannot arrive, and the channels whose events the record keeps; and what a transport delivers in place of a frame it refuses, and why it refuses it.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/bus.ml'],
        csharp: ['sdk/csharp/sdk/src/Xynolog'],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/Bus/Bus.swift',
          'sdk/swift/sdk/Sources/Xynolog/Bus/Typed.swift',
        ],
        typescript: [
          'sdk/typescript/core/src/bus.ts',
          'sdk/typescript/core/src/bus-request.ts',
          'sdk/typescript/core/src/persisted-events.ts',
        ],
        rust: ['sdk/rust/sdk/src/bus.rs', 'sdk/rust/sdk/src/transport.rs'],
        python: [
          'sdk/python/sdk/src/xynolog/bus.py',
          'sdk/python/sdk/src/xynolog/transport.py',
          'sdk/python/sdk/src/xynolog/channels.py',
        ],
        go: ['sdk/go', 'sdk/go/bus'],
        kotlin: [
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/bus',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/transport',
        ],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Bus.hs'],
      },
      members: [
        {
          member: 'replyChannelsFor',
          kind: 'function',
        },
        {
          member: 'unsubscribed',
          kind: 'function',
        },
        {
          member: 'persistedEventTypes',
          kind: 'constant',
        },
        {
          member: 'FrameRefusal',
          kind: 'type',
        },
        {
          member: 'FrameRefusalReason',
          kind: 'type',
        },
        {
          member: 'Carried',
          kind: 'type',
        },
      ],
    },
    {
      module: 'registry',
      docs: "What an application holds beside its knowledge bases: the list it has registered, which one is active and its session, what a person has open in each, and what it keeps in its storage, under which keys. Sessions are built by a factory it is given; one over HTTP reaches a knowledge base at its gateway. A person's sign-in by a page redirect lands on the entry for the knowledge base that answered. The registry is the one reader of each session's errors, from the first thing the session said: each of the session's own it says on its own errors; a refusal for lack of permission is said through the session's signals; a refusal for want of a valid token, and a failure of its transport for any other reason, it does nothing with. It renews no session: the transport that met such a refusal renews the token it sent (contract/TRANSPORT-CONTRACT.md § A refused credential). A factory reads none of them, so a session built by a factory a host writes is read the same way.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/registry.mli'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Registry'],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/Registry/OpenResources.swift',
          'sdk/swift/sdk/Sources/Xynolog/Registry/XynologBrowser.swift',
          'sdk/swift/sdk/Sources/Xynolog/Registry/SessionFactory.swift',
          'sdk/swift/sdk/Sources/Xynolog/Registry/Stored.swift',
          'sdk/swift/sdk/Sources/Xynolog/Generated/Models.swift',
        ],
        typescript: [
          'sdk/typescript/sdk/src/session/xynolog-browser.ts',
          'sdk/typescript/sdk/src/session/session-factory.ts',
          'sdk/typescript/sdk/src/session/http-session-factory.ts',
          'sdk/typescript/sdk/src/session/knowledge-base.ts',
          'sdk/typescript/sdk/src/session/open-resource.ts',
          'sdk/typescript/sdk/src/session/storage.ts',
        ],
        rust: [
          'sdk/rust/sdk/src/session/browser.rs',
          'sdk/rust/sdk/src/session/factory.rs',
          'sdk/rust/sdk/src/session/knowledge_base.rs',
          'sdk/rust/sdk/src/session/open_resource.rs',
          'sdk/rust/sdk/src/session/stored.rs',
          'sdk/rust/http-transport/src/session.rs',
        ],
        python: [
          'sdk/python/sdk/src/xynolog/stored.py',
          'sdk/python/sdk/src/xynolog/registry.py',
          'sdk/python/sdk/src/xynolog/http/session.py',
        ],
        go: ['sdk/go/registry'],
        kotlin: [
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/registry',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/http',
        ],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Registry.hs'],
      },
      whole: ['go'],
      members: [
        {
          member: 'XynologBrowser',
          kind: 'type',
        },
        {
          member: 'newXynologBrowser',
          kind: 'function',
        },
        {
          member: 'XynologBrowserConfig',
          kind: 'type',
        },
        {
          member: 'SignedIn',
          kind: 'type',
          fieldsNamed: {
            go: {
              kbId: 'KbID',
            },
          },
        },
        {
          member: 'Expected',
          kind: 'type',
        },
        {
          member: 'SignInOutcome',
          kind: 'type',
        },
        {
          member: 'KbReadVerdict',
          kind: 'type',
        },
        {
          member: 'KbReadKind',
          kind: 'type',
        },
        {
          member: 'SessionFactory',
          kind: 'type',
        },
        {
          member: 'SessionFactoryOptions',
          kind: 'type',
          fields: ['kb', 'storage', 'signals'],
        },
        {
          member: 'HttpSessionFactory',
          kind: 'type',
          named: {
            typescript: 'createHttpSessionFactory',
            haskell: 'newHttpSessionFactory',
          },
        },
        {
          member: 'KbSessionStatus',
          kind: 'type',
        },
        {
          member: 'OpenResource',
          kind: 'type',
        },
        {
          member: 'TabCheck',
          kind: 'type',
        },
        {
          member: 'TabVerdict',
          kind: 'type',
        },
        {
          member: 'applyTabChecks',
          kind: 'function',
        },
        {
          member: 'sortOpenResources',
          kind: 'function',
        },
        {
          member: 'StoredSession',
          kind: 'type',
        },
        {
          member: 'knowledgeBasesKey',
          kind: 'constant',
          named: {
            typescript: 'STORAGE_KEY',
          },
        },
        {
          member: 'activeKey',
          kind: 'constant',
        },
        {
          member: 'openResourcesByKbKey',
          kind: 'constant',
        },
        {
          member: 'lastViewedResourceByKbKey',
          kind: 'constant',
        },
        {
          member: 'sessionKey',
          kind: 'function',
        },
        {
          member: 'kbOfSessionKey',
          kind: 'function',
        },
        {
          member: 'storedSession',
          kind: 'function',
          named: {
            typescript: 'getStoredSession',
            go: 'StoredSessionOf',
          },
        },
        {
          member: 'storeSession',
          kind: 'function',
          named: {
            typescript: 'setStoredSession',
          },
        },
        {
          member: 'clearStoredSession',
          kind: 'function',
        },
        {
          member: 'loadKnowledgeBases',
          kind: 'function',
        },
        {
          member: 'saveKnowledgeBases',
          kind: 'function',
        },
        {
          member: 'keptIn',
          kind: 'function',
        },
        {
          member: 'beginSignIn',
          kind: 'function',
        },
        {
          member: 'completeSignIn',
          kind: 'function',
        },
      ],
    },
    {
      module: 'sessionNotices',
      docs: "What a session's signals raise: that a session ended and why, that a request was refused for lack of permission, and that a different knowledge base answers at a registered address. specs/src/client/state-units.json's `notices` states each one.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/session_notices.ml'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/State/SessionSignals.hs'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/State'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/State/SessionSignals.swift'],
        typescript: ['sdk/typescript/sdk/src/session/session-signals.ts'],
        rust: ['sdk/rust/sdk/src/session/signals.rs'],
        python: ['sdk/python/sdk/src/xynolog/session_signals.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/session'],
      },
      members: [
        {
          member: 'SessionEnded',
          kind: 'type',
        },
        {
          member: 'PermissionDenied',
          kind: 'type',
        },
        {
          member: 'KbIdentityConflict',
          kind: 'type',
        },
      ],
    },
    {
      module: 'redirectSignIn',
      docs: "A person's sign-in by a page redirect: the authorization-code grant with PKCE, its pending record kept across the trip to the issuer and back, and the question a completed sign-in asks the knowledge base, who it is.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/redirect_sign_in.ml'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Authorization'],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/Registry/RedirectSignIn.swift',
          'sdk/swift/sdk/Sources/Xynolog/Registry/Stored.swift',
        ],
        typescript: [
          'sdk/typescript/sdk/src/session/oauth.ts',
          'sdk/typescript/sdk/src/session/connect.ts',
        ],
        rust: [
          'sdk/rust/http-transport/src/oauth.rs',
          'sdk/rust/http-transport/src/session.rs',
          'sdk/rust/sdk/src/errors.rs',
        ],
        python: [
          'sdk/python/sdk/src/xynolog/stored.py',
          'sdk/python/sdk/src/xynolog/http/oauth.py',
          'sdk/python/sdk/src/xynolog/http/session.py',
          'sdk/python/sdk/src/xynolog/errors.py',
        ],
        go: ['sdk/go'],
        kotlin: [
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/registry',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/http',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/errors',
        ],
        haskell: [
          'sdk/haskell/sdk/src/Xynolog/Issuer.hs',
          'sdk/haskell/sdk/src/Xynolog/Registry/Identity.hs',
          'sdk/haskell/sdk/src/Xynolog/Registry/Stored.hs',
        ],
      },
      members: [
        {
          member: 'codeChallenge',
          kind: 'function',
        },
        {
          member: 'PendingAuthorization',
          kind: 'type',
        },
        {
          member: 'pendingAuthorizationKey',
          kind: 'constant',
        },
        {
          member: 'BeginAuthorizationOptions',
          kind: 'type',
          named: {
            rust: 'BeginAuthorization',
          },
        },
        {
          member: 'beginAuthorization',
          kind: 'function',
        },
        {
          member: 'completeAuthorization',
          kind: 'function',
        },
        {
          member: 'describeConnection',
          kind: 'function',
        },
        {
          member: 'ConnectionIdentity',
          kind: 'type',
        },
        {
          member: 'IdentityUnverifiableError',
          kind: 'type',
          named: {
            rust: 'IdentityUnverifiable',
          },
        },
      ],
    },
    {
      module: 'serviceToken',
      docs: "A service account's token, which a process holds for its own account at the issuer a knowledge base trusts: the issuer's token endpoint discovered once, through the HTTP client the token was made with, one client-credentials grant at a time, the token held until it is due for renewal, and the `Authorization` header's value it gives (`authorization`).",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/service_token.mli'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/ServiceToken.hs'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/SignIn/ServiceToken.swift'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/SignIn'],
        typescript: ['sdk/typescript/core/src/service-account.ts'],
        rust: ['sdk/rust/http-transport/src/service_account.rs'],
        python: ['sdk/python/sdk/src/xynolog/http/agent.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/http'],
      },
      members: [
        {
          member: 'ServiceToken',
          kind: 'type',
        },
      ],
    },
    {
      module: 'signInStore',
      docs: "The sign-ins `xynolog login` keeps, as specs/src/sign-in-store states them: the store, whose every change holds the lock every writer takes, and where the launcher's state home is on each system. Held by sign-in-store/cases.json.",
      where: {
        csharp: ['sdk/csharp/sdk/src/Xynolog/SignIn'],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/SignIn/SignInStore.swift',
          'sdk/swift/sdk/Sources/Xynolog/SignIn/Kept.swift',
        ],
        typescript: ['sdk/typescript/sdk/src/session/sign-in-store.ts'],
        rust: ['sdk/rust/sdk/src/sign_in_store.rs'],
        python: ['sdk/python/sdk/src/xynolog/sign_in_store.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/signin'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/SignInStore.hs'],
        ocaml: ['sdk/ocaml/sdk/lib/sign_in_store.mli'],
      },
      members: [
        {
          member: 'SignInStore',
          kind: 'type',
          named: {
            ocaml: 't',
          },
        },
        {
          member: 'stateDir',
          kind: 'function',
          named: {
            haskell: 'stateDirectory',
            ocaml: 'state_directory',
          },
        },
        {
          member: 'System',
          kind: 'type',
          named: {
            kotlin: 'Platform',
            swift: 'Platform',
            ocaml: 'platform',
          },
        },
        {
          member: 'thisSystem',
          kind: 'function',
          named: {
            kotlin: 'thisPlatform',
          },
        },
        {
          member: 'fileName',
          kind: 'constant',
          named: {
            go: 'SignInFile',
            haskell: 'signInFileName',
          },
        },
        {
          member: 'SignInFiles',
          kind: 'type',
        },
      ],
    },
    {
      module: 'keptSignIn',
      docs: "A sign-in a session holds and renews wherever it is kept (a registry's storage, through the registry's keptIn; the sign-ins `xynolog login` keeps; memory; a host's own), and what a script does with one: signs a person in to it by the device grant, opens a session over it, renews it at the issuer, and signs out of it. A session opened over one asks the gateway who its token is unless it is told not to (`validate`, true when it is left out). Its client keeps for the person the kept sign-in names from the start, whether or not it asks (specs/src/session/persisted-cases.json, `startup`); asking is how it learns the person when the sign-in names nobody yet, and a session that does not ask then keeps for nobody. docs/builder/SIGN-IN.md says which to use when.",
      where: {
        typescript: [
          'sdk/typescript/sdk/src/session/sign-in-kept.ts',
          'sdk/typescript/sdk/src/session/oauth.ts',
        ],
        rust: [
          'sdk/rust/sdk/src/session/kept.rs',
          'sdk/rust/http-transport/src/session.rs',
          'sdk/rust/http-transport/src/oauth.rs',
        ],
        python: [
          'sdk/python/sdk/src/xynolog/session.py',
          'sdk/python/sdk/src/xynolog/http/session.py',
          'sdk/python/sdk/src/xynolog/http/oauth.py',
        ],
        go: ['sdk/go'],
        kotlin: [
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/signin',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/http',
        ],
        swift: [
          'sdk/swift/sdk/Sources/Xynolog/SignIn/Kept.swift',
          'sdk/swift/sdk/Sources/Xynolog/SignIn/Issuer.swift',
          'sdk/swift/sdk/Sources/Xynolog/Session/SessionFromKept.swift',
        ],
        csharp: ['sdk/csharp/sdk/src/Xynolog/SignIn'],
        haskell: [
          'sdk/haskell/sdk/src/Xynolog/SignIn.hs',
          'sdk/haskell/sdk/src/Xynolog/Session.hs',
        ],
      },
      members: [
        {
          member: 'SignInKept',
          kind: 'type',
          named: {
            csharp: 'ISignInKept',
            haskell: 'KeptSignIn',
          },
        },
        {
          member: 'MemorySignIn',
          kind: 'type',
        },
        {
          member: 'signInDevice',
          kind: 'function',
          named: {
            go: 'SignInWithDevice',
          },
        },
        {
          member: 'sessionFromKept',
          kind: 'function',
          named: {
            haskell: 'fromKeptSession',
          },
        },
        {
          member: 'renewKept',
          kind: 'function',
        },
        {
          member: 'signOut',
          kind: 'function',
        },
      ],
    },
    {
      module: 'discovery',
      docs: 'The knowledge bases a launcher manages, as it publishes them: its document read whole or not at all, absent told from empty, entries told apart by address, and what changed since it was last read.',
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/discovery.mli'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Discovery'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Registry/Discovery.swift'],
        typescript: ['sdk/typescript/sdk/src/discovery.ts'],
        rust: [
          'sdk/rust/sdk/src/discovery.rs',
          'sdk/rust/http-transport/src/discovery.rs',
        ],
        python: [
          'sdk/python/sdk/src/xynolog/discovery.py',
          'sdk/python/sdk/src/xynolog/http/discovery.py',
        ],
        go: ['sdk/go/discovery'],
        kotlin: [
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/discovery',
          'sdk/kotlin/sdk/src/main/kotlin/xynolog/http',
        ],
        haskell: [
          'sdk/haskell/sdk/src/Xynolog/Discovery.hs',
          'sdk/haskell/sdk/src/Xynolog/Http/Discovery.hs',
        ],
      },
      whole: ['go', 'python'],
      members: [
        {
          member: 'discoveryInterval',
          kind: 'constant',
        },
        {
          member: 'DiscoveryAbsentReason',
          kind: 'type',
          named: {
            haskell: 'DiscoveryAbsentCode',
          },
        },
        {
          member: 'DiscoveryRead',
          kind: 'type',
          named: {
            typescript: 'DiscoveryReadResult',
          },
        },
        {
          member: 'DiscoveryState',
          kind: 'type',
        },
        {
          member: 'Absent',
          kind: 'type',
        },
        {
          member: 'Managed',
          kind: 'type',
        },
        {
          member: 'Unchanged',
          kind: 'type',
        },
        {
          member: 'DiscoveryTransport',
          kind: 'type',
        },
        {
          member: 'parseDiscoveryDocument',
          kind: 'function',
        },
        {
          member: 'textDiscovery',
          kind: 'function',
        },
        {
          member: 'httpDiscovery',
          kind: 'function',
        },
        {
          member: 'DiscoveryDiff',
          kind: 'type',
        },
        {
          member: 'subscribeDiscovery',
          kind: 'function',
        },
      ],
    },
    {
      module: 'testing',
      docs: "What a consumer's tests hold a composition and a registry to: the liveness axioms, that under any behaviour of the wire something is eventually said and every event is delivered exactly once; a real session over test doubles; a factory of scripted sessions for a registry; and a storage several contexts share.",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/testing.mli'],
        swift: [
          'sdk/swift/sdk/Sources/XynologTesting/Liveness.swift',
          'sdk/swift/sdk/Sources/XynologTesting/ScriptedTransport.swift',
          'sdk/swift/sdk/Sources/XynologTesting/Sessions.swift',
          'sdk/swift/sdk/Sources/XynologTesting/SharedStorage.swift',
          'sdk/swift/sdk/Sources/XynologTesting/TestClock.swift',
        ],
        typescript: [
          'sdk/typescript/core/src/liveness-axioms.ts',
          'sdk/typescript/sdk/src/testing.ts',
        ],
        rust: [
          'sdk/rust/sdk/src/testing/liveness.rs',
          'sdk/rust/sdk/src/testing/client.rs',
          'sdk/rust/sdk/src/testing/sessions.rs',
          'sdk/rust/sdk/src/testing/storage.rs',
        ],
        python: [
          'sdk/python/sdk/src/xynolog/testing/__init__.py',
          'sdk/python/sdk/src/xynolog/testing/liveness.py',
        ],
        go: ['sdk/go/xynologtest'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/testing'],
        csharp: ['sdk/csharp/sdk/src/Xynolog/Testing'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Testing.hs'],
      },
      members: [
        {
          member: 'LivenessScenario',
          kind: 'type',
        },
        {
          member: 'LivenessSpec',
          kind: 'type',
          named: {
            typescript: 'LivenessAxiomSpec',
          },
        },
        {
          member: 'Respond',
          kind: 'type',
          named: {
            go: 'MakeResponse',
            python: 'MakeResponse',
          },
        },
        {
          member: 'faultActions',
          kind: 'function',
          named: {
            typescript: 'arbFaultAction',
          },
        },
        {
          member: 'faultSchedules',
          kind: 'function',
          named: {
            typescript: 'arbFaultSchedule',
          },
        },
        {
          member: 'assertLivenessAxioms',
          kind: 'function',
        },
        {
          member: 'DeliverySubject',
          kind: 'type',
        },
        {
          member: 'DeliveryOp',
          kind: 'type',
        },
        {
          member: 'deliveryOps',
          kind: 'function',
          named: {
            typescript: 'arbDeliveryOps',
          },
        },
        {
          member: 'assertExactlyOnceDelivery',
          kind: 'function',
        },
        {
          member: 'createTestSession',
          kind: 'function',
          named: {
            go: 'NewTestSession',
          },
        },
        {
          member: 'TestSession',
          kind: 'type',
        },
        {
          member: 'TestSessionOptions',
          kind: 'type',
          named: {
            go: 'TestSessionConfig',
          },
        },
        {
          member: 'ScriptedSessions',
          kind: 'type',
        },
        {
          member: 'Renewal',
          kind: 'type',
        },
        {
          member: 'SharedStorage',
          kind: 'type',
        },
      ],
    },
    {
      module: 'refusals',
      docs: "The first fault a body has as a component schema, and what every SDK says of it as it refuses it (`it has no `x``, `its `x` is malformed`, `it is malformed`): for an SDK whose HTTP transport is a package of its own, which reads its answers and holds its stream's frames by them. Held by the table of what each schema requires (the consumer-owned generator).",
      where: {
        ocaml: ['sdk/ocaml/sdk/lib/refusals.ml'],
        typescript: ['sdk/typescript/core/src/required.ts'],
        rust: ['sdk/rust/sdk/src/required.rs'],
        python: ['sdk/python/sdk/src/xynolog/bus.py'],
        go: ['sdk/go'],
        kotlin: ['sdk/kotlin/sdk/src/main/kotlin/xynolog/bus'],
        swift: ['sdk/swift/sdk/Sources/Xynolog/Bus/Bus.swift'],
        csharp: ['sdk/csharp/sdk/src/Xynolog'],
        haskell: ['sdk/haskell/sdk/src/Xynolog/Bus.hs'],
      },
      members: [
        {
          member: 'faultSaid',
          kind: 'function',
        },
        {
          member: 'faultOf',
          kind: 'function',
        },
        {
          member: 'said',
          kind: 'function',
        },
        {
          member: 'Fault',
          kind: 'type',
        },
      ],
    },
  ],
  clock: [
    {
      source: 'clock',
      docs: "What every wait an SDK makes, and every interval it measures, keeps the time of: a clock its caller controls, so a caller who moves it sees each wait end when specs/src/client/clock-cases.json says. Where the runtime owns time, the caller moves the runtime's clock from outside the SDK, which takes none (`outside`). Where the ecosystem's waits take a clock, every public maker of something that waits takes one, its system clock when none is given, unless it is handed something that already carries one, whose clock it keeps; and what it makes keeps its clock (`takes`). A reading of the wall clock, which compares now with an instant a server stated or stamps a record, is no part of it.",
      typeWords: [
        'Clock',
        'TimeSource',
        'TimeProvider',
        'Scheduler',
        'EventLoop',
      ],
      outside: {
        typescript:
          "A test runner's fake timers, which fake every timer global and Date: every wait the SDK makes is a timer global.",
        rust: "Tokio's paused clock: every wait and interval is tokio::time's, reqwest's request deadline among them.",
        python:
          "The running asyncio loop's clock: every wait is the running loop's, and every request deadline is the SDK's own asyncio timeout.",
        go: "testing/synctest: every wait is package time's, on goroutines the caller's call starts.",
      },
      takes: {
        ocaml: {
          'Clock.make': ['Eio.Time.Mono.t', 'Eio.Time.clock'],
          'Subscription.start': ['Clock.t'],
          'Session.start': ['Clock.t'],
          'Http_wire.make': ['Clock.t'],
          'Live_query.make': ['Clock.t'],
        },
        kotlin: {
          XynologClient: ['CoroutineContext', 'TimeSource'],
          TestClient: ['CoroutineContext', 'TimeSource'],
          HttpTransport: ['CoroutineContext', 'TimeSource'],
          Bus: ['CoroutineContext', 'TimeSource'],
          request: ['TimeSource'],
          HoverDwell: ['CoroutineContext'],
          SearchPipeline: ['CoroutineContext'],
          Cache: ['CoroutineContext'],
          httpDiscovery: ['CoroutineContext'],
          FaultyTransport: ['CoroutineContext'],
          ServiceToken: ['CoroutineContext', 'TimeSource'],
          AgentToken: ['CoroutineContext'],
          signInDevice: ['TimeSource'],
          describeConnection: ['TimeSource'],
          TestSessionOptions: ['CoroutineContext', 'TimeSource'],
          LivenessSpec: ['CoroutineContext'],
          sessionFromKept: ['CoroutineContext', 'TimeSource'],
          HttpSessionFactory: ['CoroutineContext', 'TimeSource'],
          XynologBrowserConfig: ['CoroutineContext', 'TimeSource'],
          ScriptedSessions: ['CoroutineContext', 'TimeSource'],
          requestFuture: ['CoroutineContext', 'TimeSource'],
          retryWithBackoffFuture: ['CoroutineContext'],
          renewKeptFuture: ['CoroutineContext'],
          signInDeviceFuture: ['CoroutineContext', 'TimeSource'],
          signOutFuture: ['CoroutineContext'],
          beginAuthorizationFuture: ['CoroutineContext'],
          completeAuthorizationFuture: ['CoroutineContext'],
          describeConnectionFuture: ['CoroutineContext', 'TimeSource'],
          sessionFromKeptFuture: ['CoroutineContext', 'TimeSource'],
          createTestSessionFuture: ['CoroutineContext'],
        },
        swift: {
          XynologClient: ['Clock'],
          HttpTransport: ['Clock'],
          Bus: ['Clock'],
          Cache: ['Clock'],
          HoverDwell: ['Clock'],
          SearchPipeline: ['Clock'],
          subscribeDiscovery: ['Clock'],
          httpDiscovery: ['Clock'],
          retryWithBackoff: ['Clock'],
          signInDevice: ['Clock'],
          renewKept: ['Clock'],
          ServiceToken: ['Clock'],
          AgentToken: ['Clock'],
          StoragePersister: ['Clock'],
          sessionFromKept: ['Clock'],
          HttpSessionFactory: ['Clock'],
          XynologBrowserConfig: ['Clock'],
          'XynologClient.fromHttp': ['Clock'],
          signOut: ['Clock'],
          whoAmI: ['Clock'],
          beginAuthorization: ['Clock'],
          completeAuthorization: ['Clock'],
          describeConnection: ['Clock'],
          ScriptedTransport: ['Clock'],
          ScriptedSessions: ['Clock'],
          TestSessionOptions: ['Clock'],
          LivenessSpec: ['Clock'],
        },
        csharp: {
          XynologClient: ['TimeProvider'],
          HttpTransport: ['TimeProvider'],
          Issuer: ['TimeProvider'],
          ServiceToken: ['TimeProvider'],
          AgentToken: ['TimeProvider'],
          FromKeptAsync: ['TimeProvider'],
          SignInStore: ['TimeProvider'],
          Cache: ['TimeProvider'],
          HoverDwell: ['TimeProvider'],
          SearchPipeline: ['TimeProvider'],
          HttpDiscovery: ['TimeProvider'],
          SubscribeDiscovery: ['TimeProvider'],
          GetCurrentUserAsync: ['TimeProvider'],
          HttpSessionFactory: ['TimeProvider'],
          XynologBrowserConfig: ['TimeProvider'],
          FaultyTransport: ['TimeProvider'],
          TestSessionOptions: ['TimeProvider'],
          ScriptedSessions: ['TimeProvider'],
          BeginAuthorizationAsync: ['TimeProvider'],
          CompleteAuthorizationAsync: ['TimeProvider'],
          DescribeConnectionAsync: ['TimeProvider'],
          LivenessSpec: ['TimeProvider'],
          RetryWithBackoffAsync: ['TimeProvider'],
        },
        haskell: {
          newClient: ['BusOptions'],
          fromHttp: ['HttpOptions'],
          newHttpTransport: ['HttpOptions'],
          HttpOptions: ['RetryOptions'],
          newCache: ['CacheOptions'],
          newClaims: ['WorkerOptions'],
          WorkerOptions: ['BusOptions'],
          newBus: ['BusOptions'],
          newJob: ['BusOptions'],
          subscribeDiscovery: ['DiscoveryOptions'],
          retryWithBackoff: ['RetryOptions'],
          newSession: ['RetryOptions'],
          fromIssuedSession: ['HttpOptions'],
          signInDevice: ['HttpOptions'],
          IssuerOptions: ['RetryOptions'],
          newServiceTokenSecret: ['IssuerOptions'],
          newServiceTokenKey: ['IssuerOptions'],
          signInAgent: ['HttpOptions'],
          fromKeptSession: ['HttpOptions'],
          pollUntilComplete: ['JobNamespace'],
          httpDiscovery: ['RetryOptions'],
          newSignInStore: ['SignInStoreOptions'],
          SignInStoreOptions: ['RetryOptions'],
          newHttpSessionFactory: ['HttpOptions'],
          XynologBrowserConfig: ['HttpOptions'],
          describeConnection: ['HttpOptions'],
          newHoverDwell: ['RetryOptions'],
          newSearchPipeline: ['RetryOptions'],
          newMarkStateUnit: ['RetryOptions'],
          newFaultyTransport: ['RetryOptions'],
          newScriptedSessions: ['RetryOptions'],
          createTestSession: ['TestSessionOptions'],
          TestSessionOptions: ['RetryOptions'],
          assertLivenessAxioms: ['LivenessSpec'],
          LivenessSpec: ['RetryOptions'],
        },
      },
    },
    {
      source: 'random',
      docs: "What every jitter an SDK draws draws from: a random source its caller controls, so a caller can make each draw the lowest the source gives, as specs/src/client/clock-cases.json does. Where every draw can already be reached from outside the SDK, the caller reaches it there, and the SDK takes none (`outside`). Elsewhere every public maker of something that backs off, and every public function that draws a jitter, takes one, the system's source when none is given, unless it is handed something that already carries one, whose source it keeps; and what it makes keeps its source (`takes`). The randomness of a secret, a PKCE verifier, a nonce or a client assertion's `jti`, stays the platform's cryptographic source, and is no part of it.",
      typeWords: ['Random', 'Rng'],
      outside: {
        typescript:
          'Math.random, which a test replaces: every jitter draws from it.',
        python:
          'The random module, which a test seeds or patches: every jitter draws random.random().',
      },
      takes: {
        ocaml: {
          'Clock.make': ['Random.State.t'],
          'Subscription.start': ['Clock.t'],
          'Session.start': ['Clock.t'],
          'Http_wire.make': ['Clock.t'],
          'Live_query.make': ['Clock.t'],
        },
        rust: {
          HttpTransportConfig: ['Rng'],
          XynologSessionConfig: ['Rng'],
          retry_with_backoff: ['Rng'],
          SessionFromKept: ['Rng'],
          'AgentToken::sign_in': ['Rng'],
          equal_jitter: ['Rng'],
          HttpSession: ['Rng'],
          'HttpSessionFactory::new': ['Rng'],
          describe_connection: ['Rng'],
          complete_sign_in: ['Rng'],
          'ScriptedSessions::new': ['Rng'],
          'ScriptedSessions::answering': ['Rng'],
        },
        go: {
          HTTPTransportConfig: ['rand.Rand'],
          SessionConfig: ['rand.Rand'],
          ResumeConfig: ['rand.Rand'],
          SessionFromKeptConfig: ['rand.Rand'],
          Issuer: ['rand.Rand'],
          AgentConfig: ['rand.Rand'],
          HttpSessionFactory: ['rand.Rand'],
          CompleteSignIn: ['rand.Rand'],
          DescribeConnection: ['rand.Rand'],
          NewScriptedSessions: ['rand.Rand'],
          RetryWithBackoff: ['rand.Rand'],
          EqualJitter: ['rand.Rand'],
        },
        kotlin: {
          HttpTransport: ['Random'],
          AgentToken: ['Random'],
          sessionFromKept: ['Random'],
          HttpSessionFactory: ['Random'],
          XynologBrowserConfig: ['Random'],
          ScriptedSessions: ['Random'],
          retryWithBackoff: ['Random'],
          equalJitter: ['Random'],
          describeConnection: ['Random'],
          renewKept: ['Random'],
          TestSessionOptions: ['Random'],
          retryWithBackoffFuture: ['Random'],
          renewKeptFuture: ['Random'],
          sessionFromKeptFuture: ['Random'],
          describeConnectionFuture: ['Random'],
        },
        swift: {
          HttpTransport: ['RandomNumberGenerator'],
          retryWithBackoff: ['RandomNumberGenerator'],
          renewKept: ['RandomNumberGenerator'],
          AgentToken: ['RandomNumberGenerator'],
          sessionFromKept: ['RandomNumberGenerator'],
          HttpSessionFactory: ['RandomNumberGenerator'],
          XynologBrowserConfig: ['RandomNumberGenerator'],
          'XynologClient.fromHttp': ['RandomNumberGenerator'],
          describeConnection: ['RandomNumberGenerator'],
          ScriptedSessions: ['RandomNumberGenerator'],
          TestSessionOptions: ['RandomNumberGenerator'],
        },
        csharp: {
          XynologClient: ['Random'],
          HttpTransport: ['Random'],
          Issuer: ['Random'],
          ServiceToken: ['Random'],
          FromKeptAsync: ['Random'],
          SignInStore: ['Random'],
          HttpSessionFactory: ['Random'],
          XynologBrowserConfig: ['Random'],
          TestSessionOptions: ['Random'],
          ScriptedSessions: ['Random'],
          BeginAuthorizationAsync: ['Random'],
          CompleteAuthorizationAsync: ['Random'],
          DescribeConnectionAsync: ['Random'],
          RetryWithBackoffAsync: ['Random'],
        },
        haskell: {
          newHttpTransport: ['HttpOptions'],
          HttpOptions: ['RetryOptions'],
          fromHttp: ['HttpOptions'],
          retryWithBackoff: ['RetryOptions'],
          newSession: ['RetryOptions'],
          fromIssuedSession: ['HttpOptions'],
          signInDevice: ['HttpOptions'],
          IssuerOptions: ['RetryOptions'],
          newServiceTokenSecret: ['IssuerOptions'],
          newServiceTokenKey: ['IssuerOptions'],
          signInAgent: ['HttpOptions'],
          fromKeptSession: ['HttpOptions'],
          newHttpSessionFactory: ['HttpOptions'],
          XynologBrowserConfig: ['HttpOptions'],
          describeConnection: ['HttpOptions'],
        },
      },
    },
  ],
};

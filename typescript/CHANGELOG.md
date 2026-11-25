# Changelog

The changes to the Xynolog SDK for TypeScript, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `ServiceEnvironmentVariable`: every environment variable a Xynolog service
  reads, beside its configuration document, by its name
  (`ServiceEnvironmentVariable.XYNOLOG_BUS_LOG`). The bus log reads its
  variable by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- The launcher's control API: `CONTROL_METHODS` and `CONTROL_NOTIFICATIONS`
  (each method's params and result, whether it runs alone and what it sends,
  each notification's params, by their schemas), `CONTROL_API_VERSION`,
  `ControlParams<M>`, `ControlResult<M>`, `ControlNotificationParams<N>`,
  `ControlErrorData`, and the control codes, `ControlErrorCode`.
- The tables the services keep to, each its JSON typed as its own schema
  (`records['ServiceEnvironmentVariable']`, …), and `SERVICE_TABLES`
  holding each by its file: the variables each service reads and its boot
  refusals, its telemetry and log lines, each service's messages, the job
  budgets and storage, the reply bounds, the embedding requests, the
  worker's answer formats, the gateway's media token and response headers,
  and the Archivist's layout and default entity types
  (`SERVICE_ENVIRONMENT_VARIABLES`, `JOBS_BUDGETS`, `GATEWAY_MESSAGES`, …).
  The Librarian's element schemas (`LIBRARIAN_PROMPT_SCORE_SCHEMA`), and the
  Archivist's routes, `archivistRoutes`.
- `storedSessionOf(clientId, issuer, tokens)`: what is kept of a sign-in.
- `httpEndpointOf(address)`: the HTTP endpoint a gateway's address names,
  the inverse of `kbGatewayUrl`.
- `busLogTagOf(line)` and `BUS_OPS`: a bus-log line's tag, read back.
- `ResourceRepresentation` and `ResourceRepresentationStream`, what
  `browse.resourceRepresentation` and `resourceRepresentationStream` answer.
- `@xynolog/react-ui` exports `renderAgentLabel`, `renderAgentLabels` and
  `creatorName`.
- `@xynolog/observability` names each span and metric of the SDK telemetry
  table (`SPAN_CONTENT_GET`, `SPAN_BUS_EMIT`, `METRIC_XYNOLOG_BUS_SENT`, …,
  and `TELEMETRY_CHANNEL`, what stands for the channel in a span's name), and
  the transports name their spans and their count by them.

### Changed

- A member Protocol states as bytes (`format: binary`) is a `Blob`, where it
  was a `string`: `ResourceUpload`'s `file`. A browser's `File` is one as it
  is.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse`'s `motivation` is an optional `Motivation`, where
  it was `Motivation | null`. Protocol no longer allows it to be null: a null
  for it is refused as malformed.
- The element of an answer format (`WorkerAnswerFormatsFormatsItem`'s
  `element`) carries Protocol's description of it.
- A knowledge base's DID in a health reply is a `KbDid`, and a follower's
  progress a `FollowerFollowing`, where each was a plain string or an object
  stated in place.
- `OpenResource` is `@xynolog/core`'s, the type Protocol states, which
  `@xynolog/sdk` exports as it did its own.
- The sdk's names for Protocol's types are Protocol's: `ResourceList` is
  `ListResourcesResponse`, `ResourceListFilters` `BrowseResourcesRequest`,
  `MatchedResources` `MatchResourcesResponse`, `MatchSearchProgress`
  `MatchSearchResult`, `CreateAnnotationInput` `CreateAnnotationRequest`,
  and `CreateResourceInput` `PutBinaryRequest`. `mark.annotation` answers
  `MarkCreateOkResponse`.
- `job.pollUntilComplete(jobId, options?, onStatus?)` takes `JobPollOptions`
  (`everyMs`, `withinMs`) and its callback apart, as `client/surface.json`
  states it; it took `{ interval, timeout, onProgress }`.
- `gather.resource` takes `GatherResourceOptions` and `match.search`
  `MatchSearchOptions`.
- `yield.resource` hands its `PutBinaryRequest` on whole, so a clone's
  `cloneToken` and `archiveOriginal` reach the upload. `PutBinaryRequest`'s
  members are the schemas': `format` is text, and `sourceAnnotationId`,
  `sourceResourceId` and `jobId` are their kinds of id, no longer any text.
- `AnchorRect` is Protocol's, and `browse:click` carries it as
  `BrowseClickEvent` states it.
- `RETRY_RULES` retries what `retry/rules.json` states, read from the
  table, where each rule listed its statuses by hand.
- A discovery document is read by its schema; a refused one says the first
  fault the schema finds.
- A sign-in pending its redirect is read as `PendingAuthorization`, the record
  Protocol states, which `@xynolog/sdk` exports from `@xynolog/core`; a
  stored one its schema refuses is no sign-in pending. Where each stream was
  is written as `LastEventIds`.
- A stream's place is what `isPlace(scope, id)`, which `@xynolog/core`
  exports, says `LastEventIds` holds: the transport's place in each scope and
  the places kept are decided by it.
- Every type of its own that a schema states in place (an object of members,
  a union, an `allOf`, an enumeration of several values) is a type
  `@xynolog/core` exports, by the name every SDK gives it
  (`KnowledgeGraphNodesItem`), and the member that holds it is of that type.
  It was written in place, reached only through its member
  (`components['schemas']['KnowledgeGraph']['nodes'][number]`). A property of
  one value is still that literal. `@xynolog/core` exports every type
  `types.ts` declares, so `records` and `tables` too, beside `components`.
- `LastEventIds` is keyed by `ResourceId`, as its schema's `propertyNames`
  states, where any text was a key: a map whose members' names Protocol
  holds to a kind of id is a `Record` of that kind.

### Removed

- `IssuerEndpoints`, for `PendingAuthorization['issuer']`.
- `Brand`, and `EventSignature` with `StoredEvent`'s `signature`, which
  nothing wrote or read.

## 0.8.1

### Changed

- Each package's npm page links to the repository's README and to its
  issues (`homepage`, `bugs`).
- `@xynolog/react-ui` no longer ships its components' TypeScript sources:
  of `src/components` and `src/features` it carries the CSS alone, which its
  stylesheets import.
- Each package's README reads as its npm page: what the package is, how to
  install it (`npm install`, taking releases up to the next minor), a first
  program, and, for `@xynolog/sdk`, connecting and signing in and the eight
  verbs. How to work on the packages moved to the repository's
  CONTRIBUTING.md.
- Each package's README links to the repository's files at the release's
  tag, so its links resolve on npm and show the files as of the release.
- Each package's coverage badge reads that package: `make test-typescript`
  measures every package's tests, `@xynolog/react-ui`'s in its four shards,
  and CI uploads the reports to Codecov.

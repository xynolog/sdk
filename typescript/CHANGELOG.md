# Changelog

The changes to the Xynolog SDK for TypeScript, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for ten of Protocol's tables that no service keeps, each typed by
  the table's own schema: `ClientDiscoveryAbsent`, `ClientRefresh`,
  `ClientTesting`, `ControlCli`, `ErrorsCodes`, `IdentifiersKinds`,
  `MediaTypesRegistry`, `SdkTelemetryTelemetry`, `SessionOauth` and
  `SignInStoreOwnerOnly`.
- `@xynolog/core` exports the keys a registry and its sessions keep what
  they keep under, generated from Protocol's `session/stored.json`:
  `STORAGE_KEY`, `ACTIVE_KEY`, `OPEN_RESOURCES_BY_KB_KEY`,
  `LAST_VIEWED_RESOURCE_BY_KB_KEY`, `PENDING_AUTHORIZATION_KEY`, the
  prefixes `SESSION_KEY_PREFIX`, `LAST_EVENT_ID_KEY_PREFIX` and
  `CACHE_KEY_PREFIX`, `WHOLE_KEY`, and a kept query's document's version,
  `CACHE_DOCUMENT_VERSION`. The SDK makes its keys and documents of them;
  `@xynolog/sdk`'s `cache-persister` module no longer states the version.
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
- `ClientTiming` and `TransportTiming`, which `@xynolog/core` and
  `@xynolog/sdk` export: the timing a caller may set of a client and of an
  HTTP transport, each member the entry of Protocol's `client/timing.json` of
  its name. `DEFAULT_CLIENT_TIMING` and `DEFAULT_TRANSPORT_TIMING`, from
  `@xynolog/core`, hold the table's values.
- `XynologClient.fromHttp`, `XynologSession.fromHttp` and
  `XynologSession.fromKept` take `clientTiming` and `transportTiming`, and
  `createHttpSessionFactory` takes both in a second argument, after `fetch`.
- `controlRpcCodes` and `ControlRpcCode`, each code of
  `control/rpc-codes.json`, and `controlErrorCodeAnswers`: the JSON-RPC code
  each control error code is answered with, and whether a request it failed is
  worth sending again, generated from `control/rpc-codes.json` and
  `errors/codes.json`.

### Changed

- The sign-in store holds each entry to the Required table's `SignIn`
  (`faultOf('SignIn', …)`), as every SDK does: an entry with a fault as Protocol's `SignIn` states it, such as an empty
  access token (an `AccessToken` is at least one character), is no sign-in.
- A map whose schema names its keys by a schema of their own is keyed by that
  schema's type: `InferenceSpec.providers` is a
  `Partial<Record<InferenceProvider, Provider>>`, and
  `ServiceTelemetryTelemetry.sdk` is keyed by
  `ServiceTelemetryTelemetrySpansItemServicesItem`.
- Each `DiscoveryAbsentReason` value says what it means, as
  `client/discovery-absent.json` says it.
- A schema a `$ref` names at a place within a file is one type, named where
  that place is stated, wherever it is referred to: the Archivist layout's
  trees are all `ArchivistLayoutEventStreamTree`, every error vocabulary
  whose codes state only their docs is `ErrorsCodesJob`, the SDK's telemetry
  instruments are `ServiceTelemetryTelemetryMetricsItemInstrument`, and the
  rest. The type each reference was given of its own
  (`ArchivistLayoutViewTree`, `ErrorsCodesSession`, …) is gone.
- `PutBinaryRequest` is `records['PutBinaryRequest']`, generated from
  Protocol's `client/types/PutBinaryRequest.json`, and its `file` is a
  `Blob`, where it was a `File | Buffer`: a browser's `File` is one, and a
  Node `Buffer` is uploaded as `new Blob([new Uint8Array(buffer)])`. A `File`
  is sent as it is; other bytes are sent as a file named for the resource,
  of its format, as a `Buffer` was.
- `ResourceRepresentation` is `records['ResourceRepresentation']`, generated
  from Protocol's `client/types/ResourceRepresentation.json`, and its `data`
  is a `Blob`, where it was an `ArrayBuffer`: `browse.resourceRepresentation`
  and `getBinary` answer the bytes as the response held them. A reader that
  wants them as a buffer has `await data.arrayBuffer()`.
- `EngineWithLimits` is `records['EngineWithLimits']`, generated from
  Protocol's `client/types/EngineWithLimits.json`, with the members it had,
  and `EnginesWithLimits` is its list; `browse.engines()` is a
  `CacheObservable<EnginesWithLimits>`.
- A retry budget is `RetryBudget`, the type of Protocol's
  `client/RetryBudget.json` (`components['schemas']['RetryBudget']`), where
  it was `RetryPolicy`: `EMIT_RETRY` and `REFRESH_RETRY` are one, and
  `retryWithBackoff` and a transport's `emitRetry` take one. Its members are
  as they were.
- `ResourceUpload`'s `file` is `components['schemas']['Binary']`, the type of
  Protocol's bytes held whole, which is a `Blob`, where `file` was a
  `string`. A browser's `File` is one as it is.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- So is one in the emit reply, and in the open resources and last-viewed a
  browser keeps. A reply that does not read is no count, and a stored entry
  that does not read is none. A write from another context that does not
  read leaves the current state as it was.
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
- A held job holds `HeldJobRecord`, the record Protocol states for the job
  its claim hands it, as `record`, which `@xynolog/core` and `@xynolog/sdk`
  export. Its `jobId`, `resourceId`, `params`, `completedUnits`,
  `unitCursors`, `retryCount` and `maxRetries` are the record's members, of
  the record's types: `completedUnits` is a `string[]` and `unitCursors` a
  `{ [key: string]: UnitCursor }`, where each was its read-only array or
  `Record`.
- The placement of a knowledge base is `KbPlacement`, where it was
  `DiscoveredKBPlacement`, `KnowledgeBaseStatusPlacement`, `RootPlacement`
  and `TargetKind`, one type each place it was stated; an inference provider
  is `InferenceProvider`, where it was `EngineProvider`.
- A default the service owns is no longer sent when the caller leaves it
  out, and the service's own applies (protocol#109): `browse.resources` and
  `match.resources` no longer send `limit: 100` and `offset: 0`,
  `gather.annotation` no longer sends `contextWindow: 2000` (nor `options`
  when none are given), and `match.search` no longer sends
  `useSemanticScoring: true`. A stated value is sent as stated.
- `DISCOVERY_URL_PATH` is generated from `client/surface.json`.
- `@xynolog/sdk` no longer exports `System`: `stateDir` takes Protocol's
  `components['schemas']['System']`.
- Discovery's types are the ones Protocol states, which `@xynolog/core` and
  `@xynolog/sdk` export: `DiscoveryState`, `DiscoveryRead` (in place of
  `DiscoveryReadResult`) and `DiscoveryDiff`, with their members
  `DiscoveryAbsent`, `DiscoveryManaged` and `DiscoveryUnchanged`. A
  `DiscoveryDiff` names in `duplicated` each address more than one of its
  state's knowledge bases is at.
- `UploadProgress`'s `started` and `progress` reports state `totalBytes`
  only when the upload's source states its length (protocol#121), so it is
  optional. Every upload holds its bytes whole and still reports it.
  `UploadProgressBar` shows a `progress` report with no `totalBytes` as it
  shows one whose total is unknown.
- `XynologClient`'s options `busTimeoutMs`, `invalidationWindowMs`,
  `jobSilenceMs` and `jobStatusPollMs` are one, `timing`, a
  `Partial<ClientTiming>`; `busTimeoutMs` is its `busRequestTimeoutMs`.
  `BrowseNamespace`, `GatherNamespace` and `MatchNamespace` take it as the
  `timing` of their options, in place of `busTimeoutMs` and
  `invalidationWindowMs`, and `MarkNamespace` and `YieldNamespace` take it as
  their last argument. `createTestClient` and `createTestSession` take
  `timing` in place of `busTimeoutMs`.
- `HttpTransport`'s config members `timeout`, `reconnectMs`,
  `streamOpenTimeoutMs`, `lazyRemoveMs`, `lingerMs`, `emitRetry` and
  `seenEventIdsCount` are one, `timing`, a `Partial<TransportTiming>`;
  `timeout` is its `httpRequestTimeoutMs`.
- `createHoverDwell`'s delay may be left out, and is then `HOVER_DELAY_MS`.

### Removed

- `isSignIn`, which held a value only to the members `SignIn` requires: the
  store holds an entry to the Required table's `SignIn`.
- `STARTUP_FETCH_RETRY`. An agent's sign-in (`agentToken`, and so
  `startAgentSession`) is made once, as every SDK makes it: a failure is
  thrown as it came, and starting the sign-in again is the service's, on its
  own backoff (Protocol's WORKER-SERVICE R3). `agentToken` takes no
  `onRetry`.
- `retryWithBackoff`'s `onRetry`, and `RetryAttemptInfo`, which nothing
  else used. Its `signal` is its fourth argument.
- `IssuerEndpoints`, for `PendingAuthorization['issuer']`.
- `Brand`, and `EventSignature` with `StoredEvent`'s `signature`, which
  nothing wrote or read.
- `createCache`'s `saveDebounceMs`: a cache saves `SAVE_DEBOUNCE_MS` after
  its values change.
- `ResourceGatherOptions`, for `@xynolog/core`'s generated
  `GatherResourceOptions`. A gather state unit's `gatherAnnotation` takes
  the generated `GatherAnnotationOptions`.

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

# Changelog

The changes to the Xynolog SDK for TypeScript, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

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
  (`records['ServiceEnvironmentVariables']`, …), and `SERVICE_TABLES`
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

### Changed

- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
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

### Removed

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

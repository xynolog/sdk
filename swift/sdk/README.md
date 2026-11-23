# Xynolog Swift SDK

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=swift-sdk)](https://app.codecov.io/gh/xynolog/sdk/components)

The Swift SDK for Apple apps and Linux services. Use it to read and write a
Xynolog knowledge base, observe changes as they happen, and delegate jobs to
workers. The SDK shares the other languages' [protocol][protocol] and
[conformance suite][conformance]. The [Developer Guide][guide] shows how
those capabilities fit together.

## Install

Add the package to your `Package.swift` by its URL. `<version>` is a
release's. Below 1.0 the minor number is the break, so take releases up to
the next minor:

```
.package(url: "https://github.com/xynolog/sdk-swift.git", .upToNextMinor(from: "<version>"))
```

and add `.product(name: "Xynolog", package: "sdk-swift")` to your target's
dependencies. In Xcode, add the package by the same URL with the rule Up to
Next Minor Version, and link the `Xynolog` product to your target. Add the
`AsyncHTTPClient` product from [AsyncHTTPClient][http-client] to targets
that create the HTTP client.

See [the pinned Swift toolchain][toolchain]
for the version used in CI. The SDK supports macOS 15 and iOS 18 or later,
and CI also runs on Linux.

You need a running knowledge base to connect to. The [Quick Start][quick-start]
sets one up locally.

## A first program

This program starts from a signed-in client, the `opened.client` of an
open session: [Connect](#connect) is how a program comes to one. Pass that
client and the ID of a source resource to this function. It gathers
context around the resource, delegates a job to generate a summary, and
waits for the job's result. The knowledge base needs a worker that handles
generation jobs.

```swift
func generate(
  from resource: ResourceId, using client: XynologClient
) async throws -> YieldJobCompleteCommand {
  let context = try await client.gather.resource(resource)
  let run = try client.yield.delegate(
    params: GenerationJobParams(
      context: context, storageUri: "file://summary.md", title: "Summary"))
  return try await run.completed()
}
```

## Connect

A script can sign a person in using the device grant. The issuer provides a
URL and code to show to the person. After they approve in a browser, the
session renews their tokens as needed. Pass a `KbTarget` for the gateway and
a `ResourceId` from that knowledge base to read a resource's metadata.
For a gateway at `http://localhost:4000`, build the target with
`.httpEndpoint(HttpEndpoint(host: "localhost", port: 4000, protocol: .http))`
and give it an ID and label. Your `showCode` callback can print the code's
`verificationUri` and `userCode`.

```swift
import AsyncHTTPClient
import Xynolog

func readFirstResource(
  _ resource: ResourceId, in kb: KbTarget,
  showCode: @Sendable (DeviceCode) -> Void
) async throws -> ResourceDescriptor {
  let http = HTTPClient(eventLoopGroupProvider: .singleton)
  let kept = MemorySignIn()
  let descriptor: ResourceDescriptor
  do {
    try await signInDevice(kb: kb, kept: kept, httpClient: http, onCode: showCode)
    let opened = try await sessionFromKept(kb: kb, kept: kept, httpClient: http)
    defer { opened.dispose() }
    try await opened.session.ready()
    descriptor = try await opened.client.browse.resource(resource).fresh()
  } catch {
    try? await http.shutdown()
    throw error
  }
  try await http.shutdown()
  return descriptor
}
```

`MemorySignIn` holds the sign-in for the life of the program. To use an
existing launcher sign-in, open a `SignInStore(path:)` and pass its entry for
the knowledge base to `sessionFromKept`. A desktop or mobile app can sign in
with a browser redirect. See [Registry and state units](#registry-and-state-units).

## Signing in and managing a session

Sign-in uses the same caller-owned HTTP client. `ServiceToken` supports a client
secret or an RSA key (`CryptoExtras._RSA.Signing.PrivateKey`); `AgentToken` asks
the gateway for its DID once and keeps its last token when a renewal fails.
`signInDevice` shows the issuer’s device code through its callback and keeps the
result in a `SignInKept`. `whoAmI` asks the gateway once without opening a stream.

`SignInStore(path:)` reads the launcher’s `tokens.json`; `entry` selects a stack.
Writes hold `flock` on the sibling `tokens.lock`, use owner-only modes generated
from the contract, and rename a sibling temporary file. Unknown document members
survive. `MemorySignIn` follows the same renewal rules. `stateDir` computes the
launcher’s directory from values the application supplies; it reads no environment.

`sessionFromKept` returns an `OpenedSession`, which owns the session and its HTTP
transport. Dispose that owner before shutting down the HTTP client. The session asks the
gateway who its token is unless it is opened with `validate: false`. Its `ready()` raises
startup task failures; `errors()` is its one stream of what went wrong: its own
`SessionError`s (a sign-in it could not check, renew, read or record, a write its storage
refused) and its transport’s failures, each said once, in the order they were met. A session
listens to its client’s transport, whatever the transport, from when it is made, and says each
failure as the transport tells it; taken first, its listener is told what the transport kept,
which is said ahead of everything the session says. Of what it
says before anyone reads `errors()`, the latest `errorsKeptForFirstReaderCount` are kept for
the first reader. The stream ends when the session ends. Disposing the
`OpenedSession` closes the client first and ends the session once the client’s closing flush
has written, so what that flush meets arrives first; what the client meets once its session has
ended is said nowhere. Startup is bounded, overlapping refusals share
one renewal, and a renewal that gets no answer, whatever failed, keeps the stored sign-in for
another attempt. The transport tells the session the token refused:
a refusal of a token the session has already replaced is given the token it holds, and renews nothing. Session token and
user state are read-only, and their sequences finish on disposal.

Use `XynologClient.fromHttp(baseUrl:httpClient:token:)` for a short-lived
program that already holds an access token. Use a session when the program
needs renewal. See [Signing in][sign-in] for the available flows.

## Eight verbs

The client's namespaces follow the [eight protocol verbs][flows].

| Verb | What it does | Example methods |
| --- | --- | --- |
| Browse | Navigate, read, and observe the knowledge base | `browse.resource`, `browse.annotations` |
| Frame | Define and extend the vocabulary | `frame.addEntityTypes`, `frame.addTagSchema` |
| Mark | Annotate a resource | `mark.annotation`, `mark.delegate` |
| Bind | Resolve a reference | `bind.body`, `bind.initiate` |
| Gather | Assemble grounding context | `gather.resource`, `gather.annotation` |
| Match | Search for resources and reference candidates | `match.resources`, `match.search` |
| Yield | Upload or generate a resource | `yield.resource`, `yield.delegate` |
| Beckon | Direct attention across participants | `beckon.hover`, `beckon.sparkle` |

The client also exposes `job`, plus `auth` and `system` when it has gateway
operations.

## Live queries

Use a live query to keep a view up to date while other participants write.
This example receives each state until the caller cancels or disposes the
client.

```swift
func watchResource(
  _ resource: ResourceId, using client: XynologClient,
  show: (CacheState<ResourceDescriptor>) -> Void
) async {
  for await state in client.browse.resource(resource) {
    switch state {
    case .pending: show(.pending)
    case .ready(let resource): show(.ready(resource))
    case .failed(let error): show(.failed(error))
    }
  }
}
```

Iterate a live query's `Cached` sequence for `CacheState.pending`,
`.ready(value)`, and `.failed(error)`. Iterating a resource-scoped query holds
the resource's event subscription until iteration ends. Call `fresh()` to ask
the service directly and share its answer with observers. Disposing the client
ends the sequences.

Pass `CachePersistence(storage:kbId:personKey:)` (the key from `personKey(_:)`)
as the client's `persistence` option to keep resource details, annotations, and
vocabulary in application-provided `SessionStorage` for one person. Each kept
query is one document under `xynolog.cache.<kbId>.<personKey>.<query>`, in the
form every Xynolog SDK reads, so a client in another language finds what this
one kept. The first observation shows the saved value while asking for a
current one. Where the stream was is kept under
`xynolog.lastEventId.<kbId>.<personKey>`, and the HTTP transport resumes each
resource scope from it; it is written beside a cache's document only while
nothing kept is still being fetched or saved. Disposal flushes pending settled
values. A registry's session keeps for the person once its stored sign-in names
them, and forgetting that sign-in, however it is forgotten, signing in again
included, deletes what was kept. A session the SDK builds, `sessionFromKept`
with a storage too, writes only while the sign-in it holds names its person; a
client you construct with a `CachePersistence` of your own writes unchecked.

## Delegated work and workers

`gather.annotation` and `match.search` return a lazy `Running<T>`. Await
`completed()` for its result, or use `for try await` for its reports and final
value. Each operation has one consumer; constructing it or its iterator sends
nothing. Cancellation, leaving a loop, or `dispose()` stops its owned work.
Closing the client ends an unfinished operation with `bus.closed`.

`mark.delegate` and `yield.delegate` return a `Delegation` of that verb's typed
completion. Iteration reports creation first, then progress, retry setbacks and
refused frames, and finally completion. Awaiting `completed()` returns just the
completion. A refused frame of a job's progress, completion or failure,
`JobEvent.refused`, names its channel and its fault; it names no job and is no
word of one, so the follower goes on and goes on counting the job's silence.
A quiet job is checked through status polling, one request at a time; retry
setbacks keep the follower alive. A generation's stall deadline grows with its
requested length unless supplied explicitly. Stalling asks for job cancellation;
cancelling the follower itself stops observing and leaves the job running.

`job.queued`, `progress`, `complete` and `fail` are independent typed listeners
that start when asked for. `pollUntilComplete` reports every status through its
optional callback and bounds requests and sleeps by the caller's deadline. Named
no interval, it asks every `jobPollMs`; named no limit, it fails as timed out
`jobPollTimeoutMs` after its first ask, as `protocol/specs/src/client/timing.json`
states them.

Workers configure their HTTP transport with `jobClaimChannels` and add
`jobCommitChannels` when they write annotations. Iterate `client.job.claim`
to take matching jobs one at a time. An announcement its transport refused
wakes an idle worker as a matching one does. A held job exposes cancellation, progress,
checkpoints, and settlement. Cast it to `HeldMarkJob` or `HeldYieldJob` to
complete it with that verb's result. Await `claims.stop()` before disposing
the worker client so it can settle a job it still holds. `claims.refused()`
says each claim refused for a reason other than nothing pending, and
`claims.stalled()` each held job that showed no activity for longer than
`heldJobStallMs`, once for each job. Of what each says before anyone reads it,
the latest `errorsKeptForFirstReaderCount` are kept for its first reader. Both
end when the claims end.

## Registry and state units

Use `newXynologBrowser` with a `SessionStorage` and an `HttpSessionFactory`
to remember knowledge bases, activate a session, and keep open resources
for each knowledge base. `beginSignIn` returns the issuer URL for the
authorization-code flow with PKCE. Pass the redirect callback to
`completeSignIn` to exchange the code, confirm which knowledge base answered,
and activate it. Launcher discovery can read a document supplied by the app
or a document over HTTP. The discovery stream reports absent launchers,
managed knowledge bases, and changes by address.

The registry is the one reader of each session's `errors()`, from the first
thing the session said. It says each of the session's own `SessionError`s on
its own `errors()`. A refusal for lack of permission is said through the
session's `SessionSignals.permissionDenied`, with the refusal's message. A
refusal for want of a valid token is renewed by the transport that met it, and
the registry does nothing with it. A `SessionFactory` reads none of them, so a
session from a factory you write is read the same way.

State units expose read-only `Watched` values for a viewer or application.
Use `MarkStateUnit` to compose annotations and follow delegated work,
`YieldStateUnit` for generation, `GatherStateUnit` for annotation and resource
context, and `MatchStateUnit` for searches requested on the local bus.
`BeckonStateUnit`, `HoverDwell`, and `SearchPipeline` hold attention and
search input. `SessionSignals` carries session notices. `Cache` offers the
same read-through queries for app data, with an optional `StoragePersister`.

Call `dispose()` on a state unit to cancel its work and finish its streams.
The app owns the client it handed the unit. Await `XynologBrowser.close()`
to end the active session and wait for registry work before shutting down
the HTTP client.

## Building annotations

Annotation readers accept every generated body, target and selector variant.
`reconcile(text:quoted:)` finds a model's quote and returns the resource's own
words and context as a `ReconciledSpan`, whose case is how it was found; only
`fuzzyMatch` carries a `matchQuality`. Offsets count Unicode scalars.
`TextSpan(_:)` makes it the span an `OfSpan` carries. `annotationOfSpan` takes an
`OfSpan` whose `Spanned` text is either plain text or a PDF's `AnchoredText`.
It checks the span before building position/quote selectors or PDF rectangles.
`annotationOfResource` builds an annotation of the whole resource. Both builders
derive the same deterministic annotation ID as the other SDKs. Refused spans
throw `SpanRefusedError` with a generated error code.

Media-type helpers read generated registry rows, including clone formats,
storage filenames, extension aliases, and whether a format's text is decoded
or derived. Shared annotation, offset and media-type cases run in the unit suite.

## Testing a consumer

Link `XynologTesting` in a test target. Use `ScriptedTransport` for typed
requests and frames, `createTestSession` for a real session over a scripted
transport, and `ScriptedSessions` with `SharedStorage` for registry tests.
`assertLivenessAxioms` checks outputs, settlements, and retry budgets over
repeatable fault schedules. `assertExactlyOnceDelivery` checks event order
and count across interleaved writes and connection transitions.
`ScriptedTransport` is given its global channels as an HTTP transport is, and
delivers only those, and a resource-scoped frame only while its resource is held:
a test of a full client gives it `bridgedChannels`, and a worker's test
`jobClaimChannels`. It keeps no
deadline: a dropped reply never comes, and the client's bus fails the request
at its own. `fail(_:)` tells a `TransportError` to each listener of its
failures, as a transport does of a request the gateway refused, so a session
made over it says it on its `errors()`; one reported before anyone listens is
kept for the first listener. A `LivenessSpec`'s `timeout` is the
time its composition gives a bus request, so its `setup` builds the client with
that many milliseconds as its `busRequestTimeoutMs`.

Every maker that waits takes a `clock:` (any `Clock` whose duration is
`Duration`, `ContinuousClock()` when none is given), and every maker that backs
off takes a `random:` generator (`SystemRandomNumberGenerator()` when none is
given). What a maker makes keeps its clock and generator: a client's namespaces,
caches and state units, a session's renewals, a registry's sign-ins. Hand the
SDK a `TestClock` and call `advance(by:)` to end its reconnect backoff,
deadlines, debounces, renewals and polls when a test says, and hand it a
generator whose draws are fixed to make each jitter the same on every run.
The sleepers an advance wakes wake earliest first and, at one instant, in the
order they slept.

## Transports, the bus, and telemetry

`XynologClient.fromHttp(baseUrl:httpClient:token:)` constructs the HTTP client
surface. `XynologClient(transport:gateway:content:)` takes another `Transport`, with
`auth` and `system` present only when a `GatewayOperations` is supplied. Browse
content and annotation list reads and Yield uploads use the supplied `ContentTransport` or the
client transport itself when it conforms. An `Upload` is awaited with `completed()` for the
resource it created, and iterated for its `UploadProgress`: `started` with its size, `progress`
as its bytes are sent, and `finished` with the resource made. An upload that fails throws to its
awaiter and reports no `finished`. Custom content transports supply
`getAnnotations(_:)` for the live annotation list. The client implements all 66
namespace methods: vocabulary writes, binding,
attention, authentication/status, annotation writes, job events/status/cancellation,
gather/search operations, delegation, uploads and cloning, and Browse history,
directory, knowledge-base, navigation, graph, decoded and anchored text, and
binary reads. Browse also offers live resource details, annotations, event
history, resource lists, engines with limits, entity types and tag schemas.
Match offers live resource search results, and Gather offers live incoming
references.

`client.wire` sends typed generated `Channels` and `Operations`. A request
has, from the call, its emit included, `busRequestTimeoutMs`
(`XynologClient(busRequestTimeoutMs:)`, the timing table's value when none is
given), or the `timeoutMs:` its caller gives, on the client's clock and over any
transport, to be answered; then it fails as `busTimeout`, and an emit still in
flight is given up, with no attempt after it. A worker's claim waits its `claimTimeoutMs`, and a held job's
commit its `commitTimeoutMs`, the same way. `frames` on a
`ScopedChannel` requires a resource and holds that resource only while the read
is alive. Breaking, cancellation, completion or disposal releases the hold.
A `Typed` sequence gives `Heard.delivered` with its original `ReceivedFrame`,
decoded payload and principal, or `Heard.refused` with a `FrameRefusal` in place
of a frame its transport refused or whose payload is not its channel's. A
refusal names the channel, the way from the frame to its first fault (such as
`payload.resourceId`) and why, holds the payload as it came, and leaves later
frames readable. A request whose reply its transport refused fails at once.
A second iterator is refused. Channel construction and payload mismatches are
also checked by the compile-refusal suite.

`client.bus` is the client's own bus: local signals stay local, while received
wire frames are bridged into it. Every listener starts when asked for and keeps
every subsequent event. `dispose()` cancels the bridge, disposes the transport
once and finishes listeners. Custom transports can supply read-only state via
`Watched(initial, updates:)`, events via `Events`, and scoped release via
`ResourceHold` without a concurrency escape. A transport's
`request(operation:payload:)` keeps no deadline: the bus that asks keeps it, and
gives a request up by cancelling its task, which the transport ends.

The HTTP transport uses the caller's AsyncHTTPClient `HTTPClient` for every request. Its default proxy setting is `nil`; it does not read proxy environment variables. Callers configure trust and proxies on that client and shut it down after disposing the transport. The SDK reads only `XYNOLOG_BUS_LOG`.

`HttpTransport` is always given the global channels its stream names, and assumes none of its own: a full client's transport is given `bridgedChannels`, which `XynologClient.fromHttp` and `sessionFromKept` pass. A request whose reply channels it was not given fails at once as `bus.unsubscribed`. It exposes connection state, independent lossless `frames` sequences of `Carried` (several channels can share one ordered sequence), scoped holds, correlated requests, uploads and content reads. `dispose()` synchronously cancels owned work and finishes sequences. A second iterator on an events, upload or content stream throws `MultipleConsumers`. Each frame is held to `BusFrame`: one it allows is `Carried.frame`, one it does not that names its channel's readers is `Carried.refused`, and anything else is a failure. Each failure a transport meets (a refusal, a request the gateway never answered, a line no reader can read) is told to every listener taken with `tellFailures(to:)` before the call that met it returns, so in the order met; the first listener is told at once the latest `errorsKeptForFirstReaderCount` met before it came, and one taken after the transport is disposed is told nothing. A listener must not wait. Incoming trace carriers are lifted out of payloads into `ReceivedFrame.trace`. OpenTelemetry's API is the library's only telemetry dependency; the application selects its provider and exporters.

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

[protocol]: https://github.com/xynolog/protocol/blob/main/contract/README.md
[conformance]: https://github.com/xynolog/protocol/blob/main/conformance/sdk/README.md
[guide]: https://github.com/xynolog/docs/blob/main/builder/DEVELOPER-GUIDE.md
[http-client]: https://github.com/swift-server/async-http-client
[toolchain]: https://github.com/xynolog/sdk/blob/v0.8.2/swift/sdk/.swift-version
[quick-start]: https://github.com/xynolog/docs/blob/main/builder/QUICK-START.md
[flows]: https://github.com/xynolog/protocol/tree/main/contract/flows
[sign-in]: https://github.com/xynolog/docs/blob/main/builder/SIGN-IN.md

# Xynolog SDK for .NET

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=csharp-sdk)](https://app.codecov.io/gh/xynolog/sdk/components)

Use the SDK to read and write a Xynolog knowledge base, follow delegated jobs,
or run a worker.

[Install](#install) · [A first program](#a-first-program) · [Signing in](#signing-in) ·
[Delegation](#delegation) · [Live queries](#live-queries) · [Running a worker](#running-a-worker)

## Install

```sh
dotnet add package Xynolog
```

Below 1.0 the minor number is the break. NuGet restores the lowest version a
`PackageReference` accepts, so to take the releases up to the next minor, float
the patch number in your project file, where `<minor>` is a release's version
without its patch number:

```xml
<PackageReference Include="Xynolog" Version="<minor>.*" />
```

The SDK targets `net11.0`.

## A first program

Connect to a knowledge base and ask its name. Call `RunAsync` from your program
with the gateway URL and a current access token; [Signing in](#signing-in) is how
a program comes to hold one, and [Connect](#connect) says what the client owns.
The example owns its client and passes the cancellation token to the request.

```csharp
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Xynolog;

public static class NameKnowledgeBase
{
    public static async Task<string> RunAsync(string endpoint, string token,
        HttpClient? http = null, CancellationToken cancellation = default)
    {
        using var client = new XynologClient(endpoint, token, http);
        var kb = await client.Browse.KbAsync(cancellation);
        return kb.Name;
    }
}
```

## Signing in

Choose the method that fits your application. Use a [token you already hold](#connect)
for a short-lived client, a [kept session](#using-a-kept-sign-in) for a launcher
sign-in, the [device grant](#signing-in-with-a-device-code) for an interactive
script, a [browser redirect](#signing-in-with-a-browser-redirect) for an application,
or an [agent account](#signing-in-as-an-agent) for a worker.

### Using a kept sign-in

`Xynolog.SignIn.SignInStore` reads and updates the launcher's sign-ins. Give it an
explicit state directory; `StateDirectory` computes that path from values supplied by
the application and reads no environment variables. `Entry(stackKey)` returns the kept
sign-in for that stack; `MemorySignIn` keeps one in memory instead. Changes use the
launcher's native lock and atomic rename, preserve unknown entries and fields, and
keep the directory and credential files private to their owner.

`XynologSession.FromKeptAsync(kb, kept)` opens a session over a knowledge base's HTTP
endpoint and an `ISignInKept`, and gives it with the client it is made over as an
`OpenedSession`. A kept sign-in that cannot be read fails the call. Await the session's
`ReadyAsync()` for startup to settle, then read or enumerate `Token` and `User` for the
current token and gateway-validated user. An empty store or failed startup can leave
either value absent. The session asks the gateway who its token is unless it is given
`validate: false`. An expired credential is renewed before validation; a refused
credential is renewed once and validated once more. `RefreshAsync(refusedToken)`
handles a transport refusal; simultaneous callers share one renewal, and canceling a
caller's wait leaves that renewal running for the others. Transient renewal failure
retains the kept sign-in and retries on the reconnect backoff. The session signs out
when the issuer refuses its renewal, a renewal gives no token, or the gateway refuses a
token the issuer has just issued: it forgets the kept sign-in and tells `onAuthFailed`
why, before it says so on `Errors()`.

`Errors()` is the session's one stream of what went wrong: its own errors, each a
`SessionError` with one of the generated session error codes, and its client's
transport's failures, each said once. Of what it says before anyone reads it, the
latest `errorsKeptForFirstReaderCount` (protocol/specs/src/client/timing.json) are
kept for the first reader, in the order said. Given a storage, the client keeps its
persisted queries there for the person the gateway names; a write the storage refuses
is said as `session.save-refused` and written again with the client's next change or
its closing. Disposing the `OpenedSession` disposes the client, waits for its closing
save, and then ends the session and its errors, without signing out the kept
credentials.

Use `HttpSessionFactory` with `XynologBrowser` to bind a registered knowledge base's
session to its client. Its session tells the knowledge base's signals why it ended, as
it signs out. A factory reads none of the session's errors: the registry is their one
reader, from the first thing the session said. It says each of the session's own errors
on its `Errors()`, and a transport refusal for lack of permission through the signals
as a permission denied, with its message. A refusal for want of a valid token is
renewed by the transport that met it, so the registry does nothing with it, nor with
any other failure of the transport. A session from a factory you write is read the
same way. Such a factory hands its options' `Signals.NotifySessionEnded` to
`XynologSession.FromKeptAsync` as `onAuthFailed`: the registry raises no session end
itself.

`Issuer.RenewAsync(kept, holding)` exchanges the stored refresh token at its stored
endpoint. It adopts another writer's usable renewal before spending a refresh token,
preserves a renewal made during its grant, and never resurrects an entry signed out
meanwhile. A missing refresh token in the issuer's answer preserves the one spent.
Issuer refusal produces `SignInError`; transient failures use the shared retry budget.
It accepts a caller-owned `HttpClient`, `TimeProvider`, and `Random`, and disposal
cancels its pending grants without disposing the caller's client. The session layer
will decide whether an issuer refusal ends a session; the issuer itself retains the
kept entry when a grant fails.

### Signing in with a device code

`Issuer.SignInDeviceAsync(endpoint, kept, onCode)` discovers the issuer the gateway
trusts and begins a device sign-in. The callback receives a `DeviceCode`: the user code and
verification address for the application to display, and how many seconds the code is good for. Polling follows the issuer's interval and
slow-down replies, expires on the supplied clock, and stops on cancellation or issuer
disposal. A successful grant saves the access and refresh tokens in `kept`.
Pass that same entry to `XynologSession.FromKeptAsync`.
`Issuer.SignOutAsync(kept)` attempts revocation and forgets the local credentials even
when the issuer cannot be reached. Discovery rejects an issuer document that describes
a different issuer or provides invalid endpoint addresses.

### Signing in with a browser redirect

`BrowserSignIn.BeginSignInAsync` gives the authorization URL with PKCE.
Pass the callback URL to `CompleteSignInAsync` once. It exchanges the code
and asks the gateway for its knowledge-base identity before storing credentials.
Both keep the browser's `TimeProvider` and `Random` for the issuer and transport
they build. Without a browser, `RedirectSignIn.BeginAuthorizationAsync`,
`CompleteAuthorizationAsync` and `DescribeConnectionAsync` take them directly.

### Signing in as an agent

`ServiceToken` gives a service account's bearer header through
`AuthorizationAsync`. Supply its issuer, client ID, and either a client secret
or an RSA private key. The service discovers the endpoint once and shares an
in-flight grant among callers. The caller keeps any supplied key and HTTP client
usable for the service token's lifetime.

`AgentToken` uses a service token to sign in to a knowledge base and confirm
its DID. It renews the token when due or after a credential refusal, on its
service token's `TimeProvider`.
`RefreshAsync` can serve as a transport refresher, and `TokensChanged` exposes
updates to consumers. A transport tells its refresher the token refused: an
agent or a kept session that holds another by then gives it and renews
nothing. Dispose the agent before disposing its service token.

See the [builder sign-in guide](https://github.com/xynolog/docs/blob/main/builder/SIGN-IN.md) for the shared flows.

## Connect

Construct `XynologClient` with a gateway URL and a current access token.
The client disposes its transport, and a supplied HTTP client stays caller-owned.
Use a [kept session](#using-a-kept-sign-in) if the client needs to renew credentials.

`Gateway.Origin(endpoint)` validates the host and preserves the explicit port.
`Gateway.IsValidHostname(host)` is that validation: whether a host is one a knowledge
base's HTTP endpoint may name.
`Gateway.GetCurrentUserAsync(origin, token)` asks who a token is with exactly one
request, without opening a stream, retrying the request, or renewing the token.

## Eight verbs

The client's eight verb namespaces are
`Yield`, `Mark`, `Bind`, and `Frame` for writes, `Browse`, `Match`, and `Gather` for
reads, and `Beckon` for attention. The PascalCase property `Yield` can be used directly
in C# because the contextual keyword is spelled `yield`.

Frame mutations await their replies. A batch of entity types sends each mutation
after the preceding one settles.

## Delegation

`client.Mark.Delegate(resourceId, parameters)` follows an annotation job, and
`client.Yield.Delegate(parameters)` follows generation from a gathered context.
Await a delegation for its typed completion, or use `await foreach` to see the
job ID, progress, retryable failures, and completion in order. Each delegation
can be consumed once. Leaving a read stops following the job. Yield's optional
stall deadline applies to the follower, which asks the queue to cancel the job
if it stops reporting. A `JobError` carries the shared error code, job ID when
known, and failure class when the worker supplied one.

Gather a resource's context, then delegate a generation grounded in that context.
Call `RunAsync` from your program with the gateway URL, a current access token,
and the source resource ID. The example owns its client and passes the cancellation
token to both operations.

```csharp
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Xynolog;
using Xynolog.Identifiers;
using Xynolog.Types;

public static class GatherAndDelegate
{
    public static async Task<YieldJobCompleteCommand> RunAsync(
        string endpoint, string token, ResourceId source, string storageUri,
        HttpClient? http = null, CancellationToken cancellation = default)
    {
        using var client = new XynologClient(endpoint, token, http);
        var context = await client.Gather.ResourceAsync(source, cancellation: cancellation);
        var generation = client.Yield.Delegate(new GenerationJobParams
        {
            Context = context,
            Title = "Notes",
            StorageUri = storageUri,
        });
        return await generation.CompleteAsync(cancellation);
    }
}
```

## Live queries

Live reads such as `Browse.Resource` share a cache by key. A resource observer
holds that resource's event subscription until the enumerator ends. Refreshes
keep the last value visible while the new request runs. Use `FreshAsync` on the
query when you need a new answer for a one-off read.

```csharp
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Xynolog;
using Xynolog.Identifiers;
using Xynolog.Types;

public static class WatchResource
{
    public static async Task RunAsync(XynologClient client, ResourceId resourceId,
        TextWriter output, CancellationToken cancellation = default)
    {
        await foreach (var state in client.Browse.Resource(resourceId).WithCancellation(cancellation))
        {
            var message = state switch
            {
                CacheState<ResourceDescriptor>.Pending => "Loading…",
                CacheState<ResourceDescriptor>.Ready(var resource) => resource.Name,
                CacheState<ResourceDescriptor>.Failed(var error) => error.Message,
            };
            await output.WriteLineAsync(message);
        }
    }
}
```

The switch covers the cases of the SDK's closed cache-state type. When the SDK
adds a case, recompiling the switch points out the missing branch.

The SDK uses `IAsyncEnumerable<T>` and has no Rx dependency. To consume a
stream as an observable, reference `System.Interactive.Async` in the host
project and import `System.Linq`. Then call
`client.Browse.Resource(resourceId).ToObservable()`.

Supply `CachePersistence(storage, kbId, RegistryStorage.PersonKey(did))` when
constructing a client to keep its persisted queries and where its stream was
across sessions for that person: one document per query, which a client in any
Xynolog SDK reads over the same storage. A registry's `HttpSessionFactory`
keeps for the person from when the knowledge base's stored sign-in names them,
and forgetting that sign-in, however it is forgotten, signing in again
included, deletes what was kept. Such a session writes only while the sign-in
it holds names its person; a client you construct with a `CachePersistence` of
your own writes unchecked, and keeps a write its storage refuses owed without saying so. A restored value is visible immediately and
revalidated when first read.

## State units

State units in `Xynolog.State` expose read-only `StateValue<T>` properties.
Read `Value` for a snapshot or enumerate the property to receive the current
value followed by updates. Dispose the unit to stop its work and end its streams.
`XynologSession` owns the kept-session lifecycle and leaves its client with its caller.
See the [state-unit contract](https://github.com/xynolog/docs/blob/main/builder/STATE-UNITS.md).

## Running a worker

Create a `ServiceToken` with your service account credentials and keep it alive
while the worker runs. `AgentToken.SignInAsync` confirms the agent's identity
with the gateway. Give the transport the initial token, use `TokensChanged` to
keep it current, and pass `RefreshAsync` to handle a gateway refusal.

`Claims.NextAsync` returns the next job, or `null` when claiming ends. The
example starts each job and calls your handler. Complete a `HeldMarkJob` or
`HeldYieldJob` with the result for its verb, or settle it with `FailAsync` or
`CancelAsync`. Read the job's attempt and saved checkpoint when resuming work.
Use its `Trace` as the parent of the job's activity. The example awaits
`StopAsync` before closing the client so the worker can report any job it
still holds.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Xynolog;
using Xynolog.Http;
using Xynolog.Jobs;
using Xynolog.SignIn;
using Xynolog.Types;

public static class RunWorker
{
    public static async Task RunAsync(HttpEndpoint endpoint, ServiceToken service,
        IReadOnlyList<JobFilter> filters, Func<IHeldJob, CancellationToken, Task> settle,
        bool commitsAnnotations = false, HttpClient? http = null,
        CancellationToken cancellation = default)
    {
        using var agent = new AgentToken(endpoint, service, http);
        await agent.SignInAsync(cancellation);

        var channels = commitsAnnotations
            ? WorkerRules.JobClaimChannels.Concat(WorkerRules.JobCommitChannels)
            : WorkerRules.JobClaimChannels;
        using var client = new XynologClient(new HttpTransport(agent.Gateway, agent.Token,
            channels, refresher: agent.RefreshAsync, httpClient: http));
        using var updates = new CancellationTokenSource();
        var following = FollowTokensAsync(agent, client.Transport, updates.Token);
        var claims = client.Job.Claim(new ClaimOptions { Accepts = filters });
        try
        {
            while (await claims.NextAsync(cancellation) is { } job)
            {
                using var running = CancellationTokenSource.CreateLinkedTokenSource(cancellation, job.Cancelled);
                try
                {
                    await job.StartAsync(running.Token);
                    await settle(job, running.Token);
                    if (!job.Settled) throw new InvalidOperationException("The worker must settle its job.");
                }
                catch (OperationCanceledException) when (job.Cancelled.IsCancellationRequested && !cancellation.IsCancellationRequested)
                {
                    if (!job.Settled) await job.CancelAsync(cancellation: cancellation);
                }
            }
        }
        finally
        {
            try { await claims.StopAsync(); }
            finally
            {
                updates.Cancel();
                await following;
            }
        }
    }

    private static async Task FollowTokensAsync(AgentToken agent, HttpTransport transport, CancellationToken cancellation)
    {
        try
        {
            await foreach (var _ in agent.TokensChanged(cancellation)) transport.SetToken(agent.Token);
        }
        catch (OperationCanceledException) when (cancellation.IsCancellationRequested) { return; }
    }
}
```

## Reading and writing resources

Browse reads resource text, bytes, streams, graphs, anchored text, history, and
knowledge base metadata. Dispose a representation stream when finished with it.
`Yield.Resource` starts an upload immediately. Read what it reports once, each an
`UploadProgress`: its size before any bytes are sent, the bytes sent as they go, and
the resource made once the knowledge base has answered. Await the upload for the
created resource. Dispose an upload to abandon its request.
`Yield.CreateFromTokenAsync` reads the source first and uploads the copy in a
format that can be authored, using plain text for other formats.

## Several knowledge bases

`Xynolog.Registry.XynologBrowser` keeps registered knowledge bases, the active
session, and open resources. Give it an `ISessionStorage` and a session factory,
such as `HttpSessionFactory`, then hold it with `await using`. `XynologBrowserConfig`
and `HttpSessionFactory` take a `TimeProvider` and a `Random` for the sign-ins and
sessions they make. `MemoryStorage`
lasts for the process. A shared store implements atomic `Update` and sends
`Subscribe` notifications for writes from other contexts.

Use [browser redirect sign-in](#signing-in-with-a-browser-redirect) to add a signed-in knowledge base.

`LauncherDiscovery` reads the launcher's discovery document through HTTP
or a caller-provided text reader and streams changes by address.

## Annotations

`Xynolog.Annotations.AnnotationTools` reads annotation bodies and selectors,
reconciles a quote against its source, and builds annotations from a whole resource,
plain text, or PDF anchored text. Spans count Unicode code points. `Reconcile` gives a
`ReconciledSpan`, one case for each way the quote was found, and only a fuzzy match names
its `MatchQuality`. `OfSpan` takes that span as it is, or a `TextSpan` found another way.
The builders derive the same ID when they are given the same resource, motivation, span,
and body. They stamp `created` from the `TimeProvider` they are given.

## Testing a composition

`Xynolog.Testing` is part of the SDK assembly. Use `TestSessions.CreateTestSessionAsync`
for a real client and offline session. Call `SetToken` to simulate a live sign-in.
`FaultyTransport` scripts the bus over HTTP and SSE, with a request log and faults
for drops, delays, duplicates, and emit refusal. Queue responses by operation or
provide a `Respond` delegate. Use its `Other` handler for content endpoints.

`Liveness.AssertLivenessAxiomsAsync` runs a fresh composition for each fault schedule
and checks that its output speaks and awaited paths settle within a bounded time, which
it waits out on the `LivenessSpec`'s `TimeProvider`.
`Liveness.AssertExactlyOnceDeliveryAsync` checks that writes survive connection
transitions exactly once. Use a seeded `Random` with `FaultSchedules` and
`DeliveryOps` to replay the generated cases. For registry tests, `ScriptedSessions`
supplies gateway answers, identity and renewal. `TestSessionOptions` and `ScriptedSessions`
take a `TimeProvider` and a `Random` and hand them to the sessions they make. `SharedStorage.Context()` creates
another view of the same storage that hears writes from other contexts.

## The bus and transport

`client.Wire` accepts generated `BusChannels` and `BusOperations` values.
An `HttpTransport` is always given its channels and assumes none of its own: a full
client's is given `BusRegistry.BridgedChannels`, every channel delivered to everyone and
every operation's replies, as `XynologClient` and the sessions give theirs.
`BusRegistry.ReplyChannelsFor(requests)` names the result and failure channels of the
given operations, each once: the channels of a transport that awaits only those.
`BusRegistry.Unsubscribed(channel)` is the refusal of a request whose replies cannot
arrive, and `BusRegistry.PersistedEventTypes` the channels whose events the record keeps.
A typed request returns the channel's declared reply model; a reply whose payload is not
its channel's fails it with a `TransportError` saying "a payload on `<channel>` is not that
channel's: " and the payload's first fault. A typed read gives a `Heard<T>` for each frame:
a `Heard<T>.Delivered`, the frame with its envelope and trace context and its payload
decoded, or, in the place of a frame the transport refused or whose payload is not its
channel's, a `Heard<T>.Refused` holding its `FrameRefusal`. The refusal names the channel,
the `Member` the frame's first fault is at, its way from the frame (`payload.resourceId`,
or `payload` for the payload itself), and the `Reason`, `FrameRefusalReason.Lacks` or
`FrameRefusalReason.Malformed`; it holds the payload as it came, the scope, and the frame's
correlation id whenever that can be read. The read goes on to the frames after it. A scoped
read keeps its resource subscribed until the enumerator ends. A failure whose `code` is none
of the codes `CommandError` names is read with no code, its other members kept, by a typed
read and by the request it answers alike.

A delegation's events tell a refused `job:report-progress`, `job:fail` or `job:complete` as
`JobEvent<T>.Refused`, naming its channel, member and reason: it names no job, is no word of
the job, and starts the silence again neither for the follower nor for a `MarkStateUnit`.

`client.Bus` carries local signals and receives frames from the wire.
Read an existing resource scope through the local bus, or use
`client.Wire.Frames` to hold the scope during the read. Bind initiation and
Beckon hover and sparkle stay local. Beckon attention and its other remote
signals return the gateway's subscriber count when it can count observers.

`Xynolog.Http.HttpTransport` carries SSE frames, emits, and correlated requests. It
supports resource holds, reconnects with per-resource watermarks, event deduplication,
credential renewal, and cancellation. Each frame observer has its own queue; a view of
several channels preserves their delivery order. It holds every frame to `BusFrame` before
it delivers it. `Frames(channel)` and `On(channel, handler)` give each frame as a
`ReceivedBusFrame`, and, in the place of a frame `BusFrame` does not allow whose channel is a
text of at least one character and whose scope is absent or a resource's id, a
`RefusedBusFrame` holding its `FrameRefusal`: both are `Carried`. A request awaiting the reply such a refusal's correlation
id names fails at once with a `TransportError` saying "a frame on `<channel>` is not that
channel's: " and the fault. Any other line the stream carries that is not a frame is told to
`Errors()` as a `TransportError` with no status, saying "the stream carried what is not a
frame: " and its first fault. The stream goes on after either. `HttpContentTransport` uploads multipart
content and reads resource bytes, descriptions, annotations, and anchored text.

The transport accepts a caller-owned `HttpClient`. Its own HTTP handler uses no proxy.
Deadlines and backoffs use the public `TimeProvider` and `Random` constructor arguments;
the defaults are `TimeProvider.System` and `Random.Shared`. Every deadline is the SDK's own
on that `TimeProvider`: an `HttpClient` the SDK makes keeps no `Timeout`, and a caller-owned
one should keep `Timeout.InfiniteTimeSpan`. A stream that fails is opened again after an equal
jitter of a cap that doubles from `reconnectMs` to `maxReconnectMs`, and never sooner than a
refusal's `Retry-After`; once it has been reconnecting for `degradedThresholdMs` its state is
`Degraded`. Disposing the transport ends
its observers and requests and leaves a caller-owned HTTP client usable. Errors share
`Xynolog.Errors.XynologError`, with distinct transport and bus-request families.

HTTP response retries follow the shared boot, transport, and refresh rules.
The transport rule calls a request repeatable when its method cannot cause a second
effect, or when it carries an `Idempotency-Key`, as an upload does.
A repeatable request that got no answer is sent once more after `requestRetryPauseMs`;
one the caller cancelled, or whose deadline passed, is not.
The transport honors a whole-seconds `Retry-After` header. The separate job
retry rule belongs to the worker.

Every emit and every upload carries an `Idempotency-Key` the transport makes once,
and sends unchanged on each of its attempts, including the one after a renewed credential.

`Retry.RetryWithBackoffAsync` does work again until it succeeds, fails in a way its
`retryable` refuses, or the attempts of its `RetryBudget { Attempts, InitialDelayMs, MaxDelayMs }`
run out, and throws the last failure as it was. Each wait is an equal jitter of a cap that doubles from the initial delay to
the maximum, and never shorter than the wait the failure stated. Its optional
`TimeProvider` and `Random` default to `TimeProvider.System` and `Random.Shared`.

## IDs and protocol types

`make generate` writes the models from `protocol/specs/src` into `src/Xynolog/Generated`
(`codegen/lib/csharp_sdk`): sealed records, closed record unions, wire enums, and checked
identifier structs. A schema keyword the models do not read fails generation.

Use `Xynolog.Types` for models and `Xynolog.Identifiers` for identifier kinds. Optional
members are nullable and absent when null. Open objects
retain unknown members as `JsonElement`; dates and URIs retain their wire spelling.
Tests round-trip resolved payloads from the shared wire, live, and worker corpora.

`Xynolog.Session.Identity` derives a knowledge base's DID and token audience
from its domain. It also derives person and agent DIDs from issuer subjects,
encoding each subject as one DID segment.

## Telemetry

Telemetry uses BCL `ActivitySource` and `Meter`; the application chooses its exporter.
`XYNOLOG_BUS_LOG` enables payload logging to stderr, with credentials withheld according
to the shared bus-log table. See [the wire driver](https://github.com/xynolog/sdk/blob/v0.8.2/csharp/sdk/conformance/README.md) for self-contained
builds and black-box conformance.

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

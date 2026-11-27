# Xynolog Haskell SDK

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=haskell-sdk)](https://app.codecov.io/gh/xynolog/sdk/components)

The Haskell SDK implements Xynolog's client and protocol contracts with `IO`,
STM observations and scoped streams. It provides all eleven client namespaces,
live queries and durable caches, typed delegation, uploads, claims, held jobs and
durable worker commits. Device, redirect, kept-grant and service-account sign-in
share real sessions with token renewal and late-refusal handling.

The SDK also provides the knowledge-base registry, all ten state units, launcher
and HTTP discovery, annotation readers/builders, principal identity helpers and
consumer testing tools. The shared live, wire and worker conformance suites run
against its public API.

[Install](#install) · [A first program](#a-first-program) ·
[Signing in](#signing-in) · [Connect](#connect) ·
[Delegation](#delegation) · [Live queries](#live-queries) ·
[Running a worker](#running-a-worker)

## Install

Add `xynolog` to your package's `build-depends`:

```cabal
build-depends: xynolog
```

Below 1.0 the minor number is the break, so take releases up to the next
minor: `xynolog ^>=<version>`, where `<version>` is a release's, takes that
release and the later ones of its minor.

## A first program

This connects to a knowledge base with an access token you already hold and
prints the knowledge base's name. Give it the knowledge base's URL and the
token as its two arguments. [Signing in](#signing-in) is how a program comes
to hold a token, and [Connect](#connect) says what each option is for.

```haskell
module Main (main) where

import Control.Concurrent (threadDelay)
import Control.Exception (bracket)
import Control.Monad (when)
import qualified Data.Set as Set
import qualified Data.Text as Text
import qualified Data.Text.IO as Text
import qualified Data.UUID.V4 as UUID
import GHC.Clock (getMonotonicTimeNSec)
import Network.HTTP.Client (noProxy)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import System.Environment (getArgs)
import System.Random (randomRIO)
import qualified Xynolog.Browse as Browse
import Xynolog.Channels (globalChannels)
import qualified Xynolog.Client as Client
import qualified Xynolog.Http as Http
import Xynolog.Retry (RetryOptions (..))
import Xynolog.Timing.Settings (protocolClientTiming, protocolTransportTiming)
import Xynolog.Types (KbDescription (..))

main :: IO ()
main = do
  [url, token] <- map Text.pack <$> getArgs
  pool <- Http.newHttpClient noProxy tlsManagerSettings
  let options =
        Http.HttpOptions
          { Http.httpBaseUrl = url,
            Http.httpClient = pool,
            Http.httpToken = pure (Just token),
            Http.httpRenewToken = const (pure Nothing),
            Http.httpTime = RetryOptions now waitUntil (randomRIO (0, 1)),
            Http.httpTiming = protocolTransportTiming,
            Http.httpNewId = UUID.nextRandom,
            Http.httpGlobalChannels = Set.fromList globalChannels,
            Http.httpLoadPositions = pure mempty,
            Http.httpSavePosition = \_ _ -> pure ()
          }
  described <- bracket (Client.fromHttp options protocolClientTiming Nothing) Client.dispose (Browse.kb . Client.browse)
  Text.putStrLn (kbDescriptionName described)

now :: IO Integer
now = toInteger <$> getMonotonicTimeNSec

waitUntil :: Integer -> IO ()
waitUntil due = do
  current <- now
  when (current < due) $ do
    threadDelay (fromInteger (min (toInteger (maxBound :: Int)) ((due - current + 999) `div` 1000)))
    waitUntil due
```

It also needs `containers`, `text`, `http-client`, `http-client-tls`, `uuid`
and `random` in its `build-depends`, and `-threaded` in its `ghc-options`.

## Signing in

`Xynolog.Issuer` discovers the issuer from a knowledge base's resource metadata.
`signInWithDeviceGrant` reports the approval code to your callback and polls at
the issuer's interval. `beginAuthorization` saves PKCE/state and returns the
URL to navigate to; `completeAuthorization` consumes the callback once and
returns the pending identity and issued tokens. Both use the application's
HTTP pool and controlled clock. The client ids and scope come from the shared
OAuth registration table.

`Xynolog.Session.signInDevice` opens a client/session from a device grant.
`Session.signOut http kept` signs out of a kept sign-in: it revokes the refresh
token at the issuer where the sign-in names a revocation endpoint, forgets the
sign-in however that went, and says whether the issuer revoked it.
`fromIssuedSession` persists an already issued grant and installs its rotating
refresh callback. `SessionOptions` carries the knowledge base, typed kept grant, wall
clock and host callbacks; provide `sessionValidate` to confirm a person with
the supplied client and token. A service can omit that callback. `ready` waits for startup;
`token`, `user` and `streamState` are read-only observations. Refusals that arrive
together share one renewal. An issuer refusal forgets the grant; an outage
keeps it and retries with reconnect backoff. What goes wrong, the session's
own errors and its transport's failures, is said once each on `errors`, one
stream in the order met. A session is its transport's first reader when
nobody has read that transport's failures before it is made, and then says
what the transport kept for it as it is made. The first reader of `errors` is given the latest
`errorsKeptForFirstReaderCount` (`Xynolog.Timing`) said before it came, in
that order, the oldest beyond them dropped, and what is still kept when
`errors` ends is dropped: a reader who comes after is given nothing. Disposing a session
joins its work, ends `errors` and leaves its client open, and once its client
has closed, ends `errors` after what that client's transport said;
`closeOpenedSession` closes the client first, its closing flush done, then
ends the session, so what the flush meets is said before `errors` ends. A
registry reads each session's `errors` itself: a refusal for want of a valid
token is renewed by the transport that met it, and the registry does nothing
with it. Closing a registry closes its sessions before the rest of its work,
reading each one's `errors` to their end, so what a closing flush meets is
said on the registry's `errors` before they end. The registry's `errors` keep
for their first reader as a session's do, and drop what they kept as they end.

```haskell
module DeviceSignIn where
import Control.Exception (bracket)
import qualified Xynolog.Http as Http
import qualified Xynolog.Session as Session
import Xynolog.Timing.Settings (ClientTiming)
import Xynolog.Types (DeviceCode)

withDeviceSession :: Http.HttpOptions -> ClientTiming -> Session.SessionOptions
  -> (DeviceCode -> IO ()) -> (Session.Session -> IO result) -> IO result
withDeviceSession http timing options showCode use =
  bracket (Session.signInDevice http timing Nothing options showCode)
    Session.closeOpenedSession (use . Session.openedSession)
```

`Xynolog.SessionStorage.newMemoryStorage` keeps one context's text values;
applications can implement `SessionStorage` for their own storage.
`Registry.Stored.keptIn storage kbId` is that knowledge base’s typed
`KeptSignIn`; `SignIn.newMemorySignIn` is one independent in-memory grant.
Its `update` transforms and returns a result atomically, so redirect completion
and refresh rotation cannot overwrite another writer. The shared
[sign-in guide](https://github.com/xynolog/docs/blob/main/builder/SIGN-IN.md) describes the flows.

`Xynolog.ServiceToken` performs a lazy client-credentials grant with a secret
or RSA key. It discovers the token endpoint once and keeps each opaque access
token only for the lifetime the issuer stated. Key grants carry a fresh RS256
assertion, with the shared RFC 7638 thumbprint and claims; the private key stays
in the process. `Xynolog.ClientAssertion.privateKeyFromPem` reads one unencrypted
PKCS#8 RSA key and refuses other key formats without echoing their contents.

```haskell
module ServiceAccount where
import Control.Exception (bracket)
import Data.ByteString (ByteString)
import Data.Scientific (Scientific)
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Xynolog.ClientAssertion as Assertion
import qualified Xynolog.Issuer as Issuer
import qualified Xynolog.ServiceToken as Service

withAccount :: Issuer.IssuerOptions -> Text -> Text -> ByteString
  -> IO Scientific -> (Service.ServiceToken -> IO result) -> IO result
withAccount options authority clientId pem wallNow use = do
  key <- either (ioError . userError . Text.unpack) pure
    (Assertion.privateKeyFromPem pem)
  bracket (Service.newServiceTokenKey options authority clientId key wallNow)
    Service.dispose use
```

`Session.signInAgent http timing options service` opens a session for that
account and keeps the DID the gateway actually returned; it keeps no caches. It
signs in once: a failure is thrown as it came, and starting the sign-in again
is the service's, on its own backoff. The service token
remains owned by its caller. Each renewal is handed the token it renews: the
one held, expired or not, at the start the stored one though it has expired,
and after a renewal that got no answer, the one that renewal was for;
`Auth.me auth (Just token)` validates an explicit credential in one attempt,
without renewing or quarantining the inherited token. `Auth.me auth Nothing`
uses the client's own token and retry policy.

`Xynolog.SignInStore` reads the launcher's `tokens.json`, preserving unknown
members and refusing to overwrite a corrupt document. `stateDirectory` runs the
shared platform rules on directory values supplied by the application; the SDK
reads no environment. `signInFileName` is the file name below that directory.
The store keeps its directory to its owner and takes the shared native lock
for each atomic read/change/write. Its options take your clock, positive lock
retry interval and wall-clock reading. All three grant backends preserve a
concurrent renewal or sign-out; token comparison is shared.

```haskell
module KeptSignIn where
import Control.Exception (bracket)
import qualified Xynolog.Http as Http
import qualified Xynolog.Session as Session
import qualified Xynolog.SignInStore as Store
import Xynolog.Timing.Settings (ClientTiming)
import Xynolog.Types (kbTargetId)

withKeptSession :: Http.HttpOptions -> ClientTiming -> Session.SessionOptions
  -> Store.SignInStoreOptions -> FilePath
  -> (Session.Session -> IO result) -> IO result
withKeptSession http timing options storeOptions filename use = do
  store <- Store.newSignInStore storeOptions filename
  let actual = options { Session.sessionKept =
        Store.entry store (kbTargetId (Session.sessionKb options)) }
  bracket (Session.fromKeptSession http timing Nothing actual)
    Session.closeOpenedSession (use . Session.openedSession)
```

## Connect

Build a reusable HTTP pool with `Xynolog.Http.newHttpClient`, supplying an
explicit proxy policy and your `http-client` `ManagerSettings`. For example,
`newHttpClient noProxy tlsManagerSettings` uses your TLS settings without an
environment-selected proxy; `tlsManagerSettings` is supplied by
`http-client-tls`. The pool disables implicit retries and response timeouts so
Xynolog owns its attempt budgets and deadlines. A transport never closes the
caller's pool. Its active requests and response scopes end on disposal.

Supply the pool through `HttpOptions`, together with the base URL, token reader,
refused-token renewal action, fresh UUID action, global channel profile, monotonic
clock/wait/jitter actions, the transport's timing, and replay-position load/save
actions. `Client.fromHttp` also takes the client's timing.
`Xynolog.Timing.Settings` holds the two records of what you may set,
`ClientTiming` and `TransportTiming`, with the protocol's values of them
(`protocolClientTiming`, `protocolTransportTiming`); its `withOverrides` applies
a JSON object to one record and refuses a name the record does not hold. Every
other timing is a constant of `Xynolog.Timing`. Use
`Xynolog.Channels.globalChannels` for a full client. All these choices are
explicit. `Client.fromHttp` builds the bus, content and gateway adapters with
the same clock and ID source. Keep the client scoped:

```haskell
module HttpConnection (withConnection) where

import Control.Exception (bracket)
import Xynolog.Client (Client, fromHttp, dispose)
import Xynolog.Http (HttpOptions)
import Xynolog.Timing.Settings (ClientTiming)

withConnection :: HttpOptions -> ClientTiming -> (Client -> IO result) -> IO result
withConnection options timing = bracket (fromHttp options timing Nothing) dispose
```

`Client.newClient` also accepts independently supplied bus/content adapters and
an optional gateway. Each client constructs and bridges its own local bus.
Disposal stops refresh and cache work, closes transport and content operations,
and completes the local bus. `Client.wire` is its typed wire bus; the namespace
getters include `Client.browse`, `Client.gather` and `Client.match`.

HTTP content supports scoped binary streams, buffered binary reads, metadata,
annotations and anchored text. Uploads take generated `ResourceUploadMetadata`
and a `ReplayableBody`; `bytesBody` builds a byte source. A source opens again
when a refused credential is renewed. Its idempotency key stays the same and
progress never decreases across replay. An upload reports `UploadStarted` with
the body's size, 0 for a body of unknown length, before any bytes are sent;
`UploadProgress` as they are sent; and `UploadFinished` with the resource the
gateway's answer names. One that fails reports no resource. A stream retained
beyond its callback refuses further reads.

## Eight verbs

The Haskell client implements the
[client surface](https://github.com/xynolog/protocol/blob/main/specs/src/client/surface.json), with typed
channel and operation descriptors in `Xynolog.Channels`.
All methods of Frame, Bind, Beckon, Browse, Gather, Match, Mark, Yield, Job,
Auth and System are available. See the
[builder guide](https://github.com/xynolog/docs/blob/main/builder/README.md) for the shared model.

## Delegation

`Mark.delegate` and `Yield.delegate` create and follow typed jobs. Each returns
an opaque `Running (JobEvent completion) completion`: a mark job completes with
`MarkJobCompleteCommand`, and a yield job with `YieldJobCompleteCommand`.

```haskell
module DelegateMarks (runMarks) where

import qualified Xynolog.Client as Client
import qualified Xynolog.Mark as Mark
import qualified Xynolog.Running as Running
import Xynolog.Types (ResourceId, MarkJobParams, MarkJobCompleteCommand)

runMarks :: Client.Client -> ResourceId -> MarkJobParams -> IO MarkJobCompleteCommand
runMarks client identity params =
  Mark.delegate (Client.mark client) identity params >>= Running.await
```

The first report names the created job. Progress and retryable failures follow;
the final report carries its completion. A final failure or cancellation raises
`JobError` with the shared job code. After silence the follower asks for status;
progress restarts that interval, and a retryable failure parks polling until the
next attempt speaks. Early frames wait behind creation, and a completion of
another verb is refused. Following a job acquires no resource subscription.
A malformed lifecycle frame produces a `Refused` report with its channel, fault
path and reason. It neither completes the job nor resets silence or stall time.

Yield's silence guard derives from the requested token budget and the protocol
floor, or accepts an explicit per-call deadline. Each progress or retryable
failure restarts it. On expiry it requests cancellation of the known job and
raises `job.stalled`. `Yield.resource` returns `Running UploadEvent ResourceId`,
reporting started, byte progress and finished; abandoning its reader cancels
the upload.

Constructing an operation starts no work. `await` starts it and returns its
terminal result; `withReports` instead supplies a `Stream (Of report) IO result`
from the `streaming` package. Only one consumer may start an operation, once.
Producer failures propagate to the consumer. Leaving `withReports` cancels
and joins the producer, and a stream retained past that scope refuses reads.

## Live queries

`Xynolog.Cache` provides lazy read-through queries with three outcomes:
`Pending`, `Ready value`, and `Failed exception`. `Cache.query` is pure;
`Cache.watch` starts a scoped live observation, and `Cache.fresh` forces a
one-shot read. Concurrent readers share a fetch. Invalidation keeps a stale
value visible, retries a failed background read once, and prevents an obsolete
response from overwriting a newer value.

```haskell
module CachedReads (nameCache, readName) where

import Data.Text (Text)
import qualified Xynolog.Cache as Cache

nameCache :: (Text -> IO Text) -> IO Integer -> (Integer -> IO ())
          -> IO (Cache.Cache Text Text)
nameCache reader monotonic waitUntil = Cache.newCache reader Cache.CacheOptions
  { Cache.cacheNow = monotonic
  , Cache.cacheWaitUntil = waitUntil
  , Cache.cachePersister = Nothing
  , Cache.cacheScope = const (pure (pure ()))
  }

readName :: Cache.Cache Text Text -> Text -> IO Text
readName cache key = Cache.fresh (Cache.query cache key)
```

The clock actions count monotonic nanoseconds and use the same coordinate
system. An optional `CachePersister` restores settled values, revalidates each
on first observation, debounces saves, and flushes on `dispose`. Failure
markers are never saved. `persistencePending` remains true while a fetch or
unsaved content could let a resumption bookmark lead its document. Dispose
cancels and joins owned work and completes readers.

`Browse.resource`, `Browse.annotations`, `Browse.annotation`, `Browse.events`,
`Browse.resources`, `Browse.entityTypes`, `Browse.tagSchemas`, `Browse.engines`,
`Gather.referencedBy` and `Match.resources` return live queries. Scoped
observations hold the resource subscription until their callback returns. The
shared event refresh table applies before request continuations run, coalesces
repeated invalidations, writes known annotation values, and refreshes the held
global queries when a dropped connection reopens. Engines retain their job
assignments and gain each inference service's limits as those arrive.

```haskell
module ResourceNames (readResourceName) where

import Data.Text (Text)
import qualified Xynolog.Browse as Browse
import qualified Xynolog.Cache as Cache
import qualified Xynolog.Client as Client
import Xynolog.Types (ResourceId, resourceDescriptorName)

readResourceName :: Client.Client -> ResourceId -> IO Text
readResourceName client identity =
  resourceDescriptorName <$> Cache.fresh (Browse.resource (Client.browse client) identity)
```

`Gather.annotation` and `Match.search` return lazy `Running` operations.
`Gather.resource` returns a complete `GatheredContext`. Buffered text reads use
the media registry, MIME charset and byte-order mark rules; PDF text is read
through `Browse.resourceAnchoredText`, and binary content through
`Browse.resourceRepresentation` or its scoped stream.

Persisted query documents and replay bookmarks share the application storage.
Query behavior follows the
[cache contract](https://github.com/xynolog/protocol/blob/main/contract/CACHE-SEMANTICS.md).

## State units

`Xynolog.State.Mark`, `Yield`, `Gather`, `Match` and `Beckon` coordinate the
client signals and expose read-only state. `HoverDwell` waits for a pointer to
rest; `Search` debounces typed queries and joins the search it replaces.
`SessionSignals` holds host notices beside a session. The cache and session
are state units too. Each has an idempotent `dispose` that joins its work and
ends its observations without disposing the borrowed client. See
[State units](https://github.com/xynolog/docs/blob/main/builder/STATE-UNITS.md).

Mark and hover take the caller's `RetryOptions`; search takes it with an
explicit debounce and initial query. Mark says a job quiet after
`delegateSilenceMs` (`Xynolog.Timing`). No state unit reads an ambient timer. Job creation is
queued in invocation order within a unit; once a creation is answered, the next
can start while the earlier job remains followed.


```haskell
{-# LANGUAGE OverloadedStrings #-}
module ResourceSearch where
import Control.Exception (bracket)
import qualified Xynolog.Cache as Cache
import qualified Xynolog.Client as Client
import qualified Xynolog.Match as Match
import Xynolog.Retry (RetryOptions)
import qualified Xynolog.State.Search as Search
import qualified Xynolog.Timing as Timing
import Xynolog.Types (ResourceDescriptor, matchResourcesResponseResources)
import qualified Streaming.Prelude as Stream

withResourceSearch :: Client.Client -> RetryOptions
  -> (Search.SearchPipeline ResourceDescriptor -> IO result) -> IO result
withResourceSearch client clock = bracket
  (Search.newSearchPipeline clock
    Timing.searchDebounceMs "" source)
  Search.dispose
  where
    source text publish = Cache.watch
      (Match.resources (Client.match client) text Nothing)
      (Stream.mapM_ (publish . fmap matchResourcesResponseResources . Cache.readyValue))
```

Use `Search.setQuery` as input changes and observe `Search.state`. This example
also needs `streaming` in its `build-depends`.

Cache persistence is opt-in, and kept for a person. Give a session builder
such as `Session.fromKeptSession` `Just storage` in place of `Nothing`, and its
client keeps under `session/stored.json`'s keys for the knowledge base and the
person the kept sign-in names (their key is the unpadded base64url SHA-256 of
their DID): from the start when the sign-in names them already, or, with a
validate callback, once the gateway has said who the token is and the sign-in
has recorded it. Each write is checked against the sign-in and made in
one step: once the sign-in is forgotten, or names nobody or another person,
nothing more is written, so no write puts back what forgetting deleted.
Forgetting a sign-in, or replacing it, deletes what was kept for the person it
named. A sign-in that cannot be read for that check, or cannot record the
person, is said once on the session's errors as `session.keep-failed`, and
nothing more is kept. Each write the storage refuses is said there as
`session.save-refused`, and stays owed to the next change or the closing flush.
A client you build yourself keeps for one person once given
`Client.CachePersistence storage kbId personKey wallMilliseconds`, at
construction or later with `Client.keepIn`; persisted values are available
before gateway revalidation.
The queries `session/stored.json` keeps (resource details, annotation lists and
details, entity types and tag schemas) rehydrate immediately, each from one
cache document that every SDK writes and reads alike. The first observation
revalidates each restored key. Each entry's stamp is the wall clock rounded to a
whole millisecond, kept while its value is unchanged; a document over the shared
UTF-8 byte cap loses its oldest entries. Where the stream was is written in the
same call as a cache document, and only while every kept view has no fetch in
flight and owes no save and no refresh window owes an invalidation. Disposal
reads that gate once, before anything is disposed: a fetch in flight or an owed
invalidation holds the places back from the final cache saves, and an owed save
does not, since those saves are it. So a reload may replay extra events and
cannot skip an unfinished update.

## Building annotations

`Xynolog.Annotations` reads the generated annotation types without narrowing
single bodies, body lists, resource targets, or selector lists. Its builders
produce the same deterministic annotation IDs as the other SDKs. Reconciliation
and every span offset count Unicode code points, including characters outside
the basic multilingual plane. PDF spans use the anchored text's page rectangles.
`reconcile` finds a quote's words and says how, as the branch of
`ReconciledSpan` its anchor method names; only a fuzzy match carries a
`MatchQuality`. `textSpanOf` is the span it found, as `annotationOfSpan` takes
one. A worker that finds its spans another
way builds the `TextSpan` itself.

```haskell
{-# LANGUAGE OverloadedStrings #-}
module BuiltAnnotation where
import Data.Time (UTCTime)
import Xynolog.Types
import qualified Xynolog.Annotations as Annotations

highlight :: IO UTCTime -> ResourceId -> Agent -> IO (Maybe Annotation)
highlight wall resource generator =
  case Annotations.reconcile "Ada Lovelace wrote the first algorithm."
    (QuotedText "Ada Lovelace" Nothing Nothing) of
    Nothing -> pure Nothing
    Just found -> Just <$> Annotations.annotationOfSpan wall
      (Annotations.TextContent "Ada Lovelace wrote the first algorithm.")
      (Annotations.textSpanOf found) resource MotivationHighlighting generator Nothing
```

Set the existing cross-SDK `XYNOLOG_BUS_LOG` switch to a nonempty value to
write HTTP transport frames and content operations to stderr. Payload credentials
are recursively replaced with `[withheld]`; the logger does not print headers.

## Running a worker

`Xynolog.JobFilter.jobMatchesFilter` compares a typed `JobFilter` with a job's
JSON representation, including queued events and claimed job descriptions.
It compares every field the filter states at the same path; other fields do
not affect the match. `Xynolog.Claims.willRetryAfter` takes the job's metadata
before applying a failure and its optional `FailureClass`. Its answer follows
the shared job retry cases: deterministic and withheld failures do not retry;
transient and unclassified failures retry while the record has budget left.

`Xynolog.Claims.jobClaimChannels` and `jobCommitChannels` give a worker the
channels to subscribe to for claiming and committing. They are generated from
the existing SDK's worker channel declarations and the typed bus descriptors.

`Xynolog.Worker` claims one job at a time. `newClaims` is lazy: the first
`next` starts claiming, and the worker claims again after settlement, a
matching announcement while idle, or a stream reopening. Bracket it with
`stop` so a job still held when the worker stops is failed for retry before
the transport closes.

```haskell
{-# LANGUAGE GADTs #-}
module WorkerExample where

import Control.Exception (bracket)
import qualified Xynolog.Client as Client
import qualified Xynolog.Job as Job
import qualified Xynolog.Worker as Worker
import Xynolog.Types (ClaimOptions, MarkJobResult, YieldJobResult)

runWorker :: Client.Client -> ClaimOptions
  -> (Worker.HeldJob MarkJobResult -> IO MarkJobResult)
  -> (Worker.HeldJob YieldJobResult -> IO YieldJobResult)
  -> IO ()
runWorker client options mark yield =
  bracket (Job.claim (Client.job client) options) Worker.stop loop
  where
    loop claims = do
      next <- Worker.next claims
      case next of
        Nothing -> pure ()
        Just (Worker.HeldMark job) -> do
          Worker.start job
          mark job >>= Worker.complete job
          loop claims
        Just (Worker.HeldYield job) -> do
          Worker.start job
          yield job >>= Worker.complete job
          loop claims
```

`ClaimOptions`, the type Protocol states, supplies a nonempty list of
generated filters and any of the claims' waits to set; each it leaves out is
the constant of `Xynolog.Timing` of that name. The claims take their clock from
the client. The transport
must subscribe to `jobClaimChannels`, plus `jobCommitChannels` when the worker
commits annotations.

A held job exposes the claimed record's identity, parameters, retry budget,
completed units and unit cursors. Its `cancelled` and `settled` observations
are read-only STM actions. The worker's code watches cancellation and calls
`cancel` after its work has stopped. `progress` and `checkpoint` report activity;
`complete`, `fail` and `cancel` settle once, releasing the job even if sending
the outcome fails. A mark job's completion accepts only `MarkJobResult`, and a
yield job's only `YieldJobResult`.

`commit` waits for the record's acknowledgement. If it times out, it probes
the batch's last annotation once instead of sending the batch again. Settlement
reports the weakest durability evidence observed. Supply stable annotation ids
across attempts, and count a unit completed only after its commit is established.

Use the scoped `refused` and `stalled` streams for faults the host must judge,
and `vitals` for activity snapshots. An empty queue is not a refusal. Each
stream's first reader is given the latest `errorsKeptForFirstReaderCount` said
before it came, in that order; what is still kept when the claims stop is
dropped. `trace`
exposes the carrier that handed over the job; a host exporting telemetry uses
that carrier as the parent of its own job span. Claims start outside the trace
of the previous job. The shared
[worker contract](https://github.com/xynolog/protocol/blob/main/contract/WORKER-CONTRACT.md) states these
lifetimes and observations.

## Several knowledge bases

`Xynolog.HostName.isValidHostname` checks the host names an HTTP endpoint may
use. `Xynolog.Gateway.gatewayUrl` validates a typed `HttpEndpoint` and returns
its origin, with the host in lowercase and an explicit port. Invalid host
names are refused before they become part of a URL.

`Xynolog.Discovery` reads a launcher's entire document and distinguishes an
absent launcher from one managing no knowledge bases. Its types and absent
reasons are derived from the protocol. Use `textDiscovery` over an application
reader, for example a launcher file:

```haskell
module Main (main) where

import qualified Data.Text.IO as Text
import Xynolog.Discovery (readDiscovery, textDiscovery)

main :: IO ()
main = do
  found <- readDiscovery
    (textDiscovery (Text.readFile "/path/to/launcher-state/discovery/kbs.json"))
  print found
```

This program also needs `text` in its `build-depends`. `discoveryDiff` compares
entries by address, keeps separate copies with the same DID, and reports
duplicate address claims. `subscribeDiscovery` polls with the monotonic time,
interruptible absolute wait, and interval supplied through `DiscoveryOptions`.
Stopping consumption leaves no polling task running.

`Xynolog.Http.Discovery.httpDiscovery` reads discovery over HTTP with the
caller's pool and controlled clock. Reading a discovery document does not
sign in to any of its knowledge bases.

`Xynolog.Registry.newXynologBrowser` manages registered knowledge bases,
selection, sign-in, per-KB tabs and the last viewed resource. Give it a
`XynologBrowserConfig` with storage, a `SessionFactory`, HTTP options, the
timing of the clients it makes and an epoch-seconds wall reader. `newHttpSessionFactory` opens real HTTP sessions
and opts their queries into per-KB durable storage. The browser closes the
previous client before opening the next, joins stale activations, and raises
identity-conflict notices when the address answers as a different KB. A
redirect sign-in proves the responding identity before adopting its grant.
Use `beginSignIn` and `completeSignIn`; navigation remains the host's job.
Removing an entry also removes its owned cache documents and replay bookmark.
The supplied storage belongs to one principal's profile, including its tokens,
tabs and caches. Close the browser and switch storage when changing profiles.


```haskell
module KnowledgeBases where
import Control.Exception (bracket)
import Data.Scientific (Scientific)
import qualified Xynolog.Http as Http
import qualified Xynolog.Registry as Registry
import qualified Xynolog.SessionStorage as Storage
import Xynolog.Timing.Settings (ClientTiming)

withKnowledgeBases :: Storage.SessionStorage -> Http.HttpOptions -> ClientTiming
  -> IO Scientific -> (Registry.XynologBrowser -> IO result) -> IO result
withKnowledgeBases storage http timing wall = bracket
  (Registry.newXynologBrowser (Registry.XynologBrowserConfig storage
    (Registry.newHttpSessionFactory http timing wall) http timing wall))
  Registry.dispose
```

`wall` returns epoch seconds. This example also needs `scientific` in its
`build-depends`. Observe `Registry.kbs`, `activeKbId`, `activeSession` and
`activeSignals`, and call `setActiveKb` to select an entry.

## IDs and protocol types

Import models from `Xynolog.Types`. Distinct identifier types expose checked
makers such as `mkResourceId`; their constructors are hidden. JSON decoders
apply the same protocol constraints. Optional properties use `Maybe`, and are
absent or a value.

`Xynolog.Resources` reads a descriptor's primary representation, primary media
type and entity types. Representation order decides which is primary; media
types retain their case and parameters.

Records preserve extra members when their schema permits them. Closed enums
and unions are algebraic types. JSON numbers use `Integer` or `Scientific`,
and date and URI values retain their `Text` spelling.

`Xynolog.Channels` provides GADT descriptors. Each channel has its own payload
type and scope kind; each operation fixes its request, result, and failure
types. The typed bus requires `InScope resourceId` when observing a
resource-scoped channel.

## Errors and retry

`Xynolog.ErrorCodes` derives closed error vocabularies and wire/HTTP status
classifiers from the protocol. `Xynolog.Timing` derives the timing constants
and retry budgets.

`Xynolog.Retry` provides retry decisions, `Retry-After` parsing, and
`retryWithBackoff`. Its `RetryOptions` requires caller-supplied monotonic
nanoseconds, an interruptible wait to an absolute deadline, and non-secret
jitter. Cancellation is preserved, each retry respects the server's stated
wait, and the last failure is raised when the budget is exhausted.

## The bus and transport

Every `ContentTransport` read and upload takes `Maybe Text` immediately after
the transport. `Nothing` uses its held credential and normal renewal policy.
`Just accessToken` makes one explicit-credential attempt; refusal never renews
or quarantines the held credential. Scoped streams and replayable uploads keep
the same ownership rules in either mode.

`Xynolog.Transport.newTransport` gives a carrier its input handle and the
transport its consumers use. The carrier supplies sending and teardown, feeds
received frames through `receive`, frame refusals through `receiveRefusal`, and publishes valid connection transitions
through `setState`. Its subscription snapshot contains the current resource
holds and pending correlations. `Xynolog.StateValue` exposes state observations
without a public setter.

Build a `Xynolog.Bus` with `newBus`, a transport, and `BusOptions`. The options
supply monotonic time, an interruptible absolute wait, and fresh correlation
IDs. Each request waits for the stream to open, tracks its reply before sending,
emits once, and ends on a reply, deadline, cancellation, or transport close.
For example, given a bus and a typed command:

```haskell
module ProtocolCalls (addEntityType) where

import qualified Xynolog.Bus as Bus
import qualified Xynolog.Channels as Channels
import qualified Xynolog.Timing as Timing
import Xynolog.Types (EmptyBusPayload, FrameAddEntityTypeCommand)

addEntityType :: Bus.Bus -> FrameAddEntityTypeCommand -> IO EmptyBusPayload
addEntityType wire command =
  Bus.request wire Channels.FrameAddEntityTypeOperation command
    Timing.busRequestTimeoutMs
```

`Bus.frames` requires `InScope resourceId` for a resource channel and holds that
scope until its reader leaves. It yields `Heard delivered` or `Refused refusal`
in order, and continues after a refusal. Deliveries retain their emitter,
envelope, and trace. A refusal is Protocol's `FrameRefusal`: the channel, the
`member` path, its `Lacks` or `Malformed` reason, and the optional raw
payload, scope and readable correlation ID. Successful HTTP answers and stream
frames are checked against the same generated rules that the other SDKs use;
a diagnostic never includes the rejected value. The trace field is lifted out
of the payload.

`Xynolog.EventBus` is the client's separate local plane. A transport bridge
publishes raw replies there before request continuations can emit derived
signals. Detach a bridge through its returned release action. Closing a
transport completes its observations, ends pending requests, and joins its
callback workers; closing from one of those callbacks does not join itself.

The HTTP adapter reconnects with bounded backoff, drains the old stream during
scope handoffs, deduplicates overlap, and loads/saves per-resource replay
positions through the supplied callbacks. Credential renewal receives the
refused token; a credential refused again is quarantined until the host supplies
a usable one. Ordinary reads retry once when eligible, and an unanswered request
at its own deadline fails without another attempt.

Raw transport and local-bus readers receive `Carried`: `Arrived frame` or
`FrameRejected refusal`. `stream` and `on` expose the corresponding
`Either FrameRefusal Object`. Malformed envelopes with a usable channel and
scope reach those readers and any request identified by their correlation ID.
An invalid scope or unusable channel reaches the transport error report. A
typed reader names payload faults from the frame, such as `payload.resourceId`.
`errors` reports each failure the transport meets, in the order met, and keeps
for its first reader as a session's `errors` do: the latest
`errorsKeptForFirstReaderCount` met before that reader came, the oldest beyond
them dropped, and nothing once the transport has closed.
A renewed emit credential starts a fresh retry budget and backoff.

## Telemetry

The SDK uses the application's OpenTelemetry tracer/meter providers and text-map
propagator. It creates no provider or exporter. Bus sends and receives, uploads,
and content reads record the spans and counter declared by the shared telemetry
table. Outgoing HTTP requests carry the host's injected headers; incoming frames
are processed under its extracted context. Caller context also crosses request
work, operation producers and callback tasks using the standard propagation API.


## Testing applications

`Xynolog.Testing.Transport` scripts answers and faults around the real native
carrier. Give it the global channels it carries, `Xynolog.Channels.globalChannels`
for a full client; like the HTTP transport, it adds the resource-scoped channels
in the scopes it holds and delivers a frame on no other. Queue typed JSON
responses by operation; requests left unscripted fail by name. A dropped reply
still consumes the peer's answer. `SharedStorage`
gives several contexts atomic access to the same values and notifies only other
contexts. `createTestSession` builds a real session over a supplied real client.
`ScriptedSessions` supplies a registry factory and records its transports,
renewals and revocations; script its users, answers and renewal results explicitly.

`Xynolog.Testing.Liveness` supplies QuickCheck generators and executable L1/L2/L3
checks. Give `assertLivenessAxioms` QuickCheck arguments and a `LivenessSpec`
with the composition, timeout, retry budget, case count, fault generator,
responder and controlled clock. Outputs must reach a value or a failure;
awaited paths must settle within the bound, and retries must stay within budget.
`assertExactlyOnceDelivery` drives a supplied `DeliverySubject` through generated
writes and transitions and checks each written ID was delivered once.
Use the caller's clock for those waits; real sockets can use an actual host clock.

## License

[Apache-2.0](https://github.com/xynolog/sdk/blob/v0.8.2/haskell/sdk/LICENSE).

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

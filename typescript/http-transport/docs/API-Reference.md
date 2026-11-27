# `@xynolog/http-transport` Reference

`@xynolog/http-transport` ships the HTTP-specific implementations of the transport contracts in `@xynolog/core`. The developer-facing surface (`XynologClient`, the verb namespaces, sessions, state units) lives in `@xynolog/sdk`. This doc covers the HTTP adapters only.

For the namespace-level API tour, see [docs' `builder/Usage.md`](https://github.com/xynolog/docs/blob/main/builder/Usage.md).

## `HttpTransport`

`new HttpTransport(config)`. Implements `ITransport` and `IGatewayOperations` from `@xynolog/core`. Owns the SSE bus connection, HTTP `/bus/emit`, and the auth/health/status REST surface that crosses the remote boundary.

### `HttpTransportConfig`

Defined, field by field, in [`src/transport/http-transport.ts`](../src/transport/http-transport.ts). `baseUrl` and `channels` are required.

- **`token$`** is where the transport reads the current token. A new token pushed into it is used from the next request on.
- **`tokenRefresher`** is asked for a new token when the gateway refuses one (below).
- **`channels`** are the global channels the stream names; the transport assumes none of its own. A full client gives it `BRIDGED_CHANNELS`. A worker that awaits only some operations names their reply channels, and is sent nothing else.
- **`loadLastEventIds`** and **`saveLastEventId`** let a client resume its stream where its last life stopped.
- **`logger`** receives what the transport logs: see [Logging](./LOGGING.md).
- **`fetch`** is what every request is sent with: the stream's connects, the emits, the plain operations and the content transport's requests, but a browser page's upload with progress or a `signal`, which goes through `XMLHttpRequest`. Absent, the runtime's own. The certificates trusted and the proxy are the fetch's: see [The fetch it sends with](../README.md#the-fetch-it-sends-with).
- **`timing`** is what of the transport's timing differs from `DEFAULT_TRANSPORT_TIMING`: any members of `TransportTiming`, which `@xynolog/core` exports, each the entry of [`protocol/specs/src/client/timing.json`](https://github.com/xynolog/protocol/blob/main/specs/src/client/timing.json) of its name. A member left out has the table's value.
  - **`httpRequestTimeoutMs`** bounds a plain request, and the read of any refusal's body, the stream's among them: a body not read by then is a refusal with none of the gateway's words. One is made a second time at most once, after `REQUEST_RETRY_PAUSE_MS`, when `RETRY_RULES.transport` approves its status, its method and whether it carries an `Idempotency-Key`, with or without a `tokenRefresher`.
  - **`streamOpenTimeoutMs`** bounds the wait for the gateway to answer the request that opens the stream: its status and headers. An open unanswered by then has failed, and the stream is opened again on the backoff, as after any open that failed. An open the gateway refuses has its body read within `httpRequestTimeoutMs`. An open stream that carries nothing for a while has not failed.
  - **`emitRetry`**, **`reconnectMs`**, **`lingerMs`**, **`lazyRemoveMs`** and **`seenEventIdsCount`** are the retry budget of an emit and the stream's own waits and memory.

### `TokenRefresher`

```typescript
type TokenRefresher = (refused: string | null) => Promise<string | null>;
```

Called when the gateway refuses a request's credential: a 401, or a 429 whose body names the limit `refusal-rate` ([TRANSPORT-CONTRACT § A refused credential](https://github.com/xynolog/protocol/blob/main/contract/TRANSPORT-CONTRACT.md#a-refused-credential)). It is told `refused`, the token the refused request carried (no `Bearer ` prefix), or `null` when it carried none. A refresher that holds another token by then, because a renewal already answered an earlier refusal of that one, returns the token it holds and renews nothing. A REST call, a content read or upload through ky, and an emit each ask it **once**, and are sent again at once with the token it returns, when that is not the token refused; accepted, they settle as if never refused and nothing is reported. Given no token, the same one, or a second refusal, they fail as `unauthorized` with the status the gateway answered, and are not sent a third time. The SSE connect path asks it **once per outage** before the actor parks `unauthenticated` (a successful open re-arms the once). A refused credential is never retried by a retry rule and never waits out a `Retry-After`; without a refresher it is final at once. Should return a new access token (no `Bearer ` prefix), or `null` to give up; a throw counts as `null`. The transport does **not** push the result into `token$` — rotating the token source is the refresher owner's job (`XynologSession.refresh(refused)` does exactly that), which is also how the SSE path reconnects: the actor re-reads its token getter rather than trusting the returned value. An upload sent through `XMLHttpRequest` (a browser page asking for progress or giving a `signal`) is not renewed: its refused credential fails as `unauthorized`.

For session-managed refresh (proactive refresh on a timer, terminal-auth-failure surface, cross-tab sync), use `XynologSession` from `@xynolog/sdk` rather than the raw `tokenRefresher` hook — `XynologSession.refresh(refused)` orchestrates the lifecycle and `tokenRefresher` is the lower-level escape hatch.

## `HttpContentTransport`

`new HttpContentTransport(transport)`, over an `HttpTransport`. Implements `IContentTransport` from `@xynolog/core`. Binary I/O — `putBinary`, `getBinary`, `getBinaryStream` — plus three reads of JSON: `getResourceGraph`, which dereferences `GET /resources/:id/jsonld` and returns the parsed `GetResourceResponse` (the resource's JSON-LD metadata graph); `getAnnotations`, which asks `GET /resources/:id/annotations` and returns the `GetAnnotationsResponse` that is its body: the resource's annotations and how many there are; and `getAnchoredText`, which asks `GET /resources/:id/anchored-text` and returns the `AnchoredTextAnswer` that is its body: the text extracted from the resource's content with where each run of it is on a page, a stored decline, or a named absence whose `kind` says whether to ask again. Shares the wrapped transport's `baseUrl`, `token$`, and request deadline, `httpRequestTimeoutMs` (an upload has no deadline); all requests piggyback on the same auth.

## `APIError`

A `XynologError` with the HTTP `status` and `statusText` it came from, a `code` from the shared transport vocabulary, and `retryAfterMs` when the gateway said how long to wait. Thrown for non-2xx HTTP responses from the REST methods on `HttpTransport`, and from `emit` when the gateway refuses it; a refused stream is reported as one too. A request the gateway never answered — the connection failed, or the deadline passed, on every attempt — is one as well, with the code `unavailable` and a `status` of 0. `status` and `statusText` are the HTTP-level fields; `code` is the `TransportErrorCode` classification derived from the status (a 429 is `rate-limited`), but for a refused credential, which is `unauthorized` whatever its status (a 429 whose body names `refusal-rate` among them); `details.body` is the parsed response body when available. `retryAfterMs` is the wait the response's `Retry-After` stated, as a limit's 429 or a capacity 503 does: an emit's retries, and a refused stream's reconnect, wait at least that long. `XynologError` and `TransportErrorCode` come from `@xynolog/core`.

## `errors$`

Every failure a server states is reported on `HttpTransport.errors$` before its caller hears it: a refused REST call and a refused emit as the `APIError` that is then thrown, and a refused stream as an `APIError` no caller awaits. Each carries the HTTP `status` and its `TransportErrorCode`, so a consumer routing on `unauthorized` hears a refused stream as it hears a refused request. A REST call or an emit the gateway never answered is reported the same way, as `unavailable`. A stream that drops is a connection state, not a failure, and is not reported here. Of the failures met before anyone reads `errors$`, the latest `ERRORS_KEPT_FOR_FIRST_READER_COUNT` are kept for its first reader, in the order met, the oldest dropped beyond that; a later reader hears what is met from when it reads. What is still kept when the transport is disposed is dropped.

## After `dispose()`

A disposed transport is a closed bus: `state$` has completed, and a `Bus.request` made of it fails at once as `bus.closed` without sending anything.

## Composing with `XynologClient`

The intended consumption pattern is to import `XynologClient` from `@xynolog/sdk` and pass `HttpTransport` + `HttpContentTransport` instances to its constructor. `@xynolog/sdk` re-exports `HttpTransport` and `HttpContentTransport` for convenience, so a typical consumer needs only one import:

```typescript
import { XynologClient, HttpTransport, HttpContentTransport } from '@xynolog/sdk';
import { BRIDGED_CHANNELS, baseUrl, accessToken, type AccessToken } from '@xynolog/core';
import { BehaviorSubject } from 'rxjs';

const token$ = new BehaviorSubject<AccessToken | null>(accessToken('...'));
const transport = new HttpTransport({ baseUrl: baseUrl('https://kb.example.com'), channels: BRIDGED_CHANNELS, token$ });
// HttpTransport implements both ITransport and IGatewayOperations; passing it
// third enables the `auth` / `system` namespaces. Omit the third argument and
// `client.auth` / `client.system` are `undefined`.
const client = new XynologClient(transport, new HttpContentTransport(transport), transport);
```

The MCP server imports from `@xynolog/http-transport` itself, because it builds this stack by hand, with its own token source.

## Behavioral contract

The guarantees every `ITransport` implementation must honor — including `HttpTransport` — are documented in [`protocol/contract/TRANSPORT-CONTRACT.md`](https://github.com/xynolog/protocol/blob/main/contract/TRANSPORT-CONTRACT.md). HTTP-specific guarantees (the `/bus/emit` gateway, SSE reconnect, per-scope `lastEventId` replay, seven-state connection machine) live in [`protocol/contract/TRANSPORT-HTTP.md`](https://github.com/xynolog/protocol/blob/main/contract/TRANSPORT-HTTP.md).

## Other docs in this package

- [`LOGGING.md`](./LOGGING.md) — logger interface, what gets logged, integration examples.
- [`MEDIA-TOKENS.md`](./MEDIA-TOKENS.md) — short-lived JWT for binary URL fetches that can't carry an `Authorization` header.

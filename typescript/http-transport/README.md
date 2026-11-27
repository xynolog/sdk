# @xynolog/http-transport

[![Tests](https://github.com/xynolog/sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/xynolog/sdk/actions/workflows/ci.yml?query=branch%3Amain+is%3Asuccess+job%3A%22Test+http-transport%22)
[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-http-transport)](https://app.codecov.io/gh/xynolog/sdk/components)
[![npm version](https://img.shields.io/npm/v/@xynolog/http-transport.svg)](https://www.npmjs.com/package/@xynolog/http-transport)
[![npm downloads](https://img.shields.io/npm/dm/@xynolog/http-transport.svg)](https://www.npmjs.com/package/@xynolog/http-transport)
[![License](https://img.shields.io/npm/l/@xynolog/http-transport.svg)](https://github.com/xynolog/sdk/blob/v0.8.2/LICENSE)

How the TypeScript SDK reaches a knowledge base over HTTP. It implements the three transport contracts [`@xynolog/core`](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/core/README.md) states (`ITransport`, `IContentTransport`, `IGatewayOperations`) against a knowledge base's gateway.

## Install

```bash
npm install @xynolog/http-transport
```

Below 1.0 the minor number is the break, and the caret range npm writes into `package.json`
takes the releases up to the next minor and no further.

## Example

The stack wired by hand. A session does this for you.

```typescript
import { XynologClient } from '@xynolog/sdk';
import { HttpTransport, HttpContentTransport } from '@xynolog/http-transport';
import { BRIDGED_CHANNELS, baseUrl } from '@xynolog/core';

// A full client's stream names every channel a client hears.
const transport = new HttpTransport({ baseUrl: baseUrl('https://kb.example/'), channels: BRIDGED_CHANNELS });

// HttpTransport is also the gateway's plain operations: passed third, it
// gives the client its `auth` and `system` namespaces.
const client = new XynologClient(transport, new HttpContentTransport(transport), transport);
```

## Who uses it

- **[`@xynolog/sdk`](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/sdk/README.md)** builds one for every session, and re-exports `HttpTransport` and `HttpContentTransport`.

**Building an application?** Import from [`@xynolog/sdk`](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/sdk/README.md), not from here. A session gives you a connected client, and the two transport classes are re-exported there for the rare program that wires its own.

## What is in it

| | |
|---|---|
| `HttpTransport` | The bus over a gateway: `POST /bus/emit` for what a client sends, one stream (`POST /bus/subscribe`) for what it receives, and the gateway's plain operations |
| `HttpContentTransport` | A resource's bytes, up with progress and cancellation, and down whole or as a stream; its linked-data description; and its anchored text |
| `HttpTransportConfig` | What a transport is given: the gateway's address, a token source, a `TokenRefresher`, the channels its stream names, the `fetch` it sends with, and what of its `timing` (`TransportTiming`) differs from the table's |
| `currentUserOf(baseUrl, token, fetch?)` | One request asking the gateway who a token is, with no transport behind it. A session asks this of a stored credential before it trusts it |
| `APIError` | What an HTTP failure is thrown as |

## The fetch it sends with

Every request of a transport is sent with the `fetch` its config gives, or with the runtime's own when it gives none: the stream, every emit, the gateway's plain operations, and the content transport's reads and uploads. `currentUserOf` takes one as its last argument, and `agentToken` one for the gateway as `fetch`, beside the `ServiceToken` it signs in with, which asks the issuer with the one it was made with. The certificates a request trusts, and the proxy it goes through, are that fetch's: this package reads no setting of its own for either.

- **In Node**, the runtime's `fetch` trusts Node's certificate authorities. A gateway whose certificate another authority signed is reached with a `fetch` that trusts that authority: undici's `fetch`, sent through an undici `Agent` whose `connect` options carry its `ca`. The application depends on `undici` for it; this package does not.
- **In a browser page**, the browser decides what every request trusts, whatever `fetch` is given. An upload that asks for progress or gives a `signal` there goes through `XMLHttpRequest`, the one way a page can count the bytes it sends, and not through the `fetch` given.

```typescript
import { HttpTransport } from '@xynolog/http-transport';
import { BRIDGED_CHANNELS, baseUrl } from '@xynolog/core';

// A fetch that trusts the gateway's certificate authority.
declare const trusting: typeof fetch;

const transport = new HttpTransport({ baseUrl: baseUrl('https://kb.example/'), channels: BRIDGED_CHANNELS, fetch: trusting });
```

## Documentation

- [Reference](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/http-transport/docs/API-Reference.md): each export.
- [Logging](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/http-transport/docs/LOGGING.md): what the transport logs, and the bus log.
- [Media tokens](https://github.com/xynolog/sdk/blob/v0.8.2/typescript/http-transport/docs/MEDIA-TOKENS.md): how a browser fetches a resource's bytes without an `Authorization` header.

## License

Apache-2.0

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

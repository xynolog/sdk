# @xynolog/core

[![Tests](https://github.com/xynolog/sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/xynolog/sdk/actions/workflows/ci.yml?query=branch%3Amain+is%3Asuccess+job%3A%22Test+core%22)
[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-core)](https://app.codecov.io/gh/xynolog/sdk/components)
[![npm version](https://img.shields.io/npm/v/@xynolog/core.svg)](https://www.npmjs.com/package/@xynolog/core)
[![npm downloads](https://img.shields.io/npm/dm/@xynolog/core.svg)](https://www.npmjs.com/package/@xynolog/core)
[![License](https://img.shields.io/npm/l/@xynolog/core.svg)](https://github.com/xynolog/sdk/blob/v0.8.1/LICENSE)

What every TypeScript package in Xynolog stands on: the protocol's types, generated from the [spec](https://github.com/xynolog/protocol/blob/main/specs/README.md), and the logic that has to be the same wherever it runs. That is ids, the event bus and its channels, the transport contract, annotations and how they are anchored, and identities.

## Install

```bash
npm install @xynolog/core
```

Below 1.0 the minor number is the break, and the caret range npm writes into `package.json`
takes the releases up to the next minor and no further.

## Example

```typescript
import { resourceId, isResourceId, kbDid, kbResource } from '@xynolog/core';

// An id is made by its constructor, which throws for text its rule refuses.
const id = resourceId('5bcd259ab1464cf68a556bbad21f513f');

// A guard asks the same rule without throwing.
const typed = isResourceId('https://kb.example/resources/5bcd');   // false: a URI is not an id

// A knowledge base's did and the audience its tokens carry, from its committed domain.
const did = kbDid('xynoplex.github.io:xynoplex-caselaw-kb');        // 'did:web:xynoplex.github.io:xynoplex-caselaw-kb'
const audience = kbResource('xynoplex.github.io:xynoplex-caselaw-kb'); // 'https://xynoplex.github.io/xynoplex-caselaw-kb'
```

## Who uses it

Every other TypeScript package, the Browser, and the conformance and end-to-end suites. It depends on no other Xynolog package.

**Building an application?** Use [`@xynolog/sdk`](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/sdk/README.md). It re-exports what an application needs from here, the id constructors and the error types among them, and an application rarely imports this package by name.

## What is in it

| Area | What | Where |
|---|---|---|
| The protocol's types | `components`, `paths`, `operations`: every request, response and schema | `src/types.ts`, generated when the package is built and not committed |
| Ids | `ResourceId`, `AnnotationId`, `JobId`, `UserId`, each with a constructor that holds text to its rule and a guard that asks without throwing | [src/identifiers.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/identifiers.ts), generated |
| The bus | `EventBus`, the `EventMap` of every channel and its payload, and `Bus`, the typed bus over a transport, whose `request` is a request and its reply | [src/event-bus.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/event-bus.ts), [src/bus-protocol.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/bus-protocol.ts), [src/bus.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/bus.ts), [src/bus-request.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/bus-request.ts) |
| The record's events | `PersistedEvent`, `StoredEvent`, and the list of every event type a knowledge base records | [src/persisted-events.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/persisted-events.ts), [src/event-base.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/event-base.ts) |
| The transport contract | `ITransport`, `IContentTransport`, `IGatewayOperations`: what a client needs of the wire | [src/transport.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/transport.ts) |
| Annotations | Building one (`reconcile`, `annotationOfSpan`, `annotationOfResource`), and reading its target, its selectors and its links | [src/annotation-builders.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/annotation-builders.ts), [src/web-annotation-utils.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/web-annotation-utils.ts) |
| Anchoring | Finding an annotation again after its text changed, and the geometry of text on a PDF page (`locate`, `textUnder`) | [src/anchor-annotation.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/anchor-annotation.ts), [src/pdf-anchoring.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/pdf-anchoring.ts) |
| Identity | A knowledge base's own did and resource identifier (`kbDid`, `kbResource`). A principal's DID is the gateway's to mint and the record's to read | [src/did-utils.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/did-utils.ts) |
| Media types | Which types a knowledge base admits, and what can be done with each | [src/media-types.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/media-types.ts) |
| Shared rules | Error codes, timing, retry, the cache's refresh table, where jobs are kept and the API's limits, the same for every SDK | [src/error-codes.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/error-codes.ts), [src/client-timing.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/client-timing.ts), [src/cache-refresh.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/cache-refresh.ts), [src/job-storage.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/job-storage.ts), [src/protocol-limits.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/protocol-limits.ts), generated; [src/retry.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/retry.ts) |
| Languages | Every language an interface speaks, by code, with its native and English names | [src/locale-registry.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/locale-registry.ts), generated; [src/locales.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/src/locales.ts) |

The main import runs in a browser. What cannot is on a subpath:

| Import | |
|---|---|
| `@xynolog/core/openapi` | The spec's limits |
| `@xynolog/core/testing` | The test doubles every layer shares |
| `@xynolog/core/testing/axioms` | Property-based harnesses for state units and transports. They need `fast-check` |
| `@xynolog/core/testing/issuer` | An OIDC issuer in one process, for tests that verify tokens |

## Documentation

- [API tour](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/docs/API.md): each area, with examples.
- [Utilities](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/core/docs/Utilities.md): the small helpers.
- [The spec](https://github.com/xynolog/protocol/blob/main/specs/README.md), which this package is generated from.

## License

Apache-2.0

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

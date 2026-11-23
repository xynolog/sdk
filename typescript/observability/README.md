# @xynolog/observability

[![Tests](https://github.com/xynolog/sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/xynolog/sdk/actions/workflows/ci.yml?query=branch%3Amain+is%3Asuccess+job%3A%22Test+observability%22)
[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-observability)](https://app.codecov.io/gh/xynolog/sdk/components)
[![npm version](https://img.shields.io/npm/v/@xynolog/observability.svg)](https://www.npmjs.com/package/@xynolog/observability)
[![npm downloads](https://img.shields.io/npm/dm/@xynolog/observability.svg)](https://www.npmjs.com/package/@xynolog/observability)
[![License](https://img.shields.io/npm/l/@xynolog/observability.svg)](https://github.com/xynolog/sdk/blob/v0.8.1/LICENSE)

Tracing and metrics for Xynolog's TypeScript transport and for a Node program built on it, on [OpenTelemetry](https://opentelemetry.io). It is off unless a process is given somewhere to export to: with no endpoint configured, every function here does nothing.

## Install

```bash
npm install @xynolog/observability
```

Below 1.0 the minor number is the break, and the caret range npm writes into `package.json`
takes the releases up to the next minor and no further.

## Example

```typescript
import { initObservabilityNode } from '@xynolog/observability/node';
import { withSpan } from '@xynolog/observability';

// Once, at the entry point, before anything that makes a span.
initObservabilityNode({ serviceName: 'my-program', serviceVersion: '1.0.0' });

const length = await withSpan('read-document', async (span) => {
  span.setAttribute('document.pages', 12);
  return 4096;
});
```

## Who uses it

- **[`@xynolog/http-transport`](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/http-transport/README.md)** runs each request in a span and carries the trace across the wire. That is how this package comes to be in the Browser's bundle.
- **[`@xynolog/sdk`](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/sdk/README.md)** carries the trace of a job from the request that made it to the worker that claims it.

No Xynolog service is a Node process. The gateway, the dispatcher and the Archivist are Rust and have a crate of their own for this; the Python services have `xynolog_service`.

**Building an application?** You do not need this package. The SDK's transport reports through OpenTelemetry's global API, so an application that registers a tracer of its own sees the transport's spans in its traces.

## What is in it

| Import | |
|---|---|
| `@xynolog/observability` | Runs in Node and in a browser. Spans: `withSpan`. Trace context across the bus: `getActiveTraceparent`, `extractTraceparent`, `withTraceparent`; and `withoutTrace`, for work that begins a trace of its own. `recordBusSent`, the count of the emits a client sent |
| `@xynolog/observability/node` | `initObservabilityNode` and `shutdownObservabilityNode`: the tracer, the meter, the exporter and the context manager of a Node process |

Each says what it does where it is defined, in [src/index.ts](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/observability/src/index.ts).

## Documentation

- [API reference](https://github.com/xynolog/sdk/blob/v0.8.1/typescript/observability/docs/API.md): the helpers, with an example of each.
- [Observability](https://github.com/xynolog/docs/blob/main/operator/administration/OBSERVABILITY.md): the variables that turn it on, and where a stack sends its telemetry.

## License

Apache-2.0

Working on the SDK itself? See [CONTRIBUTING.md](https://github.com/xynolog/sdk/blob/main/CONTRIBUTING.md).

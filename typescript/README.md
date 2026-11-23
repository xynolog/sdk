# TypeScript

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript)](https://app.codecov.io/gh/xynolog/sdk/components)

The client side: the SDK and what it stands on. These are the consumer-facing TypeScript packages.

| Package | Published | Coverage | What it is |
|---|---|---|---|
| [@xynolog/sdk](./sdk/README.md) | [![npm](https://img.shields.io/npm/v/@xynolog/sdk)](https://www.npmjs.com/package/@xynolog/sdk) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-sdk)](https://app.codecov.io/gh/xynolog/sdk/components) | The TypeScript SDK: `XynologClient` and its verb namespaces, `XynologSession` and `XynologBrowser`, state units, and the cache behind live queries |
| [@xynolog/react-ui](./react-ui/README.md) | [![npm](https://img.shields.io/npm/v/@xynolog/react-ui)](https://www.npmjs.com/package/@xynolog/react-ui) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-react-ui)](https://app.codecov.io/gh/xynolog/sdk/components) | React components and hooks over the SDK: the resource viewer, the annotation components, and the `useStateUnit` and `useObservable` adapters |
| [@xynolog/http-transport](./http-transport/README.md) | [![npm](https://img.shields.io/npm/v/@xynolog/http-transport)](https://www.npmjs.com/package/@xynolog/http-transport) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-http-transport)](https://app.codecov.io/gh/xynolog/sdk/components) | How the SDK reaches a knowledge base over HTTP: `HttpTransport` and `HttpContentTransport`. The SDK depends on it |
| [@xynolog/core](./core/README.md) | [![npm](https://img.shields.io/npm/v/@xynolog/core)](https://www.npmjs.com/package/@xynolog/core) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-core)](https://app.codecov.io/gh/xynolog/sdk/components) | What every TypeScript package stands on: the protocol's types, generated from the spec, the ids, the event bus, and the contracts a transport implements |
| [@xynolog/observability](./observability/README.md) | [![npm](https://img.shields.io/npm/v/@xynolog/observability)](https://www.npmjs.com/package/@xynolog/observability) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=typescript-observability)](https://app.codecov.io/gh/xynolog/sdk/components) | Tracing and metrics for the TypeScript transport, on OpenTelemetry. It does nothing until a process is given somewhere to export to |

## Where things are

- The packages are npm workspaces of the repository's root, which installs and builds them all (`npm ci`, `npm run build:packages`).
- [`tsconfig.base.json`](./tsconfig.base.json) is what each package's `tsconfig.json` extends, and [`vitest.shared.config.ts`](./vitest.shared.config.ts) what each package's suite, and the Browser's, merges.
- Each package measures its coverage with `npm run test:coverage`, which `make test-typescript` runs. CI uploads the reports to Codecov under the flag `typescript`, and each package's badge reads the component of its directory, `typescript-<directory>`.

The other languages, and which SDK a program installs, are in [packages/](../README.md).

# Contributing to the Xynolog SDKs

The organization's [contributing guide](https://github.com/xynolog/.github/blob/main/CONTRIBUTING.md) holds for this repository: a change reaches `main` through a pull request, every commit is signed off and signed, and a security problem is reported privately. This guide is what is particular to the SDKs: how they are built, tested, generated and released, and what each language keeps.

## Building and testing

Run `git clone --recurse-submodules https://github.com/xynolog/sdk.git` (or initialize submodules after cloning), then run `make` at the repository root to build and stage all nine SDKs, or `make test` to run every SDK's own tests, type checks, lints and format checks (`make test-rust` and the like run one language's); `make generate` rewrites every SDK's generated files from the pinned Protocol, and `make check-generated` fails when a committed one differs from what its generator writes; `make help` lists every target. Build, test, clean, and local artifact targets use the runtime selected by `CONTAINER_RUNTIME`, or auto-detect `container`, `docker`, then `podman`. GitHub Actions runs each changed language's `make test-<language>`. Dependabot checks the supported manifests for Go, Rust and its toolchain, TypeScript, Python (uv), .NET, Kotlin, Swift, and GitHub Actions; Dependabot does not currently support the Haskell or OCaml package manifests.

`make build` (the default) builds and stages all nine SDKs in local, ecosystem-native formats; run `make typescript`, `make python`, `make rust`, `make go`, `make csharp`, `make haskell`, `make kotlin`, `make ocaml`, or `make swift` to build one language. These targets create package archives and local feeds as files; they do not start npm, PyPI, or Cargo registry servers. Every SDK build and package toolchain runs in its language container. Native packages persist under `${XDG_CACHE_HOME:-~/.cache}/xynolog-sdk/local`. Each target also creates an immutable bundle containing its native artifacts and an `artifacts.json` manifest with SDK commit, working-tree digest, pinned Protocol commit, package coordinates, toolchains, and SHA-256 checksums. The default bundle path is under `${XDG_CACHE_HOME:-~/.cache}/xynolog-sdk/bundles`; set `SDK_ARTIFACTS` to select a destination:

| SDK | Output | Format |
| --- | --- | --- |
| TypeScript | `npm/packages` | npm tarballs |
| Python | `python/packages` | wheel and source distribution |
| Rust | `rust/packages` | Cargo `.crate` archives |
| Go | `go-proxy` | file-based Go module proxy |
| C# | `nuget` | NuGet packages / folder feed |
| Haskell | `haskell` | Cabal source distribution |
| Kotlin | `kotlin-maven` | Maven repository |
| OCaml | `opam-repo/repo` | opam repository |
| Swift | `swift` | SwiftPM package, as a release writes it to `xynolog/sdk-swift` |

`make clean` removes generated build directories and local package artifacts for all nine SDK languages, their SDK-scoped compiler and dependency caches, and cached artifact bundles. Use `make rust-clean` (or another `<language>-clean` target) to clean one language. It leaves downloaded container images and any bundle written to an external `SDK_ARTIFACTS` path untouched.

## Protocol-derived code generation

[`codegen/`](codegen/README.md) is the generator that writes every SDK's generated code from the pinned Protocol, and cli's and images'.

`protocol/specs/src/` is the only source for protocol schemas and registries.
The SDK build checks that the submodule is initialized at the commit recorded by
this SDK commit, then generates the OpenAPI bundles from those sources before
building any language artifacts. Language generators remain in their SDK
directories and consume either those bundles or files under the same pinned
`protocol/specs/src/` tree. Generated SDK types and package artifacts are owned
and released here; the Protocol repository does not generate SDK code.

Do not substitute a sibling checkout or a moving Protocol branch. To change the
protocol input, update the `protocol` submodule pointer, regenerate the affected
SDK outputs, and build the SDK packages from that commit.

## Changelogs

Each language keeps a changelog beside its README (OCaml's is `CHANGES.md`, as dune-release names it), whose latest section is the coming release's. A pull request that changes a language's directory adds an entry there, or carries the `no-changelog` label; the Changelog workflow checks it.

## Releasing

`version.json` names the coming release, one semantic version `X.Y.Z` for all nine languages; `scripts/sdk_version.py` derives every package version from it. Below 1.0 the minor number is the break: a breaking change raises it, anything else the patch number. A commit tagged `vX.Y.Z` builds the release; every other commit builds a development version, which no registry receives.

To release, check out `main`'s latest commit (`git switch main && git pull --ff-only`) and run `bash scripts/tag-release.sh`; it refuses any other commit. It runs `scripts/release-ready.sh`, which checks five things:

- the committed manifests, tagged links and changelogs hold the release's versions;
- the release is not tagged on another commit;
- `main` holds the commit;
- CI's run for the commit's push to `main`, which builds and tests all nine languages, finished green;
- the Protocol submodule's commit is on Protocol's `main`.

It then signs and pushes `vX.Y.Z`. That starts the release workflow, which does nothing until it has fetched the tag and found it annotated, named as pushed, on a commit `main` holds, and signed by the release signer (`xynolog/.github`'s `release-tag.yml`); it then runs the same checks again, and builds, verifies and releases the nine-language bundle as the GitHub release `vX.Y.Z`.

Once that release exists, run `bash scripts/tag-release.sh go` on the same commit. It signs and pushes Go's `go/vX.Y.Z`, which is itself the Go release, since the Go module proxy serves the tag from then on; so it waits for the bundle, and a failed build spends no Go version.

Each registry then takes the released bundle, never a rebuild: dispatch `publish.yml` at the tag, one registry at a time, and approve it in the `release` environment, for example `gh workflow run publish.yml --ref vX.Y.Z -f registry=pypi`. Each registry accepts the SDK only through trusted publishing from that workflow and environment. cargo publishes only a crate it packages itself, so `registry=crates` packages each crate from the tag as the release did, and publishes none unless every archive is the bundle's. `registry=go` checks the signed Go tag and that the module the Go proxy serves is the bundle's.

Once the release is tagged, CI fails until the coming release moves on: `python3 scripts/sdk_version.py move X.Y.Z` writes a later one into `version.json` and every manifest, and opens its section in each language's changelog, in a pull request of its own.

## The SDKs

### TypeScript

`typescript/` holds the five npm packages, one directory each: `sdk`, `core`, `http-transport`, `observability` and `react-ui`. `make typescript` builds and stages its packages, and `make test-typescript` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### What a change to `@xynolog/core` must keep

- **The spec is the source.** Each module that opens `GENERATED FILE`, `src/types.ts` among them, is generated from [`protocol/specs/src`](https://github.com/xynolog/protocol/tree/main/specs/src), and never edited. Those modules are committed, and `make generate` writes them. Change the spec, then run `make generate`. A type written by hand that restates a schema is a second copy that nothing keeps true: use the spec's type, under the spec's name.
- **The main import runs in a browser.** It uses no Node builtin. The test issuer is reachable only by its subpath, because of the weight `jose` would add to every bundle, and `npm run lint:core-subpaths` fails a re-export of it from the root.
- **It depends on no other Xynolog package.** Everything else depends on it.
- **An id is made only by its constructor or its guard.** One kind is never assignable to another.
- **Its tests read every package.** Three census tests here walk the source of all of `packages/`, `apps/` and `images/`, tests included, so a change somewhere else can fail this package's suite.

#### What a change to `@xynolog/http-transport` must keep

- **The transport contract.** What every transport must do is [TRANSPORT-CONTRACT](https://github.com/xynolog/protocol/blob/main/contract/TRANSPORT-CONTRACT.md), and what this one does on the wire is [TRANSPORT-HTTP](https://github.com/xynolog/protocol/blob/main/contract/TRANSPORT-HTTP.md). The [SDK conformance suite](https://github.com/xynolog/protocol/blob/main/conformance/sdk/README.md) holds it to both, through [conformance/driver.ts](typescript/http-transport/conformance/driver.ts), beside the Rust transport.
- **One token source.** A transport reads the current token from `token$`. `tokenRefresher` is the only way a token is renewed, for a refused request, emit and stream alike, and it is told the token refused.
- **Timing is the spec's.** The reconnect, linger and retry values are [`protocol/specs/src/client/timing.json`](https://github.com/xynolog/protocol/blob/main/specs/src/client/timing.json)'s. The config fields that override them are for a test or the conformance driver, which cannot wait them out.
- **A narrowed stream still hears its replies.** A process that passes `channels` names the reply channels of every operation it awaits. A request whose replies are outside the set fails at once with `bus.unsubscribed`, rather than timing out.
- **Wire shapes are generated.** Requests and responses are `@xynolog/core`'s types, from the spec. None is retyped here.

A transport that is not HTTP implements `ITransport` and `IContentTransport` from `@xynolog/core` and inherits nothing from this package.

#### What a change to `@xynolog/observability` must keep

- **Off by default, and free when off.** With no exporter configured, the tracer and the meter are OpenTelemetry's own no-ops. Nothing here may do work, or fail, because telemetry is not set up.
- **The main import runs in a browser.** It imports no Node builtin. What needs Node is in `/node`.
- **One trace across the bus.** A request carries the active span as a W3C `traceparent` header, and a frame relayed over the stream carries it in its payload's trace field (`TRACE_FIELD` in `@xynolog/core`, generated from the bus registry). A handler continues that trace rather than starting one.
- **No domain logic.** The package gives the helpers and the recorder. What is worth a span or a count is decided where the work happens.
- **Initialized once.** `initObservabilityNode` is called at a process's entry point. A second call does nothing and returns `false`.

#### Developing `@xynolog/react-ui`

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Type checking
npm run typecheck
```

#### Contributing to `@xynolog/react-ui`

This library follows strict quality standards:

- **100% TypeScript** - All code must be properly typed
- **No `any` casts** - Without explicit permission
- **No cruft** - Delete dead code immediately, no "legacy" patterns
- **Direct fixes** - If something is wrong, fix it directly (no aliases/wrappers)

### Python

`python/` holds the `xynolog` distribution, in `python/sdk`. `make python` builds and stages its packages, and `make test-python` runs its tests, type checks, lints and format checks, in its toolchain's container.

The package is [`python/sdk`](https://github.com/xynolog/sdk/tree/main/python/sdk) of the [Xynolog repository](https://github.com/xynolog/sdk), and [Testing](https://github.com/xynolog/docs/blob/main/contributor/TESTING.md) says how its checks and its tests are run. The programs its README shows are files of its tests, word for word: both type checkers check them, and each one is run.

### Rust

`rust/` holds the three crates of one workspace: `sdk`, `http-transport` and `telemetry`. `make rust` builds and stages its packages, and `make test-rust` runs its tests, type checks, lints and format checks, in its toolchain's container.

### Go

`go/` holds the module `github.com/xynolog/sdk/go`. `make go` builds and stages its packages, and `make test-go` runs its tests, type checks, lints and format checks, in its toolchain's container.

### C#

`csharp/` holds the `Xynolog` NuGet package, in `csharp/sdk`. `make csharp` builds and stages its packages, and `make test-csharp` runs its tests, type checks, lints and format checks, in its toolchain's container.

### Haskell

`haskell/` holds the `xynolog` Cabal package, in `haskell/sdk`. `make haskell` builds and stages its packages, and `make test-haskell` runs its tests, type checks, lints and format checks, in its toolchain's container.

### Kotlin

`kotlin/` holds the `org.xynolog:xynolog` publication, in `kotlin/sdk`. `make kotlin` builds and stages its packages, and `make test-kotlin` runs its tests, type checks, lints and format checks, in its toolchain's container.

### OCaml

`ocaml/` holds the `xynolog` opam package, in `ocaml/sdk`. `make ocaml` builds and stages its packages, and `make test-ocaml` runs its tests, type checks, lints and format checks, in its toolchain's container.

### Swift

`swift/` holds the `Xynolog` and `XynologTesting` products, in `swift/sdk`, and the distribution a release writes to `xynolog/sdk-swift`, in `swift/distribution`. `make swift` builds and stages its packages, and `make test-swift` runs its tests, type checks, lints and format checks, in its toolchain's container.

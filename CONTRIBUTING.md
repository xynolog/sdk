# Contributing to the Xynolog SDKs

The organization's [contributing guide](https://github.com/xynolog/.github/blob/main/CONTRIBUTING.md) holds for this repository: a change reaches `main` through a pull request, every commit is signed off and signed, and a security problem is reported privately. This guide is what is particular to the SDKs: how they are built, tested, generated and released, and what each language keeps.

## Building and testing

Run `git clone --recurse-submodules https://github.com/xynolog/sdk.git` (or initialize submodules after cloning), then run `make` at the repository root to build and stage all nine SDKs, or `make test` to run every SDK's own tests, type checks, lints and format checks (`make test-rust` and the like run one language's); `make generate` rewrites every SDK's generated files from the pinned Protocol, and `make check-generated` fails when a committed one differs from what its generator writes; `make help` lists every target. Build, test, clean, and local artifact targets use the runtime selected by `CONTAINER_RUNTIME`, or auto-detect `container`, `docker`, then `podman`. GitHub Actions runs each changed language's `make test-<language>`. Dependabot checks the supported manifests for Go, Rust and its toolchain, TypeScript, Python (uv), .NET, Kotlin, Swift, and GitHub Actions; Dependabot does not currently support the Haskell or OCaml package manifests.

Each `make test-<language>` measures its tests' coverage and writes the reports into `coverage/<language>/`, each source named by its path in the repository (`scripts/coverage-report.py`). On a push to main, and on a pull request from a branch of this repository, CI's codecov job uploads them to Codecov, signed in by the run's OIDC token, under the language's flag in [`.github/codecov.yml`](.github/codecov.yml), one upload a flag. A refused upload fails that job, which CI Gate does not wait for: Codecov is no part of what CI holds a change to. A pull request from a fork uploads nothing. Each README's coverage badge reads the codecov.yml component of its name, which counts every flag's coverage in its paths, and `python3 scripts/codecov.py census` fails unless the flags are the Makefile's languages, the badges and the components are the same names, and each component's paths name a directory the checkout has.

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

To release, run `make tag-release` on `main`. It refuses a working tree with changes, or any other branch, and discards nothing. It pulls `main`'s latest commit and the pinned submodules, then runs `scripts/release-ready.sh`, which checks five things:

- the committed manifests, tagged links and changelogs hold the release's versions;
- the release is not tagged on another commit;
- `main` holds the commit;
- CI's run for the commit's push to `main`, which builds and tests all nine languages, finished green;
- the Protocol submodule's commit is on Protocol's `main`.

It then signs and pushes `vX.Y.Z`. That starts the release workflow, which does nothing until it has fetched the tag and found it annotated, named as pushed, on a commit `main` holds, and signed by the release signer (`xynolog/.github`'s `release-tag.yml`); it then runs the same checks again, and builds, verifies and releases the nine-language bundle as the GitHub release `vX.Y.Z`.

`make tag-release` watches that run. Once the release exists, it signs and pushes Go's `go/vX.Y.Z` on the same commit, which is itself the Go release, since the Go module proxy serves the tag from then on; so it waits for the bundle, and a failed build spends no Go version. A tag already on the commit is pushed again rather than signed again, so a `make tag-release` that stopped can be run again. If `main` has moved on since, finish the Go tag on the release's commit instead: `git switch --detach vX.Y.Z && bash scripts/tag-release.sh go`.

Each registry then takes the released bundle, never a rebuild. On the release's commit, `make publish` dispatches `publish.yml` at its tag for each registry the workflow offers, one at a time, and watches each run to its end. A person approves each run in the `release` environment. A run that fails stops the rest, and the registries still to publish are named. `make publish-<registry>`, as `make publish-pypi`, publishes to one. Each registry accepts the SDK only through trusted publishing from that workflow and environment. cargo publishes only a crate it packages itself, so `crates` packages each crate from the tag as the release did, and publishes none unless every archive is the bundle's. `go` checks the signed Go tag and that the module the Go proxy serves is the bundle's.

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

#### Contributing to `xynolog-http-transport`

Every Rust block of its README is a region of [tests/sign_in.rs](rust/http-transport/tests/sign_in.rs), compiled and run there against a stand-in gateway and issuer. The Rust block of the [`xynolog-worker` skill](skills/xynolog-worker/SKILL.md) is held to the same regions. [tests/stream.rs](rust/http-transport/tests/stream.rs) holds the stream's behaviour against a gateway that misbehaves on cue. [conformance/](rust/http-transport/conformance) holds the two drivers the [SDK conformance suite](https://github.com/xynolog/protocol/blob/main/conformance/sdk/README.md) runs, and the one the [worker conformance suite](https://github.com/xynolog/protocol/blob/main/conformance/worker/README.md) runs.

#### Contributing to `xynolog-telemetry`

Both Rust blocks of its README are regions of [tests/on.rs](rust/telemetry/tests/on.rs), which runs them in a process that installed an OpenTelemetry of its own and holds the crate to the telemetry table in both directions. [tests/off.rs](rust/telemetry/tests/off.rs) is the process that installed none.

### Go

`go/` holds the module `github.com/xynolog/sdk/go`. `make go` builds and stages its packages, and `make test-go` runs its tests, type checks, lints and format checks, in its toolchain's container.

A program in this repository requires the module by a `replace` directive on its relative path instead of a release, as `go/conformance/go.mod` does, so it builds against the tree:

```text
require github.com/xynolog/sdk/go v0.0.0

replace github.com/xynolog/sdk/go => ../
```

#### Regenerating

Nothing regenerates by itself. When the spec changes:

```sh
make generate
```

That runs the generator, [`codegen/`](codegen), in a container, so no Go or OCaml is needed on the host, and rewrites every generated file of every SDK, this module's among them. Commit the result. CI runs `make check-generated`, which writes nothing, and fails while a committed file differs from what the spec generates.

Package `api`'s types are its Go types group ([`codegen/lib/go_types`](codegen/lib/go_types)): a type for every component schema and every schema it reaches, so the bus's payloads too, which no HTTP path reaches. An enumeration's constants are named by the type and then the value, as `LogFormatJson` is the `json` of `LogFormat`, so a schema that reuses another's value renames no constant. A union holds its value as the wire carries it ([`go/api/union.go`](go/api/union.go)): `From` sets it to one of its members, `As` reads it into one, and a union that holds no member is refused when it is written.

#### Working on it

The module is [`go`](go) of the [Xynolog repository](https://github.com/xynolog/sdk), and [Testing](https://github.com/xynolog/docs/blob/main/contributor/TESTING.md) says how its checks and its tests are run. Go runs in a `golang` container at the toolchain its `go.mod` names. The programs its README shows are files of package `readme`, in `go/internal/readme`, word for word: the compiler checks them, and its tests run each one.

### C#

`csharp/` holds the `Xynolog` NuGet package, in `csharp/sdk`. `make csharp` builds and stages its packages, and `make test-csharp` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### Building and verifying

The SDK targets .NET 11. [global.json](csharp/sdk/global.json) pins the SDK exactly, with roll-forward disabled. [dotnet-version.sh](csharp/scripts/dotnet-version.sh) derives the container tag from that version. No .NET installation on the host is required.

From the repository root, build and check inside Apple `container`:

```sh
container run --rm --memory 4g -v "$PWD":/work -w /work/csharp/sdk \
  "mcr.microsoft.com/dotnet/sdk:$(csharp/scripts/dotnet-version.sh --image-tag)" \
  sh -c 'dotnet build -p:RestoreLockedMode=true && dotnet test --no-build --settings test.runsettings && dotnet format --no-restore --verify-no-changes'
```

The build enables nullable reference types, warnings as errors, analyzers, and explicit accessibility. Its Roslyn census analyzer covers generated code too. It refuses null forgiveness, task blocking, dynamic types, diagnostic suppression, skipped tests, and environment reads other than `XYNOLOG_BUS_LOG`. The analyzer is a build-time dependency; the SDK has no runtime package dependencies.

Every build compiles each file in [refusals](csharp/sdk/refusals) separately and requires its stated diagnostic. The xUnit suite checks valid code that must remain accepted. The test settings make a run with no tests fail. The suite's coverage, which `make test-csharp` writes as lcov, is uploaded by CI to Codecov under `csharp-sdk`.

### Haskell

`haskell/` holds the `xynolog` Cabal package, in `haskell/sdk`. `make haskell` builds and stages its packages, and `make test-haskell` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### Building and verifying

From the repository root, build and test in the pinned toolchain's container:

```sh
make test-haskell
```

CI runs the same target. Exact project
dependencies are frozen in [the freeze file](haskell/sdk/cabal.project.freeze). Ordinary
builds use checked-in generated files and require no npm or schema generation.
The target checks that every module, generated or written by hand, is laid
out as ormolu lays it out. Ormolu and what it is built from are pinned by
[its own freeze file](haskell/toolchain/ormolu/cabal.project.freeze); run
`ormolu -i` over a module to lay it out.

The target builds `conformance/bin/xynolog-haskell-wire-driver` and
`conformance/bin/xynolog-haskell-live-driver`. The shared
[SDK conformance suite](https://github.com/xynolog/protocol/blob/main/conformance/sdk/README.md) drives them
through the public SDK against the real gateway on both signal planes, including
OTLP export. Worker conformance uses the wire driver. CI transfers both tested
drivers to the corresponding conformance jobs.

Inside the development container, from `haskell/sdk`:

```sh
cabal build all --enable-tests --enable-coverage
python3 api.py --write
bash run.sh /work
```

Here `/work` is the repository root. `make generate`, at the root, writes the
generated modules: the repository's generator (`codegen/`) derives protocol
types, channel descriptors, error codes, timing and the module list. It keeps
the committed manifest's version line, which holds the coming release's Haskell
version: `scripts/sdk_version.py write` puts it there
(`haskell/scripts/cabal-version.sh`). The
manifest is not among `public-api.json`'s inputs, since the template and the
generated modules are. Refresh
`public-api.json` after library source changes;
GHC supplies the reachable types, constructors, and signatures through the
public Cabal modules, including re-exports. The census checks source
freshness; the Haskell job compares actual compiled exports.

##### What the checks cover

The schema suite generates samples from the schema definitions, checks JSON
round trips, absence/null behavior, closed enums, exact large numbers, and
permitted extra members. It also executes the shared identifier table and
every shared job-filter, job-retry, and gateway URL case, and checks resolved
JSON payloads from the wire, live-query, and worker corpora.
The wire driver additionally executes the transport scenarios against the real
gateway on both signal planes. The worker driver runs every worker case against
the real gateway on both planes as well. The live-query driver executes all
parity cases and table-derived refresh cases.
All shared state-unit cases execute, with separate cache and session suites.
All shared clock subjects run in-process at the protocol timings, including
HTTP waits, scope handoffs, cache saves, discovery, session renewal, device
polling, delegation, invalidation windows and held-job stalls. Every shared
session startup/refusal case also runs, including recovery after an unanswered
renewal. Issuer tests use byte-level HTTP connections for discovery, PKCE,
one-shot callbacks, atomic grant rotation and revocation.
`make test-codegen`'s coverage census holds every case table to a Haskell
test that names it, or to the reason Haskell runs none.

Runtime tests also cover atomic publication of raw replies before request
continuations, channel/correlation matching, tracking cleanup on cancellation,
close waking pending requests, SSE chunk boundaries, and operation ownership.

### Kotlin

`kotlin/` holds the `org.xynolog:xynolog` publication, in `kotlin/sdk`. `make kotlin` builds and stages its packages, and `make test-kotlin` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### Building it

Nothing but a container runtime is needed. In the JDK image `kotlin/sdk/.java-version` names:

```bash
container run --rm -v "$PWD":/w -w /w/kotlin/sdk eclipse-temurin:"$(kotlin/scripts/jdk-version.sh)"-jdk ./gradlew --no-daemon check
```

`check` runs, beside the build and the tests:

- `checkKotlinAbi`: the public API written by hand against the committed dump, `kotlin/sdk/api/sdk.api`. A change to that API is a change to the dump, made with `./gradlew updateKotlinAbi`. What the generator writes is the spec's, and is not in it.
- `javaTest`: the tests under `kotlin/sdk/src/fromJava/java`, which call the SDK as a Java program does. They are Java alone.
- `refusals`: the programs under `kotlin/sdk/src/refusals`, Kotlin and Java, that must not compile against the SDK. Each begins `// refused: <text>`, and the compiler must refuse it with a message holding that text.
- `census`: no source suppresses a warning (every warning is an error, so a suppression is the one way an unchecked cast gets in), and the SDK reads no environment variable but `XYNOLOG_BUS_LOG`.

Every public declaration says it is public: the build runs Kotlin's explicit API mode.

### OCaml

`ocaml/` holds the `xynolog` opam package, in `ocaml/sdk`. `make ocaml` builds and stages its packages, and `make test-ocaml` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### Develop and verify

```sh
make test-ocaml
bash ocaml/check-source-package.sh
```

The first command builds the pinned toolchain in a container and runs the development checks. The second builds and installs an isolated source archive and verifies the installed compiler interface. Regenerate protocol-derived sources with `make generate` and verify them with `make check-generated`.

`make test-ocaml` runs the tests instrumented by `bisect_ppx_ng`, a test dependency for that reason, and CI uploads their line coverage. From `ocaml/sdk`:

```sh
mkdir -p /tmp/ocaml-coverage
BISECT_FILE=/tmp/ocaml-coverage/bisect dune runtest --force --instrument-with bisect_ppx_ng
dune exec -- bisect-ppx-report summary --coverage-path /tmp/ocaml-coverage
```

A test runs in a sandbox that Dune deletes, so `BISECT_FILE` writes the coverage files outside the build.

### Swift

`swift/` holds the `Xynolog` and `XynologTesting` products, in `swift/sdk`, and the distribution a release writes to `xynolog/sdk-swift`, in `swift/distribution`. `make swift` builds and stages its packages, and `make test-swift` runs its tests, type checks, lints and format checks, in its toolchain's container.

#### Working on the SDK

CI runs the SDK tests in the pinned Swift container on Linux and
natively on Apple silicon. Both jobs run the formatter, census, and
compile-failure checks. On a provisioned macOS runner, use
`swift test --jobs 4 --force-resolved-versions` from `swift/sdk`.
The dependency lock includes the OpenTelemetry exporter's macOS dependencies.
Both jobs use the same lock.

Run the Linux checks from the repository root.

```bash
container run --rm --memory 8g -e HOME=/tmp/swift-home -v "$PWD":/w -w /w/swift/sdk "swift:$(swift/scripts/swift-version.sh)" sh -c 'mkdir -p "$HOME" && Scripts/test.sh && Scripts/coverage.sh && swift format lint --strict --recursive . && Scripts/census.sh && Scripts/refusals.sh'
```

Swift 6 language mode and warnings as errors apply to every target. The canary must fail with the concurrency diagnostic. Each future `swift/sdk/Refusals/*.swift` program begins `// refused: <text>` and must fail with that message. The census forbids unchecked concurrency escapes, environment reads beyond `XYNOLOG_BUS_LOG`, and a test wait bounded by anything but `testDeadlineMs`: every test starts at once, and on a small runner a second can pass before a test's tasks are scheduled. The formatter forbids force unwraps, force casts, force tries and implicitly unwrapped optionals throughout the package.

The tests round-trip payloads from the three conformance corpora, run every identifier case, and verify nullable members and open objects.

The models, the tables and the tests' dispatch are generated from `protocol/specs/src` by `make generate` (codegen/lib/swift_sdk) and committed under `swift/sdk/Sources/Xynolog/Generated` and `swift/sdk/Tests/XynologTests/Generated`; the generator's own tests, refused schema shapes among them, are the codegen's. Models keep timestamps and URIs as strings, use checked value types for identifiers, and preserve the three states of an optional nullable member with `Stated`. `JSONValue` carries values in open objects. Required nullable members must be present, even when null.

`swift/sdk/Scripts/test.sh` builds instrumented tests and collects their LLVM profiles directly. `swift/sdk/Scripts/coverage.sh` exports the compiled test libraries, leaving out the generated sources and avoiding SwiftPM's automatic JSON export of dependency coverage.

`swift/sdk/Scripts/install-driver.sh` builds the instrumented Linux wire driver and bundles its Swift runtime. The conformance application chooses OTLP/HTTP exporters when the harness supplies `OTEL_EXPORTER_OTLP_ENDPOINT`. Its runtime matches Ubuntu 26.04. `swift/sdk/Scripts/conformance-coverage.sh` reports the library code the driver exercised, separately from Rust's LLVM profiles.

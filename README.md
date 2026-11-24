# Xynolog SDKs

The Xynolog SDKs build applications on Xynolog knowledge bases, in nine languages. Each one is held to the same [Protocol](https://github.com/xynolog/protocol): its wire types are generated from Protocol's specifications, and it is tested against the same case tables and conformance kit. Every language publishes each release at the same version.

## Install

| Language | Package | Registry | Install | Guide |
| --- | --- | --- | --- | --- |
| TypeScript | `@xynolog/sdk`, with `@xynolog/core`, `@xynolog/http-transport`, `@xynolog/observability` and `@xynolog/react-ui` | [npm](https://www.npmjs.com/package/@xynolog/sdk) | `npm install @xynolog/sdk` | [typescript/sdk](typescript/sdk/README.md) |
| Python | `xynolog` | [PyPI](https://pypi.org/project/xynolog/) | `pip install xynolog` | [python/sdk](python/sdk/README.md) |
| Rust | `xynolog`, with `xynolog-http-transport` and `xynolog-telemetry` | [crates.io](https://crates.io/crates/xynolog), [docs.rs](https://docs.rs/xynolog) | `cargo add xynolog` | [rust/sdk](rust/sdk/README.md) |
| Go | `github.com/xynolog/sdk/go` | [pkg.go.dev](https://pkg.go.dev/github.com/xynolog/sdk/go) | `go get github.com/xynolog/sdk/go` | [go](go/README.md) |
| C# | `Xynolog` | [NuGet](https://www.nuget.org/packages/Xynolog) | `dotnet add package Xynolog` | [csharp/sdk](csharp/sdk/README.md) |
| Kotlin | `org.xynolog:xynolog` | [Maven Central](https://central.sonatype.com/artifact/org.xynolog/xynolog) | `implementation("org.xynolog:xynolog:<version>")` | [kotlin/sdk](kotlin/sdk/README.md) |
| Haskell | `xynolog` | [Hackage](https://hackage.haskell.org/package/xynolog) | `build-depends: xynolog` | [haskell/sdk](haskell/sdk/README.md) |
| OCaml | `xynolog` | [opam](https://opam.ocaml.org/packages/xynolog/) | `opam install xynolog` | [ocaml/sdk](ocaml/sdk/README.md) |
| Swift | `Xynolog`, from [`xynolog/sdk-swift`](https://github.com/xynolog/sdk-swift) | [Swift Package Index](https://swiftpackageindex.com/xynolog/sdk-swift) | `.package(url: "https://github.com/xynolog/sdk-swift.git", .upToNextMinor(from: "<version>"))` | [swift/sdk](swift/sdk/README.md) |

`<version>` is a release's: the [releases](https://github.com/xynolog/sdk/releases) list them. Below 1.0 the minor number is the break, so take releases up to the next minor. Each language's changelog says what each of its releases changed.

## Contributing

[CONTRIBUTING.md](CONTRIBUTING.md) covers building and testing the SDKs, their generated code, changelogs and releases, and what each language keeps.

[CONTRACTS.md](CONTRACTS.md) counts every contract Protocol states and how many of its items each SDK declares.

## License

Apache-2.0. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE) for attribution.

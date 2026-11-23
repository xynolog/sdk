# Rust

[![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=rust)](https://app.codecov.io/gh/xynolog/sdk/components)

These are how a Rust program uses Xynolog. What the Rust services share, and each service's own crates, are beside the services' binaries in [images/](https://github.com/xynolog/images/blob/main/README.md).

| Crate | Published | Coverage | What it is |
|---|---|---|---|
| [xynolog](./sdk/README.md) | [![crates.io](https://img.shields.io/crates/v/xynolog.svg)](https://crates.io/crates/xynolog) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=rust-sdk)](https://app.codecov.io/gh/xynolog/sdk/components) | The Rust SDK: the client of a knowledge base, the protocol's types, sessions and state units |
| [xynolog-http-transport](./http-transport/README.md) | [![crates.io](https://img.shields.io/crates/v/xynolog-http-transport.svg)](https://crates.io/crates/xynolog-http-transport) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=rust-http-transport)](https://app.codecov.io/gh/xynolog/sdk/components) | The SDK's transport over a gateway, and signing a person or a service in |
| [xynolog-telemetry](./telemetry/README.md) | [![crates.io](https://img.shields.io/crates/v/xynolog-telemetry.svg)](https://crates.io/crates/xynolog-telemetry) | [![codecov](https://codecov.io/gh/xynolog/sdk/graph/badge.svg?component=rust-telemetry)](https://app.codecov.io/gh/xynolog/sdk/components) | The SDK's spans and counts, reported to whatever OpenTelemetry the application installed. It exports nothing |

## Where things are

- One Cargo workspace, rooted here: [`Cargo.toml`](./Cargo.toml) names these crates, beside [`Cargo.lock`](./Cargo.lock), cargo-deny's [`deny.toml`](./deny.toml) and the [`rust-toolchain.toml`](./rust-toolchain.toml) every Rust build takes its compiler from. Run `cargo` here; its build output is `target/`.
- `make test-rust` runs the crates' tests under `cargo llvm-cov`, and CI uploads its report to Codecov under the flag `rust`, and each crate's badge reads the component of its directory, `rust-<directory>`. The doctests run apart and unmeasured: `cargo llvm-cov` measures them on nightly Rust alone.

The other languages, and which SDK a program installs, are in [packages/](../README.md).

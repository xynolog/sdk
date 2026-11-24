# Changelog

The changes to the Xynolog SDK for Rust, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.

### Changed

- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A schema of one integer, number or boolean is an alias of that type
  (`HttpStatus`).
- `OpenResource` is `xynolog::types::OpenResource`, the type Protocol states,
  in place of `xynolog::session::OpenResource`.

## 0.8.1

### Added

- The crates declare `rust-version = "1.89"`, the oldest Rust that builds
  them, which Cargo's MSRV-aware resolver reads.

### Changed

- docs.rs documents `xynolog` and `xynolog-http-transport` with every
  feature, and labels each feature-gated item with the feature it needs.
- Each crate's README reads as its crates.io page: what the crate is, how to
  install it (`cargo add`, whose requirement takes releases up to the next
  minor), and, for `xynolog`, a first program before connecting and the
  eight verbs. How the crates' own READMEs are held to their tests moved to
  the repository's CONTRIBUTING.md, which each README's last line links to.
- Each crate's README links to the repository's files at the release's tag,
  so its links resolve on crates.io and show the files as of the release.
- Each crate's coverage badge reads that crate: `make test-rust` measures
  the tests under `cargo llvm-cov`, and CI uploads the report to Codecov.
  The Rust README no longer lists the crates the Rust services share, which
  images holds.

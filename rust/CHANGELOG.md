# Changelog

The changes to the Xynolog SDK for Rust, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

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

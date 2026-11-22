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

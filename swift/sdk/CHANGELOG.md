# Changelog

The changes to the Xynolog SDK for Swift, release by release. A release's
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

## 0.8.1

### Added

- The distribution carries a `.spi.yml`, so the Swift Package Index hosts
  the DocC documentation of `Xynolog` and `XynologTesting`.
- The README reads as the package's front page: what the SDK is, how to
  install it (by `xynolog/sdk-swift`'s URL, taking releases up to the next
  minor), and a first program before connecting, signing in and the eight
  verbs. How to work on the SDK moved to the repository's CONTRIBUTING.md,
  which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve wherever the Swift Package Index shows it and show the
  files as of the release.
- The distribution's README is this README, as of the release, in place of
  a short page that pointed at it on `main`: the Swift Package Index shows
  the package's whole README.

### Changed

- The README's coverage badge reads the package: `make test-swift` exports
  the tests' coverage with `Scripts/coverage.sh`, which leaves out the build
  directory wherever its link leads, and CI uploads it to Codecov.

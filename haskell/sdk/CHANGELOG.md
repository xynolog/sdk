# Changelog

The changes to the Xynolog SDK for Haskell, release by release. A release's
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
- A value is validated against its schema as Protocol states it: `const`,
  `not`, `propertyNames` and `minProperties` among its keywords, and those of
  a schema that states no `type`.

## 0.8.1

### Added

- Builds with GHC 9.12 as well as 9.10 (`base < 4.22`, `time < 1.15`), as
  `tested-with` states.
- Hackage shows the package's homepage, bug tracker, source repository and
  this changelog.
- The README is Hackage's page for the package: it says what the SDK is, how
  to add it to `build-depends` and take releases up to the next minor, and
  then shows a first program, which connects and reads the knowledge base's
  name, before signing in and the eight verbs. How the SDK itself is built
  and checked moves to CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on Hackage and show the files as of the release.

### Changed

- The README's coverage badge reads the package: `make test-haskell` writes
  the suite's coverage, less Cabal's generated `Paths_xynolog`, and CI
  uploads it to Codecov.

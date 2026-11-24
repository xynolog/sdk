# Changelog

The changes to the Xynolog SDK for Python, release by release. A release's
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
- `OpenResource` is `xynolog.types.OpenResource`, in place of
  `xynolog.stored.OpenResource`. Its bounds are held by the required table as
  the registry reads what it stored.
- What is kept of a sign-in is `xynolog.types.StoredSession`, in place of
  `xynolog.session.HeldSignIn`; a changed one is made with `model_copy`.

## 0.8.1

### Changed

- `cryptography` has no upper bound, so `xynolog` installs beside a project
  that takes cryptography's next major version.
- PyPI's Documentation link opens the README as of the release, and its
  Changelog link this file.
- The README is PyPI's page for the package: it says what the SDK is, how to
  install it and take releases up to the next minor, and then shows a first
  program before signing in and the eight verbs. How the SDK itself is
  checked moves to CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on PyPI and show the files as of the release.
- The README's coverage badge reads the package: `make test-python` measures
  the tests, and CI uploads the report to Codecov.

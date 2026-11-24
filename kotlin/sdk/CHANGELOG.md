# Changelog

The changes to the Xynolog SDK for Kotlin, release by release. A release's
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
  (`HttpStatus`), and a union reads a member that is a number or a boolean.

## 0.8.1

### Added

- The publication carries the POM Maven Central takes (name, description,
  URL, license, developer, SCM, issue tracker), a sources jar and a javadoc
  jar.

### Changed

- The README is the artifact's front page: it says what the SDK is, how to
  depend on it with Gradle or Maven and take releases up to the next minor,
  and then shows a first program, connecting to a knowledge base and saying
  its name, before connecting, signing in and the eight verbs. How the SDK
  itself is built moves to CONTRIBUTING.md, which the README's last line
  links to.

### Fixed

- kotlinx-serialization-json and kotlinx-coroutines-core are `api`
  dependencies, in the POM's compile scope: the public API takes and
  returns their types (`JsonObject`, `KSerializer`, `StateFlow`), so a
  consumer compiles against them without declaring them itself.

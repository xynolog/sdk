# Changelog

The changes to the Xynolog SDK for Kotlin, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

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

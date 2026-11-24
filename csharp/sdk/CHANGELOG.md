# Changelog

The changes to the Xynolog SDK for C#, release by release. A release's
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
- A value is validated against every keyword of its schema: `const`, `not`,
  `propertyNames` and `minProperties` among them, each keyword beside a
  `oneOf` or an `anyOf`, and those of a schema that states no `type`. A value
  is one of a `oneOf`'s variants exactly.

## 0.8.1

### Added

- The package targets .NET 10, the LTS release, as well as .NET 11.
- A symbols package (`.snupkg`) beside the package, with Source Link to the
  release's commit, so a debugger steps into the SDK's source.
- nuget.org shows the package's license (Apache-2.0), project and repository
  URLs and tags.
- The package ships XML documentation (`lib/<tfm>/Xynolog.xml`), so
  IntelliSense and NuGet show a summary for every hand-written public member;
  a missing or malformed doc comment fails the build.

### Changed

- The README is NuGet's page for the package: it says what the SDK is, how to
  install it with `dotnet add package` and take releases up to the next
  minor, and then shows a first program, connecting to a knowledge base and
  asking its name, before signing in and the eight verbs. How the SDK itself
  is built and verified moves to CONTRIBUTING.md, which the README's last
  line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on NuGet and show the files as of the release.
- The README's coverage badge reads the package: `make test-csharp` writes
  the suite's coverage as lcov, and CI uploads it to Codecov.

### Fixed

- A request its gateway refused is sent again with the token its renewal
  gave, or the one it was first sent with. It was sent with whatever token
  the transport held by then, which was none once the session had withdrawn
  its token in between.
- A browser closes a session only once its check of what is open in the
  knowledge base has stopped. A check still under way sent through the
  closed session, and the browser's disposal threw
  `ObjectDisposedException`.

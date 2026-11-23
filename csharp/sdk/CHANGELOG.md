# Changelog

The changes to the Xynolog SDK for C#, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.1

### Added

- The package targets .NET 10, the LTS release, as well as .NET 11.
- A symbols package (`.snupkg`) beside the package, with Source Link to the
  release's commit, so a debugger steps into the SDK's source.
- nuget.org shows the package's license (Apache-2.0), project and repository
  URLs and tags.

### Changed

- The README is NuGet's page for the package: it says what the SDK is, how to
  install it with `dotnet add package` and take releases up to the next
  minor, and then shows a first program, connecting to a knowledge base and
  asking its name, before signing in and the eight verbs. How the SDK itself
  is built and verified moves to CONTRIBUTING.md, which the README's last
  line links to.

### Fixed

- A request its gateway refused is sent again with the token its renewal
  gave, or the one it was first sent with. It was sent with whatever token
  the transport held by then, which was none once the session had withdrawn
  its token in between.
- A browser closes a session only once its check of what is open in the
  knowledge base has stopped. A check still under way sent through the
  closed session, and the browser's disposal threw
  `ObjectDisposedException`.

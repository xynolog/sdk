# Changelog

The changes to the Xynolog SDK for Haskell, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

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

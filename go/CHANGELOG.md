# Changelog

The changes to the Xynolog SDK for Go, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

## 0.8.1

### Added

- Examples on pkg.go.dev: a client over the HTTP transport, an agent
  signed in at its issuer, and a resource's text read over `xynologtest`'s
  doubles.

### Changed

- The module requires Go 1.26, not 1.27.
- The README is pkg.go.dev's page for the module: it says what the SDK is,
  how to install it and take releases up to the next minor, and then shows a
  first program before signing in and the eight verbs. How the SDK itself is
  regenerated and checked moves to CONTRIBUTING.md, which the README's last
  line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on pkg.go.dev and show the files as of the release.

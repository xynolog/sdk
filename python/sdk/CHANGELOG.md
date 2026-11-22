# Changelog

The changes to the Xynolog SDK for Python, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

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

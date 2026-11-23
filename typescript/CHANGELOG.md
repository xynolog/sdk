# Changelog

The changes to the Xynolog SDK for TypeScript, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.1

### Changed

- Each package's npm page links to the repository's README and to its
  issues (`homepage`, `bugs`).
- `@xynolog/react-ui` no longer ships its components' TypeScript sources:
  of `src/components` and `src/features` it carries the CSS alone, which its
  stylesheets import.
- Each package's README reads as its npm page: what the package is, how to
  install it (`npm install`, taking releases up to the next minor), a first
  program, and, for `@xynolog/sdk`, connecting and signing in and the eight
  verbs. How to work on the packages moved to the repository's
  CONTRIBUTING.md.
- Each package's README links to the repository's files at the release's
  tag, so its links resolve on npm and show the files as of the release.
- Each package's coverage badge reads that package: `make test-typescript`
  measures every package's tests, `@xynolog/react-ui`'s in its four shards,
  and CI uploads the reports to Codecov.

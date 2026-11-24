# Changelog

The changes to the Xynolog SDK for Go, release by release. A release's
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
- A schema of an object that names no members is a type of its own
  (`type BrowseKbRequest map[string]any`), not an alias of `map[string]any`.
- `OpenResource` is `api.OpenResource`, the type Protocol states, in place of
  `registry.OpenResource`: its `Id` and `StorageUri` are spelled as Protocol
  spells them, and a media type or storage URI it does not know is nil.
- What is kept of a sign-in is `api.StoredSession`, in place of
  `HeldSignIn`: its `ClientId` is spelled as Protocol spells it, and an issuer
  with no revocation endpoint states none (nil).

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

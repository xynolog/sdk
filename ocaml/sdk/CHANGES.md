# Changelog

The changes to the Xynolog SDK for OCaml, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.1

- The package installs on OCaml 5.5 and later, not on 5.5.2 alone.
- ocamlformat and bisect_ppx_ng are development tools of the repository
  (`with-dev-setup`), so `opam install --with-test xynolog` no longer
  installs them.
- The GitHub release carries the opam source archive as an asset of its
  own, for an opam-repository entry's `url` to name.
- The README is opam's page for the package: it says what the SDK is, how
  to install it and take releases up to the next minor, and then shows a
  first program, which connects with a token the reader holds and prints
  the knowledge base's description of itself, before signing in and the
  eight verbs. How the SDK itself is built and checked moves to
  CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on opam and show the files as of the release.

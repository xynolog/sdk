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

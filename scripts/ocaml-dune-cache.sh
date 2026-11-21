# The xynolog-ocaml-toolchain containers keep dune's shared cache on the host,
# so that a dune workspace's locked packages, the compiler first, are built
# once and restored after, in this run's other containers and in later runs.
# Dune keeps a package's build only when it caches every rule, and the
# workspace's _build and the mounted cache are on different file systems, so
# entries are copied rather than hard-linked. A cached package can hold the
# path of the workspace that built it (ocamlfind's configuration does), and a
# package built later reads that path. So each workspace has a cache of its
# own, and every container builds a workspace at /tmp/sdk/<its path>. CI
# caches each directory (.github/actions/restore-ocaml-dune-cache).

# ocaml_dune_cache_dir WORKSPACE: the host directory of the dune workspace's
# cache, WORKSPACE being its path from the checkout's root.
ocaml_dune_cache_dir() {
  printf '%s\n' "$HOME/.cache/xynolog/ocaml-dune/$1"
}

# ocaml_dune_cache_options WORKSPACE: set OCAML_DUNE_CACHE_OPTIONS to the
# options a container that builds the workspace runs with.
ocaml_dune_cache_options() {
  local cache
  cache="$(ocaml_dune_cache_dir "$1")"
  mkdir -p "$cache"
  OCAML_DUNE_CACHE_OPTIONS=(
    --volume "$cache:/home/opam/.cache/dune"
    --env DUNE_CACHE=enabled
    --env DUNE_CACHE_STORAGE_MODE=copy
  )
}

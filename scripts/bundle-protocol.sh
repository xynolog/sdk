#!/usr/bin/env bash
# Write the pinned Protocol's bundles, each one the reader writes into specs/
# (xynolog-protocol bundle), into the protocol checkout. The SDKs' builds and
# tests read them there; Protocol commits only their sources. The reader is
# built in the generator's workspace, which vendors the pinned Protocol, on
# the OCaml toolchain's image.
#
# The bundles a build wrote are kept in a store outside the checkout, named by
# a fingerprint of all the reader is built and run from: the pinned
# Protocol's commit, the toolchain image's tag, and the generator's workspace
# as its container is handed it. A later run with the same fingerprint copies
# them from the store, and builds no image and runs no container. CI caches
# the store (.github/actions/restore-protocol-bundles).
#
#   bundle-protocol.sh            write the bundles
#   bundle-protocol.sh --store    print the store's directory, the fingerprint
#                                 its name
#   bundle-protocol.sh --builds   print the dune workspace a run builds: none
#                                 when the store holds the bundles
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
source "$ROOT/build-tools/container-runtime.sh"
source "$ROOT/scripts/run-container-quietly.sh"
source "$ROOT/scripts/require-protocol-pin.sh"
source "$ROOT/scripts/ocaml-dune-cache.sh"

usage() {
  echo 'Usage: bundle-protocol.sh [--store | --builds]' >&2
  exit 2
}
(($# <= 1)) || usage

# What the reader's container is handed of the generator's workspace, which
# vendors the pinned Protocol through its protocol symlink.
EXCLUDED=(_build .git)

revision="$(require_protocol_pin "$ROOT")"
key="$(python3 - "$ROOT/codegen" "$revision" "$(bash "$ROOT/build-tools/ocaml/toolchain-image.sh" --tag)" "${EXCLUDED[@]}" <<'PYTHON'
import hashlib
import os
import sys

workspace, revision, tag, *excluded = sys.argv[1:]
digest = hashlib.sha256(f'{revision}\0{tag}\0'.encode())
for directory, subdirectories, files in os.walk(workspace):
    for name in sorted(subdirectories + files):
        path = os.path.join(directory, name)
        if name in excluded:
            continue
        relative = os.path.relpath(path, workspace)
        if os.path.islink(path):
            digest.update(f'link\0{relative}\0{os.readlink(path)}\0'.encode())
        elif os.path.isfile(path):
            with open(path, 'rb') as source:
                digest.update(f'file\0{relative}\0{hashlib.sha256(source.read()).hexdigest()}\0'.encode())
    subdirectories[:] = [name for name in subdirectories
                         if name not in excluded and not os.path.islink(os.path.join(directory, name))]
print(digest.hexdigest())
PYTHON
)"
store="$HOME/.cache/xynolog/protocol-bundles/$key"

case "${1:-}" in
  --store) echo "$store"; exit ;;
  --builds) if [[ -d "$store" ]]; then echo none; else echo codegen; fi; exit ;;
  '') ;;
  *) usage ;;
esac

if [[ -d "$store" ]]; then
  bundles=("$store"/*.json)
  [[ -e "${bundles[0]}" ]] || { echo "bundle-protocol.sh: $store holds no bundles" >&2; exit 1; }
  cp -f "${bundles[@]}" "$ROOT/protocol/specs/"
  echo "Protocol bundles of pinned revision $revision, from $store."
  exit
fi

echo "Building protocol bundles from pinned revision $revision…"
RUNTIME="$(detect_container_runtime)"
run_container_quietly bash "$ROOT/build-tools/ocaml/toolchain-image.sh" "$ROOT/codegen"
ocaml_dune_cache_options codegen
mkdir -p "$(dirname "$store")"
staging="$(mktemp -d "$store.XXXXXX")"
tar_excludes=()
for name in "${EXCLUDED[@]}"; do tar_excludes+=("--exclude=$name"); done
# The reader writes only the bundles into specs/, so the copy holds none
# before it runs: the store keeps exactly what it wrote.
run_container_quietly "$RUNTIME" run --rm \
  --volume "$ROOT/codegen:/source/codegen:ro" \
  --volume "$ROOT/protocol:/source/protocol:ro" \
  --volume "$staging:/bundles" \
  --workdir /tmp --memory 4g "${OCAML_DUNE_CACHE_OPTIONS[@]}" \
  xynolog-ocaml-toolchain bash -euc '
    mkdir /tmp/sdk
    tar -C /source "$@" -cf - codegen protocol | tar -C /tmp/sdk -xf -
    rm -f /tmp/sdk/protocol/specs/*.json
    cd /tmp/sdk/codegen
    dune exec -- xynolog-protocol bundle ../protocol
    cp ../protocol/specs/*.json /bundles/
  ' bash "${tar_excludes[@]}"
bundles=("$staging"/*.json)
[[ -e "${bundles[0]}" ]] || { echo 'bundle-protocol.sh: the reader wrote no bundles' >&2; exit 1; }
cp -f "${bundles[@]}" "$ROOT/protocol/specs/"
if [[ -e "$store" ]]; then
  rm -rf "$staging"
else
  mv "$staging" "$store"
fi

#!/usr/bin/env bash
# reads-protocol-bundles.sh LANGUAGE...: print true when the artifact of any
# language named reads the Protocol bundles bundle-protocol.sh writes, and
# false when none does. Haskell's container is handed haskell/sdk alone, and
# Swift's copies LICENSE and swift/ alone (publish-other-local.sh). Protocol
# commits none of the bundles, so either artifact, were it to come to read
# them, would fail on a fresh checkout.
set -euo pipefail

if (($# == 0)); then
  echo 'Usage: reads-protocol-bundles.sh LANGUAGE...' >&2
  exit 2
fi
for language in "$@"; do
  case "$language" in
    haskell|swift) ;;
    *) echo true; exit ;;
  esac
done
echo false

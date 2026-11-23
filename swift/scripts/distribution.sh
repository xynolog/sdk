#!/bin/sh
# Assemble the Swift distribution package, the tree a release writes to
# xynolog/sdk-swift, and prove it installs.
#
#   swift/scripts/distribution.sh <version> <out dir>
#
# The tree, <out dir>/sdk-swift, holds the SDK's library targets, a manifest
# and a Swift Package Index .spi.yml that distribution-manifest.py derives
# from swift/sdk's, and the LICENSE, NOTICE, README and changelog. It is then
# installed as an application installs it (consume-distribution.sh), and the
# distribution's consumer built on it. Run in the pinned Swift container, from
# a checkout with python3 and git on the path.
set -eu
version=$1
tree="$2/sdk-swift"
root=$(CDPATH='' cd "$(dirname "$0")/../.." && pwd)
manifest="$root/swift/scripts/distribution-manifest.py"
work=$(mktemp -d)
test ! -e "$tree" || { echo "distribution.sh: $tree already exists" >&2; exit 1; }

cd "$root/swift/sdk"
swift package dump-package > "$work/dump.json"
python3 "$manifest" manifest "$work/dump.json" > "$work/Package.swift"
mkdir -p "$tree/Sources"
mv "$work/Package.swift" "$tree/Package.swift"
python3 "$manifest" spi "$work/dump.json" > "$tree/.spi.yml"
python3 "$manifest" targets "$work/dump.json" > "$work/targets"
while IFS= read -r target; do cp -a "Sources/$target" "$tree/Sources/$target"; done < "$work/targets"
cp "$root/LICENSE" "$root/swift/distribution/NOTICE" "$root/swift/distribution/README.md" "$root/swift/sdk/CHANGELOG.md" "$tree/"

sh "$root/swift/scripts/consume-distribution.sh" "$tree" "$version" "$root/swift/distribution/consumer"

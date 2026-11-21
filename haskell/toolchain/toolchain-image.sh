#!/usr/bin/env bash
# toolchain-image.sh: tag the Haskell toolchain's image
# xynolog-haskell-toolchain. The image is built only from this directory,
# its build context, and the GHC version toolchain.sh reads, so it is tagged
# by their digest too, and built only when no image has that tag: one an
# earlier run built, or a CI job loaded from its cache, is used as it is.
# Its base images' packages are those of the build that made it, until what
# it is built from changes.
#
# toolchain-image.sh --tag prints that tag.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd -P)"
GHC_VERSION="$(bash "$HERE/toolchain.sh" --ghc)"

image_tag() {
  python3 - "$HERE" "$GHC_VERSION" <<'PYTHON'
import hashlib
from pathlib import Path
import sys
context, ghc_version = Path(sys.argv[1]), sys.argv[2]
digest = hashlib.sha256(ghc_version.encode() + b'\0')
for path in sorted(p for p in context.rglob('*') if p.is_file()):
    digest.update(path.relative_to(context).as_posix().encode() + b'\0')
    digest.update(hashlib.sha256(path.read_bytes()).digest())
print('xynolog-haskell-toolchain:' + digest.hexdigest()[:16])
PYTHON
}

case "$*" in
  --tag) image_tag; exit ;;
  '') ;;
  *) echo 'Usage: toolchain-image.sh [--tag]' >&2; exit 2 ;;
esac

source "$HERE/../../build-tools/container-runtime.sh"
RUNTIME="$(detect_container_runtime)"
IMAGE="$(image_tag)"
if ! "$RUNTIME" image inspect "$IMAGE" >/dev/null 2>&1; then
  "$RUNTIME" build --build-arg "GHC_VERSION=$GHC_VERSION" \
    --tag "$IMAGE" --file "$HERE/Dockerfile" "$HERE"
fi
"$RUNTIME" image tag "$IMAGE" xynolog-haskell-toolchain

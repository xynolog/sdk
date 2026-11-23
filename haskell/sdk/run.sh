#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
# One plan for the build and for --only-dependencies, so the dependencies
# built alone are the ones the build uses.
build=(cabal build all --enable-tests --enable-coverage)
ormolu=/tmp/ormolu/ormolu
(cd ../toolchain/ormolu && cabal install ormolu --installdir="$(dirname "$ormolu")" \
  --install-method=copy --overwrite-policy=always)
if [[ "${1:-}" == --only-dependencies ]]; then
  "${build[@]}" --only-dependencies
  exit
fi
root=${1:?expected repository root or --only-dependencies}
bash ../toolchain/toolchain.sh --check
cabal check
find src internal test conformance generated -name '*.hs' -exec "$ormolu" --mode check {} +
"${build[@]}"
mkdir -p conformance/bin
for role in wire live; do
  name="xynolog-haskell-$role-driver"
  cp "$(cabal list-bin "$name")" "conformance/bin/$name.native"
  cp conformance/launch.sh "conformance/bin/$name"
  chmod +x "conformance/bin/$name"
done
python3 api.py --compiler-check
cabal test schema-cases --enable-coverage --test-show-details=direct --test-options="$root"
python3 test/refusals.py
cabal exec -- hpc-codecov --format=lcov --ignore-dittos -x Main -x Paths_xynolog cabal:schema-cases -o coverage.lcov
cabal sdist

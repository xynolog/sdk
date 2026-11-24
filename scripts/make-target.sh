#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
source "$ROOT/build-tools/container-runtime.sh"
source "$ROOT/scripts/require-protocol-pin.sh"
source "$ROOT/scripts/ocaml-dune-cache.sh"

usage() {
  echo 'Usage: make-target.sh test-<language>|haskell-dependencies|test-codegen|test-tooling|generate|check-generated|codegen-binary DIRECTORY' >&2
  echo '       make-target.sh --ocaml-toolchain TARGET' >&2
  exit 2
}

# What a target builds on of the OCaml toolchain. OCAML_WORKSPACE: the dune
# workspace whose locked packages its own toolchain containers build, so whose
# cache they mount; none when it runs none. READS_BUNDLES: whether it reads the
# Protocol bundles, which bundle-protocol.sh writes, or copies from its store.
ocaml_toolchain_use() {
  case "$1" in
    test-typescript|test-python|test-rust|test-csharp|test-kotlin)
      OCAML_WORKSPACE=none READS_BUNDLES=true ;;
    generate|check-generated) OCAML_WORKSPACE=codegen READS_BUNDLES=true ;;
    test-codegen|codegen-binary) OCAML_WORKSPACE=codegen READS_BUNDLES=false ;;
    test-ocaml) OCAML_WORKSPACE=ocaml/sdk READS_BUNDLES=false ;;
    test-go|test-swift|test-haskell|haskell-dependencies|test-tooling)
      OCAML_WORKSPACE=none READS_BUNDLES=false ;;
    *) usage ;;
  esac
}

# --ocaml-toolchain TARGET prints, as a line CI adds to a step's outputs, the
# dune workspace a run of the target builds: its own containers', else the
# Protocol bundles' when it reads them and their store lacks them, else none.
# The tests job restores the toolchain's image and dune cache for it alone.
if [[ "${1:-}" == --ocaml-toolchain ]]; then
  (($# == 2)) || usage
  ocaml_toolchain_use "$2"
  workspace="$OCAML_WORKSPACE"
  if [[ "$workspace" == none && "$READS_BUNDLES" == true ]]; then
    workspace="$(bash "$ROOT/scripts/bundle-protocol.sh" --builds)"
  fi
  printf 'workspace=%s\n' "$workspace"
  exit
fi
ocaml_toolchain_use "${1:-}"
if [[ "$1" == codegen-binary ]]; then
  (($# == 2)) || usage
fi

RUNTIME="$(detect_container_runtime)"
require_protocol_pin "$ROOT" >/dev/null

# Run a language's checks in its toolchain's container, on a copy of the
# checkout laid out as the checkout is, with the Protocol bundles built.
COPY=/tmp/sdk
in_container() {
  local image="$1" script="$2"
  shift 2
  "$RUNTIME" run --rm --volume "$ROOT:/source:ro" --workdir /tmp "$@" "$image" \
    bash -euc "cp -a /source $COPY
$script"
}

# A language's tests measure their coverage, and its container writes each
# report into /coverage, the directory COVERAGE mounts, as its tool names the
# sources. coverage_reports writes them into coverage/<language>/ by the
# checkout's paths (coverage-report.py), where CI uploads them to Codecov
# (codecov.py). A container writes its reports there flat: a directory it
# made would be root's, and the trap could not empty it.
measure_coverage() {
  COVERAGE="$(mktemp -d "${TMPDIR:-/tmp}/xynolog-sdk-coverage.XXXXXX")"
  trap 'rm -rf "$COVERAGE"' EXIT
}
coverage_reports() {
  local language="$1"
  shift
  rm -rf "$ROOT/coverage/$language"
  mkdir -p "$ROOT/coverage/$language"
  python3 "$ROOT/scripts/coverage-report.py" "$1" "$COVERAGE" "$ROOT/coverage/$language" "$COPY" "${@:2}"
}

# The OCaml toolchain's image, which the SDK and the generator build on, each
# held to build-tools' pins, then the target's dune cache and the Protocol
# bundles, as ocaml_toolchain_use says.
if [[ "$OCAML_WORKSPACE" != none ]]; then
  bash "$ROOT/build-tools/ocaml/toolchain-image.sh" "$ROOT/ocaml/sdk" "$ROOT/codegen"
  ocaml_dune_cache_options "$OCAML_WORKSPACE"
fi
if [[ "$READS_BUNDLES" == true ]]; then
  bash "$ROOT/scripts/bundle-protocol.sh"
fi

case "${1:-}" in
  test-typescript)
    measure_coverage
    in_container node:26-bookworm '
      # The censuses ask git what the repository holds, and the copy belongs
      # to another user than the container runs as.
      git config --global --add safe.directory /tmp/sdk
      cd /tmp/sdk/typescript
      npm install --no-package-lock
      npm run format:check
      npm run build:packages
      npm run typecheck --workspaces
      npm run typecheck:conformance --workspaces --if-present
      npm run lint:css --workspace=@xynolog/react-ui
      node react-ui/scripts/check-no-utility-classes-in-react-ui.cjs
      node react-ui/scripts/check-css-variables-defined.cjs
      node react-ui/scripts/check-css-classes-live.cjs
      node scripts/compliance/audit-hooks-ordering.mts
      bash scripts/compliance/audit-gathered-context-component-state.sh
      bash scripts/compliance/audit-session-typed-factories.sh
      bash react-ui/scripts/audit-toolbar-pref-storage.sh
      npm run test:coverage --workspaces
      find . -name node_modules -prune -o -name lcov.info -print | while read -r report; do
        name="${report#./}"
        cp "$report" "/coverage/${name//\//-}"
      done' --memory 4g --volume "$COVERAGE:/coverage"
    coverage_reports typescript lcov .
    ;;
  test-tooling)
    in_container node:26-bookworm '
      # The census asks git what the repository holds, and the copy belongs
      # to another user than the container runs as.
      git config --global --add safe.directory /tmp/sdk
      cd /tmp/sdk/typescript
      npm install --no-package-lock
      npx tsc -p tsconfig.scripts.json
      npx tsc -p tsconfig.configs.json
      node scripts/tsconfig-census.mjs' --memory 4g
    in_container python:3.12-bookworm '
      # pyright is a Node program, and its Python wrapper runs the node it
      # finds on PATH.
      apt-get update -qq
      apt-get install -y -qq --no-install-recommends nodejs > /dev/null
      python -m pip install --disable-pip-version-check --no-cache-dir --root-user-action=ignore uv
      git config --global --add safe.directory /tmp/sdk
      (cd /tmp/sdk/python/sdk && uv sync --locked)
      bash /tmp/sdk/scripts/check-python-tooling.sh' --memory 4g
    ;;
  test-python)
    measure_coverage
    in_container python:3.12-bookworm '
      # pyright is a Node program, and its Python wrapper runs the node it
      # finds on PATH.
      apt-get update -qq
      apt-get install -y -qq --no-install-recommends nodejs > /dev/null
      python -m pip install --disable-pip-version-check --no-cache-dir --root-user-action=ignore uv
      cd /tmp/sdk/python/sdk
      uv sync --locked
      uv run mypy
      uv run pyright
      uv run mypy --platform win32
      uv run pyright --pythonplatform Windows
      uv run ruff check
      uv run ruff format --check
      uv run pytest --cov --cov-report=lcov:/coverage/python.lcov' --memory 4g --volume "$COVERAGE:/coverage"
    coverage_reports python lcov python/sdk
    ;;
  test-rust)
    measure_coverage
    in_container "rust:$(sh "$ROOT/rust/scripts/rust-toolchain.sh")-bookworm" '
      cd /tmp/sdk/rust
      cargo fmt --all --check
      rustfmt --edition 2024 --check sdk/src/generated/*.rs
      cargo clippy --workspace --all-targets --all-features --locked -- -D warnings
      # cargo-llvm-cov runs every test but the doctests, which it measures on
      # nightly alone: they run apart, unmeasured.
      rustup component add llvm-tools
      cargo install --locked cargo-llvm-cov@0.9.1
      cargo llvm-cov --workspace --all-features --locked --lcov --output-path /coverage/rust.lcov
      cargo test --doc --workspace --all-features --locked' --memory 4g --volume "$COVERAGE:/coverage"
    coverage_reports rust lcov rust
    ;;
  test-go)
    measure_coverage
    in_container "golang:$(sh "$ROOT/go/scripts/go-toolchain.sh")-bookworm" '
      cd /tmp/sdk/go
      unformatted="$(gofmt -l .)"
      if [ -n "$unformatted" ]; then echo "not as gofmt writes them:"; echo "$unformatted"; exit 1; fi
      go vet ./...
      go test -race -coverprofile=/coverage/coverage.txt -covermode=atomic ./...' \
      --volume "$COVERAGE:/coverage"
    coverage_reports go go go
    ;;
  test-csharp)
    measure_coverage
    in_container "mcr.microsoft.com/dotnet/sdk:$(sh "$ROOT/csharp/scripts/dotnet-version.sh" --image-tag)" '
      cd /tmp/sdk/csharp/sdk
      test "$(dotnet --version)" = "$(sh ../scripts/dotnet-version.sh)"
      dotnet build -p:RestoreLockedMode=true
      dotnet test --no-build --settings test.runsettings --results-directory /tmp/test-results
      # The collector writes its report into a directory of its own.
      set -- /tmp/test-results/*/coverage.info
      test "$#" -eq 1
      cp "$1" /coverage/csharp.lcov
      # The generated files too, but not those a package compiles in.
      dotnet format --no-restore --verify-no-changes --include-generated --exclude "$HOME/.nuget/packages"' --memory 4g \
      --volume "$COVERAGE:/coverage"
    coverage_reports csharp lcov csharp
    ;;
  test-kotlin)
    # Gradle's home (the wrapper's distribution, and the plugins and
    # dependencies it fetches) outlives the container. CI's tests job caches
    # this directory.
    gradle_home="$HOME/.cache/xynolog/kotlin-gradle"
    mkdir -p "$gradle_home"
    measure_coverage
    in_container "eclipse-temurin:$(sh "$ROOT/kotlin/scripts/jdk-version.sh")-jdk" '
      cd /tmp/sdk/kotlin/sdk
      ./gradlew --no-daemon --console=plain check
      cp build/reports/jacoco/test/jacocoTestReport.xml /coverage/kotlin.xml' --memory 4g \
      --volume "$gradle_home:/gradle" --env GRADLE_USER_HOME=/gradle --volume "$COVERAGE:/coverage"
    coverage_reports kotlin jacoco kotlin/sdk/src/main/kotlin kotlin/sdk/src/generated/kotlin
    ;;
  test-swift)
    # SwiftPM's build directory (the dependencies' checkouts and what every
    # build compiled of them, the refusals' canary build too) outlives the
    # container. CI's tests job caches this directory, once the checks pass,
    # as the runner's user; the container's root writes some of it readable
    # by root alone.
    swift_build="$HOME/.cache/xynolog/swift-build"
    mkdir -p "$swift_build"
    measure_coverage
    in_container "swift:$(sh "$ROOT/swift/scripts/swift-version.sh")" '
      cd /tmp/sdk/swift/sdk
      rm -rf .build
      ln -s /swift-build .build
      Scripts/test.sh
      Scripts/coverage.sh
      mv .build/coverage.lcov /coverage/swift.lcov
      swift format lint --strict --recursive .
      Scripts/census.sh
      Scripts/refusals.sh
      find /swift-build -mindepth 1 -exec chmod a+rX {} +' --memory 4g --volume "$swift_build:/swift-build" \
      --volume "$COVERAGE:/coverage"
    coverage_reports swift lcov swift
    ;;
  test-haskell|haskell-dependencies)
    bash "$ROOT/haskell/toolchain/toolchain-image.sh"
    # Cabal's home (its index and the store of built dependencies) outlives
    # the container, so a run builds only what changed since the last one.
    # CI's tests job caches this directory, once haskell-dependencies has
    # built every dependency into it.
    cabal_home="$HOME/.cache/xynolog/haskell-cabal"
    mkdir -p "$cabal_home"
    if [[ "$1" == haskell-dependencies ]]; then
      in_container xynolog-haskell-toolchain '
        cd /tmp/sdk/haskell/sdk
        cabal update
        bash run.sh --only-dependencies' --memory 4g --volume "$cabal_home:/cabal" --env CABAL_DIR=/cabal
    else
      # The package's build directory outlives the container too, always
      # mounted at one path: Cabal records where it was. GHC decides a
      # module's recompilation by its source's hash, so a checkout's fresh
      # mtimes recompile nothing unchanged. Cabal decides a C source's by
      # its mtime against the object's, which an edit of a header it
      # includes leaves alone, so the C sources are given fresh ones. CI's
      # tests job caches this directory, once the checks pass, as the
      # runner's user; GHC's coverage writes some of it readable by root
      # alone.
      haskell_build="$HOME/.cache/xynolog/haskell-build"
      mkdir -p "$haskell_build"
      measure_coverage
      in_container xynolog-haskell-toolchain '
        cd /tmp/sdk/haskell/sdk
        rm -rf dist-newstyle
        ln -s /haskell-build dist-newstyle
        find . -name "*.c" -exec touch {} +
        cabal update
        bash run.sh /tmp/sdk
        mv coverage.lcov /coverage/haskell.lcov
        find /haskell-build -mindepth 1 -exec chmod a+rX {} +' --memory 4g \
        --volume "$cabal_home:/cabal" --env CABAL_DIR=/cabal --volume "$haskell_build:/haskell-build" \
        --volume "$COVERAGE:/coverage"
      coverage_reports haskell lcov haskell/sdk
    fi
    ;;
  test-ocaml)
    measure_coverage
    in_container xynolog-ocaml-toolchain '
      cd /tmp/sdk/ocaml/sdk
      dune build @all @opam
      dune tools install ocamlformat
      dune build @fmt
      python3 test/check-installed-api.py
      python3 probes/check-interface.py
      python3 api.py
      python3 probes/check-api-controls.py
      # A test runs in a sandbox that dune deletes, so its coverage files are
      # written outside the build.
      mkdir /tmp/ocaml-coverage
      BISECT_FILE=/tmp/ocaml-coverage/bisect dune runtest --force --instrument-with bisect_ppx_ng
      dune exec -- bisect-ppx-report coveralls /coverage/ocaml.json --coverage-path /tmp/ocaml-coverage
      dune build @conformance' --memory 4g "${OCAML_DUNE_CACHE_OPTIONS[@]}" --volume "$COVERAGE:/coverage"
    coverage_reports ocaml coveralls ocaml/sdk
    ;;
  test-codegen)
    # The pinned Protocol reads through its reader, and Swift's table values
    # are its own. Every case
    # table is run by a named test of each SDK, or absent from it for a
    # reason, and every surface item an SDK lacks is one Protocol has, with a
    # reason. Every sdk path the pinned Protocol names is one this checkout
    # has, each base module a generated one imports stays below it, and every
    # SDK declares every item of every contract Protocol states.
    in_container xynolog-ocaml-toolchain '
      cd /tmp/sdk/codegen
      dune build @all @opam
      dune build @fmt
      dune runtest
      dune exec -- ./test/census.exe ../protocol/specs/src
      dune exec -- ./test/coverage_census.exe ..
      dune exec -- ./test/cli_groups.exe ..
      dune exec -- ./test/images_groups.exe ..
      dune exec -- xynolog-codegen read ..
      dune exec -- ./test/boundary_census.exe ..
      dune exec -- ./test/contracts_census.exe ..
      dune exec -- ./test/protocol_paths_census.exe .. ../protocol' --memory 4g "${OCAML_DUNE_CACHE_OPTIONS[@]}"
    ;;
  generate|check-generated)
    # The OCaml generator writes each of its groups' files, a TypeScript one as
    # it prints it, and the Node step lays those out with Prettier. generate
    # writes into the checkout and builds xynolog-codegen in a copy of
    # codegen/, never in the checkout; check-generated runs the same into a
    # copy of the checkout, and fails when a file the generator names differs
    # from the committed one.
    work=$(mktemp -d)
    # The containers write into it as their own users, root among them, so a
    # container empties it.
    trap '"$RUNTIME" run --rm --volume "$work:/work" node:26-bookworm find /work -mindepth 1 -delete
      rmdir "$work"' EXIT
    if [[ "$1" == generate ]]; then
      target=$ROOT
    else
      target=$work/sdk
      mkdir "$target"
      tar -C "$ROOT" --exclude=.git --exclude=node_modules --exclude=dist --exclude=dist-newstyle \
        --exclude=target --exclude=.gradle --exclude=build --exclude=obj --exclude=.build \
        --exclude=_build --exclude=.venv -cf - . | tar -C "$target" -xf -
    fi
    "$RUNTIME" run --rm --volume "$target:/sdk" --volume "$work:/work" --workdir /tmp --memory 4g \
      "${OCAML_DUNE_CACHE_OPTIONS[@]}" xynolog-ocaml-toolchain bash -euc '
        set -o pipefail
        mkdir /tmp/sdk
        cp -a /sdk/codegen /sdk/protocol /tmp/sdk/
        cd /tmp/sdk/codegen
        dune build ./bin/main.exe
        dune exec -- xynolog-codegen generate sdk /sdk | tee /work/written'
    "$RUNTIME" run --rm --volume "$target:/sdk" --volume "$work:/work" --workdir /sdk node:26-bookworm bash -euc '
      cd typescript
      npm install --no-package-lock --ignore-scripts
      cd ..
      sed -n "s/^format //p" /work/written > /work/laid-out
      xargs -r -a /work/laid-out typescript/node_modules/.bin/prettier --write --log-level warn'
    if [[ "$1" == check-generated ]]; then
      [[ -s "$work/written" ]]
      drifted=0
      while read -r _ path; do
        if [[ ! -f "$ROOT/$path" ]]; then
          echo "absent $path"
          drifted=$((drifted + 1))
        elif ! cmp -s "$target/$path" "$ROOT/$path"; then
          echo "DRIFT  $path"
          drifted=$((drifted + 1))
        fi
      done < "$work/written"
      if ((drifted)); then
        echo "$drifted generated files differ from what their generators write: run make generate" >&2
        exit 1
      fi
    fi
    ;;
  codegen-binary)
    # The generator as the SDK bundle carries it, for another repository to
    # run against its own checkout: built in the toolchain's container, and
    # linked statically, so it runs in any Linux container. It is written to
    # the directory given, as xynolog-codegen.
    mkdir -p "$2"
    in_container xynolog-ocaml-toolchain '
      cd /tmp/sdk/codegen
      dune build ./bin/main.exe
      install -m 0755 _build/default/bin/main.exe /artifacts/xynolog-codegen' \
      --volume "$(cd "$2" && pwd -P):/artifacts" --memory 4g "${OCAML_DUNE_CACHE_OPTIONS[@]}"
    ;;
  *)
    usage
    ;;
esac

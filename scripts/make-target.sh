#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
source "$ROOT/build-tools/container-runtime.sh"
source "$ROOT/scripts/require-protocol-pin.sh"
RUNTIME="$(detect_container_runtime)"
require_protocol_pin "$ROOT" >/dev/null

# Run a language's checks in its toolchain's container, on a copy of the
# checkout laid out as the checkout is, with the Protocol bundles built.
in_container() {
  local image="$1" script="$2"
  shift 2
  "$RUNTIME" run --rm --volume "$ROOT:/source:ro" --workdir /tmp "$@" "$image" \
    bash -euc "cp -a /source /tmp/sdk
$script"
}

# The OCaml toolchain's image, which the SDK and the generator build on, each
# held to build-tools' pins.
ocaml_toolchain_image() {
  bash "$ROOT/build-tools/ocaml/toolchain-image.sh" "$ROOT/ocaml/sdk" "$ROOT/codegen"
}

case "${1:-}" in
  test-typescript)
    bash "$ROOT/scripts/bundle-protocol.sh"
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
      npm test --workspaces' --memory 4g
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
    bash "$ROOT/scripts/bundle-protocol.sh"
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
      uv run pytest' --memory 4g
    ;;
  test-rust)
    bash "$ROOT/scripts/bundle-protocol.sh"
    in_container "rust:$(sh "$ROOT/rust/scripts/rust-toolchain.sh")-bookworm" '
      cd /tmp/sdk/rust
      cargo fmt --all --check
      rustfmt --edition 2024 --check sdk/src/generated/*.rs
      cargo clippy --workspace --all-targets --all-features --locked -- -D warnings
      cargo test --workspace --all-features --locked' --memory 4g
    ;;
  test-go)
    COVERAGE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/xynolog-sdk-coverage.XXXXXX")"
    trap 'rm -rf "$COVERAGE_DIR"' EXIT
    in_container "golang:$(sh "$ROOT/go/scripts/go-toolchain.sh")-bookworm" '
      cd /tmp/sdk/go
      unformatted="$(gofmt -l .)"
      if [ -n "$unformatted" ]; then echo "not as gofmt writes them:"; echo "$unformatted"; exit 1; fi
      go vet ./...
      go test -race -coverprofile=/coverage/coverage.txt -covermode=atomic ./...' \
      --volume "$COVERAGE_DIR:/coverage"
    cp "$COVERAGE_DIR/coverage.txt" "$ROOT/coverage.txt"
    ;;
  test-csharp)
    bash "$ROOT/scripts/bundle-protocol.sh"
    in_container "mcr.microsoft.com/dotnet/sdk:$(sh "$ROOT/csharp/scripts/dotnet-version.sh" --image-tag)" '
      cd /tmp/sdk/csharp/sdk
      test "$(dotnet --version)" = "$(sh ../scripts/dotnet-version.sh)"
      dotnet build -p:RestoreLockedMode=true
      dotnet test --no-build --settings test.runsettings
      # The generated files too, but not those a package compiles in.
      dotnet format --no-restore --verify-no-changes --include-generated --exclude "$HOME/.nuget/packages"' --memory 4g
    ;;
  test-kotlin)
    bash "$ROOT/scripts/bundle-protocol.sh"
    # Gradle's home (the wrapper's distribution, and the plugins and
    # dependencies it fetches) outlives the container. CI's tests job caches
    # this directory.
    gradle_home="$HOME/.cache/xynolog/kotlin-gradle"
    mkdir -p "$gradle_home"
    in_container "eclipse-temurin:$(sh "$ROOT/kotlin/scripts/jdk-version.sh")-jdk" '
      cd /tmp/sdk/kotlin/sdk
      ./gradlew --no-daemon --console=plain check' --memory 4g --volume "$gradle_home:/gradle" --env GRADLE_USER_HOME=/gradle
    ;;
  test-swift)
    in_container "swift:$(sh "$ROOT/swift/scripts/swift-version.sh")" '
      cd /tmp/sdk/swift/sdk
      Scripts/test.sh
      swift format lint --strict --recursive .
      Scripts/census.sh
      Scripts/refusals.sh' --memory 4g
    ;;
  test-haskell|haskell-dependencies)
    "$RUNTIME" build --build-arg "GHC_VERSION=$(bash "$ROOT/haskell/toolchain/toolchain.sh" --ghc)" \
      --tag xynolog-haskell-toolchain --file "$ROOT/haskell/toolchain/Dockerfile" "$ROOT/haskell/toolchain"
    # Cabal's home (its index and the store of built dependencies) outlives
    # the container, so a run builds only what changed since the last one.
    # CI's tests job caches this directory, once haskell-dependencies has
    # built every dependency into it.
    cabal_home="$HOME/.cache/xynolog/haskell-cabal"
    mkdir -p "$cabal_home"
    if [[ "$1" == haskell-dependencies ]]; then
      commands='bash run.sh --only-dependencies'
    else
      commands='bash run.sh /tmp/sdk
      python3 ../coverage.py coverage.lcov'
    fi
    in_container xynolog-haskell-toolchain "
      cd /tmp/sdk/haskell/sdk
      cabal update
      $commands" --memory 4g --volume "$cabal_home:/cabal" --env CABAL_DIR=/cabal
    ;;
  test-ocaml)
    ocaml_toolchain_image
    in_container xynolog-ocaml-toolchain '
      cd /tmp/sdk/ocaml/sdk
      dune build @all @opam
      dune build @fmt
      python3 test/check-installed-api.py
      python3 probes/check-interface.py
      python3 api.py
      python3 probes/check-api-controls.py
      dune runtest' --memory 4g
    ;;
  test-codegen)
    # The pinned Protocol reads through its reader, and Swift's table values
    # are its own. Every case
    # table is run by a named test of each SDK, or absent from it for a
    # reason, and every surface item an SDK lacks is one Protocol has, with a
    # reason. Every sdk path the pinned Protocol names is one this checkout
    # has, and each base module a generated one imports stays below it.
    ocaml_toolchain_image
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
      dune exec -- ./test/protocol_paths_census.exe .. ../protocol' --memory 4g
    ;;
  generate|check-generated)
    # The OCaml generator writes each of its groups' files, a TypeScript one as
    # it prints it, and the Node step lays those out with Prettier. generate
    # writes into the checkout and builds xynolog-codegen in a copy of
    # codegen/, never in the checkout; check-generated runs the same into a
    # copy of the checkout, and fails when a file the generator names differs
    # from the committed one.
    bash "$ROOT/scripts/bundle-protocol.sh"
    ocaml_toolchain_image
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
      xynolog-ocaml-toolchain bash -euc '
        set -o pipefail
        cp -a /sdk/codegen /sdk/protocol /tmp/
        cd /tmp/codegen
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
    [[ $# -eq 2 ]] || { echo 'Usage: make-target.sh codegen-binary DIRECTORY' >&2; exit 2; }
    mkdir -p "$2"
    ocaml_toolchain_image
    in_container xynolog-ocaml-toolchain '
      cd /tmp/sdk/codegen
      dune build ./bin/main.exe
      install -m 0755 _build/default/bin/main.exe /artifacts/xynolog-codegen' \
      --volume "$(cd "$2" && pwd -P):/artifacts" --memory 4g
    ;;
  *)
    echo 'Usage: make-target.sh test-<language>|haskell-dependencies|test-codegen|generate|check-generated|codegen-binary DIRECTORY' >&2
    exit 2
    ;;
esac

#!/usr/bin/env bash
# Install one language's packages from an SDK artifact bundle as a consumer
# installs them from the registry, in a clean container on each runtime the
# packages admit at their edges, and build a program against them.
#
#   scripts/clean-room.sh <language> <bundle dir>
#
# Nothing of the checkout's build is reused: no cache, no lockfile, no
# toolchain of the repository's own. Each package resolves its dependencies
# from their registry, newest first, as a consumer's fresh install does. The
# runtimes are read from what the packages declare (the lowest a manifest
# admits, or each one a package targets), never written here a second time.
# The consumer programs are scripts/clean-room/<language>.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
source "$ROOT/build-tools/container-runtime.sh"
(($# == 2)) || { echo 'Usage: clean-room.sh <language> <bundle dir>' >&2; exit 2; }
LANGUAGE=$1
BUNDLE="$(cd "$2" && pwd -P)"
CONSUMER="$ROOT/scripts/clean-room/$LANGUAGE"
RUNTIME="$(detect_container_runtime)"

# The version every artifact of the language carries; they agree, or the
# bundle is refused.
VERSION="$(python3 - "$BUNDLE/artifacts.json" "$LANGUAGE" <<'PY'
import json, sys
manifest, language = sys.argv[1:]
data = json.load(open(manifest))
if language not in data["languages"]:
    sys.exit(f"clean-room.sh: the bundle holds no {language} artifacts")
versions = {a["version"] for a in data["artifacts"] if a["path"].startswith(f"{language}/")}
if len(versions) != 1:
    sys.exit(f"clean-room.sh: the {language} artifacts carry versions {sorted(versions)}, not one")
print(versions.pop())
PY
)"

# The value a manifest gives one field, which must be there: the pattern's
# group <n> (the first by default) on the one line it matches.
field() {
  local file=$1 pattern=$2 group=${3:-1} value
  value="$(sed -nE "s/$pattern/\\$group/p" "$ROOT/$file")"
  [[ -n "$value" && "$value" != *$'\n'* ]] || { echo "clean-room.sh: $file gives no single value for $pattern" >&2; exit 1; }
  printf '%s\n' "$value"
}

in_clean_room() {
  local image=$1 script=$2
  shift 2
  echo "== $LANGUAGE $VERSION on $image"
  "$RUNTIME" run --rm --memory 4g \
    --volume "$BUNDLE/$LANGUAGE:/bundle:ro" --volume "$CONSUMER:/consumer:ro" \
    --env "VERSION=$VERSION" "$@" --workdir /tmp "$image" bash -euc "$script"
}

case "$LANGUAGE" in
  typescript)
    # Each package's engines floor; they agree.
    floors="$(for manifest in "$ROOT"/typescript/*/package.json; do
      python3 -c 'import json, sys; m = json.load(open(sys.argv[1])); print(m["engines"]["node"]) if not m.get("private") else None' "$manifest"
    done | sort -u)"
    [[ "$floors" =~ ^\>=([0-9]+\.[0-9]+\.[0-9]+)$ ]] || { echo "clean-room.sh: the packages' engines.node differ or are not one floor: $floors" >&2; exit 1; }
    in_clean_room "node:${BASH_REMATCH[1]}-bookworm" '
      mkdir app && cd app && cp /consumer/package.json /consumer/consume.mjs .
      npm install --no-audit --no-fund /bundle/*.tgz
      node consume.mjs'
    ;;
  python)
    floor="$(field python/sdk/pyproject.toml '^requires-python = ">=([0-9]+\.[0-9]+)"$')"
    in_clean_room "python:$floor-bookworm" '
      python -m venv /tmp/venv
      /tmp/venv/bin/pip install --quiet --find-links /bundle "xynolog==$VERSION"
      /tmp/venv/bin/python /consumer/consume.py'
    ;;
  rust)
    # Each crate as crates.io serves it, checked with every feature on the
    # lowest Rust the crates declare, its dependencies resolved afresh by the
    # MSRV-aware resolver, and a program built on them; the crates name each
    # other, and the program names them, through the patch.
    msrv="$(field rust/Cargo.toml '^rust-version = "([0-9]+\.[0-9]+)"$')"
    in_clean_room "rust:$msrv-bookworm" '
      mkdir crates && for crate in /bundle/*.crate; do tar -xzf "$crate" -C crates; done
      mkdir -p app/src && cp /consumer/main.rs app/src/
      {
        echo "[package]"; echo "name = \"consumer\""; echo "version = \"0.0.0\""; echo "edition = \"2024\""
        echo "[dependencies]"
        for crate in xynolog xynolog-http-transport; do echo "$crate = \"=$VERSION\""; done
      } > app/Cargo.toml
      {
        echo "[workspace]"; echo "resolver = \"3\""
        printf "members = [\"app\", "; for dir in crates/*; do printf "\"%s\", " "$dir"; done; echo "]"
        echo "[patch.crates-io]"
        for dir in crates/*; do name="${dir#crates/}"; echo "${name%-$VERSION} = { path = \"$dir\" }"; done
      } > Cargo.toml
      cargo check --workspace --all-features --lib
      cargo build --package consumer'
    ;;
  go)
    # The module on the lowest Go its go line admits, from the bundle's module
    # proxy, every package of it built and vetted, and a program built on it.
    lowest="$(field go/go.mod '^go ([0-9]+\.[0-9]+\.[0-9]+)$')"
    in_clean_room "golang:$lowest-bookworm" '
      export GOTOOLCHAIN=local GOFLAGS=-mod=mod GOPROXY=file:///bundle/go-proxy,https://proxy.golang.org GONOSUMDB=github.com/xynolog/sdk/go
      mkdir app && cd app && go mod init consumer && cp /consumer/main.go .
      go get "github.com/xynolog/sdk/go@v$VERSION"
      go build ./... && go vet ./...
      go build github.com/xynolog/sdk/go/... && go vet github.com/xynolog/sdk/go/...'
    ;;
  csharp)
    # A console application of each framework the package targets, on the
    # .NET SDK of that framework: the newest one's is the repository's own.
    package="$BUNDLE/csharp/Xynolog.$VERSION.nupkg"
    frameworks="$(python3 -c 'import sys, zipfile; print("\n".join(sorted({n.split("/")[1] for n in zipfile.ZipFile(sys.argv[1]).namelist() if n.startswith("lib/")})))' "$package")"
    newest="$(field csharp/sdk/Directory.Build.props '^ *<XynologTargetFramework>(net[0-9]+\.[0-9]+)<\/XynologTargetFramework>$')"
    [[ "$(tail -n 1 <<< "$frameworks")" == "$newest" ]] || { echo "clean-room.sh: the package's newest framework is not $newest: $frameworks" >&2; exit 1; }
    for framework in $frameworks; do
      if [[ "$framework" == "$newest" ]]; then
        image="mcr.microsoft.com/dotnet/sdk:$(sh "$ROOT/csharp/scripts/dotnet-version.sh" --image-tag)"
      else
        image="mcr.microsoft.com/dotnet/sdk:${framework#net}"
      fi
      in_clean_room "$image" '
        export DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1
        dotnet new console --framework "$FRAMEWORK" --output app >/dev/null && cd app
        cp /consumer/nuget.config /consumer/Program.cs .
        dotnet add package Xynolog --version "$VERSION"
        dotnet build -warnaserror' --env "FRAMEWORK=$framework"
    done
    ;;
  kotlin)
    # A Java program that names the types the public API takes and returns
    # (JsonObject, StateFlow) compiles against the publication alone, read by
    # Gradle (its module metadata) and by Maven (the POM).
    java="$(cat "$ROOT/kotlin/sdk/.java-version")"
    repository='mkdir -p "/tmp/repo/org/xynolog/xynolog/$VERSION" && cp /bundle/* "/tmp/repo/org/xynolog/xynolog/$VERSION/"'
    in_clean_room "eclipse-temurin:$java-jdk" "$repository"'
      mkdir app && cd app && cp -R /consumer/gradle/. . && cp /kotlin/gradlew . && mkdir gradle && cp -R /kotlin/gradle/wrapper gradle/ && mkdir -p src/main/java && cp /consumer/Consumer.java src/main/java/
      ./gradlew --no-daemon --quiet -PxynologVersion="$VERSION" -PjavaRelease="$JAVA" compileJava' \
      --env "JAVA=$java" --volume "$ROOT/kotlin/sdk:/kotlin:ro"
    in_clean_room "maven:3.9-eclipse-temurin-$java" "$repository"'
      mkdir app && cd app && cp /consumer/maven/pom.xml . && mkdir -p src/main/java && cp /consumer/Consumer.java src/main/java/
      mvn --batch-mode --quiet -Dxynolog.version="$VERSION" -Djava.release="$JAVA" compile' --env "JAVA=$java"
    ;;
  haskell)
    # The source distribution as Hackage builds it: on the newest GHC
    # tested-with names, from a fresh index, with its documentation. The
    # repository's tests build with the lowest, cabal.project's with-compiler,
    # which tested-with must name. cabal haddock builds every dependency with
    # its documentation, as a unit apart from one built without, so the build
    # builds them with it too, and each is built once.
    tested="$(field haskell/sdk/xynolog.cabal '^tested-with: (GHC == .*)$')"
    compiler="$(field haskell/sdk/cabal.project '^with-compiler: ghc-([0-9.]+)$')"
    versions="$(grep -oE '[0-9]+\.[0-9]+\.[0-9]+' <<< "$tested" | sort -V)"
    grep -qx "$compiler" <<< "$versions" || { echo "clean-room.sh: tested-with ($tested) does not name cabal.project's GHC $compiler" >&2; exit 1; }
    in_clean_room "haskell:$(tail -n 1 <<< "$versions")" '
      cabal update >/dev/null
      mkdir app && cd app && cp /consumer/consumer.cabal /consumer/Main.hs .
      printf "packages: . /bundle/xynolog-%s.tar.gz\n" "$VERSION" > cabal.project
      cabal build --enable-documentation --jobs exe:consumer
      cabal haddock --jobs xynolog'
    ;;
  ocaml)
    # The source archive as opam-repository's CI installs it: a repository of
    # this one package, whose opam file is the archive's own, on the lowest
    # compiler that opam file admits.
    lowest="$(field ocaml/sdk/xynolog.opam '^  "ocaml" \{(= |>= )"([0-9]+\.[0-9]+)(\.[0-9]+)?"\}$' 2)"
    in_clean_room "ocaml/opam:debian-13-ocaml-$lowest" '
      sudo apt-get update -qq && sudo apt-get install -y -qq --no-install-recommends libgmp-dev pkg-config >/dev/null
      archive="/bundle/xynolog.$VERSION.tar.gz"
      mkdir -p "repo/packages/xynolog/xynolog.$VERSION" && printf "opam-version: \"2.0\"\n" > repo/repo
      tar -xzOf "$archive" ./xynolog.opam > "repo/packages/xynolog/xynolog.$VERSION/opam"
      printf "url {\n  src: \"file://%s\"\n  checksum: \"sha256=%s\"\n}\n" "$archive" "$(sha256sum "$archive" | cut -d" " -f1)" >> "repo/packages/xynolog/xynolog.$VERSION/opam"
      opam update --quiet default >/dev/null
      opam repository add --quiet --this-switch bundle "file:///tmp/repo"
      opam install --yes "xynolog.$VERSION"
      mkdir app && cd app && cp /consumer/dune-project /consumer/dune /consumer/consume.ml .
      opam exec -- dune build ./consume.exe'
    ;;
  swift)
    # The distribution as an application takes it, by URL at exactly its
    # version, on the lowest Swift its manifest's tools version admits.
    CONSUMER="$ROOT/swift/distribution/consumer"
    tools="$(unzip -p "$BUNDLE/swift/sdk-swift-$VERSION.zip" sdk-swift/Package.swift | sed -nE '1s|^// swift-tools-version: ([0-9]+\.[0-9]+)$|\1|p')"
    [[ -n "$tools" ]] || { echo "clean-room.sh: the distribution's Package.swift names no tools version" >&2; exit 1; }
    in_clean_room "swift:$tools-bookworm" '
      apt-get update -qq && apt-get install -y -qq --no-install-recommends unzip >/dev/null
      unzip -q "/bundle/sdk-swift-$VERSION.zip"
      sh /scripts/consume-distribution.sh "$PWD/sdk-swift" "$VERSION" /consumer' \
      --volume "$ROOT/swift/scripts:/scripts:ro"
    ;;
  *) echo "clean-room.sh: unknown SDK language $LANGUAGE" >&2; exit 2 ;;
esac

#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
source "$ROOT/build-tools/container-runtime.sh"
source "$ROOT/scripts/run-container-quietly.sh"
source "$ROOT/scripts/require-protocol-pin.sh"
RUNTIME="$(detect_container_runtime)"
STATE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/xynolog-sdk/local"
PROTOCOL="$ROOT/protocol"
LANGUAGE="${1:-all}"
case "$LANGUAGE" in
  all|go|csharp|haskell|kotlin|ocaml|swift) ;;
  *) echo "Unsupported language for this artifact script: $LANGUAGE" >&2; exit 2 ;;
esac
PROTOCOL_REVISION="$(require_protocol_pin "$ROOT")"
mkdir -p "$STATE_ROOT"/{go-proxy,nuget,nuget-cache,haskell,cabal-cache,haskell-build,kotlin-maven,gradle-cache,opam-repo,swift,swift-cache,go-mod-cache,go-build-cache}
OPAM_VOLUME=xynolog-sdk-opam-5-5
# The version this build gives a language's packages: the release's, or a
# development version. Each container is handed its own.
version_of() { python3 "$ROOT/scripts/sdk_version.py" "$1"; }
SDK_SOURCE_TIME="$(git -C "$ROOT" log -1 --format=%cI)"

case "$LANGUAGE" in
  all|go|csharp|kotlin)
    [[ -d "$PROTOCOL/specs/src" ]] || exit 1
    ;;
esac

if [[ "$LANGUAGE" == all || "$LANGUAGE" == go ]]; then
echo 'Building the Go module proxy package in a Go container…'
go_package_version="$(version_of go)"
# What a commit of this tree would hold of the module and what Go's packager
# reads beside it: go/, LICENSE and .gitattributes, tracked or new and not ignored.
GO_MODULE_SOURCE="$(mktemp -d)"
trap 'rm -rf "$GO_MODULE_SOURCE"' EXIT
git -C "$ROOT" ls-files -z --cached --others --exclude-standard -- go LICENSE .gitattributes \
  | while IFS= read -r -d '' path; do if [[ -e "$ROOT/$path" ]]; then printf '%s\0' "$path"; fi; done \
  | tar -C "$ROOT" --null -T - -cf - | tar -C "$GO_MODULE_SOURCE" -xf -
run_container_quietly "$RUNTIME" run --rm \
  --volume "$ROOT:/source:ro" --volume "$PROTOCOL:/protocol:ro" \
  --volume "$GO_MODULE_SOURCE:/module-source:ro" \
  --volume "$STATE_ROOT/go-proxy:/out" --volume "$STATE_ROOT/go-mod-cache:/go/pkg/mod" \
  --volume "$STATE_ROOT/go-build-cache:/root/.cache/go-build" \
  --env "SDK_SOURCE_TIME=$SDK_SOURCE_TIME" --env "XYNOLOG_SDK_VERSION=$go_package_version" \
  --workdir /tmp "golang:$(sh "$ROOT/go/scripts/go-toolchain.sh")-bookworm" bash -euc '
    version="$XYNOLOG_SDK_VERSION"
    mkdir -p /tmp/sdk && cp -a /source/. /tmp/sdk/ && rm -rf /tmp/sdk/protocol && cp -a /protocol /tmp/sdk/protocol && cd /tmp/sdk/go && go build ./...
    module="github.com/xynolog/sdk/go"
    mkdir -p "/out/$module/@v"
    printf "{\"Version\":\"v%s\",\"Time\":\"%s\"}\n" "$version" "$SDK_SOURCE_TIME" > "/out/$module/@v/v$version.info"
    cp /source/go/go.mod "/out/$module/@v/v$version.mod"
    printf "v%s\\n" "$version" > "/out/$module/@v/list"
    # Go packages a module from a commit: commit the staged tree in a scratch repository.
    cp -R /module-source /tmp/module-repository
    git -C /tmp/module-repository init -q
    git -C /tmp/module-repository add -A -f
    git -C /tmp/module-repository -c user.name=go-module-zip -c user.email=go-module-zip@localhost commit -q -m "go-module-zip"
    (cd /source/scripts/go-module-zip && go run . "$module" "v$version" /tmp/module-repository HEAD go "/out/$module/@v/v$version.zip")
  '
fi
if [[ "$LANGUAGE" == all || "$LANGUAGE" == csharp ]]; then
echo 'Packing the .NET SDK in a .NET container…'
csharp_package_version="$(version_of csharp)"
dotnet_version="$(sh "$ROOT/csharp/scripts/dotnet-version.sh" --image-tag)"
run_container_quietly "$RUNTIME" run --rm \
  --volume "$ROOT:/source:ro" --volume "$PROTOCOL:/protocol:ro" \
  --volume "$STATE_ROOT/nuget:/out" --volume "$STATE_ROOT/nuget-cache:/root/.nuget/packages" --workdir /tmp \
  --env "XYNOLOG_SDK_VERSION=$csharp_package_version" \
  "mcr.microsoft.com/dotnet/sdk:$dotnet_version" bash -euc '
    version="$XYNOLOG_SDK_VERSION"
    cp -a /source /tmp/sdk
    rm -rf /tmp/sdk/protocol
    cp -a /protocol /tmp/sdk/protocol
    # ContinuousIntegrationBuild writes /_/ into the PDBs in place of the
    # paths of the container, so two builds of one commit write the same bytes.
    dotnet pack /tmp/sdk/csharp/sdk/src/Xynolog/Xynolog.csproj -c Release --verbosity quiet \
      -p:IsPackable=true -p:PackageId=Xynolog -p:PackageVersion="$version" \
      -p:ContinuousIntegrationBuild=true -p:CheckRefusals=false -o /out
  '
fi

if [[ "$LANGUAGE" == all || "$LANGUAGE" == haskell ]]; then
echo 'Creating the Haskell source distribution in a GHC container…'
haskell_package_version="$(version_of haskell)"
run_container_quietly "$RUNTIME" run --rm --memory 4g --volume "$ROOT/haskell/sdk:/source:ro" \
  --volume "$ROOT/haskell/scripts/cabal-version.sh:/cabal-version.sh:ro" \
  --volume "$STATE_ROOT/haskell:/out" --volume "$STATE_ROOT/cabal-cache:/root/.cabal" \
  --volume "$STATE_ROOT/haskell-build:/tmp/sdk/dist-newstyle" --workdir /tmp \
  --env "XYNOLOG_SDK_VERSION=$haskell_package_version" \
  "haskell:$(bash "$ROOT/haskell/toolchain/toolchain.sh" --ghc)" bash -euc 'mkdir -p /tmp/sdk && cp -a /source/. /tmp/sdk/ && bash /cabal-version.sh "$XYNOLOG_SDK_VERSION" /tmp/sdk/xynolog.cabal && cd /tmp/sdk && printf "packages: .\\n" > cabal.project && test -f /root/.cabal/packages/hackage.haskell.org/01-index.cache || cabal update; cabal build lib:xynolog && cabal sdist --output-directory=/out'
fi

if [[ "$LANGUAGE" == all || "$LANGUAGE" == kotlin ]]; then
# The build's own publication (kotlin/sdk/build.gradle.kts), written to its
# build directory and copied into the local Maven repository.
echo 'Building and publishing the Kotlin SDK to a local Maven repository in a JDK container…'
kotlin_package_version="$(version_of kotlin)"
jdk="$(sh "$ROOT/kotlin/scripts/jdk-version.sh")"
run_container_quietly "$RUNTIME" run --rm --memory 4g --volume "$ROOT:/source:ro" \
  --volume "$PROTOCOL:/protocol:ro" --volume "$STATE_ROOT/kotlin-maven:/out" \
  --volume "$STATE_ROOT/gradle-cache:/root/.gradle" \
  --env "XYNOLOG_SDK_VERSION=$kotlin_package_version" \
  --workdir /tmp eclipse-temurin:"$jdk"-jdk bash -euc '
    mkdir -p /tmp/sdk && cp -a /source/. /tmp/sdk/ && rm -rf /tmp/sdk/protocol && cp -a /protocol /tmp/sdk/protocol
    cd /tmp/sdk/kotlin/sdk
    ./gradlew --no-daemon -Pversion="$XYNOLOG_SDK_VERSION" assemble -x checkKotlinAbi publishMavenPublicationToBuildRepository
    cp -R build/repository/. /out/
  '
fi

if [[ "$LANGUAGE" == all || "$LANGUAGE" == ocaml ]]; then
echo 'Building and archiving the OCaml SDK in an OCaml container…'
ocaml_package_version="$(version_of ocaml)"
ocaml_image="$(python3 "$ROOT/build-tools/ocaml/check-toolchain.py" --base-image)"
opam_archive_uri="file://$STATE_ROOT/opam-repo/repo/archives/xynolog.$ocaml_package_version.tar.gz"
opam_archive_uri="${opam_archive_uri// /%20}"
if ! "$RUNTIME" volume inspect "$OPAM_VOLUME" >/dev/null 2>&1; then
  "$RUNTIME" volume create "$OPAM_VOLUME" >/dev/null
fi
if ! run_container_quietly "$RUNTIME" run --rm --volume "$OPAM_VOLUME:/cache" \
  "$ocaml_image" bash -euc 'test -s /cache/config'; then
  echo 'Seeding the pinned OCaml switch cache…'
  run_container_quietly "$RUNTIME" run --rm --user 0:0 --volume "$OPAM_VOLUME:/cache" \
    "$ocaml_image" bash -euc 'cp -R /home/opam/.opam/. /cache/ && chown -R opam:opam /cache'
fi
# The OCaml image runs as its opam user, who writes the repository here.
chmod 0777 "$STATE_ROOT/opam-repo"
run_container_quietly "$RUNTIME" run --rm --memory 4g --volume "$ROOT/ocaml/sdk:/source:ro" \
  --volume "$STATE_ROOT/opam-repo:/out" \
  --volume "$OPAM_VOLUME:/home/opam/.opam" \
  --env "XYNOLOG_SDK_VERSION=$ocaml_package_version" --env "XYNOLOG_OPAM_ARCHIVE_URI=$opam_archive_uri" \
  --workdir /tmp \
  "$ocaml_image" bash -euc '
    sudo apt-get update -qq && sudo apt-get install -y -qq --no-install-recommends libgmp-dev pkg-config >/dev/null
    cp -a /source /tmp/sdk && cd /tmp/sdk
    rm -rf /home/opam/.opam/5.5/.opam-switch/sources/uring.2.15.0
    opam install . --deps-only -y --jobs "$(nproc)"
    eval "$(opam env)"
    dune build -p xynolog @install
    version="$XYNOLOG_SDK_VERSION"
    rm -rf /out/repo && mkdir -p "/out/repo/packages/xynolog/xynolog.$version" "/out/repo/archives"
    cp xynolog.opam "/out/repo/packages/xynolog/xynolog.$version/opam"
    tar --exclude=.git --exclude=_build -czf "/out/repo/archives/xynolog.$version.tar.gz" .
    checksum=$(sha256sum "/out/repo/archives/xynolog.$version.tar.gz" | cut -d" " -f1)
    printf "\nurl {\n  src: \"%s\"\n  checksum: [ \"sha256=%s\" ]\n}\n" \
      "$XYNOLOG_OPAM_ARCHIVE_URI" "$checksum" >> "/out/repo/packages/xynolog/xynolog.$version/opam"
    printf "opam-version: \"2.0\"\n" > /out/repo/repo
    cd /out/repo && opam admin index
  '
fi

if [[ "$LANGUAGE" == all || "$LANGUAGE" == swift ]]; then
echo 'Building the Swift package and its distribution in a Swift container…'
swift_package_version="$(version_of swift)"
swift_version="$(cat "$ROOT/swift/sdk/.swift-version")"
# The container holds the repository as a checkout lays it out: swift/ and the
# LICENSE.
# Its dependencies resolve as an application's do, to the newest versions
# Package.swift allows; the tests job builds against Package.resolved.
run_container_quietly "$RUNTIME" run --rm --memory 4g --volume "$ROOT:/source:ro" \
  --volume "$STATE_ROOT/swift:/out" --volume "$STATE_ROOT/swift-cache:/root/.cache" \
  --env "XYNOLOG_SDK_VERSION=$swift_package_version" --workdir /tmp "swift:$swift_version" bash -euc '
    apt-get update -qq && apt-get install -y -qq --no-install-recommends python3 zip >/dev/null
    mkdir -p /tmp/sdk
    cp -a /source/LICENSE /source/swift /tmp/sdk/
    if ! sh /tmp/sdk/swift/scripts/distribution.sh "$XYNOLOG_SDK_VERSION" /tmp/distribution > /out/distribution.log 2>&1; then tail -n 100 /out/distribution.log; exit 1; fi
    cd /tmp/distribution
    rm -f "/out/sdk-swift-$XYNOLOG_SDK_VERSION.zip"
    zip -qr "/out/sdk-swift-$XYNOLOG_SDK_VERSION.zip" sdk-swift
  '
fi

#!/usr/bin/env bash
# rust-crates.sh package|publish <version> — the crates published to crates.io,
# at <version>, in a Rust container whose /source is the SDK checkout and
# /protocol its pinned Protocol:
#
#   package  builds the workspace, rejecting every warning, and writes each
#            crate's archive to /artifacts (scripts/publish-local.sh).
#   publish  packages each crate the same way and refuses unless every archive
#            is the one the release's bundle at /bundle holds; then publishes
#            them with $CARGO_REGISTRY_TOKEN (publish.yml). It builds nothing,
#            so no dependency's build script runs while the token is here.
set -euo pipefail

usage='usage: rust-crates.sh package|publish <version>'
command="${1:?$usage}"
version="${2:?$usage}"
case "$command" in
  package | publish) ;;
  *) echo "$usage" >&2; exit 2 ;;
esac

SCRATCH=/tmp/xynolog-sdk-rust
rm -rf "$SCRATCH"
mkdir -p "$SCRATCH"
cp -a /source/rust "$SCRATCH/rust"
cp -a /protocol "$SCRATCH/protocol"
cp /source/LICENSE "$SCRATCH/"
bash "$SCRATCH/rust/scripts/cargo-version.sh" "$version"

cd "$SCRATCH/rust"

# The extracted SDK repository's lockfile can lag the independently-versioned
# protocol/workspace graph. Resolve in this disposable copy, then package every
# archive below from that same resolved lockfile.
if [[ "$command" == package ]]; then
  echo 'Building the Rust workspace…'
  # All features, so the optional sign-in code is checked too.
  RUSTFLAGS="${RUSTFLAGS:+$RUSTFLAGS }-D warnings" cargo build --workspace --all-features
else
  cargo metadata --format-version 1 > /dev/null
fi

# Dependencies before consumers, the order crates.io takes them in.
crates=(xynolog xynolog-telemetry xynolog-http-transport)

# Cargo for one crate, with its workspace dependencies patched to their paths,
# so none is looked up on crates.io before it is there.
cargo_crate() {
  local crate="$1"
  shift
  local patch="$SCRATCH/patch-$crate.toml"
  case "$crate" in
    xynolog)
      cargo "$@" --package "$crate"
      return
      ;;
    xynolog-telemetry)
      cat > "$patch" <<PATCH
[patch.crates-io]
xynolog = { path = "$SCRATCH/rust/sdk" }
PATCH
      ;;
    xynolog-http-transport)
      cat > "$patch" <<PATCH
[patch.crates-io]
xynolog = { path = "$SCRATCH/rust/sdk" }
xynolog-telemetry = { path = "$SCRATCH/rust/telemetry" }
PATCH
      ;;
  esac
  cargo --config "$patch" "$@" --package "$crate"
}

# Fails unless the archive cargo wrote for a crate is the bundle's.
released() {
  local crate="$1"
  local packaged released
  packaged="$(sha256sum "$CARGO_TARGET_DIR/package/$crate-$version.crate" | cut -d' ' -f1)"
  released="$(sha256sum "/bundle/rust/$crate-$version.crate" | cut -d' ' -f1)"
  if [[ "$packaged" != "$released" ]]; then
    echo "$crate $version packages as $packaged, not the released $released" >&2
    exit 1
  fi
}

# Cargo writes one .crate archive per crate to target/package; no registry is
# involved.
for crate in "${crates[@]}"; do
  cargo_crate "$crate" package --locked --no-verify --all-features
  archive="$CARGO_TARGET_DIR/package/$crate-$version.crate"
  if [[ ! -f "$archive" ]]; then
    echo "Cargo did not create the expected archive: $archive" >&2
    exit 1
  fi
  if [[ "$command" == package ]]; then
    cp -f "$archive" /artifacts/
    printf 'Created %s %s\n' "$crate" "$version"
  else
    released "$crate"
    printf '%s %s is the released archive\n' "$crate" "$version"
  fi
done

if [[ "$command" == package ]]; then
  echo 'Rust crate archives are ready under /artifacts.'
  exit 0
fi

: "${CARGO_REGISTRY_TOKEN:?publishing needs a crates.io token in CARGO_REGISTRY_TOKEN}"
for crate in "${crates[@]}"; do
  cargo_crate "$crate" publish --locked --no-verify --all-features
done

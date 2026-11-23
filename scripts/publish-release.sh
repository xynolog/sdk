#!/usr/bin/env bash
# Publish the release this commit is tagged as, as `make publish` runs it:
# dispatch publish.yml at the tag for each registry at once, each run
# publishing the released bundle, never a rebuild, and watch every run to its
# end.
#
#   scripts/publish-release.sh <registry> ...   those registries
#
# `make publish` names each registry publish.yml offers, and
# `make publish-<registry>` one.
#
# A person approves each run in the `release` environment, all of them
# together. A registry that failed spends only its own version, so the others
# go on, and each that failed is named with its run.

set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "$1" >&2; exit 1; }

test "$#" -ge 1 || fail "usage: scripts/publish-release.sh <registry> ..."

read -r -a tags <<< "$(python3 scripts/sdk_version.py tags)"
release="${tags[0]}"
test "$(git rev-parse --quiet --verify "refs/tags/$release^{commit}")" = "$(git rev-parse HEAD)" \
  || fail "This commit is not tagged $release, the release its version.json names: check out a release's tag first (git switch --detach vX.Y.Z)."

registries=("$@")
runs=()
already=""
for registry in "${registries[@]}"; do
  dispatched="$(gh workflow run publish.yml --repo xynolog/sdk --ref "$release" -f "registry=$registry" 2>&1)" \
    || fail "$dispatched${already:+$'\n'Already dispatched, each waiting for its approval:$already}"
  url="$(sed -nE 's#.*(https://github\.com/xynolog/sdk/actions/runs/[0-9]+).*#\1#p' <<< "$dispatched")"
  test -n "$url" \
    || fail "gh workflow run named no run for $registry: find it in publish.yml's runs in the Actions tab.${already:+$'\n'Already dispatched, each waiting for its approval:$already}"
  runs+=("$url")
  already="$already"$'\n'"  $registry: $url"
  echo "Publishing $release to $registry: $url"
done
echo "Approve each run in the release environment."

failed=()
for i in "${!registries[@]}"; do
  gh run watch --repo xynolog/sdk --compact --exit-status "${runs[$i]##*/}" \
    || failed+=("${registries[$i]}: ${runs[$i]}")
done

if [ "${#failed[@]}" -gt 0 ]; then
  printf '%s did not publish to:\n' "$release" >&2
  printf '  %s\n' "${failed[@]}" >&2
  exit 1
fi
echo "$release published to: ${registries[*]}"

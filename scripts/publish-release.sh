#!/usr/bin/env bash
# Publish the release this commit is tagged as, as `make publish` runs it:
# dispatch publish.yml at the tag, which publishes the released bundle, never
# a rebuild, and watch the run to its end.
#
#   scripts/publish-release.sh              each registry publish.yml offers, in its order
#   scripts/publish-release.sh <registry>   that registry alone
#
# A person approves each run in the `release` environment. A registry that
# failed spends only its own version, so a run that failed stops the rest, and
# the registries still to publish are named.

set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "$1" >&2; exit 1; }

test "$#" -le 1 || fail "usage: scripts/publish-release.sh [registry]"

read -r -a tags <<< "$(python3 scripts/sdk_version.py tags)"
release="${tags[0]}"
test "$(git rev-parse --quiet --verify "refs/tags/$release^{commit}")" = "$(git rev-parse HEAD)" \
  || fail "This commit is not tagged $release, the release its version.json names: check out a release's tag first (git switch --detach vX.Y.Z)."

if [ "$#" -eq 1 ]; then
  registries=("$1")
else
  # publish.yml's one choice input, `registry`, lists the registries.
  options="$(sed -n 's/^ *options: \[\(.*\)\]$/\1/p' .github/workflows/publish.yml)"
  [[ -n "$options" && "$options" != *$'\n'* ]] \
    || fail "publish.yml must list its registries as one input's options: [a, b, ...]"
  IFS=', ' read -r -a registries <<< "$options"
fi

for i in "${!registries[@]}"; do
  registry="${registries[$i]}"
  remaining="${registries[*]:i+1}"
  echo "Publishing $release to $registry"
  dispatched="$(gh workflow run publish.yml --repo xynolog/sdk --ref "$release" -f "registry=$registry" 2>&1)" \
    || fail "$dispatched"
  echo "$dispatched"
  url="$(sed -nE 's#.*(https://github\.com/xynolog/sdk/actions/runs/[0-9]+).*#\1#p' <<< "$dispatched")"
  test -n "$url" || fail "gh workflow run named no run to watch: find publish.yml's run for $registry in the Actions tab."
  echo "Approve it in the release environment: $url"
  gh run watch --repo xynolog/sdk --compact --exit-status "${url##*/}" \
    || fail "$release did not publish to $registry: $url${remaining:+. Not yet published to: $remaining}"
done

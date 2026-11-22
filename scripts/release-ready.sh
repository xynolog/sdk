#!/usr/bin/env bash
# What a release of this commit needs, checked before it is tagged and again
# before anything is published:
#
#   - the committed manifests hold the coming release's versions;
#   - the coming release is not tagged on another commit;
#   - main holds the commit, so its release workflow and the signing key it
#     trusts came through a pull request;
#   - CI's run for the commit's push to main finished green. A pull request
#     builds and tests only the languages it touches; a push to main builds
#     and tests all of them, so that run is what says every SDK passed;
#   - its Protocol submodule's commit is on Protocol's main, so no release
#     builds from an unmerged Protocol change. Protocol has no versions; the
#     commit is the whole pin.
#
#   scripts/release-ready.sh

set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "::error::$1" >&2; exit 1; }

python3 scripts/sdk_version.py check
python3 scripts/sdk_version.py unreleased

git fetch --quiet origin main
git merge-base --is-ancestor HEAD FETCH_HEAD || fail "main does not hold $(git rev-parse HEAD)"

commit="$(git rev-parse HEAD)"
run="$(gh api "repos/xynolog/sdk/actions/workflows/ci.yml/runs?event=push&branch=main&head_sha=$commit" \
  --jq '.workflow_runs[0] // empty | "\(.status) \(.conclusion) \(.html_url)"')" \
  || fail "could not read CI's runs for $commit"
test -n "$run" || fail "CI has no run for the push of $commit to main"
read -r status conclusion url <<< "$run"
test "$status" = completed || fail "CI's run for $commit on main has not finished: $url"
test "$conclusion" = success || fail "CI's run for $commit on main concluded $conclusion: $url"
echo "CI passed for $commit on main: $url"

protocol="$(git rev-parse HEAD:protocol)"
# A shallow submodule cannot answer ancestry, so its history comes too.
if test "$(git -C protocol rev-parse --is-shallow-repository)" = true; then
  git -C protocol fetch --quiet --unshallow origin main
else
  git -C protocol fetch --quiet origin main
fi
git -C protocol merge-base --is-ancestor "$protocol" FETCH_HEAD \
  || fail "the Protocol submodule's commit $protocol is not on Protocol's main"
echo "Protocol $protocol, on Protocol's main."

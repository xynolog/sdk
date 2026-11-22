#!/usr/bin/env bash
# Tag this commit as the SDK release version.json names, in two steps.
#
#   scripts/tag-release.sh        sign and push vX.Y.Z on main's latest
#                                 commit, as GitHub has it
#   scripts/tag-release.sh go     sign and push go/vX.Y.Z on vX.Y.Z's commit,
#                                 once its release workflow has released the
#                                 bundle, though main may have moved on since
#
# A person runs it, with their own Git signer: each tag is annotated and
# signed, and a release workflow does nothing unless the release signer signed
# it. Pushing `vX.Y.Z` starts the release workflow, which builds, verifies and
# releases the bundle. Pushing `go/vX.Y.Z` is itself the Go release, since the
# Go module proxy serves it from then on, so it waits until that bundle is
# released from this commit: a failed build spends no Go version.

set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "$1" >&2; exit 1; }

test "$#" -le 1 || fail "usage: scripts/tag-release.sh [go]"
step="${1:-sdk}"
test "$step" = sdk || test "$step" = go || fail "usage: scripts/tag-release.sh [go]"

test -z "$(git status --porcelain)" || fail "The working tree has changes: tag a commit as it is."
bash scripts/release-ready.sh

read -r -a tags <<< "$(python3 scripts/sdk_version.py tags)"
release="${tags[0]}"
commit="$(git rev-parse HEAD)"

if [ "$step" = sdk ]; then
  tag="$release"
  # A merge lands on main as a new squashed commit, so a local main that was
  # not pulled since is an older commit that main still holds.
  git fetch --quiet origin main
  tip="$(git rev-parse FETCH_HEAD)"
  test "$tip" = "$commit" \
    || fail "This is $commit, but main is at $tip: run git switch main && git pull --ff-only, then tag again."
else
  tag="${tags[1]}"
  git fetch --quiet --force --no-tags origin "+refs/tags/$release:refs/tags/$release" \
    || fail "$release is not pushed: run scripts/tag-release.sh first"
  test "$(git rev-parse "refs/tags/$release^{commit}")" = "$commit" || fail "$release is not on this commit"
  target="$(gh api "repos/xynolog/sdk/releases/tags/$release" --jq .target_commitish)" \
    || fail "$release has no GitHub release yet: its release workflow has not released the bundle"
  test "$target" = "$commit" || fail "the GitHub release $release targets $target, not this commit"
fi

git tag --sign --annotate --message "Xynolog SDK $tag" "$tag"
git push origin "refs/tags/$tag"

#!/usr/bin/env bash
# Tag the SDK release version.json names, as `make tag-release` runs it.
#
#   scripts/tag-release.sh        on main, pull its latest commit and the
#                                 pinned submodules, sign and push vX.Y.Z,
#                                 then go on as `go` does
#   scripts/tag-release.sh go     on vX.Y.Z's commit, though main may have
#                                 moved on since: wait for its release
#                                 workflow to release the bundle, then sign
#                                 and push go/vX.Y.Z
#
# A person runs it, with their own Git signer: each tag is annotated and
# signed, and a release workflow does nothing unless the release signer signed
# it. Pushing `vX.Y.Z` starts the release workflow, which builds, verifies and
# releases the bundle. Pushing `go/vX.Y.Z` is itself the Go release, since the
# Go module proxy serves it from then on, so it waits until that bundle is
# released from this commit: a failed build spends no Go version.
#
# A tag already on this commit is pushed again rather than signed again, so a
# run that stopped is run again from the start.

set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "$1" >&2; exit 1; }

test "$#" -le 1 || fail "usage: scripts/tag-release.sh [go]"
step="${1:-sdk}"
test "$step" = sdk || test "$step" = go || fail "usage: scripts/tag-release.sh [go]"

test -z "$(git status --porcelain)" || fail "The working tree has changes: tag a commit as it is."

if [ "$step" = sdk ]; then
  branch="$(git symbolic-ref --quiet --short HEAD)" || fail "HEAD is detached: tag from main (git switch main)."
  test "$branch" = main || fail "This is $branch: tag from main (git switch main)."
  git pull --ff-only origin main
  git submodule update --init --recursive
fi

bash scripts/release-ready.sh

read -r -a tags <<< "$(python3 scripts/sdk_version.py tags)"
release="${tags[0]}"
go="${tags[1]}"
commit="$(git rev-parse HEAD)"

# Sign the tag on this commit, unless it is already, and push it.
push_tag() {
  if git rev-parse --quiet --verify "refs/tags/$1" > /dev/null; then
    test "$(git rev-parse "refs/tags/$1^{commit}")" = "$commit" \
      || fail "$1 is tagged here on $(git rev-parse "refs/tags/$1^{commit}"), not on this commit $commit."
  else
    git tag --sign --annotate --message "Xynolog SDK $1" "$1"
  fi
  git push origin "refs/tags/$1"
}

if [ "$step" = sdk ]; then
  # A merge lands on main as a new squashed commit, so a local main that the
  # pull could not bring up to date is an older commit that main still holds.
  git fetch --quiet origin main
  tip="$(git rev-parse FETCH_HEAD)"
  test "$tip" = "$commit" || fail "This is $commit, but main is at $tip."
  push_tag "$release"
fi

git fetch --quiet --force --no-tags origin "+refs/tags/$release:refs/tags/$release" \
  || fail "$release is not pushed: run scripts/tag-release.sh on main first"
test "$(git rev-parse "refs/tags/$release^{commit}")" = "$commit" || fail "$release is not on this commit"

# The push starts the run, which GitHub lists a few seconds later.
run=""
for _ in $(seq 60); do
  run="$(gh run list --repo xynolog/sdk --workflow release-artifacts.yml --event push --commit "$commit" \
    --json databaseId --jq '.[0].databaseId // empty')"
  test -n "$run" && break
  sleep 5
done
test -n "$run" || fail "release-artifacts.yml has no run for $release after five minutes"
gh run watch --repo xynolog/sdk --compact --exit-status "$run" \
  || fail "release-artifacts.yml's run for $release did not succeed, so $go is not tagged: https://github.com/xynolog/sdk/actions/runs/$run"

target="$(gh api "repos/xynolog/sdk/releases/tags/$release" --jq .target_commitish)" \
  || fail "$release has no GitHub release, though its release workflow succeeded"
test "$target" = "$commit" || fail "the GitHub release $release targets $target, not this commit"

push_tag "$go"

#!/usr/bin/env bash
# languages-to-build.sh EVENT — print, as a JSON list, the SDK languages a
# workflow run for the GitHub event EVENT builds.
#
# A pull request builds the languages its change touches (changed-languages.py),
# read from the merge commit it checks out: its first parent is the base, so
# HEAD^1..HEAD is the pull request's change. Every other run, main's and the
# merge queue's among them, builds every language, so a read the search misses
# still fails before a release.
set -euo pipefail
cd "$(dirname "$0")/.."

if (($# != 1)); then
  echo 'Usage: languages-to-build.sh EVENT' >&2
  exit 2
fi

listed="$(printf "print-%%:\n\t@echo \$(\$*)\n" | make -s --no-print-directory -f Makefile -f - print-LANGUAGES)"
read -r -a languages <<< "$listed"
if ((${#languages[@]} == 0)); then
  echo 'languages-to-build.sh: the Makefile lists no LANGUAGES' >&2
  exit 1
fi
if [[ "$1" == pull_request ]]; then
  python3 scripts/changed-languages.py HEAD^1 HEAD "${languages[@]}"
else
  python3 -c 'import json, sys; print(json.dumps(sys.argv[1:]))' "${languages[@]}"
fi

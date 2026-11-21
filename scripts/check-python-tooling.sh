#!/usr/bin/env bash
# Hold every Python file outside python/sdk, the repository's tooling, to the
# Python SDK's own checks, its mypy, pyright and ruff settings, with the tools
# python/sdk's uv.lock pins. Run from the repository root once `uv sync` has
# run in python/sdk.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
cd "$ROOT"
CONFIG="$ROOT/python/sdk/pyproject.toml"
TOOLS=(uv run --project python/sdk --locked)
# Every check runs, and any that fails fails the whole.
failed=0

# A failed listing fails here, not as a check of no files.
listed="$(git ls-files -- '*.py' ':!:python/sdk/**')"
[[ -n "$listed" ]] || { echo 'git lists no Python file outside python/sdk' >&2; exit 1; }
mapfile -t files <<< "$listed"
mapfile -t directories < <(printf '%s\n' "${files[@]}" | xargs -n1 dirname | sort -u)

# mypy takes two files of the same name as one module twice, and two
# directories each hold an api.py: each directory is its own run.
for directory in "${directories[@]}"; do
  here=()
  for file in "${files[@]}"; do
    if [[ "$(dirname "$file")" == "$directory" ]]; then here+=("$file"); fi
  done
  "${TOOLS[@]}" mypy --config-file "$CONFIG" "${here[@]}" || failed=1
done

# A script imports its directory's modules by name, as Python runs it.
pyright_config="$(mktemp -d)/pyrightconfig.json"
python3 - "$CONFIG" "${directories[@]/#/$ROOT/}" > "$pyright_config" <<'EOF'
import json
import sys

print(json.dumps({"extends": sys.argv[1], "extraPaths": sys.argv[2:]}))
EOF
"${TOOLS[@]}" pyright -p "$pyright_config" "${files[@]}" || failed=1

"${TOOLS[@]}" ruff check --config "$CONFIG" "${files[@]}" || failed=1
"${TOOLS[@]}" ruff format --check --config "$CONFIG" "${files[@]}" || failed=1
exit "$failed"

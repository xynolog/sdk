#!/usr/bin/env python3
"""Print, as a JSON list of matrix entries, the CodeQL analyses for the SDK languages a run builds.

Usage: codeql-analyses.py <sdk-languages>

<sdk-languages> is the JSON list languages-to-build.sh prints. Each SDK
language is scanned as the CodeQL languages its sources are written in; Haskell
and OCaml, which CodeQL does not read, are scanned for their C. GitHub Actions
is scanned when every SDK language is built: a change to the workflows touches
every language, and main's runs build every language.

An SDK language with no CodeQL language here fails the run, so a new SDK
language is scanned from its first build or the workflow says why not.
"""

import json
import sys

# Each analysis's build mode and runner. CodeQL analyzes Swift on macOS alone,
# and no Swift newer than 6.3 (Xcode 26), nor any build traced under Xcode 27
# or macOS 27; the package's own toolchain, Swift 6.4, is past what CodeQL
# reads, so codeql.yml compiles it with Xcode 26's Swift on a macOS 26 runner.
ANALYSES: dict[str, dict[str, str]] = {
    "actions": {"build-mode": "none", "runner": "ubuntu-latest"},
    "c-cpp": {"build-mode": "none", "runner": "ubuntu-latest"},
    "csharp": {"build-mode": "none", "runner": "ubuntu-latest"},
    "go": {"build-mode": "autobuild", "runner": "ubuntu-latest"},
    "java-kotlin": {"build-mode": "manual", "runner": "ubuntu-latest"},
    "javascript-typescript": {"build-mode": "none", "runner": "ubuntu-latest"},
    "python": {"build-mode": "none", "runner": "ubuntu-latest"},
    "rust": {"build-mode": "none", "runner": "ubuntu-latest"},
    "swift": {"build-mode": "manual", "runner": "macos-26"},
}

SCANNED_AS: dict[str, str] = {
    "typescript": "javascript-typescript",
    "python": "python",
    "rust": "rust",
    "go": "go",
    "csharp": "csharp",
    "haskell": "c-cpp",
    "kotlin": "java-kotlin",
    "ocaml": "c-cpp",
    "swift": "swift",
}

WORKFLOWS = "actions"


def analyses(languages: list[str]) -> list[dict[str, str]]:
    unscanned = [language for language in languages if language not in SCANNED_AS]
    if unscanned:
        sys.exit(f"codeql-analyses.py: no CodeQL language scans the SDK language(s) {', '.join(unscanned)}")
    selected = {SCANNED_AS[language] for language in languages}
    if set(languages) == set(SCANNED_AS):
        selected.add(WORKFLOWS)
    return [{"language": name, **ANALYSES[name]} for name in ANALYSES if name in selected]


def main() -> None:
    unreachable = set(ANALYSES) - set(SCANNED_AS.values()) - {WORKFLOWS}
    if unreachable:
        sys.exit(f"codeql-analyses.py: no SDK language selects the analyses {', '.join(sorted(unreachable))}")
    if len(sys.argv) != 2:
        sys.exit("Usage: codeql-analyses.py <sdk-languages>")
    print(json.dumps(analyses(json.loads(sys.argv[1]))))


if __name__ == "__main__":
    main()

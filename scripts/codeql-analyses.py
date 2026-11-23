#!/usr/bin/env python3
"""Print, as a JSON list of matrix entries, the CodeQL analyses for the SDK languages a run builds.

Usage: codeql-analyses.py <sdk-languages> <main-languages>

Each argument is a JSON list languages-to-build.sh prints: the SDK languages
this run builds, and those a push to main builds, every one. An SDK is
scanned in every CodeQL language its directory holds a source file of, as git
lists them: Haskell and OCaml, which CodeQL does not read, for their C and
Python. GitHub Actions is scanned when the run builds what main does: a change
to the workflows touches every language, and main's runs build every language.
"""

import json
import subprocess
import sys
from pathlib import PurePosixPath

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

# The CodeQL language that reads a source file, by its extension.
READ_BY: dict[str, str] = {
    ".c": "c-cpp",
    ".cc": "c-cpp",
    ".cpp": "c-cpp",
    ".cxx": "c-cpp",
    ".h": "c-cpp",
    ".hh": "c-cpp",
    ".hpp": "c-cpp",
    ".cs": "csharp",
    ".go": "go",
    ".java": "java-kotlin",
    ".kt": "java-kotlin",
    ".kts": "java-kotlin",
    ".cjs": "javascript-typescript",
    ".cts": "javascript-typescript",
    ".js": "javascript-typescript",
    ".jsx": "javascript-typescript",
    ".mjs": "javascript-typescript",
    ".mts": "javascript-typescript",
    ".ts": "javascript-typescript",
    ".tsx": "javascript-typescript",
    ".py": "python",
    ".pyi": "python",
    ".rs": "rust",
    ".swift": "swift",
}

WORKFLOWS = "actions"


def read_in(language: str) -> set[str]:
    files = subprocess.run(["git", "ls-files", "--", language], stdout=subprocess.PIPE, text=True, check=True).stdout
    if not files:
        sys.exit(f"codeql-analyses.py: git lists no file under {language}/")
    suffixes = {PurePosixPath(path).suffix for path in files.splitlines()}
    return {READ_BY[suffix] for suffix in suffixes if suffix in READ_BY}


def analyses(languages: list[str], as_main: bool) -> list[dict[str, str]]:
    selected = {read for language in languages for read in read_in(language)}
    if as_main:
        selected.add(WORKFLOWS)
    return [{"language": name, **ANALYSES[name]} for name in ANALYSES if name in selected]


def main() -> None:
    unreachable = set(ANALYSES) - set(READ_BY.values()) - {WORKFLOWS}
    if unreachable:
        sys.exit(f"codeql-analyses.py: no extension selects the analyses {', '.join(sorted(unreachable))}")
    if len(sys.argv) != 3:
        sys.exit("Usage: codeql-analyses.py <sdk-languages> <main-languages>")
    languages: list[str] = json.loads(sys.argv[1])
    main_languages: list[str] = json.loads(sys.argv[2])
    print(json.dumps(analyses(languages, set(languages) == set(main_languages))))


if __name__ == "__main__":
    main()

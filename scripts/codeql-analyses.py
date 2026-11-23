#!/usr/bin/env python3
"""Print, as a JSON list of matrix entries, the CodeQL analyses of the SDKs a run builds.

Usage: codeql-analyses.py <sdk-languages> <main-languages>

Each argument is a JSON list languages-to-build.sh prints: the SDKs this run
builds, and those a push to main builds, every one. Each SDK is its own
directory and its own artifact, and is scanned in every CodeQL language its
directory holds a source file of, as git lists them, under the category
/sdk:<sdk>/language:<language>. What lies outside the SDKs' directories (the
workflows, scripts/) is the unit "repository", scanned when the run builds what
main does: a change outside the SDKs' directories touches every SDK.

An analysis is held to its unit's files. One that runs no build reads only the
paths its config names. One that builds compiles its unit alone: Gradle in
kotlin/sdk, SwiftPM in swift/sdk, and go build in each Go module the unit
holds. A compiled language found in a unit with no build of its own here fails
the run.
"""

import json
import subprocess
import sys
from pathlib import PurePosixPath

REPOSITORY = "repository"

# Each analysis's build mode and runner. CodeQL analyzes Swift on macOS alone,
# and no Swift newer than 6.3 (Xcode 26), nor any build traced under Xcode 27
# or macOS 27; the package's own toolchain, Swift 6.4, is past what CodeQL
# reads, so codeql.yml compiles it with Xcode 26's Swift on a macOS 26 runner.
ANALYSES: dict[str, dict[str, str]] = {
    "actions": {"build-mode": "none", "runner": "ubuntu-latest"},
    "c-cpp": {"build-mode": "none", "runner": "ubuntu-latest"},
    "csharp": {"build-mode": "none", "runner": "ubuntu-latest"},
    "go": {"build-mode": "manual", "runner": "ubuntu-latest"},
    "java-kotlin": {"build-mode": "manual", "runner": "ubuntu-latest"},
    "javascript-typescript": {"build-mode": "none", "runner": "ubuntu-latest"},
    "python": {"build-mode": "none", "runner": "ubuntu-latest"},
    "rust": {"build-mode": "none", "runner": "ubuntu-latest"},
    "swift": {"build-mode": "manual", "runner": "macos-26"},
}

# The unit whose build codeql.yml runs for a language CodeQL reads by tracing
# it, besides Go, which it builds in every module a unit holds.
BUILT_IN: dict[str, str] = {"java-kotlin": "kotlin", "swift": "swift"}

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

WORKFLOWS = ".github/"


def listed(pathspecs: list[str]) -> list[str]:
    files = subprocess.run(["git", "ls-files", "--", *pathspecs], stdout=subprocess.PIPE, text=True, check=True).stdout
    return files.splitlines()


def unit_files(unit: str, sdks: list[str]) -> list[str]:
    if unit == REPOSITORY:
        return listed(["."] + [f":(exclude){sdk}/" for sdk in sdks])
    files = listed([f"{unit}/"])
    if not files:
        sys.exit(f"codeql-analyses.py: git lists no file under {unit}/")
    return files


def read_in(files: list[str]) -> set[str]:
    languages = {READ_BY[suffix] for suffix in {PurePosixPath(path).suffix for path in files} if suffix in READ_BY}
    if any(path.startswith(WORKFLOWS) and path.endswith((".yml", ".yaml")) for path in files):
        languages.add("actions")
    return languages


def scope(unit: str, sdks: list[str]) -> str:
    if unit == REPOSITORY:
        return json.dumps({"paths-ignore": sdks})
    return json.dumps({"paths": [unit]})


def entry(unit: str, language: str, files: list[str], sdks: list[str]) -> dict[str, str]:
    analysis = {"sdk": unit, "language": language, **ANALYSES[language]}
    if analysis["build-mode"] == "none":
        return {**analysis, "config": scope(unit, sdks), "go-modules": "[]"}
    if language == "go":
        # The outermost module first: its go.mod names the Go that codeql.yml sets up.
        modules = sorted(
            (str(PurePosixPath(path).parent) for path in files if PurePosixPath(path).name == "go.mod"),
            key=lambda module: (module.count("/"), module),
        )
        if not modules:
            sys.exit(f"codeql-analyses.py: {unit} holds Go but no go.mod")
        return {**analysis, "config": "", "go-modules": json.dumps(modules)}
    if BUILT_IN[language] != unit:
        sys.exit(f"codeql-analyses.py: {unit} holds {language}, which codeql.yml builds in {BUILT_IN[language]} alone")
    return {**analysis, "config": "", "go-modules": "[]"}


def analyses(sdks: list[str], main_sdks: list[str]) -> list[dict[str, str]]:
    units = sdks + ([REPOSITORY] if set(sdks) == set(main_sdks) else [])
    entries: list[dict[str, str]] = []
    for unit in units:
        files = unit_files(unit, main_sdks)
        languages = read_in(files)
        entries += [entry(unit, language, files, main_sdks) for language in ANALYSES if language in languages]
    return entries


def main() -> None:
    if len(sys.argv) != 3:
        sys.exit("Usage: codeql-analyses.py <sdk-languages> <main-languages>")
    sdks: list[str] = json.loads(sys.argv[1])
    main_sdks: list[str] = json.loads(sys.argv[2])
    print(json.dumps(analyses(sdks, main_sdks)))


if __name__ == "__main__":
    main()

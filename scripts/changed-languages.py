#!/usr/bin/env python3
"""Print, as a JSON list, the SDK languages a pull request's changes touch.

Usage: changed-languages.py <base> <head> <language>...

A path under a language's directory touches that language and every language
that reads it. A language reads another when any of its files other than
Markdown names the other's directory ("typescript/", or "typescript" quoted,
as a path join spells it). The tree is searched on every run, so a new read
is found without being listed here, and a comment that only names another
language selects one language too many, never one too few. Readers are only
the direct ones: a build sees another language's change through the committed
files it reads, and those are in the diff. A Markdown file at the repository
root touches none. Any other path (protocol, scripts/, the Makefile, .github/,
version.json) touches every language.
"""

import json
import re
import subprocess
import sys


def git(*arguments: str) -> str:
    return subprocess.run(["git", *arguments], stdout=subprocess.PIPE, text=True, check=True).stdout


def naming_pattern(language: str) -> str:
    name = re.escape(language)
    return rf"(^|[^A-Za-z0-9_.-]){name}/|[\"']{name}[\"']"


def mentions(reader: str, read: str) -> bool:
    found = subprocess.run(["git", "grep", "-q", "-E", naming_pattern(read), "--", reader, ":!*.md"])
    if found.returncode > 1:
        sys.exit(f"changed-languages.py: git grep failed searching {reader} for {read}")
    return found.returncode == 0


def readers_of(languages: list[str]) -> dict[str, set[str]]:
    return {read: {reader for reader in languages if reader != read and mentions(reader, read)} for read in languages}


def touched(paths: list[str], languages: list[str]) -> set[str]:
    readers = readers_of(languages)
    selected: set[str] = set()
    for path in paths:
        top, _, rest = path.partition("/")
        if top in languages and rest:
            selected |= {top} | readers[top]
        elif rest or not path.endswith(".md"):
            return set(languages)
    return selected


def main() -> None:
    base, head, *languages = sys.argv[1:]
    if not languages:
        sys.exit("changed-languages.py: name the languages after <base> <head>")
    paths = git("diff", "--name-only", "--no-renames", base, head).splitlines()
    selected = touched(paths, languages)
    print(json.dumps([language for language in languages if language in selected]))


if __name__ == "__main__":
    main()

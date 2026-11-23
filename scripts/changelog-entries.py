#!/usr/bin/env python3
"""Fail when a change to a language's directory leaves its changelog as it was.

Usage: changelog-entries.py <base> <head>

Each of the Makefile's languages keeps one changelog under its directory
(sdk_version.changelog), whose latest section is the coming release's. A
change between <base> and <head> to any other file under a language's
directory changes that changelog too. A pull request whose change needs no
entry carries the no-changelog label, and the Changelog workflow does not
run this.
"""

import sys

import sdk_version


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    base, head = sys.argv[1:]
    paths = set(sdk_version.git("diff", "--name-only", "--no-renames", base, head).splitlines())
    missing: list[str] = []
    for language in sdk_version.LANGUAGES:
        changelog = str(sdk_version.changelog(language).relative_to(sdk_version.ROOT))
        changed = sorted(path for path in paths if path.startswith(f"{language}/") and path != changelog)
        if changed and changelog not in paths:
            missing.append(f"  {changelog}, for {len(changed)} changed files, {changed[0]} first")
    if missing:
        raise SystemExit(
            "These languages changed and their changelogs did not: add an entry to the coming release's section,"
            " or label the pull request no-changelog:\n" + "\n".join(missing)
        )
    print("Each language this changes has an entry in its changelog.")


if __name__ == "__main__":
    main()

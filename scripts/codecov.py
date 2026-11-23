#!/usr/bin/env python3
"""What sdk's Codecov badges read, and what each language uploads for them.

Usage: codecov.py census
       codecov.py upload LANGUAGE

.github/codecov.yml names a flag for each of the Makefile's languages, scoped
to the language's directory, and the components, each by its paths. Codecov
counts an upload's whole report under each flag it carries, so a language
uploads under its own flag alone: `upload` prints it, and the reports
`make test-<language>` wrote into coverage/<language>/
(scripts/make-target.sh), as lines for a step's outputs. A component counts
every flag's coverage in its paths, and a README's badge reads one.

`census` fails unless the flags are the Makefile's languages, one each, each
scoped to `<language>/**`; unless the badges in sdk's Markdown and the
components are the same names, one of each; and unless each component's
paths are each the glob `<directory>/**` of a directory the checkout has,
inside one language's directory. It reads codecov.yml with yq, as CI's
runner has it.
"""

import json
import re
import subprocess
import sys
from typing import TypedDict

import sdk_version

ROOT = sdk_version.ROOT
CONFIG = ROOT / ".github" / "codecov.yml"
SLUG = "xynolog/sdk"
BADGE = re.compile(rf"https://codecov\.io/gh/{re.escape(SLUG)}/graph/badge\.svg\?component=([a-z0-9-]+)\)")
COMPONENTS_PAGE = f"https://app.codecov.io/gh/{SLUG}/components)"
CODECOV_LINK = re.compile(r"https://(?:app\.)?codecov\.io/[^\s)]*\)?")
PATH = re.compile(r"(.+)/\*\*")


class Flag(TypedDict):
    name: str
    paths: list[str]


class FlagManagement(TypedDict):
    individual_flags: list[Flag]


class Component(TypedDict):
    component_id: str
    paths: list[str]


class ComponentManagement(TypedDict):
    individual_components: list[Component]


class Config(TypedDict):
    flag_management: FlagManagement
    component_management: ComponentManagement


def config() -> Config:
    read = subprocess.run(["yq", "-o=json", ".", str(CONFIG)], stdout=subprocess.PIPE, text=True, check=True)
    parsed: Config = json.loads(read.stdout)
    return parsed


def upload(language: str) -> None:
    if language not in sdk_version.LANGUAGES:
        raise SystemExit(f"codecov.py: {language} is none of the Makefile's languages, {' '.join(sdk_version.LANGUAGES)}")
    if language not in {flag["name"] for flag in config()["flag_management"]["individual_flags"]}:
        raise SystemExit(f"codecov.py: {CONFIG.relative_to(ROOT)} names no flag {language}")
    reports = ROOT / "coverage" / language
    files = sorted(str(path.relative_to(ROOT)) for path in reports.iterdir() if path.is_file()) if reports.is_dir() else []
    if not files:
        raise SystemExit(f"codecov.py: make test-{language} wrote no coverage report into {reports.relative_to(ROOT)}")
    print(f"flags={language}")
    print(f"files={','.join(files)}")


def badges() -> tuple[list[str], list[str]]:
    """The components sdk's Markdown badges read, and each Codecov link that is neither a badge nor the components page."""
    read: list[str] = []
    other: list[str] = []
    for name in sdk_version.git("ls-files", "-z", "--", "*.md").split("\0"):
        if not name:
            continue
        text = (ROOT / name).read_text()
        for link in CODECOV_LINK.findall(text):
            badge = BADGE.fullmatch(link)
            if badge:
                read.append(badge.group(1))
            elif link != COMPONENTS_PAGE:
                other.append(f"{name}: {link}")
    return read, other


def once(names: list[str], what: str) -> list[str]:
    return [f"{what} name {name} {names.count(name)} times" for name in sorted(set(names)) if names.count(name) > 1]


def directory(path: str) -> str | None:
    """The directory a path's glob `<directory>/**` names, when the checkout has it."""
    glob = PATH.fullmatch(path)
    return glob.group(1) if glob and (ROOT / glob.group(1)).is_dir() else None


def census() -> None:
    data = config()
    flags = data["flag_management"]["individual_flags"]
    components = data["component_management"]["individual_components"]
    read, other = badges()
    refusals = [f"a Codecov link that reads no component of {SLUG}: {link}" for link in other]
    refusals += once([flag["name"] for flag in flags], "codecov.yml's flags")
    refusals += once([component["component_id"] for component in components], "codecov.yml's components")
    named = {flag["name"] for flag in flags}
    refusals += [f"{language}: a language of the Makefile's with no flag" for language in sdk_version.LANGUAGES if language not in named]
    for flag in flags:
        if flag["name"] not in sdk_version.LANGUAGES:
            refusals.append(f"{flag['name']}: a flag that is none of the Makefile's languages, which alone upload")
        elif flag["paths"] != [f"{flag['name']}/**"]:
            refusals.append(f"{flag['name']}: the flag covers {flag['paths']}, not its language's directory, {flag['name']}/**")
    ids = {component["component_id"] for component in components}
    refusals += [f"{name}: a badge reads it, and no component is it" for name in sorted(set(read) - ids)]
    refusals += [f"{name}: a component no badge reads" for name in sorted(ids - set(read))]
    for component in components:
        for path in component["paths"]:
            found = directory(path)
            if found is None:
                refusals.append(f"{component['component_id']}: {path} is not the glob <directory>/** of a directory the checkout has")
            elif found.split("/")[0] not in sdk_version.LANGUAGES:
                refusals.append(f"{component['component_id']}: {path} is in no language's directory")
    if refusals:
        raise SystemExit(f"codecov.py: {CONFIG.relative_to(ROOT)} and the badges disagree:\n  " + "\n  ".join(refusals))
    print(f"The badges read {len(ids)} components, and each of the {len(flags)} languages uploads under its flag.")


def main() -> None:
    match sys.argv[1:]:
        case ["census"]:
            census()
        case ["upload", language]:
            upload(language)
        case _:
            raise SystemExit(__doc__)


if __name__ == "__main__":
    main()

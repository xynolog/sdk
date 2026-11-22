#!/usr/bin/env python3
"""The SDK's version in each language, derived from version.json.

version.json names the coming release, a semantic version `X.Y.Z`, and every
one of the nine languages publishes it as it is. Below 1.0 the minor number is
the break. Every package version and file name is derived here, and nothing
else reads version.json's `release`.

A commit that the release tag `vX.Y.Z` points at builds the release. Every
other commit builds a development version: a pre-release of the coming
release, labelled by the commit's UTC time and hash, which a shallow checkout
has (Hackage's by the time alone). A development version is never pushed to a
registry.

A release is tagged twice, `vX.Y.Z` and Go's `go/vX.Y.Z`. Once it is, the
coming release must move on, or every later commit's development version
would sort before the release it follows.

    sdk_version.py release          the coming release, X.Y.Z
    sdk_version.py tags             its release tags, the SDK's first
    sdk_version.py <language>       that language's version for this commit
    sdk_version.py check            the committed manifests and tagged links hold the release's versions
    sdk_version.py write            write them there
    sdk_version.py unreleased       the coming release is not yet tagged, but on this commit
    sdk_version.py move X.Y.Z       make X.Y.Z, a later release, the coming one
"""

# Hosts run this with their own python3, which may be older than the `X | None` it is typed with.
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import TypedDict


class Package(TypedDict):
    dir: str
    publish: bool


class Config(TypedDict):
    release: str
    packages: dict[str, Package]


ROOT = Path(__file__).resolve().parents[1]
RELEASE = re.compile(r"(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)")
GO_MODULE = "github.com/xynolog/sdk/go"
# A link to a file or directory of sdk as a release tag holds it, which a
# registry shows beside the release: it names the coming release, as the
# manifests do. A changelog's links name the releases they describe.
TAGGED_LINK = re.compile(r"(github\.com/xynolog/sdk/(?:blob|tree)/v)((?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*))/")
CHANGELOGS = {"CHANGELOG.md", "CHANGES.md"}


def makefile_languages() -> tuple[str, ...]:
    found = re.findall(r"(?m)^LANGUAGES := (.+)$", (ROOT / "Makefile").read_text())
    if len(found) != 1:
        raise SystemExit("sdk_version.py: the Makefile must set LANGUAGES exactly once")
    return tuple(found[0].split())


LANGUAGES = makefile_languages()


def config() -> Config:
    data: Config = json.loads((ROOT / "version.json").read_text())
    if sorted(data) != ["packages", "release"]:
        raise SystemExit(f"version.json: names {sorted(data)}, not the release and the packages")
    if not RELEASE.fullmatch(data["release"]):
        raise SystemExit(f"version.json: release {data['release']!r} is not X.Y.Z")
    return data


def released(data: Config, language: str) -> str:
    if language not in LANGUAGES:
        raise SystemExit(f"sdk_version.py: unknown SDK language {language!r}")
    return data["release"]


def development(data: Config, language: str, time: str, commit: str) -> str:
    base, label = released(data, language), f"g{commit[:7]}"
    if language == "python":
        return f"{base}.dev{time}+{label}"
    if language == "haskell":
        # Hackage takes no pre-release, and Cabal no more than nine digits in a
        # part: the date and the time of day as two more numeric parts. Five
        # parts never equal a release's three.
        return f"{base}.{time[:8]}.{int(time[8:])}"
    if language == "ocaml":
        return f"{base}~dev{time}.{label}"
    return f"{base}-dev.{time}.{label}"


def tags(data: Config) -> list[str]:
    return [f"v{data['release']}", f"go/v{released(data, 'go')}"]


def parts(release: str) -> tuple[int, int, int]:
    match = RELEASE.fullmatch(release)
    if match is None:
        raise SystemExit(f"sdk_version.py: {release!r} is not X.Y.Z")
    major, minor, patch = match.groups()
    return int(major), int(minor), int(patch)


def go_module(data: Config) -> str:
    """From major version 2, Go names the module by it."""
    major = parts(data["release"])[0]
    return GO_MODULE if major < 2 else f"{GO_MODULE}/v{major}"


def git(*arguments: str) -> str:
    return subprocess.run(
        ["git", "-C", str(ROOT), *arguments],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
        env={**os.environ, "TZ": "UTC"},
    ).stdout.strip()


def is_release(data: Config) -> bool:
    return f"v{data['release']}" in git("tag", "--points-at", "HEAD").split()


def version(language: str) -> str:
    """The version a build of this commit gives the language's packages."""
    data = config()
    if is_release(data):
        return released(data, language)
    time = git("log", "-1", "--format=%cd", "--date=format-local:%Y%m%d%H%M%S")
    return development(data, language, time, git("rev-parse", "HEAD"))


def manifests(data: Config) -> list[tuple[str, str | None, str]]:
    """Each committed manifest's version, as (path, found, wanted)."""
    found: list[tuple[str, str | None, str]] = []
    cargo = (ROOT / "rust/Cargo.toml").read_text()
    section = ""
    for line in cargo.splitlines():
        if line.startswith("["):
            section = line
        elif section == "[workspace.package]" and line.startswith("version = "):
            found.append(("rust/Cargo.toml [workspace.package]", line.split('"')[1], "rust"))
        elif section == "[workspace.dependencies]" and "path = " in line and 'version = "' in line:
            pinned = re.search(r'version = "([^"]*)"', line)
            found.append((f"rust/Cargo.toml {line.split()[0]}", pinned.group(1) if pinned else None, "rust"))
    published = subprocess.run(
        ["bash", str(ROOT / "rust/scripts/published-crates.sh")],
        stdout=subprocess.PIPE,
        text=True,
        check=True,
    ).stdout.split()
    lock = (ROOT / "rust/Cargo.lock").read_text()
    for crate in published:
        entry = re.search(rf'(?m)^name = "{re.escape(crate)}"\nversion = "([^"]*)"$', lock)
        found.append((f"rust/Cargo.lock {crate}", entry.group(1) if entry else None, "rust"))
    for package in data["packages"].values():
        path = f"{package['dir']}/package.json"
        found.append((path, json.loads((ROOT / path).read_text()).get("version"), "typescript"))
    cabal = re.findall(r"(?m)^version: (.+)$", (ROOT / "haskell/sdk/xynolog.cabal").read_text())
    found.append(("haskell/sdk/xynolog.cabal", cabal[0] if len(cabal) == 1 else None, "haskell"))
    return [(path, value, released(data, language)) for path, value, language in found]


def tagged_files() -> list[Path]:
    """Each tracked file outside a changelog that links to sdk at a release tag."""
    listed = git("ls-files", "-z").split("\0")
    found: list[Path] = []
    for name in listed:
        path = ROOT / name
        if not name or Path(name).name in CHANGELOGS or not path.is_file() or path.is_symlink():
            continue
        try:
            text = path.read_text()
        except UnicodeDecodeError:
            continue
        if TAGGED_LINK.search(text):
            found.append(path)
    return found


def tagged_links(data: Config) -> list[tuple[str, str | None, str]]:
    """Each tagged link's release, as (path:line, found, wanted)."""
    found: list[tuple[str, str | None, str]] = []
    for path in tagged_files():
        for number, line in enumerate(path.read_text().splitlines(), start=1):
            for link in TAGGED_LINK.finditer(line):
                found.append((f"{path.relative_to(ROOT)}:{number}", link.group(2), data["release"]))
    return found


def check() -> None:
    data = config()
    wrong = [f"  {path}: {value}, not {wanted}" for path, value, wanted in manifests(data) + tagged_links(data) if value != wanted]
    module = re.findall(r"(?m)^module (\S+)$", (ROOT / "go/go.mod").read_text())
    if module != [go_module(data)]:
        wrong.append(f"  go/go.mod: module {' '.join(module)}, not {go_module(data)}")
    if wrong:
        raise SystemExit(
            "The committed manifests and tagged links must hold the release's versions (sdk_version.py write):\n" + "\n".join(wrong)
        )
    print("The committed manifests and tagged links hold the release's versions.")


def write() -> None:
    data = config()
    subprocess.run(["bash", str(ROOT / "rust/scripts/cargo-version.sh"), released(data, "rust")], check=True)
    subprocess.run(
        ["bash", str(ROOT / "haskell/scripts/cabal-version.sh"), released(data, "haskell"), str(ROOT / "haskell/sdk/xynolog.cabal")],
        check=True,
    )
    for package in data["packages"].values():
        path = ROOT / package["dir"] / "package.json"
        manifest = json.loads(path.read_text())
        manifest["version"] = released(data, "typescript")
        path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")
    for path in tagged_files():
        path.write_text(TAGGED_LINK.sub(lambda link: f"{link.group(1)}{data['release']}/", path.read_text()))
    check()


def unreleased() -> None:
    """A tagged release is spent: only the commit it was tagged on may still name it."""
    data = config()
    tag = f"refs/tags/v{data['release']}"
    peeled = f"{tag}^{{}}"
    listed = {ref: commit for commit, ref in (line.split("\t") for line in git("ls-remote", "--tags", "origin", tag, peeled).splitlines())}
    # An annotated tag lists its commit as the peeled ref; a lightweight one, as itself.
    tagged = listed.get(peeled, listed.get(tag))
    if tagged is not None and tagged != git("rev-parse", "HEAD"):
        raise SystemExit(
            f"version.json's release {data['release']} is already tagged, at {tagged}:"
            " make a later release the coming one (sdk_version.py move X.Y.Z)"
        )
    print(f"The coming release {data['release']} is not yet tagged on another commit.")


def move(release: str) -> None:
    data = config()
    if parts(release) <= parts(data["release"]):
        raise SystemExit(f"sdk_version.py: {release} does not come after {data['release']}")
    data["release"] = release
    (ROOT / "version.json").write_text(json.dumps(data, indent=2) + "\n")
    write()


def main() -> None:
    command = sys.argv[1:]
    if command[:1] == ["move"] and len(command) == 2:
        move(command[1])
    elif len(command) != 1:
        raise SystemExit(__doc__)
    elif command == ["release"]:
        print(config()["release"])
    elif command == ["tags"]:
        print(" ".join(tags(config())))
    elif command == ["unreleased"]:
        unreleased()
    elif command == ["check"]:
        check()
    elif command == ["write"]:
        write()
    else:
        print(version(command[0]))


if __name__ == "__main__":
    main()

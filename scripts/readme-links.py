#!/usr/bin/env python3
"""Fail when a README a registry publishes links to sdk other than at the release's tag.

Usage: readme-links.py

Each registry resolves a relative link its own way or not at all, and a link
to main moves past the release it describes. So a published README links to a
file or directory of sdk as a tagged link (sdk_version.TAGGED_LINK), which
`sdk_version.py write` moves with each release and `check` holds to it, and
the link names a path the checkout tracks. Its in-page anchors stay, and so
does the one link to CONTRIBUTING.md at main, which is for working on the SDK
now. Code blocks and code spans hold no links.

The published READMEs are, for each of the Makefile's languages, the README
each published package's manifest names, or, where the registry takes it by
convention, the README beside the manifest.
"""

import json
import os
import re
from collections.abc import Callable
from pathlib import PurePosixPath

import sdk_version

ROOT = sdk_version.ROOT
SDK_LINK = re.compile(r"github\.com/xynolog/sdk/(?:blob|tree)/[^\s)\"'<>\]]*")
CONTRIBUTING_AT_MAIN = "github.com/xynolog/sdk/blob/main/CONTRIBUTING.md"
INLINE = re.compile(r"\]\(\s*<?([^\s)>]+)")
REFERENCE = re.compile(r"^ {0,3}\[[^\]]+\]:\s*<?([^\s>]+)")
HTML = re.compile(r"""\b(?:src|href)\s*=\s*["']([^"']+)["']""")
SCHEME = re.compile(r"[A-Za-z][A-Za-z0-9+.-]*:")
FENCE = re.compile(r"^ {0,3}(`{3,}|~{3,})")
CODE_SPAN = re.compile(r"(`+).+?\1")
PACKED = re.compile(r'<None Include="([^"]+)" Pack="true" PackagePath="/" />')


def tracked() -> list[str]:
    return [name for name in sdk_version.git("ls-files", "-z").split("\0") if name]


def under(files: list[str], language: str, name: Callable[[str], bool]) -> list[str]:
    return [path for path in files if path.startswith(f"{language}/") and name(PurePosixPath(path).name)]


def beside(manifest: str, readme: str) -> str:
    return os.path.normpath(str(PurePosixPath(manifest).parent / readme))


def one(found: list[str], what: str) -> str:
    if len(found) != 1:
        raise SystemExit(f"readme-links.py: {what} names one README, not {found}")
    return found[0]


def toml_strings(text: str, table: str) -> dict[str, str]:
    """The string values a TOML table sets on lines of their own."""
    section = ""
    found: dict[str, str] = {}
    for line in text.splitlines():
        if line.startswith("["):
            section = line.strip()
        elif section == f"[{table}]":
            value = re.fullmatch(r'([A-Za-z0-9_.-]+) = "([^"]*)"', line)
            if value:
                found[value.group(1)] = value.group(2)
    return found


def typescript(files: list[str]) -> list[str]:
    """npm's page is the README a published package's `files` lists."""
    found: list[str] = []
    for name, package in sdk_version.config()["packages"].items():
        if package["publish"]:
            listed: list[str] = json.loads((ROOT / package["dir"] / "package.json").read_text())["files"]
            found.append(one([f"{package['dir']}/{entry}" for entry in listed if entry.startswith("README")], name))
    return found


def python(files: list[str]) -> list[str]:
    """PyPI's page is the README a pyproject's `readme` names."""
    found: list[str] = []
    for manifest in under(files, "python", lambda name: name == "pyproject.toml"):
        readme = toml_strings((ROOT / manifest).read_text(), "project").get("readme")
        found.append(beside(manifest, one([readme] if readme else [], manifest)))
    return found


def rust(files: list[str]) -> list[str]:
    """crates.io's page is a published crate's `readme`, or, as Cargo takes it unnamed, the README.md beside its manifest."""
    crates: dict[str, str] = {}
    for manifest in under(files, "rust", lambda name: name == "Cargo.toml"):
        package = toml_strings((ROOT / manifest).read_text(), "package")
        if "name" in package:
            crates[package["name"]] = beside(manifest, package.get("readme", "README.md"))
    published = sdk_version.published_crates()
    unfound = [crate for crate in published if crate not in crates]
    if unfound:
        raise SystemExit(f"readme-links.py: no tracked Cargo.toml names the published crates {unfound}")
    return [crates[crate] for crate in published]


def go(files: list[str]) -> list[str]:
    """pkg.go.dev's page is the README.md at the module's root."""
    module = sdk_version.go_module(sdk_version.config())
    return [
        beside(manifest, "README.md")
        for manifest in under(files, "go", lambda name: name == "go.mod")
        if re.findall(r"(?m)^module (\S+)$", (ROOT / manifest).read_text()) == [module]
    ]


def csharp(files: list[str]) -> list[str]:
    """NuGet's page is the PackageReadmeFile a project packs at the package's root."""
    found: list[str] = []
    for manifest in under(files, "csharp", lambda name: name.endswith(".csproj")):
        text = (ROOT / manifest).read_text()
        for readme in re.findall(r"<PackageReadmeFile>([^<]+)</PackageReadmeFile>", text):
            packed = [beside(manifest, path) for path in re.findall(PACKED, text) if PurePosixPath(path).name == readme]
            found.append(one(packed, f"{manifest}'s PackageReadmeFile"))
    return found


def haskell(files: list[str]) -> list[str]:
    """Hackage's page is the README a package's cabal file ships at its root."""
    found: list[str] = []
    for manifest in under(files, "haskell", lambda name: name.endswith(".cabal")):
        fields = re.findall(r"(?m)^extra-(?:source|doc)-files:(.*(?:\n[ \t]+.*)*)", (ROOT / manifest).read_text())
        shipped = [entry for field in fields for entry in re.split(r"[\s,]+", field) if entry]
        found.append(one([beside(manifest, entry) for entry in shipped if entry.startswith("README")], manifest))
    return found


def by_convention(language: str, manifest: Callable[[str], bool]) -> Callable[[list[str]], list[str]]:
    return lambda files: [beside(path, "README.md") for path in under(files, language, manifest)]


SWIFT_DISTRIBUTION = "swift/distribution/README.md"
SWIFT_DISTRIBUTES = "swift/scripts/distribution.sh"


def swift(files: list[str]) -> list[str]:
    """The README beside Package.swift, and the Swift Package Index's page, which distribution.sh copies to xynolog/sdk-swift."""
    if SWIFT_DISTRIBUTION not in (ROOT / SWIFT_DISTRIBUTES).read_text():
        raise SystemExit(f"readme-links.py: {SWIFT_DISTRIBUTES} no longer copies {SWIFT_DISTRIBUTION} to xynolog/sdk-swift")
    return [*by_convention("swift", lambda name: name == "Package.swift")(files), SWIFT_DISTRIBUTION]


READMES: dict[str, Callable[[list[str]], list[str]]] = {
    "typescript": typescript,
    "python": python,
    "rust": rust,
    "go": go,
    "csharp": csharp,
    "haskell": haskell,
    # opam's page is the README beside the package's opam file.
    "ocaml": by_convention("ocaml", lambda name: name.endswith(".opam")),
    "kotlin": by_convention("kotlin", lambda name: name == "build.gradle.kts"),
    "swift": swift,
}


def published(files: list[str]) -> list[str]:
    languages = sorted(sdk_version.LANGUAGES)
    if sorted(READMES) != languages:
        raise SystemExit(f"readme-links.py: finds the published READMEs of {sorted(READMES)}, not of the Makefile's {languages}")
    found: list[str] = []
    for language, readmes in READMES.items():
        listed = readmes(files)
        if not listed:
            raise SystemExit(f"readme-links.py: {language} publishes no README it can find")
        untracked = [path for path in listed if path not in files]
        if untracked:
            raise SystemExit(f"readme-links.py: {language}'s published READMEs {untracked} are not tracked")
        found += listed
    return found


def prose(text: str) -> list[tuple[int, str]]:
    """Each line outside a code block, numbered, without its code spans."""
    lines: list[tuple[int, str]] = []
    fence = ""
    for number, line in enumerate(text.splitlines(), start=1):
        marker = FENCE.match(line)
        if fence:
            if marker and marker.group(1)[0] == fence[0] and len(marker.group(1)) >= len(fence) and not line[marker.end() :].strip():
                fence = ""
        elif marker:
            fence = marker.group(1)
        else:
            lines.append((number, CODE_SPAN.sub("", line)))
    return lines


def wrong_links(readme: str, files: list[str]) -> list[str]:
    wrong: list[str] = []
    for number, line in prose((ROOT / readme).read_text()):
        where = f"  {readme}:{number}"
        targets = [*INLINE.findall(line), *REFERENCE.findall(line), *HTML.findall(line)]
        wrong += [f"{where}: {target} is relative" for target in targets if not target.startswith("#") and not SCHEME.match(target)]
        for link in SDK_LINK.findall(line):
            if link == CONTRIBUTING_AT_MAIN:
                continue
            tagged = sdk_version.TAGGED_LINK.match(link)
            if tagged is None:
                wrong.append(f"{where}: {link} is not at the release's tag")
                continue
            kind = link.split("/")[3]
            path = re.split(r"[#?]", link[tagged.end() :])[0].rstrip("/")
            if kind == "blob" and path not in files:
                wrong.append(f"{where}: {link} names {path}, not a file the checkout tracks")
            elif kind == "tree" and not any(name.startswith(f"{path}/") for name in files):
                wrong.append(f"{where}: {link} names {path}, not a directory the checkout tracks")
    return wrong


def main() -> None:
    files = tracked()
    wrong = [line for readme in published(files) for line in wrong_links(readme, files)]
    if wrong:
        raise SystemExit(
            "A published README links to sdk at the release's tag, https://github.com/xynolog/sdk/blob/v<release>/<path>"
            " (tree/ for a directory), to a path the checkout tracks:\n" + "\n".join(wrong)
        )
    print("Each published README links to sdk at the release's tag.")


if __name__ == "__main__":
    main()

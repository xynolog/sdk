#!/usr/bin/env python3
"""Write a language's coverage reports as Codecov places them: by the repository's paths.

Usage: coverage-report.py FORMAT REPORTS OUT COPY BASE...

A language's tests run in its toolchain's container, on a copy of the
checkout at COPY (scripts/make-target.sh), and its coverage tool names each
source as it found it: by its path in that copy, by a path relative to one of
the checkout's directories BASE, or, for Go, by its import path. Each report
in the directory REPORTS is written into the directory OUT, each source named
by its path in the checkout. A source that is not a file of the checkout, or
that two BASEs both name, fails, and so does a report that names no source.

FORMAT is what the tool writes, and each format is written as itself, but
JaCoCo's XML, which is written as lcov:
  lcov    an lcov tracefile
  go      a Go cover profile, whose import paths are below sdk_version.GO_MODULE
  jacoco  JaCoCo's XML report, which names a source by its package's directory
"""

import os
import sys
import xml.etree.ElementTree as ElementTree
from pathlib import Path

import sdk_version

ROOT = sdk_version.ROOT


def source(named: str, copy: str, bases: list[str]) -> str:
    """The checkout's path of the one file a report names."""
    if named.startswith("/"):
        if not named.startswith(f"{copy}/"):
            raise SystemExit(f"coverage-report.py: {named} is outside the checkout's copy, {copy}")
        candidates = {named.removeprefix(f"{copy}/")}
    else:
        candidates = {os.path.normpath(f"{base}/{named}") for base in bases}
    found = sorted(path for path in candidates if not path.startswith("../") and (ROOT / path).is_file())
    if len(found) != 1:
        raise SystemExit(f"coverage-report.py: {named} names {found or 'no file'} of the checkout, from {sorted(bases)}")
    return found[0]


def lcov(report: Path, copy: str, bases: list[str]) -> tuple[str, int]:
    lines = report.read_text().splitlines(keepends=True)
    files = 0
    for index, line in enumerate(lines):
        if line.startswith("SF:"):
            lines[index] = f"SF:{source(line[3:].strip(), copy, bases)}\n"
            files += 1
    return "".join(lines), files


def go(report: Path, copy: str, bases: list[str]) -> tuple[str, int]:
    """A cover profile's line is `<import path>:<range> <statements> <count>`, after its `mode:` line."""
    mode, *blocks = report.read_text().splitlines()
    if not mode.startswith("mode: "):
        raise SystemExit(f"coverage-report.py: {report} is no Go cover profile")
    written = [mode]
    files: set[str] = set()
    for block in blocks:
        imported, _, counts = block.rpartition(":")
        if not imported.startswith(f"{sdk_version.GO_MODULE}/"):
            raise SystemExit(f"coverage-report.py: {imported} is not in the module {sdk_version.GO_MODULE}")
        path = source(imported.removeprefix(f"{sdk_version.GO_MODULE}/"), copy, bases)
        files.add(path)
        written.append(f"{path}:{counts}")
    return "\n".join(written) + "\n", len(files)


def attribute(element: ElementTree.Element, name: str) -> str:
    value = element.get(name)
    if value is None:
        raise SystemExit(f"coverage-report.py: a JaCoCo <{element.tag}> has no {name}")
    return value


def jacoco(report: Path, copy: str, bases: list[str]) -> tuple[str, int]:
    """Each line's covered instructions are its hits, and each branch is taken or missed."""
    records: list[str] = []
    for package in ElementTree.parse(report).getroot().iter("package"):
        directory = attribute(package, "name")
        for sourcefile in package.iter("sourcefile"):
            name = attribute(sourcefile, "name")
            records.append(f"SF:{source(f'{directory}/{name}' if directory else name, copy, bases)}\n")
            for line in sourcefile.iter("line"):
                number = attribute(line, "nr")
                records.append(f"DA:{number},{attribute(line, 'ci')}\n")
                taken = [1] * int(attribute(line, "cb")) + [0] * int(attribute(line, "mb"))
                records.extend(f"BRDA:{number},0,{branch},{hit}\n" for branch, hit in enumerate(taken))
            records.append("end_of_record\n")
    return "".join(records), sum(record.startswith("SF:") for record in records)


FORMATS = {"lcov": (lcov, ""), "go": (go, ""), "jacoco": (jacoco, ".lcov")}


def main() -> None:
    if len(sys.argv) < 6 or sys.argv[1] not in FORMATS:
        raise SystemExit(__doc__)
    write, suffix = FORMATS[sys.argv[1]]
    reports, out, copy, bases = Path(sys.argv[2]), Path(sys.argv[3]), sys.argv[4], sys.argv[5:]
    found = sorted(path for path in reports.iterdir() if path.is_file())
    if not found:
        raise SystemExit(f"coverage-report.py: the tests wrote no coverage report into {reports}")
    for report in found:
        text, files = write(report, copy, bases)
        if files == 0:
            raise SystemExit(f"coverage-report.py: {report.name} names no source")
        (out / (report.name + suffix)).write_text(text)
        print(f"coverage-report.py: {report.name} covers {files} files of the checkout")


if __name__ == "__main__":
    main()

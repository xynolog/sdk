"""Normalize HPC LCOV paths without changing line, function or branch counts."""

import os
import sys
from pathlib import Path

report = Path(sys.argv[1]).resolve()
root = Path(__file__).resolve().parents[1]
lines = report.read_text().splitlines(keepends=True)
files = 0
for index, line in enumerate(lines):
    if not line.startswith("SF:"):
        continue
    # Cabal's generated modules sit in dist-newstyle, which may be a symlink
    # out of the package (scripts/make-target.sh): the path is named as the
    # package holds it, not where the link leads.
    source = Path(os.path.normpath(report.parent / line[3:].strip()))
    if not source.is_file():
        raise AssertionError(f"HPC named a missing source file: {source}")
    lines[index] = "SF:" + source.relative_to(root).as_posix() + "\n"
    files += 1
if files == 0:
    raise AssertionError("HPC reported no source files")
report.write_text("".join(lines))

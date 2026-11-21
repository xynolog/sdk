#!/usr/bin/env python3
"""Create a deterministic gzip-compressed tar archive of an SDK bundle."""

from __future__ import annotations

import gzip
import sys
import tarfile
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit("Usage: create-artifact-archive.py BUNDLE_DIR OUTPUT_TAR_GZ")

    root = Path(sys.argv[1]).resolve()
    output = Path(sys.argv[2]).resolve()
    if not (root / "artifacts.json").is_file():
        raise SystemExit(f"Not an SDK artifact bundle: {root}")
    output.parent.mkdir(parents=True, exist_ok=True)

    with (
        output.open("wb") as raw_output,
        gzip.GzipFile(filename="", mode="wb", fileobj=raw_output, mtime=0, compresslevel=9) as compressed,
        tarfile.open(fileobj=compressed, mode="w|", format=tarfile.USTAR_FORMAT) as archive,
    ):
        paths = [root, *sorted(root.rglob("*"), key=lambda path: path.relative_to(root).as_posix())]
        for path in paths:
            relative = "." if path == root else path.relative_to(root).as_posix()
            info = archive.gettarinfo(str(path), arcname=relative)
            info.uid = 0
            info.gid = 0
            info.uname = ""
            info.gname = ""
            info.mtime = 0
            if info.isdir():
                info.mode = 0o755
            elif info.isfile():
                info.mode = 0o644
            elif info.issym():
                info.mode = 0o777
            if info.isfile():
                with path.open("rb") as source:
                    archive.addfile(info, source)
            else:
                archive.addfile(info)


if __name__ == "__main__":
    main()

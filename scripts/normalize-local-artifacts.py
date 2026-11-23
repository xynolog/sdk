#!/usr/bin/env python3
"""Normalize archive metadata before local SDK artifacts enter a bundle."""

import gzip
import os
import sys
import tarfile
import zipfile
from pathlib import Path

EPOCH = (1980, 1, 1, 0, 0, 0)


def normalize_zip(path: Path) -> None:
    temporary = path.with_name(path.name + ".normalized")
    with zipfile.ZipFile(path) as source, zipfile.ZipFile(temporary, "w") as target:
        target.comment = source.comment
        for original in sorted(source.infolist(), key=lambda item: item.filename):
            item = zipfile.ZipInfo(original.filename, EPOCH)
            item.compress_type = original.compress_type
            item.create_system = original.create_system
            item.external_attr = original.external_attr
            item.internal_attr = original.internal_attr
            item.flag_bits = original.flag_bits
            item.extra = b""
            target.writestr(item, source.read(original.filename), compress_type=item.compress_type)
    os.replace(temporary, path)


def normalize_tar_gz(path: Path) -> None:
    temporary = path.with_name(path.name + ".normalized")
    with tarfile.open(path, "r:gz") as source:
        members = sorted(source.getmembers(), key=lambda item: item.name)
        # Ustar, whose prefix field holds a name past 100 bytes: Cabal's tar
        # reader ignores a PAX path record, so a source distribution written
        # with one unpacks under truncated names. A name ustar cannot hold
        # fails here.
        with (
            temporary.open("wb") as raw,
            gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as compressed,
            tarfile.open(fileobj=compressed, mode="w", format=tarfile.USTAR_FORMAT) as target,
        ):
            for original in members:
                item = tarfile.TarInfo(original.name)
                item.type = original.type
                item.linkname = original.linkname
                item.mode = original.mode
                item.uid = 0
                item.gid = 0
                item.uname = ""
                item.gname = ""
                item.mtime = 0
                item.devmajor = original.devmajor
                item.devminor = original.devminor
                if original.isfile():
                    stream = source.extractfile(original)
                    if stream is None:
                        raise ValueError(f"cannot read archive member {original.name}")
                    item.size = original.size
                    target.addfile(item, stream)
                else:
                    item.size = 0
                    target.addfile(item)
    os.replace(temporary, path)


def main() -> None:
    for raw_path in sys.argv[1:]:
        path = Path(raw_path)
        if path.suffix in {".zip", ".nupkg", ".snupkg", ".jar", ".whl"}:
            normalize_zip(path)
        elif path.name.endswith(".tar.gz"):
            normalize_tar_gz(path)


if __name__ == "__main__":
    main()

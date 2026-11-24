#!/usr/bin/env python3
"""Verify an SDK artifact bundle's manifest identities and file digests."""

import argparse
import hashlib
import json
import sys
from pathlib import Path


def sha256(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("bundle", type=Path)
    parser.add_argument("--sdk-commit")
    parser.add_argument("--protocol-commit")
    parser.add_argument("--language", action="append", default=[])
    args = parser.parse_args()
    bundle = args.bundle.resolve()
    manifest_path = bundle / "artifacts.json"
    if not manifest_path.is_file():
        sys.exit(f"SDK artifact manifest not found: {manifest_path}")
    manifest = json.loads(manifest_path.read_text())
    if manifest.get("schema") != "xynolog-sdk-artifacts/v2":
        sys.exit("Unsupported SDK artifact manifest schema")
    if args.sdk_commit and manifest["sdk"]["commit"] != args.sdk_commit:
        sys.exit(f"SDK commit mismatch: expected {args.sdk_commit}, got {manifest['sdk']['commit']}")
    if args.protocol_commit and manifest["protocol"]["commit"] != args.protocol_commit:
        sys.exit(f"Protocol commit mismatch: expected {args.protocol_commit}, got {manifest['protocol']['commit']}")
    selected = set(args.language)
    carried = {Path(artifact["path"]).parts[0] for artifact in manifest["artifacts"] if artifact["ecosystem"] != "bundle-tool"}
    absent = sorted(selected - carried)
    if absent:
        sys.exit(f"SDK artifact bundle carries no artifacts for: {', '.join(absent)}")
    for artifact in manifest["artifacts"]:
        relative = Path(artifact["path"])
        if relative.is_absolute() or ".." in relative.parts:
            sys.exit(f"invalid artifact path in manifest: {relative}")
        if selected and artifact["ecosystem"] != "bundle-tool" and Path(artifact["path"]).parts[0] not in selected:
            continue
        path = bundle / relative
        if not path.is_file():
            sys.exit(f"SDK artifact is missing: {path}")
        actual = sha256(path)
        if actual != artifact["sha256"]:
            sys.exit(f"SDK artifact checksum mismatch: {path}")
    print(f"Verified SDK artifact bundle {manifest['sdk']['commit']} / {manifest['protocol']['commit']}")


if __name__ == "__main__":
    main()

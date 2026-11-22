#!/usr/bin/env python3
"""Stage current native SDK packages with source and Protocol provenance."""

import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from pathlib import Path

import sdk_version

ROOT = Path(__file__).resolve().parents[1]
STATE = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "xynolog-sdk" / "local"
SDK_COMMIT = subprocess.check_output(["git", "-C", str(ROOT), "rev-parse", "HEAD"], text=True).strip()
PROTOCOL_COMMIT = subprocess.check_output(["git", "-C", str(ROOT / "protocol"), "rev-parse", "HEAD"], text=True).strip()


def rust_toolchain() -> str:
    return subprocess.check_output(["sh", str(ROOT / "rust/scripts/rust-toolchain.sh")], text=True).strip()


def go_toolchain() -> str:
    return subprocess.check_output(["sh", str(ROOT / "go/scripts/go-toolchain.sh")], text=True).strip()


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(block)
    return value.hexdigest()


def working_tree_digest() -> str:
    value = hashlib.sha256()
    diff = subprocess.check_output(["git", "-C", str(ROOT), "diff", "--binary", "HEAD", "--", "."])
    value.update(diff)
    untracked = subprocess.check_output(["git", "-C", str(ROOT), "ls-files", "--others", "--exclude-standard", "-z"]).split(b"\0")
    for raw_path in sorted(path for path in untracked if path and not path.startswith(b"protocol/")):
        path = Path(os.fsdecode(raw_path))
        value.update(raw_path)
        value.update((ROOT / path).read_bytes())
    return value.hexdigest()


def files(language: str) -> list[tuple[Path, str, str]]:
    """Return source paths and package coordinate for a built language output."""
    if language == "codegen":
        return [(STATE / "codegen/xynolog-codegen", "codegen-binary", "xynolog-codegen")]
    version = sdk_version.version(language)
    if language == "typescript":
        return [
            (STATE / "npm/packages" / f"{name.removeprefix('@').replace('/', '-')}-{version}.tgz", "npm", name)
            for name, package in sdk_version.config()["packages"].items()
            if package["publish"]
        ]
    if language == "python":
        return [(p, "python", "xynolog") for p in sorted((STATE / "python/packages").glob(f"xynolog-{version}*"))]
    if language == "rust":
        names = ["xynolog", "xynolog-telemetry", "xynolog-http-transport"]
        return [(STATE / "rust/packages" / f"{name}-{version}.crate", "cargo", name) for name in names]
    if language == "go":
        root = STATE / "go-proxy/github.com/xynolog/sdk/go/@v"
        return [
            (root / ("list" if suffix == "list" else f"v{version}.{suffix}"), "go-module-proxy", "github.com/xynolog/sdk/go")
            for suffix in ("zip", "mod", "info", "list")
        ]
    if language == "csharp":
        return [(STATE / "nuget" / f"Xynolog.{version}.nupkg", "nuget", "Xynolog")]
    if language == "haskell":
        return [(STATE / "haskell" / f"xynolog-{version}.tar.gz", "hackage-sdist", "xynolog")]
    if language == "kotlin":
        root = STATE / f"kotlin-maven/org/xynolog/xynolog/{version}"
        return [(p, "maven", "org.xynolog:xynolog") for p in sorted(root.glob(f"xynolog-{version}.*")) if p.is_file()]
    if language == "ocaml":
        source = STATE / "opam-repo/repo" / f"archives/xynolog.{version}.tar.gz"
        return [(source, "opam-source", "xynolog")]
    if language == "swift":
        return [(STATE / "swift" / f"sdk-swift-{version}.zip", "swiftpm-package", "sdk-swift")]
    raise ValueError(f"unknown SDK language {language}")


def package_version(language: str, path: Path) -> str:
    if language == "typescript":
        with tarfile.open(path, "r:gz") as archive:
            member = next(m for m in archive.getmembers() if m.name.endswith("package/package.json"))
            stream = archive.extractfile(member)
            if stream is None:
                raise ValueError(f"{member.name} in {path} is not a file")
            version: str = json.load(stream)["version"]
            return version
    if language == "python" and path.suffix == ".whl":
        with zipfile.ZipFile(path) as archive:
            metadata = next(n for n in archive.namelist() if n.endswith(".dist-info/METADATA"))
            text = archive.read(metadata).decode()
    elif language == "python":
        with tarfile.open(path, "r:gz") as archive:
            info = next(m for m in archive.getmembers() if m.name.endswith("/PKG-INFO"))
            stream = archive.extractfile(info)
            if stream is None:
                raise ValueError(f"{info.name} in {path} is not a file")
            text = stream.read().decode()
    elif language == "codegen":
        return SDK_COMMIT
    else:
        return sdk_version.version(language)
    match = re.search(r"(?m)^Version: (.+)$", text)
    if not match:
        raise ValueError(f"package version missing from {path}")
    return match.group(1)


def main() -> None:
    arguments = sys.argv[1:]
    show_path = bool(arguments and arguments[0] == "--path")
    if show_path:
        arguments = arguments[1:]
    languages = list(sdk_version.LANGUAGES) if arguments == ["all"] else arguments
    if not languages:
        raise SystemExit("select at least one SDK language")
    languages = sorted(languages)
    tree_digest = working_tree_digest()
    selection = "-".join(languages)
    default_output = STATE.parent / "bundles" / f"v2-{SDK_COMMIT}-{PROTOCOL_COMMIT}-{tree_digest[:16]}-{selection}"
    configured_output = os.environ.get("SDK_ARTIFACTS")
    output = Path(configured_output or default_output).expanduser().resolve()
    if show_path:
        print(output)
        return

    with tempfile.TemporaryDirectory(prefix="xynolog-sdk-bundle.") as scratch:
        write_bundle(languages, tree_digest, output, Path(scratch))


def write_bundle(languages: list[str], tree_digest: str, output: Path, staged: Path) -> None:
    """Bundle copies of the selected packages, normalized in `staged`.

    The build containers own the cache they write the packages to; the copies are this host's to rewrite.
    """
    selected: list[tuple[str, str, str, Path, Path]] = []
    for language in languages:
        for source, ecosystem, package in files(language):
            if not source.is_file():
                raise SystemExit(f"required {language} SDK artifact is missing: {source}")
            relative = Path(language) / (source.relative_to(STATE) if language == "go" else source.name)
            copy = staged / relative
            copy.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(source, copy)
            selected.append((language, ecosystem, package, copy, relative))
    subprocess.run(
        [sys.executable, str(ROOT / "scripts/normalize-local-artifacts.py"), *(str(copy) for *_, copy, _ in selected)],
        check=True,
    )

    artifacts: list[dict[str, str]] = []
    copied: list[tuple[Path, Path]] = []
    for language, ecosystem, package, copy, relative in selected:
        artifacts.append(
            {
                "ecosystem": ecosystem,
                "package": package,
                "version": package_version(language, copy),
                "path": relative.as_posix(),
                "sha256": digest(copy),
            }
        )
        copied.append((copy, relative))

    toolchains = {
        "typescript": "node:26-bookworm",
        "python": "python:3.12-bookworm",
        "rust": f"rust:{rust_toolchain()}-bookworm",
        "go": f"golang:{go_toolchain()}-bookworm",
        "csharp": "mcr.microsoft.com/dotnet/sdk (version from csharp/sdk/global.json)",
        "haskell": "haskell:9.10.3",
        "kotlin": "eclipse-temurin (version from kotlin/sdk/.java-version)",
        "ocaml": "ocaml/opam:debian-13-ocaml-5.5",
        "swift": f"swift:{(ROOT / 'swift/sdk/.swift-version').read_text().strip()}",
        "codegen": "xynolog-ocaml-toolchain (build-tools/ocaml/toolchain.json), linked statically",
    }
    release = sdk_version.config()
    verifier_source = ROOT / "scripts/verify-artifact-bundle.py"
    verifier_path = Path("tools/verify-artifact-bundle.py")
    artifacts.append(
        {
            "ecosystem": "bundle-tool",
            "package": "xynolog-sdk-artifact-verifier",
            "version": "1",
            "path": verifier_path.as_posix(),
            "sha256": digest(verifier_source),
        }
    )
    copied.append((verifier_source, verifier_path))
    manifest: dict[str, object] = {
        "schema": "xynolog-sdk-artifacts/v2",
        "sdk": {
            "commit": SDK_COMMIT,
            "release": release["release"],
            "development": not sdk_version.is_release(release),
            "workingTreeSha256": tree_digest,
        },
        "protocol": {"commit": PROTOCOL_COMMIT},
        "languages": languages,
        "toolchains": {language: toolchains[language] for language in languages},
        "artifacts": artifacts,
    }
    encoded = (json.dumps(manifest, indent=2, sort_keys=True) + "\n").encode()

    existing = output / "artifacts.json"
    if existing.exists():
        if existing.read_bytes() != encoded:
            raise SystemExit(f"immutable artifact bundle already exists with different inputs: {output}")
        for source, relative in copied:
            target = output / relative
            if not target.is_file() or digest(target) != digest(source):
                raise SystemExit(f"artifact bundle checksum mismatch: {target}")
        print(f"Verified existing SDK artifact bundle: {output}")
        return

    if output.exists() and any(output.iterdir()):
        raise SystemExit(f"artifact destination is not empty: {output}")
    output.mkdir(parents=True, exist_ok=True)
    for source, relative in copied:
        target = output / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(source, target)
    (output / "artifacts.json").write_bytes(encoded)
    print(f"Created SDK artifact bundle: {output}")


if __name__ == "__main__":
    main()

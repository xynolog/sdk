"""Snapshot the installed library's actual GHC exports, including re-exports."""

import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path
from typing import TypedDict

ROOT = Path(__file__).resolve().parent


class Recipe(TypedDict):
    """public-api.inputs.json."""

    files: list[str]
    directories: list[str]


class Exports(TypedDict):
    """A module's exports, as public-api.json holds them."""

    types: dict[str, dict[str, str]]
    values: dict[str, str]


def inputs() -> dict[str, str]:
    recipe: Recipe = json.loads((ROOT / "public-api.inputs.json").read_text())
    paths = set(recipe["files"])
    for directory in recipe["directories"]:
        paths.update(p.relative_to(ROOT).as_posix() for p in (ROOT / directory).rglob("*") if p.is_file())
    return {path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest() for path in sorted(paths)}


def public_modules() -> list[str]:
    manifest = (ROOT / "xynolog.cabal").read_text()
    public = re.search(r"^library\n(.*?)(?=^\S|\Z)", manifest, re.M | re.S)
    if public is None:
        raise ValueError("no public Cabal library")
    if re.search(r"^\s+(?:if|else)\b", public[1], re.M):
        raise ValueError("conditional public modules need a compiler-package reader")
    fields = re.findall(r"^  (?:exposed-modules|reexported-modules):([^\n]*(?:\n    [^\n]*)*)", public[1], re.M)
    modules = [part for field in fields for part in re.split(r"[,\s]+", field.strip()) if part]
    if not modules or len(set(modules)) != len(modules) or not all(re.fullmatch(r"[A-Z]\w*(?:\.[A-Z]\w*)*", m) for m in modules):
        raise ValueError("unreadable or duplicate public module")
    return sorted(modules)


def canonical_units(declaration: str) -> str:
    # Hidden units acquire a package qualifier in GHC's pretty printer; an
    # exposed unit's identical type has only its module qualifier. Dependency
    # versions are held separately by the hashed Cabal freeze file.
    return re.sub(r"\b[A-Za-z][A-Za-z0-9_.+-]*(?::[A-Za-z][A-Za-z0-9_.+-]*)*:(?=[A-Z])", "", declaration)


def declarations(module: str) -> Exports:
    commands = f'Prelude.putStrLn "XYNOLOG_API_BEGIN"\n:browse! {module}\nPrelude.putStrLn "XYNOLOG_API_END"\n:quit\n'
    result = subprocess.run(
        ["cabal", "exec", "-v0", "--", "ghci", "-package", "xynolog", "-ignore-dot-ghci", "-v0"],
        input=commands,
        text=True,
        capture_output=True,
        check=True,
        cwd=ROOT,
        timeout=60,
    )
    if result.stderr.strip() or result.stdout.count("XYNOLOG_API_BEGIN\n") != 1 or result.stdout.count("XYNOLOG_API_END\n") != 1:
        raise ValueError(f"compiler inventory failed for {module}: {result.stdout}\n{result.stderr}")
    body = canonical_units(result.stdout.split("XYNOLOG_API_BEGIN\n")[1].split("XYNOLOG_API_END\n")[0])
    groups: list[str] = []
    for line in body.splitlines():
        if not line.strip() or line.startswith("--"):
            continue
        if line[0].isspace():
            if not groups:
                raise ValueError(f"orphan compiler continuation: {line}")
            groups[-1] += " " + line.strip()
        else:
            groups.append(line)
    values: dict[str, str] = {}
    types: dict[str, dict[str, str]] = {}
    for declaration in groups:
        if declaration.startswith("type role "):
            _, _, name, roles = declaration.split(" ", 3)
            types.setdefault(name.rsplit(".", 1)[-1], {})["roles"] = roles
        elif declaration.startswith("type "):
            kind = re.fullmatch(r"type ([\w.]+) :: (.+)", declaration)
            synonym = re.fullmatch(r"type ([\w.]+)(?: [a-z]\w*)* = .+", declaration)
            if kind:
                types.setdefault(kind[1].rsplit(".", 1)[-1], {})["kind"] = kind[2]
            elif synonym:
                types.setdefault(synonym[1].rsplit(".", 1)[-1], {})["definition"] = declaration
            else:
                raise ValueError(f"unreadable compiler type in {module}: {declaration}")
        elif declaration.startswith(("data ", "newtype ")):
            name = declaration.split(" ", 2)[1].rsplit(".", 1)[-1]
            types.setdefault(name, {})["definition"] = declaration
        elif " :: " in declaration:
            qualified, signature = declaration.split(" :: ", 1)
            name = qualified.rsplit(".", 1)[-1]
            if not re.fullmatch(r"[A-Za-z_]\w*", name) or name in values:
                raise ValueError(f"unreadable or duplicate compiler value: {declaration}")
            values[name] = signature
        else:
            raise ValueError(f"unreadable compiler declaration: {declaration}")
    if not values and not types:
        raise ValueError(f"compiler returned no exports for {module}")
    return {"types": types, "values": values}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument("--write", action="store_true")
    modes.add_argument("--check", action="store_true")
    modes.add_argument("--compiler-check", action="store_true")
    args = parser.parse_args()
    snapshot = ROOT / "public-api.json"
    source = inputs()
    modules = public_modules()
    if args.check:
        kept = json.loads(snapshot.read_text())
        if kept["inputs"] != source or sorted(kept["modules"]) != modules:
            raise ValueError("public API inventory is stale; build the library and run python3 api.py --write")
    else:
        actual = {"inputs": source, "modules": {module: declarations(module) for module in modules}}
        if args.write:
            snapshot.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n")
        else:
            expected = json.loads(snapshot.read_text())
            if expected != actual:
                import difflib

                difference = difflib.unified_diff(
                    json.dumps(expected, indent=2, sort_keys=True).splitlines(),
                    json.dumps(actual, indent=2, sort_keys=True).splitlines(),
                    fromfile="public-api.json",
                    tofile="GHC exports",
                    lineterm="",
                )
                raise ValueError("GHC exports differ from public-api.json:\n" + "\n".join(difference))
    print(f"PASS compiler-derived API inventory: {len(modules)} public modules")


if __name__ == "__main__":
    main()

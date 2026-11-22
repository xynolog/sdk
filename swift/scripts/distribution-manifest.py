#!/usr/bin/env python3
"""The Swift distribution package's manifest, derived from the SDK's.

Usage: distribution-manifest.py manifest <dump.json>
       distribution-manifest.py targets <dump.json>
       distribution-manifest.py spi <dump.json>

<dump.json> is what `swift package dump-package` prints for swift/sdk. The
distribution holds the SDK's library products, the targets they need, and the
package dependencies those targets name, and nothing else; a target that uses
a build plugin is refused, since the SDK commits what it generates.
`manifest` prints the distribution's Package.swift; `targets` prints the
targets it holds, one per line; `spi` prints its .spi.yml, which has the Swift
Package Index build and host the DocC documentation of each library product's
targets.

Anything in the dump this script does not know is refused, never guessed at:
a new setting, requirement or target property must be taught here first.
"""

import json
import sys
from collections.abc import Mapping, Set
from typing import Literal, NoReturn, NotRequired, TypedDict

# What this script reads of `swift package dump-package`. SwiftPM writes an
# enum case with values as {case: [values]}; each such value is narrowed where
# it is read.


class Product(TypedDict):
    name: str
    settings: list[object]
    targets: list[str]
    type: object


class Target(TypedDict):
    dependencies: list[dict[str, list[object]]]
    exclude: list[object]
    name: str
    packageAccess: object
    path: NotRequired[object]
    pluginUsages: NotRequired[object]
    resources: list[object]
    settings: list[object]
    type: str


class Remote(TypedDict):
    urlString: str


class Location(TypedDict):
    remote: list[Remote]


class Bounds(TypedDict):
    lowerBound: str
    upperBound: str


class SourceControl(TypedDict):
    identity: str
    location: Location
    productFilter: object
    # {"range": [Bounds]} or {"exact": [version]}
    requirement: dict[str, list[Bounds | str]]
    traits: object


class PackageDependency(TypedDict):
    sourceControl: list[SourceControl]


class Platform(TypedDict):
    options: list[object]
    platformName: str
    version: str


class ToolsVersion(TypedDict):
    _version: str


class Dump(TypedDict):
    cLanguageStandard: object
    cxxLanguageStandard: object
    defaultLocalization: object
    dependencies: list[PackageDependency]
    name: str
    packageKind: object
    pkgConfig: object
    platforms: list[Platform]
    products: list[Product]
    providers: object
    swiftLanguageVersions: list[str]
    targets: list[Target]
    toolsVersion: ToolsVersion
    traits: list[object]


PLATFORMS = {
    "macos": "macOS",
    "ios": "iOS",
    "tvos": "tvOS",
    "watchos": "watchOS",
    "visionos": "visionOS",
    "maccatalyst": "macCatalyst",
}
LANGUAGE_MODES = {"5": ".v5", "6": ".v6"}
UNSET_PACKAGE_KEYS = ("cLanguageStandard", "cxxLanguageStandard", "defaultLocalization", "pkgConfig", "providers")
PACKAGE_KEYS = Dump.__required_keys__
TARGET_KEYS = Target.__required_keys__ | Target.__optional_keys__


def refuse(message: str) -> NoReturn:
    raise SystemExit(f"distribution-manifest.py: {message}")


def quoted(text: object) -> str:
    return json.dumps(text)


def only_keys(what: str, value: Mapping[str, object], allowed: Set[str]) -> None:
    unknown = sorted(set(value) - allowed)
    if unknown:
        refuse(f"{what} has properties this script does not know: {unknown}")


def library_products(dump: Dump) -> list[Product]:
    products: list[Product] = []
    for product in dump["products"]:
        only_keys(f"product {product['name']}", product, Product.__required_keys__)
        if product["type"] != {"library": ["automatic"]} or product["settings"]:
            refuse(f"product {product['name']} is not an automatic library without settings")
        products.append(product)
    return products


def needed_targets(dump: Dump) -> list[Target]:
    """The targets the library products need, in the dump's order."""
    by_name = {target["name"]: target for target in dump["targets"]}
    needed: set[str] = set()
    waiting = [name for product in library_products(dump) for name in product["targets"]]
    while waiting:
        name = waiting.pop()
        if name in needed:
            continue
        if name not in by_name:
            refuse(f"{name} is needed but is not a target of the package")
        needed.add(name)
        for dependency in by_name[name]["dependencies"]:
            for kind in ("byName", "target"):
                if kind in dependency:
                    named = dependency[kind][0]
                    if not isinstance(named, str):
                        refuse(f"a target dependency this script does not know: {dependency}")
                    waiting.append(named)
    return [target for target in dump["targets"] if target["name"] in needed]


def target_dependency(dependency: dict[str, list[object]]) -> str:
    if set(dependency) == {"byName"} or set(dependency) == {"target"}:
        name, condition = next(iter(dependency.values()))
        if condition is not None:
            refuse(f"the dependency on {name} has a condition")
        return quoted(name) if "byName" in dependency else f".target(name: {quoted(name)})"
    if set(dependency) == {"product"}:
        name, package, aliases, condition = dependency["product"]
        if package is None or aliases is not None or condition is not None:
            refuse(f"the dependency on product {name} names no package, or has aliases or a condition")
        return f".product(name: {quoted(name)}, package: {quoted(package)})"
    refuse(f"a target dependency this script does not know: {dependency}")


def setting(entry: object) -> str:
    if entry == {"kind": {"treatAllWarnings": {"_0": "error"}}, "tool": "swift"}:
        return ".treatAllWarnings(as: .error)"
    refuse(f"a build setting this script does not know: {entry}")


def target(entry: Target) -> str:
    name = entry["name"]
    only_keys(f"target {name}", entry, TARGET_KEYS)
    if entry["type"] != "regular":
        refuse(f"target {name} is a {entry['type']} target, not a library target")
    empty: Literal["exclude", "resources"]
    for empty in ("exclude", "resources"):
        if entry[empty]:
            refuse(f"target {name} has {empty}")
    if "path" in entry:
        refuse(f"target {name} names a path; the distribution keeps each target at Sources/<name>")
    if entry["packageAccess"] is not True:
        refuse(f"target {name} turns package access off")
    if usages := entry.get("pluginUsages"):
        refuse(f"target {name} uses a build plugin: {usages}")
    arguments = [f"name: {quoted(name)}"]
    dependencies = [target_dependency(dependency) for dependency in entry["dependencies"]]
    if dependencies:
        arguments.append("dependencies: [\n" + "".join(f"        {d},\n" for d in dependencies) + "      ]")
    settings = [setting(item) for item in entry["settings"]]
    if settings:
        arguments.append(f"swiftSettings: [{', '.join(settings)}]")
    return "    .target(\n" + ",\n".join(f"      {argument}" for argument in arguments) + "\n    ),\n"


def package_dependency(entry: PackageDependency) -> tuple[str, str]:
    if set(entry) != {"sourceControl"} or len(entry["sourceControl"]) != 1:
        refuse(f"a package dependency that is not one source-control dependency: {entry}")
    control = entry["sourceControl"][0]
    only_keys(f"dependency {control.get('identity')}", control, SourceControl.__required_keys__)
    if control["productFilter"] is not None or control["traits"] != [{"name": "default"}]:
        refuse(f"dependency {control['identity']} filters products or chooses traits")
    location = control["location"]
    if set(location) != {"remote"} or len(location["remote"]) != 1 or set(location["remote"][0]) != {"urlString"}:
        refuse(f"dependency {control['identity']} is not one remote URL")
    url = location["remote"][0]["urlString"]
    requirement = control["requirement"]
    if set(requirement) == {"range"} and len(requirement["range"]) == 1:
        bounds = requirement["range"][0]
        if isinstance(bounds, str) or set(bounds) != {"lowerBound", "upperBound"}:
            refuse(f"dependency {control['identity']}'s range is not a lower and upper bound")
        written = f"{quoted(bounds['lowerBound'])}..<{quoted(bounds['upperBound'])}"
    elif set(requirement) == {"exact"} and len(requirement["exact"]) == 1:
        written = f"exact: {quoted(requirement['exact'][0])}"
    else:
        refuse(f"dependency {control['identity']}'s requirement is not a version range or exact version")
    return control["identity"], f"    .package(url: {quoted(url)}, {written}),\n"


def platform(entry: Platform) -> str:
    if entry["platformName"] not in PLATFORMS or entry["options"]:
        refuse(f"a platform this script does not know: {entry}")
    return f".{PLATFORMS[entry['platformName']]}({quoted(entry['version'])})"


def tools_version(dump: Dump) -> str:
    major, minor, patch = dump["toolsVersion"]["_version"].split(".")
    return f"{major}.{minor}" if patch == "0" else f"{major}.{minor}.{patch}"


def manifest(dump: Dump) -> str:
    only_keys("the package", dump, PACKAGE_KEYS)
    fields: Mapping[str, object] = dump
    for key in UNSET_PACKAGE_KEYS:
        if fields[key] is not None:
            refuse(f"the package sets {key}")
    if dump["traits"]:
        refuse("the package declares traits")
    targets = needed_targets(dump)
    named: set[str] = set()
    for dependency in (d for t in targets for d in t["dependencies"] if "product" in d):
        package = dependency["product"][1]
        if not isinstance(package, str):
            refuse(f"the dependency on product {dependency['product'][0]} names no package")
        named.add(package)
    dependencies = dict(package_dependency(entry) for entry in dump["dependencies"])
    missing = sorted(named - set(dependencies))
    if missing:
        refuse(f"targets name packages the package does not depend on: {missing}")
    modes = [
        LANGUAGE_MODES.get(mode) or refuse(f"a Swift language mode this script does not know: {mode}")
        for mode in dump["swiftLanguageVersions"]
    ]
    products = "".join(
        f"    .library(name: {quoted(p['name'])}, targets: [{', '.join(quoted(t) for t in p['targets'])}]),\n"
        for p in library_products(dump)
    )
    return (
        f"// swift-tools-version: {tools_version(dump)}\n"
        "// Written by the Xynolog SDK's release from the SDK's own manifest; not edited here.\n"
        "import PackageDescription\n\n"
        "let package = Package(\n"
        f"  name: {quoted(dump['name'])},\n"
        f"  platforms: [{', '.join(platform(p) for p in dump['platforms'])}],\n"
        f"  products: [\n{products}  ],\n"
        "  dependencies: [\n" + "".join(dependencies[identity] for identity in sorted(named)) + "  ],\n"
        "  targets: [\n" + "".join(target(t) for t in targets) + "  ],\n"
        f"  swiftLanguageModes: [{', '.join(modes)}]\n"
        ")\n"
    )


def spi(dump: Dump) -> str:
    documented = list(dict.fromkeys(name for product in library_products(dump) for name in product["targets"]))
    return (
        "# Written by the Xynolog SDK's release from the SDK's own manifest; not edited here.\n"
        "version: 1\n"
        "builder:\n"
        "  configs:\n"
        f"    - documentation_targets: [{', '.join(documented)}]\n"
    )


def main() -> None:
    if len(sys.argv) != 3 or sys.argv[1] not in ("manifest", "targets", "spi"):
        raise SystemExit(__doc__)
    with open(sys.argv[2]) as file:
        dump: Dump = json.load(file)
    if sys.argv[1] == "manifest":
        sys.stdout.write(manifest(dump))
    elif sys.argv[1] == "spi":
        sys.stdout.write(spi(dump))
    else:
        sys.stdout.write("".join(f"{t['name']}\n" for t in needed_targets(dump)))


if __name__ == "__main__":
    main()

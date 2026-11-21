#!/usr/bin/env python3
"""The Swift distribution package's manifest, derived from the SDK's.

Usage: distribution-manifest.py manifest <dump.json>
       distribution-manifest.py targets <dump.json>

<dump.json> is what `swift package dump-package` prints for swift/sdk. The
distribution holds the SDK's library products, the targets they need, and the
package dependencies those targets name, and nothing else; a target that uses
a build plugin is refused, since the SDK commits what it generates.
`manifest` prints the distribution's Package.swift; `targets` prints the
targets it holds, one per line.

Anything in the dump this script does not know is refused, never guessed at:
a new setting, requirement or target property must be taught here first.
"""

import json
import sys

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
PACKAGE_KEYS = {
    "dependencies",
    "name",
    "packageKind",
    "platforms",
    "products",
    "swiftLanguageVersions",
    "targets",
    "toolsVersion",
    "traits",
    *UNSET_PACKAGE_KEYS,
}
TARGET_KEYS = {"dependencies", "exclude", "name", "packageAccess", "path", "pluginUsages", "resources", "settings", "type"}


def refuse(message: str) -> None:
    raise SystemExit(f"distribution-manifest.py: {message}")


def quoted(text: str) -> str:
    return json.dumps(text)


def only_keys(what: str, value: dict, allowed: set) -> None:
    unknown = sorted(set(value) - allowed)
    if unknown:
        refuse(f"{what} has properties this script does not know: {unknown}")


def library_products(dump: dict) -> list:
    products = []
    for product in dump["products"]:
        only_keys(f"product {product['name']}", product, {"name", "settings", "targets", "type"})
        if product["type"] != {"library": ["automatic"]} or product["settings"]:
            refuse(f"product {product['name']} is not an automatic library without settings")
        products.append(product)
    return products


def needed_targets(dump: dict) -> list:
    """The targets the library products need, in the dump's order."""
    by_name = {target["name"]: target for target in dump["targets"]}
    needed: set = set()
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
                    waiting.append(dependency[kind][0])
    return [target for target in dump["targets"] if target["name"] in needed]


def target_dependency(dependency: dict) -> str:
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


def setting(entry: dict) -> str:
    if entry == {"kind": {"treatAllWarnings": {"_0": "error"}}, "tool": "swift"}:
        return ".treatAllWarnings(as: .error)"
    refuse(f"a build setting this script does not know: {entry}")


def target(entry: dict) -> str:
    name = entry["name"]
    only_keys(f"target {name}", entry, TARGET_KEYS)
    if entry["type"] != "regular":
        refuse(f"target {name} is a {entry['type']} target, not a library target")
    for empty in ("exclude", "resources"):
        if entry[empty]:
            refuse(f"target {name} has {empty}")
    if "path" in entry:
        refuse(f"target {name} names a path; the distribution keeps each target at Sources/<name>")
    if entry["packageAccess"] is not True:
        refuse(f"target {name} turns package access off")
    if entry.get("pluginUsages"):
        refuse(f"target {name} uses a build plugin: {entry['pluginUsages']}")
    arguments = [f"name: {quoted(name)}"]
    dependencies = [target_dependency(dependency) for dependency in entry["dependencies"]]
    if dependencies:
        arguments.append("dependencies: [\n" + "".join(f"        {d},\n" for d in dependencies) + "      ]")
    settings = [setting(item) for item in entry["settings"]]
    if settings:
        arguments.append(f"swiftSettings: [{', '.join(settings)}]")
    return "    .target(\n" + ",\n".join(f"      {argument}" for argument in arguments) + "\n    ),\n"


def package_dependency(entry: dict) -> tuple:
    if set(entry) != {"sourceControl"} or len(entry["sourceControl"]) != 1:
        refuse(f"a package dependency that is not one source-control dependency: {entry}")
    control = entry["sourceControl"][0]
    only_keys(f"dependency {control.get('identity')}", control, {"identity", "location", "productFilter", "requirement", "traits"})
    if control["productFilter"] is not None or control["traits"] != [{"name": "default"}]:
        refuse(f"dependency {control['identity']} filters products or chooses traits")
    location = control["location"]
    if set(location) != {"remote"} or len(location["remote"]) != 1 or set(location["remote"][0]) != {"urlString"}:
        refuse(f"dependency {control['identity']} is not one remote URL")
    url = location["remote"][0]["urlString"]
    requirement = control["requirement"]
    if set(requirement) == {"range"} and len(requirement["range"]) == 1:
        bounds = requirement["range"][0]
        if set(bounds) != {"lowerBound", "upperBound"}:
            refuse(f"dependency {control['identity']}'s range is not a lower and upper bound")
        written = f"{quoted(bounds['lowerBound'])}..<{quoted(bounds['upperBound'])}"
    elif set(requirement) == {"exact"} and len(requirement["exact"]) == 1:
        written = f"exact: {quoted(requirement['exact'][0])}"
    else:
        refuse(f"dependency {control['identity']}'s requirement is not a version range or exact version")
    return control["identity"], f"    .package(url: {quoted(url)}, {written}),\n"


def platform(entry: dict) -> str:
    if entry["platformName"] not in PLATFORMS or entry["options"]:
        refuse(f"a platform this script does not know: {entry}")
    return f".{PLATFORMS[entry['platformName']]}({quoted(entry['version'])})"


def tools_version(dump: dict) -> str:
    major, minor, patch = dump["toolsVersion"]["_version"].split(".")
    return f"{major}.{minor}" if patch == "0" else f"{major}.{minor}.{patch}"


def manifest(dump: dict) -> str:
    only_keys("the package", dump, PACKAGE_KEYS)
    for key in UNSET_PACKAGE_KEYS:
        if dump[key] is not None:
            refuse(f"the package sets {key}")
    if dump["traits"]:
        refuse("the package declares traits")
    targets = needed_targets(dump)
    named = {d["product"][1] for t in targets for d in t["dependencies"] if "product" in d}
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


def main() -> None:
    if len(sys.argv) != 3 or sys.argv[1] not in ("manifest", "targets"):
        raise SystemExit(__doc__)
    with open(sys.argv[2]) as file:
        dump = json.load(file)
    if sys.argv[1] == "manifest":
        sys.stdout.write(manifest(dump))
    else:
        sys.stdout.write("".join(f"{t['name']}\n" for t in needed_targets(dump)))


if __name__ == "__main__":
    main()

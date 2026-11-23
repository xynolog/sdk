#!/bin/sh
# Install the Swift distribution package as an application installs it, and
# build a program on it.
#
#   swift/scripts/consume-distribution.sh <tree> <version> <consumer>
#
# <tree> is the distribution, as distribution.sh writes it; <consumer> holds
# Sources/Consumer, the program. The tree is committed to a scratch git
# repository and tagged <version>, and the program depends on it by URL at
# exactly that version, with the SDK's dependencies at the newest versions
# its manifest allows. Run where swift and git are on the path.
set -eu
tree=$1
version=$2
consumer=$3
work=$(mktemp -d)

cp -a "$tree" "$work/sdk-swift"
git -C "$work/sdk-swift" init -q
git -C "$work/sdk-swift" add -A
git -C "$work/sdk-swift" -c user.name=distribution -c user.email=distribution@invalid commit -q -m "Xynolog SDK for Swift $version"
git -C "$work/sdk-swift" tag "$version"
cp -a "$consumer" "$work/consumer"
cat > "$work/consumer/Package.swift" <<MANIFEST
// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "Consumer",
  dependencies: [.package(url: "file://$work/sdk-swift", exact: "$version")],
  targets: [
    .executableTarget(
      name: "Consumer",
      dependencies: [
        .product(name: "Xynolog", package: "sdk-swift"),
        .product(name: "XynologTesting", package: "sdk-swift"),
      ])
  ]
)
MANIFEST
cd "$work/consumer"
swift build --jobs 4
# How SwiftPM took the dependency: the pin names its kind.
cat Package.resolved

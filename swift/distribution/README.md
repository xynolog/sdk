# Xynolog SDK for Swift

The Swift package of the Xynolog SDK. Each release of the SDK writes one
commit here and tags it with the Swift package's version; nothing here is
edited by hand. The SDK is developed in
[xynolog/sdk](https://github.com/xynolog/sdk), whose
[Swift README](https://github.com/xynolog/sdk/blob/v0.8.1/swift/sdk/README.md)
describes its use.

Add the package to your `Package.swift` by this repository's URL, from the
version you want. Below 1.0 the minor number is the break, and SwiftPM's
`from:` would let a breaking `0.y` through, so take releases up to the next
minor:

```swift
.package(url: "https://github.com/xynolog/sdk-swift.git", .upToNextMinor(from: "<version>")),
```

and add `.product(name: "Xynolog", package: "sdk-swift")` to your target's
dependencies. `XynologTesting` holds the test doubles.

The wire models in `Sources/Xynolog/Generated` are generated from the
Protocol commit the SDK release was built from.

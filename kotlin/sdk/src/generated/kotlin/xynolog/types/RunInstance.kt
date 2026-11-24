// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

/** A run's instance, by the name its caller gave it: unique among the target's instances that run on this machine. A second dispatcher beside the first is another instance. The launcher names the instance's container from the target's key and this name. */
public typealias RunInstance = String

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

/** An access token, as its issuer issued it: short-lived, and what a session's transport sends as a Bearer token. Opaque to a client, which reads nothing in it but its expiry. */
public typealias AccessToken = String

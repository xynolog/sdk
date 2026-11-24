// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public enum class GatewayMediaTokenHeaderTyp(
    /** The value as the wire spells it. */
    public val value: String,
) {
    JWT("JWT"),
}

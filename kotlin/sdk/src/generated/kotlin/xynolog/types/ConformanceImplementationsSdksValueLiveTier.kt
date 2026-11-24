// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does. */
@Serializable
public enum class ConformanceImplementationsSdksValueLiveTier(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("fleet")
    Fleet("fleet"),

    @SerialName("parity")
    Parity("parity"),
}

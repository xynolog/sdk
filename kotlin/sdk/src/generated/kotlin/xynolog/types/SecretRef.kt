// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A secret the document names and does not hold. The launcher hands it to the service that needs it, from where the reference says it is. */
@Serializable
public data class SecretRef(
    /** The environment variable that holds the secret where the launcher runs. Unset, the start that needs it is refused. */
    public val fromEnv: String,
) {
    /** How Java makes a `SecretRef`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val fromEnv: String,
    ) {
        public fun build(): SecretRef = SecretRef(fromEnv = fromEnv)
    }

    public companion object {
        /** A builder of a `SecretRef` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(fromEnv: String): Builder = Builder(fromEnv)
    }
}

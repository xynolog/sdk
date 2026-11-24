// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** launcher.about's params. */
@Serializable
public data class AboutParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
) {
    /** How Java makes a `AboutParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        public fun build(): AboutParams = AboutParams(apiVersion = apiVersion)
    }

    public companion object {
        /** A builder of a `AboutParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}

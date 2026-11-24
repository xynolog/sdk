// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** Live: the client's stream comes to name exactly these scopes. */
@Serializable
public data class ConformanceStepScopes(
    /** The scopes. */
    public val scopes: kotlin.collections.List<JsonElement>,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepScopes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val scopes: kotlin.collections.List<JsonElement>,
    ) {
        public fun build(): ConformanceStepScopes = ConformanceStepScopes(scopes = scopes)
    }

    public companion object {
        /** A builder of a `ConformanceStepScopes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(scopes: kotlin.collections.List<JsonElement>): Builder = Builder(scopes)
    }
}

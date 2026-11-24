// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The stream a wire step named has carried this frame to the client. */
@Serializable
public data class ConformanceStepCarried(
    /** The stream. */
    public val carried: String,
    public val `is`: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepCarried`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val carried: String,
        private val `is`: JsonElement,
    ) {
        public fun build(): ConformanceStepCarried = ConformanceStepCarried(carried = carried, `is` = `is`)
    }

    public companion object {
        /** A builder of a `ConformanceStepCarried` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(carried: String, `is`: JsonElement): Builder = Builder(carried, `is`)
    }
}

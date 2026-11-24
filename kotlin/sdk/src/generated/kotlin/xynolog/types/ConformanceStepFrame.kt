// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The next frame the client delivers on this channel is this one. */
@Serializable
public data class ConformanceStepFrame(
    /** The channel. */
    public val frame: String,
    public val `is`: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepFrame`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val frame: String,
        private val `is`: JsonElement,
    ) {
        public fun build(): ConformanceStepFrame = ConformanceStepFrame(frame = frame, `is` = `is`)
    }

    public companion object {
        /** A builder of a `ConformanceStepFrame` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(frame: String, `is`: JsonElement): Builder = Builder(frame, `is`)
    }
}

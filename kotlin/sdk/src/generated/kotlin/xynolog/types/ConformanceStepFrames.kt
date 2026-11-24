// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The client delivers this many more frames on this channel. What they are is held, as every frame is, to what the gateway sent. */
@Serializable
public data class ConformanceStepFrames(
    /** The channel. */
    public val frames: String,
    /** How many more. */
    public val count: Long,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepFrames`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val frames: String,
        private val count: Long,
    ) {
        public fun build(): ConformanceStepFrames = ConformanceStepFrames(frames = frames, count = count)
    }

    public companion object {
        /** A builder of a `ConformanceStepFrames` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(frames: String, count: Long): Builder = Builder(frames, count)
    }
}

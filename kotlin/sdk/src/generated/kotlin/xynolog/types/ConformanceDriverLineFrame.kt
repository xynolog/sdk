// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A frame was delivered on a channel the driver listens to. */
@Serializable
public data class ConformanceDriverLineFrame(
    /** The frame. */
    public val frame: ConformanceDriverLineFrameFrame,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineFrame`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val frame: ConformanceDriverLineFrameFrame,
    ) {
        public fun build(): ConformanceDriverLineFrame = ConformanceDriverLineFrame(frame = frame)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineFrame` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(frame: ConformanceDriverLineFrameFrame): Builder = Builder(frame)
    }
}

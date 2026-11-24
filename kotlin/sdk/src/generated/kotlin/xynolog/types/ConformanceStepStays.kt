// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The transport is in this state and has reported no other since the case last read its state. */
@Serializable
public data class ConformanceStepStays(
    /** The state. */
    public val stays: ConformanceStepStaysStays,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepStays`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val stays: ConformanceStepStaysStays,
    ) {
        public fun build(): ConformanceStepStays = ConformanceStepStays(stays = stays)
    }

    public companion object {
        /** A builder of a `ConformanceStepStays` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(stays: ConformanceStepStaysStays): Builder = Builder(stays)
    }
}

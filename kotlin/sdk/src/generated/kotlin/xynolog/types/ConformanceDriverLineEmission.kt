// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The live driver: an observer was given a state. */
@Serializable
public data class ConformanceDriverLineEmission(
    /** The emission. */
    public val emission: ConformanceDriverLineEmissionEmission,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineEmission`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val emission: ConformanceDriverLineEmissionEmission,
    ) {
        public fun build(): ConformanceDriverLineEmission = ConformanceDriverLineEmission(emission = emission)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineEmission` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(emission: ConformanceDriverLineEmissionEmission): Builder = Builder(emission)
    }
}

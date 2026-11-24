// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The emission. */
@Serializable
public data class ConformanceDriverLineEmissionEmission(
    /** The observer. */
    public val observer: String,
    /** The state. */
    public val state: ConformanceDriverLineEmissionEmissionState,
) {
    /** How Java makes a `ConformanceDriverLineEmissionEmission`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val observer: String,
        private val state: ConformanceDriverLineEmissionEmissionState,
    ) {
        public fun build(): ConformanceDriverLineEmissionEmission = ConformanceDriverLineEmissionEmission(observer = observer, state = state)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineEmissionEmission` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(observer: String, state: ConformanceDriverLineEmissionEmissionState): Builder = Builder(observer, state)
    }
}

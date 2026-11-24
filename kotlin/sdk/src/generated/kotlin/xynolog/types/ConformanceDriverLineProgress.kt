// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An upload reported how much of it has been sent. */
@Serializable
public data class ConformanceDriverLineProgress(
    /** The report. */
    public val progress: ConformanceDriverLineProgressProgress,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineProgress`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val progress: ConformanceDriverLineProgressProgress,
    ) {
        public fun build(): ConformanceDriverLineProgress = ConformanceDriverLineProgress(progress = progress)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineProgress` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(progress: ConformanceDriverLineProgressProgress): Builder = Builder(progress)
    }
}

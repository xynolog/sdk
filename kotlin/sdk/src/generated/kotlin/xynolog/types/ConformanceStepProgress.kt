// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An upload started with `as`, and not yet settled, has reported all of it sent: every report states the same total, none states less than the one before, and the last states the total. */
@Serializable
public data class ConformanceStepProgress(
    /** The upload. */
    public val progress: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepProgress`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val progress: String,
    ) {
        public fun build(): ConformanceStepProgress = ConformanceStepProgress(progress = progress)
    }

    public companion object {
        /** A builder of a `ConformanceStepProgress` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(progress: String): Builder = Builder(progress)
    }
}

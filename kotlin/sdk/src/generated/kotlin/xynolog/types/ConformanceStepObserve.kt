// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Live: an observer, named by `as`, begins observing a live query. */
@Serializable
public data class ConformanceStepObserve(
    /** The live query. */
    public val observe: ConformanceStepObserveObserve,
    /** The observer. */
    public val `as`: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepObserve`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val observe: ConformanceStepObserveObserve,
        private val `as`: String,
    ) {
        public fun build(): ConformanceStepObserve = ConformanceStepObserve(observe = observe, `as` = `as`)
    }

    public companion object {
        /** A builder of a `ConformanceStepObserve` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(observe: ConformanceStepObserveObserve, `as`: String): Builder = Builder(observe, `as`)
    }
}

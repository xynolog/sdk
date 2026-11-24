// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The transport's connection state changed. */
@Serializable
public data class ConformanceDriverLineState(
    /** The state it is in now: one a case's `state` step names (ConformanceStep.json), or another the case never waits for. */
    public val state: String,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineState`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val state: String,
    ) {
        public fun build(): ConformanceDriverLineState = ConformanceDriverLineState(state = state)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineState` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(state: String): Builder = Builder(state)
    }
}

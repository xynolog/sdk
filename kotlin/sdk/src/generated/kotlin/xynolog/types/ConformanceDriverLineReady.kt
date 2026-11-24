// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The driver can take operations. */
@Serializable
public data class ConformanceDriverLineReady(
    /** Written once. */
    public val ready: Boolean,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineReady`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val ready: Boolean,
    ) {
        public fun build(): ConformanceDriverLineReady = ConformanceDriverLineReady(ready = ready)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineReady` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(ready: Boolean): Builder = Builder(ready)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTestingDelayMs(
    /** What it is, in prose. */
    public val docs: String,
    /** The fewest milliseconds a drawn delay is. */
    public val minimum: Long,
    /** The most milliseconds a drawn delay is. */
    public val maximum: Long,
) {
    /** How Java makes a `ClientTestingDelayMs`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val minimum: Long,
        private val maximum: Long,
    ) {
        public fun build(): ClientTestingDelayMs = ClientTestingDelayMs(docs = docs, minimum = minimum, maximum = maximum)
    }

    public companion object {
        /** A builder of a `ClientTestingDelayMs` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, minimum: Long, maximum: Long): Builder = Builder(docs, minimum, maximum)
    }
}

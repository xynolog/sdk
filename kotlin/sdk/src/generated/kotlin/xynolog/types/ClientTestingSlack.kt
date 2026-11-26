// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTestingSlack(
    /** What it is, in prose. */
    public val docs: String,
    /** How many times its reckoned bound a case is given. */
    public val times: Long,
) {
    /** How Java makes a `ClientTestingSlack`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val times: Long,
    ) {
        public fun build(): ClientTestingSlack = ClientTestingSlack(docs = docs, times = times)
    }

    public companion object {
        /** A builder of a `ClientTestingSlack` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, times: Long): Builder = Builder(docs, times)
    }
}

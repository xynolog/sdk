// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTestingFaultActionsItem(
    /** The fault's type's name. */
    public val name: String,
    /** The word that names the fault in a request log. */
    public val kind: String,
    /** What it is, in prose. */
    public val docs: String,
    /** The whole numbers the fault carries, by name. */
    public val holds: kotlin.collections.List<String>,
) {
    /** How Java makes a `ClientTestingFaultActionsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val kind: String,
        private val docs: String,
        private val holds: kotlin.collections.List<String>,
    ) {
        public fun build(): ClientTestingFaultActionsItem = ClientTestingFaultActionsItem(name = name, kind = kind, docs = docs, holds = holds)
    }

    public companion object {
        /** A builder of a `ClientTestingFaultActionsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, kind: String, docs: String, holds: kotlin.collections.List<String>): Builder = Builder(name, kind, docs, holds)
    }
}

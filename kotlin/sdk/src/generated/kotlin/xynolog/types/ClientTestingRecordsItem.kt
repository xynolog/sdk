// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTestingRecordsItem(
    /** The record's type's name. */
    public val name: String,
    /** What it is, in prose. */
    public val docs: String,
    /** The record's members, named as surface.json names members. */
    public val members: kotlin.collections.List<String>,
) {
    /** How Java makes a `ClientTestingRecordsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val docs: String,
        private val members: kotlin.collections.List<String>,
    ) {
        public fun build(): ClientTestingRecordsItem = ClientTestingRecordsItem(name = name, docs = docs, members = members)
    }

    public companion object {
        /** A builder of a `ClientTestingRecordsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, docs: String, members: kotlin.collections.List<String>): Builder = Builder(name, docs, members)
    }
}

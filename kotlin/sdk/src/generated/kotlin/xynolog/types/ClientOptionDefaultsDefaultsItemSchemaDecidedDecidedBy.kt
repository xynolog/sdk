// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What decides it. */
@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy(
    /** A member beside the function, whose value is of an enum. */
    public val member: String,
) {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val member: String,
    ) {
        public fun build(): ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy = ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy(member = member)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(member: String): Builder = Builder(member)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaDecided(
    /** What a value decides: the schema a table names for it. */
    public val decided: ClientOptionDefaultsDefaultsItemSchemaDecidedDecided,
) : ClientOptionDefaultsDefaultsItemSchema {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaDecided`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val decided: ClientOptionDefaultsDefaultsItemSchemaDecidedDecided,
    ) {
        public fun build(): ClientOptionDefaultsDefaultsItemSchemaDecided = ClientOptionDefaultsDefaultsItemSchemaDecided(decided = decided)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaDecided` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(decided: ClientOptionDefaultsDefaultsItemSchemaDecidedDecided): Builder = Builder(decided)
    }
}

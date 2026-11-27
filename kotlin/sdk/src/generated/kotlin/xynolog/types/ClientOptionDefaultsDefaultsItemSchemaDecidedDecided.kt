// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** What a value decides: the schema a table names for it. */
@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaDecidedDecided(
    /** What decides it. */
    public val by: ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy,
    /** The table that names the schema: `takes`, the function's own, by each of the enum's values in its order. */
    @EncodeDefault
    public val `in`: ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedIn = ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedIn.Takes,
) {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaDecidedDecided`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val by: ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy,
    ) {
        public fun build(): ClientOptionDefaultsDefaultsItemSchemaDecidedDecided = ClientOptionDefaultsDefaultsItemSchemaDecidedDecided(by = by)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaDecidedDecided` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(by: ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedBy): Builder = Builder(by)
    }
}

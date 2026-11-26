// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaTypeParameter(
    /** A type parameter of the state unit the member is of, by its name: what it is, the unit's maker says. */
    public val typeParameter: String,
) : ClientOptionDefaultsDefaultsItemSchema {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaTypeParameter`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val typeParameter: String,
    ) {
        public fun build(): ClientOptionDefaultsDefaultsItemSchemaTypeParameter = ClientOptionDefaultsDefaultsItemSchemaTypeParameter(typeParameter = typeParameter)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaTypeParameter` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(typeParameter: String): Builder = Builder(typeParameter)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaReference(
    /** The $id of a component, a member within one, or a client type of specs/src/client/types: an object is always one of these, so that it is named. */
    @SerialName("\$ref")
    public val ref: String,
    /** What each of the client type's type parameters is here, by its name: a type parameter of the unit it is given in, one for each the client type's x-xynolog-typeParameters states, and only where it states any. */
    public val typeArguments: kotlin.collections.Map<String, ClientOptionDefaultsDefaultsItemSchemaReferenceTypeArgumentsValue>? = null,
) : ClientOptionDefaultsDefaultsItemSchema {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaReference`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val ref: String,
    ) {
        private var typeArguments: kotlin.collections.Map<String, ClientOptionDefaultsDefaultsItemSchemaReferenceTypeArgumentsValue>? = null

        public fun typeArguments(typeArguments: kotlin.collections.Map<String, ClientOptionDefaultsDefaultsItemSchemaReferenceTypeArgumentsValue>?): Builder = apply { this.typeArguments = typeArguments }

        public fun build(): ClientOptionDefaultsDefaultsItemSchemaReference = ClientOptionDefaultsDefaultsItemSchemaReference(ref = ref, typeArguments = typeArguments)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaReference` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(ref: String): Builder = Builder(ref)
    }
}

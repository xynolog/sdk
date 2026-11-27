// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What the parameter is. Left out where it is the SDK's own: its error, which no schema states. */
@Serializable(with = ClientOptionDefaultsDefaultsItemSchemaSerializer::class)
public sealed interface ClientOptionDefaultsDefaultsItemSchema

internal object ClientOptionDefaultsDefaultsItemSchemaSerializer : SignatureUnionSerializer<ClientOptionDefaultsDefaultsItemSchema>(
    ClientOptionDefaultsDefaultsItemSchema::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("\$ref"),
                allowed = listOf("\$ref", "typeArguments"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "description"),
                allowed = listOf("type", "minimum", "format", "description"),
                fixed = listOf("type" to listOf(Literal.Text("integer"), Literal.Text("string"), Literal.Text("boolean")), "format" to listOf(Literal.Text("date-time"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("typeParameter"),
                allowed = listOf("typeParameter"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("decided"),
                allowed = listOf("decided"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ClientOptionDefaultsDefaultsItemSchemaReference.serializer(),
            ClientOptionDefaultsDefaultsItemSchemaDateTime.serializer(),
            ClientOptionDefaultsDefaultsItemSchemaTypeParameter.serializer(),
            ClientOptionDefaultsDefaultsItemSchemaDecided.serializer(),
        )
    },
)

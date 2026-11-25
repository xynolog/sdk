// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One change to an annotation's bodies: a body added, a body removed, or one body replaced by another. */
@Serializable(with = BodyOperationSerializer::class)
public sealed interface BodyOperation

internal object BodyOperationSerializer : SignatureUnionSerializer<BodyOperation>(
    BodyOperation::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("op", "item"),
                allowed = null,
                fixed = listOf("op" to listOf(Literal.Text("add"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("op", "item"),
                allowed = null,
                fixed = listOf("op" to listOf(Literal.Text("remove"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("op", "oldItem", "newItem"),
                allowed = null,
                fixed = listOf("op" to listOf(Literal.Text("replace"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            BodyOperationAdd.serializer(),
            BodyOperationRemove.serializer(),
            BodyOperationReplace.serializer(),
        )
    },
)

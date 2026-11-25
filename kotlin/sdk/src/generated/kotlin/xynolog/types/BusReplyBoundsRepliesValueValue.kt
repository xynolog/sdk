// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = BusReplyBoundsRepliesValueValueSerializer::class)
public sealed interface BusReplyBoundsRepliesValueValue

internal object BusReplyBoundsRepliesValueValueSerializer : SignatureUnionSerializer<BusReplyBoundsRepliesValueValue>(
    BusReplyBoundsRepliesValueValue::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("by"),
                allowed = listOf("by"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("grows"),
                allowed = listOf("grows"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            BusReplyBoundsRepliesValueValueBy.serializer(),
            BusReplyBoundsRepliesValueValueGrows.serializer(),
        )
    },
)

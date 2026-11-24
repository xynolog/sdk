// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = BusReplyBoundsRepliesValueValueSerializer::class)
public sealed interface BusReplyBoundsRepliesValueValue

internal object BusReplyBoundsRepliesValueValueSerializer : KindsUnionSerializer<BusReplyBoundsRepliesValueValue>(
    BusReplyBoundsRepliesValueValue::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(BusReplyBoundsRepliesValueValueBy.serializer(), BusReplyBoundsRepliesValueValueGrows.serializer()) },
)

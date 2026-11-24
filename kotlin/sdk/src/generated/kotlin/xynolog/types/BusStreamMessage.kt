// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Every message the bus stream carries. A client ignores an `event` it does not know; the gateway writes no other. */
@Serializable(with = BusStreamMessageSerializer::class)
public sealed interface BusStreamMessage

internal object BusStreamMessageSerializer : KindsUnionSerializer<BusStreamMessage>(
    BusStreamMessage::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(BusEventMessage.serializer(), BusPingMessage.serializer()) },
)

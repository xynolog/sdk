// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Every message the bus stream carries. A client ignores an `event` it does not know; the gateway writes no other. */
@Serializable(with = BusStreamMessageSerializer::class)
public sealed interface BusStreamMessage

internal object BusStreamMessageSerializer : SignatureUnionSerializer<BusStreamMessage>(
    BusStreamMessage::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("event", "id", "data"),
                allowed = listOf("event", "id", "data"),
                fixed = listOf("event" to listOf(Literal.Text("bus-event"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("event", "data"),
                allowed = listOf("event", "data"),
                fixed = listOf("event" to listOf(Literal.Text("ping"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            BusEventMessage.serializer(),
            BusPingMessage.serializer(),
        )
    },
)

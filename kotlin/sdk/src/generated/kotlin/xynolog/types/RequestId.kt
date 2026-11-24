// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The request a notification is about: the JSON-RPC id its client gave it, as the client gave it. */
@Serializable(with = RequestIdSerializer::class)
public sealed interface RequestId {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : RequestId {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `Long`, as the value itself. */
    @Serializable(with = Integer.Serializer::class)
    public data class Integer(public val value: Long) : RequestId {
        internal object Serializer : WrapperSerializer<Integer, Long>(Integer::class, kotlinx.serialization.serializer(), { Integer(it) }, Integer::value)
    }
}

internal object RequestIdSerializer : KindsUnionSerializer<RequestId>(
    RequestId::class,
    strings = { listOf(RequestId.Text.serializer()) },
    scalars = { listOf(RequestId.Integer.serializer()) },
    arrays = { emptyList() },
    objects = { emptyList() },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ClientTimingTimingItemValueSerializer::class)
public sealed interface ClientTimingTimingItemValue {
    /** A member that is a `Long`, as the value itself. */
    @Serializable(with = Integer.Serializer::class)
    public data class Integer(public val value: Long) : ClientTimingTimingItemValue {
        internal object Serializer : WrapperSerializer<Integer, Long>(Integer::class, kotlinx.serialization.serializer(), { Integer(it) }, Integer::value)
    }
}

internal object ClientTimingTimingItemValueSerializer : SignatureUnionSerializer<ClientTimingTimingItemValue>(
    ClientTimingTimingItemValue::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.INTEGER,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("attempts", "initialDelayMs", "maxDelayMs"),
                allowed = listOf("attempts", "initialDelayMs", "maxDelayMs"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ClientTimingTimingItemValue.Integer.serializer(),
            RetryBudget.serializer(),
        )
    },
)

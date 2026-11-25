// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemSerializer::class)
public sealed interface ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `Boolean`, as the value itself. */
    @Serializable(with = Boolean.Serializer::class)
    public data class Boolean(public val value: kotlin.Boolean) : ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem {
        internal object Serializer : WrapperSerializer<Boolean, kotlin.Boolean>(Boolean::class, kotlinx.serialization.serializer(), { Boolean(it) }, Boolean::value)
    }
}

internal object ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItemSerializer : SignatureUnionSerializer<ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem>(
    ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.TEXT,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.BOOLEAN,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem.Text.serializer(),
            ServiceTelemetryTelemetryMetricsItemAttributesItemValuesItem.Boolean.serializer(),
        )
    },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemSerializer::class)
public sealed interface SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `Boolean`, as the value itself. */
    @Serializable(with = Boolean.Serializer::class)
    public data class Boolean(public val value: kotlin.Boolean) : SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem {
        internal object Serializer : WrapperSerializer<Boolean, kotlin.Boolean>(Boolean::class, kotlinx.serialization.serializer(), { Boolean(it) }, Boolean::value)
    }
}

internal object SdkTelemetryTelemetryMetricsItemAttributesItemValuesItemSerializer : SignatureUnionSerializer<SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem>(
    SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem::class,
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
            SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem.Text.serializer(),
            SdkTelemetryTelemetryMetricsItemAttributesItemValuesItem.Boolean.serializer(),
        )
    },
)

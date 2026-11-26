// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An attribute a row carries. */
@Serializable
public data class SdkTelemetryTelemetrySpansItemAttributesItem(
    /** The attribute's key. */
    public val key: String,
    /** When alone the attribute is carried: a row's attribute without it is carried every time. */
    public val only: String? = null,
    /** The only values it carries, each of the type it is carried as: a string or a boolean. */
    public val values: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItemValuesItem>? = null,
) {
    /** How Java makes a `SdkTelemetryTelemetrySpansItemAttributesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val key: String,
    ) {
        private var only: String? = null
        private var values: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItemValuesItem>? = null

        public fun only(only: String?): Builder = apply { this.only = only }
        public fun values(values: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItemValuesItem>?): Builder = apply { this.values = values }

        public fun build(): SdkTelemetryTelemetrySpansItemAttributesItem = SdkTelemetryTelemetrySpansItemAttributesItem(key = key, only = only, values = values)
    }

    public companion object {
        /** A builder of a `SdkTelemetryTelemetrySpansItemAttributesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(key: String): Builder = Builder(key)
    }
}

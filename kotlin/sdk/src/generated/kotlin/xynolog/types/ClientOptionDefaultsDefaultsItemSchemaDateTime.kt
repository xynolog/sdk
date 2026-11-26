// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientOptionDefaultsDefaultsItemSchemaDateTime(
    /** The value's type, where no component states one. */
    public val type: ClientOptionDefaultsDefaultsItemSchemaDateTimeType,
    /** The least an integer may be. */
    public val minimum: Long? = null,
    /** The string's format, where it has one: `date-time` is an RFC 3339 time. */
    public val format: ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat? = null,
    /** What the value is. */
    public val description: String,
) : ClientOptionDefaultsDefaultsItemSchema {
    /** How Java makes a `ClientOptionDefaultsDefaultsItemSchemaDateTime`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: ClientOptionDefaultsDefaultsItemSchemaDateTimeType,
        private val description: String,
    ) {
        private var minimum: Long? = null
        private var format: ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat? = null

        public fun minimum(minimum: Long?): Builder = apply { this.minimum = minimum }
        public fun format(format: ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat?): Builder = apply { this.format = format }

        public fun build(): ClientOptionDefaultsDefaultsItemSchemaDateTime = ClientOptionDefaultsDefaultsItemSchemaDateTime(type = type, minimum = minimum, format = format, description = description)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItemSchemaDateTime` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: ClientOptionDefaultsDefaultsItemSchemaDateTimeType, description: String): Builder = Builder(type, description)
    }
}

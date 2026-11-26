// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The value's type, where no component states one. */
@Serializable
public enum class ClientOptionDefaultsDefaultsItemSchemaDateTimeType(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("integer")
    Integer("integer"),

    @SerialName("string")
    String("string"),

    @SerialName("boolean")
    Boolean("boolean"),
}

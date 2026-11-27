// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The table that names the schema: `takes`, the function's own, by each of the enum's values in its order. */
@Serializable
public enum class ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedIn(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("takes")
    Takes("takes"),
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What one is kept per; absent, the knowledge base has one. */
@Serializable
public enum class ClientRefreshQueriesItemReadsPer(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("resource")
    Resource("resource"),

    @SerialName("annotation")
    Annotation("annotation"),

    @SerialName("filters")
    Filters("filters"),
}

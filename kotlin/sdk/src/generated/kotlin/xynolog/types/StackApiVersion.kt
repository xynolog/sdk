// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The group and version of Xynolog's kinds. The group names who defines a kind, under the domain the knowledge bases' DIDs use; which knowledge base a document is about is said inside it. */
@Serializable
public enum class StackApiVersion(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("xynolog.org/v1alpha1")
    XynologOrgV1alpha1("xynolog.org/v1alpha1"),
}

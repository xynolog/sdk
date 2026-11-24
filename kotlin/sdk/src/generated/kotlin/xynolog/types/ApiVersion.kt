// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The group and version of the control API. Every request's params state it; a launcher refuses a version it does not speak with control.unsupported-api-version, and names the ones it does. */
@Serializable
public enum class ApiVersion(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("control.xynolog.org/v1alpha1")
    ControlXynologOrgV1alpha1("control.xynolog.org/v1alpha1"),
}

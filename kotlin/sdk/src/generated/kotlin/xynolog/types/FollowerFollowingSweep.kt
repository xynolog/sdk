// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The latest sweep's phase: `pending` before its stream first opens, `running`, `done`, or `due` where the record could not be listed and the sweep is tried again. */
@Serializable
public enum class FollowerFollowingSweep(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("pending")
    Pending("pending"),

    @SerialName("running")
    Running("running"),

    @SerialName("done")
    Done("done"),

    @SerialName("due")
    Due("due"),
}

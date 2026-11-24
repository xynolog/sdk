// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What the line is: narration (log, note), an outcome (ok, warn, fail), a heading (banner, section), a timestamp (stamp), a runtime command about to run (command), or text the operation printed (output). */
@Serializable
public enum class ProgressKind(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("log")
    Log("log"),

    @SerialName("note")
    Note("note"),

    @SerialName("ok")
    Ok("ok"),

    @SerialName("warn")
    Warn("warn"),

    @SerialName("fail")
    Fail("fail"),

    @SerialName("banner")
    Banner("banner"),

    @SerialName("section")
    Section("section"),

    @SerialName("stamp")
    Stamp("stamp"),

    @SerialName("command")
    Command("command"),

    @SerialName("output")
    Output("output"),
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The first fault a value has as its schema allows: where it is, and why (contract/TRANSPORT-CONTRACT.md § Identity). What a refusal of a frame, a payload or an answer names. */
@Serializable
public data class Fault(
    /** The way from the value to its first fault: the names of the members it is within, and its own, joined by dots; empty for the value itself. */
    public val member: String,
    /** Why it is at fault. */
    public val reason: FrameRefusalReason,
) {
    /** How Java makes a `Fault`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val member: String,
        private val reason: FrameRefusalReason,
    ) {
        public fun build(): Fault = Fault(member = member, reason = reason)
    }

    public companion object {
        /** A builder of a `Fault` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(member: String, reason: FrameRefusalReason): Builder = Builder(member, reason)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A session ended, and why. What the session's signals raise (client/surface.json's `sessionSignals`). */
@Serializable
public data class SessionEnded(
    /** Why it ended. */
    public val reason: SessionEndReason,
) {
    /** How Java makes a `SessionEnded`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reason: SessionEndReason,
    ) {
        public fun build(): SessionEnded = SessionEnded(reason = reason)
    }

    public companion object {
        /** A builder of a `SessionEnded` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reason: SessionEndReason): Builder = Builder(reason)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One line of what an operation is doing, as the command line would tell a person, without colour. A secret value the launcher generated or read never appears in one. */
@Serializable
public data class Progress(
    public val requestId: RequestId,
    /** What the line is: narration (log, note), an outcome (ok, warn, fail), a heading (banner, section), a timestamp (stamp), a runtime command about to run (command), or text the operation printed (output). */
    public val kind: ProgressKind,
    /** The line. */
    public val text: String,
) {
    /** How Java makes a `Progress`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
        private val kind: ProgressKind,
        private val text: String,
    ) {
        public fun build(): Progress = Progress(requestId = requestId, kind = kind, text = text)
    }

    public companion object {
        /** A builder of a `Progress` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId, kind: ProgressKind, text: String): Builder = Builder(requestId, kind, text)
    }
}

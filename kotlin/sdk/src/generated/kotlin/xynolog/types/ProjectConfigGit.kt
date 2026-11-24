// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How the knowledge base's changes reach git. */
@Serializable
public data class ProjectConfigGit(
    /** Whether changes to the working tree and the event log are staged in git as they are made. */
    public val sync: Boolean,
) {
    /** How Java makes a `ProjectConfigGit`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val sync: Boolean,
    ) {
        public fun build(): ProjectConfigGit = ProjectConfigGit(sync = sync)
    }

    public companion object {
        /** A builder of a `ProjectConfigGit` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(sync: Boolean): Builder = Builder(sync)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Which knowledge base an operation acts on: a local clone's stack, or a codespace's. The launcher resolves it as the command line resolves --root and --repo, and refuses a choice it would have to guess. */
@Serializable
public data class Target(
    /** Where the stack runs: on this machine (local), or on a GitHub codespace whose knowledge base is forwarded here (codespace). */
    public val kind: TargetKind,
    /** For a local target: the knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the local stack the command line chooses with --runtime, standing where the control server was started. */
    public val root: String? = null,
    /** For a codespace target: the GitHub repository, as --repo takes it. */
    public val repo: String? = null,
) {
    /** How Java makes a `Target`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val kind: TargetKind,
    ) {
        private var root: String? = null
        private var repo: String? = null

        public fun root(root: String?): Builder = apply { this.root = root }
        public fun repo(repo: String?): Builder = apply { this.repo = repo }

        public fun build(): Target = Target(kind = kind, root = root, repo = repo)
    }

    public companion object {
        /** A builder of a `Target` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(kind: TargetKind): Builder = Builder(kind)
    }
}

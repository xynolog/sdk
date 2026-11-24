// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The knowledge base's name. */
@Serializable
public data class ProjectConfigProject(
    /** The knowledge base's name, which decides where its state is kept. */
    public val name: String,
    /** A version the knowledge base's author gives it. Nothing changes it. */
    public val version: String? = null,
) {
    /** How Java makes a `ProjectConfigProject`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
    ) {
        private var version: String? = null

        public fun version(version: String?): Builder = apply { this.version = version }

        public fun build(): ProjectConfigProject = ProjectConfigProject(name = name, version = version)
    }

    public companion object {
        /** A builder of a `ProjectConfigProject` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String): Builder = Builder(name)
    }
}

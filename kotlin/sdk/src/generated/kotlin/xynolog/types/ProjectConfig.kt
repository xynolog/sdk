// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A knowledge base's committed `.xynolog/config.yaml`: its name, whether its changes are staged in git, and its permanent identity. A deployment's documents never restate any of it. */
@Serializable
public data class ProjectConfig(
    /** The knowledge base's name. */
    public val project: ProjectConfigProject,
    /** How the knowledge base's changes reach git. */
    public val git: ProjectConfigGit,
    /** The knowledge base's identity. */
    public val site: ProjectConfigSite,
) {
    /** How Java makes a `ProjectConfig`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val project: ProjectConfigProject,
        private val git: ProjectConfigGit,
        private val site: ProjectConfigSite,
    ) {
        public fun build(): ProjectConfig = ProjectConfig(project = project, git = git, site = site)
    }

    public companion object {
        /** A builder of a `ProjectConfig` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(project: ProjectConfigProject, git: ProjectConfigGit, site: ProjectConfigSite): Builder = Builder(project, git, site)
    }
}

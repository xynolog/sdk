// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What the launcher is. A client asks this first, to learn whether it speaks to the launcher it found. */
@Serializable
public data class AboutResult(
    /** The version stamped into the launcher at build. Absent from a development build, which states none. */
    public val version: String? = null,
    /** Whether this is a development build: one with no version stamped. */
    public val development: Boolean,
    /** The commit it was built from, when stamped. */
    public val commit: String? = null,
    /** When it was built, when stamped. */
    public val built: String? = null,
    /** Each version of the control API it speaks. A client that speaks none of them stops here. */
    public val apiVersions: kotlin.collections.List<String>,
    /** The registry its catalog's images come from. */
    public val imageRegistry: String,
    /** Each container runtime it drives, in the order it prefers them, and whether this machine has it. */
    public val runtimes: kotlin.collections.List<RuntimeState>,
) {
    /** How Java makes a `AboutResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val development: Boolean,
        private val apiVersions: kotlin.collections.List<String>,
        private val imageRegistry: String,
        private val runtimes: kotlin.collections.List<RuntimeState>,
    ) {
        private var version: String? = null
        private var commit: String? = null
        private var built: String? = null

        public fun version(version: String?): Builder = apply { this.version = version }
        public fun commit(commit: String?): Builder = apply { this.commit = commit }
        public fun built(built: String?): Builder = apply { this.built = built }

        public fun build(): AboutResult = AboutResult(version = version, development = development, commit = commit, built = built, apiVersions = apiVersions, imageRegistry = imageRegistry, runtimes = runtimes)
    }

    public companion object {
        /** A builder of a `AboutResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(development: Boolean, apiVersions: kotlin.collections.List<String>, imageRegistry: String, runtimes: kotlin.collections.List<RuntimeState>): Builder = Builder(development, apiVersions, imageRegistry, runtimes)
    }
}

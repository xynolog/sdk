// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The most a container may use. */
@Serializable
public data class ResourcesLimits(
    /** The memory ceiling: a whole number of gigabytes or megabytes, `8G` or `512M`. */
    public val memory: String,
) {
    /** How Java makes a `ResourcesLimits`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val memory: String,
    ) {
        public fun build(): ResourcesLimits = ResourcesLimits(memory = memory)
    }

    public companion object {
        /** A builder of a `ResourcesLimits` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(memory: String): Builder = Builder(memory)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a container is given, in Kubernetes' spelling. */
@Serializable
public data class Resources(
    /** The most a container may use. */
    public val limits: ResourcesLimits,
) {
    /** How Java makes a `Resources`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val limits: ResourcesLimits,
    ) {
        public fun build(): Resources = Resources(limits = limits)
    }

    public companion object {
        /** A builder of a `Resources` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(limits: ResourcesLimits): Builder = Builder(limits)
    }
}

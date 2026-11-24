// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One container runtime the launcher drives, and whether this machine has it. */
@Serializable
public data class RuntimeState(
    public val name: Runtime,
    /** Whether it is on the launcher's PATH. */
    public val found: Boolean,
) {
    /** How Java makes a `RuntimeState`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: Runtime,
        private val found: Boolean,
    ) {
        public fun build(): RuntimeState = RuntimeState(name = name, found = found)
    }

    public companion object {
        /** A builder of a `RuntimeState` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: Runtime, found: Boolean): Builder = Builder(name, found)
    }
}

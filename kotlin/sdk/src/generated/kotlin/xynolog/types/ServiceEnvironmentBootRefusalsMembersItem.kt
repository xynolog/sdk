// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ServiceEnvironmentBootRefusalsMembersItem(
    /** The situation's name. */
    public val name: String,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The line, filled as the row's `situation` says. */
    public val line: String,
) {
    /** How Java makes a `ServiceEnvironmentBootRefusalsMembersItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val situation: String,
        private val line: String,
    ) {
        public fun build(): ServiceEnvironmentBootRefusalsMembersItem = ServiceEnvironmentBootRefusalsMembersItem(name = name, situation = situation, line = line)
    }

    public companion object {
        /** A builder of a `ServiceEnvironmentBootRefusalsMembersItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, situation: String, line: String): Builder = Builder(name, situation, line)
    }
}

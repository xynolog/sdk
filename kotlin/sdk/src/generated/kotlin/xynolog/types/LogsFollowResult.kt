// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A follow whose every source ended on its own. A follow the client cancels is answered with control.cancelled. */
@Serializable
public data class LogsFollowResult(
    /** The services that were followed. */
    public val services: kotlin.collections.List<String>,
) {
    /** How Java makes a `LogsFollowResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val services: kotlin.collections.List<String>,
    ) {
        public fun build(): LogsFollowResult = LogsFollowResult(services = services)
    }

    public companion object {
        /** A builder of a `LogsFollowResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(services: kotlin.collections.List<String>): Builder = Builder(services)
    }
}

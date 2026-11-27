// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How its live driver is started, and the tier of the live corpus the SDK is held to. */
@Serializable
public data class ConformanceImplementationsSdksValueLive(
    /** How its live driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written. */
    public val command: kotlin.collections.List<String>,
    /** A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does. */
    public val tier: ConformanceCaseTier,
) {
    /** How Java makes a `ConformanceImplementationsSdksValueLive`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val command: kotlin.collections.List<String>,
        private val tier: ConformanceCaseTier,
    ) {
        public fun build(): ConformanceImplementationsSdksValueLive = ConformanceImplementationsSdksValueLive(command = command, tier = tier)
    }

    public companion object {
        /** A builder of a `ConformanceImplementationsSdksValueLive` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(command: kotlin.collections.List<String>, tier: ConformanceCaseTier): Builder = Builder(command, tier)
    }
}

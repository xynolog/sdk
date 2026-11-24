// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One SDK's drivers. */
@Serializable
public data class ConformanceImplementationsSdksValue(
    /** How its wire driver is started. A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written. */
    public val wire: kotlin.collections.List<String>? = null,
    /** How its live driver is started, and the tier of the live corpus the SDK is held to. */
    public val live: ConformanceImplementationsSdksValueLive? = null,
    /** How its worker driver is started, when the SDK has a worker's surface (conformance/worker/README.md). A command and its arguments, as the harness starts it. An argument that starts with ./ or ../ is a path, resolved against the manifest's own directory; every other is passed as written. */
    public val worker: kotlin.collections.List<String>? = null,
    /** The wire cases its driver cannot be put through, by the case's name, each with why. The suite holds an exemption as it holds a case: the driver must answer unsupported to what the case asks, or the exemption is stale. */
    public val exempt: kotlin.collections.Map<String, String>? = null,
) {
    /** How Java makes a `ConformanceImplementationsSdksValue`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var wire: kotlin.collections.List<String>? = null
        private var live: ConformanceImplementationsSdksValueLive? = null
        private var worker: kotlin.collections.List<String>? = null
        private var exempt: kotlin.collections.Map<String, String>? = null

        public fun wire(wire: kotlin.collections.List<String>?): Builder = apply { this.wire = wire }
        public fun live(live: ConformanceImplementationsSdksValueLive?): Builder = apply { this.live = live }
        public fun worker(worker: kotlin.collections.List<String>?): Builder = apply { this.worker = worker }
        public fun exempt(exempt: kotlin.collections.Map<String, String>?): Builder = apply { this.exempt = exempt }

        public fun build(): ConformanceImplementationsSdksValue = ConformanceImplementationsSdksValue(wire = wire, live = live, worker = worker, exempt = exempt)
    }

    public companion object {
        /** A builder of a `ConformanceImplementationsSdksValue` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}

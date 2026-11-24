// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One case of the conformance corpus: a scenario every SDK's driver is put through, a JSON file of conformance/sdk/wire, conformance/sdk/live or conformance/worker/cases named by the case. What the client is asked to do, what the backend does around it, and the transcript a conforming client produces. conformance/sdk/README.md explains each step; the reader reads every file of the corpus through this schema. */
@Serializable
public data class ConformanceCase(
    /** What the case holds a client to, in a sentence. */
    public val about: String,
    /** Where the protocol or the spec states it. */
    public val source: String,
    /** The signal planes the case runs on. Absent, it runs on both. */
    public val planes: kotlin.collections.List<ConformanceCasePlanesItem>? = null,
    /** A live case's tier: `fleet`, what every SDK with a live layer does, or `parity`, what one that implements all of CACHE-SEMANTICS does. */
    public val tier: ConformanceCaseTier? = null,
    /** Run the client exporting to an OTLP receiver, and once it has exited hold what it exported to specs/src/sdk-telemetry/telemetry.json. A worker case also holds the worker to a trace of its own for each job it ran (conformance/worker/README.md). */
    public val telemetry: Boolean? = null,
    /** The steps, run in order. */
    public val steps: kotlin.collections.List<ConformanceStep>,
) {
    /** How Java makes a `ConformanceCase`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val about: String,
        private val source: String,
        private val steps: kotlin.collections.List<ConformanceStep>,
    ) {
        private var planes: kotlin.collections.List<ConformanceCasePlanesItem>? = null
        private var tier: ConformanceCaseTier? = null
        private var telemetry: Boolean? = null

        public fun planes(planes: kotlin.collections.List<ConformanceCasePlanesItem>?): Builder = apply { this.planes = planes }
        public fun tier(tier: ConformanceCaseTier?): Builder = apply { this.tier = tier }
        public fun telemetry(telemetry: Boolean?): Builder = apply { this.telemetry = telemetry }

        public fun build(): ConformanceCase = ConformanceCase(about = about, source = source, planes = planes, tier = tier, telemetry = telemetry, steps = steps)
    }

    public companion object {
        /** A builder of a `ConformanceCase` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(about: String, source: String, steps: kotlin.collections.List<ConformanceStep>): Builder = Builder(about, source, steps)
    }
}

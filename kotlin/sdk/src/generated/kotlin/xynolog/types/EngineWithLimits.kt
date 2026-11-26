// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One of the knowledge base's engines as a client joins it: the entry `browse:engines-result` names, with the inference limits the service holding its credentials reported. A client asks each such service for its limits; an engine no service reported has no `limits`. */
@Serializable
public data class EngineWithLimits(
    public val engine: Engine,
    /** The jobs the knowledge base's Inference document has this engine used for, as a claim names them. Absent for an engine only Librarian actors ask. */
    public val jobs: kotlin.collections.List<JobFilter>? = null,
    public val limits: InferenceLimits? = null,
) {
    /** How Java makes a `EngineWithLimits`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val engine: Engine,
    ) {
        private var jobs: kotlin.collections.List<JobFilter>? = null
        private var limits: InferenceLimits? = null

        public fun jobs(jobs: kotlin.collections.List<JobFilter>?): Builder = apply { this.jobs = jobs }
        public fun limits(limits: InferenceLimits?): Builder = apply { this.limits = limits }

        public fun build(): EngineWithLimits = EngineWithLimits(engine = engine, jobs = jobs, limits = limits)
    }

    public companion object {
        /** A builder of a `EngineWithLimits` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(engine: Engine): Builder = Builder(engine)
    }
}

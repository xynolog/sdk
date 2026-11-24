// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The KV bucket that keeps one record per job, keyed by the job's id. */
@Serializable
public data class JobsStorageBucket(
    public val name: String,
    /** The component schema each of the bucket's values is. */
    public val record: String,
) {
    /** How Java makes a `JobsStorageBucket`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val record: String,
    ) {
        public fun build(): JobsStorageBucket = JobsStorageBucket(name = name, record = record)
    }

    public companion object {
        /** A builder of a `JobsStorageBucket` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, record: String): Builder = Builder(name, record)
    }
}

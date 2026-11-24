// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The durable consumer that delivers each job to the dispatcher holding its lease. */
@Serializable
public data class JobsStorageConsumer(
    public val durableName: String,
) {
    /** How Java makes a `JobsStorageConsumer`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val durableName: String,
    ) {
        public fun build(): JobsStorageConsumer = JobsStorageConsumer(durableName = durableName)
    }

    public companion object {
        /** A builder of a `JobsStorageConsumer` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(durableName: String): Builder = Builder(durableName)
    }
}

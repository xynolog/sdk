// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** notifications/serviceOutput: one line a run's instance wrote, from its start, every line, in the order of its stream, as the instance wrote it. The launcher gives an instance none of its own secrets (R2), and keeps no copy. */
@Serializable
public data class ServiceOutput(
    public val requestId: RequestId,
    public val instance: RunInstance,
    public val stream: OutputStream,
    /** The line, without its newline. */
    public val line: String,
) {
    /** How Java makes a `ServiceOutput`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
        private val instance: RunInstance,
        private val stream: OutputStream,
        private val line: String,
    ) {
        public fun build(): ServiceOutput = ServiceOutput(requestId = requestId, instance = instance, stream = stream, line = line)
    }

    public companion object {
        /** A builder of a `ServiceOutput` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId, instance: RunInstance, stream: OutputStream, line: String): Builder = Builder(requestId, instance, stream, line)
    }
}

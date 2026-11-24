// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One line one of a stack's services wrote. The launcher removes from it each secret value the launcher generated or read; anything else the service wrote is the client's to handle. The launcher keeps no copy. */
@Serializable
public data class LogRecord(
    public val requestId: RequestId,
    /** The role whose container wrote the line, as xynolog status names it. */
    public val service: String,
    /** Which of the container's streams the line was on. */
    public val stream: OutputStream,
    /** The line, without its newline. */
    public val line: String,
    /** When the launcher read the line, in RFC 3339 with its fraction: a container's own lines carry the time it wrote them, if any. */
    public val receivedAt: String,
) {
    /** How Java makes a `LogRecord`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
        private val service: String,
        private val stream: OutputStream,
        private val line: String,
        private val receivedAt: String,
    ) {
        public fun build(): LogRecord = LogRecord(requestId = requestId, service = service, stream = stream, line = line, receivedAt = receivedAt)
    }

    public companion object {
        /** A builder of a `LogRecord` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId, service: String, stream: OutputStream, line: String, receivedAt: String): Builder = Builder(requestId, service, stream, line, receivedAt)
    }
}

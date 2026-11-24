// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The report. */
@Serializable
public data class ConformanceDriverLineProgressProgress(
    /** The `upload` operation's id. */
    public val upload: Long,
    /** How many bytes it has sent. */
    public val bytesUploaded: Long,
    /** How many it will send. */
    public val totalBytes: Long,
) {
    /** How Java makes a `ConformanceDriverLineProgressProgress`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val upload: Long,
        private val bytesUploaded: Long,
        private val totalBytes: Long,
    ) {
        public fun build(): ConformanceDriverLineProgressProgress = ConformanceDriverLineProgressProgress(upload = upload, bytesUploaded = bytesUploaded, totalBytes = totalBytes)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineProgressProgress` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(upload: Long, bytesUploaded: Long, totalBytes: Long): Builder = Builder(upload, bytesUploaded, totalBytes)
    }
}

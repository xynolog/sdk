// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** Bytes were sent. */
@Serializable
public data class UploadProgressProgress(
    @EncodeDefault
    public val phase: UploadProgressProgressPhase = UploadProgressProgressPhase.Progress,
    /** How many bytes are sent so far. */
    public val bytesUploaded: Long,
    /** How many bytes the upload is: its ByteSource's length. Absent when the source states none. */
    public val totalBytes: Long? = null,
) : UploadProgress {
    /** How Java makes a `UploadProgressProgress`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val bytesUploaded: Long,
    ) {
        private var totalBytes: Long? = null

        public fun totalBytes(totalBytes: Long?): Builder = apply { this.totalBytes = totalBytes }

        public fun build(): UploadProgressProgress = UploadProgressProgress(bytesUploaded = bytesUploaded, totalBytes = totalBytes)
    }

    public companion object {
        /** A builder of a `UploadProgressProgress` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(bytesUploaded: Long): Builder = Builder(bytesUploaded)
    }
}

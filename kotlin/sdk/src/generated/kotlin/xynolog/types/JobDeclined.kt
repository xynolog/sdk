// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** Result of a job that completed without doing its work because the resource could not be read. Distinct from a failure: nothing went wrong, there was simply no text to work with — an encrypted or damaged PDF, a scan whose text could not be recognized, or a document that yielded nothing. The reasons are the extraction vocabulary the Smelter reports on `smelt:settled`, MINUS `no-extractor`: a media type that can never yield text (a zip, an image) is a bad request rather than a decline, so a worker asked to detect over one throws and the job reports `job:fail`. Everything here is a resource-specific outcome — the same media type would have succeeded on a different document. */
@Serializable
public data class JobDeclined(
    /** Always true. It is what tells a decline from the result of a job that did its work, which never carries it. */
    @EncodeDefault
    public val declined: JobDeclinedDeclined = JobDeclinedDeclined,
    /** Why the resource could not be read. A CODE, not a sentence: the client owns the wording, so a browser renders it in the user's language and the CLI renders English terminal copy from the same value. A prose `message` composed server-side would be English everywhere. */
    public val reason: JobDeclinedReason,
) : JobResult,
    MarkJobResult,
    YieldJobResult {
    /** How Java makes a `JobDeclined`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reason: JobDeclinedReason,
    ) {
        public fun build(): JobDeclined = JobDeclined(reason = reason)
    }

    public companion object {
        /** A builder of a `JobDeclined` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reason: JobDeclinedReason): Builder = Builder(reason)
    }
}

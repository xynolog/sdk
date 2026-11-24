// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** worker/answer-formats.json: the element of the array each kind of detection asks a model for. */
@Serializable
public data class WorkerAnswerFormats(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val formats: kotlin.collections.List<WorkerAnswerFormatsFormatsItem>,
) {
    /** How Java makes a `WorkerAnswerFormats`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val formats: kotlin.collections.List<WorkerAnswerFormatsFormatsItem>,
    ) {
        public fun build(): WorkerAnswerFormats = WorkerAnswerFormats(comment = comment, formats = formats)
    }

    public companion object {
        /** A builder of a `WorkerAnswerFormats` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, formats: kotlin.collections.List<WorkerAnswerFormatsFormatsItem>): Builder = Builder(comment, formats)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
public data class WorkerAnswerFormatsFormatsItem(
    /** A motivation a `mark` job takes, or `count`. */
    public val name: String,
    /** What an element is, in prose. */
    public val about: String,
    /** The JSON Schema of one element of the answer. */
    public val element: JsonElement,
) {
    /** How Java makes a `WorkerAnswerFormatsFormatsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val about: String,
        private val element: JsonElement,
    ) {
        public fun build(): WorkerAnswerFormatsFormatsItem = WorkerAnswerFormatsFormatsItem(name = name, about = about, element = element)
    }

    public companion object {
        /** A builder of a `WorkerAnswerFormatsFormatsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, about: String, element: JsonElement): Builder = Builder(name, about, element)
    }
}

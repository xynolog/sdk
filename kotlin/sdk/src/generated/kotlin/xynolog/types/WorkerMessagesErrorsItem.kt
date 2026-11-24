// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class WorkerMessagesErrorsItem(
    /** The situation's name. */
    public val name: String,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The error. `{job}` in it is the job, as `job` names it. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies. */
    public val error: String,
) {
    /** How Java makes a `WorkerMessagesErrorsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val situation: String,
        private val error: String,
    ) {
        public fun build(): WorkerMessagesErrorsItem = WorkerMessagesErrorsItem(name = name, situation = situation, error = error)
    }

    public companion object {
        /** A builder of a `WorkerMessagesErrorsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, situation: String, error: String): Builder = Builder(name, situation, error)
    }
}

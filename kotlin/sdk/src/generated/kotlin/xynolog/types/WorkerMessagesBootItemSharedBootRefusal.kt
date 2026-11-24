// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class WorkerMessagesBootItemSharedBootRefusal(
    /** The situation's name. */
    public val name: String,
    /** When it is written. What fills its text is the shared row's. */
    public val situation: String,
    /** The `name` of the row of service-environment/boot-refusals.json's `refusals` that is this refusal, with `{service}` `worker` and `{schema}` `WorkerConfig`. */
    public val bootRefusal: String,
) : WorkerMessagesBootItem {
    /** How Java makes a `WorkerMessagesBootItemSharedBootRefusal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val situation: String,
        private val bootRefusal: String,
    ) {
        public fun build(): WorkerMessagesBootItemSharedBootRefusal = WorkerMessagesBootItemSharedBootRefusal(name = name, situation = situation, bootRefusal = bootRefusal)
    }

    public companion object {
        /** A builder of a `WorkerMessagesBootItemSharedBootRefusal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, situation: String, bootRefusal: String): Builder = Builder(name, situation, bootRefusal)
    }
}

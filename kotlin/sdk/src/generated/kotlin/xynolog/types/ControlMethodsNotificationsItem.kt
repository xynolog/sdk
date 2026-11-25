// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ControlMethodsNotificationsItem(
    /** A notification's name. */
    public val name: String,
    /** Which side sends it. */
    public val from: ControlMethodsNotificationsItemFrom,
    /** A schema of control/, by its $id. */
    public val params: String,
    /** What it says. */
    public val docs: String,
) {
    /** How Java makes a `ControlMethodsNotificationsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val from: ControlMethodsNotificationsItemFrom,
        private val params: String,
        private val docs: String,
    ) {
        public fun build(): ControlMethodsNotificationsItem = ControlMethodsNotificationsItem(name = name, from = from, params = params, docs = docs)
    }

    public companion object {
        /** A builder of a `ControlMethodsNotificationsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, from: ControlMethodsNotificationsItemFrom, params: String, docs: String): Builder = Builder(name, from, params, docs)
    }
}

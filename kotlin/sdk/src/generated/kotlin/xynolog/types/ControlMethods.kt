// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** control/methods.json: the control API's methods and notifications, and the schemas each names. */
@Serializable
public data class ControlMethods(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** A schema of control/, by its $id. */
    public val apiVersion: String,
    /** A schema of control/, by its $id. */
    public val errorData: String,
    public val methods: kotlin.collections.List<ControlMethodsMethodsItem>,
    public val notifications: kotlin.collections.List<ControlMethodsNotificationsItem>,
) {
    /** How Java makes a `ControlMethods`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val apiVersion: String,
        private val errorData: String,
        private val methods: kotlin.collections.List<ControlMethodsMethodsItem>,
        private val notifications: kotlin.collections.List<ControlMethodsNotificationsItem>,
    ) {
        public fun build(): ControlMethods = ControlMethods(comment = comment, apiVersion = apiVersion, errorData = errorData, methods = methods, notifications = notifications)
    }

    public companion object {
        /** A builder of a `ControlMethods` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, apiVersion: String, errorData: String, methods: kotlin.collections.List<ControlMethodsMethodsItem>, notifications: kotlin.collections.List<ControlMethodsNotificationsItem>): Builder = Builder(comment, apiVersion, errorData, methods, notifications)
    }
}

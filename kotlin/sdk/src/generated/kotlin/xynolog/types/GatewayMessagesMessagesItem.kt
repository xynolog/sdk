// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class GatewayMessagesMessagesItem(
    /** The situation's name. */
    public val name: String,
    public val status: HttpStatus,
    /** Its `code`, where it carries one: a LimitRefusal's, or the transport code errors/codes.json names for its status. */
    public val code: String? = null,
    /** When the gateway answers it, and what fills each `{name}` of its texts. */
    public val situation: String,
    /** Its text. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies. */
    public val error: String,
    /** Its `hint`, where it carries one. */
    public val hint: String? = null,
) {
    /** How Java makes a `GatewayMessagesMessagesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val status: HttpStatus,
        private val situation: String,
        private val error: String,
    ) {
        private var code: String? = null
        private var hint: String? = null

        public fun code(code: String?): Builder = apply { this.code = code }
        public fun hint(hint: String?): Builder = apply { this.hint = hint }

        public fun build(): GatewayMessagesMessagesItem = GatewayMessagesMessagesItem(name = name, status = status, code = code, situation = situation, error = error, hint = hint)
    }

    public companion object {
        /** A builder of a `GatewayMessagesMessagesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, status: HttpStatus, situation: String, error: String): Builder = Builder(name, status, situation, error)
    }
}

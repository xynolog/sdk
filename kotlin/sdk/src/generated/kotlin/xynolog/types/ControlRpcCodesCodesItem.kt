// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ControlRpcCodesCodesItem(
    /** The JSON-RPC error's code. */
    public val number: Long,
    /** Its name, as every SDK names it. */
    public val name: String,
    /** When the launcher answers with it, in prose, by the contract's rules. */
    public val docs: String,
    /** The data every answer under it carries, whatever failed. */
    public val data: ErrorData? = null,
) {
    /** How Java makes a `ControlRpcCodesCodesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val number: Long,
        private val name: String,
        private val docs: String,
    ) {
        private var data: ErrorData? = null

        public fun data(data: ErrorData?): Builder = apply { this.data = data }

        public fun build(): ControlRpcCodesCodesItem = ControlRpcCodesCodesItem(number = number, name = name, docs = docs, data = data)
    }

    public companion object {
        /** A builder of a `ControlRpcCodesCodesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(number: Long, name: String, docs: String): Builder = Builder(number, name, docs)
    }
}

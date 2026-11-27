// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ErrorsCodesControlCodesItem(
    /** The code, as every SDK names it. */
    public val code: String,
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    /** The JSON-RPC error's code an answer carries it under: a number of control/rpc-codes.json. */
    public val rpc: Long,
    /** Whether the same request can succeed sent again unchanged, once something outside it changes (contract/LAUNCHER-CONTROL.md E3): what ErrorData's retryable says of it when it is answered under its rpc. Under a code of control/rpc-codes.json that states its data, the data is that row's. */
    public val retryable: Boolean,
) {
    /** How Java makes a `ErrorsCodesControlCodesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val docs: String,
        private val rpc: Long,
        private val retryable: Boolean,
    ) {
        public fun build(): ErrorsCodesControlCodesItem = ErrorsCodesControlCodesItem(code = code, docs = docs, rpc = rpc, retryable = retryable)
    }

    public companion object {
        /** A builder of a `ErrorsCodesControlCodesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, docs: String, rpc: Long, retryable: Boolean): Builder = Builder(code, docs, rpc, retryable)
    }
}

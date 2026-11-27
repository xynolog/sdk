// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** control/rpc-codes.json: the JSON-RPC error codes the control API answers with. */
@Serializable
public data class ControlRpcCodes(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val codes: kotlin.collections.List<ControlRpcCodesCodesItem>,
) {
    /** How Java makes a `ControlRpcCodes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val codes: kotlin.collections.List<ControlRpcCodesCodesItem>,
    ) {
        public fun build(): ControlRpcCodes = ControlRpcCodes(comment = comment, codes = codes)
    }

    public companion object {
        /** A builder of a `ControlRpcCodes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, codes: kotlin.collections.List<ControlRpcCodesCodesItem>): Builder = Builder(comment, codes)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A claim refused for a reason other than that nothing is pending, which is no fault: what a worker's claims say on `refused` (contract/WORKER-CONTRACT.md § Claiming). `bus.unauthorized` means the credential cannot claim, and will not be able to later. */
@Serializable
public data class ClaimRefusal(
    /** The bus code the reply was read as, or null when the refusal was the worker's own: a reply its schema does not allow. Never a code the reply did not state, and never `bus.none-pending`. */
    public val code: xynolog.errors.BusRequestErrorCode?,
    /** What the refusal said. */
    public val message: String,
) {
    /** How Java makes a `ClaimRefusal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: xynolog.errors.BusRequestErrorCode?,
        private val message: String,
    ) {
        public fun build(): ClaimRefusal = ClaimRefusal(code = code, message = message)
    }

    public companion object {
        /** A builder of a `ClaimRefusal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: xynolog.errors.BusRequestErrorCode?, message: String): Builder = Builder(code, message)
    }
}

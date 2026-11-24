// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The client gives up on one of its requests. The launcher answers that request with control.cancelled, unless it has answered it already; a cancellation of a request it does not know is ignored. */
@Serializable
public data class Cancelled(
    public val requestId: RequestId,
    /** Why, for the launcher's diagnostics. */
    public val reason: String? = null,
) {
    /** How Java makes a `Cancelled`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
    ) {
        private var reason: String? = null

        public fun reason(reason: String?): Builder = apply { this.reason = reason }

        public fun build(): Cancelled = Cancelled(requestId = requestId, reason = reason)
    }

    public companion object {
        /** A builder of a `Cancelled` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId): Builder = Builder(requestId)
    }
}

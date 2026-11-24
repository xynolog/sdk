// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A failure as an SDK reports it to the suite (conformance/sdk/README.md, "The driver protocol"): its code, the status when a server stated one, and a job failure's class when it has one; and the SDK's own words for it. */
@Serializable
public data class ConformanceFailure(
    /** The SDK's code for it, from specs/src/errors/codes.json. */
    public val code: String? = null,
    /** The HTTP status, when a server stated one. */
    public val status: Long? = null,
    /** A job failure's class, when it has one. */
    public val failureClass: FailureClass? = null,
    /** The SDK's words, for a person; nothing compares it. */
    public val detail: String,
) {
    /** How Java makes a `ConformanceFailure`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val detail: String,
    ) {
        private var code: String? = null
        private var status: Long? = null
        private var failureClass: FailureClass? = null

        public fun code(code: String?): Builder = apply { this.code = code }
        public fun status(status: Long?): Builder = apply { this.status = status }
        public fun failureClass(failureClass: FailureClass?): Builder = apply { this.failureClass = failureClass }

        public fun build(): ConformanceFailure = ConformanceFailure(code = code, status = status, failureClass = failureClass, detail = detail)
    }

    public companion object {
        /** A builder of a `ConformanceFailure` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(detail: String): Builder = Builder(detail)
    }
}

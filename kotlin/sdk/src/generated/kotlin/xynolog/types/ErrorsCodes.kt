// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** errors/codes.json: the error codes a Xynolog client reports, in one vocabulary for each kind of failure. */
@Serializable
public data class ErrorsCodes(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Why a bus request did not resolve. */
    public val busRequest: ErrorsCodesBusRequest,
    /** The transport-neutral failure vocabulary. */
    public val transport: ErrorsCodesTransport,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val job: ErrorsCodesJob,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val session: ErrorsCodesJob,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val signIn: ErrorsCodesJob,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val kbIdentity: ErrorsCodesJob,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val spanRefusal: ErrorsCodesJob,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val control: ErrorsCodesJob,
) {
    /** How Java makes a `ErrorsCodes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val busRequest: ErrorsCodesBusRequest,
        private val transport: ErrorsCodesTransport,
        private val job: ErrorsCodesJob,
        private val session: ErrorsCodesJob,
        private val signIn: ErrorsCodesJob,
        private val kbIdentity: ErrorsCodesJob,
        private val spanRefusal: ErrorsCodesJob,
        private val control: ErrorsCodesJob,
    ) {
        public fun build(): ErrorsCodes = ErrorsCodes(comment = comment, busRequest = busRequest, transport = transport, job = job, session = session, signIn = signIn, kbIdentity = kbIdentity, spanRefusal = spanRefusal, control = control)
    }

    public companion object {
        /** A builder of a `ErrorsCodes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, busRequest: ErrorsCodesBusRequest, transport: ErrorsCodesTransport, job: ErrorsCodesJob, session: ErrorsCodesJob, signIn: ErrorsCodesJob, kbIdentity: ErrorsCodesJob, spanRefusal: ErrorsCodesJob, control: ErrorsCodesJob): Builder = Builder(comment, busRequest, transport, job, session, signIn, kbIdentity, spanRefusal, control)
    }
}

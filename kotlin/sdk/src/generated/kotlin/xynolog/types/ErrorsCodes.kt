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
    public val session: ErrorsCodesSession,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val signIn: ErrorsCodesSignIn,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val kbIdentity: ErrorsCodesKbIdentity,
    /** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
    public val spanRefusal: ErrorsCodesSpanRefusal,
    /** Why a request of the launcher's control API failed: each code, the JSON-RPC code an answer carries it under, and whether a request that fails with it is retryable. */
    public val control: ErrorsCodesControl,
) {
    /** How Java makes a `ErrorsCodes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val busRequest: ErrorsCodesBusRequest,
        private val transport: ErrorsCodesTransport,
        private val job: ErrorsCodesJob,
        private val session: ErrorsCodesSession,
        private val signIn: ErrorsCodesSignIn,
        private val kbIdentity: ErrorsCodesKbIdentity,
        private val spanRefusal: ErrorsCodesSpanRefusal,
        private val control: ErrorsCodesControl,
    ) {
        public fun build(): ErrorsCodes = ErrorsCodes(comment = comment, busRequest = busRequest, transport = transport, job = job, session = session, signIn = signIn, kbIdentity = kbIdentity, spanRefusal = spanRefusal, control = control)
    }

    public companion object {
        /** A builder of a `ErrorsCodes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, busRequest: ErrorsCodesBusRequest, transport: ErrorsCodesTransport, job: ErrorsCodesJob, session: ErrorsCodesSession, signIn: ErrorsCodesSignIn, kbIdentity: ErrorsCodesKbIdentity, spanRefusal: ErrorsCodesSpanRefusal, control: ErrorsCodesControl): Builder = Builder(comment, busRequest, transport, job, session, signIn, kbIdentity, spanRefusal, control)
    }
}

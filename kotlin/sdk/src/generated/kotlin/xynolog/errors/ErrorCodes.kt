// Generated from protocol/specs/src/errors/codes.json; do not edit.
// Regenerate: make generate (codegen/lib/error_codes/kotlin.ml)

package xynolog.errors

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import xynolog.Generated
import xynolog.types.CommandErrorCode

/** Why a transport failed a request: what a server refused, or that none answered. */
@Generated
@Serializable
public enum class TransportErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * Authentication is required: the token is missing, expired, or refused. A refusal of `limitRefusals` refuses the token too (contract/TRANSPORT-CONTRACT.md § A refused credential), and is reported as this code with its own status.
     */
    @SerialName("unauthorized")
    Unauthorized("unauthorized"),

    /**
     * Authenticated, and lacking permission.
     */
    @SerialName("forbidden")
    Forbidden("forbidden"),

    /**
     * The resource is missing.
     */
    @SerialName("not-found")
    NotFound("not-found"),

    /**
     * A concurrent modification, a duplicate, or another conflict with current state.
     */
    @SerialName("conflict")
    Conflict("conflict"),

    /**
     * The request is malformed.
     */
    @SerialName("bad-request")
    BadRequest("bad-request"),

    /**
     * The request is well formed and cannot be carried out as it stands: an `Idempotency-Key` used for two different requests. Sent again, it is refused again.
     */
    @SerialName("unprocessable")
    Unprocessable("unprocessable"),

    /**
     * A limit refused it; the refusal's `Retry-After` says when to return.
     */
    @SerialName("rate-limited")
    RateLimited("rate-limited"),

    /**
     * The gateway is unreachable, the network failed, or the server answered 5xx.
     */
    @SerialName("unavailable")
    Unavailable("unavailable"),

    /**
     * A failure no other member names.
     */
    @SerialName("error")
    Error("error"),
}

/** Why a bus request did not resolve. */
@Generated
@Serializable
public enum class BusRequestErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * No reply arrived within the time the request allowed.
     */
    @SerialName("bus.timeout")
    Timeout("bus.timeout"),

    /**
     * The peer answered with a failure that states no code, or one CommandError does not list, which is read as none.
     */
    @SerialName("bus.rejected")
    Rejected("bus.rejected"),

    /**
     * The bus stopped before a reply came: its client was disposed, or its transport closed.
     */
    @SerialName("bus.closed")
    Closed("bus.closed"),

    /**
     * The peer says this resource does not exist in its knowledge base.
     */
    @SerialName("bus.not-found")
    NotFound("bus.not-found"),

    /**
     * THIS transport is not subscribed to the reply channel: a local misconfiguration, caught before emitting. Not to be confused with `bus.peer-unavailable`, which is the opposite end.
     */
    @SerialName("bus.unsubscribed")
    Unsubscribed("bus.unsubscribed"),

    /**
     * The service that answers this channel is not connected. Transient by nature, a peer still starting, and therefore the one failure on this list worth retrying.
     */
    @SerialName("bus.peer-unavailable")
    PeerUnavailable("bus.peer-unavailable"),

    /**
     * The peer says this caller may not do what it asked: authenticated, not permitted. Retrying under the same credential cannot succeed, so a consumer surfaces it and never spins on it.
     */
    @SerialName("bus.unauthorized")
    Unauthorized("bus.unauthorized"),

    /**
     * The peer declined and nothing went wrong: a `job:claim` found no pending job of the requested types. The one member a consumer parks on.
     */
    @SerialName("bus.none-pending")
    NonePending("bus.none-pending"),
}

/** Why a job its client follows ended without a result. A failure the queue will retry is not one of these: the job goes on, and its follower is told of the setback and keeps following. */
@Generated
@Serializable
public enum class JobErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * The job failed and will not be tried again: the failure its worker reported, or the one its status states.
     */
    @SerialName("job.failed")
    Failed("job.failed"),

    /**
     * The job was cancelled before it ended, as its status states. Nothing announces a cancellation: its follower learns of it when it asks for the job's status.
     */
    @SerialName("job.cancelled")
    Cancelled("job.cancelled"),

    /**
     * The job said nothing for longer than its follower allows. The follower has asked for that job to be cancelled.
     */
    @SerialName("job.stalled")
    Stalled("job.stalled"),
}

/** Why a session itself is unusable, or what its client keeps could not be kept or written. Per-request failures stay with their caller. */
@Generated
@Serializable
public enum class SessionErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * A session for the knowledge base could not be built or made ready.
     */
    @SerialName("session.construct-failed")
    ConstructFailed("session.construct-failed"),

    /**
     * The stored credential could not be validated at startup, for a reason other than the gateway refusing it.
     */
    @SerialName("session.auth-failed")
    AuthFailed("session.auth-failed"),

    /**
     * The session could not be renewed: the issuer refused, or stayed unreachable until the retry budget was spent. Not a prompt to retry: retrying already happened.
     */
    @SerialName("session.refresh-exhausted")
    RefreshExhausted("session.refresh-exhausted"),

    /**
     * The gateway refused a token the issuer had just issued. The two disagree about who may sign in, and renewing again cannot change the answer: the session is over, and signing in again is what is left.
     */
    @SerialName("session.credential-refused")
    CredentialRefused("session.credential-refused"),

    /**
     * The sign-in the session holds could not be read before its client saved what it keeps, or could not record the person the gateway named, so it is not known to name the person that is kept for: the client keeps nothing more for the rest of its life. The session itself goes on, and says so once on its errors stream.
     */
    @SerialName("session.keep-failed")
    KeepFailed("session.keep-failed"),

    /**
     * The storage refused a write of what the session's client keeps. The save stays owed: the client's next change, or its closing, writes it again, and what its closing cannot write is lost. The session says so on its errors stream once for each write the storage refuses, with what the storage said, a refusal of its closing among them, before the stream ends. The session itself goes on.
     */
    @SerialName("session.save-refused")
    SaveRefused("session.save-refused"),
}

/** Why a person could not be signed in at the issuer a knowledge base trusts, or a session could not be renewed there. Over the authorization-code grant, the device grant, the refresh grant and revocation alike. */
@Generated
@Serializable
public enum class SignInErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * The knowledge base trusts no external issuer: there is nowhere to sign in.
     */
    @SerialName("no-issuer")
    NoIssuer("no-issuer"),

    /**
     * The knowledge base did not say which issuer it trusts, or the issuer did not describe itself, or described another issuer, or offers no endpoint the grant needs.
     */
    @SerialName("discovery")
    Discovery("discovery"),

    /**
     * A sign-in response arrived and no sign-in is pending here: it was completed already, or begun somewhere else.
     */
    @SerialName("no-pending")
    NoPending("no-pending"),

    /**
     * The sign-in response does not belong to the pending sign-in.
     */
    @SerialName("state")
    State("state"),

    /**
     * The person, or the issuer, refused the sign-in.
     */
    @SerialName("denied")
    Denied("denied"),

    /**
     * The device code ran out before it was approved.
     */
    @SerialName("expired")
    Expired("expired"),

    /**
     * The sign-in was abandoned by whoever began it.
     */
    @SerialName("aborted")
    Aborted("aborted"),

    /**
     * The issuer refused a token request, a device authorization or a revocation, or answered without what was asked for.
     */
    @SerialName("exchange")
    Exchange("exchange"),
}

/** Why a knowledge base that was reached with a fresh sign-in could not be registered: it has to say who it is, and nothing stands in for its answer. */
@Generated
@Serializable
public enum class IdentityUnverifiableReason(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * The knowledge base was not reached, so it said nothing.
     */
    @SerialName("unreachable")
    Unreachable("unreachable"),

    /**
     * The knowledge base answered that it cannot say what it is.
     */
    @SerialName("not-reported")
    NotReported("not-reported"),
}

/** Why no annotation was built of a span: the span is not the text's, or, for a PDF, is nowhere on its pages, or the PDF's anchored text does not hold together. specs/src/annotations/builder-cases.json holds when each is given. */
@Generated
@Serializable
public enum class SpanRefusal(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * The span's offsets are not two whole numbers from 0, the second no less than the first, within the text.
     */
    @SerialName("span-out-of-range")
    SpanOutOfRange("span-out-of-range"),

    /**
     * The words the span states are not the text between its offsets.
     */
    @SerialName("exact-mismatch")
    ExactMismatch("exact-mismatch"),

    /**
     * The prefix the span states is not the text just before it.
     */
    @SerialName("prefix-mismatch")
    PrefixMismatch("prefix-mismatch"),

    /**
     * The suffix the span states is not the text just after it.
     */
    @SerialName("suffix-mismatch")
    SuffixMismatch("suffix-mismatch"),

    /**
     * No item of the PDF's anchored text holds any of the span, so it is nowhere on a page.
     */
    @SerialName("nothing-located")
    NothingLocated("nothing-located"),

    /**
     * The items of the PDF's anchored text that hold the span do not have its words.
     */
    @SerialName("exact-not-covered")
    ExactNotCovered("exact-not-covered"),

    /**
     * An item of the PDF's anchored text is no stretch of that text: its offsets are not two whole numbers from 0, the second no less than the first, within the text. This one is said of the anchored text and not of the span: the items are what say where the text is on a page, and no span is built on an anchored text one of whose items cannot be.
     */
    @SerialName("item-out-of-range")
    ItemOutOfRange("item-out-of-range"),
}

/** Why a request of the launcher's control API (`xynolog control`, contract/LAUNCHER-CONTROL.md) failed. The launcher sends one in each error's data, and Desktop reads it. A knowledge base never sends one. */
@Generated
@Serializable
public enum class ControlErrorCode(
    /** The code as the wire and every SDK spell it. */
    public val code: String,
) {
    /**
     * The request's params are not what its method's schema admits. The error's fields name each fault.
     */
    @SerialName("control.invalid-params")
    InvalidParams("control.invalid-params"),

    /**
     * The request is written to a version of the control API this launcher does not speak. The error's supported field names the ones it does.
     */
    @SerialName("control.unsupported-api-version")
    UnsupportedApiVersion("control.unsupported-api-version"),

    /**
     * The launcher refuses the request as the command line refuses the same options: they contradict each other, or do not apply to what they name.
     */
    @SerialName("control.invalid-request")
    InvalidRequest("control.invalid-request"),

    /**
     * The request names a service or a group the launcher has none of.
     */
    @SerialName("control.invalid-service")
    InvalidService("control.invalid-service"),

    /**
     * The launcher refuses a setting's value, as a start would refuse it. The previous value is kept.
     */
    @SerialName("control.invalid-value")
    InvalidValue("control.invalid-value"),

    /**
     * The request names a setting the launcher does not keep.
     */
    @SerialName("control.unknown-setting")
    UnknownSetting("control.unknown-setting"),

    /**
     * Several stacks could be meant and the request names none of them. The error's choices name each; nothing was done.
     */
    @SerialName("control.target-required")
    TargetRequired("control.target-required"),

    /**
     * The root the request names is the basename of several registered roots. The error's choices name each by its path; nothing was done.
     */
    @SerialName("control.target-ambiguous")
    TargetAmbiguous("control.target-ambiguous"),

    /**
     * The root the request names is not a knowledge base's clone: no such directory, no .xynolog/ in it, or a project file the launcher refuses.
     */
    @SerialName("control.root-not-found")
    RootNotFound("control.root-not-found"),

    /**
     * The root the request names is not in the registry.
     */
    @SerialName("control.root-not-registered")
    RootNotRegistered("control.root-not-registered"),

    /**
     * The request needs a stack of its target recorded on this machine, and none is.
     */
    @SerialName("control.stack-not-running")
    StackNotRunning("control.stack-not-running"),

    /**
     * The request would change what a recorded stack depends on: stop the stack first.
     */
    @SerialName("control.stack-running")
    StackRunning("control.stack-running"),

    /**
     * Another xynolog start of the same knowledge base holds its start lock.
     */
    @SerialName("control.start-in-progress")
    StartInProgress("control.start-in-progress"),

    /**
     * No container runtime the request can use is on the launcher's PATH.
     */
    @SerialName("control.runtime-unavailable")
    RuntimeUnavailable("control.runtime-unavailable"),

    /**
     * A program the request needs besides a container runtime (gh, for a codespace) is not on the launcher's PATH.
     */
    @SerialName("control.dependency-unavailable")
    DependencyUnavailable("control.dependency-unavailable"),

    /**
     * What the request needs to reach did not answer: the knowledge base, its issuer, or a codespace's forward.
     */
    @SerialName("control.unreachable")
    Unreachable("control.unreachable"),

    /**
     * An instance of the name the run gives already runs on this machine for its target, whichever control server or command started it. Nothing was started.
     */
    @SerialName("control.instance-in-use")
    InstanceInUse("control.instance-in-use"),

    /**
     * No run of an instance of the name the request gives is in flight on this machine for its target: none was started, or its run has been answered.
     */
    @SerialName("control.instance-not-found")
    InstanceNotFound("control.instance-not-found"),

    /**
     * The request would destroy something, and does not state that a person confirmed it.
     */
    @SerialName("control.confirmation-required")
    ConfirmationRequired("control.confirmation-required"),

    /**
     * The launcher's own record of this machine (the stack record, the registry, the sign-in store) cannot be read. Nothing was assumed in its place.
     */
    @SerialName("control.unreadable-state")
    UnreadableState("control.unreadable-state"),

    /**
     * The launcher's stored session for the target is valid: there is nothing to sign in to.
     */
    @SerialName("control.already-signed-in")
    AlreadySignedIn("control.already-signed-in"),

    /**
     * The person was not signed in: the issuer refused or the code expired, the gateway refused the token, or the session could not be kept. Nothing was stored.
     */
    @SerialName("control.sign-in-failed")
    SignInFailed("control.sign-in-failed"),

    /**
     * The client cancelled the request before it ended.
     */
    @SerialName("control.cancelled")
    Cancelled("control.cancelled"),

    /**
     * The request failed for a reason no other code names. Its message says why, as the command line would.
     */
    @SerialName("control.failed")
    Failed("control.failed"),
}

/** The code a refusal of `status` fails with. */
internal fun transportErrorCodeFor(status: Int): TransportErrorCode = when {
    status == 401 -> TransportErrorCode.Unauthorized
    status == 403 -> TransportErrorCode.Forbidden
    status == 404 -> TransportErrorCode.NotFound
    status == 409 -> TransportErrorCode.Conflict
    status == 400 -> TransportErrorCode.BadRequest
    status == 422 -> TransportErrorCode.Unprocessable
    status == 429 -> TransportErrorCode.RateLimited
    status >= 500 -> TransportErrorCode.Unavailable
    else -> TransportErrorCode.Error
}

/** The client code each of CommandError's codes, a failure's own code, becomes. */
internal fun busRequestCodeOf(code: CommandErrorCode): BusRequestErrorCode = when (code) {
    CommandErrorCode.PeerUnavailable -> BusRequestErrorCode.PeerUnavailable
    CommandErrorCode.NotFound -> BusRequestErrorCode.NotFound
    CommandErrorCode.Unauthorized -> BusRequestErrorCode.Unauthorized
    CommandErrorCode.NonePending -> BusRequestErrorCode.NonePending
}

/** The client code of a failure that states no code: one whose code the required table does not recognize is read as stating none. */
internal val UNRECOGNIZED_FAILURE: BusRequestErrorCode = BusRequestErrorCode.Rejected

/** A gateway refusal of a limit that is a transport code too: its status, its `LimitRefusal` code, and the transport code it is. */
@Generated
public data class LimitRefusalTransportCode(
    public val status: Int,
    public val code: String,
    public val transport: TransportErrorCode,
)

/** Each gateway refusal of a limit that is a transport code too. */
public val LIMIT_REFUSAL_TRANSPORT_CODES: List<LimitRefusalTransportCode> = listOf(LimitRefusalTransportCode(429, "refusal-rate", TransportErrorCode.Unauthorized))

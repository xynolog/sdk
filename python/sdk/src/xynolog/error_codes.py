# Generated from protocol/specs/src/errors/codes.json; do not edit.
# Regenerate: make generate (codegen/lib/error_codes/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The codes a Xynolog client reports a failure under.

Each vocabulary is a closed set: a `Literal` union, so a `match` over one that
ends in `assert_never` is checked to name every code, and a tuple of the same
codes to iterate.
"""

from typing import Final, Literal, assert_never

from xynolog.types import CommandErrorCode

__all__ = [
    "BUS_REQUEST_ERROR_CODES",
    "BusRequestErrorCode",
    "CONTROL_ERROR_CODES",
    "ControlErrorCode",
    "IDENTITY_UNVERIFIABLE_REASONS",
    "IdentityUnverifiableReason",
    "JOB_ERROR_CODES",
    "JobErrorCode",
    "SIGN_IN_ERROR_CODES",
    "SPAN_REFUSALS",
    "SignInErrorCode",
    "SpanRefusal",
    "TRANSPORT_ERROR_CODES",
    "TransportErrorCode",
    "XYNOLOG_SESSION_ERROR_CODES",
    "XynologSessionErrorCode",
    "bus_request_code_for_wire_code",
    "transport_error_code_for_status",
]

# Why a bus request did not resolve. Some members restate a failure the answering peer declared
# on the wire (`wire` names its `CommandError.code`); the rest are facts only the requesting
# side knows, which is why this vocabulary and the wire's stay separate.
type BusRequestErrorCode = Literal[
    # No reply arrived within the time the request allowed.
    "bus.timeout",
    # The peer answered with a failure that states no code, or one CommandError does not list,
    # which is read as none.
    "bus.rejected",
    # The bus stopped before a reply came: its client was disposed, or its transport closed.
    "bus.closed",
    # The peer says this resource does not exist in its knowledge base.
    "bus.not-found",
    # THIS transport is not subscribed to the reply channel: a local misconfiguration, caught
    # before emitting. Not to be confused with `bus.peer-unavailable`, which is the opposite
    # end.
    "bus.unsubscribed",
    # The service that answers this channel is not connected. Transient by nature, a peer still
    # starting, and therefore the one failure on this list worth retrying.
    "bus.peer-unavailable",
    # The peer says this caller may not do what it asked: authenticated, not permitted. Retrying
    # under the same credential cannot succeed, so a consumer surfaces it and never spins on it.
    "bus.unauthorized",
    # The peer declined and nothing went wrong: a `job:claim` found no pending job of the
    # requested types. The one member a consumer parks on.
    "bus.none-pending",
]

BUS_REQUEST_ERROR_CODES: Final[tuple[BusRequestErrorCode, ...]] = (
    "bus.timeout",
    "bus.rejected",
    "bus.closed",
    "bus.not-found",
    "bus.unsubscribed",
    "bus.peer-unavailable",
    "bus.unauthorized",
    "bus.none-pending",
)


def bus_request_code_for_wire_code(code: CommandErrorCode | None) -> BusRequestErrorCode:
    """The bus code a failure's own code (`CommandError.code`) becomes.

    A failure that states none is the unrecognized failure, and so is one
    whose code the wire does not list, which is read as stating none.
    """
    match code:
        case "not-found":
            return "bus.not-found"
        case "peer-unavailable":
            return "bus.peer-unavailable"
        case "unauthorized":
            return "bus.unauthorized"
        case "none-pending":
            return "bus.none-pending"
        case None:
            return "bus.rejected"
        case _:
            assert_never(code)


# Transport-neutral failure vocabulary. Every transport maps its native failures to one of
# these, so a routing layer matches on the code without knowing the wire kind. Over HTTP the
# mapping is by status: `status` is an exact status, `statusFrom` every status at or above it.
type TransportErrorCode = Literal[
    # Authentication is required: the token is missing, expired, or refused. A 429 whose `code`
    # is `refusal-rate` refuses the token too, and is reported as this code with its own status.
    "unauthorized",
    # Authenticated, and lacking permission.
    "forbidden",
    # The resource is missing.
    "not-found",
    # A concurrent modification, a duplicate, or another conflict with current state.
    "conflict",
    # The request is malformed.
    "bad-request",
    # The request is well formed and cannot be carried out as it stands: an `Idempotency-Key`
    # used for two different requests. Sent again, it is refused again.
    "unprocessable",
    # A limit refused it; the refusal's `Retry-After` says when to return.
    "rate-limited",
    # The gateway is unreachable, the network failed, or the server answered 5xx.
    "unavailable",
    # A failure no other member names.
    "error",
]

TRANSPORT_ERROR_CODES: Final[tuple[TransportErrorCode, ...]] = (
    "unauthorized",
    "forbidden",
    "not-found",
    "conflict",
    "bad-request",
    "unprocessable",
    "rate-limited",
    "unavailable",
    "error",
)


def transport_error_code_for_status(status: int) -> TransportErrorCode:
    """The transport code an HTTP status becomes."""
    match status:
        case 401:
            return "unauthorized"
        case 403:
            return "forbidden"
        case 404:
            return "not-found"
        case 409:
            return "conflict"
        case 400:
            return "bad-request"
        case 422:
            return "unprocessable"
        case 429:
            return "rate-limited"
        case _:
            pass
    if status >= 500:
        return "unavailable"
    return "error"


# Why a job its client follows ended without a result. A failure the queue will retry is not one
# of these: the job goes on, and its follower is told of the setback and keeps following.
type JobErrorCode = Literal[
    # The job failed and will not be tried again: the failure its worker reported, or the one
    # its status states.
    "job.failed",
    # The job was cancelled before it ended, as its status states. Nothing announces a
    # cancellation: its follower learns of it when it asks for the job's status.
    "job.cancelled",
    # The job said nothing for longer than its follower allows. The follower has asked for that
    # job to be cancelled.
    "job.stalled",
]

JOB_ERROR_CODES: Final[tuple[JobErrorCode, ...]] = (
    "job.failed",
    "job.cancelled",
    "job.stalled",
)

# Why a session itself is unusable, or what its client keeps could not be kept or written.
# Per-request failures stay with their caller.
type XynologSessionErrorCode = Literal[
    # A session for the knowledge base could not be built or made ready.
    "session.construct-failed",
    # The stored credential could not be validated at startup, for a reason other than the
    # gateway refusing it.
    "session.auth-failed",
    # The session could not be renewed: the issuer refused, or stayed unreachable until the
    # retry budget was spent. Not a prompt to retry: retrying already happened.
    "session.refresh-exhausted",
    # The gateway refused a token the issuer had just issued. The two disagree about who may
    # sign in, and renewing again cannot change the answer: the session is over, and signing in
    # again is what is left.
    "session.credential-refused",
    # The sign-in the session holds could not be read before its client saved what it keeps, or
    # could not record the person the gateway named, so it is not known to name the person that
    # is kept for: the client keeps nothing more for the rest of its life. The session itself
    # goes on, and says so once on its errors stream.
    "session.keep-failed",
    # The storage refused a write of what the session's client keeps. The save stays owed: the
    # client's next change, or its closing, writes it again, and what its closing cannot write
    # is lost. The session says so on its errors stream once for each write the storage refuses,
    # with what the storage said, a refusal of its closing among them, before the stream ends.
    # The session itself goes on.
    "session.save-refused",
]

XYNOLOG_SESSION_ERROR_CODES: Final[tuple[XynologSessionErrorCode, ...]] = (
    "session.construct-failed",
    "session.auth-failed",
    "session.refresh-exhausted",
    "session.credential-refused",
    "session.keep-failed",
    "session.save-refused",
)

# Why a person could not be signed in at the issuer a knowledge base trusts, or a session could
# not be renewed there. Over the authorization-code grant, the device grant, the refresh grant
# and revocation alike.
type SignInErrorCode = Literal[
    # The knowledge base trusts no external issuer: there is nowhere to sign in.
    "no-issuer",
    # The knowledge base did not say which issuer it trusts, or the issuer did not describe
    # itself, or described another issuer, or offers no endpoint the grant needs.
    "discovery",
    # A sign-in response arrived and no sign-in is pending here: it was completed already, or
    # begun somewhere else.
    "no-pending",
    # The sign-in response does not belong to the pending sign-in.
    "state",
    # The person, or the issuer, refused the sign-in.
    "denied",
    # The device code ran out before it was approved.
    "expired",
    # The sign-in was abandoned by whoever began it.
    "aborted",
    # The issuer refused a token request, a device authorization or a revocation, or answered
    # without what was asked for.
    "exchange",
]

SIGN_IN_ERROR_CODES: Final[tuple[SignInErrorCode, ...]] = (
    "no-issuer",
    "discovery",
    "no-pending",
    "state",
    "denied",
    "expired",
    "aborted",
    "exchange",
)

# Why a knowledge base that was reached with a fresh sign-in could not be registered: it has to
# say who it is, and nothing stands in for its answer.
type IdentityUnverifiableReason = Literal[
    # The knowledge base was not reached, so it said nothing.
    "unreachable",
    # The knowledge base answered that it cannot say what it is.
    "not-reported",
]

IDENTITY_UNVERIFIABLE_REASONS: Final[tuple[IdentityUnverifiableReason, ...]] = (
    "unreachable",
    "not-reported",
)

# Why no annotation was built of a span: the span is not the text's, or, for a PDF, is nowhere
# on its pages, or the PDF's anchored text does not hold together.
# specs/src/annotations/builder-cases.json holds when each is given.
type SpanRefusal = Literal[
    # The span's offsets are not two whole numbers from 0, the second no less than the first,
    # within the text.
    "span-out-of-range",
    # The words the span states are not the text between its offsets.
    "exact-mismatch",
    # The prefix the span states is not the text just before it.
    "prefix-mismatch",
    # The suffix the span states is not the text just after it.
    "suffix-mismatch",
    # No item of the PDF's anchored text holds any of the span, so it is nowhere on a page.
    "nothing-located",
    # The items of the PDF's anchored text that hold the span do not have its words.
    "exact-not-covered",
    # An item of the PDF's anchored text is no stretch of that text: its offsets are not two
    # whole numbers from 0, the second no less than the first, within the text. This one is said
    # of the anchored text and not of the span: the items are what say where the text is on a
    # page, and no span is built on an anchored text one of whose items cannot be.
    "item-out-of-range",
]

SPAN_REFUSALS: Final[tuple[SpanRefusal, ...]] = (
    "span-out-of-range",
    "exact-mismatch",
    "prefix-mismatch",
    "suffix-mismatch",
    "nothing-located",
    "exact-not-covered",
    "item-out-of-range",
)

# Why a request of the launcher's control API (`xynolog control`, contract/LAUNCHER-CONTROL.md)
# failed. The launcher sends one in each error's data, and Desktop reads it. A knowledge base
# never sends one.
type ControlErrorCode = Literal[
    # The request's params are not what its method's schema admits. The error's fields name each
    # fault; JSON-RPC's own invalid-params code (-32602) carries it.
    "control.invalid-params",
    # The request is written to a version of the control API this launcher does not speak. The
    # error's supported field names the ones it does.
    "control.unsupported-api-version",
    # The launcher refuses the request as the command line refuses the same options: they
    # contradict each other, or do not apply to what they name.
    "control.invalid-request",
    # The request names a service or a group the launcher has none of.
    "control.invalid-service",
    # The launcher refuses a setting's value, as a start would refuse it. The previous value is
    # kept.
    "control.invalid-value",
    # The request names a setting the launcher does not keep.
    "control.unknown-setting",
    # Several stacks could be meant and the request names none of them. The error's choices name
    # each; nothing was done.
    "control.target-required",
    # The root the request names is the basename of several registered roots. The error's
    # choices name each by its path; nothing was done.
    "control.target-ambiguous",
    # The root the request names is not a knowledge base's clone: no such directory, no
    # .xynolog/ in it, or a project file the launcher refuses.
    "control.root-not-found",
    # The root the request names is not in the registry.
    "control.root-not-registered",
    # The request needs a stack of its target recorded on this machine, and none is.
    "control.stack-not-running",
    # The request would change what a recorded stack depends on: stop the stack first.
    "control.stack-running",
    # Another xynolog start of the same knowledge base holds its start lock.
    "control.start-in-progress",
    # No container runtime the request can use is on the launcher's PATH.
    "control.runtime-unavailable",
    # A program the request needs besides a container runtime (gh, for a codespace) is not on
    # the launcher's PATH.
    "control.dependency-unavailable",
    # What the request needs to reach did not answer: the knowledge base, its issuer, or a
    # codespace's forward.
    "control.unreachable",
    # An instance of the name the run gives already runs on this machine for its target,
    # whichever control server or command started it. Nothing was started.
    "control.instance-in-use",
    # No run of an instance of the name the request gives is in flight on this machine for its
    # target: none was started, or its run has been answered.
    "control.instance-not-found",
    # The request would destroy something, and does not state that a person confirmed it.
    "control.confirmation-required",
    # The launcher's own record of this machine (the stack record, the registry, the sign-in
    # store) cannot be read. Nothing was assumed in its place.
    "control.unreadable-state",
    # The launcher's stored session for the target is valid: there is nothing to sign in to.
    "control.already-signed-in",
    # The person was not signed in: the issuer refused or the code expired, the gateway refused
    # the token, or the session could not be kept. Nothing was stored.
    "control.sign-in-failed",
    # The client cancelled the request before it ended.
    "control.cancelled",
    # The request failed for a reason no other code names. Its message says why, as the command
    # line would.
    "control.failed",
]

CONTROL_ERROR_CODES: Final[tuple[ControlErrorCode, ...]] = (
    "control.invalid-params",
    "control.unsupported-api-version",
    "control.invalid-request",
    "control.invalid-service",
    "control.invalid-value",
    "control.unknown-setting",
    "control.target-required",
    "control.target-ambiguous",
    "control.root-not-found",
    "control.root-not-registered",
    "control.stack-not-running",
    "control.stack-running",
    "control.start-in-progress",
    "control.runtime-unavailable",
    "control.dependency-unavailable",
    "control.unreachable",
    "control.instance-in-use",
    "control.instance-not-found",
    "control.confirmation-required",
    "control.unreadable-state",
    "control.already-signed-in",
    "control.sign-in-failed",
    "control.cancelled",
    "control.failed",
)

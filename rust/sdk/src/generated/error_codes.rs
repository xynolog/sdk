// Generated from protocol/specs/src/errors/codes.json; do not edit.
// Regenerate: make generate (codegen/lib/error_codes/rust.ml)
/// Why a bus request did not resolve. Some members restate a failure the answering peer declared on the wire (`wire` names its `CommandError.code`); the rest are facts only the requesting side knows, which is why this vocabulary and the wire's stay separate.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum BusRequestErrorCode {
    /// No reply arrived within the time the request allowed.
    #[serde(rename = "bus.timeout")]
    Timeout,
    /// The peer answered with a failure that states no code, or one CommandError does not list, which is read as none.
    #[serde(rename = "bus.rejected")]
    Rejected,
    /// The bus stopped before a reply came: its client was disposed, or its transport closed.
    #[serde(rename = "bus.closed")]
    Closed,
    /// The peer says this resource does not exist in its knowledge base.
    #[serde(rename = "bus.not-found")]
    NotFound,
    /// THIS transport is not subscribed to the reply channel: a local misconfiguration, caught before emitting. Not to be confused with `bus.peer-unavailable`, which is the opposite end.
    #[serde(rename = "bus.unsubscribed")]
    Unsubscribed,
    /// The service that answers this channel is not connected. Transient by nature, a peer still starting, and therefore the one failure on this list worth retrying.
    #[serde(rename = "bus.peer-unavailable")]
    PeerUnavailable,
    /// The peer says this caller may not do what it asked: authenticated, not permitted. Retrying under the same credential cannot succeed, so a consumer surfaces it and never spins on it.
    #[serde(rename = "bus.unauthorized")]
    Unauthorized,
    /// The peer declined and nothing went wrong: a `job:claim` found no pending job of the requested types. The one member a consumer parks on.
    #[serde(rename = "bus.none-pending")]
    NonePending,
}

impl BusRequestErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [BusRequestErrorCode; 8] = [
        BusRequestErrorCode::Timeout,
        BusRequestErrorCode::Rejected,
        BusRequestErrorCode::Closed,
        BusRequestErrorCode::NotFound,
        BusRequestErrorCode::Unsubscribed,
        BusRequestErrorCode::PeerUnavailable,
        BusRequestErrorCode::Unauthorized,
        BusRequestErrorCode::NonePending,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            BusRequestErrorCode::Timeout => "bus.timeout",
            BusRequestErrorCode::Rejected => "bus.rejected",
            BusRequestErrorCode::Closed => "bus.closed",
            BusRequestErrorCode::NotFound => "bus.not-found",
            BusRequestErrorCode::Unsubscribed => "bus.unsubscribed",
            BusRequestErrorCode::PeerUnavailable => "bus.peer-unavailable",
            BusRequestErrorCode::Unauthorized => "bus.unauthorized",
            BusRequestErrorCode::NonePending => "bus.none-pending",
        }
    }
}

impl BusRequestErrorCode {
    /// The code a failure's own code (`CommandError.code`) becomes; one that states none is the table's `unrecognizedFailure`.
    pub fn of_wire(code: Option<crate::types::CommandErrorCode>) -> BusRequestErrorCode {
        match code {
            Some(crate::types::CommandErrorCode::PeerUnavailable) => {
                BusRequestErrorCode::PeerUnavailable
            }
            Some(crate::types::CommandErrorCode::NotFound) => BusRequestErrorCode::NotFound,
            Some(crate::types::CommandErrorCode::Unauthorized) => BusRequestErrorCode::Unauthorized,
            Some(crate::types::CommandErrorCode::NonePending) => BusRequestErrorCode::NonePending,
            None => BusRequestErrorCode::Rejected,
        }
    }

    /// The wire code a peer stated, when this code restates one: what a service answers its own caller with. A failure only this side knows states none.
    pub const fn wire(self) -> Option<crate::types::CommandErrorCode> {
        match self {
            BusRequestErrorCode::NotFound => Some(crate::types::CommandErrorCode::NotFound),
            BusRequestErrorCode::PeerUnavailable => {
                Some(crate::types::CommandErrorCode::PeerUnavailable)
            }
            BusRequestErrorCode::Unauthorized => Some(crate::types::CommandErrorCode::Unauthorized),
            BusRequestErrorCode::NonePending => Some(crate::types::CommandErrorCode::NonePending),
            _ => None,
        }
    }
}

/// Transport-neutral failure vocabulary. Every transport maps its native failures to one of these, so a routing layer matches on the code without knowing the wire kind. Over HTTP the mapping is by status: `status` is an exact status, `statusFrom` every status at or above it.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum TransportErrorCode {
    /// Authentication is required: the token is missing, expired, or refused. A refusal of `limitRefusals` refuses the token too (contract/TRANSPORT-CONTRACT.md § A refused credential), and is reported as this code with its own status.
    #[serde(rename = "unauthorized")]
    Unauthorized,
    /// Authenticated, and lacking permission.
    #[serde(rename = "forbidden")]
    Forbidden,
    /// The resource is missing.
    #[serde(rename = "not-found")]
    NotFound,
    /// A concurrent modification, a duplicate, or another conflict with current state.
    #[serde(rename = "conflict")]
    Conflict,
    /// The request is malformed.
    #[serde(rename = "bad-request")]
    BadRequest,
    /// The request is well formed and cannot be carried out as it stands: an `Idempotency-Key` used for two different requests. Sent again, it is refused again.
    #[serde(rename = "unprocessable")]
    Unprocessable,
    /// A limit refused it; the refusal's `Retry-After` says when to return.
    #[serde(rename = "rate-limited")]
    RateLimited,
    /// The gateway is unreachable, the network failed, or the server answered 5xx.
    #[serde(rename = "unavailable")]
    Unavailable,
    /// A failure no other member names.
    #[serde(rename = "error")]
    Error,
}

impl TransportErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [TransportErrorCode; 9] = [
        TransportErrorCode::Unauthorized,
        TransportErrorCode::Forbidden,
        TransportErrorCode::NotFound,
        TransportErrorCode::Conflict,
        TransportErrorCode::BadRequest,
        TransportErrorCode::Unprocessable,
        TransportErrorCode::RateLimited,
        TransportErrorCode::Unavailable,
        TransportErrorCode::Error,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            TransportErrorCode::Unauthorized => "unauthorized",
            TransportErrorCode::Forbidden => "forbidden",
            TransportErrorCode::NotFound => "not-found",
            TransportErrorCode::Conflict => "conflict",
            TransportErrorCode::BadRequest => "bad-request",
            TransportErrorCode::Unprocessable => "unprocessable",
            TransportErrorCode::RateLimited => "rate-limited",
            TransportErrorCode::Unavailable => "unavailable",
            TransportErrorCode::Error => "error",
        }
    }
}

impl TransportErrorCode {
    /// The code an HTTP status becomes.
    pub const fn of_status(status: u16) -> TransportErrorCode {
        match status {
            401 => TransportErrorCode::Unauthorized,
            403 => TransportErrorCode::Forbidden,
            404 => TransportErrorCode::NotFound,
            409 => TransportErrorCode::Conflict,
            400 => TransportErrorCode::BadRequest,
            422 => TransportErrorCode::Unprocessable,
            429 => TransportErrorCode::RateLimited,
            500.. => TransportErrorCode::Unavailable,
            _ => TransportErrorCode::Error,
        }
    }
}

/// Why a job its client follows ended without a result. A failure the queue will retry is not one of these: the job goes on, and its follower is told of the setback and keeps following.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum JobErrorCode {
    /// The job failed and will not be tried again: the failure its worker reported, or the one its status states.
    #[serde(rename = "job.failed")]
    Failed,
    /// The job was cancelled before it ended, as its status states. Nothing announces a cancellation: its follower learns of it when it asks for the job's status.
    #[serde(rename = "job.cancelled")]
    Cancelled,
    /// The job said nothing for longer than its follower allows. The follower has asked for that job to be cancelled.
    #[serde(rename = "job.stalled")]
    Stalled,
}

impl JobErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [JobErrorCode; 3] = [
        JobErrorCode::Failed,
        JobErrorCode::Cancelled,
        JobErrorCode::Stalled,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            JobErrorCode::Failed => "job.failed",
            JobErrorCode::Cancelled => "job.cancelled",
            JobErrorCode::Stalled => "job.stalled",
        }
    }
}

/// Why a session itself is unusable, or what its client keeps could not be kept or written. Per-request failures stay with their caller.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum SessionErrorCode {
    /// A session for the knowledge base could not be built or made ready.
    #[serde(rename = "session.construct-failed")]
    ConstructFailed,
    /// The stored credential could not be validated at startup, for a reason other than the gateway refusing it.
    #[serde(rename = "session.auth-failed")]
    AuthFailed,
    /// The session could not be renewed: the issuer refused, or stayed unreachable until the retry budget was spent. Not a prompt to retry: retrying already happened.
    #[serde(rename = "session.refresh-exhausted")]
    RefreshExhausted,
    /// The gateway refused a token the issuer had just issued. The two disagree about who may sign in, and renewing again cannot change the answer: the session is over, and signing in again is what is left.
    #[serde(rename = "session.credential-refused")]
    CredentialRefused,
    /// The sign-in the session holds could not be read before its client saved what it keeps, or could not record the person the gateway named, so it is not known to name the person that is kept for: the client keeps nothing more for the rest of its life. The session itself goes on, and says so once on its errors stream.
    #[serde(rename = "session.keep-failed")]
    KeepFailed,
    /// The storage refused a write of what the session's client keeps. The save stays owed: the client's next change, or its closing, writes it again, and what its closing cannot write is lost. The session says so on its errors stream once for each write the storage refuses, with what the storage said, a refusal of its closing among them, before the stream ends. The session itself goes on.
    #[serde(rename = "session.save-refused")]
    SaveRefused,
}

impl SessionErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [SessionErrorCode; 6] = [
        SessionErrorCode::ConstructFailed,
        SessionErrorCode::AuthFailed,
        SessionErrorCode::RefreshExhausted,
        SessionErrorCode::CredentialRefused,
        SessionErrorCode::KeepFailed,
        SessionErrorCode::SaveRefused,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            SessionErrorCode::ConstructFailed => "session.construct-failed",
            SessionErrorCode::AuthFailed => "session.auth-failed",
            SessionErrorCode::RefreshExhausted => "session.refresh-exhausted",
            SessionErrorCode::CredentialRefused => "session.credential-refused",
            SessionErrorCode::KeepFailed => "session.keep-failed",
            SessionErrorCode::SaveRefused => "session.save-refused",
        }
    }
}

/// Why a person could not be signed in at the issuer a knowledge base trusts, or a session could not be renewed there. Over the authorization-code grant, the device grant, the refresh grant and revocation alike.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum SignInErrorCode {
    /// The knowledge base trusts no external issuer: there is nowhere to sign in.
    #[serde(rename = "no-issuer")]
    NoIssuer,
    /// The knowledge base did not say which issuer it trusts, or the issuer did not describe itself, or described another issuer, or offers no endpoint the grant needs.
    #[serde(rename = "discovery")]
    Discovery,
    /// A sign-in response arrived and no sign-in is pending here: it was completed already, or begun somewhere else.
    #[serde(rename = "no-pending")]
    NoPending,
    /// The sign-in response does not belong to the pending sign-in.
    #[serde(rename = "state")]
    State,
    /// The person, or the issuer, refused the sign-in.
    #[serde(rename = "denied")]
    Denied,
    /// The device code ran out before it was approved.
    #[serde(rename = "expired")]
    Expired,
    /// The sign-in was abandoned by whoever began it.
    #[serde(rename = "aborted")]
    Aborted,
    /// The issuer refused a token request, a device authorization or a revocation, or answered without what was asked for.
    #[serde(rename = "exchange")]
    Exchange,
}

impl SignInErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [SignInErrorCode; 8] = [
        SignInErrorCode::NoIssuer,
        SignInErrorCode::Discovery,
        SignInErrorCode::NoPending,
        SignInErrorCode::State,
        SignInErrorCode::Denied,
        SignInErrorCode::Expired,
        SignInErrorCode::Aborted,
        SignInErrorCode::Exchange,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            SignInErrorCode::NoIssuer => "no-issuer",
            SignInErrorCode::Discovery => "discovery",
            SignInErrorCode::NoPending => "no-pending",
            SignInErrorCode::State => "state",
            SignInErrorCode::Denied => "denied",
            SignInErrorCode::Expired => "expired",
            SignInErrorCode::Aborted => "aborted",
            SignInErrorCode::Exchange => "exchange",
        }
    }
}

/// Why a knowledge base that was reached with a fresh sign-in could not be registered: it has to say who it is, and nothing stands in for its answer.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum IdentityUnverifiableReason {
    /// The knowledge base was not reached, so it said nothing.
    #[serde(rename = "unreachable")]
    Unreachable,
    /// The knowledge base answered that it cannot say what it is.
    #[serde(rename = "not-reported")]
    NotReported,
}

impl IdentityUnverifiableReason {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [IdentityUnverifiableReason; 2] = [
        IdentityUnverifiableReason::Unreachable,
        IdentityUnverifiableReason::NotReported,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            IdentityUnverifiableReason::Unreachable => "unreachable",
            IdentityUnverifiableReason::NotReported => "not-reported",
        }
    }
}

/// Why no annotation was built of a span: the span is not the text's, or, for a PDF, is nowhere on its pages, or the PDF's anchored text does not hold together. specs/src/annotations/builder-cases.json holds when each is given.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum SpanRefusal {
    /// The span's offsets are not two whole numbers from 0, the second no less than the first, within the text.
    #[serde(rename = "span-out-of-range")]
    SpanOutOfRange,
    /// The words the span states are not the text between its offsets.
    #[serde(rename = "exact-mismatch")]
    ExactMismatch,
    /// The prefix the span states is not the text just before it.
    #[serde(rename = "prefix-mismatch")]
    PrefixMismatch,
    /// The suffix the span states is not the text just after it.
    #[serde(rename = "suffix-mismatch")]
    SuffixMismatch,
    /// No item of the PDF's anchored text holds any of the span, so it is nowhere on a page.
    #[serde(rename = "nothing-located")]
    NothingLocated,
    /// The items of the PDF's anchored text that hold the span do not have its words.
    #[serde(rename = "exact-not-covered")]
    ExactNotCovered,
    /// An item of the PDF's anchored text is no stretch of that text: its offsets are not two whole numbers from 0, the second no less than the first, within the text. This one is said of the anchored text and not of the span: the items are what say where the text is on a page, and no span is built on an anchored text one of whose items cannot be.
    #[serde(rename = "item-out-of-range")]
    ItemOutOfRange,
}

impl SpanRefusal {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [SpanRefusal; 7] = [
        SpanRefusal::SpanOutOfRange,
        SpanRefusal::ExactMismatch,
        SpanRefusal::PrefixMismatch,
        SpanRefusal::SuffixMismatch,
        SpanRefusal::NothingLocated,
        SpanRefusal::ExactNotCovered,
        SpanRefusal::ItemOutOfRange,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            SpanRefusal::SpanOutOfRange => "span-out-of-range",
            SpanRefusal::ExactMismatch => "exact-mismatch",
            SpanRefusal::PrefixMismatch => "prefix-mismatch",
            SpanRefusal::SuffixMismatch => "suffix-mismatch",
            SpanRefusal::NothingLocated => "nothing-located",
            SpanRefusal::ExactNotCovered => "exact-not-covered",
            SpanRefusal::ItemOutOfRange => "item-out-of-range",
        }
    }
}

/// Why a request of the launcher's control API (`xynolog control`, contract/LAUNCHER-CONTROL.md) failed. The launcher sends one in each error's data, and Desktop reads it. A knowledge base never sends one.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, serde::Deserialize, serde::Serialize)]
pub enum ControlErrorCode {
    /// The request's params are not what its method's schema admits. The error's fields name each fault.
    #[serde(rename = "control.invalid-params")]
    InvalidParams,
    /// The request is written to a version of the control API this launcher does not speak. The error's supported field names the ones it does.
    #[serde(rename = "control.unsupported-api-version")]
    UnsupportedApiVersion,
    /// The launcher refuses the request as the command line refuses the same options: they contradict each other, or do not apply to what they name.
    #[serde(rename = "control.invalid-request")]
    InvalidRequest,
    /// The request names a service or a group the launcher has none of.
    #[serde(rename = "control.invalid-service")]
    InvalidService,
    /// The launcher refuses a setting's value, as a start would refuse it. The previous value is kept.
    #[serde(rename = "control.invalid-value")]
    InvalidValue,
    /// The request names a setting the launcher does not keep.
    #[serde(rename = "control.unknown-setting")]
    UnknownSetting,
    /// Several stacks could be meant and the request names none of them. The error's choices name each; nothing was done.
    #[serde(rename = "control.target-required")]
    TargetRequired,
    /// The root the request names is the basename of several registered roots. The error's choices name each by its path; nothing was done.
    #[serde(rename = "control.target-ambiguous")]
    TargetAmbiguous,
    /// The root the request names is not a knowledge base's clone: no such directory, no .xynolog/ in it, or a project file the launcher refuses.
    #[serde(rename = "control.root-not-found")]
    RootNotFound,
    /// The root the request names is not in the registry.
    #[serde(rename = "control.root-not-registered")]
    RootNotRegistered,
    /// The request needs a stack of its target recorded on this machine, and none is.
    #[serde(rename = "control.stack-not-running")]
    StackNotRunning,
    /// The request would change what a recorded stack depends on: stop the stack first.
    #[serde(rename = "control.stack-running")]
    StackRunning,
    /// Another xynolog start of the same knowledge base holds its start lock.
    #[serde(rename = "control.start-in-progress")]
    StartInProgress,
    /// No container runtime the request can use is on the launcher's PATH.
    #[serde(rename = "control.runtime-unavailable")]
    RuntimeUnavailable,
    /// A program the request needs besides a container runtime (gh, for a codespace) is not on the launcher's PATH.
    #[serde(rename = "control.dependency-unavailable")]
    DependencyUnavailable,
    /// What the request needs to reach did not answer: the knowledge base, its issuer, or a codespace's forward.
    #[serde(rename = "control.unreachable")]
    Unreachable,
    /// An instance of the name the run gives already runs on this machine for its target, whichever control server or command started it. Nothing was started.
    #[serde(rename = "control.instance-in-use")]
    InstanceInUse,
    /// No run of an instance of the name the request gives is in flight on this machine for its target: none was started, or its run has been answered.
    #[serde(rename = "control.instance-not-found")]
    InstanceNotFound,
    /// The request would destroy something, and does not state that a person confirmed it.
    #[serde(rename = "control.confirmation-required")]
    ConfirmationRequired,
    /// The launcher's own record of this machine (the stack record, the registry, the sign-in store) cannot be read. Nothing was assumed in its place.
    #[serde(rename = "control.unreadable-state")]
    UnreadableState,
    /// The launcher's stored session for the target is valid: there is nothing to sign in to.
    #[serde(rename = "control.already-signed-in")]
    AlreadySignedIn,
    /// The person was not signed in: the issuer refused or the code expired, the gateway refused the token, or the session could not be kept. Nothing was stored.
    #[serde(rename = "control.sign-in-failed")]
    SignInFailed,
    /// The client cancelled the request before it ended.
    #[serde(rename = "control.cancelled")]
    Cancelled,
    /// The request failed for a reason no other code names. Its message says why, as the command line would.
    #[serde(rename = "control.failed")]
    Failed,
}

impl ControlErrorCode {
    /// Every code of the vocabulary, in the table's order.
    pub const ALL: [ControlErrorCode; 24] = [
        ControlErrorCode::InvalidParams,
        ControlErrorCode::UnsupportedApiVersion,
        ControlErrorCode::InvalidRequest,
        ControlErrorCode::InvalidService,
        ControlErrorCode::InvalidValue,
        ControlErrorCode::UnknownSetting,
        ControlErrorCode::TargetRequired,
        ControlErrorCode::TargetAmbiguous,
        ControlErrorCode::RootNotFound,
        ControlErrorCode::RootNotRegistered,
        ControlErrorCode::StackNotRunning,
        ControlErrorCode::StackRunning,
        ControlErrorCode::StartInProgress,
        ControlErrorCode::RuntimeUnavailable,
        ControlErrorCode::DependencyUnavailable,
        ControlErrorCode::Unreachable,
        ControlErrorCode::InstanceInUse,
        ControlErrorCode::InstanceNotFound,
        ControlErrorCode::ConfirmationRequired,
        ControlErrorCode::UnreadableState,
        ControlErrorCode::AlreadySignedIn,
        ControlErrorCode::SignInFailed,
        ControlErrorCode::Cancelled,
        ControlErrorCode::Failed,
    ];

    /// The code as every SDK reports it.
    pub const fn as_str(self) -> &'static str {
        match self {
            ControlErrorCode::InvalidParams => "control.invalid-params",
            ControlErrorCode::UnsupportedApiVersion => "control.unsupported-api-version",
            ControlErrorCode::InvalidRequest => "control.invalid-request",
            ControlErrorCode::InvalidService => "control.invalid-service",
            ControlErrorCode::InvalidValue => "control.invalid-value",
            ControlErrorCode::UnknownSetting => "control.unknown-setting",
            ControlErrorCode::TargetRequired => "control.target-required",
            ControlErrorCode::TargetAmbiguous => "control.target-ambiguous",
            ControlErrorCode::RootNotFound => "control.root-not-found",
            ControlErrorCode::RootNotRegistered => "control.root-not-registered",
            ControlErrorCode::StackNotRunning => "control.stack-not-running",
            ControlErrorCode::StackRunning => "control.stack-running",
            ControlErrorCode::StartInProgress => "control.start-in-progress",
            ControlErrorCode::RuntimeUnavailable => "control.runtime-unavailable",
            ControlErrorCode::DependencyUnavailable => "control.dependency-unavailable",
            ControlErrorCode::Unreachable => "control.unreachable",
            ControlErrorCode::InstanceInUse => "control.instance-in-use",
            ControlErrorCode::InstanceNotFound => "control.instance-not-found",
            ControlErrorCode::ConfirmationRequired => "control.confirmation-required",
            ControlErrorCode::UnreadableState => "control.unreadable-state",
            ControlErrorCode::AlreadySignedIn => "control.already-signed-in",
            ControlErrorCode::SignInFailed => "control.sign-in-failed",
            ControlErrorCode::Cancelled => "control.cancelled",
            ControlErrorCode::Failed => "control.failed",
        }
    }
}

/// The line is not JSON, or holds more than one JSON value. Answered under a null id (F2).
pub const CONTROL_RPC_PARSE_ERROR: i32 = -32700;
/// The message is a batch, does not state `"jsonrpc": "2.0"` and a method, has a member JSON-RPC does not define, or its id is null, a fraction or one in flight. Answered under a null id (F2, F3).
pub const CONTROL_RPC_INVALID_REQUEST: i32 = -32600;
/// The API has no method of the request's name (F4).
pub const CONTROL_RPC_METHOD_NOT_FOUND: i32 = -32601;
/// The request's params are not what its method's schema admits, or are written to a version of the API this launcher does not speak (V1, P1).
pub const CONTROL_RPC_INVALID_PARAMS: i32 = -32602;
/// The launcher would send a result or error data that does not hold to its schema, or the handler panicked. Never retryable: the same request fails the same way (E4).
pub const CONTROL_RPC_INTERNAL_ERROR: i32 = -32603;
/// The operation the request ran failed. The data's code says why, and whether the request is retryable (E2).
pub const CONTROL_RPC_OPERATION_FAILED: i32 = -32000;

impl ControlErrorCode {
    /// The JSON-RPC code of control/rpc-codes.json an answer carries the code under.
    pub const fn rpc(self) -> i32 {
        match self {
            ControlErrorCode::InvalidParams => CONTROL_RPC_INVALID_PARAMS,
            ControlErrorCode::UnsupportedApiVersion => CONTROL_RPC_INVALID_PARAMS,
            ControlErrorCode::InvalidRequest => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::InvalidService => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::InvalidValue => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::UnknownSetting => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::TargetRequired => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::TargetAmbiguous => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::RootNotFound => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::RootNotRegistered => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::StackNotRunning => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::StackRunning => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::StartInProgress => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::RuntimeUnavailable => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::DependencyUnavailable => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::Unreachable => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::InstanceInUse => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::InstanceNotFound => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::ConfirmationRequired => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::UnreadableState => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::AlreadySignedIn => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::SignInFailed => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::Cancelled => CONTROL_RPC_OPERATION_FAILED,
            ControlErrorCode::Failed => CONTROL_RPC_OPERATION_FAILED,
        }
    }

    /// Whether the same request can succeed sent again unchanged, once something outside it changes: what `ErrorData::retryable` says of the code.
    pub const fn retryable(self) -> bool {
        match self {
            ControlErrorCode::InvalidParams => false,
            ControlErrorCode::UnsupportedApiVersion => false,
            ControlErrorCode::InvalidRequest => false,
            ControlErrorCode::InvalidService => false,
            ControlErrorCode::InvalidValue => false,
            ControlErrorCode::UnknownSetting => false,
            ControlErrorCode::TargetRequired => false,
            ControlErrorCode::TargetAmbiguous => false,
            ControlErrorCode::RootNotFound => false,
            ControlErrorCode::RootNotRegistered => false,
            ControlErrorCode::StackNotRunning => true,
            ControlErrorCode::StackRunning => true,
            ControlErrorCode::StartInProgress => true,
            ControlErrorCode::RuntimeUnavailable => true,
            ControlErrorCode::DependencyUnavailable => true,
            ControlErrorCode::Unreachable => true,
            ControlErrorCode::InstanceInUse => false,
            ControlErrorCode::InstanceNotFound => false,
            ControlErrorCode::ConfirmationRequired => false,
            ControlErrorCode::UnreadableState => true,
            ControlErrorCode::AlreadySignedIn => false,
            ControlErrorCode::SignInFailed => true,
            ControlErrorCode::Cancelled => false,
            ControlErrorCode::Failed => true,
        }
    }
}

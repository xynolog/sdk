// Generated from protocol/specs/src/errors/codes.json; do not edit.
// Regenerate: make generate (codegen/lib/error_codes/rust.ml)
/// Why a bus request did not resolve. Some members restate a failure the answering peer declared on the wire (`wire` names its `CommandError.code`); the rest are facts only the requesting side knows, which is why this vocabulary and the wire's stay separate.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BusRequestErrorCode {
    /// No reply arrived within the time the request allowed.
    Timeout,
    /// The peer answered with a failure that states no code, or one CommandError does not list, which is read as none.
    Rejected,
    /// The bus stopped before a reply came: its client was disposed, or its transport closed.
    Closed,
    /// The peer says this resource does not exist in its knowledge base.
    NotFound,
    /// THIS transport is not subscribed to the reply channel: a local misconfiguration, caught before emitting. Not to be confused with `bus.peer-unavailable`, which is the opposite end.
    Unsubscribed,
    /// The service that answers this channel is not connected. Transient by nature, a peer still starting, and therefore the one failure on this list worth retrying.
    PeerUnavailable,
    /// The peer says this caller may not do what it asked: authenticated, not permitted. Retrying under the same credential cannot succeed, so a consumer surfaces it and never spins on it.
    Unauthorized,
    /// The peer declined and nothing went wrong: a `job:claim` found no pending job of the requested types. The one member a consumer parks on.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum TransportErrorCode {
    /// Authentication is required: the token is missing, expired, or refused. A 429 whose `code` is `refusal-rate` refuses the token too, and is reported as this code with its own status.
    Unauthorized,
    /// Authenticated, and lacking permission.
    Forbidden,
    /// The resource is missing.
    NotFound,
    /// A concurrent modification, a duplicate, or another conflict with current state.
    Conflict,
    /// The request is malformed.
    BadRequest,
    /// The request is well formed and cannot be carried out as it stands: an `Idempotency-Key` used for two different requests. Sent again, it is refused again.
    Unprocessable,
    /// A limit refused it; the refusal's `Retry-After` says when to return.
    RateLimited,
    /// The gateway is unreachable, the network failed, or the server answered 5xx.
    Unavailable,
    /// A failure no other member names.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum JobErrorCode {
    /// The job failed and will not be tried again: the failure its worker reported, or the one its status states.
    Failed,
    /// The job was cancelled before it ended, as its status states. Nothing announces a cancellation: its follower learns of it when it asks for the job's status.
    Cancelled,
    /// The job said nothing for longer than its follower allows. The follower has asked for that job to be cancelled.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum SessionErrorCode {
    /// A session for the knowledge base could not be built or made ready.
    ConstructFailed,
    /// The stored credential could not be validated at startup, for a reason other than the gateway refusing it.
    AuthFailed,
    /// The session could not be renewed: the issuer refused, or stayed unreachable until the retry budget was spent. Not a prompt to retry: retrying already happened.
    RefreshExhausted,
    /// The gateway refused a token the issuer had just issued. The two disagree about who may sign in, and renewing again cannot change the answer: the session is over, and signing in again is what is left.
    CredentialRefused,
    /// The sign-in the session holds could not be read before its client saved what it keeps, or could not record the person the gateway named, so it is not known to name the person that is kept for: the client keeps nothing more for the rest of its life. The session itself goes on, and says so once on its errors stream.
    KeepFailed,
    /// The storage refused a write of what the session's client keeps. The save stays owed: the client's next change, or its closing, writes it again, and what its closing cannot write is lost. The session says so on its errors stream once for each write the storage refuses, with what the storage said, a refusal of its closing among them, before the stream ends. The session itself goes on.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum SignInErrorCode {
    /// The knowledge base trusts no external issuer: there is nowhere to sign in.
    NoIssuer,
    /// The knowledge base did not say which issuer it trusts, or the issuer did not describe itself, or described another issuer, or offers no endpoint the grant needs.
    Discovery,
    /// A sign-in response arrived and no sign-in is pending here: it was completed already, or begun somewhere else.
    NoPending,
    /// The sign-in response does not belong to the pending sign-in.
    State,
    /// The person, or the issuer, refused the sign-in.
    Denied,
    /// The device code ran out before it was approved.
    Expired,
    /// The sign-in was abandoned by whoever began it.
    Aborted,
    /// The issuer refused a token request, a device authorization or a revocation, or answered without what was asked for.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum IdentityUnverifiableReason {
    /// The knowledge base was not reached, so it said nothing.
    Unreachable,
    /// The knowledge base answered that it cannot say what it is.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum SpanRefusal {
    /// The span's offsets are not two whole numbers from 0, the second no less than the first, within the text.
    SpanOutOfRange,
    /// The words the span states are not the text between its offsets.
    ExactMismatch,
    /// The prefix the span states is not the text just before it.
    PrefixMismatch,
    /// The suffix the span states is not the text just after it.
    SuffixMismatch,
    /// No item of the PDF's anchored text holds any of the span, so it is nowhere on a page.
    NothingLocated,
    /// The items of the PDF's anchored text that hold the span do not have its words.
    ExactNotCovered,
    /// An item of the PDF's anchored text is no stretch of that text: its offsets are not two whole numbers from 0, the second no less than the first, within the text. This one is said of the anchored text and not of the span: the items are what say where the text is on a page, and no span is built on an anchored text one of whose items cannot be.
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum ControlErrorCode {
    /// The request's params are not what its method's schema admits. The error's fields name each fault; JSON-RPC's own invalid-params code (-32602) carries it.
    InvalidParams,
    /// The request is written to a version of the control API this launcher does not speak. The error's supported field names the ones it does.
    UnsupportedApiVersion,
    /// The launcher refuses the request as the command line refuses the same options: they contradict each other, or do not apply to what they name.
    InvalidRequest,
    /// The request names a service or a group the launcher has none of.
    InvalidService,
    /// The launcher refuses a setting's value, as a start would refuse it. The previous value is kept.
    InvalidValue,
    /// The request names a setting the launcher does not keep.
    UnknownSetting,
    /// Several stacks could be meant and the request names none of them. The error's choices name each; nothing was done.
    TargetRequired,
    /// The root the request names is the basename of several registered roots. The error's choices name each by its path; nothing was done.
    TargetAmbiguous,
    /// The root the request names is not a knowledge base's clone: no such directory, no .xynolog/ in it, or a project file the launcher refuses.
    RootNotFound,
    /// The root the request names is not in the registry.
    RootNotRegistered,
    /// The request needs a stack of its target recorded on this machine, and none is.
    StackNotRunning,
    /// The request would change what a recorded stack depends on: stop the stack first.
    StackRunning,
    /// Another xynolog start of the same knowledge base holds its start lock.
    StartInProgress,
    /// No container runtime the request can use is on the launcher's PATH.
    RuntimeUnavailable,
    /// A program the request needs besides a container runtime (gh, for a codespace) is not on the launcher's PATH.
    DependencyUnavailable,
    /// What the request needs to reach did not answer: the knowledge base, its issuer, or a codespace's forward.
    Unreachable,
    /// An instance of the name the run gives already runs on this machine for its target, whichever control server or command started it. Nothing was started.
    InstanceInUse,
    /// No run of an instance of the name the request gives is in flight on this machine for its target: none was started, or its run has been answered.
    InstanceNotFound,
    /// The request would destroy something, and does not state that a person confirmed it.
    ConfirmationRequired,
    /// The launcher's own record of this machine (the stack record, the registry, the sign-in store) cannot be read. Nothing was assumed in its place.
    UnreadableState,
    /// The launcher's stored session for the target is valid: there is nothing to sign in to.
    AlreadySignedIn,
    /// The person was not signed in: the issuer refused or the code expired, the gateway refused the token, or the session could not be kept. Nothing was stored.
    SignInFailed,
    /// The client cancelled the request before it ended.
    Cancelled,
    /// The request failed for a reason no other code names. Its message says why, as the command line would.
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

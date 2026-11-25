// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/errors/codes.json
// Regenerate:  make generate  (codegen/lib/error_codes/typescript.ml)

/** Why a bus request did not resolve. Some members restate a failure the answering peer declared on the wire (`wire` names its `CommandError.code`); the rest are facts only the requesting side knows, which is why this vocabulary and the wire's stay separate. */
export type BusRequestErrorCode =
  /** No reply arrived within the time the request allowed. */
  | 'bus.timeout'
  /** The peer answered with a failure that states no code, or one CommandError does not list, which is read as none. */
  | 'bus.rejected'
  /** The bus stopped before a reply came: its client was disposed, or its transport closed. */
  | 'bus.closed'
  /** The peer says this resource does not exist in its knowledge base. */
  | 'bus.not-found'
  /** THIS transport is not subscribed to the reply channel: a local misconfiguration, caught before emitting. Not to be confused with `bus.peer-unavailable`, which is the opposite end. */
  | 'bus.unsubscribed'
  /** The service that answers this channel is not connected. Transient by nature, a peer still starting, and therefore the one failure on this list worth retrying. */
  | 'bus.peer-unavailable'
  /** The peer says this caller may not do what it asked: authenticated, not permitted. Retrying under the same credential cannot succeed, so a consumer surfaces it and never spins on it. */
  | 'bus.unauthorized'
  /** The peer declined and nothing went wrong: a `job:claim` found no pending job of the requested types. The one member a consumer parks on. */
  | 'bus.none-pending';

/** The bus code a failure's own wire code (`CommandError.code`) becomes. */
export const busRequestCodeByWireCode = {
  'not-found': 'bus.not-found',
  'peer-unavailable': 'bus.peer-unavailable',
  unauthorized: 'bus.unauthorized',
  'none-pending': 'bus.none-pending',
} as const;

/** What a failure becomes when it states no code, or one CommandError does not list, which is read as none. */
export const unrecognizedFailureCode = 'bus.rejected' as const;

/** Transport-neutral failure vocabulary. Every transport maps its native failures to one of these, so a routing layer matches on the code without knowing the wire kind. Over HTTP the mapping is by status: `status` is an exact status, `statusFrom` every status at or above it. */
export type TransportErrorCode =
  /** Authentication is required: the token is missing, expired, or refused. A refusal of `limitRefusals` refuses the token too (contract/TRANSPORT-CONTRACT.md § A refused credential), and is reported as this code with its own status. */
  | 'unauthorized'
  /** Authenticated, and lacking permission. */
  | 'forbidden'
  /** The resource is missing. */
  | 'not-found'
  /** A concurrent modification, a duplicate, or another conflict with current state. */
  | 'conflict'
  /** The request is malformed. */
  | 'bad-request'
  /** The request is well formed and cannot be carried out as it stands: an `Idempotency-Key` used for two different requests. Sent again, it is refused again. */
  | 'unprocessable'
  /** A limit refused it; the refusal's `Retry-After` says when to return. */
  | 'rate-limited'
  /** The gateway is unreachable, the network failed, or the server answered 5xx. */
  | 'unavailable'
  /** A failure no other member names. */
  | 'error';

/** The transport code an HTTP status becomes. */
export function transportErrorCodeForStatus(
  status: number,
): TransportErrorCode {
  switch (status) {
    case 401:
      return 'unauthorized';
    case 403:
      return 'forbidden';
    case 404:
      return 'not-found';
    case 409:
      return 'conflict';
    case 400:
      return 'bad-request';
    case 422:
      return 'unprocessable';
    case 429:
      return 'rate-limited';
  }
  if (status >= 500) return 'unavailable';
  return 'error';
}

/** Each gateway refusal of a limit that is a transport code too: its status, its `LimitRefusal` code, and the transport code it is. */
export const limitRefusalTransportCodes = [
  { status: 429, code: 'refusal-rate', transport: 'unauthorized' },
] as const;

/** Why a job its client follows ended without a result. A failure the queue will retry is not one of these: the job goes on, and its follower is told of the setback and keeps following. */
export type JobErrorCode =
  /** The job failed and will not be tried again: the failure its worker reported, or the one its status states. */
  | 'job.failed'
  /** The job was cancelled before it ended, as its status states. Nothing announces a cancellation: its follower learns of it when it asks for the job's status. */
  | 'job.cancelled'
  /** The job said nothing for longer than its follower allows. The follower has asked for that job to be cancelled. */
  | 'job.stalled';

/** Why a session itself is unusable, or what its client keeps could not be kept or written. Per-request failures stay with their caller. */
export type XynologSessionErrorCode =
  /** A session for the knowledge base could not be built or made ready. */
  | 'session.construct-failed'
  /** The stored credential could not be validated at startup, for a reason other than the gateway refusing it. */
  | 'session.auth-failed'
  /** The session could not be renewed: the issuer refused, or stayed unreachable until the retry budget was spent. Not a prompt to retry: retrying already happened. */
  | 'session.refresh-exhausted'
  /** The gateway refused a token the issuer had just issued. The two disagree about who may sign in, and renewing again cannot change the answer: the session is over, and signing in again is what is left. */
  | 'session.credential-refused'
  /** The sign-in the session holds could not be read before its client saved what it keeps, or could not record the person the gateway named, so it is not known to name the person that is kept for: the client keeps nothing more for the rest of its life. The session itself goes on, and says so once on its errors stream. */
  | 'session.keep-failed'
  /** The storage refused a write of what the session's client keeps. The save stays owed: the client's next change, or its closing, writes it again, and what its closing cannot write is lost. The session says so on its errors stream once for each write the storage refuses, with what the storage said, a refusal of its closing among them, before the stream ends. The session itself goes on. */
  | 'session.save-refused';

/** Why a person could not be signed in at the issuer a knowledge base trusts, or a session could not be renewed there. Over the authorization-code grant, the device grant, the refresh grant and revocation alike. */
export type SignInErrorCode =
  /** The knowledge base trusts no external issuer: there is nowhere to sign in. */
  | 'no-issuer'
  /** The knowledge base did not say which issuer it trusts, or the issuer did not describe itself, or described another issuer, or offers no endpoint the grant needs. */
  | 'discovery'
  /** A sign-in response arrived and no sign-in is pending here: it was completed already, or begun somewhere else. */
  | 'no-pending'
  /** The sign-in response does not belong to the pending sign-in. */
  | 'state'
  /** The person, or the issuer, refused the sign-in. */
  | 'denied'
  /** The device code ran out before it was approved. */
  | 'expired'
  /** The sign-in was abandoned by whoever began it. */
  | 'aborted'
  /** The issuer refused a token request, a device authorization or a revocation, or answered without what was asked for. */
  | 'exchange';

/** Why a knowledge base that was reached with a fresh sign-in could not be registered: it has to say who it is, and nothing stands in for its answer. */
export type IdentityUnverifiableReason =
  /** The knowledge base was not reached, so it said nothing. */
  | 'unreachable'
  /** The knowledge base answered that it cannot say what it is. */
  | 'not-reported';

/** Why no annotation was built of a span: the span is not the text's, or, for a PDF, is nowhere on its pages, or the PDF's anchored text does not hold together. specs/src/annotations/builder-cases.json holds when each is given. */
export type SpanRefusal =
  /** The span's offsets are not two whole numbers from 0, the second no less than the first, within the text. */
  | 'span-out-of-range'
  /** The words the span states are not the text between its offsets. */
  | 'exact-mismatch'
  /** The prefix the span states is not the text just before it. */
  | 'prefix-mismatch'
  /** The suffix the span states is not the text just after it. */
  | 'suffix-mismatch'
  /** No item of the PDF's anchored text holds any of the span, so it is nowhere on a page. */
  | 'nothing-located'
  /** The items of the PDF's anchored text that hold the span do not have its words. */
  | 'exact-not-covered'
  /** An item of the PDF's anchored text is no stretch of that text: its offsets are not two whole numbers from 0, the second no less than the first, within the text. This one is said of the anchored text and not of the span: the items are what say where the text is on a page, and no span is built on an anchored text one of whose items cannot be. */
  | 'item-out-of-range';

/** Why a request of the launcher's control API (`xynolog control`, contract/LAUNCHER-CONTROL.md) failed. The launcher sends one in each error's data, and Desktop reads it. A knowledge base never sends one. */
export type ControlErrorCode =
  /** The request's params are not what its method's schema admits. The error's fields name each fault; JSON-RPC's own invalid-params code (-32602) carries it. */
  | 'control.invalid-params'
  /** The request is written to a version of the control API this launcher does not speak. The error's supported field names the ones it does. */
  | 'control.unsupported-api-version'
  /** The launcher refuses the request as the command line refuses the same options: they contradict each other, or do not apply to what they name. */
  | 'control.invalid-request'
  /** The request names a service or a group the launcher has none of. */
  | 'control.invalid-service'
  /** The launcher refuses a setting's value, as a start would refuse it. The previous value is kept. */
  | 'control.invalid-value'
  /** The request names a setting the launcher does not keep. */
  | 'control.unknown-setting'
  /** Several stacks could be meant and the request names none of them. The error's choices name each; nothing was done. */
  | 'control.target-required'
  /** The root the request names is the basename of several registered roots. The error's choices name each by its path; nothing was done. */
  | 'control.target-ambiguous'
  /** The root the request names is not a knowledge base's clone: no such directory, no .xynolog/ in it, or a project file the launcher refuses. */
  | 'control.root-not-found'
  /** The root the request names is not in the registry. */
  | 'control.root-not-registered'
  /** The request needs a stack of its target recorded on this machine, and none is. */
  | 'control.stack-not-running'
  /** The request would change what a recorded stack depends on: stop the stack first. */
  | 'control.stack-running'
  /** Another xynolog start of the same knowledge base holds its start lock. */
  | 'control.start-in-progress'
  /** No container runtime the request can use is on the launcher's PATH. */
  | 'control.runtime-unavailable'
  /** A program the request needs besides a container runtime (gh, for a codespace) is not on the launcher's PATH. */
  | 'control.dependency-unavailable'
  /** What the request needs to reach did not answer: the knowledge base, its issuer, or a codespace's forward. */
  | 'control.unreachable'
  /** An instance of the name the run gives already runs on this machine for its target, whichever control server or command started it. Nothing was started. */
  | 'control.instance-in-use'
  /** No run of an instance of the name the request gives is in flight on this machine for its target: none was started, or its run has been answered. */
  | 'control.instance-not-found'
  /** The request would destroy something, and does not state that a person confirmed it. */
  | 'control.confirmation-required'
  /** The launcher's own record of this machine (the stack record, the registry, the sign-in store) cannot be read. Nothing was assumed in its place. */
  | 'control.unreadable-state'
  /** The launcher's stored session for the target is valid: there is nothing to sign in to. */
  | 'control.already-signed-in'
  /** The person was not signed in: the issuer refused or the code expired, the gateway refused the token, or the session could not be kept. Nothing was stored. */
  | 'control.sign-in-failed'
  /** The client cancelled the request before it ended. */
  | 'control.cancelled'
  /** The request failed for a reason no other code names. Its message says why, as the command line would. */
  | 'control.failed';

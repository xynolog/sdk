using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.Errors;

/// <summary>The base of every error the SDK throws, which carries the protocol's code for the failure.</summary>
public abstract class XynologError : Exception
{
    /// <summary>How many of what a stream says before anyone reads it are kept for its first reader: a session's errors, a
    /// transport's failures, a registry's own errors, and a worker's claim refusals and stalls.</summary>
    internal static readonly int KeptForFirstReader = Timings.ErrorsKeptForFirstReaderCount;

    private protected XynologError(string code, string message, int? status = null, Exception? inner = null) : base(message, inner)
    {
        Code = code;
        Status = status;
    }

    /// <summary>The protocol's code for the failure, which a caller can branch on.</summary>
    public string Code { get; }
    /// <summary>The HTTP status the failure was answered with, when one was.</summary>
    public int? Status { get; }
}

/// <summary>Thrown when a bus request is answered on its operation's failure channel, in that answer's own
/// words.</summary>
public sealed class BusRequestError(string code, string message) : XynologError(code, message);

/// <summary>Thrown when the gateway cannot be reached, does not answer in time, refuses a request, or answers with what
/// the protocol does not allow.</summary>
public sealed class TransportError(string code, string message, int? status = null, Exception? inner = null) : XynologError(code, message, status, inner);

/// <summary>Thrown when signing in, or renewing a credential, fails.</summary>
public sealed class SignInError(string code, string message, int? status = null, Exception? inner = null) : XynologError(code, message, status, inner);

/// <summary>Thrown when a session to a knowledge base cannot be opened or kept.</summary>
public sealed class SessionError(string code, string message, Exception? inner = null) : XynologError(code, message, inner: inner);

/// <summary>Thrown when a job a caller follows fails, stalls or is cancelled.</summary>
public sealed class JobError : XynologError
{
    internal JobError(string code, string message, JobId? jobId, FailureClass? failureClass = null) : base(code, message)
    {
        JobId = jobId;
        FailureClass = failureClass;
    }

    /// <summary>The job that failed, when the failure is one job's.</summary>
    public JobId? JobId { get; }
    /// <summary>Whether the job's failure is transient or permanent, when the job stated it.</summary>
    public FailureClass? FailureClass { get; }
}

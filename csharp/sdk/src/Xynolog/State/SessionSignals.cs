using Xynolog.Types;

namespace Xynolog.State;

/// <summary>Notices for the host. Raising the same notice twice is observable twice.</summary>
public sealed class SessionSignals : IStateUnit
{
    /// <summary>The notice that the session ended and why, until it is acknowledged.</summary>
    public StateValue<SessionEnded?> SessionEnded { get; } = new(null);
    /// <summary>The notice that the knowledge base refused an action, until it is acknowledged.</summary>
    public StateValue<PermissionDenied?> PermissionDenied { get; } = new(null);
    /// <summary>The notice that the knowledge base answered under another identity than the one expected, until it is
    /// acknowledged.</summary>
    public StateValue<KbIdentityConflict?> KbIdentityConflict { get; } = new(null);

    /// <summary>Raises the notice that the session ended for the reason given.</summary>
    public void NotifySessionEnded(SessionEndReason reason) => SessionEnded.Set(new SessionEnded { Reason = reason }, repeat: true);
    /// <summary>Raises the notice that the knowledge base refused an action, with its detail when it gave one.</summary>
    public void NotifyPermissionDenied(string? detail) => PermissionDenied.Set(new PermissionDenied { Detail = detail }, repeat: true);
    /// <summary>Raises the notice that the knowledge base answered under another identity than the one expected.</summary>
    public void NotifyKbIdentityConflict(KbIdentityConflict conflict) => KbIdentityConflict.Set(conflict, repeat: true);
    /// <summary>Clears the session-ended notice.</summary>
    public void AcknowledgeSessionEnded() => SessionEnded.Set(null, repeat: true);
    /// <summary>Clears the permission-denied notice.</summary>
    public void AcknowledgePermissionDenied() => PermissionDenied.Set(null, repeat: true);
    /// <summary>Clears the knowledge-base identity notice.</summary>
    public void AcknowledgeKbIdentityConflict() => KbIdentityConflict.Set(null, repeat: true);

    /// <inheritdoc/>
    public void Dispose()
    {
        SessionEnded.Close();
        PermissionDenied.Close();
        KbIdentityConflict.Close();
    }
}

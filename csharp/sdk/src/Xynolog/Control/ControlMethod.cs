namespace Xynolog.Control;

/// <summary>
/// A method of the launcher's control API: a request whose params are a <typeparamref name="TParams"/>, answered with a
/// <typeparamref name="TResult"/>. Each is a property of <see cref="ControlMethods"/>.
/// </summary>
/// <param name="Name">The method as a request names it.</param>
/// <param name="Exclusive">Whether a request of it waits for every other exclusive request to end, and holds the others off until it does.</param>
/// <param name="Sends">The notifications a request of it may send besides progress, which any may.</param>
public sealed record ControlMethod<TParams, TResult>(string Name, bool Exclusive, IReadOnlyList<string> Sends);

/// <summary>
/// A notification of the launcher's control API, whose params are a <typeparamref name="TParams"/>. Each is a
/// property of <see cref="ControlMethods"/>.
/// </summary>
/// <param name="Name">The notification as its message names it.</param>
/// <param name="From">Who sends it.</param>
public sealed record ControlNotification<TParams>(string Name, ControlSender From);

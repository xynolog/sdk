using Xynolog.Protocol;

namespace Xynolog.SignIn;

internal static class SignInPolicy
{
    internal static string Scope => ProtocolTables.SessionOauth.Scopes.Value;
    internal static string BrowserClientId => ClientId("browser");
    internal static string ScriptClientId => ClientId("script");
    private static string ClientId(string name) => ProtocolTables.SessionOauth.Clients.Single(client => client.Name == name).Id;
}

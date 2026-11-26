using System.Runtime.Versioning;
using System.Security.AccessControl;
using System.Security.Principal;
using Xynolog.Protocol;

namespace Xynolog.SignIn;

internal static class StorePermissions
{
    internal static UnixFileMode DirectoryMode => (UnixFileMode)Convert.ToInt32(ProtocolTables.SignInStoreOwnerOnly.DirectoryMode.Value, 8);
    internal static UnixFileMode FileMode => (UnixFileMode)Convert.ToInt32(ProtocolTables.SignInStoreOwnerOnly.FileMode.Value, 8);

    internal static void CreateDirectory(string path)
    {
        if (OperatingSystem.IsWindows()) Directory.CreateDirectory(path);
        else Directory.CreateDirectory(path, DirectoryMode);
    }

    internal static void Keep(string path)
    {
        if (OperatingSystem.IsWindows()) KeepWindows(path);
        else File.SetUnixFileMode(path, DirectoryMode);
    }

    [SupportedOSPlatform("windows")]
    private static void KeepWindows(string path)
    {
        using var user = WindowsIdentity.GetCurrent();
        var sid = user.User?.Value ?? throw new IOException("The writer has no Windows identity");
        var stated = ProtocolTables.SignInStoreOwnerOnly.DirectoryAccessList.Value;
        var target = new DirectorySecurity();
        target.SetSecurityDescriptorSddlForm(stated.Replace("{owner}", sid, StringComparison.Ordinal));
        var directory = new DirectoryInfo(path);
        var current = directory.GetAccessControl(AccessControlSections.Access);
        static HashSet<string> Rules(DirectorySecurity security) => security.GetAccessRules(true, true, typeof(SecurityIdentifier)).Cast<FileSystemAccessRule>()
            .Select(rule => $"{rule.IdentityReference.Value}:{rule.AccessControlType}:{(uint)rule.FileSystemRights}:{rule.InheritanceFlags}:{rule.PropagationFlags}:{rule.IsInherited}").ToHashSet(StringComparer.Ordinal);
        if (!current.AreAccessRulesProtected || !Rules(current).SetEquals(Rules(target))) directory.SetAccessControl(target);
    }
}

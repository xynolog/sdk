using System.Text.Json;
using Xunit;
using Xynolog.Control;

namespace Xynolog.Tests;

public sealed class ControlMethodsTests
{
    private static string Schema(JsonElement entry, string member) =>
        Path.GetFileNameWithoutExtension(entry.GetProperty(member).GetString() ?? throw new InvalidOperationException(member + " names no schema."));

    private static string Named(JsonElement entry) =>
        entry.GetProperty("name").GetString() ?? throw new InvalidOperationException("A control entry has no name.");

    [Fact]
    public void EveryMethodAndNotificationIsTheOneProtocolStates()
    {
        using var document = JsonDocument.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "specs/control/methods.json")));
        var methods = document.RootElement.GetProperty("methods").EnumerateArray().ToDictionary(Named);
        var notifications = document.RootElement.GetProperty("notifications").EnumerateArray().ToDictionary(Named);
        var seenMethods = new HashSet<string>();
        var seenNotifications = new HashSet<string>();
        foreach (var property in typeof(ControlMethods).GetProperties())
        {
            var value = property.GetValue(null) ?? throw new InvalidOperationException(property.Name + " is null.");
            var type = value.GetType();
            var arguments = type.GetGenericArguments().Select(argument => argument.Name).ToArray();
            if (type.GetGenericTypeDefinition() == typeof(ControlMethod<,>))
            {
                var name = (string)type.GetProperty(nameof(ControlMethod<object, object>.Name))!.GetValue(value)!;
                var stated = methods[name];
                Assert.True(seenMethods.Add(name));
                Assert.Equal<string>(new[] { Schema(stated, "params"), Schema(stated, "result") }, arguments);
                Assert.Equal(stated.GetProperty("exclusive").GetBoolean(), (bool)type.GetProperty(nameof(ControlMethod<object, object>.Exclusive))!.GetValue(value)!);
                Assert.Equal<string>(
                    stated.GetProperty("sends").EnumerateArray().Select(sent => sent.GetString() ?? throw new InvalidOperationException(name + " sends no name.")),
                    (IReadOnlyList<string>)type.GetProperty(nameof(ControlMethod<object, object>.Sends))!.GetValue(value)!);
            }
            else
            {
                Assert.Equal(typeof(ControlNotification<>), type.GetGenericTypeDefinition());
                var name = (string)type.GetProperty(nameof(ControlNotification<object>.Name))!.GetValue(value)!;
                var stated = notifications[name];
                Assert.True(seenNotifications.Add(name));
                Assert.Equal<string>(new[] { Schema(stated, "params") }, arguments);
                var from = (ControlSender)type.GetProperty(nameof(ControlNotification<object>.From))!.GetValue(value)!;
                Assert.Equal(stated.GetProperty("from").GetString(), from.ToString().ToLowerInvariant());
            }
        }
        Assert.Equal<string>(methods.Keys.Order(), seenMethods.Order());
        Assert.Equal<string>(notifications.Keys.Order(), seenNotifications.Order());
    }
}

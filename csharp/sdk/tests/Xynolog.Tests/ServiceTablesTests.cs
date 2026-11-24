using System.Reflection;
using System.Text.Json;
using Xynolog.Services;
using Xunit;

namespace Xynolog.Tests;

public sealed class ServiceTablesTests
{
    private static readonly string[] HttpMethods = ["get", "put", "post", "delete", "patch", "head", "options", "trace"];

    [Fact]
    public void EachServiceTableReadsAsItsSchemasType()
    {
        var tables = typeof(ServiceTables).GetProperties(BindingFlags.Public | BindingFlags.Static);
        Assert.NotEmpty(tables);
        foreach (var table in tables)
            Assert.NotNull(table.GetValue(null));
    }

    [Fact]
    public void ArchivistRoutesAreEveryOperationOfItsSurface()
    {
        var directory = Path.Join(AppContext.BaseDirectory, "specs/archivist");
        using var document = JsonDocument.Parse(File.ReadAllText(Path.Join(directory, "openapi.json")));
        var stated = new List<(string, string)>();
        foreach (var path in document.RootElement.GetProperty("paths").EnumerateObject())
        {
            var item = path.Value.GetProperty("$ref").GetString() ?? throw new InvalidOperationException(path.Name + " names no path item");
            using var operations = JsonDocument.Parse(File.ReadAllText(Path.Join(directory, item)));
            foreach (var method in operations.RootElement.EnumerateObject().Where(member => HttpMethods.Contains(member.Name)))
                stated.Add((method.Name.ToUpperInvariant(), path.Name));
        }
        var routes = typeof(ArchivistRoutes).GetProperties(BindingFlags.Public | BindingFlags.Static)
            .Select(property => (ServiceRoute)(property.GetValue(null) ?? throw new InvalidOperationException(property.Name + " is null")))
            .Select(route => (route.Method.Method, route.Path));
        Assert.Equal(stated.Order(), routes.Order());
    }
}

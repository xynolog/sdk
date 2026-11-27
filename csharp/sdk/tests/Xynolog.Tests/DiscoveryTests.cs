using System.Net;
using System.Net.Http.Headers;
using System.Text;
using Xunit;
using Xynolog.Discovery;
using Xynolog.Types;

namespace Xynolog.Tests;

public sealed partial class TransportTests
{
    [Theory]
    [InlineData("{", DiscoveryAbsentReason.NotJson)]
    [InlineData("[]", DiscoveryAbsentReason.Invalid)]
    [InlineData("{\"version\":2,\"kbs\":[]}", DiscoveryAbsentReason.UnsupportedVersion)]
    [InlineData("{\"version\":1,\"kbs\":[{\"host\":\"localhost\",\"port\":1}]}", DiscoveryAbsentReason.Invalid)]
    [InlineData("{\"version\":1,\"kbs\":[{\"host\":\"localhost\",\"port\":0,\"placement\":\"local\",\"did\":\"did:web:a.test\",\"managedBy\":\"launcher\"}]}", DiscoveryAbsentReason.Invalid)]
    public void DiscoveryRejectsAnEntireInvalidDocument(string text, DiscoveryAbsentReason reason) =>
        Assert.Equal(reason, Assert.IsType<DiscoveryState.DiscoveryAbsent>(LauncherDiscovery.ParseDiscoveryDocument(text)).Value.Reason);

    [Fact]
    public void DiscoveryIntervalIsTheSharedOne()
    {
        using var timings = ReadSpec("client/timing.json");
        Assert.Equal(timings.RootElement.GetProperty("timing").EnumerateArray().Single(row => Text(row, "name") == "discoveryIntervalMs")
            .GetProperty("value").GetInt32(), LauncherDiscovery.DiscoveryInterval.TotalMilliseconds);
        Assert.Empty(Assert.IsType<DiscoveryState.DiscoveryManaged>(LauncherDiscovery.ParseDiscoveryDocument("""{"version":1,"kbs":[]}""")).Value.Kbs);
    }

    [Fact]
    public async Task HttpDiscoveryOnlyReusesTagsForDocumentsItCanRead()
    {
        using var server = new Handler();
        using var http = new HttpClient(server);
        var read = 0;
        server.Other = (request, _) =>
        {
            var step = ++read;
            Assert.Equal(step is 2 or 3 ? "\"known\"" : null, request.Headers.IfNoneMatch.SingleOrDefault()?.Tag);
            var response = step switch
            {
                2 => new HttpResponseMessage(HttpStatusCode.NotModified),
                3 => new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("{}", Encoding.UTF8, "application/json") },
                _ => new HttpResponseMessage(HttpStatusCode.OK) { Content = new StringContent("""{"version":1,"kbs":[]}""", Encoding.UTF8, "application/json") },
            };
            response.Headers.ETag = new EntityTagHeaderValue(step == 3 ? "\"bad\"" : "\"known\"");
            return Task.FromResult(response);
        };
        var discovery = LauncherDiscovery.HttpDiscovery("https://launcher.test" + LauncherDiscovery.DiscoveryUrlPath, http);
        Assert.IsType<DiscoveryRead.DiscoveryManaged>(await discovery.ReadAsync());
        Assert.IsType<DiscoveryRead.DiscoveryUnchanged>(await discovery.ReadAsync());
        Assert.Equal(DiscoveryAbsentReason.Invalid, Assert.IsType<DiscoveryRead.DiscoveryAbsent>(await discovery.ReadAsync()).Value.Reason);
        Assert.IsType<DiscoveryRead.DiscoveryManaged>(await discovery.ReadAsync());
    }

    [Fact]
    public async Task DiscoverySubscriptionSkipsUnchangedReadsAndTellsAbsentFromEmpty()
    {
        var clock = new TestClock();
        var period = TimeSpan.FromSeconds(2);
        using var deadline = new CancellationTokenSource(TimeSpan.FromSeconds(10));
        var discovery = new ScriptedDiscovery(new DiscoveryRead.DiscoveryUnchanged(new DiscoveryUnchanged()),
            new DiscoveryRead.DiscoveryAbsent(new DiscoveryAbsent { Reason = DiscoveryAbsentReason.NotFound }),
            new DiscoveryRead.DiscoveryManaged(new DiscoveryManaged { Kbs = [] }));
        await using var events = LauncherDiscovery.SubscribeDiscovery(discovery, period, clock).GetAsyncEnumerator(deadline.Token);
        var first = events.MoveNextAsync().AsTask();
        await clock.WaitForAsync(period);
        Assert.False(first.IsCompleted);
        clock.Advance(period);
        Assert.True(await first);
        Assert.IsType<DiscoveryState.DiscoveryAbsent>(events.Current.State);
        var second = events.MoveNextAsync().AsTask();
        await clock.WaitForAsync(period);
        clock.Advance(period);
        Assert.True(await second);
        Assert.Empty(Assert.IsType<DiscoveryState.DiscoveryManaged>(events.Current.State).Value.Kbs);
    }

    private sealed class ScriptedDiscovery(params DiscoveryRead[] answers) : DiscoveryTransport
    {
        private int next;
        public Task<DiscoveryRead> ReadAsync(CancellationToken cancellation = default) => Task.FromResult(answers[next++]);
    }

    [Fact]
    public void DiscoveryUsesAddressesAndReportsEveryClaimant()
    {
        var read = Assert.IsType<DiscoveryState.DiscoveryManaged>(LauncherDiscovery.ParseDiscoveryDocument("""
            {"version":1,"kbs":[
              {"host":"localhost","port":4110,"placement":"local","did":"did:web:shared.test","managedBy":"launcher"},
              {"host":"localhost","port":4111,"placement":"codespace","did":"did:web:shared.test","managedBy":"launcher"},
              {"host":"localhost","port":4111,"placement":"codespace","did":"did:web:other.test","managedBy":"launcher"}
            ]}
            """));
        var first = Assert.IsType<DiscoveryDiff>(LauncherDiscovery.Difference(null, read));
        Assert.Equal(3, first.Added.Count);
        Assert.Equal("localhost:4111", Assert.Single(first.Duplicated));
        Assert.Null(LauncherDiscovery.Difference(read, new DiscoveryState.DiscoveryManaged(new DiscoveryManaged { Kbs = read.Value.Kbs.Reverse().ToArray() })));
        var absent = Assert.IsType<DiscoveryDiff>(LauncherDiscovery.Difference(read,
            new DiscoveryState.DiscoveryAbsent(new DiscoveryAbsent { Reason = DiscoveryAbsentReason.NotFound })));
        Assert.Equal(3, absent.Removed.Count);
        Assert.IsType<DiscoveryState.DiscoveryAbsent>(absent.State);
    }
}

using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using Xynolog;

public static class NameKnowledgeBase
{
    public static async Task<string> RunAsync(string endpoint, string token,
        HttpClient? http = null, CancellationToken cancellation = default)
    {
        using var client = new XynologClient(endpoint, token, http);
        var kb = await client.Browse.KbAsync(cancellation);
        return kb.Name;
    }
}

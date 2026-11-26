using System.Text;
using Xynolog.Protocol;
using Xynolog.Serialization;
using Xynolog.Types;

namespace Xynolog;

internal static class MediaTypes
{
    private const string PlainText = "text/plain";
    private static readonly Dictionary<string, MediaTypesRegistryMediaTypesItem> Rows = ProtocolTables.MediaTypesRegistry.MediaTypes
        .ToDictionary(row => WireEnumConverter<SupportedMediaType>.Wire(row.MediaType), StringComparer.Ordinal);

    internal static string Base(string format) => format.AsSpan().SplitAtSemicolon().Trim().ToString().ToLowerInvariant();

    internal static string TextSource(string format)
    {
        var media = Base(format);
        return Rows.TryGetValue(media, out var row) ? row.TextSource :
            media.StartsWith("text/", StringComparison.Ordinal) ? "decode" : "none";
    }

    internal static string CloneFormat(string? format)
    {
        var media = format is null ? PlainText : Base(format);
        return Rows.TryGetValue(media, out var row) && row.Authorable ? media : PlainText;
    }

    internal static string StorageFileName(string name, string format)
    {
        var slug = new StringBuilder();
        var separated = true;
        foreach (var character in name.ToLowerInvariant())
        {
            if (char.IsAsciiLetterOrDigit(character))
            {
                if (separated && slug.Length > 0) slug.Append('-');
                slug.Append(character);
                separated = false;
            }
            else separated = true;
        }
        var extension = Rows.TryGetValue(Base(format), out var row) ? row.Extension : ".dat";
        return slug.Append(extension).ToString();
    }

    internal static ReadOnlySpan<char> SplitAtSemicolon(this ReadOnlySpan<char> value)
    {
        var end = value.IndexOf(';');
        return end < 0 ? value : value[..end];
    }
}

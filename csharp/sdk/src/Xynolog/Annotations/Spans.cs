using System.Text;
using Xynolog.Types;

namespace Xynolog.Annotations;

internal sealed class ScalarText(Rune[] points)
{
    internal ScalarText(string text) : this(text.EnumerateRunes().ToArray()) { }

    internal Rune[] Points { get; } = points;
    internal int Length => Points.Length;

    internal string Slice(int start, int end)
    {
        var result = new StringBuilder(end - start);
        Span<char> buffer = stackalloc char[2];
        foreach (var rune in Points.AsSpan(start, end - start))
            result.Append(buffer[..rune.EncodeToUtf16(buffer)]);
        return result.ToString();
    }

    internal IEnumerable<int> Places(ScalarText exact)
    {
        if (exact.Length == 0) yield break;
        for (var at = 0; at <= Length - exact.Length; at++)
            if (Points.AsSpan(at, exact.Length).SequenceEqual(exact.Points)) yield return at;
    }

    internal bool Contains(string text) => Places(new ScalarText(text)).Any();

    internal static string Collapse(string text)
    {
        var result = new StringBuilder();
        var space = false;
        Span<char> encoded = stackalloc char[2];
        foreach (var point in text.EnumerateRunes())
        {
            if (Rune.IsWhiteSpace(point)) { space = result.Length > 0; continue; }
            if (space) result.Append(' ');
            result.Append(encoded[..point.EncodeToUtf16(encoded)]);
            space = false;
        }
        return result.ToString();
    }
}

public static partial class AnnotationTools
{
    /// <summary>Finds where <paramref name="quoted"/> lies in <paramref name="text"/>: a unique match, a match its
    /// prefix or suffix picks out of several, the first of several, or a normalized, case-insensitive or fuzzy match;
    /// null when the quote is blank or nothing near it is found.</summary>
    public static ReconciledSpan? Reconcile(string text, QuotedText quoted)
    {
        if (string.IsNullOrWhiteSpace(quoted.Exact)) return null;
        var whole = new ScalarText(text);
        var exact = new ScalarText(quoted.Exact);
        var places = whole.Places(exact).Select(at => (Start: at, End: at + exact.Length)).ToArray();
        if (places.Length == 1) return UniqueMatch(Own(whole, places[0]));
        if (places.Length > 1)
        {
            var recovered = Hinted(whole, places, quoted);
            return recovered.HasValue ? ContextRecovered(Own(whole, recovered.Value)) : FirstOfMany(Own(whole, places[0]));
        }
        return ChangedMatch(whole, exact, quoted, Normalize, MatchQuality.Normalized)
            ?? ChangedMatch(whole, exact, quoted, Lower, MatchQuality.CaseInsensitive)
            ?? (Nearest(whole, exact) is { } near ? FuzzyMatch(Own(whole, near), MatchQuality.Fuzzy) : null);
    }

    private static ReconciledSpan? ChangedMatch(ScalarText whole, ScalarText exact, QuotedText quoted,
        Func<ScalarText, ChangedText> change, MatchQuality quality)
    {
        var transformed = change(whole);
        var wanted = change(exact).Text;
        var places = transformed.Text.Places(wanted)
            .Select(at => (Start: transformed.From[at], End: transformed.From[at + wanted.Length - 1] + 1)).ToArray();
        return places.Length == 0 ? null : FuzzyMatch(Own(whole, Hinted(whole, places, quoted) ?? places[0]), quality);
    }

    private static (int Start, int End)? Hinted(ScalarText text, (int Start, int End)[] places, QuotedText quote)
    {
        var prefix = quote.Prefix?.Trim();
        var suffix = quote.Suffix?.Trim();
        if (string.IsNullOrEmpty(prefix) && string.IsNullOrEmpty(suffix)) return null;
        var before = Math.Max(32, quote.Prefix?.EnumerateRunes().Count() ?? 0);
        var after = Math.Max(32, quote.Suffix?.EnumerateRunes().Count() ?? 0);
        foreach (var place in places)
        {
            if (!string.IsNullOrEmpty(prefix) &&
                !new ScalarText(text.Slice(Math.Max(0, place.Start - before), place.Start)).Contains(prefix)) continue;
            if (!string.IsNullOrEmpty(suffix) &&
                !new ScalarText(text.Slice(place.End, Math.Min(text.Length, place.End + after))).Contains(suffix)) continue;
            return place;
        }
        return null;
    }

    private static TextSpan Own(ScalarText text, (int Start, int End) place)
    {
        var begin = Math.Max(0, place.Start - 64);
        var first = Math.Max(0, begin - 32);
        while (begin > first && !Boundary(text.Points[begin - 1])) begin--;
        var end = Math.Min(text.Length, place.End + 64);
        var last = Math.Min(text.Length, end + 32);
        while (end < last && !Boundary(text.Points[end])) end++;
        return new TextSpan
        {
            Start = place.Start,
            End = place.End,
            Exact = text.Slice(place.Start, place.End),
            Prefix = place.Start == 0 ? null : text.Slice(begin, place.Start),
            Suffix = place.End == text.Length ? null : text.Slice(place.End, end),
        };
    }

    private static ReconciledSpan UniqueMatch(TextSpan span) =>
        new ReconciledSpan.UniqueMatch(new ReconciledSpanUniqueMatch { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix });

    private static ReconciledSpan ContextRecovered(TextSpan span) =>
        new ReconciledSpan.ContextRecovered(new ReconciledSpanContextRecovered { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix });

    private static ReconciledSpan FirstOfMany(TextSpan span) =>
        new ReconciledSpan.FirstOfMany(new ReconciledSpanFirstOfMany { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix });

    private static ReconciledSpan FuzzyMatch(TextSpan span, MatchQuality quality) =>
        new ReconciledSpan.FuzzyMatch(new ReconciledSpanFuzzyMatch { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix, MatchQuality = quality });

    private static bool Boundary(Rune point) => Rune.IsWhiteSpace(point) ||
        (point.IsAscii && ".,;:!?'\"()[]{}<>/\\".Contains((char)point.Value));

    private static ChangedText Normalize(ScalarText text)
    {
        var points = new List<Rune>();
        var from = new List<int>();
        int? whitespace = null;
        for (var offset = 0; offset < text.Length; offset++)
        {
            var point = text.Points[offset];
            if (Rune.IsWhiteSpace(point)) { whitespace ??= offset; continue; }
            if (whitespace is int space && points.Count > 0) Append(new Rune(' '), space);
            whitespace = null;
            switch (point.Value)
            {
                case 0x2018 or 0x2019: Append(new Rune('\''), offset); break;
                case 0x201c or 0x201d: Append(new Rune('"'), offset); break;
                case 0x2014: Append(new Rune('-'), offset); Append(new Rune('-'), offset); break;
                case 0x2013: Append(new Rune('-'), offset); break;
                default: Append(point, offset); break;
            }
        }
        return new ChangedText(new ScalarText(points.ToArray()), from.ToArray());

        void Append(Rune point, int offset) { points.Add(point); from.Add(offset); }
    }

    private static ChangedText Lower(ScalarText text)
    {
        var points = new List<Rune>();
        var from = new List<int>();
        for (var offset = 0; offset < text.Length; offset++)
        {
            var point = text.Points[offset];
            if (point.Value == 0x130)
            {
                points.Add(new Rune('i'));
                from.Add(offset);
                point = new Rune(0x307);
            }
            else if (point.Value == 0x3a3 && CasedNeighbor(text, offset, -1) && !CasedNeighbor(text, offset, 1))
            {
                point = new Rune(0x3c2);
            }
            points.Add(Rune.ToLowerInvariant(point));
            from.Add(offset);
        }
        return new ChangedText(new ScalarText(points.ToArray()), from.ToArray());
    }

    private static bool CasedNeighbor(ScalarText text, int offset, int step)
    {
        for (var at = offset + step; at >= 0 && at < text.Length; at += step)
        {
            var point = text.Points[at].Value;
            if (UnicodeCase.CaseIgnorable(point)) continue;
            return UnicodeCase.Cased(point);
        }
        return false;
    }

    private static (int Start, int End)? Nearest(ScalarText text, ScalarText exact)
    {
        var allowance = exact.Length / 20;
        var shortest = exact.Length - allowance;
        if (allowance == 0 || text.Length < shortest) return null;
        var beyond = allowance + 1;
        var bestDistance = beyond;
        (int Start, int End)? best = null;
        var width = 2 * allowance + 3;
        var row = new int[width];
        var above = new int[width];
        for (var start = 0; start <= text.Length - shortest; start++)
        {
            var longest = Math.Min(exact.Length + allowance, text.Length - start);
            Array.Fill(row, beyond);
            for (var length = 0; length <= allowance; length++) row[length + allowance + 1] = length;
            var refused = false;
            for (var taken = 1; taken <= exact.Length; taken++)
            {
                (row, above) = (above, row);
                Array.Fill(row, beyond);
                var least = beyond;
                for (var length = Math.Max(0, taken - allowance); length <= Math.Min(longest, taken + allowance); length++)
                {
                    var at = length - taken + allowance + 1;
                    var replacement = length > 0 && exact.Points[taken - 1] != text.Points[start + length - 1] ? 1 : 0;
                    var distance = length == 0 ? taken : Math.Min(above[at + 1] + 1, Math.Min(row[at - 1] + 1, above[at] + replacement));
                    row[at] = Math.Min(distance, beyond);
                    least = Math.Min(least, distance);
                }
                if (least <= allowance) continue;
                refused = true;
                break;
            }
            if (refused) continue;
            TryLength(exact.Length);
            for (var offset = 1; offset <= allowance; offset++)
            {
                TryLength(exact.Length - offset);
                TryLength(exact.Length + offset);
            }
            if (bestDistance == 0) break;

            void TryLength(int length)
            {
                if (length > longest) return;
                var distance = row[length - exact.Length + allowance + 1];
                if (distance >= bestDistance) return;
                bestDistance = distance;
                best = (start, start + length);
            }
        }
        return best;
    }

    private sealed record ChangedText(ScalarText Text, int[] From);
}

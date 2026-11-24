// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Where a quoted selection was found in a text, and how it was found, told apart by `anchorMethod`, one of AnchorMethod's words: a fuzzy match also names its search, `matchQuality`, and no other states one. */
@Serializable(with = ReconciledSpanSerializer::class)
public sealed interface ReconciledSpan

internal object ReconciledSpanSerializer : SignatureUnionSerializer<ReconciledSpan>(
    ReconciledSpan::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("start", "end", "exact", "anchorMethod"),
                allowed = listOf("start", "end", "exact", "prefix", "suffix", "anchorMethod"),
                fixed = listOf("anchorMethod" to listOf(Literal.Text("unique-match"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("start", "end", "exact", "anchorMethod"),
                allowed = listOf("start", "end", "exact", "prefix", "suffix", "anchorMethod"),
                fixed = listOf("anchorMethod" to listOf(Literal.Text("context-recovered"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("start", "end", "exact", "anchorMethod"),
                allowed = listOf("start", "end", "exact", "prefix", "suffix", "anchorMethod"),
                fixed = listOf("anchorMethod" to listOf(Literal.Text("first-of-many"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("start", "end", "exact", "anchorMethod", "matchQuality"),
                allowed = listOf("start", "end", "exact", "prefix", "suffix", "anchorMethod", "matchQuality"),
                fixed = listOf("anchorMethod" to listOf(Literal.Text("fuzzy-match")), "matchQuality" to listOf(Literal.Text("normalized"), Literal.Text("case-insensitive"), Literal.Text("fuzzy"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        ReconciledSpanUniqueMatch.serializer(),
        ReconciledSpanContextRecovered.serializer(),
        ReconciledSpanFirstOfMany.serializer(),
        ReconciledSpanFuzzyMatch.serializer(),
    ) },
)

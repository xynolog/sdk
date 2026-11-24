// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a target's `selector` holds: one W3C selector, or several of the same segment. */
@Serializable(with = AnnotationSelectorSerializer::class)
public sealed interface AnnotationSelector {
    /** A member that is a `List<Selector>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<Selector>) : AnnotationSelector {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<Selector>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object AnnotationSelectorSerializer : SignatureUnionSerializer<AnnotationSelector>(
    AnnotationSelector::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "start", "end"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextPositionSelector"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "exact"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextQuoteSelector"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("SvgSelector"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("FragmentSelector"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.LIST,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        Selector.serializer(),
        AnnotationSelector.List.serializer(),
    ) },
)

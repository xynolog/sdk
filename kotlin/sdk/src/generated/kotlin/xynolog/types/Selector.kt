// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One W3C selector: a way of finding a segment of a resource. Tell them apart by `type`, which is required on each and single-valued. */
@Serializable(with = SelectorSerializer::class)
public sealed interface Selector : AnnotationSelector

internal object SelectorSerializer : SignatureUnionSerializer<Selector>(
    Selector::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "start", "end"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextPositionSelector"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "exact"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextQuoteSelector"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("SvgSelector"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("FragmentSelector"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            TextPositionSelector.serializer(),
            TextQuoteSelector.serializer(),
            SvgSelector.serializer(),
            FragmentSelector.serializer(),
        )
    },
)

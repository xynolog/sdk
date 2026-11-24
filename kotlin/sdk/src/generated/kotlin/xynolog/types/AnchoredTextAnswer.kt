// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/**
 * What a reader gets when it asks for a resource's coordinate map: the map, a stored decline, or a named absence.
 *
 * Distinct from `ExtractionOutcome` on purpose. That type is what the STORE holds and what an extractor RETURNS — neither of which can ever be 'not yet'. This is the read answer, which can, so widening ExtractionOutcome itself would have put an impossible state into the store's own type.
 *
 * Flat, one discriminant: every member carries `kind`, rather than nesting an outcome inside a status envelope and giving the wire two `kind` fields at different depths.
 */
@Serializable(with = AnchoredTextAnswerSerializer::class)
public sealed interface AnchoredTextAnswer

internal object AnchoredTextAnswerSerializer : SignatureUnionSerializer<AnchoredTextAnswer>(
    AnchoredTextAnswer::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("text", "items", "kind", "method"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("extracted")), "method" to listOf(Literal.Text("text-passthrough"), Literal.Text("pdf-text-layer"), Literal.Text("table"), Literal.Text("form"), Literal.Text("ocr")), "pdfClass" to listOf(Literal.Text("A"), Literal.Text("B"), Literal.Text("C"), Literal.Text("D"), Literal.Text("E"), Literal.Text("F"), Literal.Text("G"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "declined"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("declined")), "declined" to listOf(Literal.Text("no-text-layer"), Literal.Text("encrypted"), Literal.Text("corrupt"), Literal.Text("too-large"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("not-yet"), Literal.Text("no-map"), Literal.Text("unknown"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        ExtractedText.serializer(),
        ExtractionDeclined.serializer(),
        AnchoredTextAbsent.serializer(),
    ) },
)

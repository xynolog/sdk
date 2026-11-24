// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The full outcome of text extraction for one representation — the record the anchored-text store holds and the wire serves. Discriminated on `kind`: 'extracted' — the anchored text with its provenance; 'declined' — a named decline. ocrConfidence is extraction quality for operators, deliberately not anchor confidence. */
@Serializable(with = ExtractionOutcomeSerializer::class)
public sealed interface ExtractionOutcome

internal object ExtractionOutcomeSerializer : SignatureUnionSerializer<ExtractionOutcome>(
    ExtractionOutcome::class,
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
    ),
    variants = { listOf(
        ExtractedText.serializer(),
        ExtractionDeclined.serializer(),
    ) },
)

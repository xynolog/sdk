// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One entry of the anchored-text store: the file `<ab>/<cd>/<key>.json` under the store's directory, where the key is the SHA-256 of the bytes the text was extracted from, in hex. The Smelter derives it and stores it over the Archivist's HTTP surface (`AnchoredTextWrite`); the Archivist writes it, as compact JSON with `v` and `stamp` first, to a sibling temporary file renamed onto the path. The stamp the Smelter states (`AnchoredTextStamp`) is kept, followed by a newline, in the file `STAMP` at the store's root. */
@Serializable(with = AnchoredTextEntrySerializer::class)
public sealed interface AnchoredTextEntry

internal object AnchoredTextEntrySerializer : SignatureUnionSerializer<AnchoredTextEntry>(
    AnchoredTextEntry::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("v", "stamp", "text", "lines", "method"),
                allowed = listOf("v", "stamp", "text", "lines", "method", "pdfClass", "ocrConfidence", "unreadPages"),
                fixed = listOf("v" to listOf(Literal.Integer(3)), "method" to listOf(Literal.Text("text-passthrough"), Literal.Text("pdf-text-layer"), Literal.Text("table"), Literal.Text("form"), Literal.Text("ocr")), "pdfClass" to listOf(Literal.Text("A"), Literal.Text("B"), Literal.Text("C"), Literal.Text("D"), Literal.Text("E"), Literal.Text("F"), Literal.Text("G"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("v", "stamp", "declined"),
                allowed = listOf("v", "stamp", "declined"),
                fixed = listOf("v" to listOf(Literal.Integer(3)), "declined" to listOf(Literal.Text("no-text-layer"), Literal.Text("encrypted"), Literal.Text("corrupt"), Literal.Text("too-large"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            AnchoredTextExtractedEntry.serializer(),
            AnchoredTextDeclinedEntry.serializer(),
        )
    },
)

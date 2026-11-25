// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a `mark` job reports when it concludes without failing: its counts, or a decline. Neither names its kind: a decline is the one with `declined`. */
@Serializable(with = MarkJobResultSerializer::class)
public sealed interface MarkJobResult

internal object MarkJobResultSerializer : SignatureUnionSerializer<MarkJobResult>(
    MarkJobResult::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("found", "persisted"),
                allowed = listOf("found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("declined", "reason"),
                allowed = listOf("declined", "reason"),
                fixed = listOf("declined" to listOf(Literal.Boolean(true)), "reason" to listOf(Literal.Text("no-text-layer"), Literal.Text("encrypted"), Literal.Text("corrupt"), Literal.Text("too-large"), Literal.Text("empty"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            MarkJobDone.serializer(),
            JobDeclined.serializer(),
        )
    },
)

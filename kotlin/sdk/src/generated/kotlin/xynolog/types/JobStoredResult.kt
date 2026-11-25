// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A completed job's result as the dispatcher stores it: the result its worker reported with `job:complete`, or an empty object when it reported none. */
@Serializable(with = JobStoredResultSerializer::class)
public sealed interface JobStoredResult {
    /** The empty object. */
    @Serializable
    public data object Empty : JobStoredResult
}

internal object JobStoredResultSerializer : SignatureUnionSerializer<JobStoredResult>(
    JobStoredResult::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("found", "persisted"),
                allowed = listOf("found", "persisted", "errors", "byCategory", "underReportedPieces", "uncheckedPieces"),
                fixed = emptyList(),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("resourceId", "resourceName", "truncated"),
                allowed = listOf("resourceId", "resourceName", "truncated"),
                fixed = emptyList(),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("declined", "reason"),
                allowed = listOf("declined", "reason"),
                fixed = listOf("declined" to listOf(Literal.Boolean(true)), "reason" to listOf(Literal.Text("no-text-layer"), Literal.Text("encrypted"), Literal.Text("corrupt"), Literal.Text("too-large"), Literal.Text("empty"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = emptyList(),
                allowed = emptyList(),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            JobResult.serializer(),
            JobStoredResult.Empty.serializer(),
        )
    },
)

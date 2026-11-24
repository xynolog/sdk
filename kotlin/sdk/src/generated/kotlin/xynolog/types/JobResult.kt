// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a job reports when it concludes without failing: a `mark` job's counts, the resource a `yield` job made, or a decline from either. A result has no discriminant of its own: the job description beside it says which job it answers, and the three share no member, so each is told from the others by what it alone carries. */
@Serializable(with = JobResultSerializer::class)
public sealed interface JobResult : JobStoredResult

internal object JobResultSerializer : SignatureUnionSerializer<JobResult>(
    JobResult::class,
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
                required = listOf("resourceId", "resourceName", "truncated"),
                allowed = listOf("resourceId", "resourceName", "truncated"),
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
    variants = { listOf(
        MarkJobDone.serializer(),
        YieldJobDone.serializer(),
        JobDeclined.serializer(),
    ) },
)

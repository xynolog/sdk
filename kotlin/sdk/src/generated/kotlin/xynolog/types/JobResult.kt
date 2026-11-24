// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a job reports when it concludes without failing: a `mark` job's counts, the resource a `yield` job made, or a decline from either. A result has no discriminant of its own: the job description beside it says which job it answers, and the three share no member, so each is told from the others by what it alone carries. */
@Serializable(with = JobResultSerializer::class)
public sealed interface JobResult : JobStoredResult

internal object JobResultSerializer : KindsUnionSerializer<JobResult>(
    JobResult::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(MarkJobDone.serializer(), YieldJobDone.serializer(), JobDeclined.serializer()) },
)

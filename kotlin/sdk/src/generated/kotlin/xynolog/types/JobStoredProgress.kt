// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A running job's progress as the dispatcher stores it: the last JobProgress its worker reported with `job:report-progress`, or an empty object before the first report. */
@Serializable(with = JobStoredProgressSerializer::class)
public sealed interface JobStoredProgress {
    /** The empty object. */
    @Serializable
    public data object Empty : JobStoredProgress
}

internal object JobStoredProgressSerializer : KindsUnionSerializer<JobStoredProgress>(
    JobStoredProgress::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(JobProgress.serializer(), JobStoredProgress.Empty.serializer()) },
)

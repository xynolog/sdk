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

internal object JobStoredResultSerializer : KindsUnionSerializer<JobStoredResult>(
    JobStoredResult::class,
    strings = { listOf(JobResult.serializer()) },
    scalars = { listOf(JobResult.serializer()) },
    arrays = { listOf(JobResult.serializer()) },
    objects = { listOf(JobResult.serializer(), JobStoredResult.Empty.serializer()) },
)

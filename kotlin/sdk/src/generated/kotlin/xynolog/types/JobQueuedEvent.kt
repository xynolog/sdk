// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A pending job, announced when it is created and again at each tick while it waits. It carries the job description less the job's input, so that a party deciding whether to claim reads here what its claim would be matched against. It is a wake-up and not an offer of this job: a claim is answered with the next pending job it matches. */
@Serializable(with = JobQueuedEventSerializer::class)
public sealed interface JobQueuedEvent

internal object JobQueuedEventSerializer : SignatureUnionSerializer<JobQueuedEvent>(
    JobQueuedEvent::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("jobId", "jobType", "resourceId", "userId", "params"),
                allowed = null,
                fixed = listOf("jobType" to listOf(Literal.Text("mark"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("jobId", "jobType", "resourceId", "userId", "params"),
                allowed = null,
                fixed = listOf("jobType" to listOf(Literal.Text("yield"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            MarkJobQueuedEvent.serializer(),
            YieldJobQueuedEvent.serializer(),
        )
    },
)

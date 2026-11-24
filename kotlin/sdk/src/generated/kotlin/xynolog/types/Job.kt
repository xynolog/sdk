// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A job as the dispatcher holds it. Its `status` decides which timestamps and outcome fields it carries. It is what a claim returns (`job:claimed`, always `running`) and what the queue stores, inside a JobRecord. */
@Serializable(with = JobSerializer::class)
public sealed interface Job

internal object JobSerializer : SignatureUnionSerializer<Job>(
    Job::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "metadata", "params"),
                allowed = listOf("status", "metadata", "params"),
                fixed = listOf("status" to listOf(Literal.Text("pending"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "metadata", "params", "startedAt", "progress"),
                allowed = listOf("status", "metadata", "params", "startedAt", "progress"),
                fixed = listOf("status" to listOf(Literal.Text("running"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "metadata", "params", "startedAt", "completedAt", "result"),
                allowed = listOf("status", "metadata", "params", "startedAt", "completedAt", "result"),
                fixed = listOf("status" to listOf(Literal.Text("complete"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "metadata", "params", "completedAt", "error"),
                allowed = listOf("status", "metadata", "params", "startedAt", "completedAt", "error", "failureClass"),
                fixed = listOf("status" to listOf(Literal.Text("failed")), "failureClass" to listOf(Literal.Text("transient"), Literal.Text("deterministic"), Literal.Text("withheld"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "metadata", "params", "completedAt"),
                allowed = listOf("status", "metadata", "params", "startedAt", "completedAt"),
                fixed = listOf("status" to listOf(Literal.Text("cancelled"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        JobPending.serializer(),
        JobRunning.serializer(),
        JobComplete.serializer(),
        JobFailed.serializer(),
        JobCancelled.serializer(),
    ) },
)

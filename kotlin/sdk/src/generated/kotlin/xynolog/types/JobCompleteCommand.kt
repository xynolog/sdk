// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A job's worker says the job is complete. The result it carries is its verb's: a `mark` job's counts or the resource a `yield` job made, or a decline from either. A completion whose result is the other verb's is refused where the command is admitted. */
@Serializable(with = JobCompleteCommandSerializer::class)
public sealed interface JobCompleteCommand

internal object JobCompleteCommandSerializer : SignatureUnionSerializer<JobCompleteCommand>(
    JobCompleteCommand::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("resourceId", "jobId", "jobType"),
                allowed = null,
                fixed = listOf("jobType" to listOf(Literal.Text("mark")), "durability" to listOf(Literal.Text("acknowledged"), Literal.Text("probe-confirmed"), Literal.Text("probe-refused"), Literal.Text("probe-unreachable"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("resourceId", "jobId", "jobType"),
                allowed = null,
                fixed = listOf("jobType" to listOf(Literal.Text("yield")), "durability" to listOf(Literal.Text("acknowledged"), Literal.Text("probe-confirmed"), Literal.Text("probe-refused"), Literal.Text("probe-unreachable"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        MarkJobCompleteCommand.serializer(),
        YieldJobCompleteCommand.serializer(),
    ) },
)

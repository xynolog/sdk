// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Some jobs, named by fields of the job description: a partial description, at the description's own paths. A job matches when every field stated here equals the job's. A `mark` filter always states its motivation. */
@Serializable(with = JobFilterSerializer::class)
public sealed interface JobFilter

internal object JobFilterSerializer : SignatureUnionSerializer<JobFilter>(
    JobFilter::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("jobType", "params"),
                allowed = listOf("jobType", "params"),
                fixed = listOf("jobType" to listOf(Literal.Text("mark"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("jobType"),
                allowed = listOf("jobType"),
                fixed = listOf("jobType" to listOf(Literal.Text("yield"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        MarkJobFilter.serializer(),
        YieldJobFilter.serializer(),
    ) },
)

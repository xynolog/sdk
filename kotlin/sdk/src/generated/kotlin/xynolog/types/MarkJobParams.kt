// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The parameters of a `mark` job, told apart by `motivation`. Each motivation takes its own parameters and no others: a parameter a job does not take is refused where the job is created. */
@Serializable(with = MarkJobParamsSerializer::class)
public sealed interface MarkJobParams

internal object MarkJobParamsSerializer : SignatureUnionSerializer<MarkJobParams>(
    MarkJobParams::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("motivation"),
                allowed = listOf("motivation", "instructions", "density", "sourceLanguage"),
                fixed = listOf("motivation" to listOf(Literal.Text("highlighting"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("motivation"),
                allowed = listOf("motivation", "instructions", "tone", "density", "language", "sourceLanguage"),
                fixed = listOf("motivation" to listOf(Literal.Text("commenting")), "tone" to listOf(Literal.Text("scholarly"), Literal.Text("explanatory"), Literal.Text("conversational"), Literal.Text("technical"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("motivation"),
                allowed = listOf("motivation", "instructions", "tone", "density", "language", "sourceLanguage"),
                fixed = listOf("motivation" to listOf(Literal.Text("assessing")), "tone" to listOf(Literal.Text("analytical"), Literal.Text("critical"), Literal.Text("balanced"), Literal.Text("constructive"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("motivation", "entityTypes"),
                allowed = listOf("motivation", "entityTypes", "includeDescriptiveReferences", "language", "sourceLanguage"),
                fixed = listOf("motivation" to listOf(Literal.Text("linking"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("motivation", "schemaId", "categories"),
                allowed = listOf("motivation", "schemaId", "categories", "language", "sourceLanguage"),
                fixed = listOf("motivation" to listOf(Literal.Text("tagging"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        HighlightingJobParams.serializer(),
        CommentingJobParams.serializer(),
        AssessingJobParams.serializer(),
        LinkingJobParams.serializer(),
        TaggingJobParams.serializer(),
    ) },
)

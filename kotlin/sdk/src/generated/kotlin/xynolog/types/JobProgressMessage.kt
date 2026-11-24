// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a running job is doing right now, as a code plus typed params — never a prose sentence. The producer reports what happened; each client renders it in the user's language (react-ui from its translations, the Go launcher from its English map). One named schema per code, discriminated on `code`, so generated clients get typed variants and copy-map completeness is statically checkable. The vocabulary is every report Xynolog's worker makes (contract/WORKER-SERVICE.md, D16 to D19 and Y8); extending it means adding a named variant here and copy in every client, gated by the locale-completeness check. */
@Serializable(with = JobProgressMessageSerializer::class)
public sealed interface JobProgressMessage

internal object JobProgressMessageSerializer : SignatureUnionSerializer<JobProgressMessage>(
    JobProgressMessage::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("loading"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("analyzing"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("analyzing-tags"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("generating-resource"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("creating-resource"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "truncated"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("complete-generated"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "entityType"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("detecting-entities"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "count"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("creating-annotations"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "count"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("creating-tag-annotations"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "count", "motivation"),
                allowed = null,
                fixed = listOf("code" to listOf(Literal.Text("complete-created")), "motivation" to listOf(Literal.Text("assessing"), Literal.Text("commenting"), Literal.Text("highlighting"), Literal.Text("linking"), Literal.Text("tagging"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        JobProgressLoading.serializer(),
        JobProgressAnalyzing.serializer(),
        JobProgressAnalyzingTags.serializer(),
        JobProgressGeneratingResource.serializer(),
        JobProgressCreatingResource.serializer(),
        JobProgressCompleteGenerated.serializer(),
        JobProgressDetectingEntities.serializer(),
        JobProgressCreatingAnnotations.serializer(),
        JobProgressCreatingTagAnnotations.serializer(),
        JobProgressCompleteCreated.serializer(),
    ) },
)

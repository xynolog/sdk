// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An annotation's body: a TextualBody carries text the annotation states (entity tags, descriptions, comments), a SpecificResource points at what it links to. Tell them apart by `type`, which is required on both and single-valued — a consumer never has to probe for which fields happen to be present. */
@Serializable(with = AnnotationBodySerializer::class)
public sealed interface AnnotationBody : AnnotationBodies

internal object AnnotationBodySerializer : SignatureUnionSerializer<AnnotationBody>(
    AnnotationBody::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextualBody")), "purpose" to listOf(Literal.Text("assessing"), Literal.Text("bookmarking"), Literal.Text("classifying"), Literal.Text("commenting"), Literal.Text("describing"), Literal.Text("editing"), Literal.Text("highlighting"), Literal.Text("identifying"), Literal.Text("linking"), Literal.Text("moderating"), Literal.Text("questioning"), Literal.Text("replying"), Literal.Text("tagging"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "source"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("SpecificResource")), "purpose" to listOf(Literal.Text("assessing"), Literal.Text("bookmarking"), Literal.Text("classifying"), Literal.Text("commenting"), Literal.Text("describing"), Literal.Text("editing"), Literal.Text("highlighting"), Literal.Text("identifying"), Literal.Text("linking"), Literal.Text("moderating"), Literal.Text("questioning"), Literal.Text("replying"), Literal.Text("tagging"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        TextualBody.serializer(),
        SpecificResource.serializer(),
    ) },
)

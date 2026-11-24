// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What an annotation's `body` holds: one body, or a non-empty list of them. There is no empty list: an annotation with nothing to say has no `body`. */
@Serializable(with = AnnotationBodiesSerializer::class)
public sealed interface AnnotationBodies {
    /** A member that is a `List<AnnotationBody>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<AnnotationBody>) : AnnotationBodies {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<AnnotationBody>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object AnnotationBodiesSerializer : SignatureUnionSerializer<AnnotationBodies>(
    AnnotationBodies::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "value"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("TextualBody")), "purpose" to listOf(Literal.Text("assessing"), Literal.Text("bookmarking"), Literal.Text("classifying"), Literal.Text("commenting"), Literal.Text("describing"), Literal.Text("editing"), Literal.Text("highlighting"), Literal.Text("identifying"), Literal.Text("linking"), Literal.Text("moderating"), Literal.Text("questioning"), Literal.Text("replying"), Literal.Text("tagging"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "source"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("SpecificResource")), "purpose" to listOf(Literal.Text("assessing"), Literal.Text("bookmarking"), Literal.Text("classifying"), Literal.Text("commenting"), Literal.Text("describing"), Literal.Text("editing"), Literal.Text("highlighting"), Literal.Text("identifying"), Literal.Text("linking"), Literal.Text("moderating"), Literal.Text("questioning"), Literal.Text("replying"), Literal.Text("tagging"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.LIST,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        AnnotationBody.serializer(),
        AnnotationBodies.List.serializer(),
    ) },
)

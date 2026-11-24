// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = KnowledgeGraphNodesItemSerializer::class)
public sealed interface KnowledgeGraphNodesItem

internal object KnowledgeGraphNodesItemSerializer : SignatureUnionSerializer<KnowledgeGraphNodesItem>(
    KnowledgeGraphNodesItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "type", "label"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("resource"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "type", "label", "annotation"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("annotation"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        GraphResourceNode.serializer(),
        GraphAnnotationNode.serializer(),
    ) },
)

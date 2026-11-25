// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Managed or referenced byte-level renditions of this resource. */
@Serializable(with = ResourceDescriptorRepresentationsSerializer::class)
public sealed interface ResourceDescriptorRepresentations {
    /** A member that is a `List<Representation>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<Representation>) : ResourceDescriptorRepresentations {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<Representation>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object ResourceDescriptorRepresentationsSerializer : SignatureUnionSerializer<ResourceDescriptorRepresentations>(
    ResourceDescriptorRepresentations::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("mediaType"),
                allowed = null,
                fixed = listOf("rel" to listOf(Literal.Text("original"), Literal.Text("thumbnail"), Literal.Text("preview"), Literal.Text("optimized"), Literal.Text("derived"), Literal.Text("other"))),
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
    variants = {
        listOf(
            Representation.serializer(),
            ResourceDescriptorRepresentations.List.serializer(),
        )
    },
)

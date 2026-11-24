// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import xynolog.identifiers.ResourceId

/** W3C PROV: the resource, or resources, this one was derived from, each by its id */
@Serializable(with = ResourceDescriptorWasDerivedFromSerializer::class)
public sealed interface ResourceDescriptorWasDerivedFrom {
    /** A member that is a `ResourceId`, as the value itself. */
    @Serializable(with = ResourceId.Serializer::class)
    public data class ResourceId(public val value: xynolog.identifiers.ResourceId) : ResourceDescriptorWasDerivedFrom {
        internal object Serializer : WrapperSerializer<ResourceId, xynolog.identifiers.ResourceId>(ResourceId::class, kotlinx.serialization.serializer(), { ResourceId(it) }, ResourceId::value)
    }

    /** A member that is a `List<ResourceId>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<ResourceId>) : ResourceDescriptorWasDerivedFrom {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<ResourceId>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object ResourceDescriptorWasDerivedFromSerializer : SignatureUnionSerializer<ResourceDescriptorWasDerivedFrom>(
    ResourceDescriptorWasDerivedFrom::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.TEXT,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
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
        ResourceDescriptorWasDerivedFrom.ResourceId.serializer(),
        ResourceDescriptorWasDerivedFrom.List.serializer(),
    ) },
)

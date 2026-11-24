// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Persistent identifiers (e.g., DOI, URN). */
@Serializable(with = ResourceDescriptorIdentifierSerializer::class)
public sealed interface ResourceDescriptorIdentifier {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : ResourceDescriptorIdentifier {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `List<String>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<String>) : ResourceDescriptorIdentifier {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<String>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object ResourceDescriptorIdentifierSerializer : KindsUnionSerializer<ResourceDescriptorIdentifier>(
    ResourceDescriptorIdentifier::class,
    strings = { listOf(ResourceDescriptorIdentifier.Text.serializer()) },
    scalars = { emptyList() },
    arrays = { listOf(ResourceDescriptorIdentifier.List.serializer()) },
    objects = { listOf(ResourceDescriptorIdentifierObject.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonObject

/** JSON-LD context; URI, object, or array of these. */
@Serializable(with = ResourceDescriptorContextSerializer::class)
public sealed interface ResourceDescriptorContext {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : ResourceDescriptorContext {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `JsonObject`, as the value itself. */
    @Serializable(with = Object.Serializer::class)
    public data class Object(public val value: JsonObject) : ResourceDescriptorContext {
        internal object Serializer : WrapperSerializer<Object, JsonObject>(Object::class, kotlinx.serialization.serializer(), { Object(it) }, Object::value)
    }

    /** A member that is a `List<ResourceDescriptorContextItem>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<ResourceDescriptorContextItem>) : ResourceDescriptorContext {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<ResourceDescriptorContextItem>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object ResourceDescriptorContextSerializer : KindsUnionSerializer<ResourceDescriptorContext>(
    ResourceDescriptorContext::class,
    strings = { listOf(ResourceDescriptorContext.Text.serializer()) },
    scalars = { emptyList() },
    arrays = { listOf(ResourceDescriptorContext.List.serializer()) },
    objects = { listOf(ResourceDescriptorContext.Object.serializer()) },
)

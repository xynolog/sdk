@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.DeserializationStrategy
import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonContentPolymorphicSerializer
import kotlinx.serialization.json.JsonDecoder
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonEncoder
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.jsonObject
import kotlin.reflect.KClass

/** The name a type is known by on the wire: its own, qualified. */
private fun serialNameOf(type: KClass<*>): String = type.qualifiedName ?: throw IllegalArgumentException("$type has no qualified name")

/**
 * A union whose members are told apart by the kind of JSON each is read from:
 * the first member, in the schema's order, of those read from a string, a
 * number or boolean, an array or an object, that the element decodes as.
 */
internal open class KindsUnionSerializer<T : Any>(
    union: KClass<T>,
    private val strings: () -> List<DeserializationStrategy<T>>,
    private val scalars: () -> List<DeserializationStrategy<T>>,
    private val arrays: () -> List<DeserializationStrategy<T>>,
    private val objects: () -> List<DeserializationStrategy<T>>,
) : JsonContentPolymorphicSerializer<T>(union) {
    private val union: String = union.simpleName ?: throw IllegalArgumentException("$union has no name")

    override val descriptor: SerialDescriptor = SerialDescriptor(serialNameOf(union), super.descriptor)

    override fun selectDeserializer(element: JsonElement): DeserializationStrategy<T> =
        firstThatFits(
            element,
            when (element) {
                is JsonPrimitive -> if (element.isString) strings() else scalars()
                is JsonArray -> arrays()
                is JsonObject -> objects()
            },
            union,
        )
}

/** A union whose members are told apart by the one value each states for `property`. */
internal open class TaggedUnionSerializer<T : Any>(
    union: KClass<T>,
    private val property: String,
    private val members: () -> Map<String, DeserializationStrategy<T>>,
) : JsonContentPolymorphicSerializer<T>(union) {
    private val union: String = union.simpleName ?: throw IllegalArgumentException("$union has no name")

    override val descriptor: SerialDescriptor = SerialDescriptor(serialNameOf(union), super.descriptor)

    override fun selectDeserializer(element: JsonElement): DeserializationStrategy<T> {
        val members = members()
        val tag = ((element as? JsonObject)?.get(property) as? JsonPrimitive)?.content
        return tag?.let(members::get)
            ?: throw SerializationException("a $union states a `$property` that is one of ${members.keys.joinToString(", ") { "`$it`" }}")
    }
}

/** A union's member that holds a value, written as the value itself. */
internal open class WrapperSerializer<W : Any, V>(
    wrapper: KClass<W>,
    private val value: KSerializer<V>,
    private val wrap: (V) -> W,
    private val unwrap: (W) -> V,
) : KSerializer<W> {
    override val descriptor: SerialDescriptor =
        when (val kind = value.descriptor.kind) {
            is PrimitiveKind -> PrimitiveSerialDescriptor(serialNameOf(wrapper), kind)
            else -> SerialDescriptor(serialNameOf(wrapper), value.descriptor)
        }

    override fun serialize(encoder: Encoder, value: W) {
        encoder.encodeSerializableValue(this.value, unwrap(value))
    }

    override fun deserialize(decoder: Decoder): W = wrap(decoder.decodeSerializableValue(value))
}

/**
 * An open object: what its schema names, read and written by the serializer
 * the plugin generates for it, and every other property kept as it came.
 */
internal open class OpenObjectSerializer<T : Any>(
    private val named: KSerializer<T>,
    private val rest: (T) -> JsonObject,
    private val withRest: (T, JsonObject) -> T,
) : KSerializer<T> {
    override val descriptor: SerialDescriptor = named.descriptor

    private val type: String = descriptor.serialName.substringAfterLast('.')
    private val names: Set<String> = (0 until descriptor.elementsCount).map(descriptor::getElementName).toSet()

    override fun deserialize(decoder: Decoder): T {
        val json = decoder as? JsonDecoder ?: throw SerializationException("a $type is read from JSON alone")
        val all = json.decodeJsonElement().jsonObject
        val known = json.json.decodeFromJsonElement(named, JsonObject(all.filterKeys { it in names }))
        return withRest(known, JsonObject(all.filterKeys { it !in names }))
    }

    override fun serialize(encoder: Encoder, value: T) {
        val json = encoder as? JsonEncoder ?: throw SerializationException("a $type is written as JSON alone")
        val known = json.json.encodeToJsonElement(named, value).jsonObject
        json.encodeJsonElement(JsonObject(known + rest(value)))
    }
}

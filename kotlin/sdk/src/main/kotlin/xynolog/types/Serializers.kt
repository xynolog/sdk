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
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.jsonObject
import kotlin.reflect.KClass

/** The name a type is known by on the wire: its own, qualified. */
private fun serialNameOf(type: KClass<*>): String = type.qualifiedName ?: throw IllegalArgumentException("$type has no qualified name")

/** The kind of JSON value a [Signature] admits. */
internal enum class Kind {
    TEXT,
    INTEGER,
    NUMBER,
    BOOLEAN,
    LIST,
    OBJECT,
    NULL,
    ANY,
    ;

    fun of(value: JsonElement): Boolean =
        when (this) {
            TEXT -> value is JsonPrimitive && value.isString
            INTEGER -> value is JsonPrimitive && !value.isString && value.content.toLongOrNull() != null
            NUMBER -> value is JsonPrimitive && !value.isString && value !is JsonNull && value.content.toDoubleOrNull() != null
            BOOLEAN -> value is JsonPrimitive && !value.isString && value.content.toBooleanStrictOrNull() != null
            LIST -> value is JsonArray
            OBJECT -> value is JsonObject
            NULL -> value is JsonNull
            ANY -> true
        }
}

/** One value a schema states. */
internal sealed interface Literal {
    fun isOf(value: JsonElement): kotlin.Boolean

    data class Text(val text: String) : Literal {
        override fun isOf(value: JsonElement) = value is JsonPrimitive && value.isString && value.content == text

        override fun toString() = "`$text`"
    }

    data class Integer(val number: Long) : Literal {
        override fun isOf(value: JsonElement) = Kind.INTEGER.of(value) && (value as JsonPrimitive).content.toLong() == number

        override fun toString() = "`$number`"
    }

    data class Boolean(val truth: kotlin.Boolean) : Literal {
        override fun isOf(value: JsonElement) = Kind.BOOLEAN.of(value) && (value as JsonPrimitive).content.toBooleanStrict() == truth

        override fun toString() = "`$truth`"
    }
}

/** What a member of a union admits, as its schema states it: what tells it from the union's other members. */
internal data class Signature(
    val kind: Kind,
    /** The members an object must carry. */
    val required: List<String>,
    /** Every member an object may carry, where its schema says. */
    val allowed: List<String>?,
    /** The values each of these members may take. */
    val fixed: List<Pair<String, List<Literal>>>,
    /** Every value it admits, where its schema says. */
    val values: List<Literal>?,
) {
    /** Whether [value] is of its kind, and states only the values it admits. */
    fun names(value: JsonElement): Boolean =
        kind.of(value) &&
            (values == null || values.any { it.isOf(value) }) &&
            (value !is JsonObject || fixed.all { (property, of) -> value[property]?.let { v -> of.any { it.isOf(v) } } ?: true })

    /** Whether it admits [value]: [names] it, and an object carries every member it requires and none it does not allow. */
    fun admits(value: JsonElement): Boolean =
        names(value) &&
            (value !is JsonObject || (required.all(value::containsKey) && (allowed == null || value.keys.all(allowed::contains))))
}

/** How [member] found a union's member. */
internal enum class Found {
    /** It admits the value. */
    ADMITTED,

    /** It admits no value of the union's members, and only it names it. */
    NAMED,
}

/**
 * The one of a union's [members], each its signatures, that admits [value]; or, none admitting it, the one that
 * names it, whose decoding says what is wrong with it.
 */
internal fun member(
    value: JsonElement,
    members: List<List<Signature>>,
): Pair<Int, Found>? {
    fun only(test: (Signature) -> Boolean): Int? = members.indices.filter { at -> members[at].any(test) }.singleOrNull()
    return only { it.admits(value) }?.let { it to Found.ADMITTED }
        ?: only { it.names(value) }?.let { it to Found.NAMED }
}

/**
 * What is wrong with a value of [union] that none of its [members] names: where each states its values of one
 * property, that the value's is none of them.
 */
internal fun noneOf(
    union: String,
    members: List<List<Signature>>,
): String {
    val signatures = members.flatten()
    val toldApart =
        members.firstOrNull()?.firstOrNull()?.fixed?.firstNotNullOfOrNull { (property, _) ->
            signatures
                .map { signature -> signature.fixed.firstOrNull { it.first == property }?.second }
                .takeIf { stated -> stated.all { it != null } }
                ?.let { stated -> property to stated.flatMap { it.orEmpty() } }
        }
    return toldApart?.let { (property, values) -> "a $union states a `$property` that is one of ${values.joinToString(", ")}" }
        ?: "a $union that is none of its members"
}

/**
 * A union decoded as the one of its members, in the order of its [members], that [member] finds: one that admits the
 * value is read as it, and one that only names it says what is wrong with it.
 */
internal open class SignatureUnionSerializer<T : Any>(
    union: KClass<T>,
    internal val members: List<List<Signature>>,
    internal val variants: () -> List<DeserializationStrategy<T>>,
) : JsonContentPolymorphicSerializer<T>(union) {
    private val union: String = union.simpleName ?: throw IllegalArgumentException("$union has no name")

    override val descriptor: SerialDescriptor = SerialDescriptor(serialNameOf(union), super.descriptor)

    override fun selectDeserializer(element: JsonElement): DeserializationStrategy<T> {
        val (at, found) = member(element, members) ?: throw SerializationException(noneOf(union, members))
        val variant = variants()[at]
        return when (found) {
            Found.ADMITTED -> variant
            Found.NAMED -> Refused(variant, "a $union its member ${variant.descriptor.serialName.substringAfterLast('.')} does not admit")
        }
    }

    /**
     * A member's decoding that says what is wrong with the value, and refuses it if nothing is. It is a serializer,
     * as the polymorphic decoding it is chosen by takes one, and it writes nothing.
     */
    private class Refused<T>(
        private val variant: DeserializationStrategy<T>,
        private val message: String,
    ) : KSerializer<T> {
        override val descriptor: SerialDescriptor = variant.descriptor

        override fun deserialize(decoder: Decoder): T {
            variant.deserialize(decoder)
            throw SerializationException(message)
        }

        override fun serialize(encoder: Encoder, value: T): Unit = throw SerializationException(message)
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

/** A type of one value: read from that value alone, and written as it, [wire]. */
internal open class ConstantSerializer<T : Any>(
    private val constant: T,
    internal val wire: JsonPrimitive,
) : KSerializer<T> {
    private val type: String = serialNameOf(constant::class)

    override val descriptor: SerialDescriptor =
        PrimitiveSerialDescriptor(type, if (wire.booleanOrNull != null) PrimitiveKind.BOOLEAN else PrimitiveKind.LONG)

    override fun deserialize(decoder: Decoder): T {
        val json = decoder as? JsonDecoder ?: throw SerializationException("a $type is read from JSON alone")
        if (json.decodeJsonElement() != wire) throw SerializationException("a ${type.substringAfterLast('.')} is $wire")
        return constant
    }

    override fun serialize(encoder: Encoder, value: T) {
        val json = encoder as? JsonEncoder ?: throw SerializationException("a $type is written as JSON alone")
        json.encodeJsonElement(wire)
    }
}

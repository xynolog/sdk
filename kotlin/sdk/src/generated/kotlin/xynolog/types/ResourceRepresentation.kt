// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A resource's bytes as the content transport answers them, whole, with the media type it answered with. */
@Serializable
public data class ResourceRepresentation(
    /** The bytes, whole. */
    public val data: Binary,
    /** The media type the content transport answered with. */
    public val contentType: String,
) {
    override fun equals(other: Any?): Boolean = other is ResourceRepresentation && data.contentEquals(other.data) && contentType == other.contentType

    override fun hashCode(): Int = listOf(data.contentHashCode(), contentType).hashCode()

    /** How Java makes a `ResourceRepresentation`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val data: Binary,
        private val contentType: String,
    ) {
        public fun build(): ResourceRepresentation = ResourceRepresentation(data = data, contentType = contentType)
    }

    public companion object {
        /** A builder of a `ResourceRepresentation` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(data: Binary, contentType: String): Builder = Builder(data, contentType)
    }
}

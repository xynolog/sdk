// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class MediaTypesRegistryMediaTypesItem(
    public val mediaType: SupportedMediaType,
    /** A file extension, with its dot. */
    public val extension: String,
    /** The name a person reads. */
    public val label: String,
    /** The viewer a reader mounts, one of `render`. */
    public val render: String,
    /** The annotation model, one of `anchoring`. */
    public val anchoring: String,
    /** Where its text comes from, one of `textSource`. */
    public val textSource: String,
    public val authorable: Boolean,
    public val uploadable: Boolean,
    public val generatable: Boolean,
) {
    /** How Java makes a `MediaTypesRegistryMediaTypesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val mediaType: SupportedMediaType,
        private val extension: String,
        private val label: String,
        private val render: String,
        private val anchoring: String,
        private val textSource: String,
        private val authorable: Boolean,
        private val uploadable: Boolean,
        private val generatable: Boolean,
    ) {
        public fun build(): MediaTypesRegistryMediaTypesItem = MediaTypesRegistryMediaTypesItem(mediaType = mediaType, extension = extension, label = label, render = render, anchoring = anchoring, textSource = textSource, authorable = authorable, uploadable = uploadable, generatable = generatable)
    }

    public companion object {
        /** A builder of a `MediaTypesRegistryMediaTypesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(mediaType: SupportedMediaType, extension: String, label: String, render: String, anchoring: String, textSource: String, authorable: Boolean, uploadable: Boolean, generatable: Boolean): Builder = Builder(mediaType, extension, label, render, anchoring, textSource, authorable, uploadable, generatable)
    }
}

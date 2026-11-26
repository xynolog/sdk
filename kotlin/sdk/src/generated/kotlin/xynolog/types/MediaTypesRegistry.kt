// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** media-types/registry.json: the media types a knowledge base admits, and what the system can do with each. */
@Serializable
public data class MediaTypesRegistry(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The viewers a reader mounts. */
    public val render: kotlin.collections.List<String>,
    /** The annotation models. */
    public val anchoring: kotlin.collections.List<String>,
    /** Where a type's text comes from. */
    public val textSource: kotlin.collections.List<String>,
    /** Each extension another stands for, by the extension that stands for it. */
    public val extensionAliases: kotlin.collections.Map<String, String>,
    /** One row for each member of SupportedMediaType. */
    public val mediaTypes: kotlin.collections.List<MediaTypesRegistryMediaTypesItem>,
) {
    /** How Java makes a `MediaTypesRegistry`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val render: kotlin.collections.List<String>,
        private val anchoring: kotlin.collections.List<String>,
        private val textSource: kotlin.collections.List<String>,
        private val extensionAliases: kotlin.collections.Map<String, String>,
        private val mediaTypes: kotlin.collections.List<MediaTypesRegistryMediaTypesItem>,
    ) {
        public fun build(): MediaTypesRegistry = MediaTypesRegistry(comment = comment, render = render, anchoring = anchoring, textSource = textSource, extensionAliases = extensionAliases, mediaTypes = mediaTypes)
    }

    public companion object {
        /** A builder of a `MediaTypesRegistry` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, render: kotlin.collections.List<String>, anchoring: kotlin.collections.List<String>, textSource: kotlin.collections.List<String>, extensionAliases: kotlin.collections.Map<String, String>, mediaTypes: kotlin.collections.List<MediaTypesRegistryMediaTypesItem>): Builder = Builder(comment, render, anchoring, textSource, extensionAliases, mediaTypes)
    }
}

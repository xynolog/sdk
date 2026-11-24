// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Smelter: it writes the vectors and the anchored text. */
@Serializable
public data class KnowledgeIndexSpecSmelter(
    public val image: Image,
    public val resources: Resources,
    /** How many PDFs it works on at once. A page of a scan held for OCR is large; one for each 2G of its memory is a reading of what fits. */
    public val pdfsAtOnce: Long,
) {
    /** How Java makes a `KnowledgeIndexSpecSmelter`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
        private val pdfsAtOnce: Long,
    ) {
        public fun build(): KnowledgeIndexSpecSmelter = KnowledgeIndexSpecSmelter(image = image, resources = resources, pdfsAtOnce = pdfsAtOnce)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecSmelter` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources, pdfsAtOnce: Long): Builder = Builder(image, resources, pdfsAtOnce)
    }
}

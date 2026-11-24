// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Weaver: it writes the graph. */
@Serializable
public data class KnowledgeIndexSpecWeaver(
    public val image: Image,
    public val resources: Resources,
) {
    /** How Java makes a `KnowledgeIndexSpecWeaver`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
    ) {
        public fun build(): KnowledgeIndexSpecWeaver = KnowledgeIndexSpecWeaver(image = image, resources = resources)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecWeaver` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources): Builder = Builder(image, resources)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Archivist: it keeps the knowledge base's record in its working tree. */
@Serializable
public data class StackKnowledgeBaseSpecArchivist(
    public val image: Image,
    public val resources: Resources,
    /** Where the stack's services reach the Archivist, when that is somewhere the launcher cannot see. Absent, they reach it where the launcher places it. */
    public val address: HostPort? = null,
) {
    /** How Java makes a `StackKnowledgeBaseSpecArchivist`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
    ) {
        private var address: HostPort? = null

        public fun address(address: HostPort?): Builder = apply { this.address = address }

        public fun build(): StackKnowledgeBaseSpecArchivist = StackKnowledgeBaseSpecArchivist(image = image, resources = resources, address = address)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecArchivist` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources): Builder = Builder(image, resources)
    }
}

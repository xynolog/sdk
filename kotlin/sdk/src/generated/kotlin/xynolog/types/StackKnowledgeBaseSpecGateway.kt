// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Gateway: where every client and every service reaches the knowledge base. */
@Serializable
public data class StackKnowledgeBaseSpecGateway(
    public val image: Image,
    public val resources: Resources,
    /** The port the Gateway is published on. */
    public val port: Long,
    /** Where clients reach the Gateway: the server its API document names. A service of the stack reaches it where the launcher places it, on `port`. */
    public val publicURL: String,
) {
    /** How Java makes a `StackKnowledgeBaseSpecGateway`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
        private val port: Long,
        private val publicURL: String,
    ) {
        public fun build(): StackKnowledgeBaseSpecGateway = StackKnowledgeBaseSpecGateway(image = image, resources = resources, port = port, publicURL = publicURL)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecGateway` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources, port: Long, publicURL: String): Builder = Builder(image, resources, port, publicURL)
    }
}

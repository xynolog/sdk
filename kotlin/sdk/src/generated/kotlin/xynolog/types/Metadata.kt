// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What names a document, as Kubernetes names an object. Documents refer to one another by `name`. */
@Serializable
public data class Metadata(
    /** The document's name: lower-case letters, digits and `-`, beginning and ending with a letter or digit. It names the document, never the knowledge base. */
    public val name: String,
    /** The Kubernetes namespace the document belongs in. The launcher reads none. */
    public val namespace: String? = null,
    /** Kubernetes labels. The launcher reads none. */
    public val labels: kotlin.collections.Map<String, String>? = null,
    /** Kubernetes annotations. The launcher reads none. */
    public val annotations: kotlin.collections.Map<String, String>? = null,
) {
    /** How Java makes a `Metadata`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
    ) {
        private var namespace: String? = null
        private var labels: kotlin.collections.Map<String, String>? = null
        private var annotations: kotlin.collections.Map<String, String>? = null

        public fun namespace(namespace: String?): Builder = apply { this.namespace = namespace }
        public fun labels(labels: kotlin.collections.Map<String, String>?): Builder = apply { this.labels = labels }
        public fun annotations(annotations: kotlin.collections.Map<String, String>?): Builder = apply { this.annotations = annotations }

        public fun build(): Metadata = Metadata(name = name, namespace = namespace, labels = labels, annotations = annotations)
    }

    public companion object {
        /** A builder of a `Metadata` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String): Builder = Builder(name)
    }
}

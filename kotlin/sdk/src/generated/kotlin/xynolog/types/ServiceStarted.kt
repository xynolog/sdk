// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** notifications/serviceStarted: a run's instance is running. Sent once, before any of its output. */
@Serializable
public data class ServiceStarted(
    public val requestId: RequestId,
    public val instance: RunInstance,
    /** The runtime's name for the instance's container. */
    public val container: String,
    /** Where the instance reads its document: the path the image's own arguments name. Present when the run gave a document. */
    public val documentPath: String? = null,
    /** The host address the instance's ports are published on, as service.host names it for the run's runtime. */
    public val address: String,
) {
    /** How Java makes a `ServiceStarted`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
        private val instance: RunInstance,
        private val container: String,
        private val address: String,
    ) {
        private var documentPath: String? = null

        public fun documentPath(documentPath: String?): Builder = apply { this.documentPath = documentPath }

        public fun build(): ServiceStarted = ServiceStarted(requestId = requestId, instance = instance, container = container, documentPath = documentPath, address = address)
    }

    public companion object {
        /** A builder of a `ServiceStarted` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId, instance: RunInstance, container: String, address: String): Builder = Builder(requestId, instance, container, address)
    }
}

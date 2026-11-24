// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The shared worker that does knowledge bases' jobs: its image, its memory and its log level. They are shared, not any knowledge base's, so its document is kept in the launcher's state home, in `stack/workers.yaml`, not in a knowledge base's repository. A knowledge base's jobs are done when its Inference document gives a job an engine. A worker needs only the Gateway, and an issuer's token with the worker's role. */
@Serializable
public data class WorkerPool(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: WorkerPoolKind = WorkerPoolKind.WorkerPool,
    public val metadata: Metadata,
    /** How the worker runs. */
    public val spec: WorkerPoolSpec,
) {
    /** How Java makes a `WorkerPool`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: WorkerPoolSpec,
    ) {
        public fun build(): WorkerPool = WorkerPool(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `WorkerPool` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: WorkerPoolSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}

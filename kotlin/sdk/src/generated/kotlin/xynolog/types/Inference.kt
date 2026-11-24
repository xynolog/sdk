// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The engines a machine uses for a knowledge base: the providers it reaches, and the provider and model each job and each Librarian actor is done with. A knowledge base's repository may carry several, one for each provider, and a machine chooses one. */
@Serializable
public data class Inference(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: InferenceKind = InferenceKind.Inference,
    public val metadata: Metadata,
    /** The providers, and the engine for each job and each Librarian actor. */
    public val spec: InferenceSpec,
) {
    /** How Java makes a `Inference`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: InferenceSpec,
    ) {
        public fun build(): Inference = Inference(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `Inference` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: InferenceSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}

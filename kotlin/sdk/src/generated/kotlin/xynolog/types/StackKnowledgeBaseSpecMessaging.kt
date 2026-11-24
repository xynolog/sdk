// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The broker the job queue and the signal plane share: the launcher's, run from `image`, or somebody else's, at `external`. */
@Serializable
public data class StackKnowledgeBaseSpecMessaging(
    /** The Dispatcher's queue. */
    public val jobs: StackKnowledgeBaseSpecMessagingJobs,
    /** The Gateway's signal plane. */
    public val signal: StackKnowledgeBaseSpecMessagingSignal,
    public val image: Image? = null,
    public val resources: Resources? = null,
    /** A broker somebody else runs, serving this knowledge base alone: a second knowledge base on it would share the job queue and, on a `nats` signal plane, the frames and the gateway's record of pending replies. The launcher refuses to start a knowledge base whose `servers` another knowledge base on its machine names. */
    public val external: StackKnowledgeBaseSpecMessagingExternal? = null,
) {
    /** How Java makes a `StackKnowledgeBaseSpecMessaging`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val jobs: StackKnowledgeBaseSpecMessagingJobs,
        private val signal: StackKnowledgeBaseSpecMessagingSignal,
    ) {
        private var image: Image? = null
        private var resources: Resources? = null
        private var external: StackKnowledgeBaseSpecMessagingExternal? = null

        public fun image(image: Image?): Builder = apply { this.image = image }
        public fun resources(resources: Resources?): Builder = apply { this.resources = resources }
        public fun external(external: StackKnowledgeBaseSpecMessagingExternal?): Builder = apply { this.external = external }

        public fun build(): StackKnowledgeBaseSpecMessaging = StackKnowledgeBaseSpecMessaging(jobs = jobs, signal = signal, image = image, resources = resources, external = external)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecMessaging` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(jobs: StackKnowledgeBaseSpecMessagingJobs, signal: StackKnowledgeBaseSpecMessagingSignal): Builder = Builder(jobs, signal)
    }
}

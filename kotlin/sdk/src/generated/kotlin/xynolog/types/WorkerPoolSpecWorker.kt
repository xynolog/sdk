// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Worker. */
@Serializable
public data class WorkerPoolSpecWorker(
    public val image: Image,
    public val resources: Resources,
) {
    /** How Java makes a `WorkerPoolSpecWorker`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
    ) {
        public fun build(): WorkerPoolSpecWorker = WorkerPoolSpecWorker(image = image, resources = resources)
    }

    public companion object {
        /** A builder of a `WorkerPoolSpecWorker` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources): Builder = Builder(image, resources)
    }
}

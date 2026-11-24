// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The work-queue stream every job is published into. */
@Serializable
public data class JobsStorageStream(
    public val name: String,
    /** The root of the subjects the stream captures: a job is published on `<subjectRoot>.<jobType>`. */
    public val subjectRoot: String,
) {
    /** How Java makes a `JobsStorageStream`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val subjectRoot: String,
    ) {
        public fun build(): JobsStorageStream = JobsStorageStream(name = name, subjectRoot = subjectRoot)
    }

    public companion object {
        /** A builder of a `JobsStorageStream` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, subjectRoot: String): Builder = Builder(name, subjectRoot)
    }
}

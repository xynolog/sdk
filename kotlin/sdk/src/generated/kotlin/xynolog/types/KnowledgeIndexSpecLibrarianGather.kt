// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How a gather waits. */
@Serializable
public data class KnowledgeIndexSpecLibrarianGather(
    /** How long a gather waits for the Smelter to settle a resource, in milliseconds. */
    public val settleTimeoutMs: Long,
) {
    /** How Java makes a `KnowledgeIndexSpecLibrarianGather`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val settleTimeoutMs: Long,
    ) {
        public fun build(): KnowledgeIndexSpecLibrarianGather = KnowledgeIndexSpecLibrarianGather(settleTimeoutMs = settleTimeoutMs)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecLibrarianGather` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(settleTimeoutMs: Long): Builder = Builder(settleTimeoutMs)
    }
}

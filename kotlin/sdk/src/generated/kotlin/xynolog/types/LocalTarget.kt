// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** A local knowledge base, named explicitly: the operations that act on one local stack and never resolve one for the caller (identity administration, a service's run). */
@Serializable
public data class LocalTarget(
    /** Only a local stack. */
    @EncodeDefault
    public val kind: LocalTargetKind = LocalTargetKind.Local,
    /** The knowledge base's clone, by its path. */
    public val root: String,
) {
    /** How Java makes a `LocalTarget`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val root: String,
    ) {
        public fun build(): LocalTarget = LocalTarget(root = root)
    }

    public companion object {
        /** A builder of a `LocalTarget` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(root: String): Builder = Builder(root)
    }
}

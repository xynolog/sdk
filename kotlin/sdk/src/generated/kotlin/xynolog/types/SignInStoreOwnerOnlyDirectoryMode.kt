// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A mode, on a system that has modes. */
@Serializable
public data class SignInStoreOwnerOnlyDirectoryMode(
    /** The mode, in octal. */
    public val value: String,
    public val docs: String,
) {
    /** How Java makes a `SignInStoreOwnerOnlyDirectoryMode`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val value: String,
        private val docs: String,
    ) {
        public fun build(): SignInStoreOwnerOnlyDirectoryMode = SignInStoreOwnerOnlyDirectoryMode(value = value, docs = docs)
    }

    public companion object {
        /** A builder of a `SignInStoreOwnerOnlyDirectoryMode` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(value: String, docs: String): Builder = Builder(value, docs)
    }
}

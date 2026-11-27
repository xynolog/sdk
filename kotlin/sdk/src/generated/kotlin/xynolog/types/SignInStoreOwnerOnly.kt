// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** sign-in-store/owner-only.json: how a writer keeps a directory and a file to its owner. */
@Serializable
public data class SignInStoreOwnerOnly(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** A mode, on a system that has modes. */
    public val directoryMode: SignInStoreOwnerOnlyDirectoryMode,
    /** A mode, on a system that has modes. */
    public val fileMode: SignInStoreOwnerOnlyDirectoryMode,
    /** An access list, on Windows. */
    public val directoryAccessList: SignInStoreOwnerOnlyDirectoryAccessList,
    /** An access list, on Windows. */
    public val fileAccessList: SignInStoreOwnerOnlyDirectoryAccessList,
) {
    /** How Java makes a `SignInStoreOwnerOnly`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val directoryMode: SignInStoreOwnerOnlyDirectoryMode,
        private val fileMode: SignInStoreOwnerOnlyDirectoryMode,
        private val directoryAccessList: SignInStoreOwnerOnlyDirectoryAccessList,
        private val fileAccessList: SignInStoreOwnerOnlyDirectoryAccessList,
    ) {
        public fun build(): SignInStoreOwnerOnly = SignInStoreOwnerOnly(comment = comment, directoryMode = directoryMode, fileMode = fileMode, directoryAccessList = directoryAccessList, fileAccessList = fileAccessList)
    }

    public companion object {
        /** A builder of a `SignInStoreOwnerOnly` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, directoryMode: SignInStoreOwnerOnlyDirectoryMode, fileMode: SignInStoreOwnerOnlyDirectoryMode, directoryAccessList: SignInStoreOwnerOnlyDirectoryAccessList, fileAccessList: SignInStoreOwnerOnlyDirectoryAccessList): Builder = Builder(comment, directoryMode, fileMode, directoryAccessList, fileAccessList)
    }
}

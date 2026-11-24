// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Accounts in the selected knowledge base's launcher-managed identity realm. */
@Serializable
public data class IdentityUsersListResult(
    /** Accounts, sorted by sign-in name. */
    public val users: kotlin.collections.List<IdentityUser>,
) {
    /** How Java makes a `IdentityUsersListResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val users: kotlin.collections.List<IdentityUser>,
    ) {
        public fun build(): IdentityUsersListResult = IdentityUsersListResult(users = users)
    }

    public companion object {
        /** A builder of a `IdentityUsersListResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(users: kotlin.collections.List<IdentityUser>): Builder = Builder(users)
    }
}

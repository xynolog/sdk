// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** List accounts in one local knowledge base's launcher-managed Keycloak realm. */
@Serializable
public data class IdentityUsersListParams(
    public val apiVersion: ApiVersion,
    public val target: LocalTarget,
) {
    /** How Java makes a `IdentityUsersListParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val target: LocalTarget,
    ) {
        public fun build(): IdentityUsersListParams = IdentityUsersListParams(apiVersion = apiVersion, target = target)
    }

    public companion object {
        /** A builder of a `IdentityUsersListParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, target: LocalTarget): Builder = Builder(apiVersion, target)
    }
}

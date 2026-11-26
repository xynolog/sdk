// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** principals/roles.json: the claims a token carries for the gateway to read its holder's roles and kind by, and each role. */
@Serializable
public data class PrincipalsRoles(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The claim whose value is a flat array of the account's roles. */
    public val rolesClaim: String,
    /** Each role the gateway reads. */
    public val roles: kotlin.collections.List<PrincipalsRolesRolesItem>,
    /** The claim that says what kind of account the token's is. */
    public val kindClaim: String,
    /** What the kind claim holds on an agent's account. A person's account carries any other value, or none. */
    public val agentKind: String,
) {
    /** How Java makes a `PrincipalsRoles`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val rolesClaim: String,
        private val roles: kotlin.collections.List<PrincipalsRolesRolesItem>,
        private val kindClaim: String,
        private val agentKind: String,
    ) {
        public fun build(): PrincipalsRoles = PrincipalsRoles(comment = comment, rolesClaim = rolesClaim, roles = roles, kindClaim = kindClaim, agentKind = agentKind)
    }

    public companion object {
        /** A builder of a `PrincipalsRoles` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, rolesClaim: String, roles: kotlin.collections.List<PrincipalsRolesRolesItem>, kindClaim: String, agentKind: String): Builder = Builder(comment, rolesClaim, roles, kindClaim, agentKind)
    }
}

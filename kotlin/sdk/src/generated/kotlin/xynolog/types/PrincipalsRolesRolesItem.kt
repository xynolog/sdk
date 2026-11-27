// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class PrincipalsRolesRolesItem(
    /** The role, as the token carries it. */
    public val role: String,
    /** What it grants, in prose. */
    public val docs: String,
) {
    /** How Java makes a `PrincipalsRolesRolesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val role: String,
        private val docs: String,
    ) {
        public fun build(): PrincipalsRolesRolesItem = PrincipalsRolesRolesItem(role = role, docs = docs)
    }

    public companion object {
        /** A builder of a `PrincipalsRolesRolesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(role: String, docs: String): Builder = Builder(role, docs)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class SessionOauthClientsItem(
    /** What the client is named by in every SDK. */
    public val name: String,
    /** The client id the realm registers. */
    public val id: String,
    /** Its documentation, in prose. */
    public val docs: String,
) {
    /** How Java makes a `SessionOauthClientsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val id: String,
        private val docs: String,
    ) {
        public fun build(): SessionOauthClientsItem = SessionOauthClientsItem(name = name, id = id, docs = docs)
    }

    public companion object {
        /** A builder of a `SessionOauthClientsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, id: String, docs: String): Builder = Builder(name, id, docs)
    }
}

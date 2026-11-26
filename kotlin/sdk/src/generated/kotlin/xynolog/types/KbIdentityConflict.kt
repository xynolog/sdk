// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A different knowledge base answers at a registered address. Both dids, because neither alone says what to do: a person has to recognise which knowledge base they registered and which one answers. What the session's signals raise (client/surface.json's `sessionSignals`). */
@Serializable
public data class KbIdentityConflict(
    /** The did the entry records. */
    public val expectedDid: String,
    /** The did the knowledge base that answered reported. */
    public val observedDid: String,
) {
    /** How Java makes a `KbIdentityConflict`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val expectedDid: String,
        private val observedDid: String,
    ) {
        public fun build(): KbIdentityConflict = KbIdentityConflict(expectedDid = expectedDid, observedDid = observedDid)
    }

    public companion object {
        /** A builder of a `KbIdentityConflict` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(expectedDid: String, observedDid: String): Builder = Builder(expectedDid, observedDid)
    }
}

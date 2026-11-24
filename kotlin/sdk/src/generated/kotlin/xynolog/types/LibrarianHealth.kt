// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The Librarian's health answer (LIBRARIAN.md § Health). Its port opens last, after it has begun to take requests from the bus, so a Librarian whose health answers is answering. */
@Serializable
public data class LibrarianHealth(
    @EncodeDefault
    public val status: LibrarianHealthStatus = LibrarianHealthStatus.Ok,
    /** The DID of the knowledge base it serves: the one its document names, which that knowledge base said it is before the Librarian reached its stores. */
    public val kb: KbDid,
    /** The two actors it runs, `matcher` and `gatherer`. */
    public val actors: kotlin.collections.List<LibrarianHealthActorsItem>,
) {
    /** How Java makes a `LibrarianHealth`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val kb: KbDid,
        private val actors: kotlin.collections.List<LibrarianHealthActorsItem>,
    ) {
        public fun build(): LibrarianHealth = LibrarianHealth(kb = kb, actors = actors)
    }

    public companion object {
        /** A builder of a `LibrarianHealth` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(kb: KbDid, actors: kotlin.collections.List<LibrarianHealthActorsItem>): Builder = Builder(kb, actors)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Librarian: it answers gathers and searches from the indexes. */
@Serializable
public data class KnowledgeIndexSpecLibrarian(
    public val image: Image,
    public val resources: Resources,
    /** How a gather waits. */
    public val gather: KnowledgeIndexSpecLibrarianGather,
    /** What a search by meaning keeps. */
    public val search: KnowledgeIndexSpecLibrarianSearch,
) {
    /** How Java makes a `KnowledgeIndexSpecLibrarian`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
        private val gather: KnowledgeIndexSpecLibrarianGather,
        private val search: KnowledgeIndexSpecLibrarianSearch,
    ) {
        public fun build(): KnowledgeIndexSpecLibrarian = KnowledgeIndexSpecLibrarian(image = image, resources = resources, gather = gather, search = search)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecLibrarian` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources, gather: KnowledgeIndexSpecLibrarianGather, search: KnowledgeIndexSpecLibrarianSearch): Builder = Builder(image, resources, gather, search)
    }
}

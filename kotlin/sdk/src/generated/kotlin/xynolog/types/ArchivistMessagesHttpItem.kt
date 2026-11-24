// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ArchivistMessagesHttpItem(
    /** The situation's name. */
    public val name: String,
    /** The route's method. */
    public val method: ArchivistMessagesHttpItemMethod,
    /** The route, as the Archivist's API names its path. */
    public val route: String,
    public val status: HttpStatus,
    /** The body's `code`, where it carries one. */
    public val code: String? = null,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The body's `error`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies. */
    public val error: String,
) {
    /** How Java makes a `ArchivistMessagesHttpItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val method: ArchivistMessagesHttpItemMethod,
        private val route: String,
        private val status: HttpStatus,
        private val situation: String,
        private val error: String,
    ) {
        private var code: String? = null

        public fun code(code: String?): Builder = apply { this.code = code }

        public fun build(): ArchivistMessagesHttpItem = ArchivistMessagesHttpItem(name = name, method = method, route = route, status = status, code = code, situation = situation, error = error)
    }

    public companion object {
        /** A builder of a `ArchivistMessagesHttpItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, method: ArchivistMessagesHttpItemMethod, route: String, status: HttpStatus, situation: String, error: String): Builder = Builder(name, method, route, status, situation, error)
    }
}

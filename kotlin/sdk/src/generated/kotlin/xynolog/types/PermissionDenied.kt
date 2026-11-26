// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A request was refused for lack of permission. What the session's signals raise (client/surface.json's `sessionSignals`). */
@Serializable
public data class PermissionDenied(
    /** The refusal's own message, untranslated; null when it gave none. */
    public val detail: String?,
) {
    /** How Java makes a `PermissionDenied`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val detail: String?,
    ) {
        public fun build(): PermissionDenied = PermissionDenied(detail = detail)
    }

    public companion object {
        /** A builder of a `PermissionDenied` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(detail: String?): Builder = Builder(detail)
    }
}

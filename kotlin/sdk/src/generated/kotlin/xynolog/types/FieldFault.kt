// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One fault in a request's params, named where it is. */
@Serializable
public data class FieldFault(
    /** Where in the params the fault is, as a JSON pointer (RFC 6901); empty for the params as a whole. */
    public val field: String,
    /** What is wrong there. */
    public val message: String,
) {
    /** How Java makes a `FieldFault`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val field: String,
        private val message: String,
    ) {
        public fun build(): FieldFault = FieldFault(field = field, message = message)
    }

    public companion object {
        /** A builder of a `FieldFault` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(field: String, message: String): Builder = Builder(field, message)
    }
}

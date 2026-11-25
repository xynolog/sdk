// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ControlMethodsMethodsItem(
    /** The method's name. */
    public val name: String,
    /** A schema of control/, by its $id. */
    public val params: String,
    /** A schema of control/, by its $id. */
    public val result: String,
    /** Whether a request waits for every other exclusive request to end, and holds the others off until it does. */
    public val exclusive: Boolean,
    /** The notifications a request may send besides notifications/progress. */
    public val sends: kotlin.collections.List<String>,
    /** What the method does. */
    public val docs: String,
) {
    /** How Java makes a `ControlMethodsMethodsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val params: String,
        private val result: String,
        private val exclusive: Boolean,
        private val sends: kotlin.collections.List<String>,
        private val docs: String,
    ) {
        public fun build(): ControlMethodsMethodsItem = ControlMethodsMethodsItem(name = name, params = params, result = result, exclusive = exclusive, sends = sends, docs = docs)
    }

    public companion object {
        /** A builder of a `ControlMethodsMethodsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, params: String, result: String, exclusive: Boolean, sends: kotlin.collections.List<String>, docs: String): Builder = Builder(name, params, result, exclusive, sends, docs)
    }
}

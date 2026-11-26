// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
public data class ClientOptionDefaultsDefaultsItem(
    /** What takes the option, as client/surface.json names it: a namespace's method, or a module's function, the two joined by a dot. */
    public val method: String,
    /** The parameter it is, or the parameter whose member it is. */
    public val parameter: String,
    /** The member of the parameter it is, where the parameter is an object of options. Absent: the parameter itself. */
    public val option: String? = null,
    public val value: JsonElement,
    /** What the parameter is. Left out where it is the SDK's own: its error, which no schema states. */
    public val schema: ClientOptionDefaultsDefaultsItemSchema? = null,
    /** Where in the request the method sends it, as a JSON Pointer into a case's `sends`. Absent: the option is not sent, and only changes what the client does. */
    public val sends: String? = null,
    /** What the option is, in prose. */
    public val docs: String,
) {
    /** How Java makes a `ClientOptionDefaultsDefaultsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val method: String,
        private val parameter: String,
        private val value: JsonElement,
        private val docs: String,
    ) {
        private var option: String? = null
        private var schema: ClientOptionDefaultsDefaultsItemSchema? = null
        private var sends: String? = null

        public fun option(option: String?): Builder = apply { this.option = option }
        public fun schema(schema: ClientOptionDefaultsDefaultsItemSchema?): Builder = apply { this.schema = schema }
        public fun sends(sends: String?): Builder = apply { this.sends = sends }

        public fun build(): ClientOptionDefaultsDefaultsItem = ClientOptionDefaultsDefaultsItem(method = method, parameter = parameter, option = option, value = value, schema = schema, sends = sends, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaultsDefaultsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(method: String, parameter: String, value: JsonElement, docs: String): Builder = Builder(method, parameter, value, docs)
    }
}

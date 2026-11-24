// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** service-environment/variables.json: every environment variable a Xynolog service reads, beside its configuration document. */
@Serializable
public data class ServiceEnvironmentVariables(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val variables: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItem>,
) {
    /** How Java makes a `ServiceEnvironmentVariables`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val variables: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItem>,
    ) {
        public fun build(): ServiceEnvironmentVariables = ServiceEnvironmentVariables(comment = comment, variables = variables)
    }

    public companion object {
        /** A builder of a `ServiceEnvironmentVariables` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, variables: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItem>): Builder = Builder(comment, variables)
    }
}

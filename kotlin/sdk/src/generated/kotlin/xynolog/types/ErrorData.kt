// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The data of a control error: the launcher's code for the failure, one of specs/src/errors/codes.json's control group, and what a client can act on. A request's failure is never only a message. */
@Serializable
public data class ErrorData(
    /** Why the request failed: a code of the control group of specs/src/errors/codes.json. */
    public val code: String,
    /** Whether the same request can succeed sent again unchanged, once something outside it changes: a start finishes, a runtime is installed, a stack comes up. */
    public val retryable: Boolean,
    /** For params the contract refuses: each fault, where it is. */
    public val fields: kotlin.collections.List<FieldFault>? = null,
    /** For control.target-required and control.target-ambiguous: each target the request could have meant, to send again with one. */
    public val choices: kotlin.collections.List<Target>? = null,
    /** For control.unsupported-api-version: each version this launcher speaks. */
    public val supported: kotlin.collections.List<String>? = null,
    /** For a cancelled stack.start: whether services the start launched may still be running. The launcher stops waiting, and stops nothing. */
    public val mayStillRun: Boolean? = null,
) {
    /** How Java makes a `ErrorData`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val retryable: Boolean,
    ) {
        private var fields: kotlin.collections.List<FieldFault>? = null
        private var choices: kotlin.collections.List<Target>? = null
        private var supported: kotlin.collections.List<String>? = null
        private var mayStillRun: Boolean? = null

        public fun fields(fields: kotlin.collections.List<FieldFault>?): Builder = apply { this.fields = fields }
        public fun choices(choices: kotlin.collections.List<Target>?): Builder = apply { this.choices = choices }
        public fun supported(supported: kotlin.collections.List<String>?): Builder = apply { this.supported = supported }
        public fun mayStillRun(mayStillRun: Boolean?): Builder = apply { this.mayStillRun = mayStillRun }

        public fun build(): ErrorData = ErrorData(code = code, retryable = retryable, fields = fields, choices = choices, supported = supported, mayStillRun = mayStillRun)
    }

    public companion object {
        /** A builder of a `ErrorData` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, retryable: Boolean): Builder = Builder(code, retryable)
    }
}

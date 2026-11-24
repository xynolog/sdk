// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The backend does something (conformance/sdk/README.md, "Backend directives"). */
@Serializable
public data class ConformanceStepBackend(
    /** The directive. */
    public val backend: ConformanceStepBackendBackend,
    /** The directive's arguments. */
    public val with: kotlin.collections.Map<String, JsonElement>? = null,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepBackend`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val backend: ConformanceStepBackendBackend,
    ) {
        private var with: kotlin.collections.Map<String, JsonElement>? = null

        public fun with(with: kotlin.collections.Map<String, JsonElement>?): Builder = apply { this.with = with }

        public fun build(): ConformanceStepBackend = ConformanceStepBackend(backend = backend, with = with)
    }

    public companion object {
        /** A builder of a `ConformanceStepBackend` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(backend: ConformanceStepBackendBackend): Builder = Builder(backend)
    }
}

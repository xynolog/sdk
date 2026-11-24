// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A read over HTTP a live case expects the client to make: an operation of the gateway's API by its method and path, with the values its path carries. The stand-in Archivist answers it from what the case seeded. */
@Serializable
public data class ConformanceHttpFetch(
    /** The operation, by its method and path. */
    public val fetch: String,
    public val params: JsonElement? = null,
) : ConformanceStep,
    ConformanceStepFetchesFetchesItem {
    /** How Java makes a `ConformanceHttpFetch`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val fetch: String,
    ) {
        private var params: JsonElement? = null

        public fun params(params: JsonElement?): Builder = apply { this.params = params }

        public fun build(): ConformanceHttpFetch = ConformanceHttpFetch(fetch = fetch, params = params)
    }

    public companion object {
        /** A builder of a `ConformanceHttpFetch` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(fetch: String): Builder = Builder(fetch)
    }
}

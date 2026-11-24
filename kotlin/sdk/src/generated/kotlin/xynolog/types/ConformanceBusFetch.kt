// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A request on the bus a live case expects the client to make, on this channel; `as` names its correlation id, for the backend to answer. */
@Serializable
public data class ConformanceBusFetch(
    /** The request's channel, a request of specs/src/bus/registry.json. */
    public val fetch: String,
    public val payload: JsonElement? = null,
    /** The request's correlation id, for the backend's answer. */
    public val `as`: String,
) : ConformanceStep,
    ConformanceStepFetchesFetchesItem {
    /** How Java makes a `ConformanceBusFetch`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val fetch: String,
        private val `as`: String,
    ) {
        private var payload: JsonElement? = null

        public fun payload(payload: JsonElement?): Builder = apply { this.payload = payload }

        public fun build(): ConformanceBusFetch = ConformanceBusFetch(fetch = fetch, payload = payload, `as` = `as`)
    }

    public companion object {
        /** A builder of a `ConformanceBusFetch` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(fetch: String, `as`: String): Builder = Builder(fetch, `as`)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement
import xynolog.identifiers.ResourceId

/** The frame. */
@Serializable
public data class ConformanceDriverLineFrameFrame(
    /** The channel. */
    public val channel: String,
    public val payload: JsonElement? = null,
    /** The frame's correlation id, when it has one. */
    public val correlationId: String? = null,
    /** The frame's scope, when it has one. */
    @get:JvmExposeBoxed
    public val scope: ResourceId? = null,
) {
    /** How Java makes a `ConformanceDriverLineFrameFrame`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val channel: String,
    ) {
        private var payload: JsonElement? = null
        private var correlationId: String? = null
        private var scope: ResourceId? = null

        public fun payload(payload: JsonElement?): Builder = apply { this.payload = payload }
        public fun correlationId(correlationId: String?): Builder = apply { this.correlationId = correlationId }

        @JvmExposeBoxed
        public fun scope(scope: ResourceId?): Builder = apply { this.scope = scope }

        public fun build(): ConformanceDriverLineFrameFrame = ConformanceDriverLineFrameFrame(channel = channel, payload = payload, correlationId = correlationId, scope = scope)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineFrameFrame` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(channel: String): Builder = Builder(channel)
    }
}

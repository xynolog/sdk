// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement
import xynolog.identifiers.ResourceId

/** A frame refused, given to its readers in its place: by its transport, for its first fault as BusFrame, or by its channel's typed read, for its payload's first fault as its channel's (contract/TRANSPORT-CONTRACT.md § Frames). A transport's own, never on the wire. */
@Serializable
public data class FrameRefusal(
    /** The channel the frame names. */
    public val channel: String,
    /** The way from the frame to its first fault; a fault of its payload is within `payload`. */
    public val member: String,
    /** Why it is at fault. */
    public val reason: FrameRefusalReason,
    public val payload: JsonElement? = null,
    /** The resource whose scope it was delivered on; absent when it names none. */
    @get:JvmExposeBoxed
    public val scope: ResourceId? = null,
    /** The frame's correlation id, when it carries one BusFrame allows: a request awaiting the reply it names is told of the refusal at once. */
    public val correlationId: String? = null,
) {
    /** How Java makes a `FrameRefusal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val channel: String,
        private val member: String,
        private val reason: FrameRefusalReason,
    ) {
        private var payload: JsonElement? = null
        private var scope: ResourceId? = null
        private var correlationId: String? = null

        public fun payload(payload: JsonElement?): Builder = apply { this.payload = payload }

        @JvmExposeBoxed
        public fun scope(scope: ResourceId?): Builder = apply { this.scope = scope }

        public fun correlationId(correlationId: String?): Builder = apply { this.correlationId = correlationId }

        public fun build(): FrameRefusal = FrameRefusal(channel = channel, member = member, reason = reason, payload = payload, scope = scope, correlationId = correlationId)
    }

    public companion object {
        /** A builder of a `FrameRefusal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(channel: String, member: String, reason: FrameRefusalReason): Builder = Builder(channel, member, reason)
    }
}

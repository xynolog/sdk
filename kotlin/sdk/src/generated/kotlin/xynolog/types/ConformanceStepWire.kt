// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The next request the client put on the wire is this operation, with each field given. */
@Serializable
public data class ConformanceStepWire(
    /** The operation of the gateway's API, by its method and path. */
    public val wire: String,
    /** When it is read: on arrival, once answered (the default), or once its stream has caught up. */
    public val at: ConformanceStepWireAt? = null,
    /** The status it was answered with. */
    public val status: Long? = null,
    public val params: JsonElement? = null,
    public val body: JsonElement? = null,
    public val token: JsonElement? = null,
    /** The request's headers named here, each as a pattern; headers not named are not compared. */
    public val headers: kotlin.collections.Map<String, JsonElement>? = null,
    public val answer: JsonElement? = null,
    /** The request's name, for a later step. */
    public val `as`: String? = null,
    /** A request named earlier, which was answered before this one arrived. */
    public val follows: String? = null,
    /** A request named earlier, answered with a Retry-After, which this one waited out. */
    public val waited: String? = null,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepWire`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val wire: String,
    ) {
        private var at: ConformanceStepWireAt? = null
        private var status: Long? = null
        private var params: JsonElement? = null
        private var body: JsonElement? = null
        private var token: JsonElement? = null
        private var headers: kotlin.collections.Map<String, JsonElement>? = null
        private var answer: JsonElement? = null
        private var `as`: String? = null
        private var follows: String? = null
        private var waited: String? = null

        public fun at(at: ConformanceStepWireAt?): Builder = apply { this.at = at }
        public fun status(status: Long?): Builder = apply { this.status = status }
        public fun params(params: JsonElement?): Builder = apply { this.params = params }
        public fun body(body: JsonElement?): Builder = apply { this.body = body }
        public fun token(token: JsonElement?): Builder = apply { this.token = token }
        public fun headers(headers: kotlin.collections.Map<String, JsonElement>?): Builder = apply { this.headers = headers }
        public fun answer(answer: JsonElement?): Builder = apply { this.answer = answer }
        public fun `as`(`as`: String?): Builder = apply { this.`as` = `as` }
        public fun follows(follows: String?): Builder = apply { this.follows = follows }
        public fun waited(waited: String?): Builder = apply { this.waited = waited }

        public fun build(): ConformanceStepWire = ConformanceStepWire(wire = wire, at = at, status = status, params = params, body = body, token = token, headers = headers, answer = answer, `as` = `as`, follows = follows, waited = waited)
    }

    public companion object {
        /** A builder of a `ConformanceStepWire` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(wire: String): Builder = Builder(wire)
    }
}

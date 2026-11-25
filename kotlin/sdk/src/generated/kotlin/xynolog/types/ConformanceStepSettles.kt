// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** An operation started with `as` settles: it succeeded, with `returns` when given; or failed with `fails`; or, `abandoned`, it ended because the case abandoned it and reported nothing. */
@Serializable
public data class ConformanceStepSettles(
    /** The operation. */
    public val settles: String,
    public val returns: JsonElement? = null,
    public val fails: JsonElement? = null,
    /** It ended because the case abandoned it. */
    public val abandoned: ConformanceStepSettlesAbandoned? = null,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepSettles`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val settles: String,
    ) {
        private var returns: JsonElement? = null
        private var fails: JsonElement? = null
        private var abandoned: ConformanceStepSettlesAbandoned? = null

        public fun returns(returns: JsonElement?): Builder = apply { this.returns = returns }
        public fun fails(fails: JsonElement?): Builder = apply { this.fails = fails }
        public fun abandoned(abandoned: ConformanceStepSettlesAbandoned?): Builder = apply { this.abandoned = abandoned }

        public fun build(): ConformanceStepSettles = ConformanceStepSettles(settles = settles, returns = returns, fails = fails, abandoned = abandoned)
    }

    public companion object {
        /** A builder of a `ConformanceStepSettles` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(settles: String): Builder = Builder(settles)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** Ask the driver for an operation. It must succeed, with `returns` when given, or fail with `fails`. With `as`, the step does not wait: a later `settles` step does. */
@Serializable
public data class ConformanceStepDriver(
    /** The operation (conformance/sdk/README.md, "Operations"). */
    public val driver: String,
    /** The operation's arguments. */
    public val with: kotlin.collections.Map<String, JsonElement>? = null,
    public val returns: JsonElement? = null,
    public val fails: JsonElement? = null,
    /** The operation's name, for the `settles` or `abandon` step that ends it. */
    public val `as`: String? = null,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepDriver`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val driver: String,
    ) {
        private var with: kotlin.collections.Map<String, JsonElement>? = null
        private var returns: JsonElement? = null
        private var fails: JsonElement? = null
        private var `as`: String? = null

        public fun with(with: kotlin.collections.Map<String, JsonElement>?): Builder = apply { this.with = with }
        public fun returns(returns: JsonElement?): Builder = apply { this.returns = returns }
        public fun fails(fails: JsonElement?): Builder = apply { this.fails = fails }
        public fun `as`(`as`: String?): Builder = apply { this.`as` = `as` }

        public fun build(): ConformanceStepDriver = ConformanceStepDriver(driver = driver, with = with, returns = returns, fails = fails, `as` = `as`)
    }

    public companion object {
        /** A builder of a `ConformanceStepDriver` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(driver: String): Builder = Builder(driver)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ServiceTelemetryLogLinesBusPartsItem(
    /** What it shows. */
    public val part: String,
    /** Its text. */
    public val text: String,
    /** How many characters of it are shown, from its first. */
    public val characters: Long? = null,
) {
    /** How Java makes a `ServiceTelemetryLogLinesBusPartsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val part: String,
        private val text: String,
    ) {
        private var characters: Long? = null

        public fun characters(characters: Long?): Builder = apply { this.characters = characters }

        public fun build(): ServiceTelemetryLogLinesBusPartsItem = ServiceTelemetryLogLinesBusPartsItem(part = part, text = text, characters = characters)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLinesBusPartsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(part: String, text: String): Builder = Builder(part, text)
    }
}

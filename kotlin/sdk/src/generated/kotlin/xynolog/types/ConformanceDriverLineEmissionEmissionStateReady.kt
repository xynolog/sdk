// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
public data class ConformanceDriverLineEmissionEmissionStateReady(
    /** A value to show. */
    @EncodeDefault
    public val status: ConformanceDriverLineEmissionEmissionStateReadyStatus = ConformanceDriverLineEmissionEmissionStateReadyStatus.Ready,
    public val value: JsonElement,
) : ConformanceDriverLineEmissionEmissionState {
    /** How Java makes a `ConformanceDriverLineEmissionEmissionStateReady`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val value: JsonElement,
    ) {
        public fun build(): ConformanceDriverLineEmissionEmissionStateReady = ConformanceDriverLineEmissionEmissionStateReady(value = value)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineEmissionEmissionStateReady` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(value: JsonElement): Builder = Builder(value)
    }
}

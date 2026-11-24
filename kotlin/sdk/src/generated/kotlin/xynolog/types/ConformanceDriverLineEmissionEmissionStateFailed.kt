// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

@Serializable
public data class ConformanceDriverLineEmissionEmissionStateFailed(
    /** The query failed. */
    @EncodeDefault
    public val status: ConformanceDriverLineEmissionEmissionStateFailedStatus = ConformanceDriverLineEmissionEmissionStateFailedStatus.Failed,
    /** The failure. */
    public val error: ConformanceFailure,
) : ConformanceDriverLineEmissionEmissionState {
    /** How Java makes a `ConformanceDriverLineEmissionEmissionStateFailed`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val error: ConformanceFailure,
    ) {
        public fun build(): ConformanceDriverLineEmissionEmissionStateFailed = ConformanceDriverLineEmissionEmissionStateFailed(error = error)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineEmissionEmissionStateFailed` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(error: ConformanceFailure): Builder = Builder(error)
    }
}

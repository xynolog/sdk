// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The driver can take operations. */
@Serializable
public data class ConformanceDriverLineReady(
    /** Written once. */
    @EncodeDefault
    public val ready: ConformanceDriverLineReadyReady = ConformanceDriverLineReadyReady,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineReady`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        public fun build(): ConformanceDriverLineReady = ConformanceDriverLineReady()
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineReady` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}

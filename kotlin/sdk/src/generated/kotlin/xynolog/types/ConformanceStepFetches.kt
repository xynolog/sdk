// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Live: the next requests the client makes of a service are these, in whatever order it makes them. */
@Serializable
public data class ConformanceStepFetches(
    /** The requests. */
    public val fetches: kotlin.collections.List<ConformanceStepFetchesFetchesItem>,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepFetches`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val fetches: kotlin.collections.List<ConformanceStepFetchesFetchesItem>,
    ) {
        public fun build(): ConformanceStepFetches = ConformanceStepFetches(fetches = fetches)
    }

    public companion object {
        /** A builder of a `ConformanceStepFetches` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(fetches: kotlin.collections.List<ConformanceStepFetchesFetchesItem>): Builder = Builder(fetches)
    }
}

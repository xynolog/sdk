// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The providers, and the engine for each job and each Librarian actor. */
@Serializable
public data class InferenceSpec(
    /** Each provider an engine names, and how it is reached. */
    public val providers: kotlin.collections.Map<InferenceProvider, Provider>,
    /** The engine each job is done with when software does it, and the engine each Librarian actor asks. */
    public val engines: ArchivistEngines,
) {
    /** How Java makes a `InferenceSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val providers: kotlin.collections.Map<InferenceProvider, Provider>,
        private val engines: ArchivistEngines,
    ) {
        public fun build(): InferenceSpec = InferenceSpec(providers = providers, engines = engines)
    }

    public companion object {
        /** A builder of a `InferenceSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(providers: kotlin.collections.Map<InferenceProvider, Provider>, engines: ArchivistEngines): Builder = Builder(providers, engines)
    }
}

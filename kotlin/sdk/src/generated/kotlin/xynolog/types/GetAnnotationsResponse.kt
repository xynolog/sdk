// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

@Serializable
@JsonIgnoreUnknownKeys
public data class GetAnnotationsResponse(
    public val annotations: kotlin.collections.List<Annotation>,
    /** Total number of annotations */
    public val total: Double,
    /** Motivation filter applied (if any) */
    public val motivation: Motivation? = null,
) {
    /** How Java makes a `GetAnnotationsResponse`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val annotations: kotlin.collections.List<Annotation>,
        private val total: Double,
    ) {
        private var motivation: Motivation? = null

        public fun motivation(motivation: Motivation?): Builder = apply { this.motivation = motivation }

        public fun build(): GetAnnotationsResponse = GetAnnotationsResponse(annotations = annotations, total = total, motivation = motivation)
    }

    public companion object {
        /** A builder of a `GetAnnotationsResponse` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(annotations: kotlin.collections.List<Annotation>, total: Double): Builder = Builder(annotations, total)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The live query. */
@Serializable
public data class ConformanceStepObserveObserve(
    /** The live query, by its name in specs/src/client/refresh.json. */
    public val query: String,
    public val resource: JsonElement? = null,
    public val annotation: JsonElement? = null,
    public val search: JsonElement? = null,
    public val filters: JsonElement? = null,
) {
    /** How Java makes a `ConformanceStepObserveObserve`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val query: String,
    ) {
        private var resource: JsonElement? = null
        private var annotation: JsonElement? = null
        private var search: JsonElement? = null
        private var filters: JsonElement? = null

        public fun resource(resource: JsonElement?): Builder = apply { this.resource = resource }
        public fun annotation(annotation: JsonElement?): Builder = apply { this.annotation = annotation }
        public fun search(search: JsonElement?): Builder = apply { this.search = search }
        public fun filters(filters: JsonElement?): Builder = apply { this.filters = filters }

        public fun build(): ConformanceStepObserveObserve = ConformanceStepObserveObserve(query = query, resource = resource, annotation = annotation, search = search, filters = filters)
    }

    public companion object {
        /** A builder of a `ConformanceStepObserveObserve` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(query: String): Builder = Builder(query)
    }
}

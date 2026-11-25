// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Where in the event a subject row finds the resource and the annotation it names. */
@Serializable
public data class ClientRefreshRefreshItemOnNames(
    /** A way into the event's payload: the names of the members it passes through and of its own, joined by dots. */
    public val resource: String? = null,
    /** A way into the event's payload: the names of the members it passes through and of its own, joined by dots. */
    public val annotation: String? = null,
) {
    /** How Java makes a `ClientRefreshRefreshItemOnNames`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var resource: String? = null
        private var annotation: String? = null

        public fun resource(resource: String?): Builder = apply { this.resource = resource }
        public fun annotation(annotation: String?): Builder = apply { this.annotation = annotation }

        public fun build(): ClientRefreshRefreshItemOnNames = ClientRefreshRefreshItemOnNames(resource = resource, annotation = annotation)
    }

    public companion object {
        /** A builder of a `ClientRefreshRefreshItemOnNames` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}

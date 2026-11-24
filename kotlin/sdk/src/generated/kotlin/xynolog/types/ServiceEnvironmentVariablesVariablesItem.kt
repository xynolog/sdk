// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ServiceEnvironmentVariablesVariablesItem(
    /** The variable's name. */
    public val name: String,
    /** The services that read it. */
    public val services: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItemServicesItem>,
    /** What reads it: the service's own code, or the OpenTelemetry SDK. */
    public val readBy: ServiceEnvironmentVariablesVariablesItemReadBy,
    /** What sets it where the launcher runs the service. */
    public val providedBy: ServiceEnvironmentVariablesVariablesItemProvidedBy,
    /** Whether the service refuses to start without it. */
    public val required: Boolean,
    /** What it does. */
    public val effect: String,
) {
    /** How Java makes a `ServiceEnvironmentVariablesVariablesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val services: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItemServicesItem>,
        private val readBy: ServiceEnvironmentVariablesVariablesItemReadBy,
        private val providedBy: ServiceEnvironmentVariablesVariablesItemProvidedBy,
        private val required: Boolean,
        private val effect: String,
    ) {
        public fun build(): ServiceEnvironmentVariablesVariablesItem = ServiceEnvironmentVariablesVariablesItem(name = name, services = services, readBy = readBy, providedBy = providedBy, required = required, effect = effect)
    }

    public companion object {
        /** A builder of a `ServiceEnvironmentVariablesVariablesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, services: kotlin.collections.List<ServiceEnvironmentVariablesVariablesItemServicesItem>, readBy: ServiceEnvironmentVariablesVariablesItemReadBy, providedBy: ServiceEnvironmentVariablesVariablesItemProvidedBy, required: Boolean, effect: String): Builder = Builder(name, services, readBy, providedBy, required, effect)
    }
}

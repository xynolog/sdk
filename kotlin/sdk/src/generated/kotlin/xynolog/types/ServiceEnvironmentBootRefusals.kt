// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** service-environment/boot-refusals.json: what a service writes when it refuses to start on its configuration document or its environment. */
@Serializable
public data class ServiceEnvironmentBootRefusals(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The services that refuse to start so. */
    public val services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>,
    /** The one line the service writes to stderr, its refusal in place of `{refusal}`, before it exits. */
    public val line: String,
    /** The status it exits with. */
    public val exitCode: Long,
    /** Each refusal. */
    public val refusals: kotlin.collections.List<ServiceEnvironmentBootRefusalsRefusalsItem>,
    /** Each line of the refusal `invalid`: one for each way the document is not its schema's. */
    public val members: kotlin.collections.List<ServiceEnvironmentBootRefusalsMembersItem>,
) {
    /** How Java makes a `ServiceEnvironmentBootRefusals`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>,
        private val line: String,
        private val exitCode: Long,
        private val refusals: kotlin.collections.List<ServiceEnvironmentBootRefusalsRefusalsItem>,
        private val members: kotlin.collections.List<ServiceEnvironmentBootRefusalsMembersItem>,
    ) {
        public fun build(): ServiceEnvironmentBootRefusals = ServiceEnvironmentBootRefusals(comment = comment, services = services, line = line, exitCode = exitCode, refusals = refusals, members = members)
    }

    public companion object {
        /** A builder of a `ServiceEnvironmentBootRefusals` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>, line: String, exitCode: Long, refusals: kotlin.collections.List<ServiceEnvironmentBootRefusalsRefusalsItem>, members: kotlin.collections.List<ServiceEnvironmentBootRefusalsMembersItem>): Builder = Builder(comment, services, line, exitCode, refusals, members)
    }
}

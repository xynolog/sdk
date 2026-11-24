// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** One of a knowledge base's own services, which service.run runs: the seven Xynolog services, as service-telemetry/telemetry.json names them. The reader holds the two lists to each other. */
@Serializable
public enum class RunService(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("archivist")
    Archivist("archivist"),

    @SerialName("dispatcher")
    Dispatcher("dispatcher"),

    @SerialName("gateway")
    Gateway("gateway"),

    @SerialName("librarian")
    Librarian("librarian"),

    @SerialName("smelter")
    Smelter("smelter"),

    @SerialName("weaver")
    Weaver("weaver"),

    @SerialName("worker")
    Worker("worker"),
}

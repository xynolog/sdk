// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** A group of services, as xynolog status reports them and --group names them: a knowledge base's record and its index, the issuer that signs its accounts in, the knowledge workers where people and agents work on it, the providers of its models, and the telemetry that watches them all. */
@Serializable
public enum class ServiceGroup(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("record")
    Record("record"),

    @SerialName("index")
    Index("index"),

    @SerialName("issuer")
    Issuer("issuer"),

    @SerialName("knowledge-workers")
    KnowledgeWorkers("knowledge-workers"),

    @SerialName("providers")
    Providers("providers"),

    @SerialName("telemetry")
    Telemetry("telemetry"),
}

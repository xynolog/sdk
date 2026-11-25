// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** Document schema version. Consumers MUST check it and ignore documents they do not understand. */
@Serializable(with = DiscoveryDocumentVersion.Serializer::class)
public data object DiscoveryDocumentVersion {
    internal object Serializer : ConstantSerializer<DiscoveryDocumentVersion>(DiscoveryDocumentVersion, JsonPrimitive(1))
}

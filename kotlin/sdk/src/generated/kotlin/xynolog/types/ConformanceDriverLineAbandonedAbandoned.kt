// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** It was abandoned. */
@Serializable(with = ConformanceDriverLineAbandonedAbandoned.Serializer::class)
public data object ConformanceDriverLineAbandonedAbandoned {
    internal object Serializer : ConstantSerializer<ConformanceDriverLineAbandonedAbandoned>(ConformanceDriverLineAbandonedAbandoned, JsonPrimitive(true))
}

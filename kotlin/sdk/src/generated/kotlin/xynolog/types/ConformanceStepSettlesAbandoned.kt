// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** It ended because the case abandoned it. */
@Serializable(with = ConformanceStepSettlesAbandoned.Serializer::class)
public data object ConformanceStepSettlesAbandoned {
    internal object Serializer : ConstantSerializer<ConformanceStepSettlesAbandoned>(ConformanceStepSettlesAbandoned, JsonPrimitive(true))
}

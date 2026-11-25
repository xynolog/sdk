// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** Written once. */
@Serializable(with = ConformanceDriverLineReadyReady.Serializer::class)
public data object ConformanceDriverLineReadyReady {
    internal object Serializer : ConstantSerializer<ConformanceDriverLineReadyReady>(ConformanceDriverLineReadyReady, JsonPrimitive(true))
}

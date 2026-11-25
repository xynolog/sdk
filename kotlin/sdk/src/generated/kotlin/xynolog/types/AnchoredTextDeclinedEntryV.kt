// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** The entry format. */
@Serializable(with = AnchoredTextDeclinedEntryV.Serializer::class)
public data object AnchoredTextDeclinedEntryV {
    internal object Serializer : ConstantSerializer<AnchoredTextDeclinedEntryV>(AnchoredTextDeclinedEntryV, JsonPrimitive(3))
}

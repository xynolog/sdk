// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** The entry format. */
@Serializable(with = AnchoredTextExtractedEntryV.Serializer::class)
public data object AnchoredTextExtractedEntryV {
    internal object Serializer : ConstantSerializer<AnchoredTextExtractedEntryV>(AnchoredTextExtractedEntryV, JsonPrimitive(3))
}

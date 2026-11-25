// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** Always true. It is what tells a decline from the result of a job that did its work, which never carries it. */
@Serializable(with = JobDeclinedDeclined.Serializer::class)
public data object JobDeclinedDeclined {
    internal object Serializer : ConstantSerializer<JobDeclinedDeclined>(JobDeclinedDeclined, JsonPrimitive(true))
}

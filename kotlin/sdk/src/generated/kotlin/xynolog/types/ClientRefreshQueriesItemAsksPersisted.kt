// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** Its answers are kept across a client's lives. */
@Serializable(with = ClientRefreshQueriesItemAsksPersisted.Serializer::class)
public data object ClientRefreshQueriesItemAsksPersisted {
    internal object Serializer : ConstantSerializer<ClientRefreshQueriesItemAsksPersisted>(ClientRefreshQueriesItemAsksPersisted, JsonPrimitive(true))
}

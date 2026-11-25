// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ConformanceStepFetchesFetchesItemSerializer::class)
public sealed interface ConformanceStepFetchesFetchesItem

internal object ConformanceStepFetchesFetchesItemSerializer : SignatureUnionSerializer<ConformanceStepFetchesFetchesItem>(
    ConformanceStepFetchesFetchesItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fetch", "as"),
                allowed = listOf("fetch", "payload", "as"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fetch"),
                allowed = listOf("fetch", "params"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ConformanceBusFetch.serializer(),
            ConformanceHttpFetch.serializer(),
        )
    },
)

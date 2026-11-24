// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ConformanceStepFetchesFetchesItemSerializer::class)
public sealed interface ConformanceStepFetchesFetchesItem

internal object ConformanceStepFetchesFetchesItemSerializer : KindsUnionSerializer<ConformanceStepFetchesFetchesItem>(
    ConformanceStepFetchesFetchesItem::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(ConformanceBusFetch.serializer(), ConformanceHttpFetch.serializer()) },
)

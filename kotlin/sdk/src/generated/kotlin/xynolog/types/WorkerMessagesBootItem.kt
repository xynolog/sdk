// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = WorkerMessagesBootItemSerializer::class)
public sealed interface WorkerMessagesBootItem

internal object WorkerMessagesBootItemSerializer : KindsUnionSerializer<WorkerMessagesBootItem>(
    WorkerMessagesBootItem::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(WorkerMessagesBootItemOwnBootRefusal.serializer(), WorkerMessagesBootItemSharedBootRefusal.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = WorkerMessagesBootItemSerializer::class)
public sealed interface WorkerMessagesBootItem

internal object WorkerMessagesBootItemSerializer : SignatureUnionSerializer<WorkerMessagesBootItem>(
    WorkerMessagesBootItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "situation", "refusal"),
                allowed = listOf("name", "situation", "refusal"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "situation", "bootRefusal"),
                allowed = listOf("name", "situation", "bootRefusal"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        WorkerMessagesBootItemOwnBootRefusal.serializer(),
        WorkerMessagesBootItemSharedBootRefusal.serializer(),
    ) },
)

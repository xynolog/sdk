// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ClientRefreshQueriesItemSerializer::class)
public sealed interface ClientRefreshQueriesItem

internal object ClientRefreshQueriesItemSerializer : SignatureUnionSerializer<ClientRefreshQueriesItem>(
    ClientRefreshQueriesItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "asks", "value", "docs"),
                allowed = listOf("name", "per", "asks", "persisted", "value", "docs"),
                fixed = listOf("per" to listOf(Literal.Text("resource"), Literal.Text("annotation"), Literal.Text("filters")), "persisted" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "reads", "value", "docs"),
                allowed = listOf("name", "per", "reads", "persisted", "value", "docs"),
                fixed = listOf("per" to listOf(Literal.Text("resource"), Literal.Text("annotation"), Literal.Text("filters")), "persisted" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ClientRefreshQueriesItemAsks.serializer(),
            ClientRefreshQueriesItemReads.serializer(),
        )
    },
)

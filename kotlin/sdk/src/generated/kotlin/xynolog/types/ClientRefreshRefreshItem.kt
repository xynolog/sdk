// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ClientRefreshRefreshItemSerializer::class)
public sealed interface ClientRefreshRefreshItem

internal object ClientRefreshRefreshItemSerializer : SignatureUnionSerializer<ClientRefreshRefreshItem>(
    ClientRefreshRefreshItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("on", "docs"),
                allowed = listOf("on", "when", "reach", "names", "carries", "refetches", "writes", "removes", "docs"),
                fixed = listOf("when" to listOf(Literal.Text("enriched"), Literal.Text("unenriched")), "reach" to listOf(Literal.Text("subject"), Literal.Text("held"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("stream", "docs"),
                allowed = listOf("stream", "reach", "refetches", "docs"),
                fixed = listOf("stream" to listOf(Literal.Text("reopened"), Literal.Text("unreadable")), "reach" to listOf(Literal.Text("subject"), Literal.Text("held"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ClientRefreshRefreshItemOn.serializer(),
            ClientRefreshRefreshItemStream.serializer(),
        )
    },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What checking one open resource against its knowledge base concluded. `gone` is the only verdict that closes it, and it means the knowledge base said the resource does not exist, not that the check failed: a failed transport, a timeout and a peer that is down are each `unknown`, and an unknown resource stays open. */
@Serializable(with = TabCheckSerializer::class)
public sealed interface TabCheck

internal object TabCheckSerializer : SignatureUnionSerializer<TabCheck>(
    TabCheck::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("verdict"),
                allowed = listOf("verdict"),
                fixed = listOf("verdict" to listOf(Literal.Text("gone"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("verdict", "name"),
                allowed = listOf("verdict", "name", "mediaType"),
                fixed = listOf("verdict" to listOf(Literal.Text("ready"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("verdict"),
                allowed = listOf("verdict"),
                fixed = listOf("verdict" to listOf(Literal.Text("unknown"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        TabCheckGone.serializer(),
        TabCheckReady.serializer(),
        TabCheckUnknown.serializer(),
    ) },
)

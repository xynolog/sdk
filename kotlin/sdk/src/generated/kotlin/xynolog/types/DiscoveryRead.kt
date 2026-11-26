// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What one read of a launcher's discovery document gave: a DiscoveryState's absent or managed, or that nothing changed since the last read. Told apart by `kind`, as DiscoveryState's are. */
@Serializable(with = DiscoveryReadSerializer::class)
public sealed interface DiscoveryRead

internal object DiscoveryReadSerializer : SignatureUnionSerializer<DiscoveryRead>(
    DiscoveryRead::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "reason"),
                allowed = listOf("kind", "reason", "diagnostic"),
                fixed = listOf("kind" to listOf(Literal.Text("absent")), "reason" to listOf(Literal.Text("not-found"), Literal.Text("not-json"), Literal.Text("invalid"), Literal.Text("unsupported-version"), Literal.Text("unreadable"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "kbs"),
                allowed = listOf("kind", "kbs"),
                fixed = listOf("kind" to listOf(Literal.Text("managed"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind"),
                allowed = listOf("kind"),
                fixed = listOf("kind" to listOf(Literal.Text("unchanged"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            DiscoveryAbsent.serializer(),
            DiscoveryManaged.serializer(),
            DiscoveryUnchanged.serializer(),
        )
    },
)

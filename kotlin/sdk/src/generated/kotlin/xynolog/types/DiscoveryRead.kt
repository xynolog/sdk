// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What one read of a launcher's discovery document gave, told apart by `kind`: no launcher was found, the knowledge bases one manages, or nothing changed since the last read. A launcher that manages none is not an absent one. */
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
                fixed = listOf("kind" to listOf(Literal.Text("absent"))),
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
            DiscoveryReadAbsent.serializer(),
            DiscoveryReadManaged.serializer(),
            DiscoveryReadUnchanged.serializer(),
        )
    },
)

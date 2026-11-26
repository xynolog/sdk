// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a launcher's discovery document says, told apart by `kind`: no launcher was found, or the knowledge bases one manages. A launcher that manages none is not an absent one. */
@Serializable(with = DiscoveryStateSerializer::class)
public sealed interface DiscoveryState

internal object DiscoveryStateSerializer : SignatureUnionSerializer<DiscoveryState>(
    DiscoveryState::class,
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
    ),
    variants = {
        listOf(
            DiscoveryAbsent.serializer(),
            DiscoveryManaged.serializer(),
        )
    },
)

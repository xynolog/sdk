// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The state. */
@Serializable(with = ConformanceDriverLineEmissionEmissionStateSerializer::class)
public sealed interface ConformanceDriverLineEmissionEmissionState

internal object ConformanceDriverLineEmissionEmissionStateSerializer : SignatureUnionSerializer<ConformanceDriverLineEmissionEmissionState>(
    ConformanceDriverLineEmissionEmissionState::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status"),
                allowed = listOf("status"),
                fixed = listOf("status" to listOf(Literal.Text("pending"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "value"),
                allowed = listOf("status", "value"),
                fixed = listOf("status" to listOf(Literal.Text("ready"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("status", "error"),
                allowed = listOf("status", "error"),
                fixed = listOf("status" to listOf(Literal.Text("failed"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        ConformanceDriverLineEmissionEmissionStatePending.serializer(),
        ConformanceDriverLineEmissionEmissionStateReady.serializer(),
        ConformanceDriverLineEmissionEmissionStateFailed.serializer(),
    ) },
)

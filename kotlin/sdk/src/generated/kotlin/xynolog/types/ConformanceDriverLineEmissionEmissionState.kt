// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The state. */
@Serializable(with = ConformanceDriverLineEmissionEmissionStateSerializer::class)
public sealed interface ConformanceDriverLineEmissionEmissionState

internal object ConformanceDriverLineEmissionEmissionStateSerializer : KindsUnionSerializer<ConformanceDriverLineEmissionEmissionState>(
    ConformanceDriverLineEmissionEmissionState::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(ConformanceDriverLineEmissionEmissionStatePending.serializer(), ConformanceDriverLineEmissionEmissionStateReady.serializer(), ConformanceDriverLineEmissionEmissionStateFailed.serializer()) },
)

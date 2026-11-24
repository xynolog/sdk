// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One step of a case of the conformance corpus (ConformanceCase.json): each is told apart by the member only it requires. conformance/sdk/README.md, "A case", says what each does. */
@Serializable(with = ConformanceStepSerializer::class)
public sealed interface ConformanceStep

internal object ConformanceStepSerializer : KindsUnionSerializer<ConformanceStep>(
    ConformanceStep::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(ConformanceStepLet.serializer(), ConformanceStepDriver.serializer(), ConformanceStepAbandon.serializer(), ConformanceStepSettles.serializer(), ConformanceStepWire.serializer(), ConformanceStepCarried.serializer(), ConformanceStepClosed.serializer(), ConformanceStepProgress.serializer(), ConformanceStepState.serializer(), ConformanceStepStays.serializer(), ConformanceStepFrame.serializer(), ConformanceStepFrames.serializer(), ConformanceStepError.serializer(), ConformanceStepBackend.serializer(), ConformanceStepQuiet.serializer(), ConformanceStepObserve.serializer(), ConformanceStepLeave.serializer(), ConformanceStepReaches.serializer(), ConformanceStepHolds.serializer(), ConformanceStepCompletes.serializer(), ConformanceBusFetch.serializer(), ConformanceHttpFetch.serializer(), ConformanceStepFetches.serializer(), ConformanceStepScopes.serializer(), ConformanceStepClaimed.serializer(), ConformanceStepRefused.serializer(), ConformanceStepSignalled.serializer(), ConformanceStepStalled.serializer()) },
)

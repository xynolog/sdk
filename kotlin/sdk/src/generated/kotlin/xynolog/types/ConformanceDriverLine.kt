// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A line a conformance driver writes on its standard output, one JSON object each (conformance/sdk/README.md, "The driver protocol"; conformance/worker/README.md, "The worker driver"): that it is ready, an operation's outcome, or what its client observed as it happened. The suite refuses any other line. */
@Serializable(with = ConformanceDriverLineSerializer::class)
public sealed interface ConformanceDriverLine

internal object ConformanceDriverLineSerializer : KindsUnionSerializer<ConformanceDriverLine>(
    ConformanceDriverLine::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(ConformanceDriverLineReady.serializer(), ConformanceDriverLineOk.serializer(), ConformanceDriverLineFailed.serializer(), ConformanceDriverLineAbandoned.serializer(), ConformanceDriverLineUnsupported.serializer(), ConformanceDriverLineMisuse.serializer(), ConformanceDriverLineState.serializer(), ConformanceDriverLineFrame.serializer(), ConformanceDriverLineErrorStream.serializer(), ConformanceDriverLineProgress.serializer(), ConformanceDriverLineEmission.serializer(), ConformanceDriverLineCompleted.serializer(), ConformanceDriverLineClaimed.serializer(), ConformanceDriverLineRefused.serializer(), ConformanceDriverLineSignalled.serializer(), ConformanceDriverLineStalled.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a `yield` job reports when it concludes without failing: the resource it made, or a decline. Neither names its kind: a decline is the one with `declined`. */
@Serializable(with = YieldJobResultSerializer::class)
public sealed interface YieldJobResult

internal object YieldJobResultSerializer : KindsUnionSerializer<YieldJobResult>(
    YieldJobResult::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(YieldJobDone.serializer(), JobDeclined.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a `mark` job reports when it concludes without failing: its counts, or a decline. Neither names its kind: a decline is the one with `declined`. */
@Serializable(with = MarkJobResultSerializer::class)
public sealed interface MarkJobResult

internal object MarkJobResultSerializer : KindsUnionSerializer<MarkJobResult>(
    MarkJobResult::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(MarkJobDone.serializer(), JobDeclined.serializer()) },
)

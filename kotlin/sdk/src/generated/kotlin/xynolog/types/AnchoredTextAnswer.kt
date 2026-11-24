// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/**
 * What a reader gets when it asks for a resource's coordinate map: the map, a stored decline, or a named absence.
 *
 * Distinct from `ExtractionOutcome` on purpose. That type is what the STORE holds and what an extractor RETURNS — neither of which can ever be 'not yet'. This is the read answer, which can, so widening ExtractionOutcome itself would have put an impossible state into the store's own type.
 *
 * Flat, one discriminant: every member carries `kind`, rather than nesting an outcome inside a status envelope and giving the wire two `kind` fields at different depths.
 */
@Serializable(with = AnchoredTextAnswerSerializer::class)
public sealed interface AnchoredTextAnswer

internal object AnchoredTextAnswerSerializer : KindsUnionSerializer<AnchoredTextAnswer>(
    AnchoredTextAnswer::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(ExtractedText.serializer(), ExtractionDeclined.serializer(), AnchoredTextAbsent.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One change to an annotation's bodies: a body added, a body removed, or one body replaced by another. */
@Serializable(with = BodyOperationSerializer::class)
public sealed interface BodyOperation

internal object BodyOperationSerializer : KindsUnionSerializer<BodyOperation>(
    BodyOperation::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(BodyOperationAdd.serializer(), BodyOperationRemove.serializer(), BodyOperationReplace.serializer()) },
)

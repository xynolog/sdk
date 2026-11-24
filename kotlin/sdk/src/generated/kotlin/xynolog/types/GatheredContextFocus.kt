// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The gather anchor. Discriminated on `kind`. */
@Serializable(with = GatheredContextFocusSerializer::class)
public sealed interface GatheredContextFocus

internal object GatheredContextFocusSerializer : KindsUnionSerializer<GatheredContextFocus>(
    GatheredContextFocus::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(GatheredContextFocusAnnotation.serializer(), GatheredContextFocusResource.serializer()) },
)

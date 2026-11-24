// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The gather anchor. Discriminated on `kind`. */
@Serializable(with = GatheredContextFocusSerializer::class)
public sealed interface GatheredContextFocus

internal object GatheredContextFocusSerializer : SignatureUnionSerializer<GatheredContextFocus>(
    GatheredContextFocus::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "annotation", "sourceResource"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("annotation"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "resource"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("resource"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        GatheredContextFocusAnnotation.serializer(),
        GatheredContextFocusResource.serializer(),
    ) },
)

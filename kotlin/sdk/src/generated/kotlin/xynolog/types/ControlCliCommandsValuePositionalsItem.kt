// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ControlCliCommandsValuePositionalsItemSerializer::class)
public sealed interface ControlCliCommandsValuePositionalsItem

internal object ControlCliCommandsValuePositionalsItemSerializer : SignatureUnionSerializer<ControlCliCommandsValuePositionalsItem>(
    ControlCliCommandsValuePositionalsItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "fields"),
                allowed = listOf("name", "fields"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("name", "cliOnly"),
                allowed = listOf("name", "cliOnly"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ControlCliCommandsValuePositionalsItemFields.serializer(),
            ControlCliCommandsValuePositionalsItemCliOnly.serializer(),
        )
    },
)

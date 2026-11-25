// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ControlCliCommandsValueFlagsValueSerializer::class)
public sealed interface ControlCliCommandsValueFlagsValue

internal object ControlCliCommandsValueFlagsValueSerializer : SignatureUnionSerializer<ControlCliCommandsValueFlagsValue>(
    ControlCliCommandsValueFlagsValue::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fields"),
                allowed = listOf("fields", "notes"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("method"),
                allowed = listOf("method"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("cliOnly"),
                allowed = listOf("cliOnly"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ControlCliCommandsValueFlagsValueFields.serializer(),
            ControlCliCommandsValueFlagsValueMethod.serializer(),
            ControlCliCommandsValueFlagsValueCliOnly.serializer(),
        )
    },
)

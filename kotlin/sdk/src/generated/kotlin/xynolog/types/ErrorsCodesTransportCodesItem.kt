// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable(with = ErrorsCodesTransportCodesItemSerializer::class)
public sealed interface ErrorsCodesTransportCodesItem

internal object ErrorsCodesTransportCodesItemSerializer : SignatureUnionSerializer<ErrorsCodesTransportCodesItem>(
    ErrorsCodesTransportCodesItem::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "docs", "status"),
                allowed = listOf("code", "docs", "status", "limitRefusals"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "docs", "statusFrom"),
                allowed = listOf("code", "docs", "statusFrom"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("code", "docs"),
                allowed = listOf("code", "docs"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ErrorsCodesTransportCodesItemStatus.serializer(),
            ErrorsCodesTransportCodesItemStatusFrom.serializer(),
            ErrorsCodesTransportCodesItemNoStatus.serializer(),
        )
    },
)

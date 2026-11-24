// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One URI, or a non-empty list of them: a JSON-LD term that may name one resource or several. */
@Serializable(with = OneOrMoreUrisSerializer::class)
public sealed interface OneOrMoreUris {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : OneOrMoreUris {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `List<String>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<String>) : OneOrMoreUris {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<String>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object OneOrMoreUrisSerializer : SignatureUnionSerializer<OneOrMoreUris>(
    OneOrMoreUris::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.TEXT,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.LIST,
                required = emptyList(),
                allowed = null,
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        OneOrMoreUris.Text.serializer(),
        OneOrMoreUris.List.serializer(),
    ) },
)

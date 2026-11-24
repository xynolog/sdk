// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One string, or a non-empty list of them: a JSON-LD term that may take one value or several. */
@Serializable(with = OneOrMoreStringsSerializer::class)
public sealed interface OneOrMoreStrings {
    /** A member that is a `String`, as the value itself. */
    @Serializable(with = Text.Serializer::class)
    public data class Text(public val value: String) : OneOrMoreStrings {
        internal object Serializer : WrapperSerializer<Text, String>(Text::class, kotlinx.serialization.serializer(), { Text(it) }, Text::value)
    }

    /** A member that is a `List<String>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<String>) : OneOrMoreStrings {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<String>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object OneOrMoreStringsSerializer : KindsUnionSerializer<OneOrMoreStrings>(
    OneOrMoreStrings::class,
    strings = { listOf(OneOrMoreStrings.Text.serializer()) },
    scalars = { emptyList() },
    arrays = { listOf(OneOrMoreStrings.List.serializer()) },
    objects = { emptyList() },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a target's `selector` holds: one W3C selector, or several of the same segment. */
@Serializable(with = AnnotationSelectorSerializer::class)
public sealed interface AnnotationSelector {
    /** A member that is a `List<Selector>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<Selector>) : AnnotationSelector {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<Selector>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object AnnotationSelectorSerializer : KindsUnionSerializer<AnnotationSelector>(
    AnnotationSelector::class,
    strings = { listOf(Selector.serializer()) },
    scalars = { listOf(Selector.serializer()) },
    arrays = { listOf(Selector.serializer(), AnnotationSelector.List.serializer()) },
    objects = { listOf(Selector.serializer()) },
)

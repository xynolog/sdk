// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What an annotation's `body` holds: one body, or a non-empty list of them. There is no empty list: an annotation with nothing to say has no `body`. */
@Serializable(with = AnnotationBodiesSerializer::class)
public sealed interface AnnotationBodies {
    /** A member that is a `List<AnnotationBody>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<AnnotationBody>) : AnnotationBodies {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<AnnotationBody>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object AnnotationBodiesSerializer : KindsUnionSerializer<AnnotationBodies>(
    AnnotationBodies::class,
    strings = { listOf(AnnotationBody.serializer()) },
    scalars = { listOf(AnnotationBody.serializer()) },
    arrays = { listOf(AnnotationBody.serializer(), AnnotationBodies.List.serializer()) },
    objects = { listOf(AnnotationBody.serializer()) },
)

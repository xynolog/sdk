// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import xynolog.identifiers.ResourceId

/** W3C Web Annotation target: the id of the resource annotated, when the whole of it is, or an object with source and optional selector (fragment) */
@Serializable(with = AnnotationTargetValueSerializer::class)
public sealed interface AnnotationTargetValue {
    /** A member that is a `ResourceId`, as the value itself. */
    @Serializable(with = ResourceId.Serializer::class)
    public data class ResourceId(public val value: xynolog.identifiers.ResourceId) : AnnotationTargetValue {
        internal object Serializer : WrapperSerializer<ResourceId, xynolog.identifiers.ResourceId>(ResourceId::class, kotlinx.serialization.serializer(), { ResourceId(it) }, ResourceId::value)
    }
}

internal object AnnotationTargetValueSerializer : SignatureUnionSerializer<AnnotationTargetValue>(
    AnnotationTargetValue::class,
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
                kind = Kind.OBJECT,
                required = listOf("source"),
                allowed = null,
                fixed = listOf("type" to listOf(Literal.Text("SpecificResource"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        AnnotationTargetValue.ResourceId.serializer(),
        AnnotationTarget.serializer(),
    ) },
)

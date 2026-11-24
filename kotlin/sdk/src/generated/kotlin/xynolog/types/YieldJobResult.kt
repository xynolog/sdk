// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a `yield` job reports when it concludes without failing: the resource it made, or a decline. Neither names its kind: a decline is the one with `declined`. */
@Serializable(with = YieldJobResultSerializer::class)
public sealed interface YieldJobResult

internal object YieldJobResultSerializer : SignatureUnionSerializer<YieldJobResult>(
    YieldJobResult::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("resourceId", "resourceName", "truncated"),
                allowed = listOf("resourceId", "resourceName", "truncated"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("declined", "reason"),
                allowed = listOf("declined", "reason"),
                fixed = listOf("declined" to listOf(Literal.Boolean(true)), "reason" to listOf(Literal.Text("no-text-layer"), Literal.Text("encrypted"), Literal.Text("corrupt"), Literal.Text("too-large"), Literal.Text("empty"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        YieldJobDone.serializer(),
        JobDeclined.serializer(),
    ) },
)

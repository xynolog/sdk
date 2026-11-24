// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One Agent, or a non-empty list of them: the parties PROV-O and the Web Annotation model let a resource or an annotation name in one place, as one agent or several. */
@Serializable(with = OneOrMoreAgentsSerializer::class)
public sealed interface OneOrMoreAgents {
    /** A member that is a `List<Agent>`, as the value itself. */
    @Serializable(with = List.Serializer::class)
    public data class List(public val value: kotlin.collections.List<Agent>) : OneOrMoreAgents {
        internal object Serializer : WrapperSerializer<List, kotlin.collections.List<Agent>>(List::class, kotlinx.serialization.serializer(), { List(it) }, List::value)
    }
}

internal object OneOrMoreAgentsSerializer : SignatureUnionSerializer<OneOrMoreAgents>(
    OneOrMoreAgents::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Person"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type", "name"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Organization"))),
                values = null,
            ),
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Software"))),
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
        Agent.serializer(),
        OneOrMoreAgents.List.serializer(),
    ) },
)

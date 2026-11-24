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

internal object OneOrMoreAgentsSerializer : KindsUnionSerializer<OneOrMoreAgents>(
    OneOrMoreAgents::class,
    strings = { listOf(Agent.serializer()) },
    scalars = { listOf(Agent.serializer()) },
    arrays = { listOf(Agent.serializer(), OneOrMoreAgents.List.serializer()) },
    objects = { listOf(Agent.serializer()) },
)

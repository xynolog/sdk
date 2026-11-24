// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Web Annotation / W3C PROV Agent. Discriminated by @type — Person, Organization, or Software (named member schemas: AgentPerson, AgentOrganization, AgentSoftware). Software peers are first-class participants, not a sub-class of Person. */
@Serializable(with = AgentSerializer::class)
public sealed interface Agent : OneOrMoreAgents

internal object AgentSerializer : SignatureUnionSerializer<Agent>(
    Agent::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Person"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type", "name"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Organization"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("@type"),
                allowed = null,
                fixed = listOf("@type" to listOf(Literal.Text("Software"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        AgentPerson.serializer(),
        AgentOrganization.serializer(),
        AgentSoftware.serializer(),
    ) },
)

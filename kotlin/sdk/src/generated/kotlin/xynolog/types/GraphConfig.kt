// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The graph database a service writes or reads, and what that kind of database needs to be reached: one of the kinds `xynolog-graph` has a store for, told apart by `type`. A secret is never a value here: a database's password is named by the environment variable that holds it. */
@Serializable(with = GraphConfigSerializer::class)
public sealed interface GraphConfig

internal object GraphConfigSerializer : SignatureUnionSerializer<GraphConfig>(
    GraphConfig::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "uri", "username", "passwordEnv", "database"),
                allowed = listOf("type", "uri", "username", "passwordEnv", "database"),
                fixed = listOf("type" to listOf(Literal.Text("neo4j"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "host", "port"),
                allowed = listOf("type", "host", "port"),
                fixed = listOf("type" to listOf(Literal.Text("janusgraph"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "endpoint", "port"),
                allowed = listOf("type", "endpoint", "port"),
                fixed = listOf("type" to listOf(Literal.Text("neptune"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type"),
                allowed = listOf("type"),
                fixed = listOf("type" to listOf(Literal.Text("memory"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            Neo4jGraphConfig.serializer(),
            JanusGraphConfig.serializer(),
            NeptuneGraphConfig.serializer(),
            MemoryGraphConfig.serializer(),
        )
    },
)

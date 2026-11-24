// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The vector index a service writes or searches, and what that kind of index needs to be reached: one of the kinds `xynolog-vectors` has a store for, told apart by `type`. */
@Serializable(with = VectorsConfigSerializer::class)
public sealed interface VectorsConfig

internal object VectorsConfigSerializer : SignatureUnionSerializer<VectorsConfig>(
    VectorsConfig::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "host", "port", "tokenEnv"),
                allowed = listOf("type", "host", "port", "tokenEnv"),
                fixed = listOf("type" to listOf(Literal.Text("qdrant"))),
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
    variants = { listOf(
        QdrantVectorsConfig.serializer(),
        MemoryVectorsConfig.serializer(),
    ) },
)

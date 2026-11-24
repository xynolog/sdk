// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The embedding provider a service asks for vectors, and what that kind of provider needs to be asked: one of the providers `xynolog-vectors` has, told apart by `type`. Two services that share an index name the same provider and the same model: a vector is compared only with vectors of the model that made it. A secret is never a value here: a provider's key is named by the environment variable that holds it. */
@Serializable(with = EmbeddingConfigSerializer::class)
public sealed interface EmbeddingConfig

internal object EmbeddingConfigSerializer : SignatureUnionSerializer<EmbeddingConfig>(
    EmbeddingConfig::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "model", "baseUrl"),
                allowed = listOf("type", "model", "baseUrl"),
                fixed = listOf("type" to listOf(Literal.Text("ollama"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "model", "endpoint", "apiKeyEnv"),
                allowed = listOf("type", "model", "endpoint", "apiKeyEnv"),
                fixed = listOf("type" to listOf(Literal.Text("voyage"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        OllamaEmbeddingConfig.serializer(),
        VoyageEmbeddingConfig.serializer(),
    ) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How a knowledge base is reached: a gateway over HTTP, or a knowledge base the host process has loaded. Told apart by `kind`. Only what builds a transport, or signs in at an issuer, reads it. */
@Serializable(with = KbEndpointSerializer::class)
public sealed interface KbEndpoint

internal object KbEndpointSerializer : SignatureUnionSerializer<KbEndpoint>(
    KbEndpoint::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "host", "port", "protocol"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("http")), "protocol" to listOf(Literal.Text("http"), Literal.Text("https"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "kbId"),
                allowed = null,
                fixed = listOf("kind" to listOf(Literal.Text("local"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            HttpEndpoint.serializer(),
            LocalEndpoint.serializer(),
        )
    },
)

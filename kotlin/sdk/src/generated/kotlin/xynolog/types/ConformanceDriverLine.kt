// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A line a conformance driver writes on its standard output, one JSON object each (conformance/sdk/README.md, "The driver protocol"; conformance/worker/README.md, "The worker driver"): that it is ready, an operation's outcome, or what its client observed as it happened. The suite refuses any other line. */
@Serializable(with = ConformanceDriverLineSerializer::class)
public sealed interface ConformanceDriverLine

internal object ConformanceDriverLineSerializer : SignatureUnionSerializer<ConformanceDriverLine>(
    ConformanceDriverLine::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("ready"),
                allowed = listOf("ready"),
                fixed = listOf("ready" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "ok"),
                allowed = listOf("id", "ok"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "error"),
                allowed = listOf("id", "error"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "abandoned"),
                allowed = listOf("id", "abandoned"),
                fixed = listOf("abandoned" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "unsupported"),
                allowed = listOf("id", "unsupported"),
                fixed = listOf("unsupported" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("id", "misuse"),
                allowed = listOf("id", "misuse"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("state"),
                allowed = listOf("state"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("frame"),
                allowed = listOf("frame"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("error"),
                allowed = listOf("error"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("progress"),
                allowed = listOf("progress"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("emission"),
                allowed = listOf("emission"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("completed"),
                allowed = listOf("completed"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("claimed"),
                allowed = listOf("claimed"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("refused"),
                allowed = listOf("refused"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("signalled"),
                allowed = listOf("signalled"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("stalled"),
                allowed = listOf("stalled"),
                fixed = emptyList(),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            ConformanceDriverLineReady.serializer(),
            ConformanceDriverLineOk.serializer(),
            ConformanceDriverLineFailed.serializer(),
            ConformanceDriverLineAbandoned.serializer(),
            ConformanceDriverLineUnsupported.serializer(),
            ConformanceDriverLineMisuse.serializer(),
            ConformanceDriverLineState.serializer(),
            ConformanceDriverLineFrame.serializer(),
            ConformanceDriverLineErrorStream.serializer(),
            ConformanceDriverLineProgress.serializer(),
            ConformanceDriverLineEmission.serializer(),
            ConformanceDriverLineCompleted.serializer(),
            ConformanceDriverLineClaimed.serializer(),
            ConformanceDriverLineRefused.serializer(),
            ConformanceDriverLineSignalled.serializer(),
            ConformanceDriverLineStalled.serializer(),
        )
    },
)

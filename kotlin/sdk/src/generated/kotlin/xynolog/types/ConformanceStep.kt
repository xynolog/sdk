// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One step of a case of the conformance corpus (ConformanceCase.json): each is told apart by the member only it requires. conformance/sdk/README.md, "A case", says what each does. */
@Serializable(with = ConformanceStepSerializer::class)
public sealed interface ConformanceStep

internal object ConformanceStepSerializer : SignatureUnionSerializer<ConformanceStep>(
    ConformanceStep::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("let"),
                allowed = listOf("let"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("driver"),
                allowed = listOf("driver", "with", "returns", "fails", "as"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("abandon"),
                allowed = listOf("abandon"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("settles"),
                allowed = listOf("settles", "returns", "fails", "abandoned"),
                fixed = listOf("abandoned" to listOf(Literal.Boolean(true))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("wire"),
                allowed = listOf("wire", "at", "status", "params", "body", "token", "headers", "answer", "as", "follows", "waited"),
                fixed = listOf("at" to listOf(Literal.Text("arrival"), Literal.Text("answer"), Literal.Text("live"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("carried", "is"),
                allowed = listOf("carried", "is"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("closed"),
                allowed = listOf("closed"),
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
                required = listOf("state"),
                allowed = listOf("state"),
                fixed = listOf("state" to listOf(Literal.Text("initial"), Literal.Text("connecting"), Literal.Text("open"), Literal.Text("reconnecting"), Literal.Text("degraded"), Literal.Text("unauthenticated"), Literal.Text("closed"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("stays"),
                allowed = listOf("stays"),
                fixed = listOf("stays" to listOf(Literal.Text("initial"), Literal.Text("connecting"), Literal.Text("open"), Literal.Text("reconnecting"), Literal.Text("degraded"), Literal.Text("unauthenticated"), Literal.Text("closed"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("frame", "is"),
                allowed = listOf("frame", "is"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("frames", "count"),
                allowed = listOf("frames", "count"),
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
                required = listOf("backend"),
                allowed = listOf("backend", "with"),
                fixed = listOf("backend" to listOf(Literal.Text("listen"), Literal.Text("emit"), Literal.Text("record"), Literal.Text("content"), Literal.Text("description"), Literal.Text("annotations"), Literal.Text("anchored-text"), Literal.Text("uploaded"), Literal.Text("refuse"), Literal.Text("unanswered"), Literal.Text("answer-lost"), Literal.Text("hold"), Literal.Text("release"), Literal.Text("rechunk"), Literal.Text("carry"), Literal.Text("cut"), Literal.Text("down"), Literal.Text("up"), Literal.Text("archivist"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("quiet"),
                allowed = listOf("quiet"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("observe", "as"),
                allowed = listOf("observe", "as"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("leave"),
                allowed = listOf("leave"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("reaches", "state"),
                allowed = listOf("reaches", "state"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("holds", "state"),
                allowed = listOf("holds", "state"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("completes"),
                allowed = listOf("completes"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fetch", "as"),
                allowed = listOf("fetch", "payload", "as"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fetch"),
                allowed = listOf("fetch", "params"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("fetches"),
                allowed = listOf("fetches"),
                fixed = emptyList(),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("scopes"),
                allowed = listOf("scopes"),
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
            ConformanceStepLet.serializer(),
            ConformanceStepDriver.serializer(),
            ConformanceStepAbandon.serializer(),
            ConformanceStepSettles.serializer(),
            ConformanceStepWire.serializer(),
            ConformanceStepCarried.serializer(),
            ConformanceStepClosed.serializer(),
            ConformanceStepProgress.serializer(),
            ConformanceStepState.serializer(),
            ConformanceStepStays.serializer(),
            ConformanceStepFrame.serializer(),
            ConformanceStepFrames.serializer(),
            ConformanceStepError.serializer(),
            ConformanceStepBackend.serializer(),
            ConformanceStepQuiet.serializer(),
            ConformanceStepObserve.serializer(),
            ConformanceStepLeave.serializer(),
            ConformanceStepReaches.serializer(),
            ConformanceStepHolds.serializer(),
            ConformanceStepCompletes.serializer(),
            ConformanceBusFetch.serializer(),
            ConformanceHttpFetch.serializer(),
            ConformanceStepFetches.serializer(),
            ConformanceStepScopes.serializer(),
            ConformanceStepClaimed.serializer(),
            ConformanceStepRefused.serializer(),
            ConformanceStepSignalled.serializer(),
            ConformanceStepStalled.serializer(),
        )
    },
)

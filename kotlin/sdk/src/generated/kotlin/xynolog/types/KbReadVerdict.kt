// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a knowledge base said when it was asked to describe itself, read against the entry it was asked as. */
@Serializable(with = KbReadVerdictSerializer::class)
public sealed interface KbReadVerdict

internal object KbReadVerdictSerializer : SignatureUnionSerializer<KbReadVerdict>(
    KbReadVerdict::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind"),
                allowed = listOf("kind"),
                fixed = listOf("kind" to listOf(Literal.Text("recorded"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind", "observedDid", "observedName"),
                allowed = listOf("kind", "observedDid", "observedName"),
                fixed = listOf("kind" to listOf(Literal.Text("conflict"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("kind"),
                allowed = listOf("kind"),
                fixed = listOf("kind" to listOf(Literal.Text("no-verdict"))),
                values = null,
            ),
        ),
    ),
    variants = { listOf(
        KbReadVerdictRecorded.serializer(),
        KbReadVerdictConflict.serializer(),
        KbReadVerdictNoVerdict.serializer(),
    ) },
)

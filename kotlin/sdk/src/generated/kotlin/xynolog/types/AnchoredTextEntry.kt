// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One entry of the anchored-text store: the file `<ab>/<cd>/<key>.json` under the store's directory, where the key is the SHA-256 of the bytes the text was extracted from, in hex. The Smelter derives it and stores it over the Archivist's HTTP surface (`AnchoredTextWrite`); the Archivist writes it, as compact JSON with `v` and `stamp` first, to a sibling temporary file renamed onto the path. The stamp the Smelter states (`AnchoredTextStamp`) is kept, followed by a newline, in the file `STAMP` at the store's root. */
@Serializable(with = AnchoredTextEntrySerializer::class)
public sealed interface AnchoredTextEntry

internal object AnchoredTextEntrySerializer : KindsUnionSerializer<AnchoredTextEntry>(
    AnchoredTextEntry::class,
    strings = { emptyList() },
    scalars = { emptyList() },
    arrays = { emptyList() },
    objects = { listOf(AnchoredTextExtractedEntry.serializer(), AnchoredTextDeclinedEntry.serializer()) },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One entry in a directory listing: a file, which may carry the resource it was ingested as, or a subdirectory. Tell them apart by `type`, which is required on both and single-valued. */
@Serializable(with = DirectoryEntrySerializer::class)
public sealed interface DirectoryEntry

internal object DirectoryEntrySerializer : SignatureUnionSerializer<DirectoryEntry>(
    DirectoryEntry::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "name", "path", "size", "mtime", "tracked"),
                allowed = listOf("type", "name", "path", "size", "mtime", "tracked", "resourceId", "entityTypes", "annotationCount", "creator"),
                fixed = listOf("type" to listOf(Literal.Text("file"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("type", "name", "path", "mtime"),
                allowed = listOf("type", "name", "path", "mtime"),
                fixed = listOf("type" to listOf(Literal.Text("dir"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            FileEntry.serializer(),
            DirEntry.serializer(),
        )
    },
)

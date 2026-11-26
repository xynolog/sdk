// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What an upload reports as it goes, told apart by `phase`: that it began, with its size when its ByteSource states one, then the bytes sent so far, then the resource made. An upload whose source states no length reports none: a size it made up would be a size the caller could not tell from a true one. */
@Serializable(with = UploadProgressSerializer::class)
public sealed interface UploadProgress

internal object UploadProgressSerializer : SignatureUnionSerializer<UploadProgress>(
    UploadProgress::class,
    members = listOf(
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("phase"),
                allowed = listOf("phase", "totalBytes"),
                fixed = listOf("phase" to listOf(Literal.Text("started"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("phase", "bytesUploaded"),
                allowed = listOf("phase", "bytesUploaded", "totalBytes"),
                fixed = listOf("phase" to listOf(Literal.Text("progress"))),
                values = null,
            ),
        ),
        listOf(
            Signature(
                kind = Kind.OBJECT,
                required = listOf("phase", "resourceId"),
                allowed = listOf("phase", "resourceId"),
                fixed = listOf("phase" to listOf(Literal.Text("finished"))),
                values = null,
            ),
        ),
    ),
    variants = {
        listOf(
            UploadProgressStarted.serializer(),
            UploadProgressProgress.serializer(),
            UploadProgressFinished.serializer(),
        )
    },
)

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Why a client that read a launcher's discovery document found no launcher: one of the reasons of client/discovery-absent.json, which says what each means. */
@Serializable
public enum class DiscoveryAbsentReason(
    /** The value as the wire spells it. */
    public val value: String,
) {
    /** There is no document where it was looked for: no file, an HTTP status that is not success, or a page that is not JSON. */
    @SerialName("not-found")
    NotFound("not-found"),

    /** There is a document, and it is not JSON. */
    @SerialName("not-json")
    NotJson("not-json"),

    /** It is JSON, and not a discovery document: one entry that is not what the schema says makes the whole document invalid, since a partial reading would hide a running knowledge base without a trace. */
    @SerialName("invalid")
    Invalid("invalid"),

    /** It is a discovery document of a version this client does not speak, and is not read in part. */
    @SerialName("unsupported-version")
    UnsupportedVersion("unsupported-version"),

    /** It could not be read at all: the file could not be opened or decoded, or the request got no answer by its deadline. */
    @SerialName("unreadable")
    Unreadable("unreadable"),
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** archivist/layout.json: where the Archivist keeps the record on disk. */
@Serializable
public data class ArchivistLayout(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** A resource's event stream: a directory of event files. */
    public val eventStream: ArchivistLayoutEventStream,
    /** The knowledge base's own stream, of the events that name no resource. It is not sharded. */
    public val systemStream: ArchivistLayoutSystemStream,
    /** The files of a stream. */
    public val eventFile: ArchivistLayoutEventFile,
    /** The schema a stored event, one line of an event file, is. */
    public val storedEvent: JsonElement,
    /** A resource's view, in the state directory. */
    public val view: ArchivistLayoutView,
    /** The projections of what the `__system__` stream adds up to, in the state directory. */
    public val systemProjections: ArchivistLayoutSystemProjections,
    /** An entry of the storage-uri index, which names the resource whose content is at a storage URI. */
    public val storageUriIndex: ArchivistLayoutStorageUriIndex,
    /** An entry of the anchored-text store, keyed by the checksum of the content it was extracted from. */
    public val anchoredTextEntry: ArchivistLayoutAnchoredTextEntry,
    /** The file holding the stamp the anchored-text store's entries are taken under: the stamp, followed by a newline. */
    public val anchoredTextStamp: ArchivistLayoutAnchoredTextStamp,
) {
    /** How Java makes a `ArchivistLayout`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val eventStream: ArchivistLayoutEventStream,
        private val systemStream: ArchivistLayoutSystemStream,
        private val eventFile: ArchivistLayoutEventFile,
        private val storedEvent: JsonElement,
        private val view: ArchivistLayoutView,
        private val systemProjections: ArchivistLayoutSystemProjections,
        private val storageUriIndex: ArchivistLayoutStorageUriIndex,
        private val anchoredTextEntry: ArchivistLayoutAnchoredTextEntry,
        private val anchoredTextStamp: ArchivistLayoutAnchoredTextStamp,
    ) {
        public fun build(): ArchivistLayout = ArchivistLayout(comment = comment, eventStream = eventStream, systemStream = systemStream, eventFile = eventFile, storedEvent = storedEvent, view = view, systemProjections = systemProjections, storageUriIndex = storageUriIndex, anchoredTextEntry = anchoredTextEntry, anchoredTextStamp = anchoredTextStamp)
    }

    public companion object {
        /** A builder of a `ArchivistLayout` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, eventStream: ArchivistLayoutEventStream, systemStream: ArchivistLayoutSystemStream, eventFile: ArchivistLayoutEventFile, storedEvent: JsonElement, view: ArchivistLayoutView, systemProjections: ArchivistLayoutSystemProjections, storageUriIndex: ArchivistLayoutStorageUriIndex, anchoredTextEntry: ArchivistLayoutAnchoredTextEntry, anchoredTextStamp: ArchivistLayoutAnchoredTextStamp): Builder = Builder(comment, eventStream, systemStream, eventFile, storedEvent, view, systemProjections, storageUriIndex, anchoredTextEntry, anchoredTextStamp)
    }
}

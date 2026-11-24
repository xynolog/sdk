// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The files of a stream. */
@Serializable
public data class ArchivistLayoutEventFile(
    /** A file's name, `{number}` its number in `digits` decimal digits. */
    public val name: String,
    /** How many decimal digits a file's number is written in, with leading zeros. */
    public val digits: Long,
    /** The first file's number. It is created, empty, with the stream's directory. */
    public val first: Long,
    /** The most events a file holds. */
    public val maxEvents: Long,
) {
    /** How Java makes a `ArchivistLayoutEventFile`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val digits: Long,
        private val first: Long,
        private val maxEvents: Long,
    ) {
        public fun build(): ArchivistLayoutEventFile = ArchivistLayoutEventFile(name = name, digits = digits, first = first, maxEvents = maxEvents)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutEventFile` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, digits: Long, first: Long, maxEvents: Long): Builder = Builder(name, digits, first, maxEvents)
    }
}

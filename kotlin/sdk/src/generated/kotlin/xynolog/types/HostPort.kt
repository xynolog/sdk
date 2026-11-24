// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Where somebody else's daemon listens. */
@Serializable
public data class HostPort(
    /** A host name or address the stack's containers can reach. */
    public val host: String,
    /** The port it listens on. */
    public val port: Long,
) {
    /** How Java makes a `HostPort`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val host: String,
        private val port: Long,
    ) {
        public fun build(): HostPort = HostPort(host = host, port = port)
    }

    public companion object {
        /** A builder of a `HostPort` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(host: String, port: Long): Builder = Builder(host, port)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How the Browser runs. */
@Serializable
public data class BrowserSpec(
    public val image: Image,
    public val resources: Resources,
    /** The port the Browser is published on, on this machine's loopback: where a person opens it, and the origin the issuer's realm allows its sign-in from. */
    public val port: Long,
) {
    /** How Java makes a `BrowserSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val image: Image,
        private val resources: Resources,
        private val port: Long,
    ) {
        public fun build(): BrowserSpec = BrowserSpec(image = image, resources = resources, port = port)
    }

    public companion object {
        /** A builder of a `BrowserSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(image: Image, resources: Resources, port: Long): Builder = Builder(image, resources, port)
    }
}

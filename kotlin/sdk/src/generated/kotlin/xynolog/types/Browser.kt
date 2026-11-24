// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The shared Browser: one viewer for every knowledge base the machine reaches. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/browser.yaml`, not in a knowledge base's repository. */
@Serializable
public data class Browser(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: BrowserKind = BrowserKind.Browser,
    public val metadata: Metadata,
    /** How the Browser runs. */
    public val spec: BrowserSpec,
) {
    /** How Java makes a `Browser`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: BrowserSpec,
    ) {
        public fun build(): Browser = Browser(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `Browser` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: BrowserSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}

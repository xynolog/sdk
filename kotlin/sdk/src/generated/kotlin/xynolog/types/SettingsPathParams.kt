// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** settings.path's params. */
@Serializable
public data class SettingsPathParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** Whose document: the Browser's, the worker's, the issuer's or the vector store's. */
    public val document: SettingsPathParamsDocument,
) {
    /** How Java makes a `SettingsPathParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val document: SettingsPathParamsDocument,
    ) {
        public fun build(): SettingsPathParams = SettingsPathParams(apiVersion = apiVersion, document = document)
    }

    public companion object {
        /** A builder of a `SettingsPathParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, document: SettingsPathParamsDocument): Builder = Builder(apiVersion, document)
    }
}

// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where a live query's key stands (contract/CACHE-SEMANTICS.md): pending, with no value yet; ready, with a stored value; or failed, a value-less key's failure, which is an emission and not the stream's end. */
@Serializable
public enum class CacheStatus(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("pending")
    Pending("pending"),

    @SerialName("ready")
    Ready("ready"),

    @SerialName("failed")
    Failed("failed"),
}

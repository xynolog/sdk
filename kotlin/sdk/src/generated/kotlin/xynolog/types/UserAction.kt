// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A sign-in waits for a person: open the verification page and enter the code. The code is sent here and nowhere else — in no progress line, no log record and no diagnostic. */
@Serializable
public data class UserAction(
    public val requestId: RequestId,
    /** The page where the person enters the code. */
    public val verificationUri: String,
    /** The page with the code already in it, when the issuer offers one. */
    public val verificationUriComplete: String? = null,
    /** The code the person enters. */
    public val userCode: String,
    /** How long the code is good for, from when it was issued. */
    public val expiresInSeconds: Long,
) {
    /** How Java makes a `UserAction`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val requestId: RequestId,
        private val verificationUri: String,
        private val userCode: String,
        private val expiresInSeconds: Long,
    ) {
        private var verificationUriComplete: String? = null

        public fun verificationUriComplete(verificationUriComplete: String?): Builder = apply { this.verificationUriComplete = verificationUriComplete }

        public fun build(): UserAction = UserAction(requestId = requestId, verificationUri = verificationUri, verificationUriComplete = verificationUriComplete, userCode = userCode, expiresInSeconds = expiresInSeconds)
    }

    public companion object {
        /** A builder of a `UserAction` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(requestId: RequestId, verificationUri: String, userCode: String, expiresInSeconds: Long): Builder = Builder(requestId, verificationUri, userCode, expiresInSeconds)
    }
}

// Generated from protocol/specs/src/client/option-defaults.json; do not edit.
// Regenerate: make generate (codegen/lib/option_defaults/kotlin.ml)

package xynolog

import xynolog.types.BrowseDirectoryRequestSort
import xynolog.types.KbTarget
import xynolog.types.wireJson

/** What a public option of the client is when its caller leaves it out, where the client decides it (protocol/specs/src/client/option-defaults.json). */
internal object OptionDefaults {
    /** The directory listed: the knowledge base's root. */
    const val BROWSE_FILES_DIR_PATH: String = "."

    /** How the listing is ordered: by name. */
    val BROWSE_FILES_SORT: BrowseDirectoryRequestSort = BrowseDirectoryRequestSort.Name

    /** How many links out from the resource the graph reaches. */
    const val GATHER_RESOURCE_DEPTH: Long = 2

    /** The most resources the context holds. */
    const val GATHER_RESOURCE_MAX_RESOURCES: Long = 10

    /** Whether the context carries the resources' text. */
    const val GATHER_RESOURCE_INCLUDE_CONTENT: Boolean = true

    /** Whether the context carries a summary of the resource. */
    const val GATHER_RESOURCE_INCLUDE_SUMMARY: Boolean = false

    /** The most candidates the search answers. */
    const val MATCH_SEARCH_LIMIT: Long = 10

    /** Whether a session opened over a kept sign-in asks the gateway who its token is. */
    const val KEPT_SIGN_IN_SESSION_FROM_KEPT_VALIDATE: Boolean = true

    /** The knowledge base a test session is with: test-kb, at http://localhost:4000. */
    val TESTING_CREATE_TEST_SESSION_KB: KbTarget =
        wireJson.decodeFromString(
            KbTarget.serializer(),
            "{\"id\":\"test-kb\",\"label\":\"Test KB\",\"endpoint\":{\"kind\":\"http\",\"host\":\"localhost\",\"port\":4000,\"protocol\":\"http\"}}",
        )
}

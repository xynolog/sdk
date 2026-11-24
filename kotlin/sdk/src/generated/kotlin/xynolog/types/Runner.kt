// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** Who runs a daemon: the launcher, from `image` with `resources`, or somebody else, reached at `external`. Exactly one of the two. */
@Serializable
@JsonIgnoreUnknownKeys
public data object Runner

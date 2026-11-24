// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import xynolog.identifiers.ResourceId

/** Where a knowledge base's stream was: for each scope, a resource's id, the id of the last recorded event delivered on it. */
public typealias LastEventIds = kotlin.collections.Map<ResourceId, PersistedEventId>

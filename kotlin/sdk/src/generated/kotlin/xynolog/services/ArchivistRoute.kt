// Generated from protocol/specs/src/archivist/openapi.json; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/service_tables.ml)

package xynolog.services

import xynolog.Generated

/** An operation of the Archivist's HTTP surface: its method, and its path, a `{name}` for each parameter, which the caller fills. */
@Generated
public enum class ArchivistRoute(
    public val method: String,
    public val path: String,
) {
    /** Liveness */
    GetHealth("GET", "/health"),

    /** Every stream of the event log, and where each stands */
    ListStreams("GET", "/events"),

    /** One stream's events from one sequence number, a page at a time */
    GetResourceEvents("GET", "/events/{resourceId}"),

    /** Store an upload and record the resource */
    StoreResource("POST", "/resources"),

    /** A resource's bytes */
    GetResourceContent("GET", "/resources/{id}/content"),

    /** A resource's linked-data description */
    GetResourceJsonLd("GET", "/resources/{id}/jsonld"),

    /** A resource's annotations */
    GetResourceAnnotations("GET", "/resources/{id}/annotations"),

    /** A resource's anchored text */
    GetResourceAnchoredText("GET", "/resources/{id}/anchored-text"),

    /** Store a resource's anchored text */
    PutResourceAnchoredText("PUT", "/resources/{id}/anchored-text"),

    /** The anchored-text store's keys */
    ListAnchoredTextEntries("GET", "/anchored-text/entries"),

    /** The anchored-text entry stored for a resource's content */
    GetStoredResourceAnchoredText("GET", "/resources/{id}/anchored-text/stored"),

    /** State the anchored-text store's stamp */
    PutAnchoredTextStamp("PUT", "/anchored-text/stamp"),
}

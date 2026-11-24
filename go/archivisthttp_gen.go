// Code generated from protocol/specs/src/archivist/openapi.json and its paths — DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/go_types/archivist_http.ml)

package xynolog

// ArchivistRoute is an operation of the Archivist: its method and its path, a
// {name} for each parameter, which the caller fills.
type ArchivistRoute struct {
	Method, Path string
}

var (
	// ArchivistRouteGetHealth is getHealth.
	ArchivistRouteGetHealth = ArchivistRoute{Method: "GET", Path: "/health"}

	// ArchivistRouteListStreams is listStreams.
	ArchivistRouteListStreams = ArchivistRoute{Method: "GET", Path: "/events"}

	// ArchivistRouteGetResourceEvents is getResourceEvents.
	ArchivistRouteGetResourceEvents = ArchivistRoute{Method: "GET", Path: "/events/{resourceId}"}

	// ArchivistRouteStoreResource is storeResource.
	ArchivistRouteStoreResource = ArchivistRoute{Method: "POST", Path: "/resources"}

	// ArchivistRouteGetResourceContent is getResourceContent.
	ArchivistRouteGetResourceContent = ArchivistRoute{Method: "GET", Path: "/resources/{id}/content"}

	// ArchivistRouteGetResourceJsonLd is getResourceJsonLd.
	ArchivistRouteGetResourceJsonLd = ArchivistRoute{Method: "GET", Path: "/resources/{id}/jsonld"}

	// ArchivistRouteGetResourceAnnotations is getResourceAnnotations.
	ArchivistRouteGetResourceAnnotations = ArchivistRoute{Method: "GET", Path: "/resources/{id}/annotations"}

	// ArchivistRouteGetResourceAnchoredText is getResourceAnchoredText.
	ArchivistRouteGetResourceAnchoredText = ArchivistRoute{Method: "GET", Path: "/resources/{id}/anchored-text"}

	// ArchivistRoutePutResourceAnchoredText is putResourceAnchoredText.
	ArchivistRoutePutResourceAnchoredText = ArchivistRoute{Method: "PUT", Path: "/resources/{id}/anchored-text"}

	// ArchivistRouteListAnchoredTextEntries is listAnchoredTextEntries.
	ArchivistRouteListAnchoredTextEntries = ArchivistRoute{Method: "GET", Path: "/anchored-text/entries"}

	// ArchivistRouteGetStoredResourceAnchoredText is
	// getStoredResourceAnchoredText.
	ArchivistRouteGetStoredResourceAnchoredText = ArchivistRoute{Method: "GET", Path: "/resources/{id}/anchored-text/stored"}

	// ArchivistRoutePutAnchoredTextStamp is putAnchoredTextStamp.
	ArchivistRoutePutAnchoredTextStamp = ArchivistRoute{Method: "PUT", Path: "/anchored-text/stamp"}
)

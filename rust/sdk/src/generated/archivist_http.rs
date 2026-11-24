// Generated from protocol/specs/src/archivist/openapi.json and its paths; do not edit.
// Regenerate: make generate (codegen/lib/gateway_http/rust.ml)
/// A method the Archivist's operations use.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ArchivistMethod {
    Get,
    Post,
    Put,
}

/// An operation of the Archivist: its method and its path (a `{name}` for each
/// parameter, which the caller fills).
#[derive(Clone, Copy, Debug)]
pub struct ArchivistRoute {
    pub method: ArchivistMethod,
    pub path: &'static str,
}

/// `getHealth`.
pub const GET_HEALTH: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/health",
};

/// `listStreams`.
pub const LIST_STREAMS: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/events",
};

/// `getResourceEvents`.
pub const GET_RESOURCE_EVENTS: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/events/{resourceId}",
};

/// `storeResource`.
pub const STORE_RESOURCE: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Post,
    path: "/resources",
};

/// `getResourceContent`.
pub const GET_RESOURCE_CONTENT: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/resources/{id}/content",
};

/// `getResourceJsonLd`.
pub const GET_RESOURCE_JSON_LD: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/resources/{id}/jsonld",
};

/// `getResourceAnnotations`.
pub const GET_RESOURCE_ANNOTATIONS: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/resources/{id}/annotations",
};

/// `getResourceAnchoredText`.
pub const GET_RESOURCE_ANCHORED_TEXT: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/resources/{id}/anchored-text",
};

/// `putResourceAnchoredText`.
pub const PUT_RESOURCE_ANCHORED_TEXT: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Put,
    path: "/resources/{id}/anchored-text",
};

/// `listAnchoredTextEntries`.
pub const LIST_ANCHORED_TEXT_ENTRIES: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/anchored-text/entries",
};

/// `getStoredResourceAnchoredText`.
pub const GET_STORED_RESOURCE_ANCHORED_TEXT: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Get,
    path: "/resources/{id}/anchored-text/stored",
};

/// `putAnchoredTextStamp`.
pub const PUT_ANCHORED_TEXT_STAMP: ArchivistRoute = ArchivistRoute {
    method: ArchivistMethod::Put,
    path: "/anchored-text/stamp",
};

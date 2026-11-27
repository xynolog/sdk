// Generated from protocol/specs/src/client/option-defaults.json; do not edit.
// Regenerate: make generate (codegen/lib/option_defaults/rust.ml)
/// The directory listed: the knowledge base's root.
pub const BROWSE_FILES_DIR_PATH: &str = ".";

/// How the listing is ordered: by name.
pub const BROWSE_FILES_SORT: crate::types::BrowseDirectoryRequestSort =
    crate::types::BrowseDirectoryRequestSort::Name;

/// How many links out from the resource the graph reaches.
pub const GATHER_RESOURCE_DEPTH: u16 = 2;

/// The most resources the context holds.
pub const GATHER_RESOURCE_MAX_RESOURCES: u16 = 10;

/// Whether the context carries the resources' text.
pub const GATHER_RESOURCE_INCLUDE_CONTENT: bool = true;

/// Whether the context carries a summary of the resource.
pub const GATHER_RESOURCE_INCLUDE_SUMMARY: bool = false;

/// The most candidates the search answers.
pub const MATCH_SEARCH_LIMIT: u16 = 10;

/// The knowledge base a test session is with: test-kb, at http://localhost:4000.
pub fn testing_create_test_session_kb() -> crate::types::KbTarget {
    crate::types::KbTarget {
        id: "test-kb".to_owned(),
        label: "Test KB".to_owned(),
        endpoint: crate::types::KbEndpoint::HttpEndpoint(crate::types::HttpEndpoint {
            kind: crate::types::HttpEndpointKind::Http,
            host: "localhost".to_owned(),
            port: 4000,
            protocol: crate::types::HttpEndpointProtocol::Http,
        }),
    }
}

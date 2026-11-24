//! The gateway's HTTP surface as the transport says it: each operation's
//! method, path and media types, the headers the operations name, an
//! upload's members and the client secret form, and a route's path for a
//! resource. Sending a form is the transport's own.

use crate::types::ResourceId;

include!("generated/gateway_http.rs");

impl Route {
    /// The route's path for one resource: its `{id}` that resource's id, one
    /// segment as it is, since the rule a `ResourceId` is held to admits
    /// nothing a path reads as its own. Every parameter of the gateway's
    /// paths is a resource's `id`.
    pub fn path_for(&self, resource_id: &ResourceId) -> String {
        self.path.replace("{id}", resource_id.as_str())
    }
}

#[cfg(test)]
mod tests {
    /// What `Route::path_for` fills: the one parameter every path of
    /// openapi.json names. A path that names another fails here.
    #[test]
    fn every_parameter_of_the_gateways_paths_is_a_resources_id() {
        let document: serde_json::Value =
            serde_json::from_str(include_str!("../specs/openapi.json")).expect("openapi.json");
        let paths = document["paths"].as_object().expect("paths");
        for path in paths.keys() {
            let mut rest = path.as_str();
            while let Some(open) = rest.find('{') {
                let close = rest[open..].find('}').expect("a parameter closes") + open;
                assert_eq!(&rest[open..=close], "{id}", "{path}");
                rest = &rest[close + 1..];
            }
        }
    }
}

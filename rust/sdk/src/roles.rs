//! What the realm stamps on an account's token: its roles, in the flat
//! `roles` claim, and its kind. A kind, not a role: roles are capabilities,
//! granted to people and agents alike, and the kind says which an account is.

use serde_json::{Map, Value};

include!("generated/roles.rs");

/// Whether the token's account is an agent's.
pub fn is_agent(claims: &Map<String, Value>) -> bool {
    claims.get(KIND_CLAIM).and_then(Value::as_str) == Some(AGENT_KIND)
}

pub fn has_role(claims: &Map<String, Value>, role: &str) -> bool {
    roles_of(claims).is_some_and(|roles| roles.iter().any(|r| r == role))
}

/// The roles a token carries: the strings in its flat `roles` claim, or none.
pub fn roles_of(claims: &Map<String, Value>) -> Option<Vec<String>> {
    let roles: Vec<String> = claims
        .get(ROLES_CLAIM)?
        .as_array()?
        .iter()
        .filter_map(|r| r.as_str().map(str::to_owned))
        .collect();
    (!roles.is_empty()).then_some(roles)
}

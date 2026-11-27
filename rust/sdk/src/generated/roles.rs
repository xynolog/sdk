// Generated from protocol/specs/src/principals/roles.json; do not edit.
// Regenerate: make generate (codegen/lib/rust_types/rust_types.ml)
/// The claim that holds an account's roles.
pub const ROLES_CLAIM: &str = "roles";
/// Carried by every service's account: it marks a service's account.
pub const XYNOLOG_SERVICE_ROLE: &str = "xynolog-service";
/// Carried by a worker's account: it grants the right to claim jobs.
pub const XYNOLOG_WORKER_ROLE: &str = "xynolog-worker";
/// The claim that marks an agent's account.
pub const KIND_CLAIM: &str = "kind";
/// What the kind claim holds on an agent's account.
pub const AGENT_KIND: &str = "agent";

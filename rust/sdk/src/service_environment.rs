//! Every environment variable a Xynolog service reads, beside its
//! configuration document, as a constant of its name, generated from
//! protocol/specs/src/service-environment/variables.json.

include!("generated/service_environment.rs");

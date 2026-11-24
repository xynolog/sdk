//! The tables the services keep to, as protocol/specs/src holds them: each
//! read as the generated type of its own schema, by a function named as the
//! type is (`jobs_budgets()` is a `crate::types::JobsBudgets`), and every
//! one by its file (`SERVICE_TABLE_FILES`, `service_table`).

use crate::types;
use serde_json::Error;

include!("generated/service_tables.rs");

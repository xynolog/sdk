// Generated from protocol/specs/src/client/surface.json and client/types; do not edit.
// Regenerate: make generate (codegen/lib/held_job/rust.ml)
impl<V> Held<V> {
    pub fn job_id(&self) -> &JobId {
        &self.record().job_id
    }
    pub fn job_type(&self) -> JobType {
        self.record().job_type
    }
    pub fn resource_id(&self) -> &ResourceId {
        &self.record().resource_id
    }
    pub fn params(&self) -> &JobParams {
        &self.record().params
    }
    /// The units a worker has finished, merged across checkpoints and failures as a set.
    pub fn completed_units(&self) -> &[String] {
        &self.record().completed_units
    }
    /// The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.
    pub fn unit_cursors(&self) -> &std::collections::BTreeMap<String, UnitCursor> {
        &self.record().unit_cursors
    }
    pub fn retry_count(&self) -> u64 {
        self.record().retry_count
    }
    /// How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.
    pub fn max_retries(&self) -> u64 {
        self.record().max_retries
    }
}

impl HeldJob {
    pub fn job_id(&self) -> &JobId {
        &self.record().job_id
    }
    pub fn job_type(&self) -> JobType {
        self.record().job_type
    }
    pub fn resource_id(&self) -> &ResourceId {
        &self.record().resource_id
    }
    pub fn params(&self) -> &JobParams {
        &self.record().params
    }
    /// The units a worker has finished, merged across checkpoints and failures as a set.
    pub fn completed_units(&self) -> &[String] {
        &self.record().completed_units
    }
    /// The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts.
    pub fn unit_cursors(&self) -> &std::collections::BTreeMap<String, UnitCursor> {
        &self.record().unit_cursors
    }
    pub fn retry_count(&self) -> u64 {
        self.record().retry_count
    }
    /// How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type.
    pub fn max_retries(&self) -> u64 {
        self.record().max_retries
    }
}

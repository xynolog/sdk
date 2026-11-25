// Generated from protocol/specs/src/client/surface.json and bus/registry.json; do not edit.
// Regenerate: make generate (codegen/lib/worker_channels/rust.ml)
/// The channels a stream names for client/surface.json's jobClaimChannels: the replies of job:claim, then job:queued and job:cancel-requested.
pub const JOB_CLAIM_CHANNELS: [&str; 4] = [
    "job:claimed",
    "job:claim-failed",
    "job:queued",
    "job:cancel-requested",
];
/// The channels a stream names for client/surface.json's jobCommitChannels: the replies of mark:commit and browse:annotation-requested.
pub const JOB_COMMIT_CHANNELS: [&str; 4] = [
    "mark:commit-ok",
    "mark:commit-failed",
    "browse:annotation-result",
    "browse:annotation-failed",
];

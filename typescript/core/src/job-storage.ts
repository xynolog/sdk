// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/jobs/storage.json, protocol/specs/src/components/schemas/JobType.json,
//              protocol/specs/src/components/schemas/MarkJobParams.json
// Regenerate:  make generate  (codegen/lib/job_storage/job_storage.ml)

/** The work-queue stream every job is published into. */
export const JOBS_STREAM = 'JOBS';

/** The root of every job subject: a job is published on `<root>.<jobType>`. */
export const JOBS_SUBJECT_ROOT = 'jobs';

/** The stream's capture filter: every subject under the root. */
export const JOBS_STREAM_SUBJECTS = [
  'jobs.>',
] as const;

/** The durable consumer that holds each job's message as its lease. */
export const JOBS_CONSUMER = 'dispatcher-leases';

/** The KV bucket holding one JobRecord per job, keyed by the job's id. */
export const JOBS_BUCKET = 'jobs';

/** Every job type. */
export const JOB_TYPES = [
  'mark',
  'yield',
] as const;

/** Every motivation a `mark` job has: the ones MarkJobParams is told apart by. */
export const MARK_MOTIVATIONS = [
  'highlighting',
  'commenting',
  'assessing',
  'linking',
  'tagging',
] as const;

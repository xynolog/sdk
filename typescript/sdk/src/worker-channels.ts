// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/surface.json
//              protocol/specs/src/bus/registry.json
// Regenerate:  make generate  (codegen/lib/worker_channels/typescript.ml)

import type { EventMap } from '@xynolog/core';

/** Each operation whose replies JOB_CLAIM_CHANNELS names. */
export type JobClaimChannelsOperation = 'job:claim';

/** The channels a stream names for client/surface.json's jobClaimChannels: the replies of job:claim, then job:queued and job:cancel-requested. */
export const JOB_CLAIM_CHANNELS: readonly (keyof EventMap)[] = [
  'job:claimed',
  'job:claim-failed',
  'job:queued',
  'job:cancel-requested',
];

/** Each operation whose replies JOB_COMMIT_CHANNELS names. */
export type JobCommitChannelsOperation =
  'mark:commit' | 'browse:annotation-requested';

/** The channels a stream names for client/surface.json's jobCommitChannels: the replies of mark:commit and browse:annotation-requested. */
export const JOB_COMMIT_CHANNELS: readonly (keyof EventMap)[] = [
  'mark:commit-ok',
  'mark:commit-failed',
  'browse:annotation-result',
  'browse:annotation-failed',
];

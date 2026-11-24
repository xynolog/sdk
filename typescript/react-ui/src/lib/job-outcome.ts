import { isObject, isString } from '@xynolog/core';
import type { JobDeclinedReason } from '@xynolog/core';
import type en from '../../translations/en.json';

/** The reasons this client has copy for: every reason the spec states, or this does not compile. */
const REASONS: Record<JobDeclinedReason, true> = {
  'no-text-layer': true,
  encrypted: true,
  corrupt: true,
  'too-large': true,
  empty: true,
};

const isDeclineReason = (reason: string): reason is JobDeclinedReason =>
  Object.hasOwn(REASONS, reason);

/**
 * A detection job can *decline* cleanly rather than succeed or fail: a PDF
 * that is encrypted, damaged, or a scan whose text could not be recognized.
 * The worker reports it on `job:complete` as a `{ declined, reason }`
 * result — `JobDeclined`, a member of the typed `JobResult` union.
 * Narrowed structurally anyway: this runs against whatever the wire
 * delivered, and a runtime check is the honest guard at that boundary.
 * Returns the reason code, or null for an ordinary result or a reason this
 * client has no copy for.
 *
 * A decline is neither a success nor an error: the caller should surface it as
 * info — not a "complete" success toast (misleading — nothing was detected) and
 * not a "failed" error toast (alarming — nothing broke).
 */
export function declineReason(result: unknown): JobDeclinedReason | null {
  if (!isObject(result) || result.declined !== true || !isString(result.reason))
    return null;
  // A reason outside the vocabulary has no copy: returning it anyway would put
  // a raw, untranslated wire token in a toast.
  return isDeclineReason(result.reason) ? result.reason : null;
}

/** The key of a decline's copy in `OutcomeToasts`: a reason with no copy in `en.json` does not compile. */
export const declineCopyKey = (
  reason: JobDeclinedReason,
): keyof (typeof en)['OutcomeToasts'] => `decline_${reason}`;

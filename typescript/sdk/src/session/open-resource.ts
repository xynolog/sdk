/**
 * The pure list operations over the open-resources list (tabs), each entry
 * an `OpenResource` of @xynolog/core.
 *
 * The list itself lives on `XynologBrowser.openResources$`, and the CRUD
 * methods (`addOpenResource`, `removeOpenResource`, `updateOpenResourceName`,
 * `reorderOpenResources`) are its methods. What lives HERE is everything that
 * is a function of a list and nothing else — ordering, and the keep/drop
 * policy for revalidation — so both are testable without constructing a
 * browser.
 *
 * Its stored shape is protocol/specs/src/session/stored.json's `openResource`,
 * held by __tests__/stored-table.test.ts.
 */

import type { OpenResource, ResourceId, TabCheck } from '@xynolog/core';

/**
 * Apply per-tab verdicts to a list: drop the affirmed-absent, refresh what
 * validated, leave everything else exactly as it was.
 *
 * Takes the list as an argument rather than closing over a snapshot, and that
 * is load-bearing: the caller passes the CURRENT committed list, so a tab a
 * sibling context added while the checks were in flight survives — it simply
 * has no verdict, and no verdict means no change.
 */
export function applyTabChecks(
  list: readonly OpenResource[],
  checks: ReadonlyMap<ResourceId, TabCheck>,
): OpenResource[] {
  const kept: OpenResource[] = [];
  for (const tab of list) {
    const check = checks.get(tab.id);
    if (check?.verdict === 'gone') continue;
    if (check?.verdict === 'ready') {
      // The pass that proves a tab real also refreshes what it displays,
      // so a renamed resource stops showing its name from whenever the tab
      // was opened. Free — the descriptor is already in hand.
      kept.push({
        ...tab,
        name: check.name,
        ...(check.mediaType ? { mediaType: check.mediaType } : {}),
      });
      continue;
    }
    kept.push(tab);
  }
  return kept;
}

/** By place, and two in one place by when each was opened, earliest first. */
export function sortOpenResources(resources: OpenResource[]): OpenResource[] {
  return [...resources].sort((a, b) =>
    a.order === b.order ? a.openedAt - b.openedAt : a.order - b.order,
  );
}

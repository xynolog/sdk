/**
 * Each refinement in bus-refinements.ts names a channel of the registry, and
 * narrows the payload the registry states for it. Both are held at compile
 * time: `tsc --noEmit` refuses this file when a refinement names nothing, or
 * when it widens or changes its payload.
 */

import { describe, expect, it } from 'vitest';
import type { ChannelRefinements } from '../bus-refinements';
import type { StatedEventMap } from '../bus-protocol';

/** The keys of `ChannelRefinements` that name no channel, or do not narrow its payload. */
type Unrefining = {
  [K in keyof ChannelRefinements]: K extends keyof StatedEventMap
    ? ChannelRefinements[K] extends StatedEventMap[K]
      ? never
      : K
    : K;
}[keyof ChannelRefinements];

const channelsRefined: [Unrefining] extends [never] ? true : false = true;

describe('the bus refinements', () => {
  it('each names a channel and narrows its payload', () => {
    expect(channelsRefined).toBe(true);
  });
});

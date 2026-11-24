/**
 * What TypeScript adds to the payloads the bus registry states: what rides a
 * UI channel on this side only, which no schema states.
 *
 * `EventMap` (bus-protocol.ts) is each channel's stated payload with the
 * channel's refinement here in its place. Each refinement narrows the type it
 * replaces, and names a channel of the registry:
 * __tests__/bus-refinements.test.ts holds both.
 */

import type { components } from './types';

type Schemas = components['schemas'];

/** Each channel whose payload this layer narrows, and the payload it is. */
export type ChannelRefinements = {
  'panel:open': Schemas['BrowsePanelOpenEvent'] & {
    anchorRect?: Schemas['AnchorRect'];
  };
  'nav:external': Schemas['BrowseExternalNavigateEvent'] & {
    cancelFallback: () => void;
  };
};

// State units in `@xynolog/sdk` — RxJS-shaped state machines that any
// consumer (web, terminal, mobile, daemon, AI agent) can subscribe to.
// None presume a UI. See https://github.com/xynolog/docs/blob/main/builder/STATE-UNITS.md for the pattern.
//
//   flows/   — wrap the long-running content flows in stateful machines
//              (loading/error/pending observables, awaitable + reactive).
//              Currently five state units (mark, gather, match, yield, beckon).
//              The eighth flow, Frame, has no state unit — its MVP methods
//              are atomic `Promise<void>` writes with no progress
//              observables; a Frame state unit lands when the surface earns one.
//   lib/     — substrate (`createDisposer`, search pipeline)
//
// A worker's claiming is `job.claim` (`../claims`).
//
// Page-shaped state (admin tables, page routing, web shell) lives in
// `@xynolog/react-ui` next to the components that render it.

export { createDisposer } from './lib/state-unit';
export {
  createSearchPipeline,
  type SearchPipeline,
  type SearchPipelineOptions,
  type SearchState,
} from './lib/search-pipeline';

// ── Flow state units ────────────────────────────────────────────────────

export {
  createBeckonStateUnit,
  type BeckonStateUnit,
  createHoverDwell,
  type HoverDwell,
} from './flows/beckon-state-unit';
export { HOVER_DELAY_MS } from '@xynolog/core';
export {
  createGatherStateUnit,
  type GatherStateUnit,
} from './flows/gather-state-unit';
export {
  createMatchStateUnit,
  type MatchStateUnit,
} from './flows/match-state-unit';
export {
  createYieldStateUnit,
  type YieldStateUnit,
} from './flows/yield-state-unit';
export {
  createMarkStateUnit,
  type MarkStateUnit,
} from './flows/mark-state-unit';
export type { PendingAnnotation } from '@xynolog/core';

export type { ConnectionState } from '@xynolog/core';

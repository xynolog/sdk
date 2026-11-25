// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/connection-states.json
// Regenerate:  make generate  (codegen/lib/connection_states/typescript.ml)

import type { ConnectionState } from '@xynolog/core';

/** Each state of a client's stream, with the states it moves to and no other. */
export const CONNECTION_STATE_MOVES: Record<
  ConnectionState,
  readonly ConnectionState[]
> = {
  initial: ['connecting', 'unauthenticated', 'closed'],
  connecting: ['open', 'reconnecting', 'unauthenticated', 'closed'],
  open: ['reconnecting', 'closed'],
  reconnecting: ['connecting', 'degraded', 'unauthenticated', 'closed'],
  degraded: ['connecting', 'unauthenticated', 'closed'],
  unauthenticated: ['connecting', 'closed'],
  closed: [],
};

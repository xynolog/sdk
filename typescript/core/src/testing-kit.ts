// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/testing.json
// Regenerate:  make generate  (codegen/lib/testing/typescript.ml)

import type { Arbitrary } from 'fast-check';
import type { Observable } from 'rxjs';
import type { BusOperationKey } from './bus-operations';
import type { FaultyTransport } from './faulty-transport';

export type FaultAction =
  /** The request's reply is delivered. */
  | { kind: 'deliver' }
  /** The request's reply is lost. */
  | { kind: 'drop-reply' }
  /** The request's reply is delivered after `ms` milliseconds. */
  | { kind: 'delay'; ms: number }
  /** The request's reply is delivered twice. */
  | { kind: 'duplicate-reply' }
  /** The emit itself is refused: the request never reaches the gateway. */
  | { kind: 'reject-emit' };

/** The delays a drawn fault is of, in milliseconds. */
export const DELAY_MS = { minimum: 0, maximum: 5 } as const;

/** How many faults a drawn schedule is of. */
export const SCHEDULE_LENGTH = { minimum: 1, maximum: 8 } as const;

/** How many times its reckoned bound a case is given: the room a scheduler's jitter takes. */
export const SLACK = 4;

/** One step of an interleaving: a write, or a client-initiated transition. */
export const DELIVERY_OPS = ['write', 'transition'] as const;

export type DeliveryOp = (typeof DELIVERY_OPS)[number];

/** One request the transport was sent. */
export interface RequestLogEntry {
  channel: BusOperationKey;
  action: FaultAction;
  correlationId: string | undefined;
  retryKey: string;
  payload: Record<string, unknown>;
}

/** What one fresh run of a composition exposes to the axioms. */
export interface LivenessScenario {
  outputs: readonly Observable<unknown>[];
  settlements?: readonly Promise<unknown>[];
  teardown?: () => void;
}

/** A composition, and the schedules it is run under. */
export interface LivenessSpec {
  setup: (
    transport: FaultyTransport,
  ) => LivenessScenario | Promise<LivenessScenario>;
  timeoutMs: number;
  retryBudget?: number;
  cases?: number;
  schedules?: Arbitrary<readonly FaultAction[]>;
  makeResponse?: (
    operation: string,
    payload: Record<string, unknown>,
  ) => unknown;
}

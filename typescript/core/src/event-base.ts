/**
 * Event Base Types
 *
 * Core shapes for the event-sourced persistence model.
 * EventBase is the common shape for all domain events.
 * StoredEvent wraps an event with persistence metadata.
 *
 * These types are referenced by persisted-events.ts (domain events)
 * and bus-protocol.ts (the full EventMap).
 */

import type { components } from './types';
import type { PersistedEvent } from './persisted-events';

// ── Core event shape ─────────────────────────────────────────────────────────

/**
 * Fields common to ALL domain events (system and resource-scoped): the spec's
 * `StoredEventResponse` without what each event type states for itself (`type`,
 * `payload`) and what persistence adds (`metadata`).
 *
 * `userId` is the one identity fact an event carries: the verified emitter,
 * stamped by the gateway from the token at `emit`. Who *requested* the work
 * and what *produced* it are not fields here — they are derived by joining
 * this event to the job it cites, whose own events carry their own verified
 * emitters.
 *
 * `timestamp` is for humans. Ordering is `metadata.sequenceNumber`'s.
 */
export type EventBase = Omit<
  components['schemas']['StoredEventResponse'],
  'type' | 'payload' | 'metadata'
>;

/** Persistence metadata attached to every stored event. */
export type EventMetadata = components['schemas']['EventMetadata'];

// ── StoredEvent: flat intersection of event + metadata ───────────────────────

/**
 * A domain event with persistence metadata.
 * Flat intersection — no nesting (event.type, not event.event.type).
 */
export type StoredEvent<T extends EventBase = PersistedEvent> = T & {
  metadata: EventMetadata;
};

/**
 * A persisted event as the bus delivers it once the EventStore's enrich step
 * has run: the stored event, plus the annotation as it stands in the view. The
 * fields are the spec's (`EnrichedResourceEvent` beyond `StoredEventResponse`).
 * Optional, because enrichment declines when the view no longer holds the annotation.
 *
 * **Which channels carry it is the registry's `enriched` flag, and only that.**
 * A removal is not among them — the view never holds the annotation by then, so
 * the flag would promise what the enricher cannot deliver.
 */
export type EnrichedEvent<T extends EventBase = PersistedEvent> =
  StoredEvent<T> & EnrichmentFields;

type EnrichmentFields = Omit<
  components['schemas']['EnrichedResourceEvent'],
  keyof components['schemas']['StoredEventResponse']
>;

/**
 * A persisted event as a history reply carries it: the stored event, and the
 * agent its `userId` identifies. The agent is derived when the reply is made
 * and is in no log.
 */
export type AttributedEvent = components['schemas']['AttributedEvent'];

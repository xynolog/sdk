/**
 * The wire carries identity.
 *
 * One field has to exist, on both bus request bodies, before the gateway can
 * route a reply to the one client that asked for it: `clientId`. The schemas
 * carry it; the gateway's reply filter, which writes a correlated reply only
 * to its owner's connections, is what reads it.
 *
 * Asserted against `protocol/specs/src/components/schemas/` rather than the generated
 * types because the schema is the authority — the TS types, the Go client and
 * the required table are all derived from it, so a check on any one of them
 * would be a check on a derivation.
 */

import { describe, it, expect } from 'vitest';
import { schema as busSubscribeRequest } from './cases/components_schemas_bus_subscribe_request_schema';
import { schema as busEmitRequest } from './cases/components_schemas_bus_emit_request_schema';

describe('the wire carries identity', () => {
  it('BusSubscribeRequest REQUIRES clientId', () => {
    // Required, not optional: a subscriber without one could never receive a
    // correlated frame, and that has to fail loudly at subscribe rather than
    // silently at delivery.
    expect(busSubscribeRequest.properties).toHaveProperty('clientId');
    expect(busSubscribeRequest.required).toContain('clientId');
  });

  it('BusEmitRequest carries clientId, optionally', () => {
    // Optional in the schema because plain broadcasts need no return address;
    // the ROUTE enforces it for a registry operation's request emitted with a
    // correlationId. A schema-level requirement would reject every
    // legitimate broadcast emit.
    expect(busEmitRequest.properties).toHaveProperty('clientId');
    expect(busEmitRequest.required).not.toContain('clientId');
  });

  it('clientId is a top-level wire field on emit, never inside the payload', () => {
    // It is a routing concern like `scope`, not part of any channel's domain
    // payload — burying it in the payload would put a routing address into
    // every consumer's typed event.
    expect(Object.keys(busEmitRequest.properties)).toEqual(
      expect.arrayContaining(['channel', 'payload', 'scope', 'clientId']),
    );
  });
});

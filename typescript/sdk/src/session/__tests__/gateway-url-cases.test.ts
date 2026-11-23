/**
 * The origin of a knowledge base's gateway, from its HTTP endpoint: one table,
 * protocol/specs/src/session/gateway-url-cases.json, run by every SDK.
 */

import { describe, it, expect } from 'vitest';
import type { HttpEndpoint } from '@xynolog/core';
import { kbGatewayUrl } from '../storage';
import { table } from '../../__tests__/cases/session_gateway_url_cases';

describe("a gateway's origin, as the shared table states it", () => {
  it.each(table.cases)('$why', ({ endpoint, origin }) => {
    const http = endpoint as HttpEndpoint;
    if (origin === null) {
      expect(() => kbGatewayUrl(http)).toThrow(
        `Invalid KB hostname: "${http.host}"`,
      );
    } else {
      expect(kbGatewayUrl(http)).toBe(origin);
    }
  });
});

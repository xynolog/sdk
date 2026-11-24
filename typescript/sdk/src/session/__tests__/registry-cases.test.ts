/**
 * When a registry takes two endpoints for one place, and the order it shows
 * the resources open in a knowledge base in: two tables,
 * protocol/specs/src/session/registry-cases.json, run by every SDK.
 */

import { describe, it, expect } from 'vitest';
import { resourceId, type KbEndpoint, type OpenResource } from '@xynolog/core';
import { sortOpenResources } from '../open-resource';
import { samePlace } from '../xynolog-browser';
import { table } from '../../__tests__/cases/session_registry_cases';

describe('one place, as the shared table states it', () => {
  it.each(table.cases)('$why', ({ one, other, samePlace: same }) => {
    const a = one as KbEndpoint;
    const b = other as KbEndpoint;
    expect(samePlace(a, b)).toBe(same);
    expect(samePlace(b, a)).toBe(same);
  });
});

describe('the order open resources are shown in, as the shared table states it', () => {
  it.each(table.openResourceOrder)('$why', ({ open, shown }) => {
    const kept = open.map((entry) => {
      const stated = entry as Omit<OpenResource, 'id'> & { id: string };
      return { ...stated, id: resourceId(stated.id) };
    });
    expect(sortOpenResources(kept).map((entry) => entry.id)).toEqual(shown);
  });
});

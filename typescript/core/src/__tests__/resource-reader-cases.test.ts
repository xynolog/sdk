/**
 * The readers of a resource's description, held to
 * protocol/specs/src/resources/reader-cases.json: the table every SDK's readers run, so
 * that every SDK gives one answer for one resource.
 *
 * Every SDK refuses a resource with a fault as it reads one in a reply, and
 * TypeScript does (`faultOf`): a refused case is refused there, for the fault
 * it states, and every other case has none. A resource no reply brought can
 * reach the readers, which refuse one whose representations are malformed.
 */

import { describe, it, expect } from 'vitest';
import { XynologError } from '../errors';
import type { ResourceDescriptor } from '../graph';
import { faultOf } from '../required';
import {
  getPrimaryMediaType,
  getPrimaryRepresentation,
  getResourceEntityTypes,
} from '../resource-utils';
import { table, type Read, type Refused } from './cases/resources_reader_cases';

const read = table.cases.filter(
  (stated): stated is Read => !('refused' in stated),
);
const refused = table.cases.filter(
  (stated): stated is Refused => 'refused' in stated,
);

/** What every case states, what a case of a resource with a representation states besides, and what a refused case states. */
const ALWAYS = ['entityTypes', 'resource', 'why'];
const OF_A_REPRESENTATION = ['primaryMediaType', 'primaryRepresentation'];
const OF_A_REFUSAL = ['member', 'reason', 'refused', 'resource', 'why'];

/** The reading is refused as the reader's own failure, naming the representations. */
function refusedNamingRepresentations(
  reading: () => unknown,
  why: string,
): void {
  let refusal: unknown;
  try {
    reading();
  } catch (thrown) {
    refusal = thrown;
  }
  expect(refusal, why).toBeInstanceOf(XynologError);
  if (refusal instanceof XynologError) {
    expect(refusal.code, why).toBe('error');
    expect(refusal.message, why).toContain('representations');
  }
}

describe('the readers of a resource (protocol/specs/src/resources/reader-cases.json)', () => {
  it('has cases of a resource with a representation and of one with none, with entity types and with none, and refused ones', () => {
    expect(
      read.some((stated) => stated.primaryRepresentation !== undefined),
    ).toBe(true);
    expect(
      read.some((stated) => stated.primaryRepresentation === undefined),
    ).toBe(true);
    expect(read.some((stated) => stated.entityTypes.length > 0)).toBe(true);
    expect(read.some((stated) => stated.entityTypes.length === 0)).toBe(true);
    expect(refused.some((stated) => stated.reason === 'lacks')).toBe(true);
    expect(refused.some((stated) => stated.reason === 'malformed')).toBe(true);
  });

  it('states in every case what each reader answers, and nothing no reader here reads', () => {
    for (const stated of read) {
      // The representation and its media type are stated together, or neither is.
      const hasOne = OF_A_REPRESENTATION.some((member) => member in stated);
      const expected = hasOne
        ? [...ALWAYS, ...OF_A_REPRESENTATION].sort()
        : ALWAYS;
      expect(Object.keys(stated).sort(), stated.why).toEqual(expected);
    }
    for (const stated of refused) {
      expect(Object.keys(stated).sort(), stated.why).toEqual(OF_A_REFUSAL);
      expect(stated.refused, stated.why).toBe(true);
    }
  });

  it('refuses, as a reply is refused, each refused resource for the fault it states, and finds none in any other', () => {
    for (const { why, resource, member, reason } of refused) {
      expect(faultOf('ResourceDescriptor', resource), why).toEqual({
        member,
        reason,
      });
    }
    for (const { why, resource } of read) {
      expect(faultOf('ResourceDescriptor', resource), why).toBeUndefined();
    }
  });

  for (const {
    why,
    resource,
    primaryRepresentation,
    primaryMediaType,
    entityTypes,
  } of read) {
    it(why, () => {
      const descriptor = resource as ResourceDescriptor;
      expect(getPrimaryRepresentation(descriptor)).toEqual(
        primaryRepresentation,
      );
      expect(getPrimaryMediaType(descriptor)).toBe(primaryMediaType);
      expect(getResourceEntityTypes(descriptor)).toEqual(entityTypes);
    });
  }

  for (const { why, resource } of refused.filter(
    (stated) =>
      stated.member === 'representations' && stated.reason === 'malformed',
  )) {
    it(why, () => {
      const descriptor = resource as ResourceDescriptor;
      refusedNamingRepresentations(
        () => getPrimaryRepresentation(descriptor),
        `${why}: getPrimaryRepresentation`,
      );
      refusedNamingRepresentations(
        () => getPrimaryMediaType(descriptor),
        `${why}: getPrimaryMediaType`,
      );
    });
  }
});

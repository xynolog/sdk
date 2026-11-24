/**
 * What every SDK's reading of a value finds of it, held to
 * protocol/specs/src/client/shape-cases.json: each case's value is held to
 * the schema it names, from the value itself, and its first fault is the one
 * the case states, or none.
 */

import { describe, it, expect } from 'vitest';
import { faultOf, isSchemaName } from '../required';
import { table } from './cases/client_shape_cases';

describe('the first fault of a value as a schema (protocol/specs/src/client/shape-cases.json)', () => {
  it('has cases', () => {
    expect(table.cases.length).toBeGreaterThan(0);
  });

  for (const stated of table.cases) {
    it(stated.why, () => {
      const { schema, value } = stated;
      if (!isSchemaName(schema))
        throw new Error(`the table has no schema ${schema}`);
      expect(faultOf(schema, value)).toEqual(
        'refused' in stated
          ? { member: stated.member, reason: stated.reason }
          : undefined,
      );
    });
  }
});

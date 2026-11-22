/**
 * The id of an annotation, held to protocol/specs/src/annotations/id-cases.json: the
 * table every SDK's builders run, so that the same annotation has the same id
 * whoever makes it, and making it again writes nothing new.
 */

import { describe, it, expect } from 'vitest';
import { annotationIdFor } from '../annotation-id';
import { table } from './cases/annotations_id_cases';

describe('the id of an annotation (protocol/specs/src/annotations/id-cases.json)', () => {
  it('has cases', () => {
    expect(table.cases.length).toBeGreaterThan(0);
  });

  for (const { why, id, ...identity } of table.cases) {
    it(why, () => {
      expect(annotationIdFor(identity)).toBe(id);
    });
  }
});

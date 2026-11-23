/**
 * `reconcile`, held to protocol/specs/src/annotations/reconcile-cases.json: the table
 * every SDK's `reconcile` runs, so that what a model quoted lands on the same
 * span of the text whoever reconciles it.
 */

import { describe, it, expect } from 'vitest';
import { reconcile } from '../annotation-builders';
import type { QuotedText } from '../payload-types';
import { table } from './cases/annotations_reconcile_cases';

describe('reconciling a quoted span (protocol/specs/src/annotations/reconcile-cases.json)', () => {
  it('has cases', () => {
    expect(table.cases.length).toBeGreaterThan(0);
  });

  for (const { why, text, quoted, reconciled } of table.cases) {
    it(why, () => {
      expect(reconcile(text, quoted as QuotedText)).toStrictEqual(reconciled);
    });
  }
});

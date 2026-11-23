/**
 * Locating a span of a PDF's text, held to the `cases` of
 * protocol/specs/src/annotations/pdf-locate-cases.json: the table every implementation
 * runs, so that a span is anchored to the same rectangles and written as the
 * same selectors, whoever does it. The table's `claims` are the rule of
 * Xynolog's worker alone, and are run there.
 */

import { describe, it, expect } from 'vitest';
import { locate, type AnchoredText } from '../pdf-anchoring';
import { createFragmentSelector } from '../pdf-coordinates';
import { table } from './cases/annotations_pdf_locate_cases';

describe('locating a span of a PDF (protocol/specs/src/annotations/pdf-locate-cases.json)', () => {
  it('has cases', () => {
    expect(table.cases.length).toBeGreaterThan(0);
  });

  for (const {
    why,
    anchored,
    span,
    overlapping,
    rects,
    fragments,
  } of table.cases) {
    it(why, () => {
      const located = locate(anchored as AnchoredText, span.start, span.end);
      expect(located.overlap, 'overlapping').toStrictEqual(overlapping);
      expect(located.rects, 'rects').toStrictEqual(rects);
      expect(rects.map(createFragmentSelector), 'fragments').toStrictEqual(
        fragments,
      );
    });
  }
});

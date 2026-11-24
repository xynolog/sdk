/**
 * The annotation readers, held to protocol/specs/src/annotations/reader-cases.json:
 * the table every SDK's readers run, so that every SDK gives one answer for
 * one annotation.
 */

import { describe, it, expect } from 'vitest';
import type { Annotation } from '../annotation-types';
import {
  getAnnotationExactText,
  getBodySource,
  getCommentText,
  getEntityTypes,
  getExactText,
  getTagCategory,
  getTagSchemaId,
  getTargetSelector,
  getTargetSource,
  getTextQuoteSelector,
  isAssessment,
  isBodyResolved,
  isComment,
  isHighlight,
  isReference,
  isResolvedReference,
  isStubReference,
  isTag,
} from '../web-annotation-utils';
import { table } from './cases/annotations_reader_cases';

const cases = table.cases.map((c) => ({
  ...c,
  annotation: c.annotation as Annotation,
}));

/** Each reader of the table, given the part of the annotation it reads. Nothing is `null`, as the table writes it. */
const READERS: Record<string, (annotation: Annotation) => unknown> = {
  bodySource: (a) => getBodySource(a.body),
  isBodyResolved: (a) => isBodyResolved(a.body),
  targetSource: (a) => getTargetSource(a.target),
  targetSelector: (a) => getTargetSelector(a.target) ?? null,
  isHighlight,
  isReference,
  isAssessment,
  isComment,
  isTag,
  commentText: (a) => getCommentText(a) ?? null,
  isStubReference,
  isResolvedReference,
  exactText: (a) => getExactText(getTargetSelector(a.target)),
  annotationExactText: getAnnotationExactText,
  textQuoteSelector: (a) => {
    const selector = getTargetSelector(a.target);
    return selector === undefined ? null : getTextQuoteSelector(selector);
  },
  entityTypes: getEntityTypes,
  tagCategory: (a) => getTagCategory(a) ?? null,
  tagSchemaId: (a) => getTagSchemaId(a) ?? null,
};

describe('the annotation readers (protocol/specs/src/annotations/reader-cases.json)', () => {
  it('has a reader here for each the table names, and no other', () => {
    expect(Object.keys(READERS).sort()).toEqual([...table.readers].sort());
  });

  it('states every reader in every case', () => {
    for (const { why, reads } of cases) {
      expect(Object.keys(reads).sort(), why).toEqual([...table.readers].sort());
    }
  });

  for (const { why, annotation, reads } of cases) {
    it(why, () => {
      for (const [reader, answer] of Object.entries(reads)) {
        expect(
          READERS[reader]?.(annotation),
          `${reader} of ${annotation.id}`,
        ).toEqual(answer);
      }
    });
  }
});

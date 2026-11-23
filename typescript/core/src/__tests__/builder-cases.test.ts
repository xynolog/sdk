/**
 * The annotation builders, held to protocol/specs/src/annotations/builder-cases.json:
 * the table every SDK's builders run, so that a span found in a resource, and
 * a resource as a whole, are built into the same annotation whoever builds it.
 */

import { describe, it, expect } from 'vitest';
import * as builders from '../annotation-builders';
import {
  annotationOfResource,
  annotationOfSpan,
  SpanRefusedError,
} from '../annotation-builders';
import type { TextSpan } from '../payload-types';
import type { Annotation } from '../annotation-types';
import { resourceId } from '../identifiers';
import type { AnchoredText } from '../pdf-anchoring';
import type { components } from '../types';
import { table } from './cases/annotations_builder_cases';
import { table as codes } from './cases/errors_codes';

type Agent = components['schemas']['Agent'];

/**
 * Every refusal a builder can give: the `spanRefusal` codes of
 * protocol/specs/src/errors/codes.json, which `SpanRefusal`, the type of a refusal's
 * `code`, is generated from.
 */
const REFUSALS: string[] = codes.spanRefusal.codes.map((entry) => entry.code);

/** The annotation with the members the table cannot state taken out, each first checked to be an instant. */
function stated(
  annotation: Annotation,
  unstated: string[],
): Record<string, unknown> {
  const rest: Record<string, unknown> = { ...annotation };
  for (const member of unstated) {
    const at = rest[member];
    expect(
      typeof at === 'string' && new Date(at).toISOString() === at,
      `${member}: ${String(at)}`,
    ).toBe(true);
    delete rest[member];
  }
  return rest;
}

/** What a builder threw, which a refused case requires it to. */
function thrownBy(build: () => unknown): unknown {
  try {
    build();
  } catch (error) {
    return error;
  }
  throw new Error('the builder refused nothing');
}

describe('the annotation builders (protocol/specs/src/annotations/builder-cases.json)', () => {
  it('are the ones the table names, and the module has nothing else but the error a refused span is', () => {
    expect(Object.keys(builders).sort()).toEqual(
      [...table.builders, 'SpanRefusedError'].sort(),
    );
  });

  it('has cases of each kind', () => {
    expect(table.cases.length).toBeGreaterThan(0);
    expect(table.resources.length).toBeGreaterThan(0);
  });

  it('can give the refusals the cases name, and no other', () => {
    const named = new Set(
      table.cases.flatMap((built) =>
        'refused' in built ? [built.refused] : [],
      ),
    );
    expect([...named].sort()).toEqual([...REFUSALS].sort());
  });

  for (const built of table.cases) {
    it(built.why, () => {
      const { resourceId: id, generator, motivation, span, body } = built;
      const of = {
        resourceId: resourceId(id),
        generator: generator as Agent,
        motivation,
        span: span as TextSpan,
        ...(body !== undefined ? { body: body as Annotation['body'] } : {}),
      };
      const build = () =>
        'text' in built
          ? annotationOfSpan({ ...of, text: built.text })
          : annotationOfSpan({
              ...of,
              anchored: built.anchored as AnchoredText,
            });

      if ('refused' in built) {
        const refusal = thrownBy(build);
        expect(refusal).toBeInstanceOf(SpanRefusedError);
        expect((refusal as SpanRefusedError).code).toBe(built.refused);
      } else {
        expect(stated(build(), table.unstated.cases)).toStrictEqual(
          built.annotation,
        );
      }
    });
  }

  for (const built of table.resources) {
    it(built.why, () => {
      const { resourceId: id, motivation, generator, body } = built;
      const annotation = annotationOfResource({
        resourceId: resourceId(id),
        motivation,
        ...(generator !== undefined ? { generator: generator as Agent } : {}),
        ...(body !== undefined ? { body: body as Annotation['body'] } : {}),
      });
      expect(stated(annotation, table.unstated.resources)).toStrictEqual(
        built.annotation,
      );
    });
  }
});

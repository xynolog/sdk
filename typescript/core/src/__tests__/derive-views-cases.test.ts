/**
 * The flat views read off a knowledge graph, held to
 * protocol/specs/src/librarian/derive-views-cases.json: the table every
 * implementation of the reading runs, so that one graph gives one set of
 * connections, citations and sibling entity types in any language.
 */

import { describe, it, expect } from 'vitest';
import { deriveViews } from '../knowledge-graph-views';
import { faultOf, said } from '../required';
import type { components } from '../types';
import { table } from './cases/librarian_derive_views_cases';

type KnowledgeGraph = components['schemas']['KnowledgeGraph'];

describe('the views read off a knowledge graph (protocol/specs/src/librarian/derive-views-cases.json)', () => {
  it('has cases, with a focal annotation and with none', () => {
    expect(table.cases.length).toBeGreaterThan(0);
    for (const stated of table.cases) {
      expect(typeof stated.why).toBe('string');
      expect(Object.keys(stated)).toEqual(
        expect.arrayContaining(['graph', 'resource', 'views']),
      );
    }
    expect(table.cases.some((stated) => stated.annotation !== undefined)).toBe(
      true,
    );
    expect(table.cases.some((stated) => stated.annotation === undefined)).toBe(
      true,
    );
  });

  it('states only graphs the spec accepts', () => {
    for (const stated of table.cases) {
      const fault = faultOf('KnowledgeGraph', stated.graph);
      expect(fault === undefined ? null : said(fault), stated.why).toBeNull();
    }
  });

  it.each(table.cases)('$why', ({ graph, resource, annotation, views }) => {
    expect(
      deriveViews(graph as KnowledgeGraph, resource, annotation),
    ).toStrictEqual(views);
  });
});

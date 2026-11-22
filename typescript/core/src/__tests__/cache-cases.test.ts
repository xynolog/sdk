/**
 * The cache case table states the spec's rule: protocol/specs/src/session/cache-cases.json, held to the
 * queries protocol/specs/src/client/refresh.json marks `persisted` and to
 * protocol/specs/src/session/stored.json's `wholeKey`, `cacheDocument` and `lastEventIds`.
 *
 * Every SDK runs the table against its own persister, so a case whose expectation is not the spec's
 * would hold every SDK to a wrong rule. Here each expectation is derived from the spec alone: a
 * document's structure by stored.json's own `cacheDocument`, each key by the query's `per` and each
 * value by its `value`, as the generated refresh table (`CACHE_PER`, `CACHE_VALUES`) states them. A load
 * keeps exactly the entries whose key and value both hold, of a document whose structure holds; a load
 * of places keeps exactly the pairs of a resource's id and a PersistedEventId. A refused write writes,
 * once the storage takes it, what a write does.
 */

import { describe, it, expect } from 'vitest';
import Ajv2020 from 'ajv/dist/2020.js';
import {
  CACHE_PER,
  CACHE_VALUES,
  PERSISTED_QUERIES,
  type CachePer,
  type PersistedQuery,
} from '../cache-refresh';
import { faultOf, isSchemaName } from '../required';
import {
  table,
  type CasesItem,
  type PlacesItem,
} from './cases/session_cache_cases';
import { table as stored } from './cases/session_stored';

/** An entry as the table states it: its key and its value. */
interface Entry {
  key: unknown;
  value: unknown;
}

const isPersisted = (name: string): name is PersistedQuery =>
  PERSISTED_QUERIES.some((persisted) => persisted === name);

function keptQuery(name: string, stated: string): PersistedQuery {
  if (!isPersisted(name))
    throw new Error(`${stated}: ${name} is no kept query`);
  return name;
}

/** Whether `value` holds as a `component`, by the rules every SDK reads the table by. */
const holds = (component: string, value: unknown): boolean => {
  if (!isSchemaName(component))
    throw new Error(`${component} is no component schema`);
  return faultOf(component, value) === undefined;
};

/** A key held as what the query is asked for per: a resource's id, an annotation's id, or the whole key. */
function keyHolds(query: PersistedQuery, key: unknown): boolean {
  const per: CachePer[PersistedQuery] = CACHE_PER[query];
  switch (per) {
    case 'resource':
      return holds('ResourceId', key);
    case 'annotation':
      return holds('AnnotationId', key);
    case 'whole':
      return key === stored.wholeKey.key;
  }
}

/** A value held as its component holding it alone, member within member. */
function valueHolds(query: PersistedQuery, value: unknown): boolean {
  const { component } = CACHE_VALUES[query];
  const members: readonly string[] = CACHE_VALUES[query].members;
  return holds(
    component,
    members.reduceRight<unknown>(
      (inner, member) => ({ [member]: inner }),
      value,
    ),
  );
}

const structureHolds = new Ajv2020({ strict: false }).compile(
  stored.cacheDocument as object,
);

/** The text a case keeps under its key. */
const text = (stated: CasesItem | PlacesItem): string => {
  if ((stated.stored === undefined) === (stated.storedText === undefined))
    throw new Error(
      `${stated.name}: states not exactly one of stored and storedText`,
    );
  return stated.storedText ?? JSON.stringify(stated.stored);
};

const parsed = (
  source: string,
): { ok: true; value: unknown } | { ok: false } => {
  try {
    return { ok: true, value: JSON.parse(source) };
  } catch {
    return { ok: false };
  }
};

/** What a load of a query's document keeps, by the spec's rule. */
function loaded(query: PersistedQuery, source: string): Entry[] {
  const document = parsed(source);
  if (!document.ok || !structureHolds(document.value)) return [];
  const { entries } = document.value as {
    entries: [unknown, unknown, number][];
  };
  return entries
    .filter(([key, value]) => keyHolds(query, key) && valueHolds(query, value))
    .map(([key, value]) => ({ key, value }));
}

/** What a load of places keeps, by the spec's rule. */
function placesLoaded(source: string): Record<string, string> {
  const places = parsed(source);
  if (
    !places.ok ||
    typeof places.value !== 'object' ||
    places.value === null ||
    Array.isArray(places.value)
  )
    return {};
  return Object.fromEntries(
    Object.entries(places.value).filter(
      ([scope, place]) =>
        holds('ResourceId', scope) && holds('PersistedEventId', place),
    ),
  );
}

const asMap = (entries: Entry[]): Map<string, unknown> =>
  new Map(entries.map(({ key, value }) => [JSON.stringify(key), value]));

describe('the cache case table (protocol/specs/src/session/cache-cases.json)', () => {
  it('keeps every query refresh.json marks persisted, and no other', () => {
    expect(new Set(table.cases.map((stated) => stated.query))).toEqual(
      new Set(PERSISTED_QUERIES),
    );
    expect(new Set(table.writes.map((stated) => stated.query))).toEqual(
      new Set(PERSISTED_QUERIES),
    );
  });

  it.each(table.cases)('$name: keeps what the spec keeps', (stated) => {
    const query = keptQuery(stated.query, stated.name);
    expect(asMap(stated.kept)).toEqual(asMap(loaded(query, text(stated))));
  });

  it.each([...table.writes, ...table.refusedWrites])(
    "$name: writes what it holds, each key and value the query's",
    (stated) => {
      const query = keptQuery(stated.query, stated.name);
      for (const { key, value } of stated.held) {
        expect(
          keyHolds(query, key),
          `${stated.name}: key ${JSON.stringify(key)}`,
        ).toBe(true);
        expect(
          valueHolds(query, value),
          `${stated.name}: the value of ${JSON.stringify(key)}`,
        ).toBe(true);
      }
      const stamped = {
        ...stated.written,
        entries: stated.written.entries.map(({ key, value }) => [
          key,
          value,
          0,
        ]),
      };
      expect(structureHolds(stamped)).toBe(true);
      expect(asMap(stated.written.entries)).toEqual(asMap(stated.held));
    },
  );

  it.each(table.places)('$name: keeps the places the spec keeps', (stated) => {
    expect(stated.kept).toEqual(placesLoaded(text(stated)));
  });
});

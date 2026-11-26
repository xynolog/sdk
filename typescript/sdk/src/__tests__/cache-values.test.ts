/**
 * What each live query's cache holds, as protocol/specs/src/client/refresh.json's `value` says. The mapping
 * is generated (codegen/lib/cache_refresh/typescript.ml): `CACHE_VALUES`, each query's component
 * and the members within it, and `CacheValues`, the type each names, which types the namespaces' caches.
 * That it names refresh.json's rows is the generator's to hold, and `make check-generated`'s. Held here, at
 * compile time (`shownCensus`): that what each live query shows, which namespaces/types.ts writes by hand in
 * the names consumers read (`ResourceDescriptor`, `ListResourcesResponse`, …), is its cache's value. `annotations`
 * shows its value's annotations. `engines` shows each engine joined with its limits (`EnginesWithLimits`), which
 * is no cache's value, and nothing here holds it.
 */

import { describe, it, expect } from 'vitest';
import type { CacheQuery, CacheValues } from '@xynolog/core';
import type { CacheObservable } from '../awaitable';
import type {
  BrowseNamespace,
  GatherNamespace,
  MatchNamespace,
} from '../namespaces/types';

/** What a live query shows. */
type Shown<O> = O extends CacheObservable<infer V> ? V : never;

/** The queries whose live query shows what generation names: all but `engines`. */
type Named = Exclude<CacheQuery, 'engines'>;

/** What each live query shows, as its namespace declares it. */
interface ShownByQuery {
  resource: Shown<ReturnType<BrowseNamespace['resource']>>;
  annotations: Shown<ReturnType<BrowseNamespace['annotations']>>;
  annotation: Shown<ReturnType<BrowseNamespace['annotation']>>;
  events: Shown<ReturnType<BrowseNamespace['events']>>;
  referencedBy: Shown<ReturnType<GatherNamespace['referencedBy']>>;
  resources: Shown<ReturnType<BrowseNamespace['resources']>>;
  matchedResources: Shown<ReturnType<MatchNamespace['resources']>>;
  entityTypes: Shown<ReturnType<BrowseNamespace['entityTypes']>>;
  tagSchemas: Shown<ReturnType<BrowseNamespace['tagSchemas']>>;
}

/** What of its cache's value each live query shows: the value, or `annotations`' annotations. */
type ShownOfValue<Q extends Named> = Q extends 'annotations'
  ? CacheValues['annotations']['annotations']
  : CacheValues[Q];

/** Each holds every value of the other: the same shape, however it is written. */
type Agrees<A, B> = [A] extends [B] ? ([B] extends [A] ? true : false) : false;

type Disagreeing = {
  [Q in Named]: Agrees<ShownByQuery[Q], ShownOfValue<Q>> extends true
    ? never
    : Q;
}[Named];

/** tsc fails here while any live query shows another type than its cache's value: `Disagreeing` is those queries. */
const shownCensus: [Disagreeing] extends [never] ? 'agrees' : Disagreeing =
  'agrees';

describe("what each live query's cache holds (protocol/specs/src/client/refresh.json's value)", () => {
  it("what each live query shows is its cache's value", () => {
    expect(shownCensus).toBe('agrees');
  });
});

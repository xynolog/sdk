/**
 * SearchState and JobEvent are generic, so they are written by hand; this
 * census holds each to its schema in protocol/specs/src/client/types. The
 * compiler holds each list below to the type's members and branches, and the
 * test holds the list to the schema's, so a member or a branch either side
 * gains or loses fails.
 */

import { describe, expect, expectTypeOf, it } from 'vitest';
import type { JobEvent } from '../awaitable';
import type { SearchState } from '../state/lib/search-pipeline';
import { schema as jobEvent } from './cases/client_types_job_event_schema';
import { schema as searchState } from './cases/client_types_search_state_schema';

const sorted = (names: readonly string[]) => [...names].sort();

const SEARCH_STATE = [
  'results',
  'isSearching',
] as const satisfies readonly (keyof SearchState<unknown>)[];

type Branch<K extends JobEvent['kind']> = Extract<JobEvent, { kind: K }>;

const JOB_EVENT = {
  created: ['kind', 'data'],
  progress: ['kind', 'data'],
  failed: ['kind', 'data'],
  refused: ['kind', 'data'],
  complete: ['kind', 'data'],
} as const satisfies { [K in JobEvent['kind']]: readonly (keyof Branch<K>)[] };

const REFUSED_DATA = [
  'channel',
  'member',
  'reason',
] as const satisfies readonly (keyof Branch<'refused'>['data'])[];

describe('the generic client types (protocol/specs/src/client/types)', () => {
  it('SearchState has the schema’s members', () => {
    expectTypeOf<
      Exclude<keyof SearchState<unknown>, (typeof SEARCH_STATE)[number]>
    >().toBeNever();
    expect(sorted(Object.keys(searchState.properties))).toEqual(
      sorted(SEARCH_STATE),
    );
  });

  it('JobEvent has the schema’s branches, each of its members', () => {
    expectTypeOf<
      Exclude<keyof Branch<'created'>, (typeof JOB_EVENT.created)[number]>
    >().toBeNever();
    expectTypeOf<
      Exclude<keyof Branch<'progress'>, (typeof JOB_EVENT.progress)[number]>
    >().toBeNever();
    expectTypeOf<
      Exclude<keyof Branch<'failed'>, (typeof JOB_EVENT.failed)[number]>
    >().toBeNever();
    expectTypeOf<
      Exclude<keyof Branch<'refused'>, (typeof JOB_EVENT.refused)[number]>
    >().toBeNever();
    expectTypeOf<
      Exclude<keyof Branch<'complete'>, (typeof JOB_EVENT.complete)[number]>
    >().toBeNever();
    expectTypeOf<
      Exclude<keyof Branch<'refused'>['data'], (typeof REFUSED_DATA)[number]>
    >().toBeNever();

    const branches = new Map<string, (typeof jobEvent.oneOf)[number]>(
      jobEvent.oneOf.map((branch) => [branch.properties.kind.enum[0], branch]),
    );
    expect(sorted([...branches.keys()])).toEqual(
      sorted(Object.keys(JOB_EVENT)),
    );
    for (const [kind, members] of Object.entries(JOB_EVENT)) {
      expect(sorted(Object.keys(branches.get(kind)!.properties))).toEqual(
        sorted(members),
      );
    }
    const refused = branches.get('refused')!.properties.data;
    if (!('properties' in refused))
      throw new Error('the refused branch states no members of its data');
    expect(sorted(Object.keys(refused.properties))).toEqual(
      sorted(REFUSED_DATA),
    );
  });
});

/**
 * The client types the generator leaves to each SDK (protocol/specs/src/client/types):
 * SearchState and JobEvent, which are generic, and EngineWithLimits,
 * PutBinaryRequest, ResourceRepresentation and ResourceRepresentationStream,
 * which hold bytes or join what two answers say. This census holds each to
 * its schema. The compiler holds each list below to the type's members (and
 * which it requires) and branches, and the test holds the list to the
 * schema's, so a member or a branch either side gains or loses fails.
 */

import { describe, expect, expectTypeOf, it } from 'vitest';
import type {
  EngineWithLimits,
  PutBinaryRequest,
  ResourceRepresentation,
  ResourceRepresentationStream,
} from '@xynolog/core';
import type { JobEvent } from '../awaitable';
import type { SearchState } from '../state/lib/search-pipeline';
import { schema as jobEvent } from './cases/client_types_job_event_schema';
import { schema as searchState } from './cases/client_types_search_state_schema';
import { schema as engineWithLimits } from './cases/client_types_engine_with_limits_schema';
import { schema as putBinaryRequest } from './cases/client_types_put_binary_request_schema';
import { schema as resourceRepresentation } from './cases/client_types_resource_representation_schema';
import { schema as resourceRepresentationStream } from './cases/client_types_resource_representation_stream_schema';

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

/** Each member of `T`, and whether `T` requires it. */
type Members<T> = { readonly [K in keyof T]-?: boolean };
/** The members a list of `Members` says are required. */
type RequiredIn<L> = { [K in keyof L]: L[K] extends true ? K : never }[keyof L];
/** The members `T` requires. */
type RequiredOf<T> = {
  [K in keyof T]-?: object extends Pick<T, K> ? never : K;
}[keyof T];

const ENGINE_WITH_LIMITS = {
  engine: true,
  jobs: false,
  limits: false,
} as const satisfies Members<EngineWithLimits>;

const PUT_BINARY_REQUEST = {
  name: true,
  file: true,
  format: true,
  storageUri: true,
  language: false,
  entityTypes: false,
  sourceAnnotationId: false,
  sourceResourceId: false,
  generationPrompt: false,
  generator: false,
  jobId: false,
  isDraft: false,
  cloneToken: false,
  archiveOriginal: false,
} as const satisfies Members<PutBinaryRequest>;

const RESOURCE_REPRESENTATION = {
  data: true,
  contentType: true,
} as const satisfies Members<ResourceRepresentation>;

const RESOURCE_REPRESENTATION_STREAM = {
  stream: true,
  contentType: true,
} as const satisfies Members<ResourceRepresentationStream>;

/** A schema's members and the ones it requires, beside a list's. */
function heldTo(
  schema: { properties: object; required?: readonly string[] },
  members: { readonly [name: string]: boolean },
): void {
  expect(sorted(Object.keys(schema.properties))).toEqual(
    sorted(Object.keys(members)),
  );
  expect(sorted(schema.required ?? [])).toEqual(
    sorted(
      Object.entries(members)
        .filter(([, required]) => required)
        .map(([name]) => name),
    ),
  );
}

describe('the client types that hold bytes or join two answers', () => {
  it('each has its schema’s members, and requires what it requires', () => {
    expectTypeOf<RequiredOf<EngineWithLimits>>().toEqualTypeOf<
      RequiredIn<typeof ENGINE_WITH_LIMITS>
    >();
    expectTypeOf<RequiredOf<PutBinaryRequest>>().toEqualTypeOf<
      RequiredIn<typeof PUT_BINARY_REQUEST>
    >();
    expectTypeOf<RequiredOf<ResourceRepresentation>>().toEqualTypeOf<
      RequiredIn<typeof RESOURCE_REPRESENTATION>
    >();
    expectTypeOf<RequiredOf<ResourceRepresentationStream>>().toEqualTypeOf<
      RequiredIn<typeof RESOURCE_REPRESENTATION_STREAM>
    >();
    heldTo(engineWithLimits, ENGINE_WITH_LIMITS);
    heldTo(putBinaryRequest, PUT_BINARY_REQUEST);
    heldTo(resourceRepresentation, RESOURCE_REPRESENTATION);
    heldTo(resourceRepresentationStream, RESOURCE_REPRESENTATION_STREAM);
  });
});

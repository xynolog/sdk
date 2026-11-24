/**
 * The states a client reports, written by hand where their documentation
 * lives and stated by Protocol only in the conformance schemas that read
 * them: a state either side gains or loses fails to compile.
 */

import { describe, expectTypeOf, it } from 'vitest';
import type { ConnectionState, components } from '@xynolog/core';
import type { CacheState } from '../cache';

type Schemas = components['schemas'];

type StatedConnection = Extract<
  Schemas['ConformanceStep'],
  { state: unknown }
>['state'];

type StatedEmission = Extract<
  Schemas['ConformanceDriverLine'],
  { emission: unknown }
>['emission']['state']['status'];

describe('the states a client reports', () => {
  it('are the states the conformance schemas state', () => {
    expectTypeOf<ConnectionState>().toEqualTypeOf<StatedConnection>();
    expectTypeOf<CacheState<unknown>['status']>().toEqualTypeOf<StatedEmission>();
  });
});

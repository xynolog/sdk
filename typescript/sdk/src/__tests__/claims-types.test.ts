/**
 * The records a worker states, written by hand in claims.ts because the
 * Haskell generator reads their declarations there, each held to the wire
 * schema it restates: a member either side gains, loses or changes fails to
 * compile.
 */

import { describe, expectTypeOf, it } from 'vitest';
import type { components } from '@xynolog/core';
import type { JobCheckpoint, JobFailure, WorkerVitals } from '../claims';

type Schemas = components['schemas'];

describe('the records a worker states', () => {
  it('are the wire schemas’ members', () => {
    expectTypeOf<WorkerVitals>().toEqualTypeOf<
      Omit<Schemas['WorkerEngineHealth'], 'engine' | 'jobs'>
    >();
    expectTypeOf<JobCheckpoint>().toEqualTypeOf<
      Pick<Schemas['JobCheckpointCommand'], 'completedUnits' | 'unitCursors'>
    >();
    expectTypeOf<JobFailure>().toEqualTypeOf<
      Pick<
        Schemas['JobFailCommand'],
        'completedUnits' | 'unitCursors' | 'failureClass'
      >
    >();
    expectTypeOf<Partial<JobCheckpoint>>().toEqualTypeOf<
      Pick<Schemas['JobCancelCommand'], 'completedUnits' | 'unitCursors'>
    >();
  });
});

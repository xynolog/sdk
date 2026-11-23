import { describe, it, expect } from 'vitest';
import { jobMatchesFilter } from '../job-filter';
import type { components } from '../types';
import { table } from './cases/jobs_filter_cases';

// The Dispatcher answers the same question in Rust, and each SDK's taking side
// in its own language. The shared table holds them all to one answer.
describe('whether a job matches a filter agrees with the shared table', () => {
  it('has cases that match and cases that do not', () => {
    expect(table.cases.some((c) => c.matches)).toBe(true);
    expect(table.cases.some((c) => !c.matches)).toBe(true);
  });

  it.each(table.cases)('$why', ({ filter, job, matches }) => {
    expect(
      jobMatchesFilter(filter as components['schemas']['JobFilter'], job),
    ).toBe(matches);
  });
});

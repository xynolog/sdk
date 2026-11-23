/**
 * Whether a failed request is worth another attempt is one table,
 * protocol/specs/src/retry/cases.json, run here through `RETRY_RULES` and
 * `retryAfterMs`. Every SDK that carries these rules runs the same table: a
 * mirror across implementations, gated by one table rather than generated.
 */
import { describe, it, expect } from 'vitest';
import { RETRY_RULES } from '../retry-rules';
import { retryAfterMs } from '../retry';
import { table } from './cases/retry_cases';

const { rules, retryAfter } = table;

const isRuleName = (name: string): name is keyof typeof RETRY_RULES =>
  Object.hasOwn(RETRY_RULES, name);

describe('retry — core agrees with the shared table', () => {
  it('the table asks every named rule, both ways: a rule with no row, or only one answer, is not held', () => {
    for (const name of Object.keys(RETRY_RULES)) {
      const answers = new Set(
        rules.filter((c) => c.rule === name).map((c) => c.retries),
      );
      expect([...answers].sort(), `rule "${name}"`).toEqual([false, true]);
    }
    expect(retryAfter.length).toBeGreaterThan(0);
  });

  it.each(rules)('$rule: $why', (c) => {
    if (!isRuleName(c.rule))
      throw new Error(`the table names a rule core does not have: ${c.rule}`);
    expect(
      RETRY_RULES[c.rule].retryable({
        status: c.status,
        method: 'method' in c ? c.method : undefined,
        keyed: 'keyed' in c ? c.keyed : undefined,
      }),
    ).toBe(c.retries);
  });

  it.each(retryAfter)('Retry-After: $why', (c) => {
    expect(retryAfterMs(c.header)).toBe(c.ms ?? undefined);
  });
});

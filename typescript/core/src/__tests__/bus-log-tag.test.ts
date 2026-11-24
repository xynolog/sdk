/**
 * `busLogTagOf` reads back what `busLog` writes: every op, with and without
 * what a tag states beside the op and the channel.
 */

import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { BUS_OPS, busLog, busLogTagOf } from '../bus-log';

const flag = globalThis as { __XYNOLOG_BUS_LOG__?: boolean };
let saved: boolean | undefined;
let debug: ReturnType<typeof vi.spyOn>;

beforeEach(() => {
  saved = flag.__XYNOLOG_BUS_LOG__;
  flag.__XYNOLOG_BUS_LOG__ = true;
  debug = vi.spyOn(console, 'debug').mockImplementation(() => {});
});

afterEach(() => {
  if (saved === undefined) delete flag.__XYNOLOG_BUS_LOG__;
  else flag.__XYNOLOG_BUS_LOG__ = saved;
  debug.mockRestore();
});

/** The tag of the one line written. */
function written(): string {
  expect(debug).toHaveBeenCalledTimes(1);
  const [tag] = debug.mock.calls[0] ?? [];
  if (typeof tag !== 'string') throw new Error('busLog wrote no tag');
  return tag;
}

describe('busLogTagOf', () => {
  it.each(BUS_OPS)('reads back a bare %s line', (op) => {
    busLog(op, 'browse:resource-requested', {});
    expect(busLogTagOf(written())).toEqual({
      op,
      channel: 'browse:resource-requested',
    });
  });

  it('reads back the scope and the correlation id', () => {
    busLog('EMIT', 'mark:added', {}, 'res-1', '0123456789abcdef');
    expect(busLogTagOf(written())).toEqual({
      op: 'EMIT',
      channel: 'mark:added',
      scope: 'res-1',
      cid: '01234567',
    });
  });

  it('reads nothing of a line busLog did not write', () => {
    expect(busLogTagOf('[bus WHAT] mark:added')).toBeUndefined();
    expect(busLogTagOf('a line of something else')).toBeUndefined();
  });
});

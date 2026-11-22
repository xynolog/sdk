/**
 * How a registry reads the errors of each session it activates: one table,
 * protocol/specs/src/session/registry-errors-cases.json, run by every SDK.
 *
 * `cases` runs a registry over a factory that builds a scripted session and
 * reads none of its errors: a real session and client over a transport whose
 * failures are exactly the code and message a case says, and a renewal that
 * records each token it is handed, so that a case fails if the registry
 * renews anything. The session says its own errors as a factory's keeping
 * says them (`sayOn`). What a case says `opening`, the factory says as it
 * builds the session; what it says `active`, it says once the registry has
 * activated it. Each case is held once the effect of what the session said
 * last is seen: its own error said on the registry's errors, or a refusal for
 * lack of permission said through the session's signals.
 *
 * `closing` runs a registry over the HTTP session factory, over a gateway
 * that is `fetch` and nothing else (fake-gateway.ts), as a registry's
 * sessions are: the session's client keeps for jo in the registry's storage,
 * which refuses every write once the session is active, and a read of a
 * resource, made while the clock is held, leaves the client owing its save,
 * still waiting out its debounce as the close begins.
 */

import { describe, it, expect, vi } from 'vitest';
import {
  BehaviorSubject,
  filter,
  firstValueFrom,
  lastValueFrom,
  map,
  toArray,
} from 'rxjs';
import { BRIDGED_CHANNELS, XynologError, resourceId } from '@xynolog/core';
import type {
  AccessToken,
  NewKnowledgeBase,
  XynologSessionErrorCode,
  TransportErrorCode,
} from '@xynolog/core';
import { isReady } from '../../cache';
import { XynologClient } from '../../client';
import { FaultyTransport, inMemoryContent } from '../../testing';
import { XynologSessionError } from '../errors';
import { createHttpSessionFactory } from '../http-session-factory';
import { XynologBrowser } from '../xynolog-browser';
import { XynologSession, sayOn } from '../xynolog-session';
import type { SessionFactory } from '../session-factory';
import { keptIn, personKey } from '../storage';
import { fakeGateway, GATEWAY_ENDPOINT, renews } from './fake-gateway';
import {
  RefusingStorage,
  TestStorage,
  freshJwt,
  testSession,
} from './test-storage-helpers';
import {
  table,
  type CasesItem,
  type SaidItem,
} from '../../__tests__/cases/session_registry_errors_cases';

/** The knowledge base each registry signs in to, where the fake gateway is. */
const KB: NewKnowledgeBase = {
  did: 'did:web:kb.example.org:kb-a',
  label: 'KB A',
  endpoint: GATEWAY_ENDPOINT,
};

const JO = {
  did: 'did:web:example.org:users:jo',
  email: 'jo@example.org',
  name: 'Jo',
  image: null,
  domain: 'example.org',
};

/** Say each of `entries` on `session`'s errors, in order: its own through `sayOn`, its transport's failures through `transport`. Gives each error as it was said. */
function sayAll(
  session: XynologSession,
  transport: FaultyTransport,
  entries: readonly SaidItem[],
): XynologError[] {
  return entries.map((entry): XynologError => {
    if ('own' in entry) {
      const own = new XynologSessionError(
        entry.own as XynologSessionErrorCode,
        `the session says ${entry.own}`,
        session.kb.id,
      );
      sayOn(session, own);
      return own;
    }
    const failure = new XynologError(
      entry.message,
      entry.transport as TransportErrorCode,
    );
    transport.fail(failure);
    return failure;
  });
}

/**
 * A factory that builds a scripted session and reads none of its errors: a
 * real session and client over a `FaultyTransport`, whose renewal records
 * each token it is handed and gives a new one. What `row` says `opening`, the
 * factory says as it builds the session, before handing it back.
 */
function scripted(row: CasesItem): {
  factory: SessionFactory;
  transports: Map<XynologSession, FaultyTransport>;
  sayings: Map<XynologSession, XynologError[]>;
  handed: (string | null)[];
} {
  const transports = new Map<XynologSession, FaultyTransport>();
  const sayings = new Map<XynologSession, XynologError[]>();
  const handed: (string | null)[] = [];
  const factory: SessionFactory = ({ kb, storage }) => {
    const transport = new FaultyTransport({ channels: BRIDGED_CHANNELS });
    const session = new XynologSession({
      kb,
      kept: keptIn(storage, kb.id),
      client: new XynologClient(transport, inMemoryContent()),
      token$: new BehaviorSubject<AccessToken | null>(null),
      refresh: async (holding) => {
        handed.push(holding);
        return freshJwt();
      },
    });
    transports.set(session, transport);
    if (row.while === 'opening')
      sayings.set(session, sayAll(session, transport, row.said));
    return session;
  };
  return { factory, transports, sayings, handed };
}

describe('protocol/specs/src/session/registry-errors-cases.json', () => {
  describe('cases', () => {
    it.each(table.cases)('$while: $why', async (row) => {
      const { factory, transports, sayings, handed } = scripted(row);
      const browser = new XynologBrowser({
        storage: new TestStorage(),
        sessionFactory: factory,
      });
      // Read before the knowledge base is added: a session it activates says what it says opening as it is made.
      const read: XynologSessionError[] = [];
      browser.error$.subscribe((error) => read.push(error));
      try {
        browser.addKb(KB, testSession(freshJwt(), 'refresh'));
        const active = await firstValueFrom(
          browser.activeSession$.pipe(
            filter((live): live is XynologSession => live !== null),
          ),
        );
        const transport = transports.get(active);
        if (transport === undefined)
          throw new Error(
            'the registry activated a session its factory did not make',
          );
        const signals = browser.activeSignals$.getValue();
        if (signals === null)
          throw new Error(
            'the registry activated a session without its signals',
          );
        if (row.while === 'active')
          sayings.set(active, sayAll(active, transport, row.said));
        const said = sayings.get(active);
        if (said === undefined) throw new Error('the session said nothing');
        const last = said[said.length - 1];
        if (last === undefined) throw new Error('the case says nothing');

        // The effect of what the session said last.
        if (last instanceof XynologSessionError)
          await vi.waitFor(() => expect(read).toContain(last));
        else if (last.code === 'forbidden')
          await vi.waitFor(() =>
            expect(signals.permissionDenied$.getValue()).toEqual({
              detail: last.message,
            }),
          );
        else
          throw new Error(
            `the case's last said, ${last.code}, has no effect to wait for`,
          );

        expect(read.map((error) => error.code)).toEqual(row.registryErrors);
        expect(handed, 'the tokens a renewal was handed').toEqual([]);
        if (row.permissionDenied === undefined)
          expect(signals.permissionDenied$.getValue()).toBeNull();
        else
          expect(signals.permissionDenied$.getValue()).toEqual({
            detail: row.permissionDenied,
          });
      } finally {
        await browser.dispose();
      }
    });
  });

  describe('closing', () => {
    it.each(table.closing)('owed $owed: $why', async (row) => {
      const storage = new RefusingStorage();
      const gateway = fakeGateway({
        whoIs: async () => Response.json(JO),
        issuer: renews,
        resourceName: 'kept',
      });
      const browser = new XynologBrowser({
        storage,
        sessionFactory: createHttpSessionFactory(gateway.fetch),
      });
      try {
        browser.addKb(KB, {
          ...testSession(freshJwt(), 'refresh'),
          personKey: personKey(JO.did),
        });
        const active = await firstValueFrom(
          browser.activeSession$.pipe(
            filter((live): live is XynologSession => live !== null),
          ),
        );
        storage.refusing = true;
        if (row.owed) {
          // The clock is held until the close begins: the save the read leaves the client owing waits out its debounce
          // on a timer that never falls due, so the close is the first to make it.
          vi.useFakeTimers({ toFake: ['setTimeout', 'clearTimeout'] });
          await firstValueFrom(
            active.client.browse
              .resource(resourceId('res-1'))
              .pipe(filter(isReady)),
          );
          vi.useRealTimers();
        }
        const said = lastValueFrom(
          browser.error$.pipe(
            map((error) => error.code),
            toArray(),
          ),
        );
        await browser.dispose();
        expect(await said).toEqual(row.registryErrors);
      } finally {
        vi.useRealTimers();
        gateway.close();
      }
    });
  });
});

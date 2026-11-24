/**
 * What a registry keeps in its storage, as protocol/specs/src/session/stored.json
 * states it: every key this SDK writes by hand, the key of a knowledge base's
 * session, the keys of what a session keeps of its stream and its queries for
 * one person, each as the table's example works it out, the members of a
 * stored session, the members of a resource open in a knowledge base, the key
 * of a kept query per nothing, and the members and the version of a kept
 * query's document. The queries kept across a restart are those
 * protocol/specs/src/client/refresh.json marks `persisted`, each asked for per
 * what it says, as the generated refresh table (`PERSISTED_QUERIES`,
 * `CACHE_PER`) states them. A key or a member the table gains, or a change in
 * what it requires, fails here until this SDK has it.
 * persisted-cases.test.ts holds every key a person's client keeps;
 * cache-cases.test.ts what a load keeps of a document and of `lastEventIds`.
 */

import { describe, it, expect } from 'vitest';
import { filter, firstValueFrom } from 'rxjs';
import {
  CACHE_PER,
  PERSISTED_QUERIES,
  faultOf,
  isObject,
  isSchemaName,
  isString,
  resourceId,
  type CachePer,
  type PersistedQuery,
} from '@xynolog/core';
import {
  KEPT_QUERIES,
  WHOLE_KEY,
  coupledLastEventId,
  keptPersister,
} from '../../cache-persister';
import { createTestSession } from '../../testing';
import { PENDING_AUTHORIZATION_KEY } from '../oauth';
import { XynologBrowser } from '../xynolog-browser';
import { InMemorySessionStorage } from '../session-storage';
import {
  ACTIVE_KEY,
  LAST_VIEWED_RESOURCE_BY_KB_KEY,
  OPEN_RESOURCES_BY_KB_KEY,
  STORAGE_KEY,
  cacheKey,
  getStoredSession,
  lastEventIdKey,
  personKey,
  sessionKey,
  setStoredSession,
} from '../storage';
import type { StoredSession } from '@xynolog/core';
import { table } from '../../__tests__/cases/session_stored';
import { schema as openResourceSchema } from '../../__tests__/cases/session_open_resource_schema';
import { schema as storedSessionSchema } from '../../__tests__/cases/session_stored_session_schema';

/** The person what the tests keep is kept for. */
const PERSON = personKey('did:web:example.org:users:jo');

/** What the table's `member` states at `path`, each step a member of an object. */
function statedAt(member: string, value: unknown, ...path: string[]): unknown {
  let at = value;
  for (const [depth, name] of path.entries()) {
    if (!isObject(at) || !(name in at))
      throw new Error(
        `the table's ${member} states no ${path.slice(0, depth + 1).join('.')}`,
      );
    at = at[name];
  }
  return at;
}

/** The `$ref` the table's `member` states at `path`. */
function refAt(member: string, value: unknown, ...path: string[]): string {
  const ref = statedAt(member, value, ...path, '$ref');
  if (!isString(ref)) throw new Error(`the table's ${member} names no schema`);
  return ref;
}

/** The schema the table names by its `$id` at `member`: `schema`, which states that `$id`. */
function referred<S extends { $id: string; title: string }>(
  member: 'storedSession' | 'openResource',
  schema: S,
): S {
  const ref = refAt(member, table[member]);
  if (ref !== schema.$id)
    throw new Error(
      `the table's ${member} names ${ref}; ${schema.title} states ${schema.$id}`,
    );
  return schema;
}

const storedSession = referred('storedSession', storedSessionSchema);
const openResource = referred('openResource', openResourceSchema);
const members = Object.keys(storedSession.properties);
const requiredMembers: readonly string[] = storedSession.required;

/** A key of each kind a kept query's entries are keyed by: a resource's id, an annotation's id, or the whole key. */
const KEY_OF_KIND: { [P in CachePer[PersistedQuery]]: string } = {
  resource: 'res-1',
  annotation: 'ann-1',
  whole: table.wholeKey.key,
};

/** Each key's constant here, by the name the table gives it. */
const KEYS: Record<string, string> = {
  knowledgeBasesKey: STORAGE_KEY,
  activeKey: ACTIVE_KEY,
  openResourcesByKbKey: OPEN_RESOURCES_BY_KB_KEY,
  lastViewedResourceByKbKey: LAST_VIEWED_RESOURCE_BY_KB_KEY,
  pendingAuthorizationKey: PENDING_AUTHORIZATION_KEY,
};

/**
 * What a registry with its knowledge base live writes under the open
 * resources key when one resource is opened with a media type and a place in
 * the working tree and another with neither: each written entry, by its id.
 */
async function writtenOpenResources(): Promise<Record<string, object>> {
  const kb = {
    id: 'kb-a',
    label: 'KB A',
    did: 'did:web:example.github.io:kb-a',
    endpoint: {
      kind: 'http' as const,
      host: 'localhost',
      port: 4000,
      protocol: 'http' as const,
    },
  };
  const { session, storage } = createTestSession({ kb });
  storage.set(STORAGE_KEY, JSON.stringify([kb]));
  storage.set(ACTIVE_KEY, kb.id);
  const browser = new XynologBrowser({
    storage,
    sessionFactory: () => session,
  });
  await firstValueFrom(
    browser.activeSession$.pipe(filter((live) => live !== null)),
  );

  browser.addOpenResource(
    resourceId('whole'),
    'Whole',
    'text/markdown',
    'file://docs/whole.md',
  );
  browser.addOpenResource(resourceId('bare'), 'Bare');
  const kept = storage.get(OPEN_RESOURCES_BY_KB_KEY);
  await browser.dispose();

  if (kept === null)
    throw new Error(`Nothing was written under ${OPEN_RESOURCES_BY_KB_KEY}`);
  const byKb = JSON.parse(kept) as Record<string, { id: string }[]>;
  return Object.fromEntries(byKb[kb.id].map((entry) => [entry.id, entry]));
}

/** What was written under `key`, as JSON. */
function writtenUnder(
  storage: InMemorySessionStorage,
  key: string,
): Record<string, unknown> {
  const text = storage.get(key);
  if (text === null) throw new Error(`Nothing was written under ${key}`);
  const written: unknown = JSON.parse(text);
  if (!isObject(written))
    throw new Error(`What was written under ${key} is no object: ${text}`);
  return written;
}

/** Whether a value holds as the component a `$ref` of the table names, by the rules every SDK reads the table by. */
function holdsAs(ref: string): (value: unknown) => boolean {
  const component =
    /^https:\/\/xynolog\.org\/protocol\/([A-Za-z0-9]+)\.json$/.exec(ref)?.[1];
  if (component === undefined || !isSchemaName(component))
    throw new Error(`${ref} names no component`);
  return (value) => faultOf(component, value) === undefined;
}

/** A stored value with every member the table names but `left`. */
const storedWithout = (left: string): string =>
  JSON.stringify(
    Object.fromEntries(
      members
        .filter((member) => member !== left)
        .map((member) => [member, `the ${member}`]),
    ),
  );

describe('what a registry keeps, as protocol/specs/src/session/stored.json states it', () => {
  it("each key is the table's, and the table has none this SDK lacks", () => {
    expect(
      Object.fromEntries(table.keys.map(({ member, key }) => [member, key])),
    ).toEqual(KEYS);
  });

  it("a knowledge base's session is kept under the table's prefix and its id", () => {
    expect(sessionKey('kb-a')).toBe(`${table.sessionKeyPrefix.prefix}kb-a`);
  });

  it("where a knowledge base's stream was, for one person, is kept under the key the table's example works out", () => {
    const { prefix, example } = table.lastEventIdKeyPrefix;
    const key = lastEventIdKey(example.kbId, personKey(example.did));
    expect(key).toBe(example.key);
    expect(key.startsWith(`${prefix}${example.kbId}.`)).toBe(true);
  });

  it("a kept query, for one person, is kept under the key the table's example works out", () => {
    const { prefix, example } = table.cacheKeyPrefix;
    const query = PERSISTED_QUERIES.find(
      (persisted) => persisted === example.query,
    );
    if (query === undefined)
      throw new Error(
        `the table's example keeps ${example.query}, which refresh.json does not mark persisted`,
      );
    const key = cacheKey(example.kbId, personKey(example.did), query);
    expect(key).toBe(example.key);
    expect(key.startsWith(`${prefix}${example.kbId}.`)).toBe(true);
  });

  const whole: StoredSession = {
    access: 'a',
    refresh: 'r',
    clientId: 'xynolog-browser',
    tokenEndpoint: 'https://issuer.test/token',
    revocationEndpoint: 'https://issuer.test/revoke',
    personKey: 'gqB898gk4Ww_orAHhzDCSVl7yHP9UEsX0DA_xbGbq-I',
  };

  it("a stored session is written with the table's members, and no others", () => {
    const storage = new InMemorySessionStorage();
    setStoredSession(storage, 'kb-a', whole);
    const written = JSON.parse(
      storage.get(sessionKey('kb-a')) ?? 'null',
    ) as Record<string, unknown>;
    expect(Object.keys(written).sort()).toEqual([...members].sort());
  });

  it('a stored session is read back with every member it was written with', () => {
    const storage = new InMemorySessionStorage();
    storage.set(sessionKey('kb-a'), JSON.stringify(whole));
    expect(getStoredSession(storage, 'kb-a')).toEqual(whole);
  });

  it.each(members)(
    'a stored value without %s is a session only if the table does not require it',
    (member) => {
      const storage = new InMemorySessionStorage();
      storage.set(sessionKey('kb-a'), storedWithout(member));
      const read = getStoredSession(storage, 'kb-a');
      if (requiredMembers.includes(member)) {
        expect(read).toBeNull();
      } else {
        expect(read).not.toBeNull();
      }
    },
  );

  it("an open resource is written with the table's members, and no others", async () => {
    const { whole } = await writtenOpenResources();
    expect(Object.keys(whole).sort()).toEqual(
      Object.keys(openResource.properties).sort(),
    );
  });

  it('an open resource with no media type and no place in the tree is written with the members the table requires, and no others', async () => {
    const { bare } = await writtenOpenResources();
    expect(Object.keys(bare).sort()).toEqual([...openResource.required].sort());
  });

  it('the queries this SDK reads back are those refresh.json marks persisted, in its order, and none other', () => {
    expect(Object.keys(KEPT_QUERIES)).toEqual([...PERSISTED_QUERIES]);
  });

  it.each(PERSISTED_QUERIES.map((query) => ({ query, per: CACHE_PER[query] })))(
    "$query: an entry keyed as refresh.json's per says ($per) is one it reads back",
    ({ query, per }) => {
      const sample = KEY_OF_KIND[per];
      expect(
        KEPT_QUERIES[query].key(sample),
        `${query} keeps an entry under ${JSON.stringify(sample)}`,
      ).toBe(true);
    },
  );

  it("a kept query per nothing keeps its one entry under the table's whole key", () => {
    expect(WHOLE_KEY).toBe(table.wholeKey.key);
  });

  it("a kept query's document is written with the table's members and version, and no others", () => {
    const storage = new InMemorySessionStorage();
    keptPersister('entityTypes', {
      storage,
      kbId: 'kb-a',
      personKey: PERSON,
    }).save(new Map([[WHOLE_KEY, ['Person']]]));
    const written = writtenUnder(
      storage,
      cacheKey('kb-a', PERSON, 'entityTypes'),
    );
    const properties = statedAt(
      'cacheDocument',
      table.cacheDocument,
      'properties',
    );
    if (!isObject(properties))
      throw new Error("the table's cacheDocument states no members");
    expect(Object.keys(written).sort()).toEqual(Object.keys(properties).sort());
    expect(written['version']).toBe(
      statedAt('cacheDocument', properties, 'version', 'const'),
    );
  });

  it("the stream's places are written as the table's lastEventIds", () => {
    const storage = new InMemorySessionStorage();
    const coupled = coupledLastEventId(storage, lastEventIdKey('kb-a', PERSON));
    coupled.saveLastEventId(resourceId('res-1'), 'p-res-1-47');
    coupled.storage.set(cacheKey('kb-a', PERSON, 'resource'), '{}');
    const written = writtenUnder(storage, lastEventIdKey('kb-a', PERSON));
    const scope = holdsAs(
      refAt('lastEventIds', table.lastEventIds, 'propertyNames'),
    );
    const place = holdsAs(
      refAt('lastEventIds', table.lastEventIds, 'additionalProperties'),
    );
    expect(Object.keys(written)).toEqual(['res-1']);
    for (const [key, value] of Object.entries(written)) {
      expect(scope(key), `the scope ${key}`).toBe(true);
      expect(place(value), `the place of ${key}`).toBe(true);
    }
  });
});

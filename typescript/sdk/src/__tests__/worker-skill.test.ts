/**
 * The `xynolog-worker` skill's TypeScript, type-checked, and its complete
 * worker, run.
 *
 * Every TypeScript block of the skill type-checks as a module of its own,
 * against the built packages, resolved as a Node program that installed them
 * resolves them. A block that awaits what is not thenable fails too: that is
 * legal TypeScript, and it is how a live query is misused.
 *
 * The TypeScript block of skills/xynolog-worker/SKILL.md that
 * has `main` is a whole program. Node is given it here word for word, as
 * whoever copies it would run it, with a gateway and the issuer it trusts
 * standing in on this machine. What the program sends is read off them. The
 * issuer admits the worker by its key, as a knowledge base's does: it grants
 * a token only for an assertion the worker's key signed
 * (protocol/specs/src/session/client-assertion-cases.json).
 *
 * The program imports `@xynolog/sdk` and `@xynolog/core` by name, so what
 * runs is the built packages: `npm run build:packages -- @xynolog/sdk` comes
 * first, and a package that is not built fails this test by name.
 */
import { spawn, type ChildProcessWithoutNullStreams } from 'node:child_process';
import { generateKeyPairSync, verify, type KeyObject } from 'node:crypto';
import { existsSync, readFileSync } from 'node:fs';
import { createServer, type ServerResponse } from 'node:http';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import * as ts from 'typescript';
import { afterEach, describe, expect, it } from 'vitest';
import { isObject, isString } from '@xynolog/core';
import { JOB_CLAIM_CHANNELS, JOB_COMMIT_CHANNELS } from '../worker-channels';
import { table as builderCases } from './cases/annotations_builder_cases';
import { table as clientAssertion } from './cases/session_client_assertion_cases';

const REPO = join(dirname(fileURLToPath(import.meta.url)), '../../../..');
const PACKAGE = join(REPO, 'typescript/sdk');
const SKILL_PATH = 'skills/xynolog-worker/SKILL.md';
const SKILL = readFileSync(join(REPO, SKILL_PATH), 'utf-8');
/** The skill's TypeScript blocks: each one's body, and the line of the skill its fence opens on. */
const FENCES = [
  ...SKILL.matchAll(/^```(?:ts|typescript)\b.*\n([\s\S]*?)^```$/gm),
].map((fence) => ({
  body: fence[1],
  line: SKILL.slice(0, fence.index).split('\n').length,
}));

/** The skill's TypeScript blocks that are a whole program: the ones that have a `main`. */
const PROGRAMS = FENCES.map((fence) => fence.body).filter((block) =>
  block.includes('async function main('),
);

/** A member of a JSON object. One that is not there is a failure that says so. */
function member(value: unknown, name: string): unknown {
  if (!isObject(value) || !(name in value))
    throw new Error(`${JSON.stringify(value)} has no \`${name}\``);
  return value[name];
}

function text(value: unknown): string {
  if (!isString(value)) throw new Error(`${JSON.stringify(value)} is not text`);
  return value;
}

function list(value: unknown): unknown[] {
  if (!Array.isArray(value))
    throw new Error(`${JSON.stringify(value)} is not a list`);
  return value;
}

/** A JWT that carries `claims`. Nothing here signs one, and nothing in the SDK verifies one. */
function jwt(claims: object): string {
  const segment = (value: unknown): string =>
    Buffer.from(JSON.stringify(value)).toString('base64url');
  return `${segment({ alg: 'HS256', typ: 'JWT' })}.${segment(claims)}.${segment('signature')}`;
}

/** A service account the issuer admits by its key: its client id, and the public half registered on its client. */
interface KeyAccount {
  clientId: string;
  publicKey: KeyObject;
}

/**
 * Whether a client-credentials grant's form proves `account`, as an issuer
 * checks it: the table's fields and no others, and an assertion `account`'s
 * key signed, made by and of the account, for this token endpoint, not expired.
 */
function proves(
  body: string,
  account: KeyAccount,
  tokenEndpoint: string,
): boolean {
  const form = new URLSearchParams(body);
  const fields = [...form.keys()];
  if (
    fields.length !== clientAssertion.form.length ||
    !clientAssertion.form.every((name) => fields.includes(name))
  )
    return false;
  if (
    form.get('grant_type') !== clientAssertion.grantType ||
    form.get('client_assertion_type') !== clientAssertion.assertionType
  )
    return false;
  const [head, claimed, signature, ...rest] = text(
    form.get('client_assertion'),
  ).split('.');
  if (
    head === undefined ||
    claimed === undefined ||
    signature === undefined ||
    rest.length > 0
  )
    return false;
  if (
    !verify(
      'sha256',
      Buffer.from(`${head}.${claimed}`),
      account.publicKey,
      Buffer.from(signature, 'base64url'),
    )
  )
    return false;
  const claims: unknown = JSON.parse(
    Buffer.from(claimed, 'base64url').toString('utf-8'),
  );
  return (
    member(
      JSON.parse(Buffer.from(head, 'base64url').toString('utf-8')),
      'alg',
    ) === 'RS256' &&
    member(claims, 'iss') === account.clientId &&
    member(claims, 'sub') === account.clientId &&
    member(claims, 'aud') === tokenEndpoint &&
    Number(member(claims, 'exp')) > Date.now() / 1000
  );
}

/** One request, as it arrived. */
interface Asked {
  method: string;
  path: string;
  authorization: string | undefined;
  body: string;
}

/** One emit the gateway's bus accepted. */
interface Emitted {
  channel: string;
  payload: unknown;
  authorization: string | undefined;
}

interface StandIn {
  origin: string;
  /** Every request, in the order it came. */
  asked: Asked[];
  /** Every emit the bus accepted, in order. */
  emitted: Emitted[];
  close(): Promise<void>;
}

/** What the stand-in is told: the account its issuer admits, who it says the account is, the token its issuer grants, the jobs its queue holds, and each resource's text. */
interface Knows {
  account: KeyAccount;
  did: string;
  serviceToken: string;
  queue: readonly unknown[];
  resources: Readonly<Record<string, string>>;
}

/**
 * A gateway and the issuer it trusts, on this machine. It names its issuer,
 * grants the account it admits its token, names the account that token is, holds
 * a stream open, serves a resource's bytes, and takes emits. Of what is emitted
 * it answers a claim, as the dispatcher does: the next job of its queue, or
 * that none is pending. And it answers a commit, as the record does: every
 * annotation of the batch is held, by its id.
 */
async function standIn(knows: Knows): Promise<StandIn> {
  const asked: Asked[] = [];
  const emitted: Emitted[] = [];
  const streams: ServerResponse[] = [];
  const queue = [...knows.queue];

  const server = createServer();
  await new Promise<void>((listening) =>
    server.listen(0, '127.0.0.1', listening),
  );
  const address = server.address();
  if (address === null || isString(address))
    throw new Error('a listening server has a port');
  const origin = `http://127.0.0.1:${address.port}`;
  const issuer = `${origin}/realms/xynolog`;

  const json = (
    response: ServerResponse,
    status: number,
    body: unknown,
  ): void => {
    response
      .writeHead(status, { 'content-type': 'application/json' })
      .end(JSON.stringify(body));
  };
  /** Say `payload` on `channel` to every open stream, as the answer to the request `correlationId` names. */
  const answer = (
    channel: string,
    correlationId: string,
    payload: unknown,
  ): void => {
    for (const stream of streams)
      stream.write(
        `event: bus-event\ndata: ${JSON.stringify({ channel, correlationId, payload })}\n\n`,
      );
  };

  server.on('request', (request, response) => {
    const chunks: Buffer[] = [];
    request.on('data', (chunk: Buffer) => chunks.push(chunk));
    request.on('end', () => {
      const { method, url: path } = request;
      if (method === undefined || path === undefined)
        throw new Error('a request to a server has a method and a path');
      const body = Buffer.concat(chunks).toString('utf-8');
      asked.push({
        method,
        path,
        authorization: request.headers.authorization,
        body,
      });

      switch (`${method} ${path}`) {
        case 'GET /.well-known/oauth-protected-resource':
          return json(response, 200, {
            resource: 'https://kb.example.org',
            authorization_servers: [issuer],
            bearer_methods_supported: ['header'],
          });
        case 'GET /realms/xynolog/.well-known/openid-configuration':
          return json(response, 200, {
            issuer,
            authorization_endpoint: `${issuer}/auth`,
            token_endpoint: `${issuer}/token`,
          });
        case 'POST /realms/xynolog/token':
          return proves(body, knows.account, `${issuer}/token`)
            ? json(response, 200, {
                access_token: knows.serviceToken,
                expires_in: 300,
              })
            : json(response, 401, { error: 'invalid_client' });
        case 'GET /api/users/me':
          return json(response, 200, {
            did: knows.did,
            email: null,
            name: null,
            image: null,
            domain: 'example.org',
          });
        case 'POST /bus/subscribe':
          // The stream is the response: it lasts until one side ends it.
          response.writeHead(200, { 'content-type': 'text/event-stream' });
          response.flushHeaders();
          streams.push(response);
          return;
        case 'POST /bus/emit': {
          const sent: unknown = JSON.parse(body);
          emitted.push({
            channel: text(member(sent, 'channel')),
            payload: member(sent, 'payload'),
            authorization: request.headers.authorization,
          });
          json(response, 202, {});
          if (member(sent, 'channel') === 'job:claim') {
            const job = queue.shift();
            if (job === undefined)
              answer('job:claim-failed', text(member(sent, 'correlationId')), {
                message: 'No pending job matches',
                code: 'none-pending',
              });
            else
              answer('job:claimed', text(member(sent, 'correlationId')), {
                response: job,
              });
          }
          if (member(sent, 'channel') === 'mark:commit') {
            const ids = list(
              member(member(sent, 'payload'), 'annotations'),
            ).map((annotation) => member(annotation, 'id'));
            answer('mark:commit-ok', text(member(sent, 'correlationId')), {
              response: { persisted: ids.length, annotationIds: ids },
            });
          }
          return;
        }
      }
      const resource =
        method === 'GET' && path.startsWith('/resources/')
          ? knows.resources[
              decodeURIComponent(path.slice('/resources/'.length))
            ]
          : undefined;
      if (resource === undefined)
        return json(response, 404, { error: 'The gateway has no such thing' });
      response
        .writeHead(200, { 'content-type': 'text/plain; charset=utf-8' })
        .end(resource);
    });
  });

  return {
    origin,
    asked,
    emitted,
    close: async () => {
      for (const stream of streams) stream.end();
      server.closeAllConnections();
      await new Promise<void>((closed) => server.close(() => closed()));
    },
  };
}

const DID = 'did:web:example.org:agents:service-account-my-worker';
const JOB = {
  status: 'running',
  metadata: {
    id: 'job-1',
    type: 'mark',
    userId: 'did:web:kb.example:users:u',
    created: '2026-01-01T00:00:00.000Z',
    retryCount: 0,
    maxRetries: 1,
  },
  params: { resourceId: 'res-1', motivation: 'highlighting' },
  startedAt: '2026-01-01T00:00:01.000Z',
  progress: {},
};

/** Whether some part of `type` has a callable `then`. `any` and `unknown` might, so they count. */
function thenable(checker: ts.TypeChecker, type: ts.Type): boolean {
  return (type.isUnion() ? type.types : [type]).some((part) => {
    if (part.flags & (ts.TypeFlags.Any | ts.TypeFlags.Unknown)) return true;
    const then = part.getProperty('then');
    const declaration = then?.declarations?.[0];
    if (!then || !declaration) return false;
    const thenType = checker.getTypeOfSymbolAtLocation(then, declaration);
    return (thenType.isUnion() ? thenType.types : [thenType]).some(
      (callee) => callee.getCallSignatures().length > 0,
    );
  });
}

describe('the TypeScript of the xynolog-worker skill', () => {
  it('type-checks, each block a module of its own, against the built packages, and awaits only what is thenable', () => {
    expect(FENCES.length, 'the skill shows TypeScript').toBeGreaterThan(0);
    const { options, errors } = ts.convertCompilerOptionsFromJson(
      {
        strict: true,
        target: 'es2022',
        lib: ['es2022'],
        module: 'nodenext',
        moduleResolution: 'nodenext',
        moduleDetection: 'force',
        types: ['node'],
        skipLibCheck: true,
        noEmit: true,
      },
      PACKAGE,
    );
    expect(errors).toEqual([]);

    // Each block is a file of the package's directory that only this program
    // holds, so its imports resolve from there, as an installed package's do.
    const blocks = new Map(
      FENCES.map((fence) => [
        join(PACKAGE, `xynolog-worker-skill.L${fence.line}.ts`),
        fence,
      ]),
    );
    const host = ts.createCompilerHost(options);
    const { fileExists, readFile, getSourceFile } = host;
    host.fileExists = (name) => blocks.has(name) || fileExists(name);
    host.readFile = (name) => {
      const block = blocks.get(name);
      return block ? block.body : readFile(name);
    };
    host.getSourceFile = (name, languageVersionOrOptions, ...rest) => {
      const block = blocks.get(name);
      return block
        ? ts.createSourceFile(name, block.body, languageVersionOrOptions, true)
        : getSourceFile(name, languageVersionOrOptions, ...rest);
    };
    const program = ts.createProgram([...blocks.keys()], options, host);
    const checker = program.getTypeChecker();

    /** Where in the skill a position of a block is. Its body's first line is the line after its fence. */
    const where = (file: ts.SourceFile, position: number): string => {
      const block = blocks.get(file.fileName);
      const { line } = file.getLineAndCharacterOfPosition(position);
      return block
        ? `${SKILL_PATH}:${block.line + line + 1}`
        : `${file.fileName}:${line + 1}`;
    };
    const failures = ts
      .getPreEmitDiagnostics(program)
      .filter(
        (diagnostic) => diagnostic.category === ts.DiagnosticCategory.Error,
      )
      .map(
        (diagnostic) =>
          `${diagnostic.file && diagnostic.start !== undefined ? where(diagnostic.file, diagnostic.start) : '(no position)'}  TS${diagnostic.code}: ${ts.flattenDiagnosticMessageText(diagnostic.messageText, ' ')}`,
      );
    for (const name of blocks.keys()) {
      const file = program.getSourceFile(name);
      if (!file) throw new Error(`${name} is not in the program`);
      const visit = (node: ts.Node): void => {
        if (
          ts.isAwaitExpression(node) &&
          !thenable(checker, checker.getTypeAtLocation(node.expression))
        ) {
          failures.push(
            `${where(file, node.getStart(file))}  awaits ${checker.typeToString(checker.getTypeAtLocation(node.expression))}, which is not thenable`,
          );
        }
        ts.forEachChild(node, visit);
      };
      visit(file);
    }
    expect(failures).toEqual([]);
  });
});

describe('the complete worker of the xynolog-worker skill', () => {
  let gateway: StandIn | undefined;
  let worker: ChildProcessWithoutNullStreams | undefined;

  afterEach(async () => {
    worker?.kill('SIGKILL');
    await gateway?.close();
  });

  it("says what it is called, claims as its agent, commits a highlight it built, says the job's lifecycle, claims again, and stops when it is told to", async () => {
    expect(PROGRAMS, 'the skill shows one TypeScript program').toHaveLength(1);
    const [program] = PROGRAMS;
    for (const imported of program.matchAll(/from '@xynolog\/([a-z-]+)'/g)) {
      const built = join(REPO, 'typescript', imported[1], 'dist/index.js');
      if (!existsSync(built))
        throw new Error(
          `${built} is missing: this test runs the built packages, so run \`npm run build --workspace=@xynolog/sdk\` first`,
        );
    }

    // A case of the table the builders are held by: a text that is one sentence, and the highlight of all of it.
    const stated = builderCases.cases[2];
    const page = text(member(stated, 'text'));
    expect([
      member(stated, 'resourceId'),
      member(stated, 'motivation'),
      member(stated, 'span'),
    ]).toEqual([
      'res-1',
      'highlighting',
      { start: 0, end: 39, exact: page, prefix: '', suffix: '' },
    ]);

    const issued = Math.floor(Date.now() / 1000);
    const serviceToken = jwt({ iat: issued, exp: issued + 300, n: 0 });
    // The worker's key, as the launcher hands it over: PKCS#8 PEM.
    const { privateKey, publicKey } = generateKeyPairSync('rsa', {
      modulusLength: 2048,
    });
    const pem = privateKey.export({ type: 'pkcs8', format: 'pem' }).toString();
    const admitted: KeyAccount = { clientId: 'my-worker', publicKey };
    const standing = await standIn({
      account: admitted,
      did: DID,
      serviceToken,
      queue: [JOB],
      resources: { 'res-1': page },
    });
    gateway = standing;

    const running = spawn(
      process.execPath,
      ['--input-type=module-typescript', '-'],
      {
        cwd: PACKAGE,
        env: {
          XYNOLOG_API_URL: standing.origin,
          XYNOLOG_OIDC_CLIENT_ID: admitted.clientId,
          XYNOLOG_OIDC_CLIENT_KEY: pem,
        },
      },
    );
    worker = running;
    const said = { out: '', err: '' };
    running.stdout.setEncoding('utf-8').on('data', (written: string) => {
      said.out += written;
    });
    running.stderr.setEncoding('utf-8').on('data', (written: string) => {
      said.err += written;
    });
    let ended:
      { code: number | null; signal: NodeJS.Signals | null } | undefined;
    const over = new Promise<void>((resolve) =>
      running.on('exit', (code, signal) => {
        ended = { code, signal };
        resolve();
      }),
    );
    running.stdin.end(program);

    const channels = (): string[] =>
      standing.emitted.map((emit) => emit.channel);
    const account = (): string =>
      [
        `It emitted: ${channels().join(', ')}`,
        `It asked: ${standing.asked.map((request) => `${request.method} ${request.path}`).join(', ')}`,
        `It ended: ${JSON.stringify(ended)}`,
        `stdout:\n${said.out}`,
        `stderr:\n${said.err}`,
      ].join('\n');
    /** Wait for `seen`. A worker that ended, or twenty seconds gone, is a failure that says what there was. */
    const until = async (what: string, seen: () => boolean): Promise<void> => {
      const deadline = Date.now() + 20_000;
      while (!seen()) {
        if (ended !== undefined || Date.now() > deadline)
          throw new Error(`${what} did not happen.\n${account()}`);
        await new Promise((resolve) => setTimeout(resolve, 10));
      }
    };

    // Settling the job is an idle moment, and so the next claim.
    await until(
      "the worker's second claim",
      () =>
        channels().filter((channel) => channel === 'job:claim').length === 2,
    );
    expect(channels()).toEqual([
      'principal:profile',
      'job:claim',
      'job:start',
      'mark:commit',
      'job:complete',
      'job:claim',
    ]);
    const [profiled, claim, start, commit, complete] = standing.emitted.map(
      (emit) => emit.payload,
    );
    // Before it claims, it says it is called by its client id.
    expect(profiled).toEqual({ name: 'my-worker' });
    expect(claim).toEqual({
      accepts: [{ jobType: 'mark', params: { motivation: 'highlighting' } }],
    });
    // Every message of the lifecycle names the job and the attempt it is.
    const identity = {
      resourceId: 'res-1',
      jobId: 'job-1',
      jobType: 'mark',
      attempt: 1,
    };
    expect(start).toEqual(identity);

    // It commits the one highlight, for the job: of the sentence its stand-in model quoted, as the text has it, made by the agent it works as.
    expect([member(commit, 'resourceId'), member(commit, 'jobId')]).toEqual([
      'res-1',
      'job-1',
    ]);
    const batch = list(member(commit, 'annotations'));
    expect(batch).toHaveLength(1);
    const [highlight] = batch;
    expect(member(highlight, 'id')).toBe(
      member(member(stated, 'annotation'), 'id'),
    );
    expect(member(highlight, 'motivation')).toBe('highlighting');
    expect(member(highlight, 'target')).toEqual(
      member(member(stated, 'annotation'), 'target'),
    );
    expect(member(highlight, 'generator')).toEqual({
      '@type': 'Software',
      '@id': DID,
      provider: 'ollama',
      model: 'gemma3:4b',
    });
    // And it reports what it proposed and what the record holds, established by the record's acknowledgement.
    expect(complete).toEqual({
      ...identity,
      result: { found: 1, persisted: 1 },
      durability: 'acknowledged',
    });

    // It signed in as its account, by its key: the issuer's token is its bearer, and the gateway named it. Nothing is exchanged.
    const grants = standing.asked.filter(
      (request) =>
        `${request.method} ${request.path}` === 'POST /realms/xynolog/token',
    );
    expect(grants).toHaveLength(1);
    expect(
      proves(
        grants[0].body,
        admitted,
        `${standing.origin}/realms/xynolog/token`,
      ),
    ).toBe(true);
    const whoAmI = standing.asked.filter(
      (request) => request.path === '/api/users/me',
    );
    expect(
      whoAmI.map((request) => `${request.method} ${request.authorization}`),
    ).toEqual([`GET Bearer ${serviceToken}`]);
    expect(
      standing.asked.filter((request) =>
        request.path.startsWith('/api/tokens/'),
      ),
    ).toEqual([]);
    expect(new Set(standing.emitted.map((emit) => emit.authorization))).toEqual(
      new Set([`Bearer ${serviceToken}`]),
    );
    expect(said.out.split('\n')).toContain(`working as ${DID}`);
    // Its stream names what claiming and committing read, and nothing else.
    const [subscription] = standing.asked.filter(
      (request) => request.path === '/bus/subscribe',
    );
    const named: unknown = JSON.parse(subscription.body);
    expect([...list(member(named, 'global'))].sort()).toEqual(
      [...JOB_CLAIM_CHANNELS, ...JOB_COMMIT_CHANNELS].sort(),
    );

    // Told to stop while it holds nothing, it ends, and has failed nothing.
    running.kill('SIGTERM');
    const stopped = await new Promise<boolean>((resolve) => {
      const late = setTimeout(() => resolve(false), 20_000);
      void over.then(() => {
        clearTimeout(late);
        resolve(true);
      });
    });
    if (!stopped)
      throw new Error(
        `the worker did not end when it was told to.\n${account()}`,
      );
    expect(ended).toEqual({ code: 0, signal: null });
    expect(channels()).not.toContain('job:fail');
    for (const line of pem
      .split('\n')
      .filter((line) => line !== '' && !line.startsWith('-----'))) {
      expect(`${said.out}${said.err}`).not.toContain(line);
    }
  }, 60_000);
});

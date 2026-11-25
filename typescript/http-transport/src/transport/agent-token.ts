/**
 * An agent's sign-in at a knowledge base's gateway.
 *
 * An agent is an account, as a person is. It signs in at the knowledge
 * base's issuer with its own service-account credential (`ServiceToken`),
 * and the token its issuer grants is its bearer at the gateway. The gateway
 * names it by that account: its DID, which the gateway answers at
 * `GET /api/users/me`, is who its work is attributed to.
 * The engine it runs is no part of it: each write names that itself.
 *
 * The DID is the gateway's, under the knowledge base's own domain, and a
 * caller carries it verbatim. Re-derived from the URL the process happens to
 * dial, one agent has two DIDs.
 *
 * The token is renewed by a new grant at the issuer, as it expires and when
 * the gateway refuses it. Its DID does not change, so nothing renewed asks
 * the gateway again.
 */

import {
  HTTP_REQUEST_TIMEOUT_MS,
  UnansweredError,
  isObject,
  isString,
  jsonOf,
  retryAfterMs,
  userId,
  withinDeadline,
  gatewayHeaders,
  gatewayRoutes,
  type ServiceToken,
  type UserId,
} from '@xynolog/core';
import { APIError } from './api-error';
import { fetchOf } from './fetch-of';

export interface AgentSignIn {
  /** The gateway, e.g. `http://gateway:4000`: where the process dials, and nothing about who it is. */
  baseUrl: string;
  /** The token of the agent's account at the knowledge base's issuer, which asks the issuer with the `fetch` it was made with. */
  service: ServiceToken;
  /** What the gateway's request is sent with. Absent, the runtime's own `fetch`. */
  fetch?: typeof fetch;
}

/**
 * Sign the agent in as its account: the account's token, and the DID the
 * gateway names it by.
 *
 * One grant at the issuer and one request to the gateway, each bounded by
 * `httpRequestTimeoutMs` (protocol/specs/src/client/timing.json), and neither
 * made again. A sign-in that fails is the service's to start again: a starting
 * worker's patience for an issuer or a gateway still coming up is its own
 * backoff (protocol/contract/WORKER-SERVICE.md, R3), and a peer that exits
 * leaves it to its restart policy (protocol/contract/ARCHIVIST.md, Boot). The
 * gateway's refusal is thrown as an `APIError` carrying its status, the
 * issuer's as a `SignInError`, and a request that got no answer as an
 * `UnansweredError`.
 */
export async function agentToken(
  opts: AgentSignIn,
): Promise<{ token: string; did: UserId }> {
  const { baseUrl, service, fetch } = opts;
  const token = await service.token({ renewed: false });
  return { token, did: await named(baseUrl, token, fetch) };
}

/** The DID the gateway names the bearer of `token` by: `GET /api/users/me`. */
async function named(
  baseUrl: string,
  token: string,
  fetch: typeof globalThis.fetch | undefined,
): Promise<UserId> {
  const { method, path } = gatewayRoutes.getCurrentUser;
  const url = `${baseUrl.replace(/\/$/, '')}${path}`;
  const unanswered = (error: unknown) => new UnansweredError(url, error);
  const { response, answer } = await withinDeadline(
    HTTP_REQUEST_TIMEOUT_MS,
    async (signal) => {
      const response = await fetchOf(fetch)(url, {
        method,
        headers: { authorization: `Bearer ${token}` },
        signal,
      }).catch((error: unknown) => {
        throw unanswered(error);
      });
      return { response, answer: await jsonOf(response, unanswered) };
    },
  );

  if (!response.ok) {
    const said =
      isObject(answer) && isString(answer['error'])
        ? answer['error']
        : `HTTP ${response.status} ${response.statusText}`;
    throw APIError.fromStatus(
      `The gateway did not name the agent: ${said}`,
      response.status,
      response.statusText,
      answer,
      retryAfterMs(response.headers.get(gatewayHeaders.retryAfter)),
    );
  }
  if (!isObject(answer) || !isString(answer['did'])) {
    throw new Error(`${url} did not answer a DID`);
  }
  return userId(answer['did']);
}

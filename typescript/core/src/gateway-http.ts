// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/openapi.json and its paths
//              protocol/specs/src/session/ClientSecretForm.json
// Regenerate:  make generate  (codegen/lib/gateway_http/typescript.ml)

/** Each operation of the gateway, by its operationId: its method, its path (a `{name}` for each parameter, which the caller fills), and the media types it sends and answers with. */
export const gatewayRoutes = {
  getHealth: {
    method: 'GET',
    path: '/api/health',
    answers: 'application/json',
  },
  getHealthAtRoot: { method: 'GET', path: '/', answers: 'application/json' },
  getOpenApiDocument: {
    method: 'GET',
    path: '/api/openapi.json',
    answers: 'application/json',
  },
  getProtectedResourceMetadata: {
    method: 'GET',
    path: '/.well-known/oauth-protected-resource',
    answers: 'application/json',
  },
  createMediaToken: {
    method: 'POST',
    path: '/api/tokens/media',
    sends: 'application/json',
    answers: 'application/json',
  },
  getCurrentUser: {
    method: 'GET',
    path: '/api/users/me',
    answers: 'application/json',
  },
  getStatus: {
    method: 'GET',
    path: '/api/status',
    answers: 'application/json',
  },
  subscribeToBus: {
    method: 'POST',
    path: '/bus/subscribe',
    sends: 'application/json',
    answers: 'text/event-stream',
  },
  emitOnBus: {
    method: 'POST',
    path: '/bus/emit',
    sends: 'application/json',
    answers: 'application/json',
  },
  uploadResource: {
    method: 'POST',
    path: '/resources',
    sends: 'multipart/form-data',
    answers: 'application/json',
  },
  getResourceRepresentation: {
    method: 'GET',
    path: '/resources/{id}',
    answers: '*/*',
  },
  getResourceJsonLd: {
    method: 'GET',
    path: '/resources/{id}/jsonld',
    answers: 'application/ld+json',
  },
  getResourceAnnotations: {
    method: 'GET',
    path: '/resources/{id}/annotations',
    answers: 'application/json',
  },
  getResourceAnchoredText: {
    method: 'GET',
    path: '/resources/{id}/anchored-text',
    answers: 'application/json',
  },
  getResourceRepresentationWithMediaToken: {
    method: 'GET',
    path: '/api/resources/{id}',
    answers: '*/*',
  },
} as const;

/** Each header the gateway's operations name, asked or answered. */
export const gatewayHeaders = {
  cacheControl: 'Cache-Control',
  idempotencyKey: 'Idempotency-Key',
  link: 'Link',
  retryAfter: 'Retry-After',
  wwwAuthenticate: 'WWW-Authenticate',
} as const;

/** Each credential the gateway takes as a key, by its security scheme: where it goes, and its name there. */
export const gatewayApiKeys = {
  mediaToken: { in: 'query', name: 'token' },
} as const;

/** The form a service account posts with a client secret. */
export type ClientSecretForm = {
  grant_type: 'client_credentials';
  client_id: string;
  client_secret: string;
};

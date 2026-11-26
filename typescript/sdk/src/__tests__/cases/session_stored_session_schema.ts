// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/StoredSession.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  $schema: 'https://json-schema.org/draft/2020-12/schema',
  $id: 'https://xynolog.org/protocol/StoredSession.json',
  title: 'StoredSession',
  type: 'object',
  description:
    "What is kept of a sign-in: the tokens an issuer issued, the client they were issued to, and the issuer's endpoints a renewal and a sign-out need, learned once at sign-in so no session asks again. TOKENS, never a password. A stored value that lacks a member it requires is no session.",
  properties: {
    access: {
      $ref: 'https://xynolog.org/protocol/AccessToken.json',
      description: 'The access token: short-lived, sent as a Bearer token.',
    },
    refresh: {
      type: 'string',
      description:
        'The refresh token: what renews the access token at the issuer without another sign-in.',
    },
    clientId: {
      type: 'string',
      description:
        'The client the tokens were issued to, which a renewal and a revocation name.',
    },
    tokenEndpoint: {
      type: 'string',
      description:
        "The issuer's token endpoint, where the refresh grant is made.",
    },
    revocationEndpoint: {
      type: 'string',
      description:
        "The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none.",
    },
    personKey: {
      type: 'string',
      description:
        "Who the gateway said the sign-in's person is, as the key their caches and stream position are kept under (`lastEventIdKeyPrefix`), never the did itself. Written once the gateway names the person, on the sign-in whose token it was asked about; a renewal keeps it, a new sign-in starts without it, and forgetting the sign-in, however it is forgotten, reads it first to delete what is kept under it. Absent for a sign-in whose gateway has not yet named its person.",
    },
  },
  required: ['access', 'refresh', 'clientId', 'tokenEndpoint'],
} as const;

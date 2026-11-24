// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/client-assertion-cases.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export type Jwk = {
  kty: string;
  n: string;
  e: string;
};

export type ThumbprintsItem = {
  why: string;
  jwk: Jwk;
  thumbprint: string;
};

export type Header = {
  alg: string;
  kid: string;
};

export type Claims = {
  iss: string;
  sub: string;
  aud: string;
  jti: string;
  iat: number;
  exp: number;
};

export type CasesItem = {
  why: string;
  jwk: Jwk;
  clientId: string;
  tokenEndpoint: string;
  issuedAt: number;
  jti: string;
  header: Header;
  claims: Claims;
};

export type Table = {
  $comment: string;
  form: string[];
  grantType: 'client_credentials';
  assertionType: string;
  lifetimeSeconds: number;
  thumbprints: ThumbprintsItem[];
  cases: CasesItem[];
};

export const table: Table = {
  "$comment": "How a service account proves itself with a key instead of a secret: OpenID Connect's private_key_jwt, the client assertion of RFC 7523 §2.2. The account holds an RSA private key; its issuer holds the public half, registered on the account's client. For each client-credentials grant the account signs a fresh JWT with RS256: its header names the key by its JWK thumbprint (RFC 7638: the SHA-256 of the key's required members `e`, `kty` and `n`, in that order, with no whitespace, base64url without padding), and its claims are `iss` and `sub` the client id, `aud` the issuer's token endpoint, `jti` a value never sent twice, `iat` when it is made and `exp` `lifetimeSeconds` after. The grant posts the form's fields and no others: the client id is the assertion's `sub`, and no secret is sent. A JSON object here is compared as JSON, member order aside. Every implementation that signs such an assertion runs every case.",
  "form": [
    "grant_type",
    "client_assertion_type",
    "client_assertion"
  ],
  "grantType": "client_credentials",
  "assertionType": "urn:ietf:params:oauth:client-assertion-type:jwt-bearer",
  "lifetimeSeconds": 60,
  "thumbprints": [
    {
      "why": "RFC 7638 §3.1's own example key and thumbprint",
      "jwk": {
        "kty": "RSA",
        "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw",
        "e": "AQAB"
      },
      "thumbprint": "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs"
    }
  ],
  "cases": [
    {
      "why": "a worker's assertion at a launcher-run Keycloak, its key RFC 7638's example",
      "jwk": {
        "kty": "RSA",
        "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw",
        "e": "AQAB"
      },
      "clientId": "xynolog-worker-alice-laptop",
      "tokenEndpoint": "http://localhost:8080/realms/xynolog/protocol/openid-connect/token",
      "issuedAt": 1798761600,
      "jti": "6f1d3c2a9b8e4f70a5d2c1b0e9f8a7d6",
      "header": {
        "alg": "RS256",
        "kid": "NzbLsXh8uDCcd-6MNwXF4W_7noWXFZAfHkxZsRGC9Xs"
      },
      "claims": {
        "iss": "xynolog-worker-alice-laptop",
        "sub": "xynolog-worker-alice-laptop",
        "aud": "http://localhost:8080/realms/xynolog/protocol/openid-connect/token",
        "jti": "6f1d3c2a9b8e4f70a5d2c1b0e9f8a7d6",
        "iat": 1798761600,
        "exp": 1798761660
      }
    }
  ]
};

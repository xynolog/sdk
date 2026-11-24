// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/retry/rules.json
// Regenerate:  make generate  (codegen/lib/typescript_types/table_modules.ml)

import type { tables } from './types';

/** protocol/specs/src/retry/rules.json, as `RetryRules` types it. */
export const RETRY_RULES: tables['RetryRules'] = {
  $comment:
    "What each retry rule retries, as sets: retry/cases.json's rows are examples of them, and its `$comment` says what each rule is for. `boot` and `job` are asked only about a status, and retry one of `statuses` or, for `job`, one at or above `statusFrom`. `transport` retries one of `statuses` when the request carries an `Idempotency-Key` or its method is one of `idempotentMethods`, and nothing with no status: a request whose connection failed is the transport's to send again, not this rule's (contract/TRANSPORT-CONTRACT.md). `refresh` retries one of `statuses`, one at or above `statusFrom`, and, as `noResponse` says, an exchange the issuer did not answer. No rule retries 401: a refused credential is renewed before any rule is asked.",
  boot: {
    statuses: [429, 503, 504],
  },
  job: {
    statuses: [408, 429],
    statusFrom: 500,
  },
  transport: {
    statuses: [408, 413, 429, 500, 502, 503, 504],
    idempotentMethods: ['GET', 'HEAD', 'PUT', 'DELETE', 'OPTIONS', 'TRACE'],
  },
  refresh: {
    statuses: [408, 429],
    statusFrom: 500,
    noResponse: true,
  },
};

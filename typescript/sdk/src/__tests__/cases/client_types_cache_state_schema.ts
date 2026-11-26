// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/CacheState.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  $schema: 'https://json-schema.org/draft/2020-12/schema',
  $id: 'https://xynolog.org/protocol/CacheState.json',
  title: 'CacheState',
  description:
    "Where a live query's key stands, told apart by `status`, CacheStatus's (contract/CACHE-SEMANTICS.md): pending, with no value yet; ready, with its value, a V; or failed, with the SDK's error. A V is what the query holds, the cache's.",
  'x-xynolog-typeParameters': ['V'],
  oneOf: [
    {
      type: 'object',
      description: 'No value yet.',
      properties: {
        status: {
          type: 'string',
          enum: ['pending'],
        },
      },
      required: ['status'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description: 'The key holds a value.',
      properties: {
        status: {
          type: 'string',
          enum: ['ready'],
        },
        value: {
          'x-xynolog-typeParameter': 'V',
          description: 'The value the key holds.',
        },
      },
      required: ['status', 'value'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description: 'The key holds no value, and its fetch failed.',
      properties: {
        status: {
          type: 'string',
          enum: ['failed'],
        },
        error: {
          $comment: "The failure: the SDK's own error, which no schema states.",
        },
      },
      required: ['status', 'error'],
      additionalProperties: false,
    },
  ],
} as const;

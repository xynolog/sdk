// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/SearchState.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  $schema: 'https://json-schema.org/draft/2020-12/schema',
  $id: 'https://xynolog.org/protocol/SearchState.json',
  title: 'SearchState',
  type: 'object',
  description:
    "A search pipeline's state: the results of the last query answered, and whether a query is still on its way. What a result is, is the search's source's.",
  properties: {
    results: {
      type: 'array',
      description:
        "The last answered query's results, as its source gives them.",
    },
    isSearching: {
      type: 'boolean',
      description: 'Whether a query is on its way.',
    },
  },
  required: ['results', 'isSearching'],
  additionalProperties: false,
} as const;

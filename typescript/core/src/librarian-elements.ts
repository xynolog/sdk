// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/librarian/elements
// Regenerate:  make generate  (codegen/lib/typescript_types/table_modules.ml)

/** protocol/specs/src/librarian/elements/LibrarianPromptScore.json: the JSON Schema of an element the Librarian asks a model for, as it is sent. */
export const LIBRARIAN_PROMPT_SCORE_SCHEMA = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/LibrarianPromptScore.json",
  "type": "object",
  "properties": {
    "candidate": {
      "type": "number"
    },
    "score": {
      "type": "number"
    }
  },
  "required": [
    "candidate",
    "score"
  ],
  "additionalProperties": false
} as const;

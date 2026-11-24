// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/components/schemas/ListResourcesResponse.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/ListResourcesResponse.json",
  "type": "object",
  "properties": {
    "resources": {
      "type": "array",
      "items": {
        "$ref": "https://xynolog.org/protocol/ResourceDescriptor.json"
      }
    },
    "total": {
      "type": "number"
    },
    "offset": {
      "type": "number"
    },
    "limit": {
      "type": "number"
    }
  },
  "required": [
    "resources",
    "total",
    "offset",
    "limit"
  ]
} as const;

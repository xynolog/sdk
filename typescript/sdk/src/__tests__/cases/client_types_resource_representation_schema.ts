// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/ResourceRepresentation.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/ResourceRepresentation.json",
  "title": "ResourceRepresentation",
  "type": "object",
  "additionalProperties": false,
  "description": "A resource's bytes as the content transport answers them, whole, with the media type it answered with.",
  "properties": {
    "data": {
      "type": "string",
      "format": "binary",
      "description": "The bytes, whole."
    },
    "contentType": {
      "type": "string",
      "minLength": 1,
      "description": "The media type the content transport answered with."
    }
  },
  "required": [
    "data",
    "contentType"
  ]
} as const;

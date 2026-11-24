// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/ResourceRepresentationStream.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/ResourceRepresentationStream.json",
  "title": "ResourceRepresentationStream",
  "type": "object",
  "additionalProperties": false,
  "description": "A resource's bytes as the content transport answers them, read as they arrive, with the media type it answered with.",
  "properties": {
    "stream": {
      "type": "string",
      "format": "binary",
      "description": "The bytes, in order, as they arrive: read once."
    },
    "contentType": {
      "$ref": "https://xynolog.org/protocol/ResourceRepresentation.json#/properties/contentType"
    }
  },
  "required": [
    "stream",
    "contentType"
  ]
} as const;

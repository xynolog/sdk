// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/components/schemas/BrowseResourcesRequest.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/BrowseResourcesRequest.json",
  "type": "object",
  "description": "Request to browse resources with optional filtering and pagination",
  "properties": {
    "archived": {
      "type": "boolean"
    },
    "entityType": {
      "type": "string"
    },
    "offset": {
      "type": "integer",
      "minimum": 0,
      "description": "How many of the resources the filters admit are passed over before the page begins."
    },
    "limit": {
      "type": "integer",
      "minimum": 1,
      "description": "The most resources a page has."
    }
  }
} as const;

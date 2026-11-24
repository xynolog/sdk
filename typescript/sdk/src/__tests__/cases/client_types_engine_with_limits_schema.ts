// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/EngineWithLimits.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/EngineWithLimits.json",
  "title": "EngineWithLimits",
  "type": "object",
  "additionalProperties": false,
  "description": "One of the knowledge base's engines as a client joins it: the entry `browse:engines-result` names, with the inference limits the service holding its credentials reported. A client asks each such service for its limits; an engine no service reported has no `limits`.",
  "properties": {
    "engine": {
      "$ref": "https://xynolog.org/protocol/EngineEntry.json#/properties/engine"
    },
    "jobs": {
      "$ref": "https://xynolog.org/protocol/EngineEntry.json#/properties/jobs"
    },
    "limits": {
      "$ref": "https://xynolog.org/protocol/InferenceLimits.json"
    }
  },
  "required": [
    "engine"
  ]
} as const;

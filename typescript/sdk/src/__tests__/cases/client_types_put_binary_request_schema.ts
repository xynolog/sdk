// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/PutBinaryRequest.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://xynolog.org/protocol/PutBinaryRequest.json",
  "title": "PutBinaryRequest",
  "type": "object",
  "additionalProperties": false,
  "description": "What uploading a resource is handed: its bytes, what the upload states of them, and, for a clone, its token. Each member is as a caller holds it; ResourceUpload is the multipart body the content transport sends of it.",
  "properties": {
    "name": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/name"
    },
    "file": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/file"
    },
    "format": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/format"
    },
    "storageUri": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/storageUri"
    },
    "language": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/language"
    },
    "entityTypes": {
      "$ref": "https://xynolog.org/protocol/YieldCreateCommand.json#/properties/entityTypes"
    },
    "sourceAnnotationId": {
      "$ref": "https://xynolog.org/protocol/AnnotationId.json"
    },
    "sourceResourceId": {
      "$ref": "https://xynolog.org/protocol/ResourceId.json"
    },
    "generationPrompt": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/generationPrompt"
    },
    "generator": {
      "$ref": "https://xynolog.org/protocol/YieldCreateCommand.json#/properties/generator"
    },
    "jobId": {
      "$ref": "https://xynolog.org/protocol/JobId.json"
    },
    "isDraft": {
      "$ref": "https://xynolog.org/protocol/YieldCreateCommand.json#/properties/isDraft"
    },
    "cloneToken": {
      "$ref": "https://xynolog.org/protocol/ResourceUpload.json#/properties/cloneToken"
    },
    "archiveOriginal": {
      "$ref": "https://xynolog.org/protocol/YieldCloneCreateCommand.json#/properties/archiveOriginal"
    }
  },
  "required": [
    "name",
    "file",
    "format",
    "storageUri"
  ]
} as const;

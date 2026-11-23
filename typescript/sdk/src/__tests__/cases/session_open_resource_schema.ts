// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/session/OpenResource.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  $schema: 'https://json-schema.org/draft/2020-12/schema',
  $id: 'https://xynolog.org/protocol/OpenResource.json',
  title: 'OpenResource',
  type: 'object',
  description:
    'A resource open in a knowledge base: which resource, the name it is shown by, when it was opened and its place among the others open there. A registry shows them by their places, and two in one place by when each was opened, first first.',
  properties: {
    id: {
      $ref: 'https://xynolog.org/protocol/ResourceId.json',
      description: 'The resource.',
    },
    name: {
      type: 'string',
      description: 'The name the resource is shown by.',
    },
    openedAt: {
      type: 'integer',
      minimum: 0,
      description:
        'When the resource was opened, in milliseconds since the Unix epoch. Opening it again while it is open changes neither this nor its place.',
    },
    order: {
      type: 'integer',
      minimum: 0,
      description:
        "The resource's place among those open in the knowledge base. One opened is given the place after the last taken, so a place freed by closing one is not given twice; a move gives each its place in the new order, counted from 0.",
    },
    mediaType: {
      type: 'string',
      description:
        "The resource's media type, which its icon is chosen by. Absent when it is not known.",
    },
    storageUri: {
      type: 'string',
      description:
        "Where the resource is in the knowledge base's working tree, as a URI (file://docs/overview.md). Absent when it is not known.",
    },
  },
  required: ['id', 'name', 'openedAt', 'order'],
} as const;

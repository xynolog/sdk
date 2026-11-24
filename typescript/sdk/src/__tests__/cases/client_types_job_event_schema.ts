// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/types/JobEvent.json
// Regenerate:  make generate  (codegen/lib/case_data/typescript.ml)

export const schema = {
  $schema: 'https://json-schema.org/draft/2020-12/schema',
  $id: 'https://xynolog.org/protocol/JobEvent.json',
  title: 'JobEvent',
  description:
    "What a delegation reports as its job goes, told apart by `kind`: the queue's naming of the job first, its progress, and last, its failure, a frame refused, or its completion. Each operation that delegates completes with its own verb's completion, a branch of JobCompleteCommand.",
  oneOf: [
    {
      type: 'object',
      description: 'The queue took the job.',
      properties: {
        kind: {
          type: 'string',
          enum: ['created'],
        },
        data: {
          $ref: 'https://xynolog.org/protocol/JobCreatedResultResponse.json',
        },
      },
      required: ['kind', 'data'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description: "The job's progress.",
      properties: {
        kind: {
          type: 'string',
          enum: ['progress'],
        },
        data: {
          $ref: 'https://xynolog.org/protocol/JobProgress.json',
        },
      },
      required: ['kind', 'data'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description: 'The job failed.',
      properties: {
        kind: {
          type: 'string',
          enum: ['failed'],
        },
        data: {
          $ref: 'https://xynolog.org/protocol/JobFailCommand.json',
        },
      },
      required: ['kind', 'data'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description:
        "A frame of the job's was refused: its channel, the member at fault, and why.",
      properties: {
        kind: {
          type: 'string',
          enum: ['refused'],
        },
        data: {
          type: 'object',
          properties: {
            channel: {
              type: 'string',
              description: 'The channel the frame came on.',
            },
            member: {
              type: 'string',
              description:
                'The member at fault, named by its way from the frame.',
            },
            reason: {
              $ref: 'https://xynolog.org/protocol/FrameRefusalReason.json',
            },
          },
          required: ['channel', 'member', 'reason'],
          additionalProperties: false,
        },
      },
      required: ['kind', 'data'],
      additionalProperties: false,
    },
    {
      type: 'object',
      description: 'The job completed.',
      properties: {
        kind: {
          type: 'string',
          enum: ['complete'],
        },
        data: {
          $ref: 'https://xynolog.org/protocol/JobCompleteCommand.json',
        },
      },
      required: ['kind', 'data'],
      additionalProperties: false,
    },
  ],
  discriminator: {
    propertyName: 'kind',
  },
} as const;

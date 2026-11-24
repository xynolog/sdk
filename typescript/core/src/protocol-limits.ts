// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/openapi.json and the files it names
// Regenerate:  make generate  (codegen/lib/limits/limits.ml)

/** Each operation's `x-xynolog-limits`, by `METHOD path`. */
export const operationLimits = {
  "POST /api/tokens/media": {
    "maxBodyBytes": 1048576
  },
  "POST /bus/subscribe": {
    "maxBodyBytes": 1048576,
    "heartbeatSeconds": 15,
    "replyRetentionSeconds": 60,
    "pendingWriteBytes": 16777216,
    "replayBufferEvents": 1000,
    "streamsPerPrincipal": {
      "baseline": 64,
      "roles": {
        "xynolog-service": "unlimited",
        "xynolog-worker": "unlimited"
      }
    },
    "streamLeaseSeconds": 30
  },
  "POST /bus/emit": {
    "maxBodyBytes": 4194304,
    "claimSeconds": 900,
    "idempotencySeconds": 600,
    "emitsPerPrincipal": {
      "baseline": {
        "perSecond": 100,
        "burst": 500
      },
      "roles": {
        "xynolog-service": "unlimited",
        "xynolog-worker": "unlimited"
      }
    }
  }
} as const;

/** Each schema property's `maxItems`, by `Schema.property`. */
export const itemLimits = {
  "BrowseProfilesRequest.dids": 500,
  "BusSubscribeRequest.pendingReplies": 256,
  "BusSubscribeRequest.scoped": 512
} as const;

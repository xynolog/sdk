// Code generated from protocol/specs/src/client/surface.json and bus/registry.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/worker_channels/go.ml)

package xynolog

import "github.com/xynolog/sdk/go/bus"

// JobClaimChannels is the replies of job:claim, then job:queued and
// job:cancel-requested.
var JobClaimChannels = []bus.Channel{
	"job:claimed",
	"job:claim-failed",
	"job:queued",
	"job:cancel-requested",
}

// JobCommitChannels is the replies of mark:commit and
// browse:annotation-requested.
var JobCommitChannels = []bus.Channel{
	"mark:commit-ok",
	"mark:commit-failed",
	"browse:annotation-result",
	"browse:annotation-failed",
}

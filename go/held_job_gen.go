// Code generated from protocol/specs/src/client/surface.json and its client types; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/held_job/go.ml)

package xynolog

import (
	"maps"
	"slices"

	"github.com/xynolog/sdk/go/api"
)

// HeldJobRecordMembers is the members of a held job that are its
// HeldJobRecord's: each is the property of its name.
type HeldJobRecordMembers interface {
	JobId() api.JobId
	JobType() api.JobType
	ResourceId() api.ResourceId
	Params() api.JobParams
	// CompletedUnits The units a worker has finished, merged across checkpoints
	// and failures as a set.
	CompletedUnits() []string
	// UnitCursors The furthest each unit begun got, keyed by unit, with what it
	// had counted there. A finished unit keeps its cursor: where it ended, and
	// its final counts.
	UnitCursors() map[string]api.UnitCursor
	RetryCount() int
	// MaxRetries How many transient failures the queue retries: 0 for
	// generation, whose re-run produces different content; 1 for every other
	// type.
	MaxRetries() int
}

func (h *heldJob) JobId() api.JobId                       { return h.record.JobId }
func (h *heldJob) JobType() api.JobType                   { return h.record.JobType }
func (h *heldJob) ResourceId() api.ResourceId             { return h.record.ResourceId }
func (h *heldJob) Params() api.JobParams                  { return h.record.Params }
func (h *heldJob) CompletedUnits() []string               { return slices.Clone(h.record.CompletedUnits) }
func (h *heldJob) UnitCursors() map[string]api.UnitCursor { return maps.Clone(h.record.UnitCursors) }
func (h *heldJob) RetryCount() int                        { return h.record.RetryCount }
func (h *heldJob) MaxRetries() int                        { return h.record.MaxRetries }

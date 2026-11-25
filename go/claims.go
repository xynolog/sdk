package xynolog

// A worker's side of the job queue: Job.Claim.
//
// A worker is any party that takes jobs and says how each one went. What it
// promises the dispatcher, and everyone who follows a job, is
// protocol/contract/WORKER-CONTRACT.md; this file is that contract for Go, and the
// worker conformance suite (protocol/conformance/worker) holds it on the wire.
//
// THE MODEL. A worker asks the queue at every moment it becomes idle, and
// never otherwise. job:claim carries the jobs it takes; the dispatcher answers
// with the next pending job that matches one of them, or declines. Queue state
// is the truth, and no message carries correctness. The idle moments:
//
//   - its claims are first ranged over, once the stream is open;
//   - it settles the job it holds, immediately, with no timer;
//   - a matching job:queued arrives while it holds nothing, or one its
//     transport refused, which no claim's question can be asked of;
//   - the stream opens again: every change to open after the first.
//
// job:queued is a WAKE-UP with no memory. While the worker holds nothing it
// causes a claim; while a claim is in flight it sets a bit that earns exactly
// one more claim, so a wake-up cannot be lost in that window; while a job is
// held it is ignored, because the settle claims. The check of a wake-up is a
// PRE-FILTER: an announcement carries the job description less its input, so
// the worker asks its own claim's question of it (JobMatchesFilter), the
// comparison the dispatcher makes, and does not spend a round trip to be
// declined.
//
// A HELD JOB owns its lifecycle. It says its own start, progress and
// checkpoints, and it settles once: Complete, Fail and Cancel each say the
// outcome and release the job in one call, and a second is refused.
//
// A HELD JOB COMMITS FOR ITSELF. Commit sends a batch of annotations to the
// record, citing the job, and returns once the batch is established: the
// record acknowledged it, or, when no acknowledgement came, answered that the
// batch's last annotation is on the resource. The job remembers the weakest of
// what its commits observed and states it when it settles, so a worker says
// neither which job a batch is for nor how its commits went.
//
// EACH JOB HAS A TRACE OF ITS OWN (WORKER-CONTRACT T1). A claim is made in no
// trace: the claiming runs as the client's, never in the context of the code
// that settled the job before it. A held job states the trace its reply
// arrived in (Trace), and a message it sends under a context in no trace is
// sent in that one; a worker's span for the job continues it with
// Continuing(ctx, job.Trace()).
//
//	claims := client.Job.Claim(api.ClaimOptions{Accepts: accepts})
//	defer claims.Close()
//	for job, err := range claims.All() {
//		var refused *api.ClaimRefusal
//		if errors.As(err, &refused) {
//			continue // the host judges: bus.unauthorized means stop
//		}
//		...
//		job.Start(ctx)
//		switch held := job.(type) {
//		case *xynolog.HeldMarkJob:
//			held.Complete(ctx, result)
//		}
//	}
//
// Closed, the claims stop, and a job still held then is failed first. Go tells
// nobody when a value is let go of, so a job that is neither settled nor held
// when its claims close stays with the dispatcher until its worker stops.

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"iter"
	"maps"
	"reflect"
	"slices"
	"strings"
	"sync"
	"time"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/internal/kept"
)

// stoppedWhileHeld is the error of a job failed because its worker stopped,
// and not because the work failed.
const stoppedWhileHeld = "The worker stopped while it held the job"

// retriedClasses is whether the queue runs a failure of each class again
// while its job has retries left. A failure known to be deterministic is not:
// the same request cannot succeed on a second attempt. Neither is an answer
// the provider withheld: it withholds its answer to the same request again.
// Every class the spec names is here, and a test holds the list to the spec.
var retriedClasses = map[api.FailureClass]bool{
	api.FailureClassTransient:     true,
	api.FailureClassDeterministic: false,
	api.FailureClassWithheld:      false,
}

// WillRetryAfter is whether a failed attempt is retried: exactly when the
// failure's class is one the queue retries and the job has retries left, on
// the record before the failure is applied. A failure of no stated class
// (nil) is retried as a transient one is. Two places need the answer and they
// must never disagree: the dispatcher's queue acts on it, and a worker
// reports it on job:fail as willRetry. protocol/specs/src/jobs/retry-cases.json is the
// table every implementation answers alike.
func WillRetryAfter(retryCount, maxRetries int, failureClass *api.FailureClass) bool {
	retried := true
	if failureClass != nil {
		retried = retriedClasses[*failureClass]
	}
	return retried && retryCount < maxRetries
}

// weakness is how weak an observation of a commit is, as evidence that the
// batch is on the record. The two a commit is not established by are equally
// weak: one says the record answered that the annotation is not there, the
// other that nobody answered, and neither says more than the other. Every
// evidence the spec names is here, and a test holds the list to the spec.
var weakness = map[api.DurabilityEvidence]int{
	api.DurabilityEvidenceAcknowledged:     0,
	api.DurabilityEvidenceProbeConfirmed:   1,
	api.DurabilityEvidenceProbeRefused:     2,
	api.DurabilityEvidenceProbeUnreachable: 2,
}

// JobMatchesFilter is whether job matches filter, both as the wire carries
// them (decoded JSON): a filter as a claim states it, and a job description
// as it is announced or held, with its jobType and its params. A filter is a
// partial job description: a job matches when every field the filter states
// equals the job's at the same path, and what the filter leaves out is not
// compared. protocol/specs/src/jobs/filter-cases.json holds every implementation to
// one answer.
func JobMatchesFilter(filter, job any) bool {
	stated, ok := filter.(map[string]any)
	if !ok {
		return false
	}
	return states(stated, job)
}

// states is whether actual states everything stated does, at the same paths.
func states(stated, actual any) bool {
	if object, ok := stated.(map[string]any); ok {
		held, ok := actual.(map[string]any)
		if !ok {
			return false
		}
		for name, value := range object {
			present, has := held[name]
			if !has || !states(value, present) {
				return false
			}
		}
		return true
	}
	// A number is the number it is, however it was written: decoded, 1 and
	// 1.0 are one float64, and neither is true.
	return reflect.DeepEqual(stated, actual)
}

// ending is a Watched read until over is done, after which it changes no
// more.
type ending[T comparable] struct {
	watched *Variable[T]
	over    context.Context
}

func (e ending[T]) Value() T { return e.watched.Value() }

func (e ending[T]) Changes(ctx context.Context) iter.Seq[T] {
	return func(yield func(T) bool) {
		inner, cancel := context.WithCancel(ctx)
		defer cancel()
		stop := context.AfterFunc(e.over, cancel)
		defer stop()
		for value := range e.watched.Changes(inner) {
			if !yield(value) {
				return
			}
		}
	}
}

// HeldJob is a job this worker holds, as its verb's: a *HeldMarkJob or a
// *HeldYieldJob. A completion is its verb's, so a type switch reads which
// before Complete is called; every other member is the same for both.
type HeldJob interface {
	// Each member of the job as its claim handed it. CompletedUnits and
	// UnitCursors are empty on a first attempt.
	HeldJobRecordMembers
	// Record is the job as its claim handed it.
	Record() api.HeldJobRecord
	// Attempt is which attempt this is, 1-based. Every lifecycle message
	// states it.
	Attempt() int
	// AnnotationId is the annotation the job is anchored to: the one a yield
	// job's context is focused on. The zero AnnotationId for a job anchored
	// to none.
	AnnotationId() api.AnnotationId
	// Trace is the trace the job is run in: the one its reply arrived in;
	// nil for a reply that arrived in none.
	Trace() *api.TraceCarrier
	// Cancelled is whether a cancellation has named this job: the answer
	// now, and the change to it, until the job is settled. The work stops
	// where it can, and the worker says Cancel.
	Cancelled() Watched[bool]
	// Settled is whether the job has been settled: completed, failed or
	// cancelled.
	Settled() bool
	// Start says job:start: the job's first message, said once.
	Start(ctx context.Context) error
	// Progress says job:report-progress. It counts as activity.
	Progress(ctx context.Context, progress api.JobProgress) error
	// Checkpoint says job:checkpoint: what a later attempt resumes from. It
	// counts as activity.
	Checkpoint(ctx context.Context, checkpoint api.JobCheckpoint) error
	// Commit says mark:commit for this job, and returns once the batch is
	// established.
	Commit(ctx context.Context, resourceID api.ResourceId, annotations []api.Annotation) error
	// Fail settles the job: job:fail.
	Fail(ctx context.Context, message string, failure api.JobFailure) error
	// Cancel settles the job: job:cancel.
	Cancel(ctx context.Context, reached api.JobReached) error

	held() *heldJob
}

var (
	_ HeldJob = (*HeldMarkJob)(nil)
	_ HeldJob = (*HeldYieldJob)(nil)
)

// heldJob is what a held job is, whatever its verb.
type heldJob struct {
	claims       *Claims
	trace        *api.TraceCarrier
	record       api.HeldJobRecord
	annotationID api.AnnotationId
	cancelled    *Variable[bool]
	// over is done once the job is settled: nothing about it changes after.
	over context.Context
	end  context.CancelFunc

	mu      sync.Mutex
	begun   bool
	settled bool
	// durability is the weakest of what this job's commits observed, across
	// every batch and every resource it committed on: the strongest thing
	// still true of the job as a whole. Nil until a batch is committed, and
	// never a default: a job that commits nothing states nothing.
	durability *api.DurabilityEvidence
}

func (h *heldJob) held() *heldJob { return h }

func (h *heldJob) Attempt() int                   { return h.record.RetryCount + 1 }
func (h *heldJob) AnnotationId() api.AnnotationId { return h.annotationID }
func (h *heldJob) Trace() *api.TraceCarrier       { return h.trace }

func (h *heldJob) Record() api.HeldJobRecord {
	record := h.record
	record.CompletedUnits = slices.Clone(h.record.CompletedUnits)
	record.UnitCursors = maps.Clone(h.record.UnitCursors)
	return record
}

func (h *heldJob) Cancelled() Watched[bool] { return ending[bool]{h.cancelled, h.over} }

func (h *heldJob) Settled() bool {
	h.mu.Lock()
	defer h.mu.Unlock()
	return h.settled
}

// attempt is Attempt, as a lifecycle message states it.
func (h *heldJob) attempt() *int {
	attempt := h.Attempt()
	return &attempt
}

// anchor is AnnotationId, as a message states it: nil for a job anchored to
// none.
func (h *heldJob) anchor() *api.AnnotationId {
	if h.annotationID.IsZero() {
		return nil
	}
	anchored := h.annotationID
	return &anchored
}

// inTrace is ctx, in the job's trace when ctx is in none.
func (h *heldJob) inTrace(ctx context.Context) context.Context {
	if activeTrace(ctx) == nil {
		return Continuing(ctx, h.trace)
	}
	return ctx
}

// unsettled refuses a message of a job that is settled.
func (h *heldJob) unsettled(saying bus.Channel) error {
	if h.settled {
		return fmt.Errorf("Job %s is already settled: it cannot say %s", h.record.JobId, saying)
	}
	return nil
}

// going marks the job as having said more than its start, and refuses a job
// that is settled.
func (h *heldJob) going(saying bus.Channel) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if err := h.unsettled(saying); err != nil {
		return err
	}
	h.begun = true
	return nil
}

// settling settles the job from the moment it is asked to be, so a second
// settle is refused while the first is on its way.
func (h *heldJob) settling(saying bus.Channel) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if err := h.unsettled(saying); err != nil {
		return err
	}
	h.settled = true
	return nil
}

// released is the job, settled and no longer held: whether it was completed.
func (h *heldJob) released(completed bool) {
	// Settled: no cancellation will be signalled to it now, and whoever
	// watches for one is told so.
	h.end()
	h.claims.released(h, completed)
}

// say sends one of a held job's messages over the wire.
func say[P any](ctx context.Context, h *heldJob, c bus.Emittable[P], payload P) error {
	_, _, err := Emit(h.inTrace(ctx), h.claims.links.wire, c, payload, Envelope{})
	return err
}

func (h *heldJob) Start(ctx context.Context) error {
	saying := bus.JobStart.Channel()
	h.mu.Lock()
	if err := h.unsettled(saying); err != nil {
		h.mu.Unlock()
		return err
	}
	if h.begun {
		h.mu.Unlock()
		return fmt.Errorf("job:start is a held job's first message, said once: job %s has already said more", h.record.JobId)
	}
	h.begun = true
	h.mu.Unlock()
	return say(ctx, h, bus.JobStart, api.JobStartCommand{
		ResourceId: h.record.ResourceId, JobId: h.record.JobId, JobType: h.record.JobType, Attempt: h.attempt(), AnnotationId: h.anchor(),
	})
}

func (h *heldJob) Progress(ctx context.Context, progress api.JobProgress) error {
	if err := h.going(bus.JobReportProgress.Channel()); err != nil {
		return err
	}
	h.claims.active()
	if anchor := h.anchor(); anchor != nil {
		progress.AnnotationId = anchor
	}
	return say(ctx, h, bus.JobReportProgress, api.JobReportProgressCommand{
		ResourceId: h.record.ResourceId, JobId: h.record.JobId, JobType: h.record.JobType, Attempt: h.attempt(), AnnotationId: h.anchor(),
		Percentage: progress.Percentage, Progress: &progress,
	})
}

func (h *heldJob) Checkpoint(ctx context.Context, checkpoint api.JobCheckpoint) error {
	if err := h.going(bus.JobCheckpoint.Channel()); err != nil {
		return err
	}
	h.claims.active()
	return say(ctx, h, bus.JobCheckpoint, api.JobCheckpointCommand{
		JobId: h.record.JobId, CompletedUnits: checkpoint.CompletedUnits, UnitCursors: checkpoint.UnitCursors,
	})
}

// Commit says mark:commit for this job: it returns once the batch is
// established.
//
// It sends the batch to the record and WAITS for the record to say it has
// it. The gateway taking the message says nothing of the record: a record
// that is down discards a batch the gateway accepted, and a job that counted
// the batch as done would report work that never landed.
//
// A commit the record does not acknowledge in time is not thereby lost. If
// the gateway goes down after the record appended the batch, the
// acknowledgement cannot be routed, and a job failed on that would be failed
// over annotations that are on the record. So the outcome follows what the
// record holds, and not the arrival of a message: the record is asked. A
// batch is never sent a second time to find out.
//
// A commit that was not established fails as its unanswered request did,
// with that request's own failure. What was observed leaves by the job's
// settle, the one place it can still be told.
func (h *heldJob) Commit(ctx context.Context, resourceID api.ResourceId, annotations []api.Annotation) error {
	h.mu.Lock()
	err := h.unsettled(bus.MarkCommit.Request().Channel())
	h.mu.Unlock()
	if err != nil {
		return err
	}
	if len(annotations) == 0 {
		// A batch of no annotations is no commit: there is nothing to establish.
		return nil
	}
	jobID := h.record.JobId
	unanswered := h.answered(ctx, bus.MarkCommit.Request().Channel(), api.MarkCommitCommand{ResourceId: resourceID, Annotations: annotations, JobId: &jobID})
	if unanswered == nil {
		h.observe(api.DurabilityEvidenceAcknowledged)
		return nil
	}
	// The record's refusal, and every other failure of the request, is the
	// commit's failure as it is. Only an acknowledgement that did not arrive
	// leaves what the record holds unknown.
	var timedOut *BusRequestError
	if !errors.As(unanswered, &timedOut) || timedOut.Code != api.BusRequestErrorCodeTimeout {
		return unanswered
	}
	observed := h.askWhetherRecorded(ctx, resourceID, annotations[len(annotations)-1].Id)
	h.observe(observed)
	if observed != api.DurabilityEvidenceProbeConfirmed {
		return unanswered
	}
	return nil
}

// askWhetherRecorded is what asking whether the annotation is on the resource
// observes. Asked of the LAST annotation of a batch nobody acknowledged, and
// that is enough: the record appends a batch in order and stops at the first
// annotation it cannot append (WORKER-CONTRACT A5), so the last being there
// says every one before it is.
//
// Every answer but the annotation fails the commit, and the asymmetry is
// deliberate: a job retried over a batch that had landed costs one more run
// of the batch's unit, where a wrong "it is there" loses the batch silently.
// A question nobody answered is neither yes nor no: it is said as its own
// observation, and it does not establish the commit.
func (h *heldJob) askWhetherRecorded(ctx context.Context, resourceID api.ResourceId, annotationID api.AnnotationId) api.DurabilityEvidence {
	err := h.answered(ctx, bus.BrowseAnnotationRequested.Request().Channel(), api.BrowseAnnotationRequest{ResourceId: resourceID, AnnotationId: annotationID})
	if err == nil {
		return api.DurabilityEvidenceProbeConfirmed
	}
	// A failure reply (bus.rejected) means the question was answered and the
	// answer was not the annotation. That is not "the annotation is absent":
	// a read that failed for its own reasons answers on the same channel. So
	// the job says what was observed, and its reader judges. Anything else
	// (bus.timeout, bus.closed) means nobody answered.
	var refused *BusRequestError
	if errors.As(err, &refused) && refused.Code == api.BusRequestErrorCodeRejected {
		return api.DurabilityEvidenceProbeRefused
	}
	return api.DurabilityEvidenceProbeUnreachable
}

// answered is one of a commit's requests, waited for the commit's wait: nil
// once it is answered, or the failure a bus request has. What it is answered
// with is not read: that the record answered is what establishes a commit,
// so an answer this SDK cannot type is the answer it is all the same.
func (h *heldJob) answered(ctx context.Context, request bus.Channel, payload any) error {
	object, err := payloadOf(payload)
	if err != nil {
		return err
	}
	_, err = h.claims.links.wire.result(h.inTrace(ctx), request, object, h.claims.timing.MarkCommitTimeout, nil)
	return err
}

// observe remembers evidence if it is weaker than what is remembered. Of two
// equally weak, the first seen is kept.
func (h *heldJob) observe(evidence api.DurabilityEvidence) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.durability == nil || weakness[evidence] > weakness[*h.durability] {
		h.durability = &evidence
	}
}

// observed is the weakest of what the job's commits observed; nil when it
// committed nothing.
func (h *heldJob) observed() *api.DurabilityEvidence {
	h.mu.Lock()
	defer h.mu.Unlock()
	return h.durability
}

// Fail settles the job: job:fail. It says whether the queue will retry, from
// the record's budget and the failure's class, and what a commit that was not
// established observed. A settle the gateway did not take still releases the
// job, and fails.
func (h *heldJob) Fail(ctx context.Context, message string, failure api.JobFailure) error {
	if err := h.settling(bus.JobFail.Channel()); err != nil {
		return err
	}
	defer h.released(false)
	// Stated only when a commit was not established: what is weaker than any
	// observation that establishes one. Otherwise the failure says nothing of
	// the job's commits.
	var notEstablished *api.DurabilityEvidence
	if observed := h.observed(); observed != nil && weakness[*observed] > weakness[api.DurabilityEvidenceProbeConfirmed] {
		notEstablished = observed
	}
	willRetry := WillRetryAfter(h.record.RetryCount, h.record.MaxRetries, failure.FailureClass)
	return say(ctx, h, bus.JobFail, api.JobFailCommand{
		ResourceId: h.record.ResourceId, JobId: h.record.JobId, JobType: h.record.JobType, Attempt: h.attempt(), AnnotationId: h.anchor(),
		Error: message, CompletedUnits: failure.CompletedUnits, UnitCursors: failure.UnitCursors,
		FailureClass: failure.FailureClass, WillRetry: &willRetry, Durability: notEstablished,
	})
}

// Cancel settles the job: job:cancel, once the work has stopped for a
// cancellation, with what it reached: the units it finished and the furthest
// each unit begun got, a finished unit's cursor where it ended. The message
// is the command's own fields and no more: it names no attempt.
func (h *heldJob) Cancel(ctx context.Context, reached api.JobReached) error {
	if err := h.settling(bus.JobCancel.Channel()); err != nil {
		return err
	}
	defer h.released(false)
	return say(ctx, h, bus.JobCancel, api.JobCancelCommand{
		ResourceId: h.record.ResourceId, JobId: h.record.JobId, JobType: h.record.JobType, AnnotationId: h.anchor(),
		CompletedUnits: reached.CompletedUnits, UnitCursors: reached.UnitCursors,
	})
}

// failFor fails the job for a reason that is not the work's, unless it is
// settled already. The failure states no class, so the record's retry budget
// decides what becomes of the job. One that cannot be said is not said: the
// job is released, and the dispatcher's sweep concludes it.
func (h *heldJob) failFor(ctx context.Context, reason string) {
	if h.Settled() {
		return
	}
	_ = h.Fail(ctx, reason, api.JobFailure{})
}

// HeldMarkJob is a mark job this worker holds, from its claim until it
// settles it. Each settle says the outcome and releases the job together; a
// second is refused. A settle the gateway did not take still releases the
// job, and fails.
type HeldMarkJob struct {
	heldJob
}

// Complete settles the job: job:complete, with what a mark job reports, and
// how its commits were established.
func (j *HeldMarkJob) Complete(ctx context.Context, result api.MarkJobResult) error {
	if err := j.settling(bus.JobComplete.Channel()); err != nil {
		return err
	}
	defer j.released(true)
	var completed api.JobCompleteCommand
	if err := completed.From(api.MarkJobCompleteCommand{
		ResourceId: j.record.ResourceId, JobId: j.record.JobId, JobType: api.MarkJobCompleteCommandJobTypeMark, Attempt: j.attempt(),
		Result: &result, Durability: j.observed(),
	}); err != nil {
		return err
	}
	return say(ctx, &j.heldJob, bus.JobComplete, completed)
}

// HeldYieldJob is a yield job this worker holds, from its claim until it
// settles it. Each settle says the outcome and releases the job together; a
// second is refused. A settle the gateway did not take still releases the
// job, and fails.
type HeldYieldJob struct {
	heldJob
}

// Complete settles the job: job:complete, with what a yield job reports, and
// how its commits were established.
func (j *HeldYieldJob) Complete(ctx context.Context, result api.YieldJobResult) error {
	if err := j.settling(bus.JobComplete.Channel()); err != nil {
		return err
	}
	defer j.released(true)
	var completed api.JobCompleteCommand
	if err := completed.From(api.YieldJobCompleteCommand{
		ResourceId: j.record.ResourceId, JobId: j.record.JobId, JobType: api.YieldJobCompleteCommandJobTypeYield, Attempt: j.attempt(),
		AnnotationId: j.anchor(), Result: &result, Durability: j.observed(),
	}); err != nil {
		return err
	}
	return say(ctx, &j.heldJob, bus.JobComplete, completed)
}

// anchorOf is the annotation a job is anchored to: the one a yield job's
// context is focused on. A yield job focused on a resource has none, and
// neither has a mark job.
func anchorOf(jobType api.JobType, params api.JobParams) api.AnnotationId {
	if jobType != api.JobTypeYield {
		return api.AnnotationId{}
	}
	encoded, err := params.MarshalJSON()
	if err != nil {
		return api.AnnotationId{}
	}
	var stated api.GenerationJobParams
	if json.Unmarshal(encoded, &stated) != nil {
		return api.AnnotationId{}
	}
	var focus api.GatheredContextFocusAnnotation
	if stated.Context.Focus.As(&focus) != nil || focus.Kind != api.GatheredContextFocusAnnotationKindAnnotation {
		return api.AnnotationId{}
	}
	return focus.Annotation.Id
}

// handedOut is what the claims hand out next: a job, or a refusal.
type handedOut struct {
	job     HeldJob
	refusal *api.ClaimRefusal
}

// Claims is a worker's claims, from Job.Claim: each job the worker comes to
// hold, one at a time, and each claim it was refused. They are ranged over
// (All). The next job is claimed when the one held is settled, and a refusal
// does not end the claims: the worker waits for its next idle moment, and
// what the refusal means is its host's to judge. Claiming begins when the
// claims are first ranged over. It ends when Close is called, when the
// transport's stream ends, or when the client closes; a job still held when
// Close stops it is failed first.
type Claims struct {
	links *links
	// timing is the client's, with each wait the claim's options state.
	timing  Timing
	accepts []api.JobFilter
	// filters is each filter as the wire carries it, which is what an
	// announcement is compared with.
	filters []any
	// filtersErr is why the filters could not be read, which refuses the
	// claims when they are first ranged over.
	filtersErr error
	handed     *kept.Queue[handedOut]
	stalls     *kept.Stream[*api.HeldJobStall]
	// life is the claims': done once they have ended. What watches for an
	// idle moment runs in it; a claim in flight does not, and is left to be
	// answered.
	life context.Context
	end  context.CancelFunc
	work sync.WaitGroup

	mu       sync.Mutex
	begun    bool
	beginErr error
	stopped  bool
	// ranging is how many ranges over All are under way: their loop's body
	// entered and not yet returned.
	ranging int
	held    *heldJob
	// The loop's two bits: one claim in flight at a time, and a wake-up that
	// arrived during it, honoured with exactly one more claim.
	claiming      bool
	wakePending   bool
	stallReported bool
	// Each by the clock a silence is measured on; zero until it happens.
	lastQueuedEventAt time.Time
	lastClaimAt       time.Time
	lastFinishedAt    time.Time
	lastActivityAt    time.Time
	heldSince         time.Time
	jobsCompleted     int
}

func newClaims(l *links, options api.ClaimOptions) *Claims {
	life, end := context.WithCancel(l.life)
	c := &Claims{
		links:   l,
		timing:  claimTiming(l.timing, options),
		accepts: slices.Clone(options.Accepts),
		handed:  kept.NewQueue[handedOut](),
		stalls:  kept.NewStream[*api.HeldJobStall](l.timing.ErrorsKeptForFirstReaderCount),
		life:    life,
		end:     end,
	}
	if c.accepts == nil {
		c.accepts = []api.JobFilter{}
	}
	// The client's closing ends the claims, and so whoever ranges over them:
	// nothing can be claimed for a client that is gone.
	context.AfterFunc(life, c.stop)
	for _, accepted := range c.accepts {
		encoded, err := accepted.MarshalJSON()
		var filter any
		if err == nil {
			err = json.Unmarshal(encoded, &filter)
		}
		if err != nil {
			c.filtersErr = fmt.Errorf("a filter of the claims does not read: %w", err)
			break
		}
		c.filters = append(c.filters, filter)
	}
	return c
}

// claimTiming is timing with each wait options states in its place.
func claimTiming(timing Timing, options api.ClaimOptions) Timing {
	for _, each := range []struct {
		stated *int
		wait   *time.Duration
	}{
		{options.JobClaimTimeoutMs, &timing.JobClaimTimeout},
		{options.HeldJobStallMs, &timing.HeldJobStall},
		{options.HeldJobStallCheckMs, &timing.HeldJobStallCheck},
		{options.MarkCommitTimeoutMs, &timing.MarkCommitTimeout},
	} {
		if each.stated != nil {
			*each.wait = time.Duration(*each.stated) * time.Millisecond
		}
	}
	return timing
}

// All is the claims as they are ranged over: each job the worker comes to
// hold, or, as its error, a claim that was refused. Ranging it the first time
// begins claiming; the sequence ends when the claims do. A range under way is
// handed every job claimed and every refusal, in order, however slowly it
// takes them. While none is, the claims keep every job claimed and, as each
// refusal is met, the latest ErrorsKeptForFirstReaderCount (Timing) of the
// refusals, the oldest dropped beyond them, for whoever ranges over them
// next. A transport whose stream does not name JobClaimChannels cannot carry
// a worker's claims, and is refused as unsubscribed.
func (c *Claims) All() iter.Seq2[HeldJob, error] {
	return func(yield func(HeldJob, error) bool) {
		c.mu.Lock()
		c.ranging++
		c.mu.Unlock()
		defer func() {
			c.mu.Lock()
			c.ranging--
			c.mu.Unlock()
		}()
		if err := c.begin(); err != nil {
			yield(nil, err)
			return
		}
		for {
			item, ok := c.handed.Next(nil)
			if !ok {
				return
			}
			if item.refusal != nil {
				if !yield(nil, item.refusal) {
					return
				}
				continue
			}
			// Claimed, and failed by the worker's stop before anybody read it.
			if item.job.Settled() {
				continue
			}
			if !yield(item.job, nil) {
				return
			}
		}
	}
}

// Vitals is what this worker can say of itself now (WORKER-CONTRACT V1),
// each stamp nil until it has happened.
//
// LastQueuedEventAt is any job:queued received, matching or not, refused by
// its transport or not. On an idle stack with an empty queue it stands still
// by design, so a still stamp alone is not a fault of the stream.
// LastActivityAt (a claim, a progress report, a checkpoint, a settle) is the
// liveness of the work: a job stuck partway stops advancing it, and that is
// what the stall rule reads. LastFinishedAt is the last settle, whatever its
// outcome: a worker that fails and moves on is alive.
func (c *Claims) Vitals() api.WorkerVitals {
	c.mu.Lock()
	defer c.mu.Unlock()
	vitals := api.WorkerVitals{
		LastQueuedEventAt: stampedAt(c.lastQueuedEventAt),
		LastClaimAt:       stampedAt(c.lastClaimAt),
		LastFinishedAt:    stampedAt(c.lastFinishedAt),
		LastActivityAt:    stampedAt(c.lastActivityAt),
		JobsCompleted:     c.jobsCompleted,
	}
	if c.held != nil && !c.heldSince.IsZero() {
		vitals.ActiveJob = &api.WorkerActiveJob{JobId: c.held.record.JobId, Type: c.held.record.JobType, Since: stamp(c.heldSince)}
	}
	return vitals
}

// stamp is at as the wire writes a time: RFC 3339, in UTC, to the
// millisecond.
func stamp(at time.Time) string { return at.UTC().Format("2006-01-02T15:04:05.000Z07:00") }

// stampedAt is at as the wire writes a time; nil for the zero time, which
// has not happened.
func stampedAt(at time.Time) *string {
	if at.IsZero() {
		return nil
	}
	stamped := stamp(at)
	return &stamped
}

// Stalled is each held job that has shown no activity for the client's
// HeldJobStall, reported once (WORKER-CONTRACT V2); what its host does then
// is the host's. Its first reader is given the latest
// ErrorsKeptForFirstReaderCount (Timing) reported since the claims were
// made, the oldest dropped beyond them, in order, and every later one what
// is reported from then on; reporting never waits for a reader. It ends when
// the claims end, and a reader who comes after that, the first among them,
// is given nothing.
func (c *Claims) Stalled() iter.Seq[*api.HeldJobStall] { return c.stalls.Reported(nil) }

// Close stops claiming. A job still held is failed first, and Close returns
// once that has been said, or could not be. A claim in flight is waited for,
// up to its timeout: a job it is answered with is failed too. Closing twice is
// closing once.
func (c *Claims) Close() {
	c.mu.Lock()
	held := c.held
	c.mu.Unlock()
	c.stop()
	if held != nil {
		held.failFor(c.links.life, stoppedWhileHeld)
	}
	c.work.Wait()
}

// stop ends the claims: nothing more is claimed or handed out, what watched
// for an idle moment stops watching, and the stalls end.
func (c *Claims) stop() {
	c.mu.Lock()
	if c.stopped {
		c.mu.Unlock()
		return
	}
	c.stopped = true
	c.mu.Unlock()
	c.handed.Close()
	c.stalls.Close()
	c.end()
}

// spawn runs work as the claims'. It is called with c.mu held, before the
// claims have stopped, so Close waits for it.
func (c *Claims) spawn(work func()) {
	c.work.Add(1)
	go func() {
		defer c.work.Done()
		work()
	}()
}

func (c *Claims) begin() error {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.begun {
		return c.beginErr
	}
	c.begun = true
	if c.filtersErr != nil {
		c.beginErr = c.filtersErr
		return c.beginErr
	}
	var unnamed []string
	for _, channel := range JobClaimChannels {
		if !c.links.transport.IsSubscribed(channel) {
			unnamed = append(unnamed, string(channel))
		}
	}
	if len(unnamed) > 0 {
		c.beginErr = &BusRequestError{
			Code: api.BusRequestErrorCodeUnsubscribed,
			Message: fmt.Sprintf("This transport's stream does not name %s: a worker on it would never be answered, woken or told of a cancellation. Give the transport JobClaimChannels.",
				strings.Join(unnamed, ", ")),
		}
		return c.beginErr
	}
	if c.stopped {
		return nil
	}
	// Both broadcasts are read from the transport, as the stream delivers
	// them, and not as this SDK types them: the comparison of an announcement
	// with a filter knows no field by name, so a job this SDK cannot type
	// still wakes a worker whose claim it matches. What the client's own
	// parts say to each other wakes no worker.
	frames, err := c.links.transport.Frames(c.life, bus.JobQueued.Channel(), bus.JobCancelRequested.Request().Channel())
	if err != nil {
		c.beginErr = err
		return c.beginErr
	}
	c.spawn(func() { c.hear(frames) })
	c.spawn(c.watchTheStream)
	c.spawn(c.lookForStalls)
	return nil
}

// hear reads the announcements and the cancellations as the transport
// delivers them. An announcement it refused was received all the same, and
// no filter can be compared with what cannot be read: it wakes the worker as
// a matching one would. A cancellation it refused names no job, and cancels
// nothing. The transport's closing ends the claims: nothing more can be
// claimed.
func (c *Claims) hear(frames iter.Seq2[Frame, error]) {
	for frame, refused := range frames {
		switch {
		case frame.Channel != bus.JobQueued.Channel():
			if refused == nil {
				c.cancellation(frame)
			}
		case refused != nil:
			c.queued()
			c.mu.Lock()
			c.pull()
			c.mu.Unlock()
		default:
			c.announced(frame)
		}
	}
	c.stop()
}

// queued stamps a job:queued received. Every announcement is stamped,
// before any filtering.
func (c *Claims) queued() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.lastQueuedEventAt = time.Now()
}

// announced is a job:queued, which claims when it matches a filter.
func (c *Claims) announced(frame Frame) {
	c.queued()
	var job any
	if json.Unmarshal(frame.Payload, &job) != nil {
		return
	}
	for _, filter := range c.filters {
		if JobMatchesFilter(filter, job) {
			c.mu.Lock()
			c.pull()
			c.mu.Unlock()
			return
		}
	}
}

// cancellation is a job:cancel-requested. It is the held job's only when it
// names it, and one that arrives after the settle signals nothing.
func (c *Claims) cancellation(frame Frame) {
	var named api.JobCancelRequest
	if json.Unmarshal(frame.Payload, &named) != nil {
		return
	}
	c.mu.Lock()
	held := c.held
	c.mu.Unlock()
	if held != nil && !held.Settled() && named.JobId == held.record.JobId {
		held.cancelled.Set(true)
	}
}

// watchTheStream claims when the stream opens: the first observation decides
// whether the first claim is made now or waits for the stream to open (a
// claim on a closed stream would only be refused here), and every change to
// open after it claims. A closed transport ends the claims.
func (c *Claims) watchTheStream() {
	first, wasOpen := true, false
	for state := range c.links.transport.State().Changes(c.life) {
		open := state == api.ConnectionStateOpen
		if open && (first || !wasOpen) {
			c.mu.Lock()
			c.pull()
			c.mu.Unlock()
		}
		if state == api.ConnectionStateClosed {
			c.stop()
			return
		}
		first, wasOpen = false, open
	}
}

// lookForStalls looks at the held job every HeldJobStallCheck, and reports
// one that has shown no activity for longer than HeldJobStall, once.
func (c *Claims) lookForStalls() {
	timing := c.timing
	ticker := time.NewTicker(timing.HeldJobStallCheck)
	defer ticker.Stop()
	for {
		select {
		case <-c.life.Done():
			return
		case <-ticker.C:
		}
		c.mu.Lock()
		held := c.held
		if held == nil || c.stallReported || c.lastActivityAt.IsZero() || c.heldSince.IsZero() {
			c.mu.Unlock()
			continue
		}
		silentFor := time.Since(c.lastActivityAt)
		if silentFor <= timing.HeldJobStall {
			c.mu.Unlock()
			continue
		}
		c.stallReported = true
		stall := &api.HeldJobStall{
			JobId: held.record.JobId, JobType: held.record.JobType, HeldSince: stamp(c.heldSince), LastActivityAt: stamp(c.lastActivityAt),
			SilentForMs: int(silentFor.Milliseconds()), ThresholdMs: int(timing.HeldJobStall.Milliseconds()),
		}
		c.mu.Unlock()
		c.stalls.Report(stall)
	}
}

// active is the work showing it is alive.
func (c *Claims) active() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.lastActivityAt = time.Now()
}

// released is job, settled and no longer held: whether it was completed. The
// settle is an idle moment.
func (c *Claims) released(job *heldJob, completed bool) {
	c.mu.Lock()
	defer c.mu.Unlock()
	if c.held != job {
		return
	}
	now := time.Now()
	c.lastActivityAt, c.lastFinishedAt = now, now
	c.held = nil
	c.heldSince = time.Time{}
	if completed {
		c.jobsCompleted++
	}
	c.pull()
}

// pull is one idle moment: ask once, or remember that we were asked to. It is
// called with c.mu held.
func (c *Claims) pull() {
	if c.stopped || c.held != nil {
		// Holding a job: the settle claims. Nothing to remember.
		return
	}
	if c.claiming {
		c.wakePending = true
		return
	}
	c.claiming, c.wakePending = true, false
	c.spawn(c.claim)
}

func (c *Claims) claim() {
	job, refusal := c.claimNext()
	c.mu.Lock()
	c.claiming = false
	if c.stopped {
		c.mu.Unlock()
		// Answered after the worker stopped: the job is this worker's at the
		// dispatcher, and nobody here will run it.
		if job != nil {
			job.held().failFor(c.links.life, stoppedWhileHeld)
		}
		return
	}
	if job != nil {
		now := time.Now()
		c.lastActivityAt, c.lastClaimAt, c.heldSince = now, now, now
		c.stallReported = false
		// A wake-up that arrived during the claim is moot: the settle claims.
		c.wakePending = false
		c.held = job.held()
		c.mu.Unlock()
		c.handed.Push(handedOut{job: job})
		return
	}
	if refusal != nil {
		c.handed.Push(handedOut{refusal: refusal})
		// What the queue holds here is refusals alone: a job claimed is held
		// until it is settled, which its reader does once it has taken it,
		// and nothing is claimed meanwhile.
		if c.ranging == 0 {
			c.handed.KeepLatest(c.links.timing.ErrorsKeptForFirstReaderCount)
		}
	}
	if c.wakePending {
		c.wakePending = false
		c.pull()
	}
	c.mu.Unlock()
}

// claimNext asks once: the job claimed, the refusal, or neither when nothing
// is pending. A claim names fields of the job description, never a job id. A
// reply that does not read as a claimed job is refused and never run
// (WORKER-CONTRACT C9): one that lacks a member its schema requires, a job
// id or parameters among them, as it is decoded, and one whose job type is
// neither verb's here.
//
// The claim is made in no trace: it runs in the client's life, never in the
// context of whatever settled the job before it.
func (c *Claims) claimNext() (HeldJob, *api.ClaimRefusal) {
	life := c.links.life
	answer, err := claimed(life, c.links, c.accepts, c.timing.JobClaimTimeout)
	if err != nil {
		if life.Err() != nil {
			// The client closed: nobody is left to claim for.
			return nil, nil
		}
		var refused *BusRequestError
		if errors.As(err, &refused) {
			if refused.Code == api.BusRequestErrorCodeNonePending {
				return nil, nil
			}
			code := refused.Code
			return nil, &api.ClaimRefusal{Code: &code, Message: refused.Message}
		}
		return nil, &api.ClaimRefusal{Message: err.Error()}
	}
	running := answer.Payload.Response
	// The verb's handle is made first, and its job filled in place: a held
	// job holds a lock, and is never copied.
	var job HeldJob
	var held *heldJob
	if running.Metadata.Type == api.JobTypeMark {
		mark := &HeldMarkJob{}
		job, held = mark, &mark.heldJob
	} else {
		yield := &HeldYieldJob{}
		job, held = yield, &yield.heldJob
	}
	held.claims = c
	held.trace = answer.Trace
	held.record = api.HeldJobRecord{
		JobId:          running.Metadata.Id,
		JobType:        running.Metadata.Type,
		ResourceId:     running.Params.ResourceId,
		Params:         running.Params,
		CompletedUnits: []string{},
		UnitCursors:    map[string]api.UnitCursor{},
		RetryCount:     running.Metadata.RetryCount,
		MaxRetries:     running.Metadata.MaxRetries,
	}
	// Both appear on the job once an attempt has checkpointed. Absent, each is none.
	if units := running.Metadata.CompletedUnits; units != nil {
		held.record.CompletedUnits = slices.Clone(*units)
	}
	if cursors := running.Metadata.UnitCursors; cursors != nil {
		held.record.UnitCursors = maps.Clone(*cursors)
	}
	held.annotationID = anchorOf(running.Metadata.Type, running.Params)
	held.cancelled = NewVariable(false)
	held.over, held.end = context.WithCancel(context.Background())
	return job, nil
}

// claimed is a claim of what accepts describes, as far as the frame that
// answers it on its result channel: its payload, and the trace it arrived in.
func claimed(ctx context.Context, l *links, accepts []api.JobFilter, timeout time.Duration) (Delivered[api.JobClaimedResult], error) {
	object, err := payloadOf(api.JobClaimCommand{Accepts: accepts})
	if err != nil {
		return Delivered[api.JobClaimedResult]{}, err
	}
	reply, err := l.wire.result(ctx, bus.JobClaim.Request().Channel(), object, timeout, nil)
	if err != nil {
		return Delivered[api.JobClaimedResult]{}, err
	}
	answer, refusal := delivered[api.JobClaimedResult](reply)
	if refusal != nil {
		return Delivered[api.JobClaimedResult]{}, refusal
	}
	return answer, nil
}

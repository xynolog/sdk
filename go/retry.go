package xynolog

// Trying again: which failures are worth another attempt, and how long to keep
// at it.
//
// The two are separate questions. A RetryRule answers the first for one
// context, as protocol/specs/src/retry/cases.json states it. An api.RetryBudget answers the
// second: a budget of attempts, and the backoff between them. The budgets a
// client keeps are protocol/specs/src/client/timing.json's (Timing).

import (
	"context"
	"math/rand/v2"
	"regexp"
	"slices"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/xynolog/sdk/go/api"
)

// RetryFacts is what is known of a failure when someone asks whether to try
// again. What is not known is nil.
type RetryFacts struct {
	// Status is the response's status; nil when no response came.
	Status *int
	// Method is the request's method; nil when the context states none.
	Method *string
	// Keyed is whether the request carries an Idempotency-Key.
	Keyed bool
}

// RetryRule is which failures one context tries again: one rule of
// protocol/specs/src/retry/rules.json, whose values retry_gen.go writes.
type RetryRule struct {
	// Name is the rule's name in the table.
	Name string
	// Statuses are the statuses it retries.
	Statuses []int
	// StatusFrom, when the rule states it, is a status at or above which every
	// status is retried too.
	StatusFrom *int
	// IdempotentMethods, when the rule states them, are the methods a repeat
	// of which cannot cause a second effect: a request of another method is
	// retried only when it carries an Idempotency-Key. A rule that states none
	// does not ask about the request.
	IdempotentMethods []string
	// NoResponse is whether a failure that got no response is retried.
	NoResponse bool
}

// Retryable reports whether a failure of these facts is worth another attempt
// under this rule.
func (r RetryRule) Retryable(facts RetryFacts) bool {
	if facts.Status == nil {
		return r.NoResponse
	}
	if r.IdempotentMethods != nil && !facts.Keyed &&
		(facts.Method == nil || !slices.Contains(r.IdempotentMethods, strings.ToUpper(*facts.Method))) {
		return false
	}
	return slices.Contains(r.Statuses, *facts.Status) || (r.StatusFrom != nil && *facts.Status >= *r.StatusFrom)
}

var wholeSeconds = regexp.MustCompile(`^[0-9]+$`)

// RetryAfter is the wait a Retry-After header states, when it gives whole
// seconds, the form the gateway sends. An empty header, as a missing one reads,
// states none, and so does any other form; ok is then false.
func RetryAfter(header string) (wait time.Duration, ok bool) {
	stated := strings.TrimSpace(header)
	if !wholeSeconds.MatchString(stated) {
		return 0, false
	}
	seconds, err := strconv.ParseInt(stated, 10, 64)
	if err != nil {
		return 0, false
	}
	return time.Duration(seconds) * time.Second, true
}

// EqualJitter is half of the cap, and a share of the other half drawn from
// random: from the system's source when random is nil.
//
// Callers that back off by one schedule against one gateway come back at the
// same instant and deliver again the burst that failed. The random half keeps
// them apart, and the wait never exceeds the cap.
func EqualJitter(cap time.Duration, random *rand.Rand) time.Duration {
	half := cap / 2
	return half + time.Duration(draw(random)*float64(cap-half))
}

// draws is held for each draw from a source a caller gave. A *rand.Rand is
// for one goroutine at a time, and the SDK backs off on many: drawn from one
// at a time, one source may be given to every maker that takes one. A caller
// that draws from it as well does so while nothing it was given to runs.
var draws sync.Mutex

// draw is a number in [0, 1) drawn from random, or from the system's source
// when random is nil.
func draw(random *rand.Rand) float64 {
	if random == nil {
		return rand.Float64()
	}
	draws.Lock()
	defer draws.Unlock()
	return random.Float64()
}

// RetryWithBackoff runs attempt until it succeeds, the budget's attempts are
// spent, or it fails in a way retryable does not accept. The wait before each
// further attempt is the budget's backoff, its jitter drawn from random
// (EqualJitter), and never less than the wait the failure itself stated (a
// refusal's Retry-After). A context that is done ends the wait in progress,
// and its error is returned; otherwise the last failure is returned as it
// was.
func RetryWithBackoff[T any](
	ctx context.Context,
	budget api.RetryBudget,
	random *rand.Rand,
	attempt func(context.Context) (T, error),
	retryable func(error) bool,
	stated func(error) (time.Duration, bool),
) (T, error) {
	limit := time.Duration(budget.InitialDelayMs) * time.Millisecond
	ceiling := time.Duration(budget.MaxDelayMs) * time.Millisecond
	for made := 1; ; made++ {
		value, err := attempt(ctx)
		if err == nil || made >= budget.Attempts || ctx.Err() != nil || !retryable(err) {
			return value, err
		}
		wait := EqualJitter(limit, random)
		if floor, ok := stated(err); ok && floor > wait {
			wait = floor
		}
		timer := time.NewTimer(wait)
		select {
		case <-ctx.Done():
			timer.Stop()
			var none T
			return none, ctx.Err()
		case <-timer.C:
		}
		limit = min(limit*2, ceiling)
	}
}

// Command xynolog-go-live-driver is the Go SDK's live driver: the program the
// SDK conformance suite talks to in the Go SDK's place for its live layer
// (protocol/conformance/sdk/README.md, § The live driver). It holds a client, its
// live queries and their cache, and reaches them only as an application does,
// through what the SDK exports, so what the suite observes is what a caller of
// the SDK gets.
package main

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"iter"
	"net/http"
	"os"
	"sync"
	"time"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/conformance/internal/protocol"
)

// query is a live query a case names, as this driver reads it: its states,
// its one-shot read, what says it is out of date, and how a state of it is
// written.
type query struct {
	states     func(ctx context.Context) iter.Seq[xynolog.CacheState]
	fresh      func(ctx context.Context) (any, error)
	invalidate func()
	written    func(state xynolog.CacheState) api.ConformanceDriverLineEmissionEmissionStateMember
}

// itself is a query's value as it is: each value of the SDK writes itself as
// the wire had it.
func itself[T any](value T) any { return value }

// liveQuery is q, its values written by show.
func liveQuery[T any](q *xynolog.Cached[T], show func(T) any) query {
	return query{
		states: q.States,
		fresh: func(ctx context.Context) (any, error) {
			value, err := q.Fresh(ctx)
			if err != nil {
				return nil, err
			}
			return show(value), nil
		},
		invalidate: q.Invalidate,
		written: func(state xynolog.CacheState) api.ConformanceDriverLineEmissionEmissionStateMember {
			switch s := state.(type) {
			case xynolog.Ready[T]:
				return ready(show(s.Value))
			case xynolog.Failed:
				return failed(s.Err)
			}
			return api.ConformanceDriverLineEmissionEmissionStatePending{Status: api.ConformanceDriverLineEmissionEmissionStatePendingStatusPending}
		},
	}
}

// engines is the engines as the wire had them, each entry with its limits
// beside its own fields.
func engines(listed []xynolog.EngineWithLimits) any {
	written := make([]any, 0, len(listed))
	for _, engine := range listed {
		encoded, err := json.Marshal(engine.Entry)
		var entry map[string]any
		if err != nil || json.Unmarshal(encoded, &entry) != nil {
			written = append(written, engine.Entry)
			continue
		}
		if engine.Limits != nil {
			entry["limits"] = engine.Limits
		}
		written = append(written, entry)
	}
	return written
}

// failure is err as the protocol carries it. An error of none of the SDK's
// vocabularies has no code to say, and the suite fails it for that.
func failure(err error) api.ConformanceFailure {
	var failed xynolog.Error
	if errors.As(err, &failed) {
		return protocol.Failure(failed)
	}
	return api.ConformanceFailure{Detail: err.Error()}
}

// ready is an observer's state that shows value.
func ready(value any) api.ConformanceDriverLineEmissionEmissionStateReady {
	return api.ConformanceDriverLineEmissionEmissionStateReady{Status: api.ConformanceDriverLineEmissionEmissionStateReadyStatusReady, Value: value}
}

// failed is an observer's state that failed with err.
func failed(err error) api.ConformanceDriverLineEmissionEmissionStateFailed {
	return api.ConformanceDriverLineEmissionEmissionStateFailed{Status: api.ConformanceDriverLineEmissionEmissionStateFailedStatusFailed, Error: failure(err)}
}

func resourceOf(args protocol.Arguments, name string) (api.ResourceId, error) {
	text, err := protocol.Text(args, name)
	if err != nil {
		return api.ResourceId{}, err
	}
	id, err := api.ParseResourceId(text)
	if err != nil {
		return api.ResourceId{}, protocol.Misused("%s is not a resource's id: %v", name, err)
	}
	return id, nil
}

func annotationOf(args protocol.Arguments, name string) (api.AnnotationId, error) {
	text, err := protocol.Text(args, name)
	if err != nil {
		return api.AnnotationId{}, err
	}
	id, err := api.ParseAnnotationId(text)
	if err != nil {
		return api.AnnotationId{}, protocol.Misused("%s is not an annotation's id: %v", name, err)
	}
	return id, nil
}

// object is the argument name, an object of arguments.
func object(args protocol.Arguments, name string) (protocol.Arguments, error) {
	var inner protocol.Arguments
	if raw, ok := args[name]; !ok || json.Unmarshal(raw, &inner) != nil || inner == nil {
		return nil, protocol.Misused("%s must be an object", name)
	}
	return inner, nil
}

// filters is the filters a case states for a list of resources, or for a
// search, as T, the filters that query takes. A filter T has no member for is
// the suite's mistake.
func filters[T any](q protocol.Arguments) (T, error) {
	var listed T
	raw, given := q["filters"]
	if !given {
		return listed, nil
	}
	decoder := json.NewDecoder(bytes.NewReader(raw))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&listed); err != nil {
		return listed, protocol.Misused("filters: %v", err)
	}
	return listed, nil
}

// queryOf is the live query a case names: a query of
// protocol/specs/src/client/refresh.json, by its name there.
func queryOf(c *xynolog.Client, q protocol.Arguments) (query, error) {
	name, err := protocol.Text(q, "query")
	if err != nil {
		return query{}, err
	}
	switch xynolog.CacheQuery(name) {
	case xynolog.CacheQueryResource:
		resource, err := resourceOf(q, "resource")
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Browse.Resource(resource), itself[api.ResourceDescriptor]), nil
	case xynolog.CacheQueryAnnotations:
		resource, err := resourceOf(q, "resource")
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Browse.Annotations(resource), itself[[]api.Annotation]), nil
	case xynolog.CacheQueryAnnotation:
		resource, err := resourceOf(q, "resource")
		if err != nil {
			return query{}, err
		}
		annotation, err := annotationOf(q, "annotation")
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Browse.Annotation(resource, annotation), itself[api.Annotation]), nil
	case xynolog.CacheQueryEvents:
		resource, err := resourceOf(q, "resource")
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Browse.Events(resource), itself[[]api.AttributedEvent]), nil
	case xynolog.CacheQueryReferencedBy:
		resource, err := resourceOf(q, "resource")
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Gather.ReferencedBy(resource), itself[[]api.GetReferencedByResponseReferencedByItem]), nil
	case xynolog.CacheQueryResources:
		listed, err := filters[api.BrowseResourcesRequest](q)
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Browse.Resources(listed), itself[api.ListResourcesResponse]), nil
	case xynolog.CacheQueryMatchedResources:
		search, err := protocol.Text(q, "search")
		if err != nil {
			return query{}, err
		}
		listed, err := filters[api.ResourceSearchFilters](q)
		if err != nil {
			return query{}, err
		}
		return liveQuery(c.Match.Resources(search, listed), itself[api.MatchResourcesResponse]), nil
	case xynolog.CacheQueryEntityTypes:
		return liveQuery(c.Browse.EntityTypes(), itself[[]string]), nil
	case xynolog.CacheQueryTagSchemas:
		return liveQuery(c.Browse.TagSchemas(), itself[[]api.TagSchema]), nil
	case xynolog.CacheQueryEngines:
		return liveQuery(c.Browse.Engines(), engines), nil
	}
	return query{}, protocol.Misused("no live query %s", name)
}

// timing is the client's timing, with what the case overrides, each entry by
// its name in protocol/specs/src/client/timing.json.
func timing(args protocol.Arguments) (xynolog.Timing, error) {
	timing := xynolog.DefaultTiming()
	if _, given := args["timing"]; !given {
		return timing, nil
	}
	stated, err := object(args, "timing")
	if err != nil {
		return timing, err
	}
	for name := range stated {
		n, err := protocol.Count(stated, name)
		if err != nil {
			return timing, err
		}
		ms := time.Duration(n) * time.Millisecond
		switch name {
		case "reconnectMs":
			timing.Reconnect = ms
		case "lazyRemoveMs":
			timing.LazyRemove = ms
		case "lingerMs":
			timing.Linger = ms
		case "busRequestTimeoutMs":
			timing.BusRequestTimeout = ms
		case "invalidationWindowMs":
			timing.InvalidationWindow = ms
		case "jobSilenceMs":
			timing.JobSilence = ms
		case "jobStatusPollMs":
			timing.JobStatusPoll = ms
		default:
			return timing, protocol.Misused("this driver cannot override %s", name)
		}
	}
	return timing, nil
}

// conformancePerson is the person a client the suite opens keeps its caches
// for: the suite asks no gateway who its token is, so every driver keeps them
// for this one.
const conformancePerson = "did:web:conformance.example:users:driver"

// live is one client, and what the suite asked it to report.
type live struct {
	// storage is what a cache is kept in, across close and the next open: a
	// reload, to the client.
	storage *xynolog.MemoryStorage

	mu        sync.Mutex
	transport *xynolog.HTTPTransport
	// client is the client, kept once closed: what a closed client does is
	// part of what the suite asks.
	client *xynolog.Client
	closed bool
	// observers is what stops each observer, by the name the suite gave it.
	observers map[string]context.CancelFunc
	// reported is the state last reported.
	reported api.ConnectionState
	// reporters is what reports what the client observes.
	reporters sync.WaitGroup
}

func (l *live) Operations() []string {
	return []string{"open", "close", "observe", "unobserve", "fresh", "invalidate", "markDelegate", "yieldDelegate", "delete", "sync"}
}

func (l *live) opened() (*xynolog.Client, error) {
	l.mu.Lock()
	defer l.mu.Unlock()
	if l.client == nil {
		return nil, protocol.Misused("no client is open")
	}
	return l.client, nil
}

// report reports the state the transport is in, unless it is the one last
// reported.
func (l *live) report(state api.ConnectionState) {
	l.mu.Lock()
	defer l.mu.Unlock()
	if l.reported != state {
		l.reported = state
		protocol.Say(api.ConformanceDriverLineState{State: string(state)})
	}
}

func (l *live) Run(ctx context.Context, _ uint64, op string, args protocol.Arguments) (any, error) {
	switch op {
	case "open":
		return nil, l.open(args)
	case "close":
		return nil, l.close()
	case "observe":
		return nil, l.observe(args)
	case "unobserve":
		return nil, l.unobserve(args)
	case "fresh":
		c, err := l.opened()
		if err != nil {
			return nil, err
		}
		q, err := l.named(c, args)
		if err != nil {
			return nil, err
		}
		value, err := q.fresh(ctx)
		if err != nil {
			return nil, err
		}
		return map[string]any{"value": value}, nil
	case "invalidate":
		c, err := l.opened()
		if err != nil {
			return nil, err
		}
		q, err := l.named(c, args)
		if err != nil {
			return nil, err
		}
		q.invalidate()
		return nil, nil
	case "markDelegate":
		return nil, l.markDelegate(args)
	case "yieldDelegate":
		return nil, l.yieldDelegate(args)
	case "delete":
		c, err := l.opened()
		if err != nil {
			return nil, err
		}
		resource, err := resourceOf(args, "resource")
		if err != nil {
			return nil, err
		}
		annotation, err := annotationOf(args, "annotation")
		if err != nil {
			return nil, err
		}
		return nil, c.Mark.Delete(ctx, resource, annotation)
	case "sync":
		// Answers after everything the client reported before it: the
		// suite's way to know it has read every state an observer was in.
		l.mu.Lock()
		transport := l.transport
		l.mu.Unlock()
		if transport != nil {
			l.report(transport.State().Value())
		}
		return nil, nil
	}
	return nil, protocol.Misused("%s is not an operation of this driver", op)
}

// named is the live query the case's `query` argument names.
func (l *live) named(c *xynolog.Client, args protocol.Arguments) (query, error) {
	q, err := object(args, "query")
	if err != nil {
		return query{}, err
	}
	return queryOf(c, q)
}

func (l *live) open(args protocol.Arguments) error {
	l.mu.Lock()
	reopening := l.client != nil && !l.closed
	l.mu.Unlock()
	if reopening {
		return protocol.Misused("a client is already open")
	}
	timing, err := timing(args)
	if err != nil {
		return err
	}
	baseURL, err := protocol.Text(args, "baseUrl")
	if err != nil {
		return err
	}
	token, err := protocol.Text(args, "token")
	if err != nil {
		return err
	}
	var persist bool
	if raw, given := args["persist"]; given && json.Unmarshal(raw, &persist) != nil {
		return protocol.Misused("persist must be true or false")
	}
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: baseURL, Token: xynolog.NewVariable(token), Channels: bus.BridgedChannels, HTTP: &http.Client{}, Timing: timing,
	})
	// Taken at once, so every failure from the first request on is said, each
	// before the call that met it returns, until the transport closes.
	transport.Failures(func(failed *xynolog.TransportError) {
		protocol.Say(api.ConformanceDriverLineErrorStream{Error: protocol.Failure(failed)})
	})
	config := xynolog.ClientConfig{Transport: transport, Content: xynolog.NewHTTPContentTransport(transport), Gateway: transport, Timing: timing}
	if persist {
		config.Persistence = &xynolog.CachePersistence{Storage: l.storage, KbID: "conformance", PersonKey: xynolog.PersonKey(conformancePerson)}
	}
	c := xynolog.NewClient(config)
	l.mu.Lock()
	l.transport, l.client, l.closed = transport, c, false
	l.observers = map[string]context.CancelFunc{}
	l.reported = ""
	l.mu.Unlock()
	l.reporters.Add(1)
	go func() {
		defer l.reporters.Done()
		for state := range transport.State().Changes(context.Background()) {
			l.report(state)
			if state == api.ConnectionStateClosed {
				return
			}
		}
	}()
	return nil
}

func (l *live) close() error {
	c, err := l.opened()
	if err != nil {
		return err
	}
	l.mu.Lock()
	transport := l.transport
	l.mu.Unlock()
	c.Close()
	transport.Close()
	l.mu.Lock()
	l.closed = true
	l.mu.Unlock()
	return nil
}

// free claims the observer a case names, which is nobody's yet, and gives
// the context that observing it runs in.
func (l *live) free(args protocol.Arguments) (string, context.Context, error) {
	observer, err := protocol.Text(args, "observer")
	if err != nil {
		return "", nil, err
	}
	l.mu.Lock()
	defer l.mu.Unlock()
	if _, taken := l.observers[observer]; taken {
		return "", nil, protocol.Misused("%s is already observing", observer)
	}
	ctx, stop := context.WithCancel(context.Background())
	l.observers[observer] = stop
	return observer, ctx, nil
}

func emission(observer string, member api.ConformanceDriverLineEmissionEmissionStateMember) {
	var state api.ConformanceDriverLineEmissionEmissionState
	if err := state.From(member); err != nil {
		fmt.Fprintln(os.Stderr, err)
		return
	}
	protocol.Say(api.ConformanceDriverLineEmission{Emission: api.ConformanceDriverLineEmissionEmission{Observer: observer, State: state}})
}

func (l *live) observe(args protocol.Arguments) error {
	c, err := l.opened()
	if err != nil {
		return err
	}
	q, err := l.named(c, args)
	if err != nil {
		return err
	}
	observer, ctx, err := l.free(args)
	if err != nil {
		return err
	}
	next, stop := iter.Pull(q.states(ctx))
	// The state an observer is given at once, the query's state now, is said
	// here, before this is answered, and only the states after it from a
	// goroutine of their own: a case that reads what the observer holds
	// straight after `observe` finds it there. None means the query
	// completed before it gave one.
	now, observing := next()
	if observing {
		emission(observer, q.written(now))
	}
	l.reporters.Add(1)
	go func() {
		defer l.reporters.Done()
		defer stop()
		if observing {
			for {
				state, more := next()
				if !more {
					break
				}
				emission(observer, q.written(state))
			}
		}
		// An observer the suite stopped has ended, not completed: only a
		// query that ended by itself, its client closed, is said to.
		if ctx.Err() == nil {
			protocol.Say(api.ConformanceDriverLineCompleted{Completed: observer})
		}
	}()
	return nil
}

func (l *live) unobserve(args protocol.Arguments) error {
	observer, err := protocol.Text(args, "observer")
	if err != nil {
		return err
	}
	l.mu.Lock()
	stop, observing := l.observers[observer]
	delete(l.observers, observer)
	l.mu.Unlock()
	if !observing {
		return protocol.Misused("%s is not observing", observer)
	}
	stop()
	return nil
}

// following reports a delegated job, followed to its end, as an observer:
// each event it reports a ready state, its failure a failed one, its end a
// completion.
func following[C any](observer string, job *xynolog.Delegation[C], done func()) {
	defer done()
	for event, err := range job.Events(context.Background()) {
		if err != nil {
			var refused xynolog.Error
			if errors.As(err, &refused) {
				emission(observer, failed(err))
			}
			break
		}
		emission(observer, ready(event))
	}
	protocol.Say(api.ConformanceDriverLineCompleted{Completed: observer})
}

func (l *live) markDelegate(args protocol.Arguments) error {
	c, err := l.opened()
	if err != nil {
		return err
	}
	resource, err := resourceOf(args, "resource")
	if err != nil {
		return err
	}
	var params api.MarkJobParams
	if raw, given := args["params"]; !given || params.UnmarshalJSON(raw) != nil {
		return protocol.Misused("params must be what a mark job is created with")
	}
	observer, _, err := l.free(args)
	if err != nil {
		return err
	}
	job := c.Mark.Delegate(resource, params)
	l.reporters.Add(1)
	go following(observer, job, func() { l.reporters.Done() })
	return nil
}

func (l *live) yieldDelegate(args protocol.Arguments) error {
	c, err := l.opened()
	if err != nil {
		return err
	}
	var params api.GenerationJobParams
	if raw, given := args["params"]; !given || json.Unmarshal(raw, &params) != nil {
		return protocol.Misused("params must be what a yield job is created with")
	}
	stall, err := protocol.Count(args, "stallDeadlineMs")
	if err != nil {
		return err
	}
	observer, _, err := l.free(args)
	if err != nil {
		return err
	}
	job := c.Yield.Delegate(params, time.Duration(stall)*time.Millisecond)
	l.reporters.Add(1)
	go following(observer, job, func() { l.reporters.Done() })
	return nil
}

func (l *live) Finish() {
	l.mu.Lock()
	c, transport, closed := l.client, l.transport, l.closed
	for _, stop := range l.observers {
		stop()
	}
	l.mu.Unlock()
	if c != nil && !closed {
		c.Close()
		transport.Close()
	}
	l.reporters.Wait()
}

func main() {
	flush, exporting := protocol.Exporting()
	protocol.Serve(func(protocol.Abandoner) protocol.Driver {
		return &live{storage: xynolog.NewMemoryStorage(), observers: map[string]context.CancelFunc{}}
	})
	if exporting {
		flush()
	}
}

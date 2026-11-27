package state_test

// What the units' cases in protocol/specs/src/client/state-units.json cannot state:
// the state-unit axioms, each unit's; how often a state wakes a reader,
// which differs by language; that a search the pipeline abandons is let go;
// that mark parameters stating no motivation their union maps, which the
// spec's cases cannot write, are no job's; and that what a unit's method
// takes is what the namespace it calls takes.

import (
	"context"
	"encoding/json"
	"iter"
	"reflect"
	"slices"
	"sync"
	"testing"
	"testing/synctest"
	"time"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/internal/timing"
	"github.com/xynolog/sdk/go/state"
	"github.com/xynolog/sdk/go/xynologtest"
)

func idOf[T any](t *testing.T, text string) T {
	t.Helper()
	id, err := decoded[T](text)
	if err != nil {
		t.Fatal(err)
	}
	return id
}

// clientOf is a client over a transport whose stream carries what a client's
// does, closed when the case is over.
func clientOf(t *testing.T, config xynologtest.FaultyConfig) *xynolog.Client {
	config.Channels = bus.BridgedChannels
	made := xynologtest.NewTestClient(xynologtest.TestClientConfig{Transport: xynologtest.NewFaultyTransport(config), Timing: xynolog.DefaultClientTiming()})
	t.Cleanup(func() {
		made.Client.Close()
		made.Transport.Close()
	})
	return made.Client
}

// ── The axioms ──────────────────────────────────────────────────────────

func TestMarkKeepsTheStateUnitAxioms(t *testing.T) {
	resource := idOf[api.ResourceId](t, "res-1")
	var params api.MarkJobParams
	if err := json.Unmarshal([]byte(`{"motivation":"highlighting"}`), &params); err != nil {
		t.Fatal(err)
	}
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.MarkStateUnit]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.MarkStateUnit] {
			client := clientOf(t, xynologtest.FaultyConfig{})
			unit := state.NewMarkStateUnit(client, resource)
			return xynologtest.Fresh[*state.MarkStateUnit]{Unit: unit}.With(xynologtest.TheClient(client))
		},
		Surfaces: func(unit *state.MarkStateUnit) []xynologtest.Surface {
			return []xynologtest.Surface{
				xynologtest.Watching(unit.PendingAnnotation()),
				xynologtest.Watching(unit.DelegatingMotivation()),
				xynologtest.Watching(unit.Progress()),
				xynologtest.Watching(unit.ProgressMotivation()),
				xynologtest.Watching(unit.Failure()),
				xynologtest.Watching(unit.JobId()),
			}
		},
		Invocations: func(unit *state.MarkStateUnit) []func() {
			return []func(){func() { unit.RequestDelegate(params) }, unit.CancelPending, unit.DismissProgress}
		},
	})
}

func TestYieldKeepsTheStateUnitAxioms(t *testing.T) {
	params, err := decoded[api.GenerationJobParams](map[string]any{
		"title":      "A title",
		"storageUri": "file://generated.md",
		"context":    map[string]any{"focus": map[string]any{"kind": "resource", "resource": map[string]any{"@context": "https://schema.org", "@id": "res-1", "name": "A resource", "representations": []any{}}}, "graph": map[string]any{"nodes": []any{}, "edges": []any{}}, "metadata": map[string]any{}},
	})
	if err != nil {
		t.Fatal(err)
	}
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.YieldStateUnit]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.YieldStateUnit] {
			client := clientOf(t, xynologtest.FaultyConfig{})
			unit := state.NewYieldStateUnit(client, "en")
			return xynologtest.Fresh[*state.YieldStateUnit]{Unit: unit}.With(xynologtest.TheClient(client))
		},
		Surfaces: func(unit *state.YieldStateUnit) []xynologtest.Surface {
			return []xynologtest.Surface{
				xynologtest.Watching(unit.IsGenerating()),
				xynologtest.Watching(unit.Progress()),
				xynologtest.Watching(unit.Outcome()),
				xynologtest.Watching(unit.Failure()),
				xynologtest.Watching(unit.JobId()),
			}
		},
		Invocations: func(unit *state.YieldStateUnit) []func() {
			return []func(){func() { unit.Generate(params, 0) }, unit.DismissProgress}
		},
	})
}

func TestGatherKeepsTheStateUnitAxioms(t *testing.T) {
	annotation := idOf[api.AnnotationId](t, "ann-1")
	resource := idOf[api.ResourceId](t, "res-1")
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.GatherStateUnit]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.GatherStateUnit] {
			client := clientOf(t, xynologtest.FaultyConfig{})
			unit := state.NewGatherStateUnit(client, resource)
			return xynologtest.Fresh[*state.GatherStateUnit]{Unit: unit}.With(xynologtest.TheClient(client))
		},
		Surfaces: func(unit *state.GatherStateUnit) []xynologtest.Surface {
			return []xynologtest.Surface{
				xynologtest.Watching(unit.Context()),
				xynologtest.Watching(unit.Loading()),
				xynologtest.Watching(unit.Error()),
				xynologtest.Watching(unit.AnnotationId()),
				xynologtest.Watching(unit.ResourceContext()),
				xynologtest.Watching(unit.ResourceLoading()),
				xynologtest.Watching(unit.ResourceError()),
			}
		},
		Invocations: func(unit *state.GatherStateUnit) []func() {
			return []func(){
				func() { unit.GatherAnnotation(annotation, api.GatherAnnotationOptions{}) },
				func() { unit.GatherResource(resource, xynolog.GatherResourceDefaults()) },
			}
		},
	})
}

func TestMatchKeepsTheStateUnitAxioms(t *testing.T) {
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.MatchStateUnit]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.MatchStateUnit] {
			// Over a client's stream, where nothing answers.
			client := clientOf(t, xynologtest.FaultyConfig{Schedule: []xynologtest.FaultAction{xynologtest.DropReply{}}, MakeResponse: never})
			unit := state.NewMatchStateUnit(client)
			return xynologtest.Fresh[*state.MatchStateUnit]{Unit: unit}.With(xynologtest.TheClient(client))
		},
	})
}

func TestBeckonKeepsTheStateUnitAxioms(t *testing.T) {
	annotation := idOf[api.AnnotationId](t, "ann-1")
	resource := idOf[api.ResourceId](t, "res-1")
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.BeckonStateUnit]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.BeckonStateUnit] {
			client := clientOf(t, xynologtest.FaultyConfig{})
			unit := state.NewBeckonStateUnit(client, resource)
			return xynologtest.Fresh[*state.BeckonStateUnit]{Unit: unit}.With(xynologtest.TheClient(client))
		},
		Surfaces: func(unit *state.BeckonStateUnit) []xynologtest.Surface {
			return []xynologtest.Surface{xynologtest.Watching(unit.HoveredAnnotationId())}
		},
		Invocations: func(unit *state.BeckonStateUnit) []func() {
			return []func(){func() { unit.Focus(annotation) }}
		},
	})
}

func TestTheDwellKeepsTheStateUnitAxioms(t *testing.T) {
	annotation := idOf[api.AnnotationId](t, "ann-1")
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.HoverDwell]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.HoverDwell] {
			// What it says is said to nobody.
			return xynologtest.Fresh[*state.HoverDwell]{Unit: state.NewHoverDwell(func(*api.AnnotationId) {}, timing.HoverDelay)}
		},
		Invocations: func(unit *state.HoverDwell) []func() {
			return []func(){func() { unit.Enter(annotation) }, unit.Leave}
		},
	})
}

// neverAnswered is a search whose answer never comes.
func neverAnswered(ctx context.Context, _ string) iter.Seq2[[]string, bool] {
	return func(func([]string, bool) bool) { <-ctx.Done() }
}

func TestTheSearchPipelineKeepsTheStateUnitAxioms(t *testing.T) {
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*state.SearchPipeline[string]]{
		Setup: func(t *testing.T) xynologtest.Fresh[*state.SearchPipeline[string]] {
			return xynologtest.Fresh[*state.SearchPipeline[string]]{Unit: state.NewSearchPipeline(neverAnswered, timing.SearchDebounce, "")}
		},
		Surfaces: func(unit *state.SearchPipeline[string]) []xynologtest.Surface {
			return []xynologtest.Surface{xynologtest.Watching(unit.Query()), xynologtest.Watching(unit.State())}
		},
		Invocations: func(unit *state.SearchPipeline[string]) []func() {
			return []func(){func() { unit.SetQuery("paris") }, func() { unit.SetQuery("rome") }}
		},
	})
}

// ── What else a case cannot state ───────────────────────────────────────

func TestAStateSetToWhatItAlreadyHoldsWakesNobody(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		client := clientOf(t, xynologtest.FaultyConfig{})
		unit := state.NewBeckonStateUnit(client, idOf[api.ResourceId](t, "res-1"))
		defer unit.Close()
		annotation := idOf[api.AnnotationId](t, "ann-1")
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()
		var mu sync.Mutex
		var given []api.AnnotationId
		go func() {
			for hovered := range unit.HoveredAnnotationId().Changes(ctx) {
				mu.Lock()
				given = append(given, hovered)
				mu.Unlock()
			}
		}()
		seen := func() []api.AnnotationId {
			synctest.Wait()
			mu.Lock()
			defer mu.Unlock()
			return slices.Clone(given)
		}
		if got := seen(); !slices.Equal(got, []api.AnnotationId{{}}) {
			t.Fatalf("a reader was first given %v, not none", got)
		}
		client.Beckon.Hover(&annotation)
		if got := seen(); !slices.Equal(got, []api.AnnotationId{{}, annotation}) {
			t.Fatalf("a hover gave the reader %v", got)
		}
		client.Beckon.Hover(&annotation)
		if got := seen(); len(got) != 2 {
			t.Fatalf("the same hover again woke the reader: %v", got)
		}
	})
}

func TestASearchThatIsAbandonedIsLetGo(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		var mu sync.Mutex
		var letGo []string
		remembered := func(ctx context.Context, query string) iter.Seq2[[]string, bool] {
			return func(func([]string, bool) bool) {
				<-ctx.Done()
				mu.Lock()
				letGo = append(letGo, query)
				mu.Unlock()
			}
		}
		released := func() []string {
			synctest.Wait()
			mu.Lock()
			defer mu.Unlock()
			return slices.Clone(letGo)
		}
		settled := timing.SearchDebounce + 2*time.Millisecond
		pipeline := state.NewSearchPipeline(remembered, timing.SearchDebounce, "paris")
		time.Sleep(settled)
		if got := released(); len(got) != 0 {
			t.Fatalf("a search under way was let go: %v", got)
		}
		pipeline.SetQuery("rome")
		time.Sleep(settled)
		if got := released(); !slices.Equal(got, []string{"paris"}) {
			t.Fatalf("the abandoned search was not let go: %v", got)
		}
		// And the one under way when the pipeline ends.
		pipeline.Close()
		if got := released(); !slices.Equal(got, []string{"paris", "rome"}) {
			t.Fatalf("the search under way at the end was not let go: %v", got)
		}
	})
}

func TestMarkParamsThatStateNoMotivationTheUnionMapsAreNoJobs(t *testing.T) {
	for _, stated := range []struct{ name, params string }{
		{"no motivation", `{}`},
		{"a motivation no member is", `{"motivation":"bogus"}`},
	} {
		t.Run(stated.name, func(t *testing.T) {
			synctest.Test(t, func(t *testing.T) {
				var params api.MarkJobParams
				if err := json.Unmarshal([]byte(stated.params), &params); err != nil {
					t.Fatal(err)
				}
				made := xynologtest.NewTestClient(xynologtest.TestClientConfig{Transport: xynologtest.NewFaultyTransport(xynologtest.FaultyConfig{Channels: bus.BridgedChannels}), Timing: xynolog.DefaultClientTiming()})
				defer made.Transport.Close()
				defer made.Client.Close()
				unit := state.NewMarkStateUnit(made.Client, idOf[api.ResourceId](t, "res-1"))
				defer unit.Close()
				unit.RequestDelegate(params)
				synctest.Wait()
				if sent := made.Transport.RequestLog(); len(sent) != 0 {
					t.Fatalf("requests were sent: %v", sent)
				}
				if unit.Failure().Value() == nil {
					t.Error("the unit holds no failure")
				}
				if delegating := unit.DelegatingMotivation().Value(); delegating != "" {
					t.Errorf("the unit is delegating %q", delegating)
				}
				if progress := unit.ProgressMotivation().Value(); progress != "" {
					t.Errorf("the unit holds progress of %q", progress)
				}
			})
		})
	}
}

// parameters is what a function takes, its first skip parameters left out.
func parameters(function any, skip int) []reflect.Type {
	of := reflect.TypeOf(function)
	var taken []reflect.Type
	for i := skip; i < of.NumIn(); i++ {
		taken = append(taken, of.In(i))
	}
	return taken
}

var contextType = reflect.TypeFor[context.Context]()

func TestWhatAUnitTakesIsWhatTheNamespaceItCallsTakes(t *testing.T) {
	for _, gate := range []struct {
		name            string
		unit, namespace []reflect.Type
	}{
		// Each after the receiver; the namespace's after its context, or after the resource that is the unit's own.
		{"GatherStateUnit.GatherResource and GatherNamespace.Resource", parameters((*state.GatherStateUnit).GatherResource, 1), parameters((*xynolog.GatherNamespace).Resource, 2)},
		{"GatherStateUnit.GatherAnnotation and GatherNamespace.Annotation", parameters((*state.GatherStateUnit).GatherAnnotation, 1), parameters((*xynolog.GatherNamespace).Annotation, 2)},
		{"YieldStateUnit.Generate and YieldNamespace.Delegate", parameters((*state.YieldStateUnit).Generate, 1), parameters((*xynolog.YieldNamespace).Delegate, 1)},
		{"MarkStateUnit.RequestDelegate and MarkNamespace.Delegate", parameters((*state.MarkStateUnit).RequestDelegate, 1), parameters((*xynolog.MarkNamespace).Delegate, 2)},
	} {
		if slices.Contains(gate.namespace, contextType) {
			t.Errorf("%s: the namespace's context is not skipped", gate.name)
		}
		if !slices.Equal(gate.unit, gate.namespace) {
			t.Errorf("%s take %v and %v", gate.name, gate.unit, gate.namespace)
		}
	}
}

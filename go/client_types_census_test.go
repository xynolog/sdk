package xynolog_test

// SearchState, JobEvent and CacheState are generic, so they are written by
// hand; this census holds each to its schema in
// protocol/specs/src/client/types. SearchState's members and a refusal's are
// read off the types, so a member either side gains or loses fails.
// JobEvent's and CacheState's branches are the lists below, since nothing
// names every type of an interface: a branch the schema gains fails, and one
// the SDK gains is caught only by its listing here.

import (
	"encoding/json"
	"os"
	"path/filepath"
	"reflect"
	"slices"
	"strings"
	"testing"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/state"
)

type objectSchema struct {
	Properties map[string]struct {
		Enum       []string                   `json:"enum"`
		Properties map[string]json.RawMessage `json:"properties"`
	} `json:"properties"`
}

func clientType[T any](t *testing.T, name string) T {
	t.Helper()
	text, err := os.ReadFile(filepath.Join("..", "protocol", "specs", "src", "client", "types", name+".json"))
	if err != nil {
		t.Fatal(err)
	}
	var schema T
	if err := json.Unmarshal(text, &schema); err != nil {
		t.Fatal(err)
	}
	return schema
}

func sortedKeys[V any](m map[string]V) []string {
	keys := make([]string, 0, len(m))
	for key := range m {
		keys = append(keys, key)
	}
	slices.Sort(keys)
	return keys
}

// jsonMembers is the members t is written as JSON with, by its tags.
func jsonMembers(t reflect.Type) []string {
	members := make([]string, 0, t.NumField())
	for i := range t.NumField() {
		name, _, _ := strings.Cut(t.Field(i).Tag.Get("json"), ",")
		members = append(members, name)
	}
	slices.Sort(members)
	return members
}

func TestSearchStateHasTheSchemasMembers(t *testing.T) {
	schema := clientType[objectSchema](t, "SearchState")
	if got, want := jsonMembers(reflect.TypeFor[state.SearchState[any]]()), sortedKeys(schema.Properties); !slices.Equal(got, want) {
		t.Fatalf("SearchState is written with %v, and the schema states %v", got, want)
	}
}

// jobEvents is one of each JobEvent, each carrying what it must to be
// written.
func jobEvents(t *testing.T) []xynolog.JobEvent {
	t.Helper()
	job, err := api.ParseJobId("job-1")
	if err != nil {
		t.Fatal(err)
	}
	resource, err := api.ParseResourceId("res-1")
	if err != nil {
		t.Fatal(err)
	}
	return []xynolog.JobEvent{
		xynolog.JobCreated{Data: api.JobCreatedResultResponse{JobId: job}},
		xynolog.JobProgressed{},
		xynolog.JobAttemptFailed{Data: api.JobFailCommand{Error: "failed", JobId: job, JobType: api.JobTypeMark, ResourceId: resource}},
		xynolog.JobRefused{},
		xynolog.JobCompleted[any]{},
	}
}

func TestJobEventHasTheSchemasBranchesEachOfItsMembers(t *testing.T) {
	schema := clientType[struct{ OneOf []objectSchema }](t, "JobEvent")
	branches := map[string]objectSchema{}
	for _, branch := range schema.OneOf {
		branches[branch.Properties["kind"].Enum[0]] = branch
	}
	written := map[string][]string{}
	for _, event := range jobEvents(t) {
		text, err := json.Marshal(event)
		if err != nil {
			t.Fatal(err)
		}
		var members map[string]json.RawMessage
		if err := json.Unmarshal(text, &members); err != nil {
			t.Fatal(err)
		}
		var kind string
		if err := json.Unmarshal(members["kind"], &kind); err != nil {
			t.Fatal(err)
		}
		written[kind] = sortedKeys(members)
	}
	if got, want := sortedKeys(written), sortedKeys(branches); !slices.Equal(got, want) {
		t.Fatalf("JobEvent is of the kinds %v, and the schema states %v", got, want)
	}
	for kind, members := range written {
		if want := sortedKeys(branches[kind].Properties); !slices.Equal(members, want) {
			t.Errorf("a %s event is written with %v, and the schema states %v", kind, members, want)
		}
	}
	got := jsonMembers(reflect.TypeFor[xynolog.JobRefused]().Field(0).Type)
	if want := sortedKeys(branches["refused"].Properties["data"].Properties); !slices.Equal(got, want) {
		t.Fatalf("a refusal's data is written with %v, and the schema states %v", got, want)
	}
}

// cacheStates is one of each CacheState.
var cacheStates = []xynolog.CacheState[any]{
	xynolog.Pending[any]{},
	xynolog.Ready[any]{},
	xynolog.Failed[any]{},
}

func TestCacheStateHasTheSchemasBranchesEachOfItsMembers(t *testing.T) {
	schema := clientType[struct{ OneOf []objectSchema }](t, "CacheState")
	branches := map[string]objectSchema{}
	for _, branch := range schema.OneOf {
		branches[branch.Properties["status"].Enum[0]] = branch
	}
	statuses := []string{}
	for _, state := range cacheStates {
		statuses = append(statuses, string(state.Status()))
	}
	slices.Sort(statuses)
	if want := sortedKeys(branches); !slices.Equal(statuses, want) {
		t.Fatalf("CacheState is of the statuses %v, and the schema states %v", statuses, want)
	}
	for _, state := range cacheStates {
		status := string(state.Status())
		typ := reflect.TypeOf(state)
		members := []string{"status"}
		for i := range typ.NumField() {
			members = append(members, strings.ToLower(typ.Field(i).Name))
		}
		slices.Sort(members)
		if want := sortedKeys(branches[status].Properties); !slices.Equal(members, want) {
			t.Errorf("a %s state holds %v, and the schema states %v", status, members, want)
		}
	}
}

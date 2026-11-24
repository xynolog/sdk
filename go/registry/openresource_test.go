package registry_test

import (
	"testing"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/optional"
	"github.com/xynolog/sdk/go/registry"
)

func tab(named string, openedAt, order int) api.OpenResource {
	plain := "text/plain"
	return api.OpenResource{Id: id(named), Name: "name of " + named, OpenedAt: openedAt, Order: order, MediaType: &plain}
}

func ids(list []api.OpenResource) []string {
	var named []string
	for _, each := range list {
		named = append(named, each.Id.String())
	}
	return named
}

func TestTheyAreOrderedByPlaceAndThenByWhenTheyWereOpened(t *testing.T) {
	sorted := registry.SortOpenResources([]api.OpenResource{tab("b", 20, 1), tab("a", 30, 0), tab("d", 15, 1), tab("c", 10, 2)})
	if got := ids(sorted); !equalStrings(got, []string{"a", "d", "b", "c"}) {
		t.Errorf("sorted: %v", got)
	}
}

func TestOnlyAResourceTheKnowledgeBaseSaysIsGoneIsDropped(t *testing.T) {
	var gone, found, unknown api.TabCheck
	must(t, gone.From(api.TabCheckGone{}))
	must(t, found.From(api.TabCheckReady{Name: "Its name now"}))
	must(t, unknown.From(api.TabCheckUnknown{}))
	byID := map[api.ResourceId]api.TabCheck{id("gone"): gone, id("found"): found, id("unknown"): unknown}
	kept := registry.ApplyTabChecks([]api.OpenResource{tab("gone", 1, 0), tab("found", 2, 1), tab("unknown", 3, 2), tab("opened-meanwhile", 4, 3)}, byID)
	if got := ids(kept); !equalStrings(got, []string{"found", "unknown", "opened-meanwhile"}) {
		t.Fatalf("kept: %v", got)
	}
	if kept[0].Name != "Its name now" {
		t.Errorf("what was found is named %q", kept[0].Name)
	}
	// A check that states no media type leaves the one it had.
	if optional.Said(kept[0].MediaType) != "text/plain" {
		t.Errorf("what was found has the media type %v", kept[0].MediaType)
	}
	if kept[1].Name != "name of unknown" {
		t.Errorf("what is unknown is named %q", kept[1].Name)
	}
}

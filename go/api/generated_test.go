package api_test

// What types_gen.go writes of each kind of schema: a union told apart by a
// property is read as the member its value names, an enum admits its values
// and nothing else, and a list a schema requires is written as the empty list
// where Go holds it as nil.

import (
	"encoding/json"
	"reflect"
	"strings"
	"testing"

	"github.com/xynolog/sdk/go/api"
)

func TestADiscoveryReadIsTheMemberItsKindNames(t *testing.T) {
	for wire, member := range map[string]any{
		`{"kind":"absent","reason":"not-found"}`: api.DiscoveryAbsent{},
		`{"kind":"managed","kbs":[]}`:            api.DiscoveryManaged{},
		`{"kind":"unchanged"}`:                   api.DiscoveryUnchanged{},
	} {
		var read api.DiscoveryRead
		if err := json.Unmarshal([]byte(wire), &read); err != nil {
			t.Fatalf("%s: %v", wire, err)
		}
		kind, err := read.Discriminator()
		if err != nil || !strings.Contains(wire, `"kind":"`+kind+`"`) {
			t.Errorf("%s: its kind is %q (%v)", wire, kind, err)
		}
		m, err := read.Member()
		if err != nil {
			t.Errorf("%s: %v", wire, err)
		} else if reflect.TypeOf(m) != reflect.TypeOf(member) {
			t.Errorf("%s: read as %T, where it is a %T", wire, m, member)
		}
	}
}

func TestADiscoveryStateIsAbsentOrManagedAndNeverUnchanged(t *testing.T) {
	for wire, member := range map[string]any{
		`{"kind":"absent","reason":"invalid","diagnostic":"no kbs"}`: api.DiscoveryAbsent{},
		`{"kind":"managed","kbs":[]}`:                                api.DiscoveryManaged{},
	} {
		var state api.DiscoveryState
		if err := json.Unmarshal([]byte(wire), &state); err != nil {
			t.Fatalf("%s: %v", wire, err)
		}
		kind, err := state.Discriminator()
		if err != nil || !strings.Contains(wire, `"kind":"`+kind+`"`) {
			t.Errorf("%s: its kind is %q (%v)", wire, kind, err)
		}
		if m, err := state.Member(); err != nil {
			t.Errorf("%s: %v", wire, err)
		} else if reflect.TypeOf(m) != reflect.TypeOf(member) {
			t.Errorf("%s: read as %T, where it is a %T", wire, m, member)
		}
	}
	var state api.DiscoveryState
	if err := json.Unmarshal([]byte(`{"kind":"unchanged"}`), &state); err != nil {
		t.Fatal(err)
	}
	if m, err := state.Member(); err == nil {
		t.Errorf("an unchanged read is a state, read as %T", m)
	}
}

func TestAnEnumAdmitsItsValuesAndNoOther(t *testing.T) {
	type enum interface{ Valid() bool }
	for name, values := range map[string][2]enum{
		"CacheStatus":           {api.CacheStatusPending, api.CacheStatus("stale")},
		"ConnectionState":       {api.ConnectionStateInitial, api.ConnectionState("asleep")},
		"ControlSender":         {api.ControlSenderClient, api.ControlSender("nobody")},
		"DiscoveryAbsentReason": {api.DiscoveryAbsentReasonNotFound, api.DiscoveryAbsentReason("lost")},
		"DiscoveryManagedKind":  {api.DiscoveryManagedKindManaged, api.DiscoveryManagedKind("absent")},
		"DiscoveryUnchangedKind": {
			api.DiscoveryUnchangedKindUnchanged, api.DiscoveryUnchangedKind("managed"),
		},
		"KbPlacement":       {api.KbPlacementLocal, api.KbPlacement("moon")},
		"InferenceProvider": {api.InferenceProviderAnthropic, api.InferenceProvider("oracle")},
		"System":            {api.SystemMacos, api.System("plan9")},
		"LimitRefusalsItemCode": {
			api.ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCodeStreams,
			api.ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode("patience"),
		},
		"DateTimeFormat": {
			api.ClientOptionDefaultsDefaultsItemSchemaDateTimeFormatDateTime,
			api.ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat("date"),
		},
		"DateTimeType": {
			api.ClientOptionDefaultsDefaultsItemSchemaDateTimeTypeInteger,
			api.ClientOptionDefaultsDefaultsItemSchemaDateTimeType("boolean"),
		},
		"DecidedIn": {
			api.ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedInTakes,
			api.ClientOptionDefaultsDefaultsItemSchemaDecidedDecidedIn("nowhere"),
		},
	} {
		if !values[0].Valid() {
			t.Errorf("%s refuses %v, one of its values", name, values[0])
		}
		if values[1].Valid() {
			t.Errorf("%s admits %v, none of its values", name, values[1])
		}
	}
}

func TestAListItsSchemaRequiresIsWrittenEmptyWhereGoHoldsNil(t *testing.T) {
	var diff api.DiscoveryDiff
	if err := diff.State.From(api.DiscoveryManaged{}); err != nil {
		t.Fatal(err)
	}
	for _, c := range []struct {
		value any
		lists []string
	}{
		{api.ClientConnectionStates{}, []string{"states"}},
		{api.ClientConnectionStatesStatesItem{State: api.ConnectionStateOpen}, []string{"moves"}},
		{api.ClientOptionDefaults{}, []string{"defaults"}},
		{api.ControlRpcCodes{}, []string{"codes"}},
		{api.PrincipalsRoles{}, []string{"roles"}},
		{api.DiscoveryManaged{Kind: api.DiscoveryManagedKindManaged}, []string{"kbs"}},
		{diff, []string{"added", "updated", "removed", "duplicated"}},
	} {
		written, err := json.Marshal(c.value)
		if err != nil {
			t.Errorf("%T: %v", c.value, err)
			continue
		}
		var members map[string]json.RawMessage
		if err := json.Unmarshal(written, &members); err != nil {
			t.Fatalf("%T: %v", c.value, err)
		}
		for _, list := range c.lists {
			if string(members[list]) != "[]" {
				t.Errorf("%T writes its %s as %s", c.value, list, members[list])
			}
		}
	}
	var written struct {
		State map[string]json.RawMessage `json:"state"`
	}
	raw, err := json.Marshal(diff)
	if err != nil {
		t.Fatal(err)
	}
	if err := json.Unmarshal(raw, &written); err != nil {
		t.Fatal(err)
	}
	if string(written.State["kind"]) != `"managed"` || string(written.State["kbs"]) != "[]" {
		t.Errorf("a diff writes its state as %s", raw)
	}
}

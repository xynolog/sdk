package api_test

// A union is read as the one member whose schema admits a value; a value one
// member names but does not admit is refused for what is wrong with it as that
// member, and a value none names for the values its members state.

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/xynolog/sdk/go/api"
)

func answer(t *testing.T, wire string) (any, error) {
	t.Helper()
	var u api.AnchoredTextAnswer
	if err := json.Unmarshal([]byte(wire), &u); err != nil {
		t.Fatalf("%s: %v", wire, err)
	}
	return u.Member()
}

func TestAUnionIsReadAsTheOneMemberThatAdmitsAValue(t *testing.T) {
	if m, err := answer(t, `{"kind":"no-map"}`); err != nil {
		t.Errorf("an absence: %v", err)
	} else if _, ok := m.(api.AnchoredTextAbsent); !ok {
		t.Errorf("an absence read as %T", m)
	}
	if m, err := answer(t, `{"kind":"declined","declined":"encrypted"}`); err != nil {
		t.Errorf("a decline: %v", err)
	} else if _, ok := m.(api.ExtractionDeclined); !ok {
		t.Errorf("a decline read as %T", m)
	}
	for wire, refusal := range map[string]string{
		`{"kind":"declined"}`: `that is a ExtractionDeclined lacks the member "declined"`,
		`{"kind":"later"}`:    "kind is none of extracted, declined, not-yet, no-map, unknown",
	} {
		_, err := answer(t, wire)
		if err == nil || !strings.Contains(err.Error(), refusal) {
			t.Errorf("%s: %v, where the refusal says %q", wire, err, refusal)
		}
	}
}

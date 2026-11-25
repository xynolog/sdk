package api

// What a union's member table admits, of each kind of value a signature
// states: a value is read as the one member that admits it, a value one
// member names is refused for what keeps that member from admitting it, and
// any other for being none of the members.

import (
	"encoding/json"
	"errors"
	"reflect"
	"strings"
	"testing"
)

var toldMembers = []unionMember{
	{"Word", readAs[string], []signature{{kind: textKind, values: []any{"a", "b"}}}},
	{"Count", readAs[int], []signature{{kind: integerKind}}},
	{"Flag", readAs[bool], []signature{{kind: booleanKind}}},
	{"Items", readAs[[]any], []signature{{kind: listKind}}},
	{"Shut", readAs[map[string]any], []signature{{kind: objectKind, required: []string{"n"}, allowed: []string{"n"}, fixed: []fixedValues{{"n", []any{1, true}}}}}},
}

func readTold(wire string) (any, error) {
	return union[any]{raw: json.RawMessage(wire)}.member("Told", toldMembers)
}

func TestAMemberIsReadAsTheOneThatAdmitsIt(t *testing.T) {
	for _, c := range []struct {
		wire string
		want any
	}{
		{`"a"`, "a"},
		{`3`, 3},
		{`true`, true},
		{`[1]`, []any{1.0}},
		{`{"n":1}`, map[string]any{"n": 1.0}},
		{`{"n":true}`, map[string]any{"n": true}},
	} {
		got, err := readTold(c.wire)
		if err != nil || !reflect.DeepEqual(got, c.want) {
			t.Errorf("%s: %#v, %v; want %#v", c.wire, got, err, c.want)
		}
	}
}

func TestAValueNoMemberAdmitsIsRefused(t *testing.T) {
	for wire, refusal := range map[string]string{
		`{"n":1,"m":2}`: `a Told that is a Shut carries the member "m"`,
		`{}`:            `a Told that is a Shut lacks the member "n"`,
		`{"n":2}`:       "a Told that is none of its members",
		`"c"`:           "a Told that is none of its members",
		`2.5`:           "a Told that is none of its members",
		`null`:          "a Told that is none of its members",
	} {
		_, err := readTold(wire)
		if err == nil || !strings.Contains(err.Error(), refusal) {
			t.Errorf("%s: %v, where the refusal says %q", wire, err, refusal)
		}
	}
	if _, err := readTold(`{`); err == nil {
		t.Error("a value that is no JSON is read")
	}
	if _, err := (union[any]{}).member("Told", toldMembers); !errors.Is(err, errNoMember) {
		t.Errorf("a union that holds no member: %v", err)
	}
}

func TestAKindAdmitsItsValuesAlone(t *testing.T) {
	values := []any{"t", 1.0, 1.5, true, []any{}, map[string]any{}, nil}
	admits := map[kind][]bool{
		textKind:    {true, false, false, false, false, false, false},
		integerKind: {false, true, false, false, false, false, false},
		numberKind:  {false, true, true, false, false, false, false},
		booleanKind: {false, false, false, true, false, false, false},
		listKind:    {false, false, false, false, true, false, false},
		objectKind:  {false, false, false, false, false, true, false},
		nullKind:    {false, false, false, false, false, false, true},
		anyKind:     {true, true, true, true, true, true, true},
	}
	for k, want := range admits {
		for at, value := range values {
			if k.of(value) != want[at] {
				t.Errorf("kind %d of %#v: %v", k, value, !want[at])
			}
		}
	}
	if textKind.of(struct{}{}) {
		t.Error("a value no JSON reads as is of a kind")
	}
}

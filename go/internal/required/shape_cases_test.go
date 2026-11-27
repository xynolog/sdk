package required

// protocol/specs/src/client/shape-cases.json: the table every SDK's reading of
// a value runs. Each case's value is held to the schema it names, and its first
// fault is the one the case states, or none.

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/xynolog/sdk/go/api"
)

type shapeCase struct {
	Why     string                 `json:"why"`
	Schema  string                 `json:"schema"`
	Value   json.RawMessage        `json:"value"`
	Refused bool                   `json:"refused"`
	Member  string                 `json:"member"`
	Reason  api.FrameRefusalReason `json:"reason"`
}

func TestShapeCases(t *testing.T) {
	text, err := os.ReadFile(filepath.Join("..", "..", "..", "protocol", "specs", "src", "client", "shape-cases.json"))
	if err != nil {
		t.Fatal(err)
	}
	var table struct {
		Cases []shapeCase `json:"cases"`
	}
	if err := json.Unmarshal(text, &table); err != nil {
		t.Fatal(err)
	}
	if len(table.Cases) == 0 {
		t.Fatal("shape-cases.json states no case")
	}
	for _, c := range table.Cases {
		t.Run(c.Why, func(t *testing.T) {
			if _, named := schemas()[c.Schema]; !named {
				t.Fatalf("the table has no schema %s", c.Schema)
			}
			var value any
			if err := json.Unmarshal(c.Value, &value); err != nil {
				t.Fatal(err)
			}
			want := none
			if c.Refused {
				want = api.Fault{Member: c.Member, Reason: c.Reason}
			}
			fault, _, faulty := faultOf(&shape{Ref: c.Schema}, value, "")
			if faulty != c.Refused || fault != want {
				t.Errorf("%s as %s has the fault %+v (%v), not %+v", c.Value, c.Schema, fault, faulty, want)
			}
		})
	}
}

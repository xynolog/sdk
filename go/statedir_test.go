package xynolog_test

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// The state home, as every program that finds tokens.json computes it
// (protocol/specs/src/sign-in-store/cases.json).
func TestTheStateHomeIsTheTables(t *testing.T) {
	b, err := os.ReadFile(filepath.Join("..", "protocol", "specs", "src", "sign-in-store", "cases.json"))
	if err != nil {
		t.Fatal(err)
	}
	var table struct {
		Cases []struct {
			Why          string     `json:"why"`
			OS           api.System `json:"os"`
			Home         *string    `json:"home"`
			XDGStateHome *string    `json:"xdgStateHome"`
			LocalAppData *string    `json:"localAppData"`
			Dir          *string    `json:"dir"`
		} `json:"cases"`
	}
	if err := json.Unmarshal(b, &table); err != nil {
		t.Fatal(err)
	}
	if len(table.Cases) == 0 {
		t.Fatal("the table states no cases: this test would pass for the wrong reason")
	}
	// null in the table: not set, which "" is to StateDir.
	set := func(s *string) string {
		if s == nil {
			return ""
		}
		return *s
	}
	for _, c := range table.Cases {
		dir, ok := xynolog.StateDir(c.OS, set(c.Home), set(c.XDGStateHome), set(c.LocalAppData))
		switch {
		case c.Dir == nil && ok:
			t.Errorf("%s: a state home %q, want none", c.Why, dir)
		case c.Dir != nil && !ok:
			t.Errorf("%s: no state home, want %q", c.Why, *c.Dir)
		case c.Dir != nil && dir != *c.Dir:
			t.Errorf("%s: the state home is %q, want %q", c.Why, dir, *c.Dir)
		}
	}
}

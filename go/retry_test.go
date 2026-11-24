package xynolog_test

// Trying again, held to the cases every SDK runs (protocol/specs/src/retry/cases.json).
// retry_gen.go writes every rule of retry/rules.json, and the cases name each.

import (
	"encoding/json"
	"os"
	"path/filepath"
	"sort"
	"testing"
	"time"

	xynolog "github.com/xynolog/sdk/go"
)

// retryRow is one of the table's rules rows. A row that omits `keyed` states a
// request with no key, so Keyed is false for it.
type retryRow struct {
	Why     string  `json:"why"`
	Rule    string  `json:"rule"`
	Status  *int    `json:"status"`
	Method  *string `json:"method"`
	Keyed   bool    `json:"keyed"`
	Retries bool    `json:"retries"`
}

type statedWait struct {
	Why    string  `json:"why"`
	Header *string `json:"header"`
	Ms     *int64  `json:"ms"`
}

func readRetryTable(t *testing.T) (rules []retryRow, waits []statedWait) {
	t.Helper()
	b, err := os.ReadFile(filepath.Join("..", "protocol", "specs", "src", "retry", "cases.json"))
	if err != nil {
		t.Fatal(err)
	}
	var table struct {
		Rules      []retryRow   `json:"rules"`
		RetryAfter []statedWait `json:"retryAfter"`
	}
	if err := json.Unmarshal(b, &table); err != nil {
		t.Fatal(err)
	}
	if len(table.Rules) == 0 || len(table.RetryAfter) == 0 {
		t.Fatal("the table states no rules or no waits: every test below would pass for the wrong reason")
	}
	return table.Rules, table.RetryAfter
}

func keptRules() map[string]xynolog.RetryRule {
	kept := map[string]xynolog.RetryRule{}
	for _, rule := range xynolog.RetryRules() {
		kept[rule.Name] = rule
	}
	return kept
}

func TestTheCasesNameEveryRule(t *testing.T) {
	rows, _ := readRetryTable(t)
	stated := map[string]bool{}
	for _, row := range rows {
		stated[row.Rule] = true
	}
	kept := keptRules()
	var missing []string
	for name := range stated {
		if _, isKept := kept[name]; !isKept {
			missing = append(missing, name)
		}
	}
	for name := range kept {
		if !stated[name] {
			missing = append(missing, name)
		}
	}
	sort.Strings(missing)
	if len(missing) > 0 {
		t.Fatalf("each rule is one the cases name and RetryRules keeps: %v", missing)
	}
}

func TestARuleAnswersAsTheTableDoes(t *testing.T) {
	rows, _ := readRetryTable(t)
	kept := keptRules()
	for _, row := range rows {
		rule := kept[row.Rule]
		facts := xynolog.RetryFacts{Status: row.Status, Method: row.Method, Keyed: row.Keyed}
		if got := rule.Retryable(facts); got != row.Retries {
			t.Errorf("%s: %s retries %v; the table says %v", row.Rule, row.Why, got, row.Retries)
		}
	}
}

func TestARetryAfterHeaderStatesTheWaitTheTableGives(t *testing.T) {
	_, waits := readRetryTable(t)
	for _, row := range waits {
		header := ""
		if row.Header != nil {
			header = *row.Header
		}
		wait, ok := xynolog.RetryAfter(header)
		switch {
		case row.Ms == nil && ok:
			t.Errorf("%s: %q states a wait of %v; the table says none", row.Why, header, wait)
		case row.Ms != nil && (!ok || wait != time.Duration(*row.Ms)*time.Millisecond):
			t.Errorf("%s: %q states %v (%v); the table says %d ms", row.Why, header, wait, ok, *row.Ms)
		}
	}
}

func TestJitterStaysBetweenHalfTheCapAndTheCap(t *testing.T) {
	for range 1000 {
		if wait := xynolog.EqualJitter(time.Second, nil); wait < 500*time.Millisecond || wait > time.Second {
			t.Fatalf("a jittered wait of %v, for a cap of 1s", wait)
		}
	}
}

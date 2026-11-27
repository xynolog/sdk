package xynolog_test

// The root package's state units held to the state-unit axioms (the cache,
// the session, the session's signals), what the session's signals' cases in
// protocol/specs/src/client/state-units.json cannot count, and the census that every
// state unit of the module is held to the axioms somewhere.

import (
	"context"
	"io/fs"
	"iter"
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"sync"
	"testing"
	"testing/synctest"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/xynologtest"
)

func TestTheCacheKeepsTheStateUnitAxioms(t *testing.T) {
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*xynolog.Cache[string, int]]{
		Setup: func(t *testing.T) xynologtest.Fresh[*xynolog.Cache[string, int]] {
			fetch := func(context.Context, string) (int, error) { return 1, nil }
			run := func(work func(context.Context)) { go work(context.Background()) }
			return xynologtest.Fresh[*xynolog.Cache[string, int]]{Unit: xynolog.NewCache(fetch, run, nil)}
		},
		// One key observed, and what moves a key.
		Surfaces: func(unit *xynolog.Cache[string, int]) []xynologtest.Surface {
			return []xynologtest.Surface{xynologtest.Events(func(ctx context.Context) iter.Seq[xynolog.CacheState] { return unit.Observe(ctx, "a") })}
		},
		Invocations: func(unit *xynolog.Cache[string, int]) []func() {
			return []func(){func() { unit.Set("a", 1) }, func() { unit.Invalidate("a") }, unit.InvalidateAll}
		},
	})
}

func TestASessionKeepsTheStateUnitAxiomsAndNeverClosesItsClient(t *testing.T) {
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*xynolog.Session]{
		Setup: func(t *testing.T) xynologtest.Fresh[*xynolog.Session] {
			made := xynologtest.NewTestClient(xynologtest.TestClientConfig{Timing: xynolog.DefaultClientTiming()})
			t.Cleanup(func() {
				made.Client.Close()
				made.Transport.Close()
			})
			session, err := xynolog.StartSession(context.Background(), xynolog.SessionConfig{
				Kb:     api.KbTarget{Id: "kb-1"},
				Client: made.Client,
				Token:  xynolog.NewVariable(""),
				Kept:   &xynolog.MemorySignIn{},
				Timing: xynolog.DefaultTransportTiming(),
			})
			if err != nil {
				t.Fatal(err)
			}
			return xynologtest.Fresh[*xynolog.Session]{Unit: session}.With(xynologtest.TheClient(made.Client))
		},
		// Its stream state is its client's, and ends with it; its errors end
		// with the session.
		Surfaces: func(unit *xynolog.Session) []xynologtest.Surface {
			return []xynologtest.Surface{
				xynologtest.Watching(unit.Token()),
				xynologtest.Watching(unit.User()),
				xynologtest.Events(func(context.Context) iter.Seq[xynolog.Error] { return unit.Errors() }),
			}
		},
	})
}

func TestTheSessionSignalsKeepTheStateUnitAxioms(t *testing.T) {
	conflict := api.KbIdentityConflict{ExpectedDid: "did:web:kb.example.org", ObservedDid: "did:web:other.example.org"}
	detail := "no"
	xynologtest.AssertStateUnitAxioms(t, xynologtest.AxiomSubject[*xynolog.SessionSignals]{
		Setup: func(*testing.T) xynologtest.Fresh[*xynolog.SessionSignals] {
			return xynologtest.Fresh[*xynolog.SessionSignals]{Unit: xynolog.NewSessionSignals()}
		},
		Surfaces: func(unit *xynolog.SessionSignals) []xynologtest.Surface {
			return []xynologtest.Surface{
				xynologtest.Watching(unit.SessionEnded()),
				xynologtest.Watching(unit.PermissionDenied()),
				xynologtest.Watching(unit.KbIdentityConflict()),
			}
		},
		Invocations: func(unit *xynolog.SessionSignals) []func() {
			return []func(){
				func() { unit.NotifySessionEnded(api.SessionEndReasonRefused) },
				func() { unit.NotifyPermissionDenied(&detail) },
				func() { unit.NotifyKbIdentityConflict(conflict) },
				unit.AcknowledgeSessionEnded,
				unit.AcknowledgePermissionDenied,
				unit.AcknowledgeKbIdentityConflict,
			}
		},
	})
}

// gathered is each value a reader of watched is given, read on a goroutine
// of its own until ctx is done.
func gathered[T any](ctx context.Context, watched xynolog.Watched[T]) func() []T {
	var mu sync.Mutex
	var given []T
	go func() {
		for value := range watched.Changes(ctx) {
			mu.Lock()
			given = append(given, value)
			mu.Unlock()
		}
	}()
	return func() []T {
		synctest.Wait()
		mu.Lock()
		defer mu.Unlock()
		return slices.Clone(given)
	}
}

func TestASecondOccurrenceIsToldEvenWhenItSaysTheSame(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		signals := xynolog.NewSessionSignals()
		defer signals.Close()
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()
		ended, denied := gathered(ctx, signals.SessionEnded()), gathered(ctx, signals.PermissionDenied())
		if len(ended()) != 1 || len(denied()) != 1 {
			t.Fatal("a reader was not first given what is raised now")
		}
		for occurrence := 2; occurrence <= 3; occurrence++ {
			signals.NotifySessionEnded(api.SessionEndReasonExpired)
			signals.NotifyPermissionDenied(nil)
			told, refused := ended(), denied()
			if len(told) != occurrence || told[occurrence-1] == nil || told[occurrence-1].Reason != api.SessionEndReasonExpired {
				t.Fatalf("occurrence %d of the session's end was not told: %v", occurrence, told)
			}
			if len(refused) != occurrence || refused[occurrence-1] == nil || refused[occurrence-1].Detail != nil {
				t.Fatalf("occurrence %d of the refusal was not told: %v", occurrence, refused)
			}
		}
	})
}

// ── The census ──────────────────────────────────────────────────────────

var (
	// declaredUnit is a type said to be a StateUnit where it is declared.
	declaredUnit = regexp.MustCompile(`(?m)^\s*(?:var\s+)?_\s+(?:xynolog\.)?StateUnit\s*=\s*\(\*(\w+)`)
	// heldUnit is a unit a test hands to the axioms.
	heldUnit = regexp.MustCompile(`AxiomSubject\[\*(?:\w+\.)?(\w+)`)
	// commentLine is a line that is only a comment.
	commentLine = regexp.MustCompile(`(?m)^\s*//.*$`)
)

func TestEveryStateUnitIsHeldToTheAxioms(t *testing.T) {
	declared := map[string]string{}
	held := map[string]bool{}
	err := filepath.WalkDir(".", func(path string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		// The test double's probe and the conformance drivers are no unit of the SDK's.
		if entry.IsDir() && (path == "xynologtest" || path == "conformance") {
			return filepath.SkipDir
		}
		if entry.IsDir() || !strings.HasSuffix(path, ".go") {
			return nil
		}
		text, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		code := commentLine.ReplaceAllString(string(text), "")
		if strings.HasSuffix(path, "_test.go") {
			for _, match := range heldUnit.FindAllStringSubmatch(code, -1) {
				held[match[1]] = true
			}
			return nil
		}
		for _, match := range declaredUnit.FindAllStringSubmatch(code, -1) {
			declared[match[1]] = path
		}
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
	for _, known := range []string{"Cache", "Session", "SessionSignals", "MarkStateUnit", "SearchPipeline"} {
		if _, ok := declared[known]; !ok {
			t.Fatalf("the census read no %s: it reads no unit where it should", known)
		}
	}
	for unit, path := range declared {
		if !held[unit] {
			t.Errorf("%s: %s is a StateUnit that no test holds to the axioms (xynologtest.AssertStateUnitAxioms)", path, unit)
		}
	}
}

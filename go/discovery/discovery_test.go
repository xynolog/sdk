package discovery_test

// The knowledge bases a launcher manages: what its document says, and what
// changed between two readings of it.

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"reflect"
	"slices"
	"strings"
	"sync"
	"testing"
	"testing/synctest"
	"time"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/discovery"
)

func entry(host string, port int, did string) map[string]any {
	return map[string]any{
		"host": host, "port": port, "placement": "local",
		"managedBy": "xynolog-launcher", "did": did,
	}
}

func written(t *testing.T, value any) string {
	t.Helper()
	text, err := json.Marshal(value)
	if err != nil {
		t.Fatal(err)
	}
	return string(text)
}

func document(t *testing.T, kbs ...any) string {
	t.Helper()
	if kbs == nil {
		kbs = []any{}
	}
	return written(t, map[string]any{"version": 1, "kbs": kbs})
}

func kb(t *testing.T, value map[string]any) api.DiscoveredKB {
	t.Helper()
	var read api.DiscoveredKB
	if err := json.Unmarshal([]byte(written(t, value)), &read); err != nil {
		t.Fatalf("a discovered knowledge base: %v", err)
	}
	return read
}

// stateOf is text read as the document's state.
func stateOf(t *testing.T, text string) api.DiscoveryState {
	t.Helper()
	state, err := discovery.ParseDiscoveryDocument(text)
	if err != nil {
		t.Fatal(err)
	}
	return state
}

// readFrom is what one read of transport found.
func readFrom(t *testing.T, ctx context.Context, transport discovery.DiscoveryTransport) api.DiscoveryRead {
	t.Helper()
	read, err := transport.Read(ctx)
	if err != nil {
		t.Fatal(err)
	}
	return read
}

// memberOf is the member a state or a read holds.
func memberOf(t *testing.T, union interface{ Member() (any, error) }) any {
	t.Helper()
	member, err := union.Member()
	if err != nil {
		t.Fatalf("%#v holds no member: %v", union, err)
	}
	return member
}

func reason(t *testing.T, state api.DiscoveryState) (api.DiscoveryAbsentReason, bool) {
	t.Helper()
	absent, isAbsent := memberOf(t, state).(api.DiscoveryAbsent)
	return absent.Reason, isAbsent
}

func diagnostic(t *testing.T, state api.DiscoveryState) string {
	t.Helper()
	if absent, isAbsent := memberOf(t, state).(api.DiscoveryAbsent); isAbsent && absent.Diagnostic != nil {
		return *absent.Diagnostic
	}
	return ""
}

func managed(kbs ...api.DiscoveredKB) api.DiscoveryManaged {
	return api.DiscoveryManaged{Kind: api.DiscoveryManagedKindManaged, Kbs: append([]api.DiscoveredKB{}, kbs...)}
}

func absent(reason api.DiscoveryAbsentReason, diagnostic *string) api.DiscoveryAbsent {
	return api.DiscoveryAbsent{Kind: api.DiscoveryAbsentKindAbsent, Reason: reason, Diagnostic: diagnostic}
}

// unchanged is the read that found nothing changed.
var unchanged = func() api.DiscoveryRead {
	var read api.DiscoveryRead
	if err := read.From(api.DiscoveryUnchanged{}); err != nil {
		panic(err)
	}
	return read
}()

const (
	a = "did:web:example.org:kb-a"
	b = "did:web:example.org:kb-b"
)

// ── What the document says ──────────────────────────────────────────────

func TestADocumentOfKnowledgeBasesIsManagedAndOneOfNoneIsManagedToo(t *testing.T) {
	codespace := map[string]any{
		"host": "localhost", "port": 4100, "placement": "codespace", "managedBy": "xynolog-launcher",
		"did": b, "repo": "owner/name", "siteName": "A site",
	}
	got := memberOf(t, stateOf(t, document(t, entry("localhost", 4000, a), codespace)))
	if want := managed(kb(t, entry("localhost", 4000, a)), kb(t, codespace)); !reflect.DeepEqual(got, want) {
		t.Errorf("read %#v, not %#v", got, want)
	}
	// A launcher that manages nothing is there. It is not absent.
	if got, want := memberOf(t, stateOf(t, document(t))), managed(); !reflect.DeepEqual(got, want) {
		t.Errorf("read %#v, not %#v", got, want)
	}
}

func TestWhatIsNotADocumentIsAbsentAndSaysWhy(t *testing.T) {
	cases := []struct {
		text     string
		expected api.DiscoveryAbsentReason
	}{
		{"<!doctype html><html></html>", api.DiscoveryAbsentReasonNotJson},
		{"[]", api.DiscoveryAbsentReasonInvalid},
		{written(t, map[string]any{"kbs": []any{}}), api.DiscoveryAbsentReasonInvalid},
		{written(t, map[string]any{"version": "1", "kbs": []any{}}), api.DiscoveryAbsentReasonInvalid},
		{written(t, map[string]any{"version": 2, "kbs": []any{}}), api.DiscoveryAbsentReasonUnsupportedVersion},
		{written(t, map[string]any{"version": 1}), api.DiscoveryAbsentReasonInvalid},
		{written(t, map[string]any{"version": 1, "kbs": []any{"localhost"}}), api.DiscoveryAbsentReasonInvalid},
		{
			document(t, map[string]any{"host": "localhost", "port": 4000, "placement": "elsewhere", "managedBy": "x", "did": a}),
			api.DiscoveryAbsentReasonInvalid,
		},
		{document(t, entry("localhost", 0, a)), api.DiscoveryAbsentReasonInvalid},
		{
			document(t, map[string]any{"host": "localhost", "port": 70000, "placement": "local", "managedBy": "x", "did": a}),
			api.DiscoveryAbsentReasonInvalid,
		},
	}
	for _, stated := range cases {
		state := stateOf(t, stated.text)
		if got, isAbsent := reason(t, state); !isAbsent || got != stated.expected {
			t.Errorf("%s: read %#v, not absent as %s", stated.text, state, stated.expected)
		}
		if diagnostic(t, state) == "" {
			t.Errorf("%s: no diagnostic", stated.text)
		}
	}
}

func TestADocumentOfAnotherVersionIsNotReadInPart(t *testing.T) {
	state := stateOf(t, written(t, map[string]any{"version": 2, "kbs": []any{entry("localhost", 4000, a)}}))
	if got, isAbsent := reason(t, state); !isAbsent || got != api.DiscoveryAbsentReasonUnsupportedVersion {
		t.Errorf("read %#v", state)
	}
	if !strings.Contains(diagnostic(t, state), "version 2") {
		t.Errorf("read %#v", state)
	}
}

func TestOneEntryThatIsNotOneMakesTheWholeDocumentAbsent(t *testing.T) {
	// A reading of the good entry alone would hide a running knowledge base.
	withoutADid := map[string]any{"host": "localhost", "port": 4100, "placement": "local", "managedBy": "x"}
	state := stateOf(t, document(t, entry("localhost", 4000, a), withoutADid))
	if got, isAbsent := reason(t, state); !isAbsent || got != api.DiscoveryAbsentReasonInvalid {
		t.Errorf("read %#v", state)
	}
	if !strings.Contains(diagnostic(t, state), "did") {
		t.Errorf("read %#v", state)
	}
}

// ── Reading it as text ──────────────────────────────────────────────────

func readOf(t *testing.T, text string, err error) api.DiscoveryRead {
	t.Helper()
	return readFrom(t, context.Background(), discovery.TextDiscovery(func(context.Context) (string, error) { return text, err }))
}

func TestTextIsReadThroughTheOneValidator(t *testing.T) {
	if got, want := memberOf(t, readOf(t, document(t, entry("localhost", 4000, a)), nil)), managed(kb(t, entry("localhost", 4000, a))); !reflect.DeepEqual(got, want) {
		t.Errorf("read %#v, not %#v", got, want)
	}
	if got, want := memberOf(t, readOf(t, "", fs.ErrNotExist)), absent(api.DiscoveryAbsentReasonNotFound, nil); !reflect.DeepEqual(got, want) {
		t.Errorf("read %#v, not %#v", got, want)
	}
	if got, want := memberOf(t, readOf(t, "", errors.New("permission denied"))), absent(api.DiscoveryAbsentReasonUnreadable, new("permission denied")); !reflect.DeepEqual(got, want) {
		t.Errorf("read %#v, not %#v", got, want)
	}
}

// ── What changed ────────────────────────────────────────────────────────

// script is a transport that gives what it was scripted to, in order, and
// then says nothing has changed.
type script struct {
	mu    sync.Mutex
	reads []api.DiscoveryRead
	asked int
}

func scriptOf(reads ...api.DiscoveryRead) *script {
	return &script{reads: reads}
}

func (s *script) Read(context.Context) (api.DiscoveryRead, error) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.asked++
	if len(s.reads) == 0 {
		return unchanged, nil
	}
	next := s.reads[0]
	s.reads = s.reads[1:]
	return next, nil
}

func (s *script) timesAsked() int {
	s.mu.Lock()
	defer s.mu.Unlock()
	return s.asked
}

// changes is every change told of in polls readings. Called inside a
// synctest bubble.
func changes(t *testing.T, s *script, polls int) []api.DiscoveryDiff {
	ctx, cancel := context.WithCancel(context.Background())
	var mu sync.Mutex
	var told []api.DiscoveryDiff
	done := make(chan struct{})
	go func() {
		defer close(done)
		for diff, err := range discovery.SubscribeDiscovery(ctx, s, discovery.DiscoveryInterval) {
			if err != nil {
				t.Error(err)
				return
			}
			mu.Lock()
			told = append(told, diff)
			mu.Unlock()
		}
	}()
	time.Sleep(discovery.DiscoveryInterval*time.Duration(polls) - time.Millisecond)
	synctest.Wait()
	cancel()
	<-done
	mu.Lock()
	defer mu.Unlock()
	return told
}

func addresses(kbs []api.DiscoveredKB) []string {
	found := []string{}
	for _, kb := range kbs {
		found = append(found, fmt.Sprintf("%s:%d", kb.Host, kb.Port))
	}
	return found
}

// summary is a diff as what it added, changed and removed, by address.
type summary struct {
	added, updated, removed []string
}

func summaryOf(diff api.DiscoveryDiff) summary {
	return summary{addresses(diff.Added), addresses(diff.Updated), addresses(diff.Removed)}
}

func at(addresses ...string) []string {
	return append([]string{}, addresses...)
}

func summaries(told []api.DiscoveryDiff) []summary {
	found := []summary{}
	for _, diff := range told {
		found = append(found, summaryOf(diff))
	}
	return found
}

// parsed is text read as the document, as every reader reads it.
func parsed(t *testing.T, text string) api.DiscoveryRead {
	t.Helper()
	return readOf(t, text, nil)
}

func TestTheFirstReadingIsToldWholeAndEachOneAfterByWhatChanged(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		renamed := map[string]any{
			"host": "localhost", "port": 4000, "placement": "local",
			"managedBy": "xynolog-launcher", "did": a, "siteName": "Renamed",
		}
		s := scriptOf(
			parsed(t, document(t, entry("localhost", 4000, a))),
			parsed(t, document(t, renamed, entry("localhost", 4100, b))),
			parsed(t, document(t, entry("localhost", 4100, b))),
		)
		told := changes(t, s, 4)

		want := []summary{
			{at("localhost:4000"), at(), at()},
			{at("localhost:4100"), at("localhost:4000"), at()},
			{at(), at(), at("localhost:4000")},
		}
		if got := summaries(told); !reflect.DeepEqual(got, want) {
			t.Fatalf("told %v, not %v", got, want)
		}
		if name := told[1].Updated[0].SiteName; name == nil || *name != "Renamed" {
			t.Errorf("the change told %v", name)
		}
		if asked := s.timesAsked(); asked != 4 {
			t.Errorf("asked %d times", asked)
		}
	})
}

func TestAKnowledgeBaseThatMovesPortIsRemovedAndAdded(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		s := scriptOf(
			parsed(t, document(t, entry("localhost", 4000, a))),
			parsed(t, document(t, entry("localhost", 4001, a))),
		)
		told := changes(t, s, 2)

		if len(told) != 2 {
			t.Fatalf("told %d changes", len(told))
		}
		if got, want := summaryOf(told[1]), (summary{at("localhost:4001"), at(), at("localhost:4000")}); !reflect.DeepEqual(got, want) {
			t.Errorf("told %v, not %v", got, want)
		}
	})
}

func TestAReadingThatChangedNothingIsNotTold(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		same := document(t, entry("localhost", 4000, a))
		s := scriptOf(parsed(t, same), unchanged, parsed(t, same), parsed(t, same))
		told := changes(t, s, 5)

		if len(told) != 1 {
			t.Errorf("told %d changes", len(told))
		}
		if asked := s.timesAsked(); asked != 5 {
			t.Errorf("asked %d times", asked)
		}
	})
}

// Go's own: an entry's optional members are pointers, and an entry read again
// is the same entry when what they point at is.
func TestAnEntryWithOptionalMembersReadAgainUnchangedIsNotTold(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		codespace := document(t, map[string]any{
			"host": "localhost", "port": 4100, "placement": "codespace", "managedBy": "xynolog-launcher",
			"did": b, "repo": "owner/name", "siteName": "A site",
		})
		s := scriptOf(parsed(t, codespace), parsed(t, codespace))
		told := changes(t, s, 2)

		if len(told) != 1 {
			t.Errorf("told %d changes", len(told))
		}
	})
}

func TestALauncherThatGoesAndComesBackIsToldWithWhatItTookAndBrought(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		managing := document(t, entry("localhost", 4000, a))
		s := scriptOf(
			parsed(t, "not json"),
			parsed(t, managing),
			parsed(t, "not json"),
			// Absent for another reason is a change too; for the same one it is not.
			parsed(t, "[]"),
			parsed(t, "{}"),
		)
		told := changes(t, s, 6)

		type said struct {
			reason  api.DiscoveryAbsentReason
			absent  bool
			summary summary
		}
		got := []said{}
		for _, diff := range told {
			why, isAbsent := reason(t, diff.State)
			got = append(got, said{why, isAbsent, summaryOf(diff)})
		}
		want := []said{
			{api.DiscoveryAbsentReasonNotJson, true, summary{at(), at(), at()}},
			{"", false, summary{at("localhost:4000"), at(), at()}},
			{api.DiscoveryAbsentReasonNotJson, true, summary{at(), at(), at("localhost:4000")}},
			{api.DiscoveryAbsentReasonInvalid, true, summary{at(), at(), at()}},
		}
		if !reflect.DeepEqual(got, want) {
			t.Errorf("told %v, not %v", got, want)
		}
	})
}

func TestOneKnowledgeBaseInTwoPlacesIsTwoEntriesAndEachIsItsOwn(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		both := document(t, entry("localhost", 4000, a), entry("localhost", 4100, a))
		s := scriptOf(
			parsed(t, both),
			parsed(t, both),
			parsed(t, document(t, entry("localhost", 4100, a))),
		)
		told := changes(t, s, 4)

		// No change while both are there, and the one that stops is not hidden
		// by the one that goes on.
		want := []summary{
			{at("localhost:4000", "localhost:4100"), at(), at()},
			{at(), at(), at("localhost:4000")},
		}
		if got := summaries(told); !reflect.DeepEqual(got, want) {
			t.Errorf("told %v, not %v", got, want)
		}
		for _, diff := range told {
			if len(diff.Duplicated) != 0 {
				t.Errorf("named %v as duplicated", diff.Duplicated)
			}
		}
	})
}

func TestTwoEntriesAtOneAddressAreNamedAndNeitherIsDroppedFromTheState(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		s := scriptOf(parsed(t, document(t,
			entry("localhost", 4000, a),
			entry("localhost", 4000, b),
			entry("localhost", 4100, b),
		)))
		told := changes(t, s, 1)

		if len(told) != 1 {
			t.Fatalf("told %d changes", len(told))
		}
		if !slices.Equal(told[0].Duplicated, at("localhost:4000")) {
			t.Errorf("named %v as duplicated", told[0].Duplicated)
		}
		managing, isManaged := memberOf(t, told[0].State).(api.DiscoveryManaged)
		if !isManaged {
			t.Fatalf("a managed state was expected, not %#v", told[0].State)
		}
		if len(managing.Kbs) != 3 {
			t.Errorf("the state lists %d entries", len(managing.Kbs))
		}
	})
}

func TestReadingStopsWhenNobodyListens(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		s := scriptOf(parsed(t, document(t)))
		ctx, cancel := context.WithCancel(context.Background())
		done := make(chan struct{})
		go func() {
			defer close(done)
			for _, err := range discovery.SubscribeDiscovery(ctx, s, discovery.DiscoveryInterval) {
				if err != nil {
					t.Error(err)
					return
				}
			}
		}()
		time.Sleep(discovery.DiscoveryInterval * 2)
		synctest.Wait()
		asked := s.timesAsked()
		if asked < 2 {
			t.Fatalf("asked %d times", asked)
		}

		cancel()
		<-done
		time.Sleep(discovery.DiscoveryInterval * 5)
		if now := s.timesAsked(); now != asked {
			t.Errorf("asked %d times after the reader left, not %d", now, asked)
		}
	})
}

package registry_test

import (
	"context"
	"encoding/json"
	"fmt"
	"io/fs"
	"maps"
	"os"
	"path/filepath"
	"reflect"
	"slices"
	"testing"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/registry"
)

// storedTable is protocol/specs/src/session/stored.json: what a registry keeps in its
// storage, which this test holds Go's registry to.
type storedTable struct {
	SessionKeyPrefix struct {
		Prefix string `json:"prefix"`
	} `json:"sessionKeyPrefix"`
	StoredSession referred `json:"storedSession"`
	OpenResource  referred `json:"openResource"`
}

// referred is an object's schema the table names by its $id, read from the
// spec file that states that $id.
type referred struct {
	Properties map[string]json.RawMessage `json:"properties"`
	Required   []string                   `json:"required"`
}

func (r *referred) UnmarshalJSON(text []byte) error {
	var reference struct {
		Ref string `json:"$ref"`
	}
	if err := json.Unmarshal(text, &reference); err != nil {
		return err
	}
	var stating []string
	err := filepath.WalkDir(filepath.Join("..", "..", "protocol", "specs", "src"), func(path string, entry fs.DirEntry, err error) error {
		if err != nil || entry.IsDir() || filepath.Ext(path) != ".json" {
			return err
		}
		schema, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		var stated struct {
			ID string `json:"$id"`
		}
		if json.Unmarshal(schema, &stated) == nil && stated.ID == reference.Ref {
			stating = append(stating, path)
		}
		return nil
	})
	if err != nil {
		return err
	}
	if len(stating) != 1 {
		return fmt.Errorf("%d spec files state the $id %q: %v", len(stating), reference.Ref, stating)
	}
	schema, err := os.ReadFile(stating[0])
	if err != nil {
		return err
	}
	type object referred
	return json.Unmarshal(schema, (*object)(r))
}

func readStoredTable(t *testing.T) storedTable {
	t.Helper()
	text, err := os.ReadFile(filepath.Join("..", "..", "protocol", "specs", "src", "session", "stored.json"))
	must(t, err)
	var table storedTable
	must(t, json.Unmarshal(text, &table))
	return table
}

// A member the table gains fails here until Go has it.
func TestWhatARegistryKeepsIsTheTables(t *testing.T) {
	table := readStoredTable(t)

	if got, want := registry.SessionKey("kb-a"), table.SessionKeyPrefix.Prefix+"kb-a"; got != want {
		t.Errorf("a knowledge base's session key is %q; the table's is %q", got, want)
	}

	members := slices.Sorted(maps.Keys(table.StoredSession.Properties))
	storage := xynolog.NewMemoryStorage()
	person := xynolog.PersonKey("did:web:example.org:users:alice")
	must(t, registry.StoreSession(storage, "kb-a", api.StoredSession{
		Access:             "a",
		Refresh:            "r",
		ClientId:           "xynolog-browser",
		TokenEndpoint:      "https://issuer.test/token",
		RevocationEndpoint: new("https://issuer.test/revoke"),
		PersonKey:          &person,
	}))
	stored, _ := storage.Get(registry.SessionKey("kb-a"))
	var written map[string]json.RawMessage
	must(t, json.Unmarshal([]byte(stored), &written))
	if got := slices.Sorted(maps.Keys(written)); !slices.Equal(got, members) {
		t.Errorf("a stored session is written with %v; the table's members are %v", got, members)
	}

	for _, left := range members {
		without := map[string]string{}
		for _, member := range members {
			if member != left {
				without[member] = "the " + member
			}
		}
		value, err := json.Marshal(without)
		must(t, err)
		must(t, storage.Set(registry.SessionKey("kb-a"), string(value)))
		_, read := registry.StoredSessionOf(storage, "kb-a")
		if required := slices.Contains(table.StoredSession.Required, left); read == required {
			t.Errorf("a stored value without %s reads as a session: %v; the table requires it: %v", left, read, required)
		}
	}
}

// An open resource the registry writes carries every member the table names
// when all of them are known, and only the ones the table requires when no
// more are. A member the table gains, or one it stops requiring, fails here
// until Go writes it so.
func TestAnOpenResourceIsWrittenWithTheTablesMembers(t *testing.T) {
	table := readStoredTable(t)
	members := slices.Sorted(maps.Keys(table.OpenResource.Properties))
	requiredMembers := slices.Sorted(slices.Values(table.OpenResource.Required))
	bubble(t, func(t *testing.T, w *world) {
		browser := w.with(kbOfA()).browser()
		live(t, browser)
		must(t, browser.AddOpenResource(id("whole"), "Whole", "text/markdown", "file://docs/whole.md"))
		must(t, browser.AddOpenResource(id("bare"), "Bare", "", ""))

		var byKb map[string][]map[string]json.RawMessage
		w.stored(registry.OpenResourcesByKbKey, &byKb)
		written := map[string][]string{}
		for _, entry := range byKb[kbA] {
			var named string
			must(t, json.Unmarshal(entry["id"], &named))
			written[named] = slices.Sorted(maps.Keys(entry))
		}
		if got := written["whole"]; !slices.Equal(got, members) {
			t.Errorf("an open resource whose media type and place in the working tree are known is written with %v; the table's members are %v", got, members)
		}
		if got := written["bare"]; !slices.Equal(got, requiredMembers) {
			t.Errorf("an open resource of which no more is known is written with %v; the table requires %v", got, requiredMembers)
		}
	})
}

// A stored open resource that lacks a member the table requires is none, as
// one with a member of the wrong type is: what is stored does not read, and
// nothing is shown open.
func TestAStoredOpenResourceThatLacksAMemberTheTableRequiresIsNone(t *testing.T) {
	table := readStoredTable(t)
	members := slices.Sorted(maps.Keys(table.OpenResource.Properties))
	whole := map[string]any{"id": "r1", "name": "One", "openedAt": 1, "order": 0, "mediaType": "text/plain", "storageUri": "file://docs/one.md"}
	if got := slices.Sorted(maps.Keys(whole)); !slices.Equal(got, members) {
		t.Fatalf("the open resource stored here has %v; the table's members are %v", got, members)
	}
	for _, left := range members {
		bubble(t, func(t *testing.T, w *world) {
			without := maps.Clone(whole)
			delete(without, left)
			w.with(kbOfA())
			must(t, w.storage.Set(registry.OpenResourcesByKbKey, string(marshal(map[string]any{kbA: []any{without}}))))
			browser := w.browser()
			live(t, browser)
			shown := len(open(browser)) == 1
			if required := slices.Contains(table.OpenResource.Required, left); shown == required {
				t.Errorf("an open resource stored without %s is shown: %v; the table requires it: %v", left, shown, required)
			}
		})
	}
}

func TestAStoredValueThatLacksAMemberOfASessionIsNone(t *testing.T) {
	storage := xynolog.NewMemoryStorage()
	must(t, storage.Set(registry.SessionKey("kb-a"), `{"access":"a","refresh":"r","tokenEndpoint":"https://issuer.test/token"}`))
	if _, ok := registry.StoredSessionOf(storage, "kb-a"); ok {
		t.Error("a session with no client is read")
	}
	must(t, storage.Set(registry.SessionKey("kb-a"), `{"access":"a","refresh":"r","clientId":"xynolog-browser","tokenEndpoint":"https://issuer.test/token"}`))
	if stored, ok := registry.StoredSessionOf(storage, "kb-a"); !ok || stored.RevocationEndpoint != nil || stored.PersonKey != nil {
		t.Errorf("a session with no revocation endpoint and no person reads as %+v, %v", stored, ok)
	}
	// Written without them, as read.
	stored, _ := registry.StoredSessionOf(storage, "kb-a")
	must(t, registry.StoreSession(storage, "kb-a", stored))
	if written, _ := storage.Get(registry.SessionKey("kb-a")); written != `{"access":"a","refresh":"r","clientId":"xynolog-browser","tokenEndpoint":"https://issuer.test/token"}` {
		t.Errorf("a session with no revocation endpoint and no person is written as %s", written)
	}
}

// The person the gateway named is recorded on the stored sign-in as one step,
// only while it holds the token that was asked about and names nobody; a
// renewal keeps it.
func TestThePersonIsRecordedOnTheStoredSignInOfTheTokenAskedAbout(t *testing.T) {
	ctx := context.Background()
	storage := xynolog.NewMemoryStorage()
	kept := registry.KeptIn(storage, "kb-a")
	jo, ann := xynolog.PersonKey("did:web:example.org:users:jo"), xynolog.PersonKey("did:web:example.org:users:ann")
	read := api.StoredSession{Access: "a1", Refresh: "r1", ClientId: "xynolog-browser", TokenEndpoint: "https://issuer.test/token"}

	if recorded, err := kept.RecordPersonKey(ctx, "a1", jo); err != nil || recorded {
		t.Fatalf("a person recorded on nothing stored: %v, %v", recorded, err)
	}
	if _, ok := registry.StoredSessionOf(storage, "kb-a"); ok {
		t.Fatal("recording a person on nothing stored wrote a sign-in")
	}

	must(t, kept.Keep(ctx, read))
	if recorded, err := kept.RecordPersonKey(ctx, "another token", jo); err != nil || recorded {
		t.Fatalf("a person recorded on a sign-in of another token: %v, %v", recorded, err)
	}
	if held, _, _ := kept.Held(ctx); held.PersonKey != nil {
		t.Fatalf("a sign-in of another token names %s", *held.PersonKey)
	}
	if recorded, err := kept.RecordPersonKey(ctx, "a1", jo); err != nil || !recorded {
		t.Fatalf("the person was not recorded: %v, %v", recorded, err)
	}
	// Recorded already: the same person still is, another is not.
	if recorded, err := kept.RecordPersonKey(ctx, "a1", jo); err != nil || !recorded {
		t.Fatalf("the person recorded already: %v, %v", recorded, err)
	}
	if recorded, err := kept.RecordPersonKey(ctx, "a1", ann); err != nil || recorded {
		t.Fatalf("another person recorded over the first: %v, %v", recorded, err)
	}
	if held, _, _ := kept.Held(ctx); held.PersonKey == nil || *held.PersonKey != jo {
		t.Fatalf("the sign-in names %+v", held.PersonKey)
	}

	// A renewal keeps the person; a new sign-in names nobody.
	named, _, _ := kept.Held(ctx)
	if _, ok, err := kept.Renewed(ctx, named, "a2", "r2"); err != nil || !ok {
		t.Fatalf("the renewal: %v, %v", ok, err)
	}
	if stored, _ := registry.StoredSessionOf(storage, "kb-a"); stored.Access != "a2" || stored.PersonKey == nil || *stored.PersonKey != jo {
		t.Fatalf("stored after a renewal: %+v", stored)
	}
	must(t, kept.Keep(ctx, api.StoredSession{Access: "a3", Refresh: "r3", ClientId: "xynolog-browser", TokenEndpoint: "https://issuer.test/token"}))
	if stored, _ := registry.StoredSessionOf(storage, "kb-a"); stored.PersonKey != nil {
		t.Fatalf("a new sign-in names %s", *stored.PersonKey)
	}
}

// A new sign-in kept where a registry keeps a knowledge base's sign-in
// replaces the one stored, and forgets what was kept there of the person it
// named, whoever the new one turns out to be: a new sign-in names nobody until
// its gateway names them. Over one that named nobody, or nothing, nothing is
// deleted; no other person's entries, nor the person's on another knowledge
// base, ever are.
func TestANewSignInKeptOverOneNamingItsPersonDeletesWhatWasKeptOfThem(t *testing.T) {
	jo, ann := xynolog.PersonKey("did:web:example.org:users:jo"), xynolog.PersonKey("did:web:example.org:users:ann")
	entriesOf := func(kbID, personKey string) []string {
		keys := []string{xynolog.LastEventIDKey(kbID, personKey)}
		for _, query := range xynolog.PersistedCacheQueries {
			keys = append(keys, xynolog.CacheKey(kbID, personKey, query))
		}
		return keys
	}
	josOnA := entriesOf("kb-a", jo)
	others := slices.Concat(entriesOf("kb-a", ann), entriesOf("kb-b", jo))
	signIn := api.StoredSession{Access: "a2", Refresh: "r2", ClientId: "xynolog-browser", TokenEndpoint: "https://issuer.test/token"}
	for _, over := range []struct {
		name      string
		stored    bool
		personKey *string
		deletes   bool
	}{
		{name: "a sign-in naming jo", stored: true, personKey: &jo, deletes: true},
		{name: "a sign-in naming nobody", stored: true},
		{name: "nothing stored"},
	} {
		t.Run(over.name, func(t *testing.T) {
			ctx := context.Background()
			storage := xynolog.NewMemoryStorage()
			for _, key := range slices.Concat(josOnA, others) {
				must(t, storage.Set(key, "kept"))
			}
			if over.stored {
				must(t, registry.StoreSession(storage, "kb-a", api.StoredSession{Access: "a1", Refresh: "r1", ClientId: "xynolog-browser", TokenEndpoint: "https://issuer.test/token", PersonKey: over.personKey}))
			}
			kept := registry.KeptIn(storage, "kb-a")

			must(t, kept.Keep(ctx, signIn))
			if held, ok, err := kept.Held(ctx); err != nil || !ok || !reflect.DeepEqual(held, signIn) {
				t.Errorf("kb-a's sign-in is %+v (%v, %v); the new one is %+v", held, ok, err, signIn)
			}
			for _, key := range josOnA {
				_, has := storage.Get(key)
				if over.deletes && has {
					t.Errorf("%s holds something once the sign-in naming jo is replaced", key)
				}
				if !over.deletes && !has {
					t.Errorf("%s was deleted; what was replaced named nobody", key)
				}
			}
			for _, key := range others {
				if _, has := storage.Get(key); !has {
					t.Errorf("%s, no entry of the person replaced on kb-a, was deleted", key)
				}
			}
		})
	}
}

func TestASessionKeyNamesItsKnowledgeBase(t *testing.T) {
	if kbID, ok := registry.KbOfSessionKey(registry.SessionKey("kb-a")); !ok || kbID != "kb-a" {
		t.Errorf("the session key of kb-a names %q, %v", kbID, ok)
	}
	if _, ok := registry.KbOfSessionKey(registry.ActiveKey); ok {
		t.Error("the active key is read as a session's")
	}
}

// A renewal is written against what is stored then: one made meanwhile stands,
// and one of a sign-in that is gone is not written back.
func TestARenewalIsKeptAgainstWhatIsStoredThen(t *testing.T) {
	ctx := context.Background()
	storage := xynolog.NewMemoryStorage()
	kept := registry.KeptIn(storage, "kb-a")
	read := api.StoredSession{Access: "a1", Refresh: "r1", ClientId: "xynolog-browser", TokenEndpoint: "https://issuer.test/token"}

	if _, ok, err := kept.Renewed(ctx, read, "a2", "r2"); err != nil || ok {
		t.Fatalf("a renewal of nothing stored is kept: %v, %v", ok, err)
	}
	if _, ok := registry.StoredSessionOf(storage, "kb-a"); ok {
		t.Fatal("a renewal of nothing stored wrote one")
	}

	must(t, kept.Keep(ctx, read))
	if current, ok, err := kept.Renewed(ctx, read, "a2", "r2"); err != nil || !ok || current != "a2" {
		t.Fatalf("a renewal gives %q, %v, %v", current, ok, err)
	}
	if held, ok, _ := kept.Held(ctx); !ok || held.Access != "a2" || held.Refresh != "r2" {
		t.Fatalf("held after a renewal: %+v", held)
	}

	// Renewed from what was read before: the renewal stored meanwhile stands.
	if current, ok, err := kept.Renewed(ctx, read, "a3", "r3"); err != nil || !ok || current != "a2" {
		t.Fatalf("a renewal of what is no longer stored gives %q, %v, %v", current, ok, err)
	}
	if held, _, _ := kept.Held(ctx); held.Access != "a2" {
		t.Fatalf("held: %+v", held)
	}

	must(t, kept.Forget(ctx))
	if _, ok, _ := kept.Held(ctx); ok {
		t.Fatal("a forgotten sign-in is held")
	}
}

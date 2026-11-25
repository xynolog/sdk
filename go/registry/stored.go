package registry

// What a registry keeps in a SessionStorage, under the keys stored_gen.go
// names: each knowledge base's tokens, the list of registered knowledge bases
// and which of them is active, and each one's open resources and last-viewed
// resource.
//
// An entry that does not read as what it should be is not there: a store
// written by another release is dropped entry by entry, never half-read.

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/required"
)

// SessionKey is the key a knowledge base's session is stored under.
func SessionKey(kbID string) string { return sessionKeyPrefix + kbID }

// KbOfSessionKey is the knowledge base key is the session of; false when it
// is no session's key.
func KbOfSessionKey(key string) (string, bool) { return strings.CutPrefix(key, sessionKeyPrefix) }

// readStoredSession is a stored value as a session; false for one that is
// not a session, which lacks a member a session has.
func readStoredSession(stored string) (api.StoredSession, bool) {
	return required.ReadAs[api.StoredSession]([]byte(stored))
}

// writtenSession is s as it is stored.
func writtenSession(s api.StoredSession) string {
	written, err := json.Marshal(s)
	if err != nil {
		// A struct of strings always encodes.
		panic(err)
	}
	return string(written)
}

// StoredSessionOf is the session stored for a knowledge base; false when
// none is.
func StoredSessionOf(storage xynolog.SessionStorage, kbID string) (api.StoredSession, bool) {
	stored, ok := storage.Get(SessionKey(kbID))
	if !ok {
		return api.StoredSession{}, false
	}
	return readStoredSession(stored)
}

// StoreSession stores a new sign-in for a knowledge base in place of the one
// stored, then forgets what its sessions kept of the person the replaced one
// named (forgetKept): a new sign-in names nobody until its gateway names
// them, whoever they turn out to be, so keeping one forgets the saved sign-in
// it replaces. The error when the storage could not.
func StoreSession(storage xynolog.SessionStorage, kbID string, session api.StoredSession) error {
	return replaceStoredSession(storage, kbID, &session)
}

// ClearStoredSession forgets a knowledge base's stored session, then what its
// sessions kept of the person it named (forgetKept): forgetting a saved
// sign-in deletes its person's entries. The error when the storage could not.
func ClearStoredSession(storage xynolog.SessionStorage, kbID string) error {
	return replaceStoredSession(storage, kbID, nil)
}

// replaceStoredSession puts next in place of a knowledge base's stored
// session, or nothing for nil, then forgets what was kept of the person the
// one it replaced named (forgetKept).
func replaceStoredSession(storage xynolog.SessionStorage, kbID string, next *api.StoredSession) error {
	replaced, _, err := swapStoredSession(storage, kbID, next)
	if err != nil {
		return err
	}
	return forgetKept(storage, kbID, replaced.PersonKey)
}

// LoadKnowledgeBases is the registered knowledge bases. Each entry is read on
// its own, and one that is not a knowledge base with a did is dropped: whoever
// it was is registered again.
func LoadKnowledgeBases(storage xynolog.SessionStorage) []api.KnowledgeBase {
	stored, ok := storage.Get(KnowledgeBasesKey)
	if !ok {
		return []api.KnowledgeBase{}
	}
	var entries []json.RawMessage
	if json.Unmarshal([]byte(stored), &entries) != nil {
		return []api.KnowledgeBase{}
	}
	kbs := []api.KnowledgeBase{}
	for _, entry := range entries {
		if kb, ok := knowledgeBaseOf(entry); ok {
			kbs = append(kbs, kb)
		}
	}
	return kbs
}

// knowledgeBaseOf is an entry as a knowledge base; false for one that lacks a
// member a knowledge base has, or whose endpoint is no endpoint.
func knowledgeBaseOf(entry json.RawMessage) (api.KnowledgeBase, bool) {
	kb, ok := required.ReadAs[api.KnowledgeBase](entry)
	if !ok {
		return api.KnowledgeBase{}, false
	}
	kind, err := kb.Endpoint.Discriminator()
	if err != nil {
		return api.KnowledgeBase{}, false
	}
	switch kind {
	case string(api.HttpEndpointKindHttp):
		err = kb.Endpoint.As(&api.HttpEndpoint{})
	case string(api.LocalEndpointKindLocal):
		err = kb.Endpoint.As(&api.LocalEndpoint{})
	default:
		return api.KnowledgeBase{}, false
	}
	return kb, err == nil
}

// SaveKnowledgeBases stores the registered knowledge bases, in place of what
// was stored; the error when the storage could not.
func SaveKnowledgeBases(storage xynolog.SessionStorage, kbs []api.KnowledgeBase) error {
	written, err := json.Marshal(kbs)
	if err != nil {
		// Each entry was read from the storage or built from a sign-in, and
		// writes as it was read.
		panic(err)
	}
	return storage.Set(KnowledgeBasesKey, string(written))
}

// KeptIn is a knowledge base's sign-in as a session keeps it, in a registry's
// storage, under SessionKey(kbID). A renewal is written as one step against
// what is stored then, so one made meanwhile by another session or context
// stands, and keeps the person the sign-in names. Keeping a new sign-in, and
// forgetting the sign-in, forget what was kept of the person the one stored
// named (StoreSession, ClearStoredSession).
func KeptIn(storage xynolog.SessionStorage, kbID string) xynolog.SignInKept {
	return keptIn{storage: storage, kbID: kbID}
}

type keptIn struct {
	storage xynolog.SessionStorage
	kbID    string
}

func (k keptIn) Held(context.Context) (api.StoredSession, bool, error) {
	stored, ok := StoredSessionOf(k.storage, k.kbID)
	return stored, ok, nil
}

func (k keptIn) Keep(_ context.Context, signIn api.StoredSession) error {
	return StoreSession(k.storage, k.kbID, signIn)
}

func (k keptIn) Renewed(_ context.Context, read api.StoredSession, access, refresh string) (string, bool, error) {
	var current string
	var kept bool
	err := k.storage.Update(SessionKey(k.kbID), func(stored string, has bool) (string, bool) {
		session, ok := readStoredSession(stored)
		if !has || !ok {
			return stored, has
		}
		kept = true
		if session.Access != read.Access || session.Refresh != read.Refresh {
			current = session.Access
			return stored, true
		}
		session.Access, session.Refresh = access, refresh
		current = access
		return writtenSession(session), true
	})
	return current, kept, err
}

// RecordPersonKey records personKey on the stored session, as
// xynolog.SignInKept says, in one update of the storage: only while it holds
// access and names no person.
func (k keptIn) RecordPersonKey(_ context.Context, access, personKey string) (bool, error) {
	var names bool
	err := k.storage.Update(SessionKey(k.kbID), func(stored string, has bool) (string, bool) {
		session, ok := readStoredSession(stored)
		if !has || !ok || session.Access != access {
			return stored, has
		}
		if session.PersonKey != nil {
			names = *session.PersonKey == personKey
			return stored, true
		}
		session.PersonKey, names = &personKey, true
		return writtenSession(session), true
	})
	return names, err
}

// Forget forgets the stored session, and what was kept of the person it named
// (ClearStoredSession). A session whose sign-in is forgotten while its client
// is open writes nothing more there (xynolog.SessionFromKeptConfig's Storage).
func (k keptIn) Forget(context.Context) error {
	return ClearStoredSession(k.storage, k.kbID)
}

// swapStoredSession puts next in place of a knowledge base's stored session,
// or nothing for nil, as one step with reading what was stored: the session
// it replaced, and false when nothing was.
func swapStoredSession(storage xynolog.SessionStorage, kbID string, next *api.StoredSession) (api.StoredSession, bool, error) {
	var replaced api.StoredSession
	var was bool
	err := storage.Update(SessionKey(kbID), func(stored string, has bool) (string, bool) {
		if has {
			replaced, was = readStoredSession(stored)
		}
		if next == nil {
			return "", false
		}
		return writtenSession(*next), true
	})
	return replaced, was, err
}

// forgetKept deletes what a session's client kept, in a knowledge base's
// storage, of the person a forgotten sign-in named, whose key is personKey:
// the key of each persisted query and the stream's places', whether or not
// each holds anything. A sign-in that named nobody (nil) deletes nothing.
// Every delete of what forgetting a saved sign-in deletes goes through it.
func forgetKept(storage xynolog.SessionStorage, kbID string, personKey *string) error {
	if personKey == nil {
		return nil
	}
	failed := []error{storage.Delete(xynolog.LastEventIDKey(kbID, *personKey))}
	for _, query := range xynolog.PersistedCacheQueries {
		failed = append(failed, storage.Delete(xynolog.CacheKey(kbID, *personKey, query)))
	}
	return errors.Join(failed...)
}

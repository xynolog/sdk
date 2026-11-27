// Package discovery reads the knowledge bases a launcher manages, as the
// launcher publishes them (protocol/specs/src/discovery): what the document says, read
// whole or not at all, and what changed since it was last read.
//
// Absent is not empty. api.DiscoveryAbsent is "no launcher was found", with
// why; api.DiscoveryManaged with no knowledge bases is "the launcher is here
// and manages nothing". A reader shows the two differently and never has to
// work out which it has.
//
// A document is read whole. One of a version this client does not speak, or
// with an entry that is not what the schema says, is absent: a partial reading
// would hide a running knowledge base without a trace.
//
// The address is the key. Entries are told apart by host and port, which the
// launcher keeps unique. A did is not unique: one knowledge base running in
// two places is two entries with one did, and each is its own. Two entries at
// one address cannot both be true, and are named in api.DiscoveryDiff.Duplicated
// for a reader to show rather than merged.
//
// Where the document is read from is a DiscoveryTransport: TextDiscovery is
// one over any way of getting the text, HttpDiscovery one over a URL.
// Discovery only describes: signing in to a knowledge base it lists is a
// person's act.
package discovery

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"iter"
	"reflect"
	"time"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/required"
	"github.com/xynolog/sdk/go/internal/timing"
)

// DiscoveryInterval is how often a launcher's document is read again, unless
// a caller says otherwise.
const DiscoveryInterval = timing.DiscoveryInterval

// DiscoveryTransport is where the document is read from.
type DiscoveryTransport interface {
	// Read reads the document once. Its error is that what it read could
	// not be written as an api.DiscoveryRead.
	Read(ctx context.Context) (api.DiscoveryRead, error)
}

// state is what a document says, a member of both api.DiscoveryState and
// api.DiscoveryRead: api.DiscoveryAbsent or api.DiscoveryManaged.
type state interface {
	api.DiscoveryStateMember
	api.DiscoveryReadMember
}

// stateOf is found as an api.DiscoveryState, or why it cannot be written
// as one.
func stateOf(found state) (api.DiscoveryState, error) {
	var held api.DiscoveryState
	if err := held.From(found); err != nil {
		return api.DiscoveryState{}, fmt.Errorf("discovery: a %T written as a DiscoveryState: %w", found, err)
	}
	return held, nil
}

// readOf is found as an api.DiscoveryRead, or why it cannot be written as
// one.
func readOf(found api.DiscoveryReadMember) (api.DiscoveryRead, error) {
	var held api.DiscoveryRead
	if err := held.From(found); err != nil {
		return api.DiscoveryRead{}, fmt.Errorf("discovery: a %T written as a DiscoveryRead: %w", found, err)
	}
	return held, nil
}

// stateIn is the state read found, and whether it found one: an
// api.DiscoveryUnchanged is none. A read that holds no member is refused.
func stateIn(read api.DiscoveryRead) (state, bool, error) {
	member, err := read.Member()
	if err != nil {
		return nil, false, fmt.Errorf("discovery: a read that holds no DiscoveryRead: %w", err)
	}
	switch found := member.(type) {
	case api.DiscoveryAbsent:
		return found, true, nil
	case api.DiscoveryManaged:
		return found, true, nil
	}
	return nil, false, nil
}

func absent(reason api.DiscoveryAbsentReason, diagnostic string) api.DiscoveryAbsent {
	return api.DiscoveryAbsent{Reason: reason, Diagnostic: &diagnostic}
}

func invalid(diagnostic string) api.DiscoveryAbsent {
	return absent(api.DiscoveryAbsentReasonInvalid, diagnostic)
}

// ParseDiscoveryDocument is the document's text as a state. Every reader reads
// the text as it does. Its error is that the state could not be written as
// an api.DiscoveryState.
func ParseDiscoveryDocument(text string) (api.DiscoveryState, error) {
	return stateOf(parse(text))
}

func parse(text string) state {
	data := []byte(text)
	if err := json.Unmarshal(data, new(any)); err != nil {
		return absent(api.DiscoveryAbsentReasonNotJson, err.Error())
	}
	var members map[string]json.RawMessage
	if json.Unmarshal(data, &members) != nil || members == nil {
		return invalid("document is not an object")
	}
	var version int64
	if raw, has := members["version"]; !has || string(raw) == "null" || json.Unmarshal(raw, &version) != nil {
		return invalid(`missing numeric "version"`)
	}
	if version != int64(api.DiscoveryDocumentVersion1) {
		return absent(
			api.DiscoveryAbsentReasonUnsupportedVersion,
			fmt.Sprintf(
				"discovery document version %d is not the one this client speaks (%d); it is not read in part",
				version, api.DiscoveryDocumentVersion1,
			),
		)
	}
	read, fault, faulty := required.Read(data, reflect.TypeFor[api.DiscoveryDocument]())
	if faulty {
		return invalid(fault.String())
	}
	var document api.DiscoveryDocument
	if err := json.Unmarshal(read, &document); err != nil {
		return invalid(err.Error())
	}
	return api.DiscoveryManaged{Kbs: document.Kbs}
}

type textDiscovery struct {
	read func(ctx context.Context) (string, error)
}

func (t textDiscovery) Read(ctx context.Context) (api.DiscoveryRead, error) {
	text, err := t.read(ctx)
	switch {
	case errors.Is(err, fs.ErrNotExist):
		return readOf(api.DiscoveryAbsent{Reason: api.DiscoveryAbsentReasonNotFound})
	case err != nil:
		return readOf(absent(api.DiscoveryAbsentReasonUnreadable, err.Error()))
	}
	return readOf(parse(text))
}

// TextDiscovery is a transport over any way of getting the document's text:
// read gives the text, an error that is fs.ErrNotExist when there is no
// document, or why it could not be read. Reading the launcher's file is
// os.ReadFile, which fails that way when there is no file.
func TextDiscovery(read func(ctx context.Context) (string, error)) DiscoveryTransport {
	return textDiscovery{read: read}
}

func address(kb api.DiscoveredKB) string {
	return fmt.Sprintf("%s:%d", kb.Host, kb.Port)
}

// kbsOf is the knowledge bases a state lists: none when it is absent, or when
// there is no state.
func kbsOf(found state) []api.DiscoveredKB {
	if managed, isManaged := found.(api.DiscoveryManaged); isManaged {
		return managed.Kbs
	}
	return nil
}

// diff is what changed between last, the state last told of (nil when none
// was), and next, and whether anything did; or why next could not be told
// of.
func diff(last state, next state) (api.DiscoveryDiff, bool, error) {
	beforeKBs, afterKBs := kbsOf(last), kbsOf(next)
	before := make(map[string]api.DiscoveredKB, len(beforeKBs))
	for _, kb := range beforeKBs {
		before[address(kb)] = kb
	}
	after := make(map[string]bool, len(afterKBs))
	for _, kb := range afterKBs {
		after[address(kb)] = true
	}

	stated, err := stateOf(next)
	if err != nil {
		return api.DiscoveryDiff{}, false, err
	}
	change := api.DiscoveryDiff{State: stated}
	claimed := make(map[string]int, len(afterKBs))
	for _, kb := range afterKBs {
		at := address(kb)
		if claimed[at]++; claimed[at] == 2 {
			change.Duplicated = append(change.Duplicated, at)
		}
		was, had := before[at]
		switch {
		case !had:
			change.Added = append(change.Added, kb)
		case !reflect.DeepEqual(was, kb):
			change.Updated = append(change.Updated, kb)
		}
	}
	for _, kb := range beforeKBs {
		if !after[address(kb)] {
			change.Removed = append(change.Removed, kb)
		}
	}

	stateChanged := true
	switch was := last.(type) {
	case api.DiscoveryManaged:
		_, isManaged := next.(api.DiscoveryManaged)
		stateChanged = !isManaged
	case api.DiscoveryAbsent:
		is, isAbsent := next.(api.DiscoveryAbsent)
		stateChanged = !isAbsent || is.Reason != was.Reason
	}
	return change, stateChanged || len(change.Added) > 0 || len(change.Updated) > 0 || len(change.Removed) > 0, nil
}

// SubscribeDiscovery reads a launcher's document now and then every interval,
// and tells of each change. The first read is always told of. After it, a
// read that changed nothing is not: only an entry added, changed or removed,
// and a change of state, which carries every entry it brought or took away.
// Each range over what it gives reads on its own, and reading stops when ctx
// is done or the range ends. A read that cannot be told of is told as its
// error, and reading stops.
func SubscribeDiscovery(ctx context.Context, transport DiscoveryTransport, interval time.Duration) iter.Seq2[api.DiscoveryDiff, error] {
	return func(yield func(api.DiscoveryDiff, error) bool) {
		var last state
		for ctx.Err() == nil {
			change, changed, err := changeOf(ctx, transport, last)
			if err != nil {
				yield(api.DiscoveryDiff{}, err)
				return
			}
			if changed {
				last = change.found
				if !yield(change.diff, nil) {
					return
				}
			}
			select {
			case <-ctx.Done():
			case <-time.After(interval):
			}
		}
	}
}

// told is a change read, and the state it was read from.
type told struct {
	diff  api.DiscoveryDiff
	found state
}

// changeOf reads transport once, and is what changed since last, and whether
// anything did. A read cut short by the end of the subscription is not told
// of.
func changeOf(ctx context.Context, transport DiscoveryTransport, last state) (told, bool, error) {
	read, err := transport.Read(ctx)
	if err != nil {
		return told{}, false, err
	}
	found, isState, err := stateIn(read)
	if err != nil || !isState || ctx.Err() != nil {
		return told{}, false, err
	}
	change, changed, err := diff(last, found)
	return told{diff: change, found: found}, changed, err
}

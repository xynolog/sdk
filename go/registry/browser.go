// Package registry is what an application holds beside its knowledge bases:
// the list of the ones it has registered, which of them is active, the active
// one's session, and what a person has open in each. It builds sessions
// through the SessionFactory it is given, and so knows nothing of how a
// knowledge base is reached; HttpSessionFactory reaches one over its gateway.
// A person's sign-in by a page redirect lands here (BeginSignIn,
// CompleteSignIn).
//
// One session is live at a time, the active knowledge base's. Making another
// active closes it first: its readers see no session, then the new one.
// Activations do not overlap, and one that was overtaken while it waited does
// nothing. SessionActivating is true while one is under way, which is what
// tells "a session is coming" from "there is none".
//
// Look up by address, verify by did. A sign-in lands on the entry, among those
// at the address, whose did is the one the knowledge base reported, or on a
// new entry. The address, the entry a person re-authenticated and the row they
// clicked say what they believed, and are reported back, never acted on. So an
// entry's did never changes, and its label and last read are written only from
// an answer that carried its did.
//
// What is open is per knowledge base, and shown only while that knowledge base
// has a live session. When a session comes up, the knowledge base is asked who
// it is and each open resource is checked against it:
//
//   - a resource the knowledge base says does not exist is closed; one whose
//     check failed any other way stays open;
//   - a different knowledge base answering voids what was open and where the
//     person was, and raises the conflict for a host to show. The entry is
//     left as it was written;
//   - no answer is no verdict, and changes nothing.
//
// A request refused for lack of permission is said at once. A refusal for
// want of a valid token is renewed by the transport that met it, and the
// registry does nothing with it, nor with any other failure of the transport.
//
// Every change to what is open is made against what the storage holds, as one
// step, so two contexts that each open a resource both keep theirs. A write the
// storage refuses changes nothing, there or here; a method that writes returns
// the refusal, and Close returns one made in the background.
//
// Close is the graceful end.
package registry

import (
	"context"
	"encoding/json"
	"errors"
	"iter"
	"slices"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"github.com/google/uuid"
	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/internal/kept"
	"github.com/xynolog/sdk/go/internal/optional"
	"github.com/xynolog/sdk/go/internal/required"
)

// XynologBrowserConfig is what a registry is made of.
type XynologBrowserConfig struct {
	// Storage is where everything the registry keeps is kept.
	Storage xynolog.SessionStorage
	// SessionFactory is what builds a knowledge base's session.
	SessionFactory SessionFactory
}

// XynologBrowser is a registry of knowledge bases: see the package's
// documentation.
type XynologBrowser struct {
	storage xynolog.SessionStorage
	factory SessionFactory

	knowledgeBases    *held[[]api.KnowledgeBase]
	activeKbID        *xynolog.Variable[string]
	activeSession     *xynolog.Variable[*xynolog.Session]
	activeSignals     *xynolog.Variable[*xynolog.SessionSignals]
	sessionActivating *xynolog.Variable[bool]
	openResources     *held[[]api.OpenResource]
	lastViewed        *xynolog.Variable[api.ResourceId]
	identityToken     *xynolog.Variable[string]
	failures          *kept.Stream[*xynolog.SessionError]
	bus               *xynolog.EventBus

	// mu guards what the registry keeps in memory of what its storage holds,
	// and the live session's end.
	mu             sync.Mutex
	openByKb       map[string][]api.OpenResource
	lastViewedByKb map[string]api.ResourceId
	// activations is how many are under way or waiting their turn.
	activations int
	// liveEnd ends the live session and its client; nil while there is none.
	liveEnd func()

	// turn lets one activation run at a time: whoever holds its one slot. A
	// channel, so one waiting its turn is blocked as a channel's reader is,
	// which a paused test clock waits on.
	turn chan struct{}
	// alive ends when the registry is closed: what it runs runs under it.
	alive context.Context
	stop  context.CancelFunc
	tasks sync.WaitGroup
	// taskFailure is the first failure of what it ran in the background:
	// Close returns it. Guarded by mu.
	taskFailure   error
	stopListening func()
	closed        atomic.Bool
}

// NewXynologBrowser is a registry over what config.Storage holds. The active
// knowledge base's session is brought up at once, in the background. What was
// read is what is kept: an entry that did not read as a knowledge base is gone
// from the storage too. A storage that refuses those writes is the error, and
// no registry is made.
func NewXynologBrowser(config XynologBrowserConfig) (*XynologBrowser, error) {
	storage := config.Storage
	kbs := LoadKnowledgeBases(storage)
	active, _ := storage.Get(ActiveKey)
	if !slices.ContainsFunc(kbs, func(kb api.KnowledgeBase) bool { return kb.Id == active }) {
		active = ""
		if len(kbs) > 0 {
			active = kbs[0].Id
		}
	}
	alive, stop := context.WithCancel(context.Background())
	b := &XynologBrowser{
		storage:           storage,
		factory:           config.SessionFactory,
		knowledgeBases:    newHeld([]api.KnowledgeBase{}),
		activeKbID:        xynolog.NewVariable(""),
		activeSession:     xynolog.NewVariable[*xynolog.Session](nil),
		activeSignals:     xynolog.NewVariable[*xynolog.SessionSignals](nil),
		sessionActivating: xynolog.NewVariable(false),
		openResources:     newHeld([]api.OpenResource{}),
		lastViewed:        xynolog.NewVariable(api.ResourceId{}),
		identityToken:     xynolog.NewVariable(""),
		failures:          kept.NewStream[*xynolog.SessionError](xynolog.DefaultTiming().ErrorsKeptForFirstReaderCount),
		bus:               xynolog.NewEventBus(),
		openByKb:          openByKbOf(storage.Get(OpenResourcesByKbKey)),
		lastViewedByKb:    lastViewedByKbOf(storage.Get(LastViewedResourceByKbKey)),
		turn:              make(chan struct{}, 1),
		alive:             alive,
		stop:              stop,
	}
	if err := b.putKbs(kbs); err != nil {
		stop()
		return nil, err
	}
	if err := b.putActiveID(active); err != nil {
		stop()
		return nil, err
	}

	if stopListening, ok := storage.Subscribe(b.writtenElsewhere); ok {
		b.stopListening = stopListening
	}
	if active != "" {
		b.spawn(func() error { return b.setActiveKb(active) })
	}
	return b, nil
}

// ── What it holds ───────────────────────────────────────────────────────

// KnowledgeBases is the registered knowledge bases.
func (b *XynologBrowser) KnowledgeBases() xynolog.Watched[[]api.KnowledgeBase] {
	return b.knowledgeBases
}

// ActiveKbId is the id of the active knowledge base; "" for none. It names
// the one meant: its session may still be on its way, or there may be none.
func (b *XynologBrowser) ActiveKbId() xynolog.Watched[string] { return b.activeKbID.Reading() }

// ActiveSession is the active knowledge base's session; nil when it has none.
func (b *XynologBrowser) ActiveSession() xynolog.Watched[*xynolog.Session] {
	return b.activeSession.Reading()
}

// ActiveSignals is what a host shows about the active session. There exactly
// when the session is.
func (b *XynologBrowser) ActiveSignals() xynolog.Watched[*xynolog.SessionSignals] {
	return b.activeSignals.Reading()
}

// SessionActivating is whether a session is being brought up.
func (b *XynologBrowser) SessionActivating() xynolog.Watched[bool] {
	return b.sessionActivating.Reading()
}

// OpenResources is what is open in the active knowledge base, in order.
// Empty while it has no live session.
func (b *XynologBrowser) OpenResources() xynolog.Watched[[]api.OpenResource] { return b.openResources }

// LastViewedResource is the resource last viewed in the active knowledge
// base; the zero id while it has no live session, and never another knowledge
// base's.
func (b *XynologBrowser) LastViewedResource() xynolog.Watched[api.ResourceId] {
	return b.lastViewed.Reading()
}

// Errors is the failures its sessions say of their own (each a
// *xynolog.SessionError among xynolog.Session's Errors, which the registry
// reads from the first thing each session said): those that made a session
// unusable, those that stopped a session's client keeping what it holds, and
// each write its storage refused, from this call on, in order, however far
// behind its reader falls, until ctx is done or the registry is closed; saying
// never waits for a reader. The first call is given first the latest
// ErrorsKeptForFirstReaderCount (xynolog.Timing) said before it, the oldest
// dropped beyond them; a call once the registry has closed, nothing.
func (b *XynologBrowser) Errors(ctx context.Context) iter.Seq[*xynolog.SessionError] {
	return b.failures.Reported(ctx.Done())
}

// IdentityToken is the token of an identity the host's environment supplies;
// "" for none.
func (b *XynologBrowser) IdentityToken() xynolog.Watched[string] { return b.identityToken.Reading() }

// SetIdentityToken sets the identity token; "" for none.
func (b *XynologBrowser) SetIdentityToken(token string) { b.identityToken.Set(token) }

// Storage is where the registry keeps what it keeps: what a sign-in that is
// under way is remembered in, too.
func (b *XynologBrowser) Storage() xynolog.SessionStorage { return b.storage }

// Bus is the application's own bus: what its parts say to each other whether
// or not a knowledge base is active. Apart from a client's own bus, which
// carries what happens in one knowledge base.
func (b *XynologBrowser) Bus() *xynolog.EventBus { return b.bus }

// ── The knowledge bases ─────────────────────────────────────────────────

// AddKb registers a knowledge base that a sign-in reached, keeps its tokens,
// and makes it the active one, returning once its session is up or known not
// to be.
func (b *XynologBrowser) AddKb(input api.NewKnowledgeBase, session api.StoredSession) (api.KnowledgeBase, error) {
	kb := api.KnowledgeBase{Id: uuid.NewString(), Label: input.Label, Did: input.Did, Endpoint: input.Endpoint, LastRead: input.LastRead}
	if err := StoreSession(b.storage, kb.Id, session); err != nil {
		return api.KnowledgeBase{}, err
	}
	if err := b.putKbs(append(slices.Clone(b.knowledgeBases.Value()), kb)); err != nil {
		return api.KnowledgeBase{}, err
	}
	return kb, b.setActiveKb(kb.Id)
}

// RemoveKb forgets a knowledge base: its entry, its saved sign-in, what was
// open in it and where the person was. If it was active, its session is
// closed and the first of the others becomes active. Then what its sessions
// kept of the person its sign-in named is deleted (forgetKept): forgetting a
// saved sign-in deletes its person's entries, once the client has closed, so
// nothing its closing writes is left.
func (b *XynologBrowser) RemoveKb(id string) error {
	stored, _, err := swapStoredSession(b.storage, id, nil)
	if err != nil {
		return err
	}
	if err := b.forgetOpenIn(id); err != nil {
		return err
	}
	rest := slices.DeleteFunc(slices.Clone(b.knowledgeBases.Value()), func(kb api.KnowledgeBase) bool { return kb.Id == id })
	next := ""
	if len(rest) > 0 {
		next = rest[0].Id
	}
	if err := b.putKbs(rest); err != nil {
		return err
	}
	if b.activeKbID.Value() == id {
		if err := b.setActiveKb(next); err != nil {
			return err
		}
	}
	return forgetKept(b.storage, id, stored.PersonKey)
}

// UpdateKb writes what a knowledge base last said of itself onto its entry: a
// label, unless it is nil, and a last read, unless it is nil. Its endpoint is
// not changed in place, and its did is never changed.
func (b *XynologBrowser) UpdateKb(id string, label *string, lastRead *api.KbRead) error {
	kbs := slices.Clone(b.knowledgeBases.Value())
	for i := range kbs {
		if kbs[i].Id != id {
			continue
		}
		if label != nil {
			kbs[i].Label = *label
		}
		if lastRead != nil {
			read := *lastRead
			kbs[i].LastRead = &read
		}
	}
	return b.putKbs(kbs)
}

// KbSessionStatus is what the credential stored for a knowledge base says,
// read without asking anyone.
func (b *XynologBrowser) KbSessionStatus(kbID string) api.KbSessionStatus {
	stored, ok := StoredSessionOf(b.storage, kbID)
	switch {
	case !ok:
		return api.KbSessionStatusSignedOut
	case xynolog.IsTokenExpired(stored.Access, time.Now()):
		return api.KbSessionStatusExpired
	default:
		return api.KbSessionStatusAuthenticated
	}
}

// SetActiveKb makes a knowledge base the active one, or none for "". It
// returns once its session is up, or once it is known there will be none.
func (b *XynologBrowser) SetActiveKb(id string) error { return b.setActiveKb(id) }

// SignIn keeps a new sign-in for a registered knowledge base in place of the
// one stored, and brings its session up on it. A session it already had is
// closed and replaced. Then, before the new one is built, what its sessions
// kept of the person the replaced sign-in named is deleted (forgetKept): a new
// sign-in names nobody until its gateway names them, so keeping one forgets
// the saved sign-in it replaces, once the client has closed, so nothing its
// closing writes is left.
func (b *XynologBrowser) SignIn(id string, session api.StoredSession) error {
	if b.closed.Load() {
		return nil
	}
	replaced, _, err := swapStoredSession(b.storage, id, &session)
	if err != nil {
		return err
	}
	// A session it already has is on the old tokens: it is closed, and the
	// one built next reads the new ones.
	if b.activeKbID.Value() == id {
		if taken := b.takeSession(); taken != nil {
			taken.close()
		}
	}
	if err := forgetKept(b.storage, id, replaced.PersonKey); err != nil {
		return err
	}
	return b.setActiveKb(id)
}

// SignedIn is the registry's half of a sign-in: it lands the sign-in on the
// entry for the knowledge base that answered (see the package's
// documentation). A description whose domain no did can hold is refused, and
// nothing is registered.
func (b *XynologBrowser) SignedIn(signedIn api.SignedIn) (api.SignInOutcome, error) {
	did, err := xynolog.KbDid(signedIn.Description.Domain)
	if err != nil {
		return api.SignInOutcome{}, err
	}
	label := signedIn.Description.Name
	lastRead := kbReadOf(signedIn.Description, time.Now())
	kbs := b.knowledgeBases.Value()
	var atAddress []api.KnowledgeBase
	for _, kb := range kbs {
		if samePlace(kb.Endpoint, signedIn.Endpoint) {
			atAddress = append(atAddress, kb)
		}
	}
	// An address with several entries singles out no belief of its own.
	var believed *api.KnowledgeBase
	switch {
	case signedIn.KbId != nil:
		if i := slices.IndexFunc(kbs, func(kb api.KnowledgeBase) bool { return kb.Id == *signedIn.KbId }); i >= 0 {
			believed = &kbs[i]
		}
	case len(atAddress) == 1:
		believed = &atAddress[0]
	}
	var expected *api.Expected
	switch {
	case signedIn.ExpectedDid != nil:
		expected = &api.Expected{Did: *signedIn.ExpectedDid, Name: signedIn.ExpectedName}
	case believed != nil:
		expected = &api.Expected{Did: believed.Did, Name: new(believed.Label)}
	}

	if i := slices.IndexFunc(atAddress, func(kb api.KnowledgeBase) bool { return kb.Did == did.String() }); i >= 0 {
		kb := atAddress[i]
		kb.Label, kb.LastRead = label, &lastRead
		if err := b.UpdateKb(kb.Id, &label, &lastRead); err != nil {
			return api.SignInOutcome{}, err
		}
		return api.SignInOutcome{Kb: kb, Expected: expected}, b.SignIn(kb.Id, signedIn.Session)
	}
	kb, err := b.AddKb(api.NewKnowledgeBase{Label: label, Did: did.String(), Endpoint: signedIn.Endpoint, LastRead: &lastRead}, signedIn.Session)
	return api.SignInOutcome{Kb: kb, Expected: expected}, err
}

// SignOut signs out of a knowledge base: its tokens are forgotten, and the
// issuer is told so its refresh token is good for nothing. If it is active,
// its session is closed. Then what its sessions kept of the person its
// sign-in named is deleted (forgetKept): forgetting a saved sign-in deletes
// its person's entries, once the client has closed, so nothing its closing
// writes is left.
func (b *XynologBrowser) SignOut(id string) error {
	if b.closed.Load() {
		return nil
	}
	stored, ok, err := swapStoredSession(b.storage, id, nil)
	if err != nil {
		return err
	}
	if ok {
		// The sign-out is the local act: an issuer that cannot be reached
		// does not keep anyone in a session they asked to end, and Close
		// does not wait for it to be told.
		go b.factory.Revoke(b.alive, stored)
	}
	// Said again, so whoever shows each knowledge base's status reads it anew.
	b.knowledgeBases.raise(b.knowledgeBases.Value())
	if b.activeKbID.Value() == id {
		if taken := b.takeSession(); taken != nil {
			taken.close()
		}
	}
	return forgetKept(b.storage, id, stored.PersonKey)
}

// ── What is open ────────────────────────────────────────────────────────

// AddOpenResource opens a resource in the active knowledge base, or, when it
// is open already, takes its name, and its media type and storage URI unless
// each is "". Nothing is opened while it has no live session.
func (b *XynologBrowser) AddOpenResource(id api.ResourceId, name, mediaType, storageURI string) error {
	return b.mutateOpenResources(func(open []api.OpenResource) []api.OpenResource {
		for i := range open {
			if open[i].Id != id {
				continue
			}
			open[i].Name = name
			if mediaType != "" {
				open[i].MediaType = &mediaType
			}
			if storageURI != "" {
				open[i].StorageUri = &storageURI
			}
			return open
		}
		// After the last place taken, not the count: a place freed by a
		// removal is not handed out twice.
		order := 0
		for _, resource := range open {
			order = max(order, resource.Order+1)
		}
		return append(open, api.OpenResource{Id: id, Name: name, OpenedAt: int(time.Now().UnixMilli()), Order: order, MediaType: optional.Text(mediaType), StorageUri: optional.Text(storageURI)})
	})
}

// RemoveOpenResource closes a resource in the active knowledge base.
func (b *XynologBrowser) RemoveOpenResource(id api.ResourceId) error {
	return b.mutateOpenResources(func(open []api.OpenResource) []api.OpenResource {
		return slices.DeleteFunc(open, func(resource api.OpenResource) bool { return resource.Id == id })
	})
}

// UpdateOpenResourceName gives an open resource of the active knowledge base
// a name.
func (b *XynologBrowser) UpdateOpenResourceName(id api.ResourceId, name string) error {
	return b.mutateOpenResources(func(open []api.OpenResource) []api.OpenResource {
		for i := range open {
			if open[i].Id == id {
				open[i].Name = name
			}
		}
		return open
	})
}

// ReorderOpenResources moves the open resource at one place in the visible
// list to another. A place that is not in the list moves nothing.
func (b *XynologBrowser) ReorderOpenResources(from, to int) error {
	return b.mutateOpenResources(func(open []api.OpenResource) []api.OpenResource {
		if from < 0 || to < 0 || from >= len(open) || to >= len(open) {
			return open
		}
		ordered := SortOpenResources(open)
		moved := ordered[from]
		ordered = slices.Insert(slices.Delete(ordered, from, from+1), to, moved)
		for place := range ordered {
			ordered[place].Order = place
		}
		return ordered
	})
}

// SetLastViewedResource records the resource a person is looking at, in the
// active knowledge base. Nothing is recorded while it has no live session.
func (b *XynologBrowser) SetLastViewedResource(id api.ResourceId) error {
	kbID := b.liveKbID()
	if kbID == "" {
		return nil
	}
	return b.mutateLastViewed(func(viewed map[string]api.ResourceId) { viewed[kbID] = id })
}

// ReadActiveKb asks the active knowledge base to describe itself again, and
// says what it answered. Asking is not activating: an answer as the entry is
// recorded on it, and a different knowledge base answering is reported.
// Nothing is voided and nothing raised.
func (b *XynologBrowser) ReadActiveKb(ctx context.Context) (api.KbReadVerdict, error) {
	session, kbID := b.activeSession.Value(), b.activeKbID.Value()
	if session == nil || kbID == "" {
		return noVerdict()
	}
	return b.readKb(ctx, session, kbID)
}

// Close ends the registry: its session is closed, and everything it holds
// ends. It returns once what it was running has stopped, with the first
// failure of any of it. A call it made to the session factory is told to stop,
// by the end of the context it was given, and is not waited for: a session the
// factory hands back afterwards is ended at once. So Close called from within
// the factory returns too. Called from within the storage, in a write the
// registry is making, it does not return: it waits for that write. Closing
// twice is closing once.
func (b *XynologBrowser) Close() error {
	b.mu.Lock()
	closing := !b.closed.Swap(true)
	b.mu.Unlock()
	if !closing {
		return nil
	}
	taken := b.takeSession()
	b.stop()
	if b.stopListening != nil {
		b.stopListening()
	}
	if taken != nil {
		taken.close()
	}
	b.tasks.Wait()
	b.failures.Close()
	b.knowledgeBases.end()
	b.activeKbID.End()
	b.activeSession.End()
	b.activeSignals.End()
	b.sessionActivating.End()
	b.openResources.end()
	b.lastViewed.End()
	b.identityToken.End()
	b.bus.Close()
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.taskFailure
}

// ── Within ──────────────────────────────────────────────────────────────

// spawn runs work under the registry's lifetime; Close waits for it, and
// returns what it failed with.
func (b *XynologBrowser) spawn(work func() error) {
	b.tasks.Add(1)
	go func() {
		defer b.tasks.Done()
		if err := work(); err != nil {
			b.mu.Lock()
			if b.taskFailure == nil {
				b.taskFailure = err
			}
			b.mu.Unlock()
		}
	}()
}

// samePlace is whether two endpoints are one place: for a gateway, its origin
// (the protocol, the host in lowercase and the port); for a loaded knowledge
// base, its id.
func samePlace(one, other api.KbEndpoint) bool {
	oneKind, err := one.Discriminator()
	if err != nil {
		return false
	}
	otherKind, err := other.Discriminator()
	if err != nil || oneKind != otherKind {
		return false
	}
	switch oneKind {
	case string(api.HttpEndpointKindHttp):
		var a, b api.HttpEndpoint
		errA, errB := one.As(&a), other.As(&b)
		return errA == nil && errB == nil && a.Protocol == b.Protocol && strings.ToLower(a.Host) == strings.ToLower(b.Host) && a.Port == b.Port
	case string(api.LocalEndpointKindLocal):
		var a, b api.LocalEndpoint
		errA, errB := one.As(&a), other.As(&b)
		return errA == nil && errB == nil && a.KbId == b.KbId
	}
	return false
}

// kbReadOf is what a knowledge base said of itself at at, beyond its name:
// the time as RFC 3339, in UTC, to the millisecond.
func kbReadOf(description api.KbDescription, at time.Time) api.KbRead {
	return api.KbRead{At: at.UTC().Format("2006-01-02T15:04:05.000Z07:00"), GitBranch: description.GitBranch}
}

// openByKbOf is what is stored of each knowledge base's open resources; none
// for what does not read as that. One entry that is no open resource, or that
// lacks a member one requires, makes none of it read.
func openByKbOf(stored string, has bool) map[string][]api.OpenResource {
	if !has {
		return map[string][]api.OpenResource{}
	}
	open, ok := required.ReadAs[map[string][]api.OpenResource]([]byte(stored))
	if !ok {
		return map[string][]api.OpenResource{}
	}
	return open
}

// lastViewedByKbOf is what is stored of where the person was in each
// knowledge base; none for what does not read as that.
func lastViewedByKbOf(stored string, has bool) map[string]api.ResourceId {
	viewed := map[string]api.ResourceId{}
	if has && json.Unmarshal([]byte(stored), &viewed) != nil {
		return map[string]api.ResourceId{}
	}
	return viewed
}

func written(value any) string {
	text, err := json.Marshal(value)
	if err != nil {
		// A map of lists of structs of strings and numbers, or of ids each read
		// from the storage or given by a caller as an id, always encodes.
		panic(err)
	}
	return string(text)
}

func (b *XynologBrowser) putKbs(kbs []api.KnowledgeBase) error {
	if b.closed.Load() {
		return nil
	}
	if err := SaveKnowledgeBases(b.storage, kbs); err != nil {
		return err
	}
	b.knowledgeBases.raise(kbs)
	return nil
}

func (b *XynologBrowser) putActiveID(id string) error {
	if b.closed.Load() {
		return nil
	}
	var err error
	if id == "" {
		err = b.storage.Delete(ActiveKey)
	} else {
		err = b.storage.Set(ActiveKey, id)
	}
	if err != nil {
		return err
	}
	b.activeKbID.Set(id)
	return nil
}

func (b *XynologBrowser) failed(err *xynolog.SessionError) { b.failures.Report(err) }

// ── The active session ──────────────────────────────────────────────────

// ended is a live session, and what a host shows about it, taken out of the
// registry to be closed.
type ended struct {
	end     func()
	signals *xynolog.SessionSignals
}

// close ends the session as its factory's end does, the client it was built
// with first, then what a host was shown of it.
func (e *ended) close() {
	e.end()
	if e.signals != nil {
		e.signals.Close()
	}
}

// takeSession takes the live session out: its readers see none, and what is
// open is shown no more. Whoever takes it closes it.
func (b *XynologBrowser) takeSession() *ended {
	b.mu.Lock()
	if b.activeSession.Value() == nil {
		b.mu.Unlock()
		return nil
	}
	taken := &ended{end: b.liveEnd, signals: b.activeSignals.Value()}
	b.liveEnd = nil
	b.activeSession.Set(nil)
	b.activeSignals.Set(nil)
	b.mu.Unlock()
	b.project()
	return taken
}

// putSession puts a session that is up as the live one. The signals first:
// putting the session is what starts the checks of it, and a conflict they
// find is said through the signals. A session is put once, so what is open is
// checked once per session. One that came up as the registry closed is closed
// instead.
func (b *XynologBrowser) putSession(session *xynolog.Session, end func(), signals *xynolog.SessionSignals) {
	b.mu.Lock()
	if b.closed.Load() {
		b.mu.Unlock()
		(&ended{end: end, signals: signals}).close()
		return
	}
	b.liveEnd = end
	b.activeSignals.Set(signals)
	b.activeSession.Set(session)
	b.mu.Unlock()
	b.project()
	b.spawn(func() error { return b.validateOpenResources(session) })
}

func (b *XynologBrowser) setActiveKb(id string) error {
	if b.closed.Load() {
		return nil
	}
	previous := b.activeKbID.Value()
	if id == previous && b.activeSession.Value() != nil {
		return nil
	}
	// Said at once: what is meant now is id, and no session is live. An
	// activation that waited reads this to learn it was overtaken.
	if previous != id {
		if err := b.putActiveID(id); err != nil {
			return err
		}
	}
	taken := b.takeSession()

	b.activating(1)
	defer b.activating(-1)
	b.turn <- struct{}{}
	defer func() { <-b.turn }()
	if taken != nil {
		taken.close()
	}
	if !b.closed.Load() && b.activeKbID.Value() == id {
		// One left live by whoever had the turn before.
		if left := b.takeSession(); left != nil {
			left.close()
		}
		if id != "" {
			b.activate(id)
		}
	}
	return nil
}

func (b *XynologBrowser) activating(change int) {
	b.mu.Lock()
	defer b.mu.Unlock()
	b.activations += change
	b.sessionActivating.Set(b.activations > 0)
}

func (b *XynologBrowser) activate(id string) {
	kbs := b.knowledgeBases.Value()
	i := slices.IndexFunc(kbs, func(kb api.KnowledgeBase) bool { return kb.Id == id })
	if i < 0 {
		return
	}
	// The signals exist before the session does: the session says it is over
	// through them, and may be over before it is ready.
	signals := xynolog.NewSessionSignals()
	handed, ok := b.build(SessionFactoryOptions{Kb: kbs[i], Storage: b.storage, Signals: signals})
	if !ok {
		return
	}
	session, end, err := handed.session, handed.end, handed.err
	if err != nil {
		signals.Close()
		if !b.closed.Load() {
			b.failed(constructFailed(err, id))
		}
		return
	}
	b.spawn(func() error {
		b.route(session, signals)
		return nil
	})
	_ = session.Ready(b.alive)
	if b.closed.Load() || b.activeKbID.Value() != id {
		(&ended{end: end, signals: signals}).close()
		return
	}
	b.putSession(session, end, signals)
}

// built is what the factory handed back for a session.
type built struct {
	session *xynolog.Session
	end     func()
	err     error
}

// build asks the factory for a session on a goroutine of its own, which Close
// does not wait for, and waits for what it hands back until the registry is
// closed: ok is false when the registry closed first. A session handed back
// after that is ended where it is handed back, with what a host was to be
// shown of it.
func (b *XynologBrowser) build(options SessionFactoryOptions) (handed built, ok bool) {
	handing := make(chan built)
	go func() {
		session, end, err := b.factory.Session(b.alive, options)
		select {
		case handing <- built{session: session, end: end, err: err}:
		case <-b.alive.Done():
			if err == nil {
				end()
			}
			options.Signals.Close()
		}
	}()
	select {
	case handed = <-handing:
		return handed, true
	case <-b.alive.Done():
		return built{}, false
	}
}

// constructFailed is a factory's refusal as the failure a registry says: the
// factory's own when it is one.
func constructFailed(err error, kbID string) *xynolog.SessionError {
	var refused *xynolog.SessionError
	if errors.As(err, &refused) {
		return refused
	}
	return &xynolog.SessionError{Code: api.SessionErrorCodeConstructFailed, Message: err.Error(), KbID: kbID}
}

// route reads the session's errors, as their one reader, and so from what
// was said at its start: each of the session's own it says on the registry's
// Errors. A refusal for lack of permission has no remedy, and is said through
// signals; any other failure of its transport, a refusal for want of a valid
// token among them, is not acted on. It ends when the session's errors do,
// when the session ends.
func (b *XynologBrowser) route(session *xynolog.Session, signals *xynolog.SessionSignals) {
	for each := range session.Errors() {
		var own *xynolog.SessionError
		if errors.As(each, &own) {
			b.failed(own)
			continue
		}
		var failure *xynolog.TransportError
		if errors.As(each, &failure) && failure.Code == api.TransportErrorCodeForbidden {
			detail := failure.Message
			signals.NotifyPermissionDenied(&detail)
		}
	}
}

// ── What is shown ───────────────────────────────────────────────────────

// liveKbID is the id of the active knowledge base when it has a live
// session; "" otherwise.
func (b *XynologBrowser) liveKbID() string {
	if b.activeSession.Value() == nil {
		return ""
	}
	return b.activeKbID.Value()
}

// project shows what is open, and where the person was, in the active
// knowledge base: only while it has a live session.
func (b *XynologBrowser) project() {
	b.mu.Lock()
	open := []api.OpenResource{}
	var viewed api.ResourceId
	if kbID := b.liveKbID(); kbID != "" {
		open = SortOpenResources(b.openByKb[kbID])
		viewed = b.lastViewedByKb[kbID]
	}
	b.mu.Unlock()
	b.openResources.set(open)
	b.lastViewed.Set(viewed)
}

// mutateOpenResources changes what is open in the active knowledge base,
// against what the storage holds, as one step.
func (b *XynologBrowser) mutateOpenResources(mutate func([]api.OpenResource) []api.OpenResource) error {
	kbID := b.liveKbID()
	if kbID == "" {
		return nil
	}
	var committed map[string][]api.OpenResource
	err := b.storage.Update(OpenResourcesByKbKey, func(stored string, has bool) (string, bool) {
		open := openByKbOf(stored, has)
		open[kbID] = mutate(slices.Clone(open[kbID]))
		committed = open
		return written(open), true
	})
	if err != nil {
		return err
	}
	b.mu.Lock()
	b.openByKb = committed
	b.mu.Unlock()
	b.project()
	return nil
}

func (b *XynologBrowser) mutateLastViewed(mutate func(map[string]api.ResourceId)) error {
	var committed map[string]api.ResourceId
	err := b.storage.Update(LastViewedResourceByKbKey, func(stored string, has bool) (string, bool) {
		viewed := lastViewedByKbOf(stored, has)
		mutate(viewed)
		committed = viewed
		return written(viewed), true
	})
	if err != nil {
		return err
	}
	b.mu.Lock()
	b.lastViewedByKb = committed
	b.mu.Unlock()
	b.project()
	return nil
}

// forgetOpenIn forgets what was open in a knowledge base and where the person
// was.
func (b *XynologBrowser) forgetOpenIn(kbID string) error {
	var committed map[string][]api.OpenResource
	err := b.storage.Update(OpenResourcesByKbKey, func(stored string, has bool) (string, bool) {
		open := openByKbOf(stored, has)
		delete(open, kbID)
		committed = open
		return written(open), true
	})
	if err != nil {
		return err
	}
	b.mu.Lock()
	b.openByKb = committed
	b.mu.Unlock()
	return b.mutateLastViewed(func(viewed map[string]api.ResourceId) { delete(viewed, kbID) })
}

// writtenElsewhere hears another context change what is open, or where the
// person was.
func (b *XynologBrowser) writtenElsewhere(key, value string, has bool) {
	if b.closed.Load() || !has {
		return
	}
	switch key {
	case OpenResourcesByKbKey:
		open, ok := required.ReadAs[map[string][]api.OpenResource]([]byte(value))
		if !ok {
			return
		}
		b.mu.Lock()
		b.openByKb = open
		b.mu.Unlock()
	case LastViewedResourceByKbKey:
		var viewed map[string]api.ResourceId
		if json.Unmarshal([]byte(value), &viewed) != nil {
			return
		}
		b.mu.Lock()
		b.lastViewedByKb = viewed
		b.mu.Unlock()
	default:
		return
	}
	b.project()
}

// ── The checks a session's arrival starts ───────────────────────────────

func (b *XynologBrowser) validateOpenResources(session *xynolog.Session) error {
	// The session's own knowledge base: by the time this runs, another may be
	// the active one.
	kbID := session.Kb().Id
	isLive := func() bool {
		live := b.activeSession.Value()
		return !b.closed.Load() && live != nil && live.Id() == session.Id()
	}

	// Who it is, first: if a different knowledge base is answering, every
	// answer about a resource would be an answer to a question asked of the
	// wrong one.
	verdict, err := b.readKb(b.alive, session, kbID)
	if err != nil {
		return err
	}
	read, err := verdict.Member()
	if err != nil {
		return err
	}
	if conflict, ok := read.(api.KbReadVerdictConflict); ok {
		// The read was of this session's knowledge base: what it voids is the
		// active one's, so only while this is still the active one.
		if isLive() {
			return b.voidForConflict(kbID, conflict.ObservedDid)
		}
		return nil
	}

	// What the storage holds, not what is in memory: another context may have
	// opened a resource before this session came up.
	var waiting []api.ResourceId
	for _, resource := range openByKbOf(b.storage.Get(OpenResourcesByKbKey))[kbID] {
		waiting = append(waiting, resource.Id)
	}
	if len(waiting) == 0 {
		return nil
	}
	ids := make(chan api.ResourceId, len(waiting))
	for _, id := range waiting {
		ids <- id
	}
	close(ids)
	var mu sync.Mutex
	checks := map[api.ResourceId]api.TabCheck{}
	var lanes sync.WaitGroup
	for range xynolog.DefaultTiming().ChecksAtOnceCount {
		lanes.Go(func() {
			for id := range ids {
				check := checkOpenResource(b.alive, session, id)
				mu.Lock()
				checks[id] = check
				mu.Unlock()
			}
		})
	}
	lanes.Wait()
	if !isLive() {
		return nil
	}
	return b.mutateOpenResources(func(open []api.OpenResource) []api.OpenResource { return ApplyTabChecks(open, checks) })
}

// readKb asks the knowledge base to describe itself, against the entry it is
// asked as. If it is the one the entry says, its name and branch are recorded
// on the entry. Otherwise nothing is recorded.
//
// A did is read one way only. It is not unique, so one that differs says a
// different knowledge base answered, and one that matches says nothing about
// what is in it: that is each resource's own check.
func (b *XynologBrowser) readKb(ctx context.Context, session *xynolog.Session, kbID string) (api.KbReadVerdict, error) {
	kbs := b.knowledgeBases.Value()
	i := slices.IndexFunc(kbs, func(kb api.KnowledgeBase) bool { return kb.Id == kbID })
	if i < 0 {
		return noVerdict()
	}
	description, err := session.Client().Browse.Kb(ctx)
	if err != nil {
		return noVerdict()
	}
	observed, err := xynolog.KbDid(description.Domain)
	if err != nil {
		// A domain no did can hold is a knowledge base that could not say who
		// it is.
		return noVerdict()
	}
	var verdict api.KbReadVerdict
	if observed.String() != kbs[i].Did {
		err := verdict.From(api.KbReadVerdictConflict{ObservedDid: observed.String(), ObservedName: description.Name})
		return verdict, err
	}
	if b.closed.Load() {
		return noVerdict()
	}
	read := kbReadOf(description, time.Now())
	if err := b.UpdateKb(kbID, &description.Name, &read); err != nil {
		return api.KbReadVerdict{}, err
	}
	err = verdict.From(api.KbReadVerdictRecorded{})
	return verdict, err
}

// noVerdict is the verdict of a knowledge base that did not answer, or could
// not say who it is: evidence of nothing.
func noVerdict() (api.KbReadVerdict, error) {
	var verdict api.KbReadVerdict
	err := verdict.From(api.KbReadVerdictNoVerdict{})
	return verdict, err
}

// voidForConflict is what an activation does when a different knowledge base
// answered for the active entry: it voids what claims to be about the entry's
// contents, both at once, and raises the conflict. Registering the knowledge
// base that answered is a person's act.
func (b *XynologBrowser) voidForConflict(kbID, observedDid string) error {
	kbs := b.knowledgeBases.Value()
	i := slices.IndexFunc(kbs, func(kb api.KnowledgeBase) bool { return kb.Id == kbID })
	if i < 0 {
		return nil
	}
	if err := b.mutateOpenResources(func([]api.OpenResource) []api.OpenResource { return []api.OpenResource{} }); err != nil {
		return err
	}
	if err := b.mutateLastViewed(func(viewed map[string]api.ResourceId) { delete(viewed, kbID) }); err != nil {
		return err
	}
	if signals := b.activeSignals.Value(); signals != nil {
		signals.NotifyKbIdentityConflict(api.KbIdentityConflict{ExpectedDid: kbs[i].Did, ObservedDid: observedDid})
	}
	return nil
}

// checkOpenResource is one open resource's verdict. Asking for it freshly
// also puts what it answered in the client's cache, where a viewer reads it.
func checkOpenResource(ctx context.Context, session *xynolog.Session, id api.ResourceId) api.TabCheck {
	var check api.TabCheck
	var written error
	descriptor, err := session.Client().Browse.Resource(id).Fresh(ctx)
	var refusal *xynolog.BusRequestError
	switch {
	case err == nil:
		ready := api.TabCheckReady{Name: descriptor.Name}
		// A descriptor with no primary representation states no media type.
		if mediaType, _, _ := xynolog.PrimaryMediaType(descriptor); mediaType != "" {
			ready.MediaType = &mediaType
		}
		written = check.From(ready)
	case errors.As(err, &refusal) && refusal.Code == api.BusRequestErrorCodeNotFound:
		written = check.From(api.TabCheckGone{})
	default:
		// Anything else is a symptom, not a verdict.
		written = check.From(api.TabCheckUnknown{})
	}
	if written != nil {
		// A member of the union always writes.
		panic(written)
	}
	return check
}

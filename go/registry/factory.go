package registry

// What knows how a knowledge base is reached: it builds the session of one,
// and ends the credentials of one. A registry is given a factory, and so
// manages sessions over any transport without knowing which.

import (
	"context"
	"math/rand/v2"
	"net/http"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

// SessionFactoryOptions is what a session is built from.
type SessionFactoryOptions struct {
	// Kb is the knowledge base the session is for.
	Kb api.KnowledgeBase
	// Storage is where its tokens are kept: the registry's own storage.
	Storage xynolog.SessionStorage
	// Signals is where the session says it is over, for a host to show.
	Signals *xynolog.SessionSignals
}

// SessionFactory builds the sessions a registry activates. A factory reads
// none of a session's errors (xynolog.Session's Errors): the registry is
// their one reader.
type SessionFactory interface {
	// Session builds the session of a knowledge base, and the client it
	// uses, and starts it. end closes the client, waiting for its closing
	// flush, then ends the session, whose errors end then, and then closes
	// what they were built on. A knowledge base this factory cannot reach is
	// refused with a *xynolog.SessionError of code
	// session.construct-failed. ctx ends when the registry is closed: the
	// registry stops waiting then, and ends a session handed back afterwards
	// at once.
	Session(ctx context.Context, options SessionFactoryOptions) (session *xynolog.Session, end func(), err error)
	// Revoke tells whoever issued a stored session that it has been
	// forgotten, so its refresh token is good for nothing. Best effort: the
	// sign-out has happened whether or not the issuer hears of it, and the
	// registry does not wait for it.
	Revoke(ctx context.Context, stored api.StoredSession)
}

// HttpSessionFactory builds the session of each knowledge base a registry
// activates, over its gateway. The session's caches, and the stream's place
// in each scope, are kept in the registry's storage for the person the
// gateway names, under the knowledge base's id and their key, which the
// stored session records; and its token is renewed at the issuer its stored
// session names. Each is written only while the stored session names that
// person (xynolog.SessionFromKeptConfig's Storage): one forgotten, here or by
// another context, or replaced with a sign-in that names nobody or another
// person, has its session write nothing more.
type HttpSessionFactory struct {
	// HTTP is what every request of a gateway and an issuer is made with.
	HTTP *http.Client
	// ClientTiming is the timing each session's client keeps.
	ClientTiming xynolog.ClientTiming
	// TransportTiming is the timing each session's transport keeps, and that
	// of the requests of its issuer, and the session's (xynolog.SessionConfig).
	TransportTiming xynolog.TransportTiming
	// Random is what the jitter of every backoff of its sessions is drawn
	// from, as xynolog.EqualJitter draws it.
	Random *rand.Rand
}

var _ SessionFactory = HttpSessionFactory{}

func (f HttpSessionFactory) Session(ctx context.Context, options SessionFactoryOptions) (*xynolog.Session, func(), error) {
	return xynolog.SessionFromKept(ctx, xynolog.SessionFromKeptConfig{
		Kb:              api.KbTarget{Endpoint: options.Kb.Endpoint, Id: options.Kb.Id, Label: options.Kb.Label},
		Kept:            KeptIn(options.Storage, options.Kb.Id),
		HTTP:            f.HTTP,
		ClientTiming:    f.ClientTiming,
		TransportTiming: f.TransportTiming,
		Random:          f.Random,
		Channels:        bus.BridgedChannels,
		Storage:         options.Storage,
		OnAuthFailed:    options.Signals.NotifySessionEnded,
	})
}

func (f HttpSessionFactory) Revoke(ctx context.Context, stored api.StoredSession) {
	if stored.RevocationEndpoint == nil {
		return
	}
	// Best effort, as the interface says: the sign-out stands either way.
	_ = xynolog.Issuer{HTTP: f.HTTP, Timing: f.TransportTiming, Random: f.Random}.Revoke(ctx, *stored.RevocationEndpoint, stored.ClientId, stored.Refresh)
}

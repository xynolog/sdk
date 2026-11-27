package xynologtest

import (
	"context"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// TestSessionConfig is what a test session is built over.
type TestSessionConfig struct {
	// Client is the test client the session is over.
	Client TestClientConfig
	// Kb is the knowledge base the session is with: with none, test-kb at
	// http://localhost:4000.
	Kb *api.KbTarget
	// Kept is where the session's sign-in is kept: a sign-in held there is
	// the session's at its start. With none, a xynolog.MemorySignIn that holds
	// nothing.
	Kept xynolog.SignInKept
}

// TestSession is a session, and what it was built over.
type TestSession struct {
	Session   *xynolog.Session
	Client    *xynolog.Client
	Transport *FaultyTransport
	Content   *InMemoryContent
	// Kept is where the session's sign-in is kept.
	Kept xynolog.SignInKept
	// Token is the token the session holds. A test that needs a signed-in
	// session sets one.
	Token *xynolog.Variable[string]
}

// NewTestSession is a real xynolog.Session over a test client. It renews
// nothing and asks nobody who it is, so it is ready as soon as it has read its
// sign-in, and holds a token only if one was kept. The caller closes the
// client, then the session, and then the transport: the session only uses
// them.
func NewTestSession(config TestSessionConfig) (TestSession, error) {
	client := NewTestClient(config.Client)
	kb := api.KbTarget{Id: "test-kb", Label: "Test KB"}
	if config.Kb != nil {
		kb = *config.Kb
	} else if err := kb.Endpoint.From(api.HttpEndpoint{Kind: api.HttpEndpointKindHttp, Host: "localhost", Port: 4000, Protocol: api.HttpEndpointProtocolHttp}); err != nil {
		// An endpoint of a host, a port and two of the spec's own words always
		// encodes.
		panic(err)
	}
	kept := config.Kept
	if kept == nil {
		kept = &xynolog.MemorySignIn{}
	}
	token := xynolog.NewVariable("")
	session, err := xynolog.StartSession(context.Background(), xynolog.SessionConfig{
		Kb:     kb,
		Client: client.Client,
		Token:  token,
		Kept:   kept,
		Timing: xynolog.DefaultTransportTiming(),
	})
	if err != nil {
		client.Client.Close()
		client.Transport.Close()
		return TestSession{}, err
	}
	return TestSession{Session: session, Client: client.Client, Transport: client.Transport, Content: client.Content, Kept: kept, Token: token}, nil
}

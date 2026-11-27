//go:build go1.27

// Built by Go 1.27 and later only: its fake network is httptest.NewTestServer's,
// which is new in 1.27, while the module admits 1.26.

package xynolog_test

// The time a client keeps, against protocol/specs/src/client/clock-cases.json.
//
// Each case runs in a testing/synctest bubble, whose clock moves only when
// every goroutine in it is blocked; over a network faked in the bubble
// (httptest.NewTestServer's in-memory network, or a FaultyTransport); at this
// SDK's timings, which are the table's; and with a random source whose every
// draw is the lowest it can give. A pass sleeps the bubble's clock
// through each instant a timer falls due on the way, and lets what falls due
// run there, so a wait ends at the instant it was set to end, or the case
// fails. What the table may say is held by its schema,
// protocol/specs/src/client/ClientClockCases.json, which
// Protocol's reader, protocol/reader, holds it to.

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"maps"
	"math"
	"math/rand/v2"
	"net"
	"net/http"
	"net/http/httptest"
	"slices"
	"strconv"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"testing/synctest"
	"time"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/discovery"
	"github.com/xynolog/sdk/go/xynologtest"
)

// clockCase is one case of the table.
type clockCase struct {
	Subject string            `json:"subject"`
	Case    string            `json:"case"`
	Given   clockGiven        `json:"given"`
	Steps   []json.RawMessage `json:"steps"`
}

// clockGiven is what a case states that its subject leaves open.
type clockGiven struct {
	RetryAfterSeconds *int     `json:"retryAfterSeconds"`
	LifetimeSeconds   *int     `json:"lifetimeSeconds"`
	IntervalSeconds   *int     `json:"intervalSeconds"`
	Answers           []string `json:"answers"`
	Status            *int     `json:"status"`
}

func readClockCases(t *testing.T) []clockCase {
	t.Helper()
	var table struct {
		Comment string      `json:"$comment"`
		Cases   []clockCase `json:"cases"`
	}
	strictly(t, readSpec(t, "client", "clock-cases.json"), &table)
	if len(table.Cases) == 0 {
		t.Fatal("the table states no case: it was not read")
	}
	return table.Cases
}

// ── Durations ───────────────────────────────────────────────────────────

// timingValues is each value protocol/specs/src/client/timing.json states, by
// its row's name.
func timingValues(t *testing.T) map[string]json.RawMessage {
	t.Helper()
	var table struct {
		Timing []struct {
			Name  string          `json:"name"`
			Value json.RawMessage `json:"value"`
		} `json:"timing"`
	}
	if err := json.Unmarshal(readSpec(t, "client", "timing.json"), &table); err != nil {
		t.Fatal(err)
	}
	if len(table.Timing) == 0 {
		t.Fatal("the timing table states no row: it was not read")
	}
	values := map[string]json.RawMessage{}
	for _, row := range table.Timing {
		values[row.Name] = row.Value
	}
	return values
}

// clockTiming is the duration timings states under name: "reconnectMs" is that
// row's value, and a retry budget's member follows its budget and a ".",
// "emitRetry.initialDelayMs", in milliseconds as the table states it.
func clockTiming(timings map[string]json.RawMessage, name string) (time.Duration, error) {
	entry, member, ofBudget := strings.Cut(name, ".")
	var ms int64
	if !ofBudget {
		if !strings.HasSuffix(entry, "Ms") || json.Unmarshal(timings[entry], &ms) != nil {
			return 0, fmt.Errorf("%s is no duration of the timing table", name)
		}
		return time.Duration(ms) * time.Millisecond, nil
	}
	var budget map[string]int64
	if json.Unmarshal(timings[entry], &budget) != nil {
		return 0, fmt.Errorf("%s is no retry budget of the timing table", name)
	}
	ms, stated := budget[member]
	if !stated || !strings.HasSuffix(member, "Ms") {
		return 0, fmt.Errorf("%s is no delay of the timing table", name)
	}
	return time.Duration(ms) * time.Millisecond, nil
}

// clockDuration is a duration as the table states it: milliseconds, or a
// timing scaled by `times` and moved by `plusMs`, a whole number of
// milliseconds either way.
func clockDuration(timings map[string]json.RawMessage, stated json.RawMessage) (time.Duration, error) {
	var ms int64
	if json.Unmarshal(stated, &ms) == nil {
		return time.Duration(ms) * time.Millisecond, nil
	}
	var scaled struct {
		Timing string   `json:"timing"`
		Times  *float64 `json:"times"`
		PlusMs *int64   `json:"plusMs"`
	}
	decoder := json.NewDecoder(bytes.NewReader(stated))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&scaled); err != nil || scaled.Timing == "" {
		return 0, fmt.Errorf("%s is no duration: milliseconds, or a timing", stated)
	}
	base, err := clockTiming(timings, scaled.Timing)
	if err != nil {
		return 0, err
	}
	times, plus := 1.0, int64(0)
	if scaled.Times != nil {
		times = *scaled.Times
	}
	if scaled.PlusMs != nil {
		plus = *scaled.PlusMs
	}
	whole := float64(base.Milliseconds())*times + float64(plus)
	if whole != math.Trunc(whole) {
		return 0, fmt.Errorf("%s is not a whole number of milliseconds", stated)
	}
	return time.Duration(whole) * time.Millisecond, nil
}

// ── What a case drives ──────────────────────────────────────────────────

// lowestDraws is a source whose every draw is the lowest it can give, so the
// equal jitter of a step is half the step.
type lowestDraws struct{}

func (lowestDraws) Uint64() uint64 { return 0 }

// lowest is the random source every subject that backs off is given.
var lowest = rand.New(lowestDraws{})

// clockSubject is what a case drives: what it counts, and its action, when it
// has one.
type clockSubject struct {
	counted func() int
	act     func() error
}

// background runs work on a goroutine of its own until the case is over: it
// is cancelled then, and waited for.
func background(t *testing.T, work func(ctx context.Context)) {
	ctx, cancel := context.WithCancel(context.Background())
	done := make(chan struct{})
	go func() {
		defer close(done)
		work(ctx)
	}()
	t.Cleanup(func() {
		cancel()
		<-done
	})
}

// tallied is how many of the values watched comes to hold counts counts, from
// now on. A reader of a changing value is given the latest when it reads, so
// two changes between its reads are read as one: each count of a case comes
// after the bubble has settled, in which the reader reads every change before
// it.
func tallied[T any](t *testing.T, watched xynolog.Watched[T], counts func(T) bool) func() int {
	var seen atomic.Int64
	background(t, func(ctx context.Context) {
		for value := range watched.Changes(ctx) {
			if counts(value) {
				seen.Add(1)
			}
		}
	})
	return func() int { return int(seen.Load()) }
}

// ── The gateway ─────────────────────────────────────────────────────────

const (
	gatewayOrigin = "http://gateway.test"
	subscribePath = "/bus/subscribe"
	emitPath      = "/bus/emit"
	healthPath    = "/api/health"
)

// streamAnswer is how a gateway answers a subscribe.
type streamAnswer int

const (
	// streamHeld is a stream it holds open and says nothing on.
	streamHeld streamAnswer = iota
	// streamRefused is a 503.
	streamRefused
	// streamUnanswered is no answer at all.
	streamUnanswered
)

// fakeGateway is a gateway in the bubble. It answers each request at once, as
// the subject has it answer, and counts what it is asked.
type fakeGateway struct {
	t          *testing.T
	stream     streamAnswer
	retryAfter *int
	refused    []string
	unanswered []string
	// over is closed once the case is over: what the gateway still holds lets
	// go then, before the server closes, which waits for every answer under
	// way.
	over   chan struct{}
	client *http.Client

	mu     sync.Mutex
	asked  map[string]int
	closed int
}

// newFakeGateway is a gateway that answers a subscribe as stream says,
// refuses a request of the paths refused names with a 503, and never answers
// a request of the paths unanswered names. Its refusals carry a Retry-After
// of retryAfter seconds when there is one.
func newFakeGateway(t *testing.T, stream streamAnswer, retryAfter *int, refused []string, unanswered ...string) *fakeGateway {
	g := &fakeGateway{t: t, stream: stream, retryAfter: retryAfter, refused: refused, unanswered: unanswered, over: make(chan struct{}), asked: map[string]int{}}
	g.client = httptest.NewTestServer(t, g).Client()
	t.Cleanup(func() { close(g.over) })
	return g
}

func (g *fakeGateway) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// The server hears that its client has gone only once the request's body
	// has been read.
	if _, err := io.Copy(io.Discard, r.Body); err != nil {
		g.t.Errorf("the gateway could not read %s %s: %v", r.Method, r.URL.Path, err)
		return
	}
	g.mu.Lock()
	g.asked[r.URL.Path]++
	g.mu.Unlock()
	if slices.Contains(g.unanswered, r.URL.Path) {
		g.never(r)
		return
	}
	if slices.Contains(g.refused, r.URL.Path) {
		g.refuse(w, r)
		return
	}
	if r.URL.Path != subscribePath {
		g.t.Errorf("the gateway was asked %s %s, which this subject does not have it answer", r.Method, r.URL.Path)
		w.WriteHeader(http.StatusNotFound)
		return
	}
	switch g.stream {
	case streamHeld:
		w.Header().Set("Content-Type", "text/event-stream")
		w.WriteHeader(http.StatusOK)
		if err := http.NewResponseController(w).Flush(); err != nil {
			g.t.Errorf("the gateway could not open a stream: %v", err)
			return
		}
		select {
		case <-r.Context().Done():
			g.mu.Lock()
			g.closed++
			g.mu.Unlock()
		case <-g.over:
		}
	case streamRefused:
		g.refuse(w, r)
	case streamUnanswered:
		g.never(r)
	}
}

// refuse answers r with a 503, and the gateway's Retry-After when it has one.
func (g *fakeGateway) refuse(w http.ResponseWriter, r *http.Request) {
	if g.retryAfter != nil {
		w.Header().Set("Retry-After", strconv.Itoa(*g.retryAfter))
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusServiceUnavailable)
	if _, err := io.WriteString(w, `{"error":"The gateway is not ready"}`); err != nil {
		g.t.Errorf("the gateway could not refuse %s %s: %v", r.Method, r.URL.Path, err)
	}
}

// never answers r with nothing: it waits until its asker has gone, or the
// case is over.
func (g *fakeGateway) never(r *http.Request) {
	select {
	case <-r.Context().Done():
	case <-g.over:
	}
}

// askedOf is how many requests of path the gateway has been asked.
func (g *fakeGateway) askedOf(path string) int {
	g.mu.Lock()
	defer g.mu.Unlock()
	return g.asked[path]
}

// closedByClient is how many of the streams it held open their client has
// closed.
func (g *fakeGateway) closedByClient() int {
	g.mu.Lock()
	defer g.mu.Unlock()
	return g.closed
}

// transport is a transport to this gateway holding a token, so its stream is
// set going.
func (g *fakeGateway) transport(t *testing.T) *xynolog.HTTPTransport {
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL:  gatewayOrigin,
		Token:    xynolog.NewVariable("a-token"),
		Channels: bus.BridgedChannels,
		HTTP:     g.client,
		Timing:   xynolog.DefaultTransportTiming(),
		Random:   lowest,
	})
	t.Cleanup(transport.Close)
	return transport
}

func refusedStream(t *testing.T, given clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamRefused, given.RetryAfterSeconds, nil)
	gateway.transport(t)
	return clockSubject{counted: func() int { return gateway.askedOf(subscribePath) }}
}

func unansweredStream(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamUnanswered, nil, nil)
	gateway.transport(t)
	return clockSubject{counted: func() int { return gateway.askedOf(subscribePath) }}
}

func degradedStream(t *testing.T, given clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamRefused, given.RetryAfterSeconds, nil)
	transport := gateway.transport(t)
	return clockSubject{counted: tallied(t, transport.State(), func(state api.ConnectionState) bool { return state == api.ConnectionStateDegraded })}
}

func scopeTaken(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamHeld, nil, nil)
	transport := gateway.transport(t)
	resource := resourceOf(t, "res-1")
	return clockSubject{
		counted: func() int { return gateway.askedOf(subscribePath) },
		// The scope is held until the transport closes.
		act: func() error { transport.SubscribeToResource(resource); return nil },
	}
}

func scopeLetGo(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamHeld, nil, nil)
	transport := gateway.transport(t)
	synctest.Wait()
	if state := transport.State().Value(); state != api.ConnectionStateOpen {
		t.Fatalf("the stream is %s, not open", state)
	}
	release := transport.SubscribeToResource(resourceOf(t, "res-1"))
	return clockSubject{
		counted: func() int { return gateway.askedOf(subscribePath) },
		act:     func() error { release(); return nil },
	}
}

func handoffLinger(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamHeld, nil, nil)
	transport := gateway.transport(t)
	resource := resourceOf(t, "res-1")
	return clockSubject{
		counted: gateway.closedByClient,
		act:     func() error { transport.SubscribeToResource(resource); return nil },
	}
}

func unansweredRequest(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamHeld, nil, nil, healthPath)
	transport := gateway.transport(t)
	var failed atomic.Int64
	background(t, func(ctx context.Context) {
		_, _, err := transport.HealthCheck(ctx)
		if ctx.Err() != nil {
			return
		}
		var refused *xynolog.TransportError
		if !errors.As(err, &refused) {
			t.Errorf("the health check ended otherwise: %v", err)
			return
		}
		if status, answered := refused.Status(); answered {
			t.Errorf("the health check was answered %d: %v", status, refused)
			return
		}
		failed.Add(1)
	})
	return clockSubject{counted: func() int { return int(failed.Load()) }}
}

func unansweredEmit(t *testing.T, _ clockGiven) clockSubject {
	gateway := newFakeGateway(t, streamHeld, nil, nil, emitPath)
	transport := gateway.transport(t)
	// Its attempts are cut before the transport closes.
	background(t, func(ctx context.Context) {
		_, _, err := transport.Emit(ctx, bus.BeckonHover.Channel(), map[string]any{"annotationId": "ann-1"}, xynolog.Envelope{})
		if ctx.Err() == nil {
			t.Errorf("the emit ended before the case did: %v", err)
		}
	})
	return clockSubject{counted: func() int { return gateway.askedOf(emitPath) }}
}

// refusedRequest is a bus request of a resource's events, made as the case
// begins, over a gateway that holds its stream open and refuses every emit;
// ended is told how it ended, unless the case was over first.
func refusedRequest(t *testing.T, given clockGiven, ended func(err error)) *fakeGateway {
	gateway := newFakeGateway(t, streamHeld, given.RetryAfterSeconds, []string{emitPath})
	wire := xynolog.NewWire(gateway.transport(t))
	background(t, func(ctx context.Context) {
		_, err := wire.RequestOf(ctx, bus.BrowseEventsRequested.Request().Channel(), map[string]any{"resourceId": "res-1"}, xynolog.DefaultClientTiming().BusRequestTimeout)
		if ctx.Err() == nil {
			ended(err)
		}
	})
	return gateway
}

func refusedBusRequest(t *testing.T, given clockGiven) clockSubject {
	gateway := refusedRequest(t, given, func(err error) {
		// How it fails is what timedOutBusRequest counts.
		if err == nil {
			t.Error("the request was answered")
		}
	})
	return clockSubject{counted: func() int { return gateway.askedOf(emitPath) }}
}

func timedOutBusRequest(t *testing.T, given clockGiven) clockSubject {
	var timedOut atomic.Int64
	refusedRequest(t, given, func(err error) {
		var failed *xynolog.BusRequestError
		if !errors.As(err, &failed) || failed.Code != api.BusRequestErrorCodeTimeout {
			t.Errorf("the request ended otherwise: %v", err)
			return
		}
		timedOut.Add(1)
	})
	return clockSubject{counted: func() int { return int(timedOut.Load()) }}
}

// ── The issuer ──────────────────────────────────────────────────────────

const issuerOrigin = "http://issuer.test/realms/xynolog"

// fakeIssuer is a knowledge base that trusts an issuer, and the issuer, in
// the bubble: what a device grant asks. It mints a code that lives 900
// seconds, with the interval the case states, and answers each ask of its
// token endpoint with the next of answers, the last repeating.
type fakeIssuer struct {
	t        *testing.T
	interval *int
	answers  []string

	mu        sync.Mutex
	tokenAsks int
}

func (i *fakeIssuer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	switch where := "http://" + r.Host + r.URL.Path; where {
	case gatewayOrigin + "/.well-known/oauth-protected-resource":
		answerJSON(i.t, w, http.StatusOK, map[string]any{"resource": gatewayOrigin, "authorization_servers": []string{issuerOrigin}, "bearer_methods_supported": []string{"header"}})
	case issuerOrigin + "/.well-known/openid-configuration":
		answerJSON(i.t, w, http.StatusOK, map[string]any{
			"issuer":                        issuerOrigin,
			"authorization_endpoint":        issuerOrigin + "/auth",
			"token_endpoint":                issuerOrigin + "/token",
			"device_authorization_endpoint": issuerOrigin + "/device",
		})
	case issuerOrigin + "/device":
		minted := map[string]any{"device_code": "the-device-code", "user_code": "WDJB-MJHT", "verification_uri": "http://issuer.test/device", "expires_in": 900}
		if i.interval != nil {
			minted["interval"] = *i.interval
		}
		answerJSON(i.t, w, http.StatusOK, minted)
	case issuerOrigin + "/token":
		i.mu.Lock()
		said := i.answers[min(i.tokenAsks, len(i.answers)-1)]
		i.tokenAsks++
		i.mu.Unlock()
		answerJSON(i.t, w, http.StatusBadRequest, map[string]any{"error": said})
	default:
		i.t.Errorf("the issuer was asked %s %s, which a device grant does not ask", r.Method, where)
		w.WriteHeader(http.StatusNotFound)
	}
}

// answerJSON answers with status and document, in JSON.
func answerJSON(t *testing.T, w http.ResponseWriter, status int, document map[string]any) {
	encoded, err := json.Marshal(document)
	if err != nil {
		t.Errorf("the answer does not encode: %v", err)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if _, err := w.Write(encoded); err != nil {
		t.Errorf("the answer could not be written: %v", err)
	}
}

func (i *fakeIssuer) asked() int {
	i.mu.Lock()
	defer i.mu.Unlock()
	return i.tokenAsks
}

func deviceGrant(t *testing.T, given clockGiven) clockSubject {
	if len(given.Answers) == 0 {
		t.Fatal("a device grant's case states what its token endpoint answers")
	}
	issuer := &fakeIssuer{t: t, interval: given.IntervalSeconds, answers: given.Answers}
	client := httptest.NewTestServer(t, issuer).Client()
	background(t, func(ctx context.Context) {
		_, err := xynolog.SignInWithDevice(ctx, xynolog.Issuer{HTTP: client, Timing: xynolog.DefaultTransportTiming(), Random: lowest}, gatewayOrigin, &xynolog.MemorySignIn{}, func(api.DeviceCode) {})
		if ctx.Err() == nil {
			t.Errorf("the sign-in ended before the case did: %v", err)
		}
	})
	return clockSubject{counted: issuer.asked}
}

// ── An agent's sign-in ──────────────────────────────────────────────────

// agentServers is an agent's issuer and gateway in the bubble. The issuer
// answers the grant with a token that lives an hour, or with grantStatus when
// there is one; the gateway answers the naming request with namingStatus. It
// counts the grants and the naming requests it is asked.
type agentServers struct {
	t            *testing.T
	grantStatus  *int
	namingStatus *int

	mu    sync.Mutex
	asked int
}

func (a *agentServers) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	switch where := "http://" + r.Host + r.URL.Path; where {
	case issuerOrigin + "/.well-known/openid-configuration":
		answerJSON(a.t, w, http.StatusOK, map[string]any{"issuer": issuerOrigin, "token_endpoint": issuerOrigin + "/token"})
	case issuerOrigin + "/token":
		n := a.ask()
		if a.grantStatus != nil {
			answerJSON(a.t, w, *a.grantStatus, map[string]any{"error": "temporarily_unavailable"})
			return
		}
		answerJSON(a.t, w, http.StatusOK, map[string]any{"access_token": tokenFor(time.Hour, n), "token_type": "Bearer", "expires_in": 3600})
	case gatewayOrigin + xynolog.RouteGetCurrentUser.Path:
		a.ask()
		if a.namingStatus == nil {
			a.t.Errorf("the gateway was asked after a refused grant")
			w.WriteHeader(http.StatusNotFound)
			return
		}
		answerJSON(a.t, w, *a.namingStatus, map[string]any{})
	default:
		a.t.Errorf("%s %s was asked, which an agent's sign-in does not ask", r.Method, where)
		w.WriteHeader(http.StatusNotFound)
	}
}

// ask counts one request, and is how many there have been.
func (a *agentServers) ask() int {
	a.mu.Lock()
	defer a.mu.Unlock()
	a.asked++
	return a.asked
}

func (a *agentServers) requests() int {
	a.mu.Lock()
	defer a.mu.Unlock()
	return a.asked
}

// agentSignIn is an agent's sign-in at servers, set going as the case begins.
// Over a gateway that is unreachable, every connection to it fails as it is
// made, and each is counted with what servers count.
func agentSignIn(t *testing.T, servers *agentServers, unreachable bool) clockSubject {
	client := httptest.NewTestServer(t, servers).Client()
	var tried atomic.Int64
	gateway := client
	if unreachable {
		gateway = &http.Client{Transport: &http.Transport{DialContext: func(context.Context, string, string) (net.Conn, error) {
			tried.Add(1)
			return nil, errors.New("the gateway cannot be reached")
		}}}
	}
	service := xynolog.NewServiceToken(
		xynolog.SecretCredential{Issuer: issuerOrigin, ClientID: "smelter", ClientSecret: "a-client-secret"},
		xynolog.Issuer{HTTP: client, Timing: xynolog.DefaultTransportTiming(), Random: lowest},
	)
	background(t, func(ctx context.Context) {
		agent, err := xynolog.SignInAgent(ctx, xynolog.AgentConfig{Gateway: gatewayOrigin, Service: service, HTTP: gateway, Timing: xynolog.DefaultTransportTiming(), Random: lowest})
		if err == nil {
			agent.Close()
			t.Error("the agent signed in")
		}
	})
	return clockSubject{counted: func() int { return servers.requests() + int(tried.Load()) }}
}

func refusedAgentSignIn(t *testing.T, given clockGiven) clockSubject {
	if given.Status == nil {
		t.Fatal("a refused sign-in's case states the gateway's status")
	}
	return agentSignIn(t, &agentServers{t: t, namingStatus: given.Status}, false)
}

func unreachableAgentSignIn(t *testing.T, _ clockGiven) clockSubject {
	return agentSignIn(t, &agentServers{t: t}, true)
}

func refusedAgentGrant(t *testing.T, given clockGiven) clockSubject {
	if given.Status == nil {
		t.Fatal("a refused grant's case states the issuer's status")
	}
	return agentSignIn(t, &agentServers{t: t, grantStatus: given.Status}, false)
}

// ── A session ───────────────────────────────────────────────────────────

func renewalSubject(t *testing.T, given clockGiven) clockSubject {
	if given.LifetimeSeconds == nil {
		t.Fatal("a renewal's case states how long its tokens live")
	}
	lifetime := time.Duration(*given.LifetimeSeconds) * time.Second
	var renewals atomic.Int64
	kept := &xynolog.MemorySignIn{}
	if err := kept.Keep(context.Background(), api.StoredSession{Access: tokenFor(lifetime, 0), Refresh: "a-refresh-token", ClientId: "xynolog-cli", TokenEndpoint: issuerOrigin + "/token"}); err != nil {
		t.Fatal(err)
	}
	client := xynologtest.NewTestClient(xynologtest.TestClientConfig{Timing: xynolog.DefaultClientTiming()})
	session, err := xynolog.StartSession(context.Background(), xynolog.SessionConfig{
		Kb:     api.KbTarget{Id: kb},
		Client: client.Client,
		Token:  xynolog.NewVariable(""),
		Kept:   kept,
		Refresh: func(context.Context, string) (string, error) {
			return tokenFor(lifetime, int(renewals.Add(1))), nil
		},
		Validate: func(context.Context, string) (api.UserResponse, error) { return alice(), nil },
		Timing:   xynolog.DefaultTransportTiming(),
		Random:   lowest,
	})
	if err != nil {
		client.Client.Close()
		client.Transport.Close()
		t.Fatal(err)
	}
	t.Cleanup(func() {
		client.Client.Close()
		session.Close()
		client.Transport.Close()
	})
	return clockSubject{counted: func() int { return int(renewals.Load()) }}
}

// ── A worker's claims ───────────────────────────────────────────────────

// claimedJob is the job a dispatcher with one job answers job:claim with.
const claimedJob = `{"status":"running","metadata":{"id":"job-1","type":"mark","userId":"did:web:example.org:users:alice",` +
	`"created":"2026-10-01T00:00:00.000Z","retryCount":0,"maxRetries":1},"params":{"resourceId":"res-1"},` +
	`"startedAt":"2026-10-01T00:00:01.000Z","progress":{}}`

func heldJobStall(t *testing.T, _ clockGiven) clockSubject {
	transport := xynologtest.NewFaultyTransport(xynologtest.FaultyConfig{Channels: xynolog.JobClaimChannels, MakeResponse: func(operation bus.Channel, payload json.RawMessage) (json.RawMessage, error) {
		if operation == bus.JobClaim.Request().Channel() {
			return json.RawMessage(claimedJob), nil
		}
		return xynologtest.RefuseUnscriptedOperation(operation, payload)
	}})
	client, _ := worldOver(t, transport, xynolog.DefaultClientTiming())
	var marks []api.JobFilter
	if err := json.Unmarshal([]byte(`[{"jobType":"mark","params":{"motivation":"highlighting"}}]`), &marks); err != nil {
		t.Fatal(err)
	}
	claims := client.Job.Claim(api.ClaimOptions{Accepts: marks})
	held := make(chan xynolog.HeldJob, 1)
	ranged := make(chan struct{})
	t.Cleanup(func() { <-ranged })
	var stalls atomic.Int64
	heard := make(chan struct{})
	t.Cleanup(func() { <-heard })
	t.Cleanup(claims.Close)
	go func() {
		defer close(heard)
		for range claims.Stalled() {
			stalls.Add(1)
		}
	}()
	go func() {
		defer close(ranged)
		for job, err := range claims.All() {
			if err != nil {
				t.Errorf("a claim was refused: %v", err)
				continue
			}
			select {
			case held <- job:
			default:
				t.Errorf("a second job was handed out: %s", job.JobId())
			}
		}
	}()
	synctest.Wait()
	var job xynolog.HeldJob
	select {
	case job = <-held:
	default:
		t.Fatal("no job was claimed at the case's start")
	}
	return clockSubject{
		counted: func() int { return int(stalls.Load()) },
		act:     func() error { return job.Progress(context.Background(), api.JobProgress{Percentage: 50}) },
	}
}

// ── Discovery ───────────────────────────────────────────────────────────

// launcherDocument is a launcher's document: one managed knowledge base at
// the first read, and unchanged at every read after it.
type launcherDocument struct {
	reads        atomic.Int64
	first, after api.DiscoveryRead
}

func (d *launcherDocument) Read(context.Context) api.DiscoveryRead {
	if d.reads.Add(1) == 1 {
		return d.first
	}
	return d.after
}

func discoverySubject(t *testing.T, _ clockGiven) clockSubject {
	document := &launcherDocument{}
	if err := document.first.From(api.DiscoveryManaged{Kbs: []api.DiscoveredKB{{
		Host: "localhost", Port: 4000, Placement: api.KbPlacementLocal, ManagedBy: "xynolog-launcher", Did: "did:web:example.org:kb-a",
	}}}); err != nil {
		t.Fatal(err)
	}
	if err := document.after.From(api.DiscoveryUnchanged{}); err != nil {
		t.Fatal(err)
	}
	background(t, func(ctx context.Context) {
		for range discovery.SubscribeDiscovery(ctx, document, discovery.DiscoveryInterval) {
		}
	})
	return clockSubject{counted: func() int { return int(document.reads.Load()) }}
}

// ── A client's queries and caches ───────────────────────────────────────

func invalidationWindow(t *testing.T, _ clockGiven) clockSubject {
	transport := xynologtest.NewFaultyTransport(xynologtest.FaultyConfig{Channels: bus.BridgedChannels, MakeResponse: knowing()})
	client, _ := worldOver(t, transport, xynolog.DefaultClientTiming())
	observed := client.Browse.Events(resourceOf(t, "res-1"))
	background(t, func(ctx context.Context) {
		for range observed.States(ctx) {
		}
	})
	added := eventOf(t, xynolog.CacheRefreshMarkAdded, "", "res-1", "ann-1")
	requested := bus.BrowseEventsRequested.Request().Channel()
	return clockSubject{
		counted: func() int { return len(requestsOn(transport, requested)) },
		act:     func() error { transport.Deliver(added); return nil },
	}
}

// recordedSaves is a cache's storage: it keeps nothing to begin with, and
// records each save.
type recordedSaves struct{ saves atomic.Int64 }

func (*recordedSaves) Load() map[string]int { return nil }

func (r *recordedSaves) Save(map[string]int) error {
	r.saves.Add(1)
	return nil
}

func saveDebounce(t *testing.T, _ clockGiven) clockSubject {
	storage := &recordedSaves{}
	cache := xynolog.NewCache(
		func(_ context.Context, key string) (int, error) {
			return 0, fmt.Errorf("a cache that is only written fetched %s", key)
		},
		func(func(context.Context)) { t.Error("a cache that is only written fetched") },
		xynolog.CachePersister[string, int](storage),
	)
	t.Cleanup(cache.Close)
	changes := 0
	return clockSubject{
		counted: func() int { return int(storage.saves.Load()) },
		act: func() error {
			changes++
			cache.Set("a key", changes)
			return nil
		},
	}
}

func jobFollower(t *testing.T, _ clockGiven) clockSubject {
	running := statusOf(t, "running", nil)
	transport := xynologtest.NewFaultyTransport(xynologtest.FaultyConfig{Channels: bus.BridgedChannels, MakeResponse: func(operation bus.Channel, payload json.RawMessage) (json.RawMessage, error) {
		switch operation {
		case jobCreate:
			return json.RawMessage(`{"jobId":"job-1"}`), nil
		case jobStatus:
			return running, nil
		}
		return xynologtest.RefuseUnscriptedOperation(operation, payload)
	}})
	client, _ := worldOver(t, transport, xynolog.DefaultClientTiming())
	delegation := highlighting(t, client)
	background(t, func(ctx context.Context) {
		_, err := delegation.Wait(ctx)
		if ctx.Err() == nil {
			t.Errorf("the follower ended before the case did: %v", err)
		}
	})
	progressed := frameOf(t, jobProgress, map[string]any{
		"resourceId": "res-1", "jobId": "job-1", "jobType": "mark", "percentage": 10, "progress": map[string]any{"percentage": 10},
	}, xynolog.Envelope{})
	return clockSubject{
		counted: func() int { return len(requestsOn(transport, jobStatus)) },
		act:     func() error { transport.Deliver(progressed); return nil },
	}
}

// polledJob is a client's job.pollUntilComplete of job-1, naming no interval
// and no limit of its own, over a transport that answers every
// job:status-requested with that job running; ended is told how the poll
// ended, unless the case was over first.
func polledJob(t *testing.T, ended func(err error)) *xynologtest.FaultyTransport {
	running := statusOf(t, "running", nil)
	transport := xynologtest.NewFaultyTransport(xynologtest.FaultyConfig{Channels: bus.BridgedChannels, MakeResponse: func(operation bus.Channel, payload json.RawMessage) (json.RawMessage, error) {
		if operation == jobStatus {
			return running, nil
		}
		return xynologtest.RefuseUnscriptedOperation(operation, payload)
	}})
	client, _ := worldOver(t, transport, xynolog.DefaultClientTiming())
	job, err := api.ParseJobId("job-1")
	if err != nil {
		t.Fatal(err)
	}
	background(t, func(ctx context.Context) {
		_, err := client.Job.PollUntilComplete(ctx, job, api.JobPollOptions{}, nil)
		if ctx.Err() == nil {
			ended(err)
		}
	})
	return transport
}

func jobPoll(t *testing.T, _ clockGiven) clockSubject {
	transport := polledJob(t, func(err error) {
		// How it fails is what jobPollTimeout counts.
		if err == nil {
			t.Error("the poll ended with the job running")
		}
	})
	return clockSubject{counted: func() int { return len(requestsOn(transport, jobStatus)) }}
}

func jobPollTimeout(t *testing.T, _ clockGiven) clockSubject {
	var timedOut atomic.Int64
	polledJob(t, func(err error) {
		var failed *xynolog.BusRequestError
		if !errors.As(err, &failed) || failed.Code != api.BusRequestErrorCodeTimeout {
			t.Errorf("the poll ended otherwise: %v", err)
			return
		}
		timedOut.Add(1)
	})
	return clockSubject{counted: func() int { return int(timedOut.Load()) }}
}

// clockSubjects is how this SDK builds each subject the table names, with
// what is to be closed once the case is over left to t's cleanup.
var clockSubjects = map[string]func(t *testing.T, given clockGiven) clockSubject{
	"refusedStream":          refusedStream,
	"unansweredStream":       unansweredStream,
	"degradedStream":         degradedStream,
	"scopeTaken":             scopeTaken,
	"scopeLetGo":             scopeLetGo,
	"handoffLinger":          handoffLinger,
	"renewal":                renewalSubject,
	"deviceGrant":            deviceGrant,
	"heldJobStall":           heldJobStall,
	"discovery":              discoverySubject,
	"invalidationWindow":     invalidationWindow,
	"saveDebounce":           saveDebounce,
	"jobFollower":            jobFollower,
	"unansweredRequest":      unansweredRequest,
	"unansweredEmit":         unansweredEmit,
	"refusedBusRequest":      refusedBusRequest,
	"timedOutBusRequest":     timedOutBusRequest,
	"jobPoll":                jobPoll,
	"jobPollTimeout":         jobPollTimeout,
	"refusedAgentSignIn":     refusedAgentSignIn,
	"unreachableAgentSignIn": unreachableAgentSignIn,
	"refusedAgentGrant":      refusedAgentGrant,
}

// ── A case, played ──────────────────────────────────────────────────────

// performClockStep performs step on subject, at moving the case's clock on by
// what it passes, a timing it names being one of timings.
func performClockStep(step json.RawMessage, subject clockSubject, timings map[string]json.RawMessage, at *time.Duration) error {
	var word string
	if json.Unmarshal(step, &word) == nil {
		switch word {
		case "settle":
			synctest.Wait()
			return nil
		case "act":
			if subject.act == nil {
				return errors.New("the subject has no action")
			}
			acted := make(chan error, 1)
			go func() { acted <- subject.act() }()
			synctest.Wait()
			select {
			case err := <-acted:
				if err != nil {
					return fmt.Errorf("the action failed: %w", err)
				}
				return nil
			default:
				return errors.New("the action did not end without the clock moving")
			}
		}
		return errors.New("no step this runner performs")
	}
	var stated struct {
		Pass    json.RawMessage `json:"pass"`
		Counted *int            `json:"counted"`
	}
	decoder := json.NewDecoder(bytes.NewReader(step))
	decoder.DisallowUnknownFields()
	if err := decoder.Decode(&stated); err != nil {
		return fmt.Errorf("no step this runner performs: %w", err)
	}
	switch {
	case stated.Pass != nil && stated.Counted == nil:
		wait, err := clockDuration(timings, stated.Pass)
		if err != nil {
			return err
		}
		if wait < 0 {
			return errors.New("a case passes no time backwards")
		}
		synctest.Wait()
		time.Sleep(wait)
		synctest.Wait()
		*at += wait
		return nil
	case stated.Counted != nil && stated.Pass == nil:
		synctest.Wait()
		if counted := subject.counted(); counted != *stated.Counted {
			return fmt.Errorf("counted %d, not %d", counted, *stated.Counted)
		}
		return nil
	}
	return errors.New("no step this runner performs")
}

// playClockCase builds the case's subject in the bubble t runs in, and
// performs its steps in order: the first that fails is the case's failure.
func playClockCase(t *testing.T, played clockCase) error {
	build, ok := clockSubjects[played.Subject]
	if !ok {
		return fmt.Errorf("%s is no subject this runner builds", played.Subject)
	}
	timings := timingValues(t)
	subject := build(t, played.Given)
	var at time.Duration
	for n, step := range played.Steps {
		if err := performClockStep(step, subject, timings, &at); err != nil {
			var compact bytes.Buffer
			if compacted := json.Compact(&compact, step); compacted != nil {
				return fmt.Errorf("steps[%d] is not JSON: %w", n, compacted)
			}
			return fmt.Errorf("steps[%d] %s, at %d ms: %w", n, compact.String(), at.Milliseconds(), err)
		}
	}
	return nil
}

// ── The tests ───────────────────────────────────────────────────────────

func TestThisRunnerBuildsEverySubjectTheClockTableNamesAndNoOther(t *testing.T) {
	named := map[string]bool{}
	for _, stated := range readClockCases(t) {
		named[stated.Subject] = true
	}
	if built := slices.Sorted(maps.Keys(clockSubjects)); !slices.Equal(built, slices.Sorted(maps.Keys(named))) {
		t.Fatalf("this runner builds %v; the table names %v", built, slices.Sorted(maps.Keys(named)))
	}
}

func TestAWaitEndsWhenItsClockCaseSays(t *testing.T) {
	for _, stated := range readClockCases(t) {
		t.Run(stated.Subject+": "+stated.Case, func(t *testing.T) {
			synctest.Test(t, func(t *testing.T) {
				if err := playClockCase(t, stated); err != nil {
					t.Fatal(err)
				}
			})
		})
	}
}

func TestTheClockRunnerFailsACaseWhoseWaitEndsAMillisecondEarly(t *testing.T) {
	cases := readClockCases(t)
	first := slices.IndexFunc(cases, func(stated clockCase) bool { return stated.Subject == "refusedStream" })
	if first < 0 {
		t.Fatal("the table has no refusedStream case")
	}
	told := cases[first]
	told.Steps = slices.Clone(told.Steps)
	// The last millisecond of the first wait: the case is told the stream was
	// opened again in it.
	var compact bytes.Buffer
	if err := json.Compact(&compact, told.Steps[2]); err != nil || compact.String() != `{"counted":1}` {
		t.Fatalf("steps[2] of the first refusedStream case is %s, not the count before its first wait ends", told.Steps[2])
	}
	told.Steps[2] = json.RawMessage(`{"counted":2}`)
	synctest.Test(t, func(t *testing.T) {
		if err := playClockCase(t, told); err == nil || !strings.HasPrefix(err.Error(), "steps[2] ") {
			t.Fatalf("a case told the stream opened again a millisecond early played as %v", err)
		}
	})
}

package xynolog

// An agent's token: its account's token from its issuer, its bearer at the
// gateway, which names it; kept until it is due and renewed when refused.

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/xynolog/sdk/go/api"
)

type agentWorld struct {
	issuer, gateway *httptest.Server

	mu     sync.Mutex
	grants int
	asked  []string      // each request the gateway was asked: its path and the Authorization it came with
	refuse bool          // the issuer refuses every grant
	takes  time.Duration // how long the issuer takes to answer a grant
}

// agentDID is the DID the gateway names the worker's account by.
const agentDID = "did:web:kb.example:agents:service-account-xynolog-worker"

func newAgentWorld(t *testing.T) *agentWorld {
	t.Helper()
	w := &agentWorld{}
	w.issuer = httptest.NewServer(http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		switch r.URL.Path {
		case "/realms/xynolog/.well-known/openid-configuration":
			writeJSON(rw, http.StatusOK, map[string]any{"token_endpoint": w.issuer.URL + "/realms/xynolog/token"})
		case "/realms/xynolog/token":
			w.mu.Lock()
			refuse, takes := w.refuse, w.takes
			w.mu.Unlock()
			time.Sleep(takes)
			if refuse || r.FormValue("grant_type") != "client_credentials" || r.FormValue("client_id") != "xynolog-worker" || r.FormValue("client_secret") != "s3cret" {
				writeJSON(rw, http.StatusUnauthorized, map[string]any{"error": "invalid_client", "error_description": "s3cret is wrong"})
				return
			}
			w.mu.Lock()
			w.grants++
			n := w.grants
			w.mu.Unlock()
			writeJSON(rw, http.StatusOK, map[string]any{"access_token": signedToken(100 + n), "expires_in": 3600})
		default:
			http.NotFound(rw, r)
		}
	}))
	t.Cleanup(w.issuer.Close)
	w.gateway = httptest.NewServer(http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
		w.mu.Lock()
		w.asked = append(w.asked, r.Method+" "+r.URL.Path+" "+r.Header.Get("Authorization"))
		w.mu.Unlock()
		if r.Method != http.MethodGet || r.URL.Path != "/api/users/me" {
			http.NotFound(rw, r)
			return
		}
		writeJSON(rw, http.StatusOK, map[string]any{"did": agentDID, "email": nil, "name": nil, "image": nil, "domain": "kb.example"})
	}))
	t.Cleanup(w.gateway.Close)
	return w
}

func (w *agentWorld) signIn(t *testing.T, secret string) (*AgentToken, error) {
	t.Helper()
	issuer := Issuer{HTTP: &http.Client{}, Timing: quickTiming()}
	service := NewServiceToken(SecretCredential{Issuer: w.issuer.URL + "/realms/xynolog", ClientID: "xynolog-worker", ClientSecret: secret}, issuer)
	return SignInAgent(context.Background(), AgentConfig{Gateway: w.gateway.URL, Service: service, HTTP: &http.Client{}, Timing: quickTiming()})
}

// An agent signs in as its account: the issuer's token is its bearer, and the
// gateway names it by that account. Nothing is exchanged.
func TestAnAgentIsSignedInAsItsAccount(t *testing.T) {
	w := newAgentWorld(t)
	agent, err := w.signIn(t, "s3cret")
	if err != nil {
		t.Fatal(err)
	}
	defer agent.Close()
	if agent.Token().Value() != signedToken(101) || agent.DID().String() != agentDID {
		t.Errorf("signed in as %q with a token that is not the issuer's", agent.DID())
	}
	w.mu.Lock()
	defer w.mu.Unlock()
	if want := "GET /api/users/me Bearer " + signedToken(101); len(w.asked) != 1 || w.asked[0] != want {
		t.Errorf("the gateway was asked %v, want only %q", w.asked, want)
	}
}

// A refusal is answered by a new grant from the issuer; one the issuer refuses
// leaves the agent the token it had.
func TestARefusedAgentTokenIsGrantedAgain(t *testing.T) {
	w := newAgentWorld(t)
	agent, err := w.signIn(t, "s3cret")
	if err != nil {
		t.Fatal(err)
	}
	defer agent.Close()
	token, ok := agent.Refresh(context.Background(), signedToken(101))
	if !ok || token != signedToken(102) || agent.Token().Value() != token {
		t.Errorf("refreshed to the issuer's second token: %v, %v", token == signedToken(102), ok)
	}
	w.mu.Lock()
	w.refuse = true
	w.mu.Unlock()
	if _, ok := agent.Refresh(context.Background(), signedToken(102)); ok {
		t.Error("a refused grant gave a token")
	}
	if agent.Token().Value() != signedToken(102) {
		t.Error("a refused grant took away the token the agent had")
	}
}

// A refusal of a token the agent has renewed since is answered by the token
// it holds: nothing is asked again.
func TestARefusalOfATokenRenewedSinceIsAnsweredByTheNewOne(t *testing.T) {
	w := newAgentWorld(t)
	agent, err := w.signIn(t, "s3cret")
	if err != nil {
		t.Fatal(err)
	}
	defer agent.Close()
	if _, ok := agent.Refresh(context.Background(), signedToken(101)); !ok {
		t.Fatal("the first refusal was not answered")
	}
	token, ok := agent.Refresh(context.Background(), signedToken(101))
	if !ok || token != signedToken(102) {
		t.Errorf("a refusal of the token renewed since was not answered with the token held (given one: %v)", ok)
	}
	w.mu.Lock()
	defer w.mu.Unlock()
	if w.grants != 2 {
		t.Errorf("a sign-in and two refusals of one token made %d grants, want 2", w.grants)
	}
}

// Refusals of the agent's token that arrive together are answered together:
// however many requests were refused it at once, they cost one grant, and
// each is given the token that grant brought.
func TestRefusalsOfAnAgentsTokenThatArriveTogetherCostOneGrant(t *testing.T) {
	w := newAgentWorld(t)
	agent, err := w.signIn(t, "s3cret")
	if err != nil {
		t.Fatal(err)
	}
	defer agent.Close()
	// An issuer that takes a moment, as one does: the refusals overlap.
	w.mu.Lock()
	w.takes = 200 * time.Millisecond
	w.mu.Unlock()
	var together sync.WaitGroup
	given := make([]string, 4)
	for i := range given {
		together.Add(1)
		go func() {
			defer together.Done()
			given[i], _ = agent.Refresh(context.Background(), signedToken(101))
		}()
	}
	together.Wait()
	for i, token := range given {
		if token != signedToken(102) || agent.Token().Value() != token {
			t.Errorf("refusal %d was not given the token the one grant brought", i+1)
		}
	}
	w.mu.Lock()
	defer w.mu.Unlock()
	if w.grants != 2 {
		t.Errorf("a sign-in and four refusals of one token together made %d grants, want 2", w.grants)
	}
}

// grantHeld is an issuer's transport that answers its discovery and each grant
// itself, the token granted named by the grant's count, and holds the second
// grant until released. The answer it holds comes whatever became of the
// request meanwhile, as an answer already on its way does.
type grantHeld struct {
	arrived, release chan struct{}

	mu     sync.Mutex
	grants int
}

func (g *grantHeld) RoundTrip(request *http.Request) (*http.Response, error) {
	answer := `{"token_endpoint":"http://issuer.test/realms/xynolog/token"}`
	if request.URL.Path == "/realms/xynolog/token" {
		g.mu.Lock()
		g.grants++
		n := g.grants
		g.mu.Unlock()
		if n == 2 {
			close(g.arrived)
			<-g.release
		}
		answer = fmt.Sprintf(`{"access_token":%q,"expires_in":3600}`, signedToken(100+n))
	}
	return &http.Response{StatusCode: http.StatusOK, Header: http.Header{"Content-Type": {"application/json"}}, Body: io.NopCloser(strings.NewReader(answer))}, nil
}

// The agent closes while a refusal's grant is under way, and the grant is
// answered after: the close ended the renewal, so the refusal is given no
// token and the answer is not taken. A refusal once the agent is closed is
// given none, whatever token it names, and the issuer is not asked.
func TestAnAgentThatClosesWhileItsTokenIsRenewedGivesTheRefusalNoTokenAndRenewsNothingAfter(t *testing.T) {
	w := newAgentWorld(t)
	issuer := &grantHeld{arrived: make(chan struct{}), release: make(chan struct{})}
	service := NewServiceToken(SecretCredential{Issuer: "http://issuer.test/realms/xynolog", ClientID: "xynolog-worker", ClientSecret: "s3cret"}, Issuer{HTTP: &http.Client{Transport: issuer}, Timing: quickTiming()})
	agent, err := SignInAgent(context.Background(), AgentConfig{Gateway: w.gateway.URL, Service: service, HTTP: &http.Client{}, Timing: quickTiming()})
	if err != nil {
		t.Fatal(err)
	}
	first := agent.Token().Value()
	given := make(chan bool, 1)
	go func() {
		token, ok := agent.Refresh(context.Background(), first)
		given <- ok || token != ""
	}()
	<-issuer.arrived
	agent.Close()
	close(issuer.release)
	select {
	case tokenGiven := <-given:
		if tokenGiven {
			t.Error("the refusal waiting on the renewal the close ended was given a token")
		}
	case <-time.After(time.Second):
		t.Fatal("the refusal waiting on the renewal the close ended was not answered")
	}
	if agent.Token().Value() != first {
		t.Error("the agent took the token a grant brought once it was closed")
	}
	// The token it holds, and one it does not.
	for _, refused := range []string{first, signedToken(100)} {
		if token, ok := agent.Refresh(context.Background(), refused); ok || token != "" {
			t.Error("a refusal once the agent is closed was given a token")
		}
	}
	issuer.mu.Lock()
	defer issuer.mu.Unlock()
	if issuer.grants != 2 {
		t.Errorf("the issuer was asked for %d grants, want 2: the sign-in's and the one the close ended", issuer.grants)
	}
}

// A gateway that does not name the agent fails the sign-in.
func TestAnAgentTheGatewayDoesNotNameIsNotSignedIn(t *testing.T) {
	w := newAgentWorld(t)
	w.gateway.Close()
	_, err := w.signIn(t, "s3cret")
	var failed *TransportError
	if !errors.As(err, &failed) {
		t.Errorf("signed in, or failed as %v, with no gateway to name it", err)
	}
}

// A service account the issuer refuses fails as a sign-in, and the failure
// says nothing of the secret.
func TestARefusedServiceAccountNamesNoSecret(t *testing.T) {
	w := newAgentWorld(t)
	_, err := w.signIn(t, "wrong")
	if err == nil {
		t.Fatal("signed in with the wrong secret")
	}
	var failed *SignInError
	if !errors.As(err, &failed) || failed.Code != api.SignInErrorCodeExchange {
		t.Errorf("failed as %v", err)
	}
	if strings.Contains(err.Error(), "s3cret") || strings.Contains(err.Error(), "wrong") {
		t.Errorf("the failure says the secret: %v", err)
	}
	credential := SecretCredential{Issuer: "https://issuer.example", ClientID: "xynolog-worker", ClientSecret: "s3cret"}
	for _, shown := range []string{fmt.Sprint(credential), fmt.Sprintf("%+v", credential), fmt.Sprintf("%#v", credential)} {
		if strings.Contains(shown, "s3cret") {
			t.Errorf("a credential printed its secret: %s", shown)
		}
	}
}

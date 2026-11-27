//go:build go1.27

package xynolog

// An agent's token renewed while a due renewal waits to try again, on a
// network faked in a testing/synctest bubble by httptest.NewTestServer, which
// is new in Go 1.27: so this file is built by 1.27 and later only, while the
// module admits 1.26.

import (
	"context"
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"
	"testing/synctest"
	"time"

	"github.com/xynolog/sdk/go/internal/timing"
)

// The agent's token falls due, and its renewal gets no answer; while it waits
// to try again, a refusal renews the token. The renewal tried again renews
// nothing: the token whose wait ran out is no longer the one held, and the
// token the refusal brought has a wait of its own. On the test's own clock.
func TestADueRenewalTriedAgainRenewsNothingOnceTheAgentsTokenIsRenewedSomeOtherWay(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		var mu sync.Mutex
		asks := 0
		// The issuer grants the sign-in, is down when the token falls due, and
		// grants every ask after that.
		client := httptest.NewTestServer(t, http.HandlerFunc(func(rw http.ResponseWriter, r *http.Request) {
			switch r.URL.Path {
			case "/realms/xynolog/.well-known/openid-configuration":
				writeJSON(rw, http.StatusOK, map[string]any{"token_endpoint": "http://issuer.test/realms/xynolog/token"})
			case "/realms/xynolog/token":
				mu.Lock()
				asks++
				n := asks
				mu.Unlock()
				if n == 2 {
					rw.WriteHeader(http.StatusServiceUnavailable)
					return
				}
				now := time.Now()
				writeJSON(rw, http.StatusOK, map[string]any{"access_token": aToken(t, map[string]any{"iat": now.Unix(), "exp": now.Add(time.Hour).Unix(), "n": n}), "expires_in": 3600})
			case "/api/users/me":
				writeJSON(rw, http.StatusOK, map[string]any{"did": agentDID, "email": nil, "name": nil, "image": nil, "domain": "kb.example"})
			default:
				http.NotFound(rw, r)
			}
		})).Client()
		service := NewServiceToken(SecretCredential{Issuer: "http://issuer.test/realms/xynolog", ClientID: "xynolog-worker", ClientSecret: "s3cret"}, Issuer{HTTP: client, Timing: quickTiming()})
		agent, err := SignInAgent(context.Background(), AgentConfig{Gateway: "http://gateway.test", Service: service, HTTP: client, Timing: quickTiming()})
		if err != nil {
			t.Fatal(err)
		}
		defer agent.Close()
		signedIn := agent.Token().Value()
		wait, scheduled := RefreshDelay(signedIn, time.Now())
		if !scheduled {
			t.Fatal("the agent's token schedules no renewal")
		}
		// The due renewal waits at least half the budget's first delay to try
		// again: a quarter of it past due, it has asked once and not again.
		time.Sleep(wait + time.Duration(timing.RefreshRetry.InitialDelayMs)*time.Millisecond/4)
		synctest.Wait()
		mu.Lock()
		due := asks
		mu.Unlock()
		if due != 2 {
			t.Fatalf("the issuer was asked %d times by the refusal's time, want 2: the sign-in and the due renewal", due)
		}
		renewed, ok := agent.Refresh(context.Background(), signedIn)
		if !ok || renewed == signedIn {
			t.Fatal("the refusal was not answered by a new grant")
		}
		// Past every try the due renewal has left.
		time.Sleep(10 * time.Minute)
		synctest.Wait()
		mu.Lock()
		defer mu.Unlock()
		if asks != 3 || agent.Token().Value() != renewed {
			t.Errorf("the issuer was asked %d times, want 3: the sign-in, the due renewal and the refusal's; the agent holds the refusal's token: %v", asks, agent.Token().Value() == renewed)
		}
	})
}

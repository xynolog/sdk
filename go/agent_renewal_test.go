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

	"github.com/xynolog/sdk/go/api"
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
		timing := quickTiming()
		// The renewal waits a minute or more to try again: the refusal is
		// answered before it does.
		timing.RefreshRetry = api.RetryBudget{Attempts: 3, InitialDelayMs: 60_000, MaxDelayMs: 60_000}
		service := NewServiceToken(SecretCredential{Issuer: "http://issuer.test/realms/xynolog", ClientID: "xynolog-worker", ClientSecret: "s3cret"}, Issuer{HTTP: client, Timing: timing})
		agent, err := SignInAgent(context.Background(), AgentConfig{Gateway: "http://gateway.test", Service: service, HTTP: client, Timing: timing})
		if err != nil {
			t.Fatal(err)
		}
		defer agent.Close()
		signedIn := agent.Token().Value()
		wait, scheduled := RefreshDelay(signedIn, time.Now(), timing)
		if !scheduled {
			t.Fatal("the agent's token schedules no renewal")
		}
		time.Sleep(wait + time.Second)
		synctest.Wait()
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

package readme

import (
	"context"
	"fmt"
	"net/http"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// Work signs the agent in, and opens a stream as it.
func Work(ctx context.Context, gateway, issuer, secret string) error {
	timing := xynolog.DefaultTransportTiming()
	service := xynolog.NewServiceToken(
		xynolog.SecretCredential{Issuer: issuer, ClientID: "xynolog-smelter", ClientSecret: secret},
		xynolog.Issuer{HTTP: http.DefaultClient, Timing: timing},
	)
	agent, err := xynolog.SignInAgent(ctx, xynolog.AgentConfig{
		Gateway: gateway, Service: service, HTTP: http.DefaultClient, Timing: timing,
	})
	if err != nil {
		return err
	}
	defer agent.Close()
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: gateway, Token: agent.Token(), Refresher: agent, Channels: xynolog.JobClaimChannels,
		HTTP: http.DefaultClient, Timing: timing,
	})
	defer transport.Close()
	fmt.Println("working as", agent.DID()) // who its work is attributed to: its account, as the gateway names it
	for state := range transport.State().Changes(ctx) {
		if state == api.ConnectionStateOpen {
			fmt.Println("its stream is open, as the agent")
			return nil
		}
	}
	return ctx.Err()
}

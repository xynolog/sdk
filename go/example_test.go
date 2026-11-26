package xynolog_test

// The examples pkg.go.dev shows beside the API. Each is compiled with the
// tests, and one that states its output is run and held to it. README.md's
// programs, with internal/readme, are the longer tour.

import (
	"context"
	"fmt"
	"net/http"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/xynologtest"
)

// A client of the knowledge base whose gateway is at origin, as the person
// whose token it holds. The transport carries the bus and the client's
// requests; the content transport, over it, carries resources' bytes.
func ExampleNewClient() {
	origin, token := "https://kb.example.org", "the person's access token"
	timing := xynolog.DefaultTiming()
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: origin, Token: xynolog.NewVariable(token), Channels: bus.BridgedChannels, HTTP: http.DefaultClient, Timing: timing,
	})
	client := xynolog.NewClient(xynolog.ClientConfig{
		Transport: transport, Content: xynolog.NewHTTPContentTransport(transport), Gateway: transport, Timing: timing,
	})
	// The client first, then the transport it speaks through.
	defer transport.Close()
	defer client.Close()

	status, err := client.System.Status(context.Background())
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(status.Version)
}

// An agent: an account that signs in at its issuer with a secret, and holds
// the token its issuer grants, renewed, as its bearer at the gateway.
func ExampleSignInAgent() {
	ctx := context.Background()
	gateway, issuer := "https://kb.example.org", "https://issuer.example.org"
	timing := xynolog.DefaultTiming()
	service := xynolog.NewServiceToken(
		xynolog.SecretCredential{Issuer: issuer, ClientID: "my-agent", ClientSecret: "the agent's secret"},
		xynolog.Issuer{HTTP: http.DefaultClient, Timing: timing},
	)
	agent, err := xynolog.SignInAgent(ctx, xynolog.AgentConfig{
		Gateway: gateway, Service: service, HTTP: http.DefaultClient, Timing: timing,
	})
	if err != nil {
		fmt.Println(err)
		return
	}
	defer agent.Close()
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: gateway, Token: agent.Token(), Refresher: agent, Channels: xynolog.JobClaimChannels,
		HTTP: http.DefaultClient, Timing: timing,
	})
	defer transport.Close()
	fmt.Println("working as", agent.DID())
}

// A resource's text, read out of its bytes. The client here is a real one
// over xynologtest's doubles, which is how a test of a program that takes a
// client is built.
func ExampleBrowseNamespace_ResourceContent() {
	made := xynologtest.NewTestClient(xynologtest.TestClientConfig{Timing: xynolog.DefaultTiming()})
	defer made.Transport.Close()
	defer made.Client.Close()

	resource, err := api.ParseResourceId("res-1")
	if err != nil {
		fmt.Println(err)
		return
	}
	made.Content.Seed(resource, api.ResourceRepresentation{Data: []byte("Attention is all you need."), ContentType: "text/plain; charset=utf-8"})
	text, err := made.Client.Browse.ResourceContent(context.Background(), resource)
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println(text)
	// Output: Attention is all you need.
}

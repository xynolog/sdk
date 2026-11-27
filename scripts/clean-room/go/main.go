// A program built on the module as the Go proxy serves it.
package main

import (
	"fmt"
	"net/http"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/bus"
)

func main() {
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: "https://kb.example.org", Token: xynolog.NewVariable("a token"), Channels: bus.BridgedChannels, HTTP: http.DefaultClient, Timing: xynolog.DefaultTransportTiming(),
	})
	client := xynolog.NewClient(xynolog.ClientConfig{
		Transport: transport, Content: xynolog.NewHTTPContentTransport(transport), Gateway: transport, Timing: xynolog.DefaultClientTiming(),
	})
	defer transport.Close()
	defer client.Close()
	fmt.Printf("%T\n", client)
}

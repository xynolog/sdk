package readme

import (
	"context"
	"errors"
	"fmt"
	"net/http"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

// Read asks for a resource on the bus, then hears what is added to it.
func Read(ctx context.Context, origin, token string, resource api.ResourceId) error {
	transport := xynolog.NewHTTPTransport(xynolog.HTTPTransportConfig{
		BaseURL: origin, Token: xynolog.NewVariable(token), Channels: bus.BridgedChannels, HTTP: http.DefaultClient, Timing: xynolog.DefaultTransportTiming(),
	})
	defer transport.Close()
	wire := xynolog.NewWire(transport)

	reply, err := xynolog.Request(ctx, wire, bus.BrowseResourceRequested, api.BrowseResourceRequest{ResourceId: resource}, xynolog.DefaultClientTiming().BusRequestTimeout)
	var refused *xynolog.BusRequestError
	if errors.As(err, &refused) {
		fmt.Println(refused.Code) // "bus.not-found", "bus.timeout", …: a closed vocabulary
		return nil
	}
	if err != nil {
		return err
	}
	fmt.Println(reply.Response.Resource.Name)

	// A resource's channel is read for the resource: the read holds its scope, and lets go when the loop stops or ctx is done.
	added, err := xynolog.FramesOf(ctx, wire, bus.MarkAdded, resource)
	if err != nil {
		return err
	}
	for frame, err := range added {
		if err != nil {
			return err
		}
		fmt.Println(frame.Scope, frame.Payload.Type)
		return nil
	}
	return ctx.Err()
}

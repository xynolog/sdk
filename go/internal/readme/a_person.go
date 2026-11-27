package readme

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"path/filepath"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
)

func show(code api.DeviceCode) {
	fmt.Printf("Open %s and enter %s\n", code.VerificationUri, code.UserCode)
}

// AsMe is a session as the person signed in to kb, by `xynolog login` or by
// the device grant here.
func AsMe(ctx context.Context, kb api.KbTarget, home string) error {
	directory, ok := xynolog.StateDir(xynolog.ThisSystem(), home, "", "")
	if !ok {
		return errors.New("this system keeps no sign-ins")
	}
	// The sign-in of the stack `xynolog login` keys as the knowledge base's id.
	kept := xynolog.NewSignInStore(filepath.Join(directory, xynolog.SignInFile)).Entry(kb.Id)
	timing := xynolog.DefaultTransportTiming()
	if _, held, err := kept.Held(ctx); err != nil {
		return err
	} else if !held {
		var endpoint api.HttpEndpoint
		if err := kb.Endpoint.As(&endpoint); err != nil {
			return err
		}
		gateway, err := xynolog.GatewayURL(endpoint)
		if err != nil {
			return err
		}
		issuer := xynolog.Issuer{HTTP: http.DefaultClient, Timing: timing}
		if _, err := xynolog.SignInWithDevice(ctx, issuer, gateway, kept, show); err != nil {
			return err
		}
	}
	session, end, err := xynolog.SessionFromKept(ctx, xynolog.SessionFromKeptConfig{
		Kb: kb, Kept: kept, HTTP: http.DefaultClient, Channels: bus.BridgedChannels,
		ClientTiming: xynolog.DefaultClientTiming(), TransportTiming: timing,
	})
	if err != nil {
		return err
	}
	defer end() // the client, then the session, then its transport
	status, err := session.Client().System.Status(ctx)
	if err != nil {
		return err
	}
	if me := session.User().Value(); me != nil {
		fmt.Println(me.Did, status.Version)
	}
	return nil
}

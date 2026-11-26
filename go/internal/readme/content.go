package readme

import (
	"bytes"
	"context"
	"fmt"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// Store uploads a page, reads it back, and asks the gateway who is signed in
// and whether it is serving. Over HTTP, content is
// xynolog.NewHTTPContentTransport(transport), and gateway is the transport.
func Store(ctx context.Context, content xynolog.ContentTransport, gateway xynolog.GatewayOperations, page []byte) (api.ResourceId, error) {
	upload := content.PutBinary(ctx, xynolog.PutBinaryRequest{
		Name: "A page", Bytes: page, Format: "text/markdown", StorageURI: "file://pages/a.md", EntityTypes: []string{"Note"},
	})
	for progress := range upload.Progress() {
		member, err := progress.Member()
		if err != nil {
			return api.ResourceId{}, err
		}
		switch reported := member.(type) {
		case api.UploadProgressStarted:
			if reported.TotalBytes != nil {
				fmt.Println("sending", *reported.TotalBytes)
			}
		case api.UploadProgressProgress:
			fmt.Println(reported.BytesUploaded, "sent")
		case api.UploadProgressFinished:
			fmt.Println("made", reported.ResourceId)
		}
	}
	created, err := upload.Wait(ctx)
	if err != nil {
		return api.ResourceId{}, err
	}

	stored, err := content.GetBinary(ctx, created.ResourceId)
	if err != nil {
		return api.ResourceId{}, err
	}
	if !bytes.Equal(stored.Bytes, page) || stored.ContentType != "text/markdown" {
		return api.ResourceId{}, fmt.Errorf("read back %d bytes of %s", len(stored.Bytes), stored.ContentType)
	}

	me, err := gateway.GetCurrentUser(ctx)
	if err != nil {
		return api.ResourceId{}, err
	}
	health, _, err := gateway.HealthCheck(ctx)
	if err != nil {
		return api.ResourceId{}, err
	}
	fmt.Println(me.Did, health.Status)
	return created.ResourceId, nil
}

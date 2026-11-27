package readme

import (
	"context"
	"encoding/json"
	"slices"
	"strings"
	"testing"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/bus"
	"github.com/xynolog/sdk/go/xynologtest"
)

// TitleOf is the code under test: a resource's name, in capitals.
func TitleOf(ctx context.Context, client *xynolog.Client, resource api.ResourceId) (string, error) {
	described, err := client.Browse.Resource(resource).Fresh(ctx)
	return strings.ToUpper(described.Name), err
}

// ATitleIsItsResourcesNameInCapitals is the test of it.
func ATitleIsItsResourcesNameInCapitals(t *testing.T) {
	made := xynologtest.NewTestClient(xynologtest.TestClientConfig{Timing: xynolog.DefaultClientTiming()})
	defer made.Transport.Close()
	defer made.Client.Close()
	asked := bus.BrowseResourceRequested.Request().Channel()
	made.Transport.QueueReply(asked, json.RawMessage(`{"resource":{"@context":"https://schema.org","@id":"res-1","name":"a page of notes","representations":[]},"lastSequence":1}`))

	resource, err := api.ParseResourceId("res-1")
	if err != nil {
		t.Fatal(err)
	}
	if title, err := TitleOf(context.Background(), made.Client, resource); err != nil || title != "A PAGE OF NOTES" {
		t.Fatalf("the title is %q (%v)", title, err)
	}

	// What the code under test asked of the knowledge base, as it was sent.
	sent := made.Transport.RequestLog()
	if !slices.EqualFunc(sent, []string{`{"resourceId":"res-1"}`}, func(entry xynologtest.RequestLogEntry, payload string) bool {
		return entry.Channel == asked && string(entry.Payload) == payload
	}) {
		t.Fatalf("asked %v", sent)
	}
}

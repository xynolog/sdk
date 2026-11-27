package readme

import (
	"context"
	"fmt"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// Watch shows a resource's annotations as they change, until ctx is done.
func Watch(ctx context.Context, client *xynolog.Client, resource api.ResourceId) {
	for state := range client.Browse.Annotations(resource).States(ctx) { // holds the resource's scope
		switch state := state.(type) {
		case xynolog.Pending[[]api.Annotation]:
			fmt.Println("asking")
		case xynolog.Ready[[]api.Annotation]:
			fmt.Println(len(state.Value), "annotations")
		case xynolog.Failed[[]api.Annotation]: // a state, not the end: the query lives on
			fmt.Println("failed:", state.Error)
		}
	}
}

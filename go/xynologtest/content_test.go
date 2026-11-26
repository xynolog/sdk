package xynologtest_test

import (
	"context"
	"slices"
	"testing"

	"github.com/xynolog/sdk/go/api"
	"github.com/xynolog/sdk/go/xynologtest"
)

// An upload is kept under an id of the double's making, and reports its
// size, that all of it was sent, and the resource made.
func TestAnUploadInMemoryReportsItsSizeThatAllOfItWasSentAndTheResourceMade(t *testing.T) {
	content := xynologtest.NewInMemoryContent()
	upload := content.PutBinary(context.Background(), api.PutBinaryRequest{
		Name: "Notes", File: []byte("some notes"), Format: "text/plain", StorageUri: "file://notes.txt",
	})
	var reports []any
	for progress := range upload.Progress() {
		member, err := progress.Member()
		if err != nil {
			t.Fatal(err)
		}
		reports = append(reports, member)
	}
	created, err := upload.Wait(context.Background())
	if err != nil {
		t.Fatal(err)
	}
	if created.ResourceId.String() != "test-content-1" {
		t.Errorf("the upload is kept as %s", created.ResourceId)
	}
	want := []any{
		api.UploadProgressStarted{Phase: api.UploadProgressStartedPhaseStarted, TotalBytes: 10},
		api.UploadProgressProgress{Phase: api.UploadProgressProgressPhaseProgress, BytesUploaded: 10, TotalBytes: 10},
		api.UploadProgressFinished{Phase: api.UploadProgressFinishedPhaseFinished, ResourceId: created.ResourceId},
	}
	if !slices.Equal(reports, want) {
		t.Errorf("the upload reported %+v, want %+v", reports, want)
	}
}

package readme

import (
	"context"
	"errors"
	"fmt"
	"strings"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// Count is your work: read the resource, and say how many lines it has. A
// worker that annotates builds each api.Annotation it finds and commits them
// with job.Commit before it completes.
func Count(ctx context.Context, client *xynolog.Client, job *xynolog.HeldMarkJob) (api.MarkJobResult, error) {
	var result api.MarkJobResult
	text, err := client.Browse.ResourceContent(ctx, job.ResourceId())
	if err != nil {
		return result, err
	}
	if err := job.Progress(ctx, api.JobProgress{Percentage: 50}); err != nil {
		return result, err
	}
	err = result.From(api.MarkJobDone{Found: strings.Count(text, "\n"), Persisted: 0})
	return result, err
}

// Run claims the highlighting jobs of the knowledge base client reaches, one
// at a time, until ctx is done or the credential can never claim.
func Run(ctx context.Context, client *xynolog.Client) error {
	var highlights api.MarkJobFilter
	highlights.JobType = api.MarkJobFilterJobTypeMark
	highlights.Params.Motivation = api.MotivationHighlighting
	var accepts api.JobFilter
	if err := accepts.From(highlights); err != nil {
		return err
	}
	// Closing the claims stops the worker: a job it still holds is failed first, and the queue retries it.
	claims := client.Job.Claim(api.ClaimOptions{Accepts: []api.JobFilter{accepts}})
	defer claims.Close()
	stop := context.AfterFunc(ctx, claims.Close)
	defer stop()
	deterministic := api.FailureClassDeterministic
	// Each job the worker comes to hold, one at a time. The next is claimed when this one settles.
	for held, err := range claims.All() {
		var refused *xynolog.ClaimRefusal
		if errors.As(err, &refused) && refused.Code != nil && *refused.Code == api.BusRequestErrorCodeUnauthorized {
			// This credential can never claim. Stop, so that whoever runs the worker sees it.
			return refused
		}
		if err != nil {
			fmt.Println("claim refused:", err)
			continue
		}
		switch job := held.(type) {
		case *xynolog.HeldYieldJob:
			if err := job.Fail(ctx, "this worker runs no yield job", xynolog.JobFailure{FailureClass: &deterministic}); err != nil {
				return err
			}
		case *xynolog.HeldMarkJob:
			if err := job.Start(ctx); err != nil {
				return err
			}
			result, err := Count(ctx, client, job)
			if err != nil {
				err = job.Fail(ctx, err.Error(), xynolog.JobFailure{})
			} else {
				err = job.Complete(ctx, result)
			}
			if err != nil {
				return err
			}
		}
	}
	return ctx.Err()
}

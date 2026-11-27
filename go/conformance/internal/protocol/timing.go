package protocol

import (
	"cmp"
	"encoding/json"
	"time"

	xynolog "github.com/xynolog/sdk/go"
	"github.com/xynolog/sdk/go/api"
)

// timingRow reads the row name of a case's `timing` into the member that holds
// it.
type timingRow func(stated Arguments, name string) error

// Timing reads the argument `timing`, when it is given, each row by its name in
// protocol/specs/src/client/timing.json, into whichever of client, transport and
// claims holds it. One the driver makes nothing of is nil. A name that none of
// the others holds is the suite's mistake.
func Timing(args Arguments, client *xynolog.ClientTiming, transport *xynolog.TransportTiming, claims *api.ClaimOptions) error {
	raw, given := args["timing"]
	if !given {
		return nil
	}
	var stated Arguments
	if json.Unmarshal(raw, &stated) != nil || stated == nil {
		return Misused("timing must be an object")
	}
	rows := map[string]timingRow{}
	if client != nil {
		rows["busRequestTimeoutMs"] = durationRow(&client.BusRequestTimeout)
		rows["invalidationWindowMs"] = durationRow(&client.InvalidationWindow)
		rows["jobSilenceMs"] = durationRow(&client.JobSilence)
		rows["jobStatusPollMs"] = durationRow(&client.JobStatusPoll)
	}
	if transport != nil {
		rows["emitRetry"] = budgetRow(&transport.EmitRetry)
		rows["httpRequestTimeoutMs"] = durationRow(&transport.HttpRequestTimeout)
		rows["streamOpenTimeoutMs"] = durationRow(&transport.StreamOpenTimeout)
		rows["reconnectMs"] = durationRow(&transport.Reconnect)
		rows["lingerMs"] = durationRow(&transport.Linger)
		rows["seenEventIdsCount"] = countRow(&transport.SeenEventIdsCount)
		rows["lazyRemoveMs"] = durationRow(&transport.LazyRemove)
	}
	if claims != nil {
		rows["jobClaimTimeoutMs"] = optionRow(&claims.JobClaimTimeoutMs)
		rows["heldJobStallMs"] = optionRow(&claims.HeldJobStallMs)
		rows["heldJobStallCheckMs"] = optionRow(&claims.HeldJobStallCheckMs)
		rows["markCommitTimeoutMs"] = optionRow(&claims.MarkCommitTimeoutMs)
	}
	for name := range stated {
		read, held := rows[name]
		if !held {
			return Misused("this driver cannot override %s", name)
		}
		if err := read(stated, name); err != nil {
			return err
		}
	}
	return nil
}

func durationRow(into *time.Duration) timingRow {
	return func(stated Arguments, name string) error {
		ms, err := Count(stated, name)
		*into = time.Duration(ms) * time.Millisecond
		return err
	}
}

func countRow(into *int) timingRow {
	return func(stated Arguments, name string) error {
		count, err := Count(stated, name)
		*into = int(count)
		return err
	}
}

// optionRow reads a row a client type's member states, which is left out until
// it is read.
func optionRow(into **int) timingRow {
	return func(stated Arguments, name string) error {
		ms, err := Count(stated, name)
		*into = new(int(ms))
		return err
	}
}

func budgetRow(into *api.RetryBudget) timingRow {
	return func(stated Arguments, name string) error {
		var budget Arguments
		if json.Unmarshal(stated[name], &budget) != nil || budget == nil {
			return Misused("%s must be an object", name)
		}
		attempts, noAttempts := Count(budget, "attempts")
		initial, noInitial := Count(budget, "initialDelayMs")
		maximum, noMaximum := Count(budget, "maxDelayMs")
		*into = api.RetryBudget{Attempts: int(attempts), InitialDelayMs: int(initial), MaxDelayMs: int(maximum)}
		return cmp.Or(noAttempts, noInitial, noMaximum)
	}
}

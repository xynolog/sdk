// Code generated from protocol/specs/src/client/connection-states.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/connection_states/go.ml)

package xynolog

import "github.com/xynolog/sdk/go/api"

// connectionStateMoves is each state with the states it moves to, and no
// other.
var connectionStateMoves = map[api.ConnectionState][]api.ConnectionState{
	api.ConnectionStateInitial:         {api.ConnectionStateConnecting, api.ConnectionStateUnauthenticated, api.ConnectionStateClosed},
	api.ConnectionStateConnecting:      {api.ConnectionStateOpen, api.ConnectionStateReconnecting, api.ConnectionStateUnauthenticated, api.ConnectionStateClosed},
	api.ConnectionStateOpen:            {api.ConnectionStateReconnecting, api.ConnectionStateClosed},
	api.ConnectionStateReconnecting:    {api.ConnectionStateConnecting, api.ConnectionStateDegraded, api.ConnectionStateUnauthenticated, api.ConnectionStateClosed},
	api.ConnectionStateDegraded:        {api.ConnectionStateConnecting, api.ConnectionStateUnauthenticated, api.ConnectionStateClosed},
	api.ConnectionStateUnauthenticated: {api.ConnectionStateConnecting, api.ConnectionStateClosed},
	api.ConnectionStateClosed:          {},
}

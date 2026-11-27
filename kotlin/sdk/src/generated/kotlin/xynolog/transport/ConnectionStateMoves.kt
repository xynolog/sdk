// Generated from protocol/specs/src/client/connection-states.json; do not edit.
// Regenerate: make generate (codegen/lib/connection_states/kotlin.ml)

package xynolog.transport

import xynolog.types.ConnectionState

/** Each state of a client's stream, with the states it moves to and no other. */
internal val CONNECTION_STATE_MOVES: Map<ConnectionState, Set<ConnectionState>> = mapOf(
    ConnectionState.Initial to setOf(ConnectionState.Connecting, ConnectionState.Unauthenticated, ConnectionState.Closed),
    ConnectionState.Connecting to setOf(ConnectionState.Open, ConnectionState.Reconnecting, ConnectionState.Unauthenticated, ConnectionState.Closed),
    ConnectionState.Open to setOf(ConnectionState.Reconnecting, ConnectionState.Closed),
    ConnectionState.Reconnecting to setOf(ConnectionState.Connecting, ConnectionState.Degraded, ConnectionState.Unauthenticated, ConnectionState.Closed),
    ConnectionState.Degraded to setOf(ConnectionState.Connecting, ConnectionState.Unauthenticated, ConnectionState.Closed),
    ConnectionState.Unauthenticated to setOf(ConnectionState.Connecting, ConnectionState.Closed),
    ConnectionState.Closed to setOf(),
)

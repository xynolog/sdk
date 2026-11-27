// Generated from protocol/specs/src/client/connection-states.json; do not edit.
// Regenerate: make generate (codegen/lib/connection_states/rust.ml)
/// Each state of a client's stream, with the states it moves to and no other.
pub const CONNECTION_STATE_MOVES: [(ConnectionState, &[ConnectionState]); 7] = [
    (
        ConnectionState::Initial,
        &[
            ConnectionState::Connecting,
            ConnectionState::Unauthenticated,
            ConnectionState::Closed,
        ],
    ),
    (
        ConnectionState::Connecting,
        &[
            ConnectionState::Open,
            ConnectionState::Reconnecting,
            ConnectionState::Unauthenticated,
            ConnectionState::Closed,
        ],
    ),
    (
        ConnectionState::Open,
        &[ConnectionState::Reconnecting, ConnectionState::Closed],
    ),
    (
        ConnectionState::Reconnecting,
        &[
            ConnectionState::Connecting,
            ConnectionState::Degraded,
            ConnectionState::Unauthenticated,
            ConnectionState::Closed,
        ],
    ),
    (
        ConnectionState::Degraded,
        &[
            ConnectionState::Connecting,
            ConnectionState::Unauthenticated,
            ConnectionState::Closed,
        ],
    ),
    (
        ConnectionState::Unauthenticated,
        &[ConnectionState::Connecting, ConnectionState::Closed],
    ),
    (ConnectionState::Closed, &[]),
];

// Generated from protocol/specs/src/client/connection-states.json; do not edit.
// Regenerate: make generate (codegen/lib/connection_states/swift.ml)
import Foundation

/// Each state of a client's stream, with the states it moves to and no other.
let connectionStateMoves: [ConnectionState: [ConnectionState]] = [
  .initial: [.connecting, .unauthenticated, .closed],
  .connecting: [.`open`, .reconnecting, .unauthenticated, .closed],
  .`open`: [.reconnecting, .closed],
  .reconnecting: [.connecting, .degraded, .unauthenticated, .closed],
  .degraded: [.connecting, .unauthenticated, .closed],
  .unauthenticated: [.connecting, .closed],
  .closed: [],
]

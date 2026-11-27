(* The states of a client's stream and the moves between them
   (protocol/specs/src/client/connection-states.json): each state of
   client/types/ConnectionState.json, in its order, which Protocol's reader
   holds the table to, with each state it moves to. *)

module States = Tables.Client_connection_states

let file = "client/connection-states.json"

type t = (string * string list) list

let derive (spec : Spec.t) : t =
  List.map
    (fun (row : States.states_item) ->
      ( States.connection_state_value row.state,
        List.map States.connection_state_value row.moves ))
    spec.tables.client_connection_states.states

let from_ = "protocol/specs/src/" ^ file

(* The Haskell SDK's transport facts: where each connection state can move
   (protocol/specs/src/client/connection-states.json), over the generated
   ConnectionState; the member a frame's trace context is lifted from; and
   the member a user's identifier is stamped under. *)

module H = Haskell_syntax

type t = {
  states : (string * string list) list;  (** Each state, and where it moves. *)
  trace_field : string;
  user_field : string;
}

let derive ~user_field (spec : Spec.t) =
  {
    states = Connection_states.Table.derive spec;
    trace_field = spec.tables.bus_registry.trace.field;
    user_field;
  }

(* The generated ConnectionState's constructor for [state]. *)
let constructor state = "ConnectionState" ^ Text.pascal state

let file ~banner t =
  let state = H.T_name "ConnectionState" in
  let text = H.T_name "Text" in
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Transport.Facts";
    imports =
      [
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Xynolog.Types" ~items:[ All "ConnectionState" ];
      ];
    body =
      [
        Value
          {
            about = [];
            name = "connectionTransitions";
            type_ = T_fun (state, T_list state);
            clauses =
              List.map
                (fun (s, targets) ->
                  {
                    H.patterns = [ Constructor (constructor s, []) ];
                    body =
                      List (List.map (fun t -> H.Name (constructor t)) targets);
                  })
                t.states;
          };
        H.value "traceField" text (Str t.trace_field);
        H.value "userField" text (Str t.user_field);
      ];
  }

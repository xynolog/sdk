(* The Haskell SDK's transport facts: where each connection state can move
   (protocol/specs/src/client/connection-states.json), over the generated
   ConnectionState; the member a frame's trace context is lifted from, and
   the members a trace carrier holds (client/types/TraceCarrier.json); and the
   member a user's identifier is stamped under. *)

module H = Haskell_syntax

let ( let* ) = Result.bind

type t = {
  states : (string * string list) list;  (** Each state, and where it moves. *)
  carrier : string list;  (** The members a trace carrier holds. *)
  trace_field : string;
  user_field : string;
}

let carrier = Roots.client_types ^ "TraceCarrier.json"

let derive ~user_field (spec : Spec.t) =
  let* carrier =
    match List.assoc_opt carrier spec.schemas with
    | Some (Schema.Schema { properties = Some properties; _ }) ->
        Ok (List.map fst properties)
    | _ -> Error (carrier ^ " states no properties")
  in
  Ok
  {
    states = Connection_states.Table.derive spec;
    carrier;
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
        H.value "traceCarrierFields" (T_list text)
          (List (List.map (fun k -> H.Str k) t.carrier));
        H.value "userField" text (Str t.user_field);
      ];
  }

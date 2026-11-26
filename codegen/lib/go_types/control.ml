(* The launcher's control API as the Go SDK carries it (go/control): every
   method and notification of protocol/specs/src/control/methods.json, each a
   value typed by package api's types of the schemas it names, and who sends
   each notification. *)

module G = Go_syntax
module T = Tables.Control_methods

let path = "go/control/methods_gen.go"
let table = "control/methods.json"

(* A method's or notification's name as a Go name: each of its segments,
   between `.` and `/`, with its first letter a capital. *)
let go_name name =
  String.split_on_char '/' name
  |> List.concat_map (String.split_on_char '.')
  |> List.map (fun segment ->
      if
        segment = ""
        || not
             (String.for_all
                (function
                  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' -> true | _ -> false)
                segment)
      then
        raise
          (Definitions.Refused
             (Printf.sprintf "%s: %s is no name a Go name is made of" table name));
      String.capitalize_ascii segment)
  |> String.concat ""

(* Package api's type of the schema the table names by [target]. *)
let api_type (spec : Spec.t) ~declared target =
  let file, _ =
    Decode.resolve spec.ids { Decode.target; file = table; pointer = "" }
  in
  match
    List.find_opt
      (fun (_, r) -> fst (Decode.resolve spec.ids r) = file)
      (Roots.all spec)
  with
  | Some (name, _) when List.mem name declared -> G.Named ("api." ^ name)
  | _ ->
      raise
        (Definitions.Refused
           (Printf.sprintf "%s names %s, for which package api declares no type"
              table target))

(* Package api's constant of who sends a notification, of ControlSender. *)
let sender_constant from =
  "api.ControlSender" ^ Naming.variant (T.control_sender_value from)

let text (spec : Spec.t) ~declared =
  let t : T.t = spec.tables.control_methods in
  let typed = api_type spec ~declared in
  let strings items =
    G.inline ~of_:(G.Slice (G.Named "string"))
      (List.map (fun s -> G.item (G.Quoted s)) items)
  in
  G.text
    {
      header =
        G.verbatim
          ("Code generated from protocol/specs/src/control/methods.json and \
            the schemas it names — DO NOT EDIT.\n\n\
            Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
      package = "control";
      imports = [ [ "github.com/xynolog/sdk/go/api" ] ];
      decls =
        [
          G.Vars
            {
              doc = [];
              spacing = Spaced;
              specs =
                List.map
                  (fun (m : T.methods_item) ->
                    G.spec
                      ~doc:(G.prose (go_name m.name ^ ": " ^ m.docs))
                      (go_name m.name)
                      (G.inline
                         ~of_:
                           (G.Generic
                              ("Method", [ typed m.params; typed m.result ]))
                         [
                           G.keyed "Name" (G.Quoted m.name);
                           G.keyed "Exclusive"
                             (G.Name (string_of_bool m.exclusive));
                           G.keyed "Sends" (strings m.sends);
                         ]))
                  t.methods;
            };
          G.Vars
            {
              doc = [];
              spacing = Spaced;
              specs =
                List.map
                  (fun (n : T.notifications_item) ->
                    G.spec
                      ~doc:(G.prose (go_name n.name ^ ": " ^ n.docs))
                      (go_name n.name)
                      (G.inline
                         ~of_:(G.Generic ("Notification", [ typed n.params ]))
                         [
                           G.keyed "Name" (G.Quoted n.name);
                           G.keyed "From" (G.Name (sender_constant n.from));
                         ]))
                  t.notifications;
            };
        ];
    }

let file spec ~declared = { Output.path; text = text spec ~declared }

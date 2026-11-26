(* The launcher's control API as the OCaml SDK states it
   (ocaml/sdk/lib/control.ml, from protocol/specs/src/control/methods.json):
   which side sends a notification ([sender]), and a value per method and per
   notification, named for its name in snake case ([identity.users.list] is
   [identity_users_list], [notifications/userAction] is
   [notifications_user_action]), a [Method.t] or a [Notification.t] that
   holds the descriptors in [Models] of what it carries, so a method's params
   and result, and a notification's params, are typed by their schemas. *)

module C = Tables.Control_methods
module O = Ocaml_syntax

let table = "control/methods.json"
let refuse message = Error [ { Decode.file = table; pointer = ""; message } ]

(* The schema a row names by its [$id], by its file's stem. *)
let component id = Filename.remove_extension (Filename.basename id)
let descriptor id = O.ident ("Models." ^ Text.snake (component id))
let kind id = O.tags [ component id ]

let value_name name =
  String.map
    (function ('a' .. 'z' | '0' .. '9' | '_') as c -> c | _ -> '_')
    (Text.snake name)

let sender from = String.capitalize_ascii (C.control_sender_value from)

let record name params fields =
  O.module_ name
    [ O.type_item (O.type_declaration "t" ~params (Record fields)) ]

let types =
  [
    O.type_item
      (O.type_declaration "sender"
         (Variant
            (List.map (fun from -> O.constructor (sender from)) C.control_sender_all)));
    record "Method" [ "params"; "result" ]
      [
        ("name", O.type_ "string");
        ("exclusive", O.type_ "bool");
        ("sends", O.type_ "list" ~args:[ O.type_ "string" ]);
        ("params", O.type_ "Models.descriptor" ~args:[ O.type_var "params" ]);
        ("result", O.type_ "Models.descriptor" ~args:[ O.type_var "result" ]);
      ];
    record "Notification" [ "params" ]
      [
        ("name", O.type_ "string");
        ("from", O.type_ "sender");
        ("params", O.type_ "Models.descriptor" ~args:[ O.type_var "params" ]);
      ];
  ]

let method_ (m : C.methods_item) =
  O.let_ (value_name m.name)
    ~type_:(O.type_ "Method.t" ~args:[ kind m.params; kind m.result ])
    (O.record
       [
         ("Method.name", O.string m.name);
         ("exclusive", O.bool m.exclusive);
         ("sends", O.list (List.map O.string m.sends));
         ("params", descriptor m.params);
         ("result", descriptor m.result);
       ])

let notification (n : C.notifications_item) =
  O.let_ (value_name n.name)
    ~type_:(O.type_ "Notification.t" ~args:[ kind n.params ])
    (O.record
       [
         ("Notification.name", O.string n.name);
         ("from", O.construct (sender n.from));
         ("params", descriptor n.params);
       ])

let file (spec : Spec.t) =
  let t : C.t = spec.tables.control_methods in
  let names =
    List.map (fun (m : C.methods_item) -> value_name m.name) t.methods
    @ List.map
        (fun (n : C.notifications_item) -> value_name n.name)
        t.notifications
  in
  match
    List.find_opt
      (fun n -> List.length (List.filter (String.equal n) names) > 1)
      names
  with
  | Some n -> refuse (Printf.sprintf "two of its names are both %s in OCaml" n)
  | None ->
      Ok
        (O.implementation ~path:"ocaml/sdk/lib/control.ml"
           ~banner:
             (Banner.ocaml ~from_:("protocol/specs/src/" ^ table) __FILE__)
           (types @ List.map method_ t.methods
           @ List.map notification t.notifications))

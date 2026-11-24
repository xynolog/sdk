(* The control group: the launcher's control API, from
   protocol/specs/src/control/methods.json and the schemas it names, for cli's
   internal/launcher: control_schemas_gen.go, the text of every schema a
   control message is read against, the method and notification tables, and
   the control group of errors/codes.json. The types of what the messages
   carry are the Go SDK's: package api declares one for every schema, and
   package control a value for every method and notification. *)

module G = Go_syntax
module T = Tables.Control_methods
open Schemas

let table = "control/methods.json"
let directory = "internal/launcher/"

(* A file a method or notification names, from the table's place. *)
let named_file ids path =
  fst (Decode.resolve ids { Decode.target = path; file = table; pointer = "" })

let header =
  G.verbatim
    ("Code generated from protocol/specs/src/control/methods.json and the \
      schemas it names — DO NOT EDIT.\n\n\
      Regenerate: make generate (xynolog/sdk's " ^ Banner.writer __FILE__ ^ ")"
    )

let derive ~root (spec : Spec.t) =
  let t : T.t = spec.tables.control_methods in
  List.iter
    (fun (m : T.methods_item) ->
      List.iter
        (fun sent ->
          if
            not
              (List.exists
                 (fun (n : T.notifications_item) ->
                   n.name = sent && n.from = T.Launcher)
                 t.notifications)
          then
            refuse table
              (Printf.sprintf
                 "%s sends %s, which is no notification the launcher sends"
                 m.name sent))
        m.sends)
    t.methods;
  let methods =
    List.map
      (fun (m : T.methods_item) ->
        (m, named_file spec.ids m.params, named_file spec.ids m.result))
      t.methods
  in
  let notifications =
    List.map
      (fun (n : T.notifications_item) -> (n, named_file spec.ids n.params))
      t.notifications
  in
  let error_data = named_file spec.ids t.error_data in
  let api_version_file = named_file spec.ids t.api_version in
  let api_version =
    match layer api_version_file (schema spec api_version_file) with
    | { const = Some (String_literal v); _ } -> v
    | _ -> refuse api_version_file "states no version as its const"
  in
  let reached =
    reach spec
      (api_version_file :: error_data
       :: List.concat_map (fun (_, p, r) -> [ p; r ]) methods
      @ List.map snd notifications)
  in
  let codes =
    match Error_codes.Table.derive spec.tables.errors_codes with
    | Ok table -> table.control.codes
    | Error (e :: _) -> raise (Refused e)
    | Error [] -> refuse Error_codes.Table.file "refused"
  in
  if codes = [] then
    refuse Error_codes.Table.file "its control group lists no codes";
  let constant (c : Error_codes.Table.code) =
    if not (String.starts_with ~prefix:"control." c.code) then
      refuse Error_codes.Table.file
        (Printf.sprintf "control's %s is not control.<kebab-case>" c.code);
    "controlCode" ^ Error_codes.Table.pascal (Error_codes.Table.segment c.code)
  in
  let q s = G.Quoted s in
  let strings items =
    G.inline ~of_:(G.Slice (G.Named "string"))
      (List.map (fun s -> G.item (q s)) items)
  in
  let schemas_file =
    {
      Output.path = directory ^ "control_schemas_gen.go";
      text =
        G.text
          {
            header;
            package = "launcher";
            imports = [];
            decls =
              [
                G.Const
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlAPIVersion: the version of the control API \
                           this launcher speaks.")
                     "controlAPIVersion" (q api_version));
                G.Const
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlErrorDataSchema: the schema of a failed \
                           request's error data.")
                     "controlErrorDataSchema"
                     (q (id ~root error_data)));
                G.Var
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlSchemaFiles: the text of every schema a \
                           control message is read against, and of every \
                           schema those refer to, by its $id.")
                     "controlSchemaFiles"
                     (G.lines
                        ~of_:(G.Map (G.Named "string", G.Named "string"))
                        ~spacing:Spaced
                        (List.map
                           (fun file ->
                             G.element
                               ~key:(q (id ~root file))
                               (q (text ~root file)))
                           reached)));
                G.Var
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlMethods: each method, the schemas of its \
                           params and its result, whether it is exclusive, and \
                           the notifications it may send besides progress.")
                     "controlMethods"
                     (G.lines ~of_:(G.Slice (G.Named "controlMethod"))
                        (List.map
                           (fun ((m : T.methods_item), params, result) ->
                             G.item
                               (G.inline
                                  [
                                    G.keyed "name" (q m.name);
                                    G.keyed "params" (q (id ~root params));
                                    G.keyed "result" (q (id ~root result));
                                    G.keyed "exclusive"
                                      (G.Name (string_of_bool m.exclusive));
                                    G.keyed "sends" (strings m.sends);
                                  ]))
                           methods)));
                G.Var
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlNotifications: each notification, who sends \
                           it, and the schema of its params.")
                     "controlNotifications"
                     (G.lines ~of_:(G.Slice (G.Named "controlNotification"))
                        (List.map
                           (fun ((n : T.notifications_item), params) ->
                             G.item
                               (G.inline
                                  [
                                    G.keyed "name" (q n.name);
                                    G.keyed "from" (q (T.from_value n.from));
                                    G.keyed "params" (q (id ~root params));
                                  ]))
                           notifications)));
                G.Consts
                  {
                    doc =
                      G.prose
                        "The control group of \
                         protocol/specs/src/errors/codes.json: why a request \
                         failed.";
                    specs =
                      List.map
                        (fun (c : Error_codes.Table.code) ->
                          G.spec ~doc:(G.prose c.docs) (constant c) (q c.code))
                        codes;
                    spacing = Spaced;
                  };
                G.Var
                  (G.spec
                     ~doc:
                       (G.prose
                          "controlCodes: every code of the control group, in \
                           its order.")
                     "controlCodes"
                     (G.lines ~of_:(G.Slice (G.Named "string"))
                        (List.map (fun c -> G.item (G.Name (constant c))) codes)));
              ];
          };
    }
  in
  [ schemas_file ]

let files ~root spec = Schemas.files (fun () -> derive ~root spec)

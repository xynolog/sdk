(* The launcher's control API as the Haskell SDK states it (Xynolog.Control,
   from protocol/specs/src/control/methods.json): which side sends a
   notification ([ControlSender]), and a value per method and per
   notification, named for its name in camel case ([identity.users.list] is
   [identityUsersList]). A method is a [ControlMethod params result] and a
   notification a [ControlNotification params], whose type arguments are the
   types of Xynolog.Types its schemas are. *)

module H = Haskell_syntax
module C = Tables.Control_methods

(* The type a row names by its [$id], by its file's stem. *)
let component id = Filename.remove_extension (Filename.basename id)
let value_name name = String.uncapitalize_ascii (Text.pascal name)

let sender from =
  "ControlSender" ^ String.capitalize_ascii (C.control_sender_value from)

let text = H.T_name "Text"

let module_ ~banner (t : C.t) =
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
  | Some n -> Error (Printf.sprintf "two of its names are both %s in Haskell" n)
  | None ->
      let carried =
        List.sort_uniq String.compare
          (List.concat_map
             (fun (m : C.methods_item) ->
               [ component m.params; component m.result ])
             t.methods
          @ List.map
              (fun (n : C.notifications_item) -> component n.params)
              t.notifications)
      in
      let method_ (m : C.methods_item) =
        H.value ~about:[ m.docs ] (value_name m.name)
          (H.T_apply
             ( "ControlMethod",
               [ H.T_name (component m.params); H.T_name (component m.result) ]
             ))
          (H.Construct
             ( "ControlMethod",
               [
                 ("controlMethodName", H.Str m.name);
                 ( "controlMethodExclusive",
                   H.Name (if m.exclusive then "True" else "False") );
                 ( "controlMethodSends",
                   H.List (List.map (fun s -> H.Str s) m.sends) );
               ] ))
      and notification (n : C.notifications_item) =
        H.value ~about:[ n.docs ] (value_name n.name)
          (H.T_apply ("ControlNotification", [ H.T_name (component n.params) ]))
          (H.Construct
             ( "ControlNotification",
               [
                 ("controlNotificationName", H.Str n.name);
                 ("controlNotificationFrom", H.Name (sender n.from));
               ] ))
      in
      Ok
        {
          H.banner;
          extensions = [ "OverloadedStrings" ];
          name = "Xynolog.Control";
          imports =
            [
              H.import "Data.Text" ~items:[ Plain "Text" ];
              H.import "Xynolog.Types"
                ~items:(List.map (fun name -> H.Plain name) carried);
            ];
          body =
            [
              H.data
                ~about:[ "Which side of the control API sends a notification." ]
                ~deriving:[ "Eq"; "Show" ] "ControlSender"
                (List.map
                   (fun from -> H.constructor (sender from))
                   C.control_sender_all);
              H.record
                ~about:
                  [
                    "A method of the control API: a request whose params are a \
                     @params@,\
                    \ answered with a @result@.";
                  ]
                ~params:[ "params"; "result" ] ~deriving:[ "Eq"; "Show" ]
                ~constructor:"ControlMethod" "ControlMethod"
                [
                  ("controlMethodName", text);
                  ("controlMethodExclusive", H.T_name "Bool");
                  ("controlMethodSends", H.T_list text);
                ];
              H.record
                ~about:
                  [
                    "A notification of the control API, whose params are a \
                     @params@.";
                  ]
                ~params:[ "params" ] ~deriving:[ "Eq"; "Show" ]
                ~constructor:"ControlNotification" "ControlNotification"
                [
                  ("controlNotificationName", text);
                  ("controlNotificationFrom", H.T_name "ControlSender");
                ];
            ]
            @ List.map method_ t.methods
            @ List.map notification t.notifications;
        }

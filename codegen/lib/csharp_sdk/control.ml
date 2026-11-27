(* The launcher's control API as the C# SDK states it
   (Generated/ControlMethods.g.cs, from protocol/specs/src/control/methods.json):
   [ControlMethods], a
   property per method and per notification, named for its name in Pascal
   case. Each is a [ControlMethod<TParams, TResult>] or a
   [ControlNotification<TParams>] (Control/ControlMethod.cs), typed by the
   models of the schemas it carries. *)

module C = Csharp_syntax
module T = Tables.Control_methods

let table = "control/methods.json"
let path = "csharp/sdk/src/Xynolog/Generated/ControlMethods.g.cs"

exception Refused of string

(* The model a row names by its [$id], by its file's stem. *)
let model (models : Models.t) id =
  let name = Filename.remove_extension (Filename.basename id) in
  if List.exists (fun (n, _) -> n = name) models.models then
    C.T ("global::Xynolog.Types." ^ name)
  else
    raise
      (Refused
         (Printf.sprintf "names %s, which the C# SDK models as no type" id))

(* Who sends a notification, as the model of ControlSender. *)
let sender from = Models.enum_constant (T.control_sender_value from)

(* A control method's or notification's property on ControlMethods. *)
let property_name name = Text.pascal name

let property ~docs ~type_ ~args name =
  C.Documented
    ( docs,
      C.Property
        {
          attributes = [];
          modifiers = [ Public; Static ];
          type_;
          name = property_name name;
          accessors = [ Get ];
          value = Some (C.New { type_ = None; args = Some args; init = None });
        } )

let method_ models (m : T.methods_item) =
  property ~docs:m.docs m.name
    ~type_:
      (C.Generic
         ("ControlMethod", [ model models m.params; model models m.result ]))
    ~args:
      [
        Arg (Str m.name);
        Arg (Bool m.exclusive);
        Arg (Collection (List.map (fun s -> C.Str s) m.sends));
      ]

let notification models (n : T.notifications_item) =
  property ~docs:n.docs n.name
    ~type_:(C.Generic ("ControlNotification", [ model models n.params ]))
    ~args:
      [
        Arg (Str n.name);
        Arg (Member (Name "global::Xynolog.Types.ControlSender", sender n.from));
      ]

let file (models : Models.t) (spec : Spec.t) =
  let t : T.t = spec.tables.control_methods in
  match
    ( List.map (method_ models) t.methods,
      List.map (notification models) t.notifications )
  with
  | exception Refused message ->
      Error [ { Decode.file = table; pointer = ""; message } ]
  | methods, notifications -> (
      let names =
        List.map (fun (m : T.methods_item) -> property_name m.name) t.methods
        @ List.map
            (fun (n : T.notifications_item) -> property_name n.name)
            t.notifications
      in
      match
        List.find_opt
          (fun n -> List.length (List.filter (String.equal n) names) > 1)
          names
      with
      | Some n ->
          Error
            [
              {
                Decode.file = table;
                pointer = "";
                message = Printf.sprintf "two of its names are both %s in C#" n;
              };
            ]
      | None ->
          Ok
            {
              Output.path;
              text =
                C.text
                  {
                    header =
                      Banner.lines
                        ~from_:("protocol/specs/src/" ^ table)
                        __FILE__;
                    nullable = false;
                    usings = [];
                    namespace = "Xynolog.Control";
                    decls =
                      [
                        C.Type
                          {
                            attributes = [];
                            modifiers = [ Public; Static ];
                            kind = Class;
                            name = "ControlMethods";
                            params = None;
                            base = None;
                            body = Some (Spaced, methods @ notifications);
                          };
                      ];
                  };
            })

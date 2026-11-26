(* The launcher's control API as the Kotlin SDK reads it
   (kotlin/sdk/src/generated/kotlin/xynolog/control/ControlMethods.kt, from
   protocol/specs/src/control/methods.json): which side sends each
   notification ([ControlSender]), and [ControlMethods], each notification
   with who sends it and its params' serializer, and each method with its
   params' and its result's serializers, whether it runs alone and the
   notifications it sends, and every one by its name. Each serializer is a
   type of xynolog.types; the rows are xynolog.control's classes. *)

module C = Tables.Control_methods
module K = Kotlin_syntax

let package = "xynolog.control"
let writer = __FILE__
let generated = K.annotation "Generated"

(* The type a row names by its [$id]: the schema's, which xynolog.types names
   by its file's stem. *)
let component ~types id =
  let name = Filename.remove_extension (Filename.basename id) in
  if not (List.mem name types) then
    Names.refuse
      "control/methods.json names %s, which is no type of xynolog.types" id;
  name

let serializer name = K.call (K.Name (name ^ ".serializer")) []

let constant name =
  let c = Names.constant_name name in
  if c = "" then Names.refuse "the control API's %s has no Kotlin name" name;
  c

let field ~about ~type_ name value =
  K.property ~about:(K.Block about)
    ~annotations:[ generated; K.annotation "JvmField" ]
    ~visibility:K.Public ~type_ ~value:(K.Below value) name

let by_name ~about ~type_ names name =
  field ~about
    ~type_:(K.Generic ("Map", [ K.Type "String"; type_ ]))
    name
    (K.call ~layout:K.Lines (K.Name "mapOf")
       (List.map
          (fun name -> K.Binary (K.Str name, K.To, K.Name (constant name)))
          names))

(* The file's name, the types of xynolog.types it names, and its
   declarations. *)
let declarations ~types (t : C.t) =
  let component = component ~types in
  let sender = "ControlSender" in
  let notifications =
    List.map (fun (n : C.notifications_item) -> n.name) t.notifications
  and methods = List.map (fun (m : C.methods_item) -> m.name) t.methods in
  let names = List.map constant (notifications @ methods) in
  (match
     List.find_opt
       (fun c -> List.length (List.filter (( = ) c) names) > 1)
       names
   with
  | Some c -> Names.refuse "two of the control API's names are both %s" c
  | None -> ());
  let notification (n : C.notifications_item) =
    let params = component n.params in
    field ~about:n.docs
      ~type_:(K.Generic ("ControlNotification", [ K.Type params ]))
      (constant n.name)
      (K.call ~layout:K.Lines (K.Name "ControlNotification")
         [
           K.Str n.name;
           K.Member (K.Name sender, Names.variant_of (C.control_sender_value n.from));
           serializer params;
         ])
  in
  let method_ (m : C.methods_item) =
    let params = component m.params and result = component m.result in
    field ~about:m.docs
      ~type_:(K.Generic ("ControlMethod", [ K.Type params; K.Type result ]))
      (constant m.name)
      (K.named_call ~layout:K.Lines (K.Name "ControlMethod")
         [
           ("name", K.Str m.name);
           ("params", serializer params);
           ("result", serializer result);
           ("exclusive", K.Bool m.exclusive);
           ( "sends",
             match m.sends with
             | [] -> K.call (K.Name "emptyList") []
             | sends ->
                 K.call (K.Name "listOf")
                   (List.map (fun s -> K.Name (constant s)) sends) );
         ])
  in
  let named =
    List.sort_uniq compare
      (List.map
         (fun (n : C.notifications_item) -> component n.params)
         t.notifications
      @ List.concat_map
          (fun (m : C.methods_item) ->
            [ component m.params; component m.result ])
          t.methods)
  in
  ( "ControlMethods",
    named,
    [
      K.class_
        ~about:(K.Doc "Which side of the control API sends a notification.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~constructor:
          (K.constructor
             [
               K.param ~about:(K.Doc "The side as the table spells it.")
                 ~binding:(K.Bound { visibility = K.Public; mutable_ = false })
                 "value" (K.Type "String");
             ])
        ~entries:
          (List.map
             (fun from ->
               let value = C.control_sender_value from in
               K.entry ~args:[ K.Str value ] (Names.variant_of value))
             C.control_sender_all)
        K.Enum_class sender;
      K.class_
        ~about:
          (K.Doc
             ("The launcher's control API: each of its notifications, and each \
               of its methods, with the serializers of what each carries. A \
               request that fails carries a `" ^ component t.error_data
            ^ "` as its error's data, and every request's params state its `"
            ^ component t.api_version ^ "`."))
        ~annotations:[ generated ] ~visibility:K.Public
        ~members:
          (List.map notification t.notifications
          @ List.map method_ t.methods
          @ [
              by_name
                ~about:
                  "Every notification, by its name: for code that is given a \
                   name and not a constant."
                ~type_:(K.Generic ("ControlNotification", [ K.Star ]))
                notifications "NOTIFICATIONS";
              by_name
                ~about:
                  "Every method, by its name: for code that is given a name \
                   and not a constant."
                ~type_:(K.Generic ("ControlMethod", [ K.Star; K.Star ]))
                methods "METHODS";
            ])
        K.Object "ControlMethods";
    ] )

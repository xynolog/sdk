(* The Rust SDK's protocol types (rust/sdk/src/types.rs): the body of every
   request and response the gateway declares but the ones a service only
   passes through, every channel's payload, the schemas the SDK holds beside
   them, every service's own schema ([Roots]), every kind of
   id, and the records Protocol states in its tables
   ([Table_records]), with every schema they reach; and an entry of
   the store [xynolog login] keeps (rust/sdk/src/sign_in_store.rs). *)

module Generate = Generate
module R = Rust_syntax

(* The mark unit holds the motivation a job's parameters state. *)
let accessors = [ "MarkJobParams" ]
let regenerate from_ = Banner.lines ~from_ __FILE__

(* The SDK's types: [bundle]'s schemas it generates, and how. *)
let generation (spec : Spec.t) (bundle : Definitions.bundle) :
    Generate.generation =
  let identifiers =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  {
    roots =
      List.sort_uniq String.compare
        (List.map fst (Roots.all spec)
        @ identifiers
        @ Definitions.generated_client_types spec
        @ List.map (fun (_, name, _) -> name) (Definitions.records spec));
    identifiers;
    accessors;
    keys = Definitions.map_keys spec;
  }

(* Each table the services keep to ([Roots.service_tables]) is typed by its
   own schema ([Places.schema_of]), named as that schema's file is. *)
let table_type table = Definitions.stem (Places.schema_of table)

(* [bundle]'s schemas and each service table's own, viewed as the bundle
   views every schema. *)
let with_tables (spec : Spec.t) (bundle : Definitions.bundle) =
  let named name =
    match bundle.definitions.schema name with
    | _ -> true
    | exception Definitions.Refused _ -> false
  in
  let tables =
    List.map
      (fun table ->
        let file = Places.schema_of table and name = table_type table in
        if named name then
          Definitions.refuse "%s, the schema of %s, is named as a schema is"
            file table;
        match List.assoc_opt file spec.schemas with
        | Some s -> (name, bundle.view (Normalize.shape_only s))
        | None -> Definitions.refuse "%s has no schema %s" table file)
      (Roots.service_tables spec)
  in
  {
    Definitions.names = bundle.definitions.names @ List.map fst tables;
    schema =
      (fun name ->
        match List.assoc_opt name tables with
        | Some s -> s
        | None -> bundle.definitions.schema name);
  }

let types (spec : Spec.t) =
  let bundle = Definitions.bundle spec in
  let generation = generation spec bundle in
  {
    Output.path = "rust/sdk/src/generated/types.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate "the component schemas in protocol/specs/src")
        (Generate.items (with_tables spec bundle)
           {
             generation with
             roots =
               List.sort_uniq String.compare
                 (generation.roots
                 @ List.map table_type (Roots.service_tables spec));
           });
  }

(* JSON text in ASCII, as a Rust string the printer lays out must be: each
   character past it as a JSON escape, which reads as the same value. *)
let ascii_json text =
  let b = Buffer.create (String.length text) in
  let escape code = Buffer.add_string b (Printf.sprintf "\\u%04x" code) in
  Text.fold_uchars
    (fun () u ->
      match Uchar.to_int u with
      | code when code < 0x80 -> Buffer.add_char b (Char.chr code)
      | code when code < 0x10000 -> escape code
      | code ->
          let c = code - 0x10000 in
          escape (0xD800 lor (c lsr 10));
          escape (0xDC00 lor (c land 0x3FF)))
    () text;
  Buffer.contents b

(* The tables the services keep to (rust/sdk/src/service_tables.rs, which
   names [types] and serde_json's [Error]): each table's text as protocol/specs/src holds it, read as its schema's type by
   a function named as the type is, and every table by its file, read
   through its type as a JSON value. *)
let service_tables ~root (spec : Spec.t) =
  let tables = Roots.service_tables spec in
  let text_constant table = Text.upper_snake (table_type table) in
  let reader table = Text.snake (table_type table) in
  let error = R.named "Error" in
  let read table =
    let ty = table_type table in
    [
      R.Const
        {
          doc = [];
          attrs = [];
          vis = Private;
          name = text_constant table;
          ty = R.str_ty;
          value =
            R.Str
              (ascii_json
                 (Yojson.Safe.to_string
                    (Yojson.Safe.from_file
                       (Filename.concat root ("protocol/specs/src/" ^ table)))));
        };
      R.Blank;
      R.Fn
        (R.fn_
           ~doc:[ "protocol/specs/src/" ^ table ^ ", read as `" ^ ty ^ "`." ]
           ~vis:Pub
           ~ret:
             (R.named ~args:[ R.Named ([ "types"; ty ], []); error ] "Result")
           (reader table)
           [
             R.Tail
               (R.Call
                  (R.p "serde_json::from_str", [ R.p (text_constant table) ]));
           ]);
      R.Blank;
    ]
  in
  {
    Output.path = "rust/sdk/src/generated/service_tables.rs";
    text =
      R.text
        ~header:(regenerate "the services' tables of protocol/specs/src")
        (List.concat_map read tables
        @ [
            R.Const
              {
                doc = [ "Every table, by its file under protocol/specs/src." ];
                attrs = [];
                vis = Pub;
                name = "SERVICE_TABLE_FILES";
                ty = R.Ref (None, R.Slice R.str_ty);
                value = R.Ref_of (R.Array (List.map (fun t -> R.Str t) tables));
              };
            R.Blank;
            R.Fn
              (R.fn_
                 ~doc:
                   [
                     "The table of a file under protocol/specs/src, read as \
                      its schema's type";
                     "and written as a JSON value; none if no service keeps to \
                      it.";
                   ]
                 ~vis:Pub
                 ~params:[ R.Param ("file", R.Ref (None, R.named "str")) ]
                 ~ret:
                   (R.named
                      ~args:
                        [
                          R.named
                            ~args:[ R.named "serde_json::Value"; error ]
                            "Result";
                        ]
                      "Option")
                 "service_table"
                 [
                   R.Tail
                     (R.Match
                        ( R.p "file",
                          List.map
                            (fun table ->
                              ( R.Str table,
                                R.Call
                                  ( R.p "Some",
                                    [
                                      R.Method
                                        ( R.Call (R.p (reader table), []),
                                          "and_then",
                                          [ R.p "serde_json::to_value" ] );
                                    ] ) ))
                            tables
                          @ [ (R.Wild, R.p "None") ] ));
                 ]);
          ]);
  }

let sign_in (spec : Spec.t) =
  let schema =
    match List.assoc_opt Roots.sign_in_entry spec.schemas with
    | Some s -> s
    | None -> Definitions.refuse "Protocol has no %s" Roots.sign_in_entry
  in
  {
    Output.path = "rust/sdk/src/generated/sign_in.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate ("protocol/specs/src/" ^ Roots.sign_in_entry))
        (Generate.items
           (Definitions.alone ~ids:spec.ids ~name:"SignIn" schema)
           { roots = [ "SignIn" ]; identifiers = []; accessors = []; keys = [] });
  }

(* Why a client that read a launcher's discovery document found no launcher
   (rust/sdk/src/discovery.rs): an enumeration of the reasons. *)
let discovery_absent (spec : Spec.t) =
  let reasons =
    List.map
      (fun (r : Tables.Client_discovery_absent.reasons_item) ->
        Schema.String_literal r.reason)
      spec.tables.client_discovery_absent.reasons
  in
  {
    Output.path = "rust/sdk/src/generated/discovery_absent.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate "protocol/specs/src/client/discovery-absent.json")
        (Generate.enumeration "DiscoveryAbsentReason"
           {
             (Definitions.node [ "type"; "enum" ]) with
             type_ = Some (One String);
             enum = Some reasons;
           }
           [ "Why no launcher was found." ]);
  }

(* The launcher's control API (rust/sdk/src/control.rs), from
   control/methods.json: a marker for each method and each notification,
   whose associated types are the generated types of what it carries, and the
   table of each by name. *)
module C = Tables.Control_methods

let control_table = "control/methods.json"

let carried (spec : Spec.t) id =
  let file, _ =
    Decode.resolve spec.ids
      { Decode.target = id; file = control_table; pointer = "" }
  in
  R.Named
    ( [ "crate"; "types"; Filename.remove_extension (Filename.basename file) ],
      [] )

let sender = function C.Client -> "client" | C.Launcher -> "launcher"
let sender_variant from = R.Path [ "ControlSender"; Text.pascal (sender from) ]
let static_strs = R.Ref (Some "'static", R.Slice R.static_str)
let strings names = R.Ref_of (R.Array (List.map (fun n -> R.Str n) names))

(* A control method's or notification's marker type, which names it in
   control.rs. *)
let control_marker name = Text.pascal name

let const name ty value =
  R.I_const { doc = []; vis = Private; name; ty; value = Some value }

let method_items spec (m : C.methods_item) =
  let marker = control_marker m.name in
  [
    R.Unit_struct
      { doc = [ "`" ^ m.name ^ "`: " ^ m.docs ]; vis = Pub; name = marker };
    R.Impl
      {
        generics = [];
        trait_ = Some (R.named "ControlMethod");
        for_ = R.named marker;
        items =
          [
            const "NAME" R.static_str (R.Str m.name);
            const "EXCLUSIVE" (R.named "bool") (R.Bool m.exclusive);
            const "SENDS" static_strs (strings m.sends);
            R.I_type ("Params", carried spec m.params);
            R.I_type ("Result", carried spec m.result);
          ];
      };
    R.Blank;
  ]

let notification_items spec (n : C.notifications_item) =
  let marker = control_marker n.name in
  [
    R.Unit_struct
      { doc = [ "`" ^ n.name ^ "`: " ^ n.docs ]; vis = Pub; name = marker };
    R.Impl
      {
        generics = [];
        trait_ = Some (R.named "ControlNotification");
        for_ = R.named marker;
        items =
          [
            const "NAME" R.static_str (R.Str n.name);
            const "FROM" (R.named "ControlSender") (sender_variant n.from);
            R.I_type ("Params", carried spec n.params);
          ];
      };
    R.Blank;
  ]

let control (spec : Spec.t) =
  let t : C.t = spec.tables.control_methods in
  let table name row ty fields =
    R.Const
      {
        doc = [];
        attrs = [];
        vis = Pub;
        name;
        ty = R.Ref (None, R.Slice (R.named ty));
        value =
          R.Ref_of
            (R.Array (List.map (fun r -> R.Struct ([ ty ], fields r, None)) row));
      }
  in
  {
    Output.path = "rust/sdk/src/generated/control.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate ("protocol/specs/src/" ^ control_table))
        (Generate.enumeration "ControlSender"
           {
             (Definitions.node [ "type"; "enum" ]) with
             type_ = Some (One String);
             enum =
               Some
                 (List.map
                    (fun from -> Schema.String_literal (sender from))
                    [ C.Client; C.Launcher ]);
           }
           [ "Which side of the control API sends a notification." ]
        @ List.concat_map (method_items spec) t.methods
        @ List.concat_map (notification_items spec) t.notifications
        @ [
            table "CONTROL_METHODS" t.methods "ControlMethodRow"
              (fun (m : C.methods_item) ->
                [
                  ("name", R.Str m.name);
                  ("exclusive", R.Bool m.exclusive);
                  ("sends", strings m.sends);
                ]);
            R.Blank;
            table "CONTROL_NOTIFICATIONS" t.notifications
              "ControlNotificationRow" (fun (n : C.notifications_item) ->
                [ ("name", R.Str n.name); ("from", sender_variant n.from) ]);
          ]);
  }

let files ~root (spec : Spec.t) =
  match
    [
      types spec;
      sign_in spec;
      discovery_absent spec;
      control spec;
      service_tables ~root spec;
    ]
  with
  | files -> Ok files
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]

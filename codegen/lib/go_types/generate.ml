(* Go types from component schemas, for the Go SDK's package api: a struct per
   object, a named string, integer or boolean per enumeration, with a
   constant per value, an alias per named string, list or map, and a union
   per [oneOf] or [anyOf]. A field is a pointer where its schema leaves it
   out or admits null, but one of any type, which holds nil itself. It knows
   the shapes the spec's schemas use and refuses any other.

   A union holds its value as the wire carries it, in the hand-written
   generic [union] (go/api/union.go), whose [From] and [As] take only one of
   its members: each member has the union's marker method, which is all this
   writes of the membership. A member that is no named schema (a text, a
   list, an object written in place) is named after the union. A member
   whose schema states one value of the property its union is told apart by
   says so ([told]), and [From] states it.

   The kinds of id are go/api/ids_gen.go's (the identifiers group), and are
   not written here.

   Each type that holds a list its schema requires gets a [MarshalJSON] that
   writes the list Go holds as nil as [[]]: encoding/json writes a nil slice
   as null, which a required member may not be. An object that keeps the
   members its schema does not name ([AdditionalProperties]) reads and writes
   them through go/api/written.go's [readOpen] and [writeOpen]. *)

module G = Go_syntax
module D = Definitions

let refuse = D.refuse

type state = {
  definitions : D.definitions;
  identifiers : string list;
  written : (string, G.decl list) Hashtbl.t;
      (** Every type written, by name, so a schema reached twice is written
          once. *)
  markers : (string, string list) Hashtbl.t;
      (** The unions each member type is a member of. *)
  told : (string, string * string) Hashtbl.t;
      (** The property and value each member of a union told apart states. *)
  marshal : (string, G.decl list) Hashtbl.t;
      (** The methods that write and read a type, by its name. *)
  mutable json : bool;  (** Whether a method calls encoding/json. *)
}

let defined st name = List.mem name st.definitions.names
let named name = G.Named name
let any = named "any"
let empty_object = "EmptyObject"

let lower name =
  String.make 1 (Char.lowercase_ascii name.[0])
  ^ String.sub name 1 (String.length name - 1)

(* A schema's description, after the name Go's doc comments open with. *)
let doc_of name (s : D.t) =
  match s with
  | D.Node { description = Some d; _ } | D.Ref { description = Some d; _ } ->
      G.prose (name ^ " " ^ String.trim d)
  | _ -> []

let marker union = "memberOf" ^ union
let member_interface union = lower union ^ "Member"

let mark st member union =
  let unions = Option.value ~default:[] (Hashtbl.find_opt st.markers member) in
  if not (List.mem union unions) then
    Hashtbl.replace st.markers member (unions @ [ union ])

let rec named_type st name =
  if (not (List.mem name st.identifiers)) && not (Hashtbl.mem st.written name)
  then (
    Hashtbl.replace st.written name [];
    Hashtbl.replace st.written name
      (declaration st name (st.definitions.schema name)));
  named name

(* A schema written in place, as the type [name]. A property an [allOf]
   child inherits is named after the schema that states it
   ([Definitions.owners]), so the one type is reached again through it. *)
and inline st name s =
  if not (Hashtbl.mem st.written name) then (
    Hashtbl.replace st.written name [];
    Hashtbl.replace st.written name (declaration st name s));
  named name

and inline_name st owner part = Naming.inline ~defined:(defined st) owner part

and empty st =
  if not (Hashtbl.mem st.written empty_object) then
    Hashtbl.replace st.written empty_object
      [
        G.Type
          {
            doc = G.prose (empty_object ^ " is an object with no properties.");
            name = empty_object;
            def = G.Struct { fields = []; spacing = Packed };
          };
      ];
  named empty_object

(* The Go type of a value [owner]'s property [property] holds, without the
   pointer its field may be. *)
and type_of st owner property (s : D.t) =
  let what = owner ^ "." ^ property in
  match s with
  | D.Ref { name; _ } -> named_type st name
  | D.Node { keys = []; _ } -> any
  | _ -> (
      match View.without_null s with
      | Some inner -> type_of st owner property inner
      | None -> (
          let here () = inline st (inline_name st owner property) s in
          match s with
          | D.Node { all_of = Some _; _ } -> here ()
          | _ -> (
              match View.union s with
              | Some members ->
                  if List.for_all (View.is_string st.definitions) members then
                    named "string"
                  else here ()
              | None -> (
                  match s with
                  | D.Node ({ type_ = Some (D.One t); _ } as n) -> (
                      match t with
                      | _ when n.enum <> None -> here ()
                      | String when n.format = Some Schema.Binary ->
                          G.Slice (named "byte")
                      | String -> named "string"
                      | Boolean -> named "bool"
                      | Number -> named "float64"
                      | Integer -> named "int"
                      | Null -> refuse "%s: null alone" what
                      | Array -> (
                          match n.items with
                          | Some items ->
                              G.Slice
                                (type_of st owner (property ^ "Item") items)
                          | None ->
                              refuse "%s: an array that states no items" what)
                      | Object -> object_type st owner property n here)
                  | _ ->
                      refuse "%s: a schema shape the generator does not know"
                        what))))

(* An object property's type: a struct of its own where it states
   properties, the empty object where it may hold none, and otherwise a map
   of the values it may hold. *)
and object_type st owner property (n : D.node) here =
  let has_properties =
    match n.properties with Some (_ :: _) -> true | _ -> false
  in
  match (has_properties, n.additional_properties) with
  | true, _ -> here ()
  | false, Some (D.Bool false) -> empty st
  | false, _ when n.max_properties = Some 0 -> empty st
  | false, (None | Some (D.Bool true)) -> G.Map (named "string", any)
  | false, Some values ->
      G.Map (named "string", type_of st owner (property ^ "Value") values)

and declaration st name (s : D.t) =
  let doc = doc_of name s in
  match View.union s with
  | Some members -> union_declaration st name members s doc
  | None -> (
      let owner = D.owners st.definitions name s in
      let s = D.meant s in
      let n =
        match s with
        | D.Node n -> n
        | _ -> refuse "%s: a schema shape the generator does not know" name
      in
      let alias t = [ G.Aliases { doc; specs = [ (name, t) ] } ] in
      match n.type_ with
      | _ when n.enum <> None -> enumeration name n doc
      | Some (D.One String) when n.format = Some Schema.Binary ->
          alias (G.Slice (named "byte"))
      | Some (D.One String) -> alias (named "string")
      | Some (D.One Boolean) -> alias (named "bool")
      | Some (D.One Number) -> alias (named "float64")
      | Some (D.One Integer) -> alias (named "int")
      | Some (D.One Array) -> (
          match n.items with
          | Some items -> alias (G.Slice (type_of st name "Item" items))
          | None -> refuse "%s: an array that states no items" name)
      | Some (D.One Object) -> (
          match n.properties with
          | Some (_ :: _) -> structure st name ~owner n doc
          | _ -> (
              match n.additional_properties with
              | Some (D.Bool false) ->
                  [
                    G.Type
                      {
                        doc;
                        name;
                        def = G.Struct { fields = []; spacing = Packed };
                      };
                  ]
              | _ when n.max_properties = Some 0 ->
                  [
                    G.Type
                      {
                        doc;
                        name;
                        def = G.Struct { fields = []; spacing = Packed };
                      };
                  ]
              | None | Some (D.Bool true) -> alias (G.Map (named "string", any))
              | Some values ->
                  alias (G.Map (named "string", type_of st name "Value" values))
              ))
      | _ -> refuse "%s: a schema shape the generator does not know" name)

(* A named enumeration: its type, a constant per value named after it, and
   [Valid], whether a value is one of them. *)
and enumeration name (n : D.node) doc =
  let values = Option.get n.enum in
  let base, literal =
    match n.type_ with
    | Some (D.One String) ->
        ( "string",
          function
          | Schema.String_literal v -> (Naming.variant v, G.Quoted v)
          | _ -> refuse "%s: a value of no string enumeration" name )
    | Some (D.One Integer) ->
        ( "int",
          function
          | Schema.Int_literal v -> (Naming.variant (string_of_int v), G.Int v)
          | _ -> refuse "%s: a value of no integer enumeration" name )
    | Some (D.One Boolean) ->
        ( "bool",
          function
          | Schema.Bool_literal v ->
              (Naming.variant (string_of_bool v), G.Name (string_of_bool v))
          | _ -> refuse "%s: a value of no boolean enumeration" name )
    | _ ->
        refuse "%s: an enumeration of a type the generator does not know" name
  in
  let constants =
    List.map
      (fun v ->
        let suffix, value = literal v in
        (name ^ suffix, value))
      values
  in
  let names = List.map fst constants in
  List.iteri
    (fun i c ->
      if List.mem c (List.filteri (fun j _ -> j < i) names) then
        refuse "%s: two values are both the constant %s" name c)
    names;
  [
    G.Type { doc; name; def = G.Is (named base) };
    G.Consts
      {
        doc = G.prose ("The values of " ^ name ^ ".");
        specs =
          List.map
            (fun (c, value) -> G.spec ~type_:(named name) c value)
            constants;
        spacing = Packed;
      };
    G.func
      ~doc:(G.prose ("Valid is whether e is one of " ^ name ^ "'s values."))
      ~receiver:("e", named name)
      ~results:(G.Unnamed [ named "bool" ])
      "Valid"
      (G.Block
         [
           G.Switch
             {
               tag = Some (G.Name "e");
               cases =
                 [
                   ( List.map (fun c -> G.Name c) names,
                     [ G.Return [ G.Name "true" ] ] );
                 ];
               default = None;
             };
           G.Return [ G.Name "false" ];
         ]);
  ]

and structure st name ~owner (n : D.node) doc =
  let properties =
    List.sort
      (fun (a, _) (b, _) -> String.compare a b)
      (Option.value n.properties ~default:[])
  in
  let required = Option.value n.required ~default:[] in
  let open_ =
    match n.additional_properties with
    | Some (D.Bool true) -> true
    | Some (D.Bool false) | None -> false
    | Some _ ->
        refuse
          "%s: properties beside additionalProperties of a schema, which the \
           generator does not know"
          name
  in
  let fields =
    List.map
      (fun (property, ps) ->
        let field = Text.pascal property in
        let t = type_of st (owner property) property ps in
        let nullable = Option.is_some (View.without_null ps) in
        let is_required = List.mem property required in
        let held =
          if (is_required && not nullable) || t = any then t else G.Pointer t
        in
        let tag =
          if is_required then Printf.sprintf "json:%S" property
          else Printf.sprintf "json:%S" (property ^ ",omitempty")
        in
        ( (property, field, is_required && not nullable, t),
          {
            G.doc = doc_of field ps;
            names = [ field ];
            type_ = held;
            tag = Some tag;
          } ))
      properties
  in
  let names = List.map (fun ((_, f, _, _), _) -> f) fields in
  List.iteri
    (fun i f ->
      if List.mem f (List.filteri (fun j _ -> j < i) names) then
        refuse "%s: two properties are named %s in Go" name f)
    names;
  let rest =
    if open_ then
      [
        {
          G.doc =
            G.prose
              "AdditionalProperties is every member the schema does not name, \
               as it came.";
          names = [ "AdditionalProperties" ];
          type_ = G.Map (named "string", any);
          tag = Some "json:\"-\"";
        };
      ]
    else []
  in
  let lists =
    List.filter_map
      (fun ((_, field, held_as_value, t), _) ->
        match t with G.Slice _ when held_as_value -> Some field | _ -> None)
      fields
  in
  marshalers st name ~lists ~open_;
  [
    G.Type
      {
        doc;
        name;
        def = G.Struct { fields = List.map snd fields @ rest; spacing = Packed };
      };
  ]

(* How [name] is written, where it holds a list its schema requires or keeps
   the members its schema does not name, and how such an object is read. *)
and marshalers st name ~lists ~open_ =
  let v = G.Name "v" in
  let listed =
    List.map
      (fun field ->
        G.Assign
          (G.Name ("v." ^ field), G.call "listOf" [ G.Name ("v." ^ field) ]))
      lists
  in
  let written = G.Convert (named "written", v) in
  let write =
    if lists = [] && not open_ then []
    else
      [
        G.func
          ~doc:
            (G.prose
               (if open_ then
                  "MarshalJSON writes v with the members its schema does not \
                   name, and each list its schema requires that Go holds as \
                   nil as the empty list."
                else
                  "MarshalJSON writes v, each list its schema requires that Go \
                   holds as nil written as the empty list."))
          ~receiver:("v", named name)
          ~results:(G.Unnamed [ G.Slice (named "byte"); named "error" ])
          "MarshalJSON"
          (G.Block
             ((G.Local_type ("written", named name) :: listed)
             @ [
                 G.Return
                   [
                     (if open_ then
                        G.call "writeOpen"
                          [ written; G.Name "v.AdditionalProperties" ]
                      else (
                        st.json <- true;
                        G.call "json.Marshal" [ written ]));
                   ];
               ]));
      ]
  in
  let read =
    if not open_ then []
    else
      [
        G.func
          ~doc:
            (G.prose
               "UnmarshalJSON reads v, and each member its schema does not \
                name into its AdditionalProperties.")
          ~receiver:("v", G.Pointer (named name))
          ~params:[ ("raw", G.Slice (named "byte")) ]
          ~results:(G.Unnamed [ named "error" ])
          "UnmarshalJSON"
          (G.Block
             [
               G.Local_type ("read", named name);
               G.Return
                 [
                   G.call "readOpen"
                     [
                       G.Name "raw";
                       G.Convert (G.Pointer (named "read"), v);
                       G.Unary (G.Address, G.Name "v.AdditionalProperties");
                     ];
                 ];
             ]);
      ]
  in
  if write @ read <> [] then Hashtbl.replace st.marshal name (write @ read)

and union_declaration st name members (s : D.t) doc =
  let told_apart =
    match s with
    | D.Node { discriminator = Some property; _ } ->
        Some (property, List.map (values_of st name property) members)
    | _ -> None
  in
  (match told_apart with
  | Some (property, values) ->
      let all = List.concat values in
      List.iteri
        (fun i v ->
          if List.mem v (List.filteri (fun j _ -> j < i) all) then
            refuse "%s: two members state the `%s` %s" name property v)
        all
  | None -> ());
  let member_types =
    List.fold_left
      (fun acc member ->
        let t =
          match member with
          | D.Ref { name = target; _ } ->
              if
                View.is_string st.definitions member
                && not (List.mem target st.identifiers)
              then
                refuse
                  "%s: its member %s is text, which Go holds as a string that \
                   can be a member of no union"
                  name target;
              ignore (named_type st target);
              target
          | D.Node { type_ = Some (D.One Object); max_properties = Some 0; _ }
            ->
              ignore (empty st);
              empty_object
          | _ when View.is_string st.definitions member ->
              let t = name ^ "Text" in
              Hashtbl.replace st.written t
                [
                  G.Type
                    {
                      doc = G.prose (t ^ " is a " ^ name ^ " that is text.");
                      name = t;
                      def = G.Is (named "string");
                    };
                ];
              t
          | D.Node { type_ = Some (D.One Array); items; _ } -> (
              match items with
              | Some items ->
                  let t = name ^ "List" in
                  let item = type_of st name "Item" items in
                  Hashtbl.replace st.written t
                    [
                      G.Type
                        {
                          doc =
                            G.prose (t ^ " is a " ^ name ^ " that is a list.");
                          name = t;
                          def = G.Is (G.Slice item);
                        };
                    ];
                  t
              | None -> refuse "%s: an array that states no items" name)
          | D.Node { type_ = Some (D.One Object); _ } -> (
              let variant =
                match View.discriminant member with
                | Some d -> Text.pascal d
                | None -> "Object"
              in
              match type_of st name variant member with
              | G.Named t -> t
              | held ->
                  let t = name ^ variant in
                  Hashtbl.replace st.written t
                    [
                      G.Type
                        {
                          doc =
                            G.prose (t ^ " is a " ^ name ^ " that is an object.");
                          name = t;
                          def = G.Is held;
                        };
                    ];
                  t)
          | _ -> refuse "%s: a union member the generator does not know" name
        in
        if List.mem t acc then
          refuse "%s: two members are both the type %s" name t;
        acc @ [ t ])
      [] members
  in
  List.iter (fun t -> mark st t name) member_types;
  (match told_apart with
  | None -> ()
  | Some (property, values) ->
      List.iter2
        (fun t -> function
          | [ tag ] -> (
              match Hashtbl.find_opt st.told t with
              | Some stated when stated <> (property, tag) ->
                  refuse
                    "%s: its member %s states the `%s` %s, and another union's \
                     the `%s` %s"
                    name t property tag (fst stated) (snd stated)
              | _ -> Hashtbl.replace st.told t (property, tag))
          | _ -> ())
        member_types values);
  let interface = member_interface name in
  let discriminated =
    match told_apart with
    | None -> []
    | Some (property, tags) ->
        [
          G.func
            ~doc:
              (G.prose
                 ("Discriminator is the `" ^ property ^ "` this value states."))
            ~receiver:("u", named name)
            ~results:(G.Unnamed [ named "string"; named "error" ])
            "Discriminator"
            (G.One_line (G.Return [ G.call "u.stated" [ G.Quoted property ] ]));
          G.func
            ~doc:
              (G.prose
                 ("ValueByDiscriminator is the member this value's `" ^ property
                ^ "` names."))
            ~receiver:("u", named name)
            ~results:(G.Unnamed [ any; named "error" ])
            "ValueByDiscriminator"
            (G.Block
               [
                 G.Define ([ "tag"; "err" ], G.call "u.Discriminator" []);
                 G.If
                   ( G.Binary (G.Name "err", G.Ne, G.Name "nil"),
                     [ G.Return [ G.Name "nil"; G.Name "err" ] ] );
                 G.Switch
                   {
                     tag = Some (G.Name "tag");
                     cases =
                       List.map2
                         (fun t values ->
                           ( List.map (fun v -> G.Quoted v) values,
                             [
                               G.Return
                                 [
                                   G.Call
                                     ( G.Instance (G.Name "as", [ named t ]),
                                       [ G.Name "u.union" ] );
                                 ];
                             ] ))
                         member_types tags;
                     default = None;
                   };
                 G.Return
                   [
                     G.Name "nil";
                     G.call "unnamedMember"
                       [ G.Quoted name; G.Quoted property; G.Name "tag" ];
                   ];
               ]);
        ]
  in
  [
    G.Type
      {
        doc;
        name;
        def =
          G.Struct
            {
              fields =
                [
                  {
                    doc = [];
                    names = [];
                    type_ = G.Generic ("union", [ named interface ]);
                    tag = None;
                  };
                ];
              spacing = G.Packed;
            };
      };
    G.Type
      {
        doc =
          G.prose
            (interface ^ " is a member of " ^ name ^ ": "
            ^ String.concat ", " member_types
            ^ ".");
        name = interface;
        def = G.Interface [ G.method_ (marker name) [] ];
      };
  ]
  @ discriminated

(* The values of [property] a member of the union [name] states: the ones
   its schema's enumeration of it admits. *)
and values_of st name property member =
  match D.meant (View.resolved st.definitions member) with
  | D.Node { required = Some required; properties = Some ps; _ }
    when List.mem property required -> (
      match List.assoc_opt property ps with
      | Some (D.Node { enum = Some values; _ }) ->
          List.map
            (function
              | Schema.String_literal v -> v
              | _ -> refuse "%s: a member's `%s` is no text" name property)
            values
      | _ -> refuse "%s: a member states no values of `%s`" name property)
  | _ -> refuse "%s: a member does not require `%s`" name property

(* The methods that make each member type a member of its unions, and say the
   value it is told apart by. *)
let membership st t =
  let markers =
    List.map
      (fun union -> G.func ~receiver:("", named t) (marker union) G.Empty)
      (Option.value ~default:[] (Hashtbl.find_opt st.markers t))
  in
  let told =
    match Hashtbl.find_opt st.told t with
    | None -> []
    | Some (property, value) ->
        [
          G.func
            ~receiver:("", named t)
            ~results:(G.Unnamed [ named "string"; named "string" ])
            "told"
            (G.One_line (G.Return [ G.Quoted property; G.Quoted value ]));
        ]
  in
  match markers @ told with [] -> [] | methods -> [ G.Adjacent methods ]

type generated = {
  decls : G.decl list;
  imports : string list;
  declared : (string * string option) list;
      (** Every type the file declares, and what it is an alias of, if it is
          one. *)
}

(* Every type of [roots], with every type they reach, in the order of their
   names. *)
let generate definitions ~identifiers roots =
  let st =
    {
      definitions;
      identifiers;
      written = Hashtbl.create 1024;
      markers = Hashtbl.create 256;
      told = Hashtbl.create 64;
      marshal = Hashtbl.create 64;
      json = false;
    }
  in
  List.iter (fun root -> ignore (named_type st root)) roots;
  let names =
    List.sort_uniq String.compare
      (Hashtbl.fold (fun n _ acc -> n :: acc) st.written []
      @ Hashtbl.fold (fun n _ acc -> n :: acc) st.markers [])
  in
  let decls =
    List.concat_map
      (fun n ->
        Option.value ~default:[] (Hashtbl.find_opt st.written n)
        @ membership st n
        @ Option.value ~default:[] (Hashtbl.find_opt st.marshal n))
      names
  in
  let declared =
    List.concat_map
      (function
        | G.Type { name; _ } -> [ (name, None) ]
        | G.Aliases { specs; _ } ->
            List.map (fun (n, t) -> (n, Some (G.type_text t))) specs
        | _ -> [])
      decls
  in
  { decls; imports = (if st.json then [ "encoding/json" ] else []); declared }

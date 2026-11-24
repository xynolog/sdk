(* Go types from Protocol's schemas as [Typing] reads them, for the Go SDK's
   package api: a struct per object, a named string, integer or boolean per
   enumeration, with a constant per value, an alias per named string, list or
   map, and a union per [oneOf] or [anyOf]. A field is a pointer where its
   schema leaves it out or admits null, but one of any type, which holds nil
   itself. It spells what [Typing] decides, and refuses a form Go has no
   spelling for.

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
module T = Typing

let refuse = Definitions.refuse

type state = {
  typing : T.t;
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

let named name = G.Named name
let any = named "any"
let string_ = named "string"
let empty_object = "EmptyObject"
let shape what = refuse "%s: a schema shape the generator does not know" what

(* A description, after the name Go's doc comments open with. *)
let doc_of name description =
  match description with
  | Some d -> G.prose (name ^ " " ^ String.trim d)
  | None -> []

let marker union = "memberOf" ^ union
let member_interface union = union ^ "Member"

let mark st member union =
  let unions = Option.value ~default:[] (Hashtbl.find_opt st.markers member) in
  if not (List.mem union unions) then
    Hashtbl.replace st.markers member (unions @ [ union ])

let identifier st name =
  match (st.typing.find name).form with T.Identifier _ -> true | _ -> false

let rec named_type st name =
  if (not (identifier st name)) && not (Hashtbl.mem st.written name) then (
    let d = st.typing.find name in
    Hashtbl.replace st.written name [];
    Hashtbl.replace st.written name
      (declaration st name d.form (doc_of name d.node_description)));
  named name

(* A type of its own written in place, declared by the name [Typing] gives
   it. *)
and declared st (i : T.inline) =
  if not (Hashtbl.mem st.written i.name) then (
    Hashtbl.replace st.written i.name [];
    Hashtbl.replace st.written i.name
      (declaration st i.name i.form (doc_of i.name i.node_description)));
  named i.name

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

(* The Go type of a value of [ty], without the pointer its field may be,
   [what] holding it. *)
and type_of st what (ty : T.ty) =
  match ty with
  | T.Named name -> named_type st name
  | T.Any -> any
  | T.Nullable inner -> type_of st what inner
  | T.Inline i -> in_place st what i
  | T.Scalar (T.Text { binary = true; _ }) -> G.Slice (named "byte")
  | T.Scalar (T.Text _) -> string_
  | T.Scalar T.Boolean -> named "bool"
  | T.Scalar T.Number -> named "float64"
  | T.Scalar (T.Integer _) -> named "int"
  | T.Null -> refuse "%s: null alone" what
  | T.List (Some items) -> G.Slice (type_of st what items)
  | T.List None -> refuse "%s: an array that states no items" what
  | T.Nothing -> shape what

(* A schema in place: a type of its own where it names members, states
   values or is a union of more than text; the empty object where it may
   hold no member; and otherwise a map of the values it may hold. *)
and in_place st what (i : T.inline) =
  match (i.form, i.composition) with
  | _, Some _ | (T.Record _ | T.Enum _), None -> declared st i
  | T.Union u, None ->
      if Deviations.text_union u then string_ else declared st i
  | form, None when T.holds_none form -> empty st
  | T.Empty _, None -> G.Map (string_, any)
  | T.Map { value; _ }, None -> G.Map (string_, type_of st what value)
  | (T.Alias _ | T.Identifier _ | T.Json), None -> shape what

and declaration st name (form : T.form) doc =
  match form with
  | T.Union u -> union_declaration st name u doc
  | T.Enum { base; values } -> enumeration name base values doc
  | T.Alias ((T.Scalar _ | T.List _) as ty) ->
      [ G.Aliases { doc; specs = [ (name, type_of st name ty) ] } ]
  | T.Record { members; rest } -> structure st name members rest doc
  | T.Empty { rest = T.Open | T.Of _; none = false } ->
      (* A type of its own, not an alias: the required table holds a value
         of it to whatever rules its schema states. *)
      [ G.Type { doc; name; def = G.Is (G.Map (string_, any)) } ]
  | T.Empty _ ->
      (* One that holds no member, or says nothing of the members it does
         not name, which are read past. *)
      [ G.Type { doc; name; def = G.Struct { fields = []; spacing = Packed } } ]
  | T.Map { key; value } ->
      (* A type of its own too: an alias is read by its kind alone, and this
         one states its keys and values. *)
      let key =
        match key with Some key -> named_type st key | None -> string_
      in
      [ G.Type { doc; name; def = G.Is (G.Map (key, type_of st name value)) } ]
  | T.Alias _ | T.Identifier _ | T.Json -> shape name

(* A named enumeration: its type, a constant per value named after it, and
   [Valid], whether a value is one of them. *)
and enumeration name (base : T.scalar option) values doc =
  let base, literal =
    match base with
    | Some (T.Text _) ->
        ( "string",
          function
          | Schema.String_literal v -> (Naming.variant v, G.Quoted v)
          | _ -> refuse "%s: a value of no string enumeration" name )
    | Some (T.Integer _) ->
        ( "int",
          function
          | Schema.Int_literal v -> (Naming.variant (string_of_int v), G.Int v)
          | _ -> refuse "%s: a value of no integer enumeration" name )
    | Some T.Boolean ->
        ( "bool",
          function
          | Schema.Bool_literal v ->
              (Naming.variant (string_of_bool v), G.Name (string_of_bool v))
          | _ -> refuse "%s: a value of no boolean enumeration" name )
    | Some T.Number | None ->
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

and structure st name (members : T.member list) (rest : T.rest) doc =
  let open_ =
    match rest with
    | T.Open -> true
    | T.Closed | T.Unstated -> false
    | T.Of _ ->
        refuse
          "%s: properties beside additionalProperties of a schema, which the \
           generator does not know"
          name
  in
  let fields =
    List.map
      (fun (m : T.member) ->
        let field = Text.pascal m.wire in
        let t = type_of st (m.owner ^ "." ^ m.wire) m.ty in
        let nullable = match m.ty with T.Nullable _ -> true | _ -> false in
        let held =
          if (m.required && not nullable) || t = any then t else G.Pointer t
        in
        let tag =
          if m.required then Printf.sprintf "json:%S" m.wire
          else Printf.sprintf "json:%S" (m.wire ^ ",omitempty")
        in
        ( (field, m.required && not nullable, t),
          {
            G.doc = doc_of field m.node_description;
            names = [ field ];
            type_ = held;
            tag = Some tag;
          } ))
      members
  in
  let names = List.map (fun ((f, _, _), _) -> f) fields in
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
          type_ = G.Map (string_, any);
          tag = Some "json:\"-\"";
        };
      ]
    else []
  in
  let lists =
    List.filter_map
      (fun ((field, held_as_value, t), _) ->
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

and union_declaration st name (u : T.union) doc =
  let told_apart =
    Option.map (fun (t : T.tag) -> (t.property, t.values)) u.tag
  in
  (* The Go type a member that is a number or a boolean is. *)
  let scalar (ty : T.ty) =
    match ty with
    | T.Scalar s | T.Inline { form = T.Enum { base = Some s; _ }; _ } -> (
        match s with
        | T.Integer _ -> Some "int"
        | T.Number -> Some "float64"
        | T.Boolean -> Some "bool"
        | T.Text _ -> None)
    | _ -> None
  in
  let member_types =
    List.fold_left
      (fun acc (b : T.branch) ->
        (* A member that is no named schema, as a type of its own named for
           its variant. *)
        let declare what held =
          let t = name ^ b.variant in
          Hashtbl.replace st.written t
            [
              G.Type
                {
                  doc = G.prose (t ^ " is a " ^ name ^ " that is " ^ what ^ ".");
                  name = t;
                  def = G.Is held;
                };
            ];
          t
        in
        let t =
          match (b.ty, scalar b.ty) with
          | T.Named target, _ ->
              if T.admits_only_text b && not (identifier st target) then
                refuse
                  "%s: its member %s is text, which Go holds as a string that \
                   can be a member of no union"
                  name target;
              ignore (named_type st target);
              target
          | T.Inline { form; composition = None; _ }, _ when T.holds_none form
            ->
              ignore (empty st);
              empty_object
          | _ when T.admits_only_text b -> declare "text" string_
          | T.List (Some _), _ -> declare "a list" (type_of st name b.ty)
          | T.List None, _ -> refuse "%s: an array that states no items" name
          | ( T.Inline { form = T.Record _ | T.Empty _ | T.Map _ | T.Union _; _ },
              _ ) -> (
              match type_of st name b.ty with
              | G.Named t -> t
              | held -> declare "an object" held)
          | _, Some held ->
              declare (String.lowercase_ascii b.variant) (named held)
          | _ -> refuse "%s: a union member the generator does not know" name
        in
        if List.mem t acc then
          refuse "%s: two members are both the type %s" name t;
        acc @ [ t ])
      [] u.branches
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

(* Every type of [typing]'s generation, with every type written in place
   within them, in the order of their names. *)
let generate (typing : T.t) =
  let st =
    {
      typing;
      written = Hashtbl.create 1024;
      markers = Hashtbl.create 256;
      told = Hashtbl.create 64;
      marshal = Hashtbl.create 64;
      json = false;
    }
  in
  List.iter (fun name -> ignore (named_type st name)) typing.names;
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

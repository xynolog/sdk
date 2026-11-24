(* Rust types from Protocol's schemas as [Typing] reads them: a struct per
   object, an enum per string enumeration, an untagged enum per union, an
   alias per named string, a type of its own per kind of id, a field per
   member, optional where the schema does not require it. It spells what
   [Typing] decides, and refuses a form Rust has no spelling for, so a schema
   that grows a new shape stops the run rather than generating something
   wrong.

   Every type written for a schema of the generation, and not an alias,
   names that schema ([Schema::NAME]), so code that needs a type's schema
   takes it from the type, and a type with none does not compile there.

   A union is written untagged. One whose schema names the property its
   members are told apart by ([status], [jobType], [motivation]), each member
   stating its own one value of it, is decoded as the member that value
   names, and a value that is wrong is refused for what is wrong with it. Any
   other is decoded as the first member that fits
   ([Deviations.single_tags]). A member's one value of such a property is its
   own to state: [new] sets it and takes the rest. A union told apart so that
   a generation names ([accessors]) says which value of the string
   enumeration the property names its member states, and a member's value
   that is none of the enumeration's is refused. What the schema says that a
   type cannot (a pattern, a length, a bound) is the validators' to hold at
   the boundary, before a value is decoded. A kind of id is the exception:
   its pattern is written as the rule its only constructor holds a value to
   (rust/sdk/src/types.rs's [Rule]), and decoding goes through that
   constructor, so a value of the type has always passed its rule. *)

module R = Rust_syntax
module T = Typing

let refuse = Definitions.refuse
let empty_object = "EmptyObject"

(* The names the SDK's own code gives what every generation shares
   (rust/sdk/src/types.rs): no schema may have one. *)
let invalid_identifier = "InvalidIdentifier"
let schema_trait = "Schema"
let own_names = [ invalid_identifier; schema_trait; "Rule"; "Admitted" ]
let ty name = R.Named ([ name ], [])
let string_ty = ty "String"
let generic name args = R.Named ([ name ], args)
let path segments = R.Path segments
let lines text = String.split_on_char '\n' text

(* A description as doc lines, as Rust's [str::lines] reads it. *)
let doc_of description =
  match description with
  | None -> []
  | Some d ->
      let d =
        if String.ends_with ~suffix:"\n" d then
          String.sub d 0 (String.length d - 1)
        else d
      in
      List.map
        (fun l ->
          if String.ends_with ~suffix:"\r" l then
            String.sub l 0 (String.length l - 1)
          else l)
        (lines d)

let describe description = doc_of description

(* An integer's type: the narrowest its bounds allow of [u16], [u64] and
   [i64]. *)
let integer_ty ~minimum ~maximum =
  let int = function
    | Some f when Float.is_integer f -> Some (int_of_float f)
    | _ -> None
  in
  ty
    (match (int minimum, int maximum) with
    | Some min, Some max when min >= 0 && max <= 65535 -> "u16"
    | Some min, _ when min >= 0 -> "u64"
    | _ -> "i64")

let only_integer (m : T.member) =
  match (m.fixed, m.ty) with
  | ( Some (Schema.Int_literal n),
      T.Inline { form = T.Enum { base = Some (T.Integer _); _ }; _ } ) ->
      Some n
  | _ -> None

let derive paths =
  R.List
    ( [ "derive" ],
      List.map
        (fun p ->
          R.Word (String.split_on_char ':' p |> List.filter (( <> ) "")))
        paths )

let serde metas = R.List ([ "serde" ], metas)

(* [items] a blank line apart, but for calls of the type macros, which are
   one block of lines. *)
let rec blank_between = function
  | [] -> []
  | (R.Macro_item _ as call) :: (R.Macro_item _ :: _ as rest) ->
      call :: blank_between rest
  | item :: rest -> item :: R.Blank :: blank_between rest

let impl ?(generics = []) ?trait_ for_ items =
  R.Impl { generics; trait_; for_; items }

(* A kind of id's pattern as the rule a value is held to: anchored at both
   ends, text every value begins with, and then one set of characters a
   stated number of times. Any other pattern is refused rather than link a
   regular-expression engine into every client for a few rules. *)
module Rule = struct
  type admitted = Not_whitespace | Of of (char * char) list

  type t = {
    prefix : string;
    admitted : admitted;
    least : int;
    most : int option;
  }

  let set text =
    if
      text = ""
      || text.[0] = '^'
      || String.exists (fun c -> c = '\\' || c = '[' || c = '\'') text
    then None
    else
      let n = String.length text in
      let rec go at acc =
        if at >= n then Some (List.rev acc)
        else if at + 2 < n && text.[at + 1] = '-' then
          go (at + 3) ((text.[at], text.[at + 2]) :: acc)
        else go (at + 1) ((text.[at], text.[at]) :: acc)
      in
      go 0 []

  let of_pattern pattern =
    let ( let* ) = Option.bind in
    let n = String.length pattern in
    let* body =
      if n >= 2 && pattern.[0] = '^' && pattern.[n - 1] = '$' then
        Some (String.sub pattern 1 (n - 2))
      else None
    in
    let* set_at =
      match (String.index_opt body '[', String.index_opt body '\\') with
      | Some a, Some b -> Some (min a b)
      | Some a, None | None, Some a -> Some a
      | None, None -> None
    in
    let prefix = String.sub body 0 set_at in
    let rest = String.sub body set_at (String.length body - set_at) in
    if String.exists (fun c -> String.contains ".|?*+(){}^$]" c) prefix then
      None
    else
      let* admitted, times =
        if String.starts_with ~prefix:"\\S" rest then
          Some (Not_whitespace, String.sub rest 2 (String.length rest - 2))
        else if String.starts_with ~prefix:"[" rest then
          let* close = String.index_opt rest ']' in
          let* chars = set (String.sub rest 1 (close - 1)) in
          Some
            ( Of chars,
              String.sub rest (close + 1) (String.length rest - close - 1) )
        else None
      in
      let* least, most =
        match times with
        | "+" -> Some (1, None)
        | "*" -> Some (0, None)
        | _ -> (
            let m = String.length times in
            let* bounds =
              if m >= 2 && times.[0] = '{' && times.[m - 1] = '}' then
                Some (String.sub times 1 (m - 2))
              else None
            in
            match String.index_opt bounds ',' with
            | Some comma -> (
                let* least = int_of_string_opt (String.sub bounds 0 comma) in
                match
                  String.sub bounds (comma + 1)
                    (String.length bounds - comma - 1)
                with
                | "" -> Some (least, None)
                | most ->
                    let* most = int_of_string_opt most in
                    Some (least, Some most))
            | None ->
                let* exactly = int_of_string_opt bounds in
                Some (exactly, Some exactly))
      in
      Some { prefix; admitted; least; most }

  let expr r =
    R.Struct
      ( [ "Rule" ],
        [
          ("prefix", R.Str r.prefix);
          ( "admitted",
            match r.admitted with
            | Not_whitespace -> path [ "Admitted"; "NotWhitespace" ]
            | Of ranges ->
                R.Call
                  ( path [ "Admitted"; "Of" ],
                    [
                      R.Ref_of
                        (R.Array
                           (List.map
                              (fun (a, b) -> R.Tuple [ R.Char a; R.Char b ])
                              ranges));
                    ] ) );
          ("least", R.Int r.least);
          ( "most",
            match r.most with
            | None -> R.p "None"
            | Some m -> R.call "Some" [ R.Int m ] );
        ],
        None )
end

type state = {
  typing : T.t;
  accessors : string list;
      (** The unions told apart by a property whose crate reads it: each is
          given a [pub(crate)] method, named as the property is, saying which
          value of the string enumeration the property names its member states.
      *)
  written : (string, R.item list) Hashtbl.t;
      (** Every type written, by name, so a schema reached twice is written
          once. *)
}

let shape what = refuse "%s: a schema shape the generator does not know" what

let rec named st name =
  if not (Hashtbl.mem st.written name) then (
    let d = st.typing.find name in
    Hashtbl.replace st.written name [];
    let items = declaration st name d.form (describe d.node_description) in
    let alias =
      List.exists
        (function R.Type_alias { name = n; _ } -> n = name | _ -> false)
        items
    in
    let items =
      if alias then items
      else
        let calls_before =
          match List.rev items with
          | R.Blank :: (R.Macro_item _ :: _ as before) -> List.rev before
          | _ -> items
        in
        calls_before @ [ R.Macro_item ("schema", [ R.p name ]) ]
    in
    Hashtbl.replace st.written name items);
  ty name

(* A type of its own written in place, declared by the name [Typing] gives
   it. *)
and declared st (i : T.inline) =
  Hashtbl.replace st.written i.name
    (declaration st i.name i.form (describe i.node_description));
  ty i.name

and empty st =
  if not (Hashtbl.mem st.written empty_object) then
    Hashtbl.replace st.written empty_object
      [
        R.Struct_def
          {
            doc = [ "An object with no properties." ];
            attrs =
              [
                derive
                  [
                    "Debug";
                    "Clone";
                    "Copy";
                    "PartialEq";
                    "Eq";
                    "Default";
                    "serde::Deserialize";
                    "serde::Serialize";
                  ];
                serde [ R.Word [ "deny_unknown_fields" ] ];
              ];
            vis = Pub;
            name = empty_object;
            generics = [];
            body = Fields [];
          };
      ];
  ty empty_object

(* The Rust type of a value of [ty], [what] holding it. *)
and type_of st what (ty_ : T.ty) =
  match ty_ with
  | T.Named name -> named st name
  | T.Any -> R.named "serde_json::Value"
  | T.Nullable inner -> type_of st what inner
  | T.Inline i -> in_place st what i
  | T.Scalar (T.Text _) -> string_ty
  | T.Scalar T.Boolean -> ty "bool"
  | T.Scalar T.Number -> ty "f64"
  | T.Scalar (T.Integer { minimum; maximum }) -> integer_ty ~minimum ~maximum
  | T.Null -> refuse "%s: null alone" what
  | T.List (Some items) -> generic "Vec" [ type_of st what items ]
  | T.List None -> refuse "%s: an array that states no items" what
  | T.Nothing -> shape what

and in_place st what (i : T.inline) =
  match (i.form, i.composition) with
  | _, Some _ | T.Record _, None -> declared st i
  | T.Union u, None ->
      if Deviations.text_union u then string_ty else declared st i
  | T.Enum { base = Some (T.Text _); _ }, None -> declared st i
  | T.Enum { base = Some (T.Integer { minimum; maximum }); _ }, None ->
      integer_ty ~minimum ~maximum
  | T.Enum { base = Some T.Boolean; _ }, None -> ty "bool"
  | T.Enum { base = Some T.Number; _ }, None -> ty "f64"
  | T.Empty _, None when Deviations.closed_empty_named i.form -> declared st i
  | (T.Empty _ as form), None when T.holds_none form -> empty st
  | T.Empty _, None ->
      R.named ~args:[ string_ty; R.named "serde_json::Value" ] "serde_json::Map"
  | T.Map { value; _ }, None ->
      R.named
        ~args:[ string_ty; type_of st what value ]
        "std::collections::BTreeMap"
  | (T.Enum { base = None; _ } | T.Alias _ | T.Identifier _ | T.Json), None ->
      shape what

and declaration st name (form : T.form) doc =
  let alias ty = [ R.Type_alias { doc; vis = Pub; name; ty } ] in
  match form with
  | T.Union u -> union_declaration st name u doc
  | T.Enum { base = Some (T.Text _); values } ->
      enumeration name
        (List.map
           (function
             | Schema.String_literal v -> v
             | _ -> refuse "%s: an enum value is not a string" name)
           values)
        doc
  | T.Enum _ -> refuse "%s: only string enumerations are generated" name
  | T.Identifier { pattern } -> identifier name pattern doc
  | T.Alias (T.Scalar (T.Text _)) -> alias string_ty
  | T.Alias (T.Scalar (T.Integer { minimum; maximum })) ->
      alias (integer_ty ~minimum ~maximum)
  | T.Alias (T.Scalar T.Number) -> alias (ty "f64")
  | T.Alias (T.Scalar T.Boolean) -> alias (ty "bool")
  | T.Map { key; value } ->
      let key = match key with Some key -> named st key | None -> string_ty in
      alias
        (R.named
           ~args:[ key; type_of st name value ]
           "std::collections::BTreeMap")
  | T.Record { members; rest } -> structure st name members rest doc
  | T.Empty { rest; _ } -> structure st name [] rest doc
  | T.Alias _ | T.Json -> shape name

and enumeration name values doc =
  let variants = List.map (fun v -> (v, Naming.variant v)) values in
  List.iteri
    (fun i (_, variant) ->
      if
        List.exists
          (fun (_, v) -> v = variant)
          (List.filteri (fun j _ -> j < i) variants)
      then
        refuse "%s: two enum values would both be the variant %s" name variant)
    variants;
  blank_between
    [
      R.Enum
        {
          doc;
          attrs =
            [
              derive
                [
                  "Debug";
                  "Clone";
                  "Copy";
                  "PartialEq";
                  "Eq";
                  "PartialOrd";
                  "Ord";
                  "Hash";
                  "serde::Deserialize";
                  "serde::Serialize";
                ];
            ];
          vis = Pub;
          name;
          variants =
            List.map
              (fun (value, variant) ->
                R.variant
                  ~attrs:[ serde [ R.Name_value ("rename", R.Str value) ] ]
                  variant)
              variants;
        };
      impl (ty name)
        [
          R.I_fn
            (R.fn_
               ~doc:[ "The value as the wire spells it." ]
               ~vis:Pub ~const:true "as_str" ~params:[ R.Self_ref ]
               ~ret:R.static_str
               [
                 R.Tail
                   (R.Match
                      ( R.p "self",
                        List.map
                          (fun (value, variant) ->
                            (path [ name; variant ], R.Str value))
                          variants ));
               ]);
        ];
    ]

(* A kind of id: a string no code can make but through [new], which holds it
   to the schema's pattern. Decoding goes through [new] too, so an id a peer
   sent is held to the same rule as one a caller made. *)
and identifier name pattern doc =
  let pattern =
    match pattern with
    | Some p -> p
    | None -> refuse "%s: a kind of id states no pattern" name
  in
  let rule =
    match Rule.of_pattern pattern with
    | Some r -> r
    | None ->
        refuse "%s: a pattern the generator cannot write as a rule: %s" name
          pattern
  in
  let self_name = ty name in
  let result = generic "Result" [ self_name; ty invalid_identifier ] in
  let as_ref_body = [ R.Tail (R.Ref_of (R.Field (R.p "self", "0"))) ] in
  let try_from trait_ assoc param_ty =
    impl ~trait_ self_name
      [
        R.I_type (assoc, ty invalid_identifier);
        R.I_blank;
        R.I_fn
          (R.fn_
             (if assoc = "Err" then "from_str" else "try_from")
             ~params:[ R.Param ("value", param_ty) ]
             ~ret:result
             [ R.Tail (R.Call (path [ name; "new" ], [ R.p "value" ])) ]);
      ]
  in
  let eq other_ty other =
    impl
      ~trait_:(generic "PartialEq" [ other_ty ])
      self_name
      [
        R.I_fn
          (R.fn_ "eq"
             ~params:[ R.Self_ref; R.Param ("other", R.Ref (None, other_ty)) ]
             ~ret:(ty "bool")
             [ R.Tail (R.Binary (R.Field (R.p "self", "0"), "==", other)) ]);
      ]
  in
  blank_between
    [
      R.Struct_def
        {
          doc;
          attrs =
            [
              derive
                [
                  "Debug";
                  "Clone";
                  "PartialEq";
                  "Eq";
                  "PartialOrd";
                  "Ord";
                  "Hash";
                  "serde::Deserialize";
                  "serde::Serialize";
                ];
              serde
                [
                  R.Name_value ("try_from", R.Str "String");
                  R.Name_value ("into", R.Str "String");
                ];
            ];
          vis = Pub;
          name;
          generics = [];
          body = Tuple_fields [ string_ty ];
        };
      impl self_name
        [
          R.I_const
            {
              doc = [ "The rule a value is held to, as the spec writes it." ];
              vis = Pub;
              name = "PATTERN";
              ty = R.static_str;
              value = Some (R.Str pattern);
            };
          R.I_blank;
          R.I_const
            {
              doc = [ "The pattern as the rule `new` holds a value to." ];
              vis = Private;
              name = "RULE";
              ty = ty "Rule";
              value = Some (Rule.expr rule);
            };
          R.I_blank;
          R.I_fn
            (R.fn_
               ~doc:
                 [
                   Printf.sprintf "`value` as a `%s`, or that it is not one."
                     name;
                 ]
               ~vis:Pub "new"
               ~params:
                 [ R.Param ("value", R.Impl_of (generic "Into" [ string_ty ])) ]
               ~ret:result
               [
                 R.Let ("value", R.Method (R.p "value", "into", []));
                 R.Tail
                   (R.If
                      ( R.Method
                          ( path [ name; "RULE" ],
                            "admits",
                            [ R.Ref_of (R.p "value") ] ),
                        [
                          R.Tail
                            (R.call "Ok"
                               [ R.Call (path [ name ], [ R.p "value" ]) ]);
                        ],
                        [
                          R.Tail
                            (R.call "Err"
                               [
                                 R.Struct
                                   ( [ invalid_identifier ],
                                     [
                                       ("kind", R.Str name);
                                       ("pattern", path [ name; "PATTERN" ]);
                                       ("value", R.p "value");
                                     ],
                                     None );
                               ]);
                        ] ));
               ]);
          R.I_blank;
          R.I_fn
            (R.fn_ ~vis:Pub "as_str" ~params:[ R.Self_ref ] ~ret:R.str_ty
               as_ref_body);
        ];
      impl
        ~trait_:(R.named "std::fmt::Display")
        self_name
        [
          R.I_fn
            (R.fn_ "fmt"
               ~params:
                 [
                   R.Self_ref;
                   R.Param
                     ( "f",
                       R.Mut_ref
                         (R.named ~args:[ R.Lifetime "'_" ]
                            "std::fmt::Formatter") );
                 ]
               ~ret:(R.named "std::fmt::Result")
               [
                 R.Tail
                   (R.Method
                      ( R.p "f",
                        "write_str",
                        [ R.Ref_of (R.Field (R.p "self", "0")) ] ));
               ]);
        ];
      impl
        ~trait_:(R.named "std::ops::Deref")
        self_name
        [
          R.I_type ("Target", ty "str");
          R.I_blank;
          R.I_fn
            (R.fn_ "deref" ~params:[ R.Self_ref ] ~ret:R.str_ty as_ref_body);
        ];
      impl
        ~trait_:(generic "AsRef" [ ty "str" ])
        self_name
        [
          R.I_fn
            (R.fn_ "as_ref" ~params:[ R.Self_ref ] ~ret:R.str_ty as_ref_body);
        ];
      try_from (R.named "std::str::FromStr") "Err" R.str_ty;
      try_from (generic "TryFrom" [ string_ty ]) "Error" string_ty;
      impl
        ~trait_:(generic "From" [ self_name ])
        string_ty
        [
          R.I_fn
            (R.fn_ "from"
               ~params:[ R.Param ("id", self_name) ]
               ~ret:string_ty
               [ R.Tail (R.Field (R.p "id", "0")) ]);
        ];
      eq (ty "str") (R.p "other");
      eq (R.Ref (None, ty "str")) (R.Deref (R.p "other"));
    ]

and structure st name (members : T.member list) (rest : T.rest) doc =
  let fields = List.map (fun (m : T.member) -> R.snake m.wire) members in
  List.iteri
    (fun i f ->
      if List.mem f (List.filteri (fun j _ -> j < i) fields) then
        refuse "%s: two properties are named %s in Rust" name f)
    fields;
  let closed = rest = T.Closed in
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
  let parameters = ref []
  and set = ref []
  and consts = ref []
  and optional = ref 0
  and single_valued = ref 0 in
  let add_param p = parameters := !parameters @ [ p ] in
  let add_set s = set := !set @ [ s ] in
  let add_const c = consts := !consts @ [ c ] in
  let option t = generic "Option" [ t ] in
  let skip = R.Name_value ("skip_serializing_if", R.Str "Option::is_none") in
  let rust_fields =
    List.map
      (fun (m : T.member) ->
        let property = m.wire in
        let rust_type = type_of st (name ^ "." ^ property) m.ty in
        let field = R.snake property in
        let renamed =
          if field <> property then
            [ serde [ R.Name_value ("rename", R.Str property) ] ]
          else []
        in
        let nullable = match m.ty with T.Nullable _ -> true | _ -> false in
        let is_required = m.required in
        let make attrs t =
          R.field
            ~doc:(describe m.node_description)
            ~attrs:(renamed @ attrs) field t
        in
        match (m.fixed, only_integer m) with
        | _ when is_required && nullable ->
            add_param (R.Param (field, option rust_type));
            add_set (field, R.p field);
            make [] (option rust_type)
        | Some (Schema.String_literal value), _ when is_required ->
            (* A property that admits one value says which member of a union
               this is. It is the type's to state, not its maker's. *)
            incr single_valued;
            let type_name =
              match rust_type with
              | R.Named ([ t ], []) -> t
              | _ -> refuse "%s.%s: one value of no enumeration" name property
            in
            add_set (field, path [ type_name; Naming.variant value ]);
            make [] rust_type
        | _, Some number when is_required ->
            (* A property that admits one number states that number, which the
               type names as a constant for a reader to compare with. *)
            incr single_valued;
            let constant = R.screaming property in
            add_const
              (R.I_const
                 {
                   doc =
                     [
                       Printf.sprintf "The one `%s` a `%s` states." property
                         name;
                     ];
                   vis = Pub;
                   name = constant;
                   ty = rust_type;
                   value = Some (R.Int number);
                 });
            add_set (field, path [ "Self"; constant ]);
            make [] rust_type
        | _ when is_required && rust_type = string_ty ->
            add_param
              (R.Param (field, R.Impl_of (generic "Into" [ string_ty ])));
            add_set (field, R.Method (R.p field, "into", []));
            make [] rust_type
        | _ when is_required ->
            add_param (R.Param (field, rust_type));
            add_set (field, R.p field);
            make [] rust_type
        | _ when nullable ->
            incr optional;
            add_set (field, R.p "None");
            (* Absent, null and a value are three things: the outer option is
               whether it was stated, the inner whether it was null. *)
            make
              [
                serde
                  [
                    R.Word [ "default" ];
                    R.Name_value ("deserialize_with", R.Str "stated");
                    skip;
                  ];
              ]
              (option (option rust_type))
        | _ ->
            incr optional;
            add_set (field, R.p "None");
            make [ serde [ R.Word [ "default" ]; skip ] ] (option rust_type))
      members
  in
  let rest =
    if open_ then
      [
        R.field
          ~doc:[ "Every property the schema does not name, as it came." ]
          ~attrs:[ serde [ R.Word [ "flatten" ] ] ]
          "rest"
          (R.named
             ~args:[ string_ty; R.named "serde_json::Value" ]
             "serde_json::Map");
      ]
    else []
  in
  let declared =
    R.Struct_def
      {
        doc;
        attrs =
          derive
            ([ "Debug"; "Clone"; "PartialEq" ]
            @ (if !parameters = [] && !single_valued = 0 then [ "Default" ]
               else [])
            @ [ "serde::Deserialize"; "serde::Serialize" ])
          ::
          (if closed then [ serde [ R.Word [ "deny_unknown_fields" ] ] ] else []);
        vis = Pub;
        name;
        generics = [];
        body = Fields (rust_fields @ rest);
      }
  in
  (* A struct that must state some properties and may leave others out is
     made from the ones it must state, and so is one with a property that
     admits a single value, which [new] states for it. One whose every
     property is the caller's to give says everything by name when it is
     written out, and one that is all optional has nothing to be made from:
     neither has a constructor, and one that is all optional is its
     [Default]. *)
  if (!parameters <> [] && !optional > 0) || !single_valued > 0 then (
    if open_ then add_set ("rest", R.call "serde_json::Map::new" []);
    let default =
      if !parameters = [] then
        [
          impl ~trait_:(ty "Default") (ty name)
            [
              R.I_fn
                (R.fn_ "default" ~ret:(ty "Self")
                   [ R.Tail (R.call "Self::new" []) ]);
            ];
        ]
      else []
    in
    blank_between
      ([ declared ] @ default
      @ [
          impl (ty name)
            ((match !consts with [] -> [] | cs -> cs @ [ R.I_blank ])
            @ [
                R.I_fn
                  (R.fn_
                     ~doc:
                       [
                         Printf.sprintf
                           "The `%s` that states %s and nothing else." name
                           (if !parameters = [] then "what it must" else "these");
                       ]
                     ~attrs:
                       (if List.length !parameters > 7 then
                          [
                            R.List
                              ( [ "allow" ],
                                [ R.Word [ "clippy"; "too_many_arguments" ] ] );
                          ]
                        else [])
                     ~vis:Pub "new" ~params:!parameters ~ret:(ty "Self")
                     [ R.Tail (R.Struct ([ "Self" ], !set, None)) ]);
              ]);
        ]))
  else [ declared; R.Blank ]

and union_declaration st name (u : T.union) doc =
  let variants =
    List.map
      (fun (b : T.branch) ->
        ( b.variant,
          match b.ty with
          | T.Scalar (T.Integer _) -> ty "i64"
          | member -> type_of st name member ))
      u.branches
  in
  let told_apart = Deviations.single_tags u in
  let enum =
    R.Enum
      {
        doc;
        attrs =
          [
            derive
              ([ "Debug"; "Clone"; "PartialEq" ]
              @ (if told_apart = None then [ "serde::Deserialize" ] else [])
              @ [ "serde::Serialize" ]);
            serde [ R.Word [ "untagged" ] ];
          ];
        vis = Pub;
        name;
        variants = List.map (fun (v, t) -> R.variant ~payload:t v) variants;
      }
  in
  let self_name = ty name in
  (* Told apart by a property, a value is decoded as the one member its
     property names, and what is wrong with it is said of that member.
     Decoded as the first member that fits, it could only be said to fit
     none. *)
  let deserialize =
    match told_apart with
    | None -> []
    | Some (property, tags) ->
        let de = R.Lifetime "'de" in
        [
          impl ~generics:[ R.Lifetime_param "'de" ]
            ~trait_:(R.named ~args:[ de ] "serde::Deserialize")
            self_name
            [
              R.I_fn
                (R.fn_ "deserialize"
                   ~generics:
                     [
                       R.Type_param
                         ("D", [ R.named ~args:[ de ] "serde::Deserializer" ]);
                     ]
                   ~params:[ R.Param ("deserializer", ty "D") ]
                   ~ret:
                     (generic "Result" [ ty "Self"; R.Assoc [ "D"; "Error" ] ])
                   [
                     R.Let
                       ( "value",
                         R.Try
                           (R.Call
                              ( R.Qualified
                                  ( R.named "serde_json::Value",
                                    R.named "serde::Deserialize",
                                    [ "deserialize" ] ),
                                [ R.p "deserializer" ] )) );
                     R.Let
                       ( "member",
                         R.Match
                           ( R.Method
                               ( R.Method
                                   (R.p "value", "get", [ R.Str property ]),
                                 "and_then",
                                 [ R.p "serde_json::Value::as_str" ] ),
                             List.map2
                               (fun tag (variant, _) ->
                                 ( R.call "Some" [ R.Str tag ],
                                   R.Method
                                     ( R.call "serde_json::from_value"
                                         [ R.p "value" ],
                                       "map",
                                       [ path [ name; variant ] ] ) ))
                               tags variants
                             @ [
                                 ( R.Wild,
                                   R.Block
                                     [
                                       R.Semi
                                         (R.Return
                                            (R.call "Err"
                                               [
                                                 R.call
                                                   "serde::de::Error::custom"
                                                   [
                                                     R.Str
                                                       (Printf.sprintf
                                                          "a %s states a `%s` \
                                                           that is one of %s"
                                                          name property
                                                          (String.concat ", "
                                                             (List.map
                                                                (fun t ->
                                                                  "`" ^ t ^ "`")
                                                                tags)));
                                                   ];
                                               ]));
                                     ] );
                               ] ) );
                     R.Tail
                       (R.Method
                          ( R.p "member",
                            "map_err",
                            [ R.p "serde::de::Error::custom" ] ));
                   ]);
            ];
        ]
  in
  let accessor =
    if not (List.mem name st.accessors) then []
    else
      match told_apart with
      | None ->
          refuse
            "%s: an accessor of the property its members are told apart by is \
             asked for, and none tells them apart"
            name
      | Some (property, tags) ->
          [ discriminator_accessor st name property tags variants ]
  in
  (* A member that is a schema of its own is the union it belongs to,
     wherever the union is wanted. A member that is text or a list is not:
     nothing says which union a [String] was meant for. *)
  let froms =
    List.concat
      (List.map2
         (fun (b : T.branch) (variant, rust_type) ->
           match b.ty with
           | T.Named _ when not (T.admits_only_text b) ->
               [
                 R.Macro_item
                   ( "member",
                     [
                       R.Call
                         ( path [ name; variant ],
                           [ R.p (R.type_text rust_type) ] );
                     ] );
               ]
           | _ -> [])
         u.branches variants)
  in
  blank_between ((enum :: deserialize) @ accessor @ froms)

(* The method saying which value of the string enumeration [property] names
   a value of the union [name] states: its member's own. *)
and discriminator_accessor st name property tags variants =
  let vocabulary = Text.pascal property in
  let values =
    let none () =
      refuse "%s: told apart by `%s`, which names no string enumeration %s" name
        property vocabulary
    in
    if not (st.typing.defined vocabulary) then none ()
    else
      match (st.typing.find vocabulary).form with
      | T.Enum { base = Some (T.Text _); values } -> values
      | _ -> none ()
  in
  let returned = named st vocabulary in
  let arms =
    List.map2
      (fun tag (variant, _) ->
        if not (List.mem (Schema.String_literal tag) values) then
          refuse "%s: a member states the `%s` `%s`, which is no %s" name
            property tag vocabulary;
        ( R.Call (path [ name; variant ], [ R.Wild ]),
          path [ vocabulary; Naming.variant tag ] ))
      tags variants
  in
  impl (ty name)
    [
      R.I_fn
        (R.fn_
           ~doc:
             [
               Printf.sprintf
                 "The `%s` this value states: the one its member is told apart \
                  by."
                 property;
             ]
           ~vis:Pub_crate ~const:true (R.snake property) ~params:[ R.Self_ref ]
           ~ret:returned
           [ R.Tail (R.Match (R.p "self", arms)) ]);
    ]

(* The items of a generation's types, every type in the order of its name. *)
let run (typing : T.t) ~accessors =
  List.iter
    (fun own ->
      if typing.defined own then
        refuse "%s is a schema's name, and the SDK's own" own)
    own_names;
  let st = { typing; accessors; written = Hashtbl.create 512 } in
  List.iter (fun root -> ignore (named st root)) typing.names;
  let names =
    List.sort String.compare
      (Hashtbl.fold (fun n _ acc -> n :: acc) st.written [])
  in
  (st, names)

(* The types written whose every member is [Eq] and [Hash], so that a value
   of one can key a map: none reaches an [f64]. Found as the greatest set
   that holds of itself, since types reach one another in cycles. *)
let hashable st names =
  let declared name =
    List.find_map
      (function
        | R.Struct_def { name = n; body = Fields fields; _ } when n = name ->
            Some (List.map (fun (f : R.field) -> f.ty) fields)
        | R.Struct_def { name = n; body = Tuple_fields tys; _ } when n = name ->
            Some tys
        | R.Enum { name = n; variants; _ } when n = name ->
            Some (List.filter_map (fun (v : R.variant) -> v.payload) variants)
        | R.Type_alias { name = n; ty; _ } when n = name -> Some [ ty ]
        | _ -> None)
      (Hashtbl.find st.written name)
  in
  let held =
    List.filter_map
      (fun name -> Option.map (fun tys -> (name, tys)) (declared name))
      names
  in
  let excluded = Hashtbl.create 64 in
  let rec admits = function
    | R.Named ([ "f64" ], []) -> false
    | R.Named ([ name ], args) when Hashtbl.mem st.written name ->
        (not (Hashtbl.mem excluded name)) && List.for_all admits args
    | R.Named
        ( ( [
              ( "String" | "bool" | "u16" | "u64" | "i64" | "Vec" | "Option"
              | "Box" );
            ]
          | [ "std"; "collections"; "BTreeMap" ]
          | [ "serde_json"; ("Map" | "Value") ] ),
          args ) ->
        List.for_all admits args
    | R.Named (segments, _) ->
        refuse "%s: a type whose Eq and Hash the generator does not know"
          (String.concat "::" segments)
    | _ -> refuse "a member type whose Eq and Hash the generator does not know"
  in
  let rec settle () =
    let dropped =
      List.filter
        (fun (name, tys) ->
          (not (Hashtbl.mem excluded name)) && not (List.for_all admits tys))
        held
    in
    List.iter (fun (name, _) -> Hashtbl.replace excluded name ()) dropped;
    if dropped <> [] then settle ()
  in
  settle ();
  fun name -> List.mem_assoc name held && not (Hashtbl.mem excluded name)

(* A derive list with [Eq] and [Hash] beside [PartialEq], each unless it has
   it. *)
let with_eq_hash attrs =
  List.map
    (function
      | R.List ([ "derive" ], words)
        when List.mem (R.Word [ "PartialEq" ]) words ->
          let lacking =
            List.filter
              (fun w -> not (List.mem w words))
              [ R.Word [ "Eq" ]; R.Word [ "Hash" ] ]
          in
          R.List
            ( [ "derive" ],
              List.concat_map
                (fun w ->
                  if w = R.Word [ "PartialEq" ] then w :: lacking else [ w ])
                words )
      | meta -> meta)
    attrs

let items typing ~accessors =
  let st, names = run typing ~accessors in
  let hashable = hashable st names in
  List.iter
    (fun name ->
      Hashtbl.replace st.written name
        (List.map
           (function
             | R.Struct_def d when hashable d.name ->
                 R.Struct_def { d with attrs = with_eq_hash d.attrs }
             | R.Enum d when hashable d.name ->
                 R.Enum { d with attrs = with_eq_hash d.attrs }
             | item -> item)
           (Hashtbl.find st.written name)))
    names;
  let rec dedupe = function
    | R.Blank :: (R.Blank :: _ as rest) -> dedupe rest
    | x :: rest -> x :: dedupe rest
    | [] -> []
  in
  dedupe
    (List.concat_map (fun n -> Hashtbl.find st.written n @ [ R.Blank ]) names)

(* The Swift types of the gateway's component schemas, as
   swift/sdk/Sources/Xynolog/Generated/Models.swift declares them: a struct
   with its Codable conformance for an object, an enum for a string
   enumeration or a union, a typealias for a schema that names another, and a
   checked struct for an identifier the identifier kinds name. A schema
   within another is declared by its owner's name and its place in it. *)

module S = Swift_syntax
module D = Definitions

let refuse = D.refuse

(* Names *)

let is_alphanumeric = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' -> true
  | _ -> false

let pieces text =
  String.split_on_char ' '
    (String.map (fun c -> if is_alphanumeric c then c else ' ') text)
  |> List.filter (( <> ) "")

let leading_underscores text =
  let rec count i =
    if i < String.length text && text.[i] = '_' then count (i + 1) else i
  in
  count 0

let is_digit = function '0' .. '9' -> true | _ -> false

(* A member's name: the wire name's words in lowerCamelCase, its leading
   underscores kept. *)
let member_name text =
  let lead = leading_underscores text in
  match pieces (String.sub text lead (String.length text - lead)) with
  | [] -> if lead > 0 then text else "value"
  | first :: rest ->
      let name =
        String.make lead '_' ^ first
        ^ String.concat "" (List.map String.capitalize_ascii rest)
      in
      if lead = 0 && is_digit name.[0] then "value" ^ name else name

(* An enumeration's case: its value's name ([Naming.variant]) in
   lowerCamelCase, as Swift takes it: its leading underscores kept, and
   [value] before a name that is empty or would begin with a digit. *)
let enum_case text =
  let lead = leading_underscores text in
  let name =
    String.make lead '_' ^ String.uncapitalize_ascii (Naming.variant text)
  in
  if lead = 0 && (name = "" || is_digit name.[0]) then "value" ^ name else name

(* Expressions the declarations share *)

let name n = S.Name n
let member base m = S.Member (base, m)
let self_ m = member (name "self") m

let call f args =
  S.Call (f, List.map (fun value -> { S.label = None; value }) args)

let arg label value = { S.label = Some label; value }
let labelled f args = S.Call (f, args)
let type_self t = member (S.Type_value t) "self"
let wire_key wire = call (name "WireKey") [ S.String wire ]
let assign target value = S.Expr (S.Binary (target, "=", value))
let try_ e = S.Try e
let inline_block stmts = { S.layout = S.Inline; stmts }
let line_block stmts = { S.layout = S.Lines; stmts }
let decl ?(doc = []) modifiers body = { S.doc; modifiers; body }
let json_value = S.Named "JSONValue"
let string_type = S.Named "String"
let dictionary_of value = S.Dictionary_of (string_type, value)

let decoder_param =
  {
    S.label = Some "from";
    name = "decoder";
    type_ = S.Any (S.Named "Decoder");
    default = None;
  }

let encoder_param =
  {
    S.label = Some "to";
    name = "encoder";
    type_ = S.Any (S.Named "Encoder");
    default = None;
  }

let decoding_init stmts =
  decl [ "public" ]
    (S.Init
       { params = [ decoder_param ]; throws = true; body = line_block stmts })

let encoding_func layout stmts =
  decl [ "public" ]
    (S.Func
       {
         name = "encode";
         generics = [];
         params = [ encoder_param ];
         throws = true;
         result = None;
         body = { S.layout; stmts };
       })

let codable = [ S.Named "Codable"; S.Named "Sendable" ]

(* A schema's value: compared and hashed by its members, so it can key a
   query's cache. *)
let schema_value = codable @ [ S.Named "Hashable" ]

(* The generator *)

type t = {
  definitions : D.definitions;
  identifiers : string list;
  keys : (string * string) list;
      (** The type a named map's keys are, by its name ([Definitions.map_keys]).
      *)
  written : (string, S.decl option) Hashtbl.t;
      (** Each declaration by its name; [None] while it is being written. *)
}

let create definitions ~identifiers ~keys =
  { definitions; identifiers; keys; written = Hashtbl.create 1024 }

let defined t name = List.mem name t.definitions.names

let known_keywords =
  [
    "$ref";
    "type";
    "properties";
    "required";
    "items";
    "additionalProperties";
    "oneOf";
    "anyOf";
    "allOf";
    "enum";
    "discriminator";
    "$comment";
    "description";
    "title";
    "format";
    "default";
    "examples";
    "minimum";
    "maximum";
    "minLength";
    "maxLength";
    "minItems";
    "maxItems";
    "maxProperties";
    "pattern";
    "uniqueItems";
  ]

let node_of = function
  | D.Node n -> n
  | D.Ref { name = r; _ } ->
      refuse "expected a schema, found a reference to %s" r
  | D.Null -> refuse "expected a schema, found null"
  | D.Bool b -> refuse "expected a schema, found %b" b

let validate = function
  | D.Node n -> (
      match List.filter (fun k -> not (List.mem k known_keywords)) n.keys with
      | [] -> ()
      | unsupported ->
          refuse "unsupported schema keywords: [%s]"
            (String.concat ", "
               (List.map (Printf.sprintf "%S")
                  (List.sort String.compare unsupported))))
  | D.Ref _ | D.Null | D.Bool _ -> ()

(* A schema without its null, and whether it allows null. *)
let nonnull = function
  | D.Node ({ type_ = Some (D.Or_null t); _ } as n) ->
      (D.Node { n with type_ = Some (D.One t) }, true)
  | D.Node { keys = [ "anyOf" ]; any_of = Some [ D.Null; inner ]; _ } ->
      (inner, true)
  | s -> (s, false)

let is_type kind = function
  | D.Node { type_ = Some (D.One k); _ } -> k = kind
  | _ -> false

let single_ref = function
  | D.Node { all_of = Some [ D.Ref { name = r; _ } ]; _ } -> Some r
  | _ -> None

(* A schema that says nothing of a value, only what it is or a note to its
   reader, as JsonSchema.json written in place does, admits any value. *)
let is_empty = function
  | D.Node { keys; _ } ->
      List.for_all
        (fun k -> List.mem k [ "$comment"; "description"; "title" ])
        keys
  | _ -> false

let schema t name = t.definitions.schema name

let rec named t n =
  if not (Hashtbl.mem t.written n) then (
    Hashtbl.replace t.written n None;
    Hashtbl.replace t.written n (Some (declaration t n (schema t n))));
  S.Named n

and inline t ~modifiers owner part s =
  let n = Naming.inline ~defined:(defined t) owner part in
  let declared = declaration_with t ~modifiers n s in
  (match Hashtbl.find_opt t.written n with
  | Some (Some old) when old <> declared ->
      refuse "two different inline schemas named %s" n
  | _ -> ());
  Hashtbl.replace t.written n (Some declared);
  S.Named n

and type_ t owner part raw =
  validate raw;
  let s, _ = nonnull raw in
  match s with
  | D.Ref { name = r; _ } -> named t r
  | _ when is_empty s -> json_value
  | _ when single_ref s <> None -> named t (Option.get (single_ref s))
  | D.Node { one_of = Some _; _ }
  | D.Node { any_of = Some _; _ }
  | D.Node { all_of = Some _; _ } ->
      inline t ~modifiers:[ "public" ] owner part s
  | D.Node n -> (
      match n.type_ with
      | None -> refuse "%s.%s: schema without a type" owner part
      | Some (D.Or_null _) -> refuse "%s.%s: a type and null" owner part
      | Some (D.One kind) -> (
          let enumerated scalar =
            if n.enum = None then S.Named scalar
            else inline t ~modifiers:[ "public" ] owner part s
          in
          match kind with
          | Schema.String -> enumerated "String"
          | Schema.Integer -> enumerated "Int"
          | Schema.Number -> S.Named "Double"
          | Schema.Boolean -> enumerated "Bool"
          | Schema.Null -> refuse "%s.%s: null alone" owner part
          | Schema.Array -> (
              match n.items with
              | None -> refuse "%s.%s: array without items" owner part
              | Some item -> S.Array_of (type_ t owner (part ^ "Item") item))
          | Schema.Object -> (
              match (n.properties, n.additional_properties) with
              | None, Some (D.Bool true) -> dictionary_of json_value
              | None, Some ((D.Ref _ | D.Node _) as value) ->
                  dictionary_of (type_ t owner (part ^ "Value") value)
              | _ -> inline t ~modifiers:[ "public" ] owner part s)))
  | D.Null | D.Bool _ -> refuse "%s.%s: no schema" owner part

and declaration t n raw = declaration_with t ~modifiers:[ "public" ] n raw

and declaration_with t ~modifiers n raw =
  validate raw;
  let s, _ = nonnull raw in
  let alias type_ = decl modifiers (S.Typealias { name = n; type_ }) in
  if List.mem n t.identifiers then identifier n s
  else
    match s with
    | _ when single_ref s <> None -> alias (named t (Option.get (single_ref s)))
    | D.Node { merged = Some m; _ } ->
        plain_declaration t ~modifiers ~owner:(D.owners t.definitions n s) n m
    | s -> plain_declaration t ~modifiers ~owner:(fun _ -> n) n s

(* The declaration of [n], whose schema [s] states no [allOf], each of its
   properties named for the schema [owner] says states it. *)
and plain_declaration t ~modifiers ~owner n s =
  let alias type_ = decl modifiers (S.Typealias { name = n; type_ }) in
  match s with
  | D.Ref { name = r; _ } -> alias (named t r)
  | D.Node { one_of = Some members; _ } | D.Node { any_of = Some members; _ } ->
      union t ~modifiers n members s
  | D.Node { enum = Some values; _ } -> enumeration ~modifiers n values s
  | D.Node node -> (
      match node.type_ with
      | None -> refuse "%s: schema without a type" n
      | Some (D.Or_null _) -> refuse "%s: a type and null" n
      | Some (D.One kind) -> (
          match kind with
          | Schema.Object -> (
              match (node.properties, node.additional_properties) with
              | None, Some (D.Bool true) -> alias (dictionary_of json_value)
              | None, Some ((D.Ref _ | D.Node _) as value) ->
                  let key =
                    match List.assoc_opt n t.keys with
                    | Some key -> S.Named key
                    | None -> string_type
                  in
                  alias (S.Dictionary_of (key, type_ t n "Value" value))
              | _ -> object_ t ~modifiers ~owner n s)
          | Schema.String -> alias string_type
          | Schema.Integer -> alias (S.Named "Int")
          | Schema.Number -> alias (S.Named "Double")
          | Schema.Boolean -> alias (S.Named "Bool")
          | Schema.Null -> refuse "%s: null alone" n
          | Schema.Array -> (
              match node.items with
              | None -> refuse "%s: array without items" n
              | Some item -> alias (S.Array_of (type_ t n "Item" item)))))
  | D.Null | D.Bool _ -> refuse "%s: no schema" n

and object_ t ~modifiers ~owner n s =
  let node = node_of s in
  let properties =
    List.sort
      (fun (a, _) (b, _) -> String.compare a b)
      (Option.value node.properties ~default:[])
  in
  let required = Option.value node.required ~default:[] in
  let open_ = node.additional_properties = Some (D.Bool true) in
  let closed =
    node.additional_properties = Some (D.Bool false)
    || node.max_properties = Some 0
  in
  (match node.additional_properties with
  | Some (D.Ref _ | D.Node _) ->
      refuse "%s: named and typed additional properties are unsupported" n
  | _ -> ());
  let seen = Hashtbl.create 16 in
  let fields =
    List.map
      (fun (wire, raw) ->
        let m = member_name wire in
        if Hashtbl.mem seen m || (open_ && m = "rest") then
          refuse "%s: duplicate or reserved property %s" n m;
        Hashtbl.replace seen m ();
        let is_required = List.mem wire required in
        let nullable = snd (nonnull raw) in
        let constant =
          match raw with
          | D.Node { enum = Some [ value ]; _ } when is_required && not nullable
            -> (
              match value with
              | Schema.String_literal text ->
                  Some (S.Implicit_member (enum_case text))
              | _ -> Some (S.Implicit_member "value"))
          | _ -> None
        in
        let type_ = type_ t (owner wire) wire raw in
        let declared =
          if (not is_required) || nullable then S.Optional type_ else type_
        in
        (wire, m, type_, is_required, constant, declared))
      properties
  in
  let rest_type = dictionary_of json_value in
  let stored =
    List.map
      (fun (_, m, _, _, constant, declared) ->
        decl [ "public" ]
          (S.Property
             {
               var = constant = None;
               name = m;
               type_ = Some declared;
               value = None;
             }))
      fields
    @
    if open_ then
      [
        decl [ "public" ]
          (S.Property
             { var = true; name = "rest"; type_ = Some rest_type; value = None });
      ]
    else []
  in
  let params =
    List.filter_map
      (fun (_, m, _, is_required, constant, declared) ->
        if constant <> None then None
        else
          Some
            {
              S.label = None;
              name = m;
              type_ = declared;
              default = (if is_required then None else Some S.Nil);
            })
      fields
    @
    if open_ then
      [
        {
          S.label = None;
          name = "rest";
          type_ = rest_type;
          default = Some (S.Dictionary (S.Inline, []));
        };
      ]
    else []
  in
  let init =
    decl [ "public" ]
      (S.Init
         {
           params;
           throws = false;
           body =
             line_block
               (List.map
                  (fun (_, m, _, _, constant, _) ->
                    assign (self_ m) (Option.value constant ~default:(name m)))
                  fields
               @ if open_ then [ assign (self_ "rest") (name "rest") ] else []);
         })
  in
  let wires = List.map (fun (wire, _, _, _, _, _) -> wire) fields in
  let names = S.Array (S.Inline, List.map (fun w -> S.String w) wires) in
  let c = name "c" in
  let on_c f args = S.Expr (try_ (labelled (member c f) args)) in
  let unlabelled value = { S.label = None; value } in
  let container keyed =
    labelled
      (member (name keyed) "container")
      [ arg "keyedBy" (type_self (S.Named "WireKey")) ]
  in
  let decoding =
    (if fields <> [] || open_ || closed then
       S.Let
         {
           var = false;
           name = "c";
           type_ = None;
           value = try_ (container "decoder");
         }
     else assign S.Discard (try_ (container "decoder")))
    ::
    (if closed then
       [ on_c "refuseUnknown" [ unlabelled names; arg "in" (S.String n) ] ]
     else [])
    @ List.map
        (fun (wire, m, _, is_required, _, _) ->
          let read = if is_required then "value" else "ifPresent" in
          assign (self_ m) (try_ (call (member c read) [ S.String wire ])))
        fields
    @
    if open_ then
      [
        assign (name "rest")
          (try_ (labelled (member c "rest") [ arg "excluding" names ]));
      ]
    else []
  in
  let encoding =
    (if fields <> [] || open_ then
       S.Let
         { var = true; name = "c"; type_ = None; value = container "encoder" }
     else assign S.Discard (container "encoder"))
    ::
    (if open_ then
       [
         on_c "encode"
           [
             arg "rest" (name "rest");
             arg "excluding" names;
             arg "of" (S.String n);
           ];
       ]
     else [])
    @ List.map
        (fun (wire, m, _, is_required, _, _) ->
          let value = self_ m and as_ = arg "as" (S.String wire) in
          if is_required then on_c "encode" [ unlabelled value; as_ ]
          else on_c "encodeIfPresent" [ unlabelled value; as_ ])
        fields
  in
  decl modifiers
    (S.Struct
       {
         name = n;
         generics = [];
         inherits = schema_value;
         layout = S.Lines;
         members =
           stored
           @ [ init; decoding_init decoding; encoding_func S.Lines encoding ];
       })

and enumeration ~modifiers n values s =
  if values = [] then refuse "%s: empty enumeration" n;
  if is_type Schema.String s then
    let seen = Hashtbl.create 16 in
    let cases =
      List.map
        (fun value ->
          let text =
            match value with
            | Schema.String_literal text -> text
            | _ ->
                refuse "%s: a string enumeration lists a value no string is" n
          in
          let label = enum_case text in
          if Hashtbl.mem seen label then
            refuse "%s: duplicate Swift enum case %s" n label;
          Hashtbl.replace seen label ();
          decl [] (S.Case { name = label; value = S.Raw (S.String text) }))
        values
    in
    decl modifiers
      (S.Enum
         {
           name = n;
           inherits =
             [
               string_type;
               S.Named "Codable";
               S.Named "Sendable";
               S.Named "CaseIterable";
             ];
           layout = S.Lines;
           members = cases;
         })
  else
    let underlying, value =
      match values with
      | [ Schema.Int_literal i ] -> ("Int", S.Int i)
      | [ Schema.Bool_literal b ] -> ("Bool", S.Bool b)
      | [ _ ] -> refuse "%s: unsupported enumeration" n
      | _ -> refuse "%s: unsupported non-string enumeration" n
    in
    let c = name "c" in
    decl modifiers
      (S.Enum
         {
           name = n;
           inherits = schema_value;
           layout = S.Lines;
           members =
             [
               decl [] (S.Case { name = "value"; value = S.Bare });
               decoding_init
                 [
                   S.Let
                     {
                       var = false;
                       name = "c";
                       type_ = None;
                       value =
                         try_
                           (call
                              (member (name "decoder") "singleValueContainer")
                              []);
                     };
                   S.Guard
                     {
                       conditions =
                         [
                           S.Is
                             (try_
                                (S.Binary
                                   ( call (member c "decode")
                                       [ type_self (S.Named underlying) ],
                                     "==",
                                     value )));
                         ];
                       else_ =
                         inline_block
                           [
                             S.Throw
                               (labelled
                                  (member (name "DecodingError")
                                     "dataCorruptedError")
                                  [
                                    arg "in" c;
                                    arg "debugDescription" (S.String n);
                                  ]);
                           ];
                     };
                   assign (name "self") (S.Implicit_member "value");
                 ];
               encoding_func S.Lines
                 [
                   S.Let
                     {
                       var = true;
                       name = "c";
                       type_ = None;
                       value =
                         call
                           (member (name "encoder") "singleValueContainer")
                           [];
                     };
                   S.Expr (try_ (call (member c "encode") [ value ]));
                 ];
             ];
         })

and union t ~modifiers n members s =
  if members = [] then refuse "%s: empty union" n;
  let discriminator = (node_of s).discriminator in
  let labels = Hashtbl.create 8 in
  let property_enum key resolved =
    match resolved with
    | D.Node { properties = Some ps; _ } -> (
        match List.assoc_opt key ps with
        | Some (D.Node { enum = Some values; _ }) -> Some values
        | _ -> None)
    | _ -> None
  in
  let variants =
    List.mapi
      (fun index raw ->
        let resolved =
          D.meant
            (match raw with D.Ref { name = r; _ } -> schema t r | m -> m)
        in
        let tag =
          match discriminator with
          | None -> None
          | Some d -> (
              match property_enum d resolved with
              | Some [ Schema.String_literal text ] -> Some text
              | Some [ _ ] -> refuse "%s: a discriminator no string is" n
              | _ -> None)
        in
        let part =
          match (raw, tag) with
          | D.Ref { name = r; _ }, _ -> r
          | _, Some tag -> Text.pascal tag
          | _ when is_type Schema.String resolved -> "Text"
          | _ when is_type Schema.Array resolved -> "List"
          | _ when is_type Schema.Integer resolved -> "Integer"
          | _ when is_type Schema.Number resolved -> "Number"
          | _ when is_type Schema.Boolean resolved -> "Boolean"
          | _
            when is_type Schema.Object resolved
                 && (node_of resolved).properties = None ->
              "Empty"
          | _ -> (
              let properties =
                List.sort
                  (fun (a, _) (b, _) -> String.compare a b)
                  (match resolved with
                  | D.Node { properties = Some ps; _ } -> ps
                  | _ -> [])
              in
              let constants =
                List.filter_map
                  (fun (_, p) ->
                    match p with
                    | D.Node { enum = Some [ Schema.String_literal text ]; _ }
                      ->
                        Some text
                    | _ -> None)
                  properties
              in
              match (constants, resolved) with
              | tag :: _, _ -> Text.pascal tag
              | [], D.Node { title = Some title; _ } -> Text.pascal title
              | [], _ when is_type Schema.Object resolved -> "Object"
              | [], _ -> refuse "%s: union member %d has no stable name" n index
              )
        in
        let label = String.uncapitalize_ascii part in
        if Hashtbl.mem labels label then
          refuse "%s: two union members named %s" n label;
        Hashtbl.replace labels label ();
        (label, type_ t n part raw, resolved))
      members
  in
  let decoder = name "decoder" in
  let decoding =
    match discriminator with
    | Some d ->
        let c = name "c" in
        let tags = Hashtbl.create 8 in
        [
          S.Let
            {
              var = false;
              name = "c";
              type_ = None;
              value =
                try_
                  (labelled
                     (member decoder "container")
                     [ arg "keyedBy" (type_self (S.Named "WireKey")) ]);
            };
          S.Let
            {
              var = false;
              name = "tag";
              type_ = None;
              value =
                try_
                  (labelled (member c "decode")
                     [
                       { label = None; value = type_self string_type };
                       arg "forKey" (wire_key d);
                     ]);
            };
          S.Switch
            {
              subject = name "tag";
              layout = S.Lines;
              cases =
                List.map
                  (fun (label, type_, resolved) ->
                    let values =
                      match property_enum d resolved with
                      | Some (_ :: _ as values) -> values
                      | _ -> refuse "%s: discriminator missing in %s" n label
                    in
                    {
                      S.patterns =
                        List.map
                          (function
                            | Schema.String_literal text ->
                                if Hashtbl.mem tags text then
                                  refuse "%s: duplicate discriminator %s" n text;
                                Hashtbl.replace tags text ();
                                S.String text
                            | _ -> refuse "%s: a discriminator no string is" n)
                          values;
                      body =
                        [
                          assign (name "self")
                            (call (S.Implicit_member label)
                               [
                                 try_
                                   (labelled (S.Type_value type_)
                                      [ arg "from" decoder ]);
                               ]);
                        ];
                    })
                  variants
                @ [
                    {
                      S.patterns = [];
                      body =
                        [
                          S.Throw
                            (labelled
                               (member (name "DecodingError")
                                  "dataCorruptedError")
                               [
                                 arg "forKey" (wire_key d);
                                 arg "in" c;
                                 arg "debugDescription"
                                   (S.String ("unknown " ^ n ^ " discriminator"));
                               ]);
                        ];
                    };
                  ];
            };
        ]
    | None ->
        List.map
          (fun (label, type_, _) ->
            S.If
              {
                conditions =
                  [
                    S.Let_bound
                      ( "value",
                        S.Try_optional
                          (labelled (S.Type_value type_) [ arg "from" decoder ])
                      );
                  ];
                body =
                  inline_block
                    [
                      assign (name "self")
                        (call (S.Implicit_member label) [ name "value" ]);
                      S.Return None;
                    ];
                else_ = None;
              })
          variants
        @ [
            S.Throw
              (call
                 (member (name "DecodingError") "dataCorrupted")
                 [
                   labelled (S.Implicit_member "init")
                     [
                       arg "codingPath" (member decoder "codingPath");
                       arg "debugDescription"
                         (S.String ("no member of " ^ n ^ " fits"));
                     ];
                 ]);
          ]
  in
  decl
    (modifiers @ [ "indirect" ])
    (S.Enum
       {
         name = n;
         inherits = schema_value;
         layout = S.Lines;
         members =
           List.map
             (fun (label, type_, _) ->
               decl [] (S.Case { name = label; value = S.Associated [ type_ ] }))
             variants
           @ [
               decoding_init decoding;
               encoding_func S.Lines
                 [
                   S.Switch
                     {
                       subject = name "self";
                       layout = S.Lines;
                       cases =
                         List.map
                           (fun (label, _, _) ->
                             {
                               S.patterns =
                                 [
                                   call (S.Implicit_member label)
                                     [ S.Bind "value" ];
                                 ];
                               body =
                                 [
                                   S.Expr
                                     (try_
                                        (labelled
                                           (member (name "value") "encode")
                                           [ arg "to" (name "encoder") ]));
                                 ];
                             })
                           variants;
                     };
                 ];
             ];
       })

(* An identifier kind's checked struct: its pattern is a prefix, then one
   character set repeated. *)
and identifier n s =
  let pattern =
    match s with
    | D.Node { type_ = Some (D.One Schema.String); pattern = Some p; _ } -> p
    | _ -> refuse "%s: identifier without a string pattern" n
  in
  let length = String.length pattern in
  if
    not
      (length >= 2
      && String.starts_with ~prefix:"^" pattern
      && String.ends_with ~suffix:"$" pattern)
  then refuse "%s: identifier pattern is not anchored" n;
  let body = String.sub pattern 1 (length - 2) in
  let start =
    match
      List.find_opt
        (fun i -> body.[i] = '[' || body.[i] = '\\')
        (List.init (String.length body) Fun.id)
    with
    | Some i -> i
    | None -> refuse "%s: unsupported identifier pattern" n
  in
  let prefix = String.sub body 0 start in
  let rest = String.sub body start (String.length body - start) in
  if
    String.exists
      (fun c ->
        String.contains " \t\n\r\x0b\x0c" c || String.contains ".|?*+(){}^$]" c)
      prefix
  then refuse "%s: unsupported identifier prefix" n;
  let value_of = member (name "c") "value" in
  let is code = S.Binary (value_of, "==", S.Int code) in
  let within low high =
    call
      (member (S.Tuple [ S.Binary (S.Int low, "...", S.Int high) ]) "contains")
      [ value_of ]
  in
  let any terms =
    match terms with
    | [] -> refuse "%s: empty identifier character set" n
    | first :: others ->
        List.fold_left
          (fun left right -> S.Binary (left, "||", right))
          first others
  in
  let predicate, times =
    if String.starts_with ~prefix:"\\S" rest then
      ( S.Not
          (S.Tuple
             [
               any
                 [
                   is 9;
                   is 10;
                   is 11;
                   is 12;
                   is 13;
                   is 32;
                   is 160;
                   is 5760;
                   within 8192 8202;
                   is 8232;
                   is 8233;
                   is 8239;
                   is 8287;
                   is 12288;
                   is 65279;
                 ];
             ]),
        String.sub rest 2 (String.length rest - 2) )
    else
      let close =
        match String.index_opt rest ']' with
        | Some i when rest.[0] = '[' -> i
        | _ -> refuse "%s: unsupported identifier character set" n
      in
      let characters =
        List.rev
          (Text.fold_uchars
             (fun acc u -> Uchar.to_int u :: acc)
             []
             (String.sub rest 1 (close - 1)))
        |> Array.of_list
      in
      let count = Array.length characters in
      let rec terms i =
        if i >= count then []
        else
          let c = characters.(i) in
          if List.mem c [ 94; 92; 91 ] then
            refuse "%s: unsupported identifier character set" n
          else if i + 2 < count && characters.(i + 1) = 45 then
            within c characters.(i + 2) :: terms (i + 3)
          else is c :: terms (i + 1)
      in
      ( any (terms 0),
        String.sub rest (close + 1) (String.length rest - close - 1) )
  in
  let low, high =
    if times = "+" then (1, None)
    else if times = "*" then (0, None)
    else if
      String.length times >= 2
      && String.starts_with ~prefix:"{" times
      && String.ends_with ~suffix:"}" times
    then
      let invalid () = refuse "%s: invalid identifier repetition" n in
      let count text =
        match int_of_string_opt text with
        | Some k
          when k >= 0 && text <> ""
               && String.for_all (fun c -> c >= '0' && c <= '9') text ->
            k
        | _ -> invalid ()
      in
      match
        String.split_on_char ',' (String.sub times 1 (String.length times - 2))
      with
      | [ least ] ->
          let k = count least in
          (k, Some k)
      | [ least; "" ] -> (count least, None)
      | [ least; most ] ->
          let low = count least and high = count most in
          if high < low then invalid () else (low, Some high)
      | _ -> invalid ()
    else refuse "%s: unsupported identifier repetition" n
  in
  let scalars_count = member (name "scalars") "count" in
  let count_check =
    let least = S.Binary (scalars_count, ">=", S.Int low) in
    match high with
    | None -> least
    | Some high ->
        S.Binary (least, "&&", S.Binary (scalars_count, "<=", S.Int high))
  in
  let value = name "value" in
  let invalid =
    S.Throw
      (labelled (name "InvalidIdentifier")
         [
           arg "kind" (S.String n);
           arg "pattern" (S.String pattern);
           arg "value" value;
         ])
  in
  let unicode_scalars e = member e "unicodeScalars" in
  let self_type = S.Named "Self" in
  let c = name "c" in
  let value_param =
    { S.label = Some "_"; name = "value"; type_ = string_type; default = None }
  in
  decl [ "public" ]
    (S.Struct
       {
         name = n;
         generics = [];
         inherits = [ S.Named "Identifier" ];
         layout = S.Lines;
         members =
           [
             decl [ "public" ]
               (S.Property
                  {
                    var = false;
                    name = "value";
                    type_ = Some string_type;
                    value = None;
                  });
             decl [ "public" ]
               (S.Computed
                  {
                    name = "description";
                    type_ = string_type;
                    body = inline_block [ S.Expr value ];
                  });
             decl [ "public" ]
               (S.Init
                  {
                    params = [ value_param ];
                    throws = true;
                    body =
                      line_block
                        [
                          S.Guard
                            {
                              conditions =
                                [
                                  S.Is
                                    (labelled
                                       (member (unicode_scalars value) "starts")
                                       [
                                         arg "with"
                                           (unicode_scalars (S.String prefix));
                                       ]);
                                ];
                              else_ = inline_block [ invalid ];
                            };
                          S.Let
                            {
                              var = false;
                              name = "scalars";
                              type_ = None;
                              value =
                                call
                                  (member (unicode_scalars value) "dropFirst")
                                  [ S.Int (Text.length prefix) ];
                            };
                          S.Guard
                            {
                              conditions =
                                [
                                  S.Is count_check;
                                  S.Is
                                    (call
                                       (member (name "scalars") "allSatisfy")
                                       [
                                         S.Closure
                                           {
                                             params = [ "c" ];
                                             layout = S.Inline;
                                             body = [ S.Expr predicate ];
                                           };
                                       ]);
                                ];
                              else_ = inline_block [ invalid ];
                            };
                          assign (self_ "value") value;
                        ];
                  });
             decl [ "public"; "static" ]
               (S.Func
                  {
                    name = "parse";
                    generics = [];
                    params = [ value_param ];
                    throws = false;
                    result = Some (S.Optional self_type);
                    body =
                      inline_block
                        [
                          S.Expr (S.Try_optional (call (name "Self") [ value ]));
                        ];
                  });
             decl [ "public"; "static" ]
               (S.Func
                  {
                    name = "==";
                    generics = [];
                    params =
                      [
                        {
                          S.label = None;
                          name = "lhs";
                          type_ = self_type;
                          default = None;
                        };
                        {
                          S.label = None;
                          name = "rhs";
                          type_ = self_type;
                          default = None;
                        };
                      ];
                    throws = false;
                    result = Some (S.Named "Bool");
                    body =
                      inline_block
                        [
                          S.Expr
                            (call
                               (member
                                  (member (member (name "lhs") "value") "utf8")
                                  "elementsEqual")
                               [ member (member (name "rhs") "value") "utf8" ]);
                        ];
                  });
             decl [ "public" ]
               (S.Func
                  {
                    name = "hash";
                    generics = [];
                    params =
                      [
                        {
                          S.label = Some "into";
                          name = "hasher";
                          type_ = S.Inout (S.Named "Hasher");
                          default = None;
                        };
                      ];
                    throws = false;
                    result = None;
                    body =
                      inline_block
                        [
                          S.For
                            {
                              names = [ "byte" ];
                              sequence = member value "utf8";
                              where_ = None;
                              body =
                                inline_block
                                  [
                                    S.Expr
                                      (call
                                         (member (name "hasher") "combine")
                                         [ name "byte" ]);
                                  ];
                            };
                        ];
                  });
             decoding_init
               [
                 S.Let
                   {
                     var = false;
                     name = "c";
                     type_ = None;
                     value =
                       try_
                         (call
                            (member (name "decoder") "singleValueContainer")
                            []);
                   };
                 S.Let
                   {
                     var = false;
                     name = "value";
                     type_ = None;
                     value =
                       try_ (call (member c "decode") [ type_self string_type ]);
                   };
                 S.Do_catch
                   ( inline_block
                       [ S.Expr (try_ (call (self_ "init") [ value ])) ],
                     inline_block
                       [
                         S.Throw
                           (labelled
                              (member (name "DecodingError")
                                 "dataCorruptedError")
                              [
                                arg "in" c;
                                arg "debugDescription"
                                  (labelled (name "String")
                                     [ arg "describing" (name "error") ]);
                              ]);
                       ] );
               ];
             encoding_func S.Inline
               [
                 S.Let
                   {
                     var = true;
                     name = "c";
                     type_ = None;
                     value =
                       call (member (name "encoder") "singleValueContainer") [];
                   };
                 S.Expr (try_ (call (member c "encode") [ value ]));
               ];
           ];
       })

(* Every declaration written, by its name. *)
let declarations t =
  Hashtbl.fold
    (fun n d acc ->
      match d with
      | Some d -> (n, d) :: acc
      | None -> refuse "%s is still being written" n)
    t.written []
  |> List.sort (fun (a, _) (b, _) -> String.compare a b)
  |> List.map snd

let generate t = List.iter (fun n -> ignore (named t n)) t.definitions.names

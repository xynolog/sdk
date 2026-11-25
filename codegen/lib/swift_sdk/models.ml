(* The Swift types of Protocol's schemas as [Typing] reads them, as
   swift/sdk/Sources/Xynolog/Generated/Models.swift declares them: a struct
   with its Codable conformance for an object, an enum for a string
   enumeration or a union, a typealias for a schema that names another, and a
   checked struct for an identifier the identifier kinds name. A union
   states what each member admits ([Typing]'s signatures), and a value is
   decoded as the one member that admits it (UnionSignature.swift). A schema
   within another is declared by the name [Typing] gives it. Where Swift
   reads otherwise than [Typing], [Deviations] names it. *)

module S = Swift_syntax
module D = Definitions
module T = Typing

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
  names : string list;
      (** Every schema of the generation, by its name, in their order. *)
  find : string -> T.declaration;
  place : T.place -> D.t -> T.ty;
      (** The type of a schema a writer of tables states at a place. *)
  defined : string -> bool;
  schema : string -> D.t;
      (** A schema as the writer of tables reads it, by its name. *)
  written : (string, S.decl option) Hashtbl.t;
      (** Each declaration by its name; [None] while it is being written. *)
}

(* The declarations of [typings], the first of which types what a writer of
   tables states, and [schema], which it reads. *)
let create (typings : T.t list) ~schema =
  match typings with
  | [] -> refuse "no schemas to declare"
  | first :: _ ->
      {
        names =
          List.sort String.compare
            (List.concat_map (fun (t : T.t) -> t.names) typings);
        find =
          (fun n ->
            match
              List.find_opt (fun (t : T.t) -> List.mem n t.names) typings
            with
            | Some t -> t.find n
            | None -> refuse "the spec declares no schema %s" n);
        place = first.place;
        defined = first.defined;
        schema;
        written = Hashtbl.create 1024;
      }

(* The one schema an [allOf] names, which Swift holds as that schema, what
   is stated beside it read past ([Deviations]). *)
let single_ref = function
  | Some { T.parts = [ T.Named r ]; _ } -> Some r
  | _ -> None

let schema t n = t.schema n

let rec named t n =
  if not (Hashtbl.mem t.written n) then (
    Hashtbl.replace t.written n None;
    let d = t.find n in
    Hashtbl.replace t.written n
      (Some (declaration t ~modifiers:[ "public" ] n d.form d.composition)));
  S.Named n

(* A type of its own written in place, declared by the name [Typing] gives
   it. *)
and declare t ~modifiers (i : T.inline) =
  let declared = declaration t ~modifiers i.name i.form i.composition in
  (match Hashtbl.find_opt t.written i.name with
  | Some (Some old) when old <> declared ->
      refuse "two different inline schemas named %s" i.name
  | _ -> ());
  Hashtbl.replace t.written i.name (Some declared);
  S.Named i.name

(* The Swift type of a value of [ty], not null. *)
and type_of t what (ty : T.ty) =
  match ty with
  | T.Named n -> named t n
  | T.Any -> json_value
  | T.Nullable inner -> type_of t what inner
  | T.Inline i -> in_place t what i
  | T.Scalar (T.Text _) -> string_type
  | T.Scalar (T.Integer _) -> S.Named "Int"
  | T.Scalar T.Number -> S.Named "Double"
  | T.Scalar T.Boolean -> S.Named "Bool"
  | T.List (Some item) -> S.Array_of (type_of t what item)
  | T.List None -> refuse "%s: array without items" what
  | T.Null -> refuse "%s: null alone" what
  | T.Nothing -> refuse "%s: no schema" what

and in_place t what (i : T.inline) =
  match (i.form, single_ref i.composition) with
  | _, Some r -> named t r
  | T.Enum { base = Some T.Number; _ }, None -> S.Named "Double"
  | T.Empty { rest = T.Open; _ }, None -> dictionary_of json_value
  | T.Map { key; value }, None -> map_of t what key value
  | T.Union u, None when Deviations.text_union u -> string_type
  | _, None -> declare t ~modifiers:[ "public" ] i

and map_of t what key value =
  S.Dictionary_of
    ( (match key with Some key -> S.Named key | None -> string_type),
      type_of t what value )

(* A schema the writer of tables states at [owner]'s [part], as its Swift
   type. *)
and type_ t owner part raw =
  type_of t (owner ^ "." ^ part) (t.place { owner; part } raw)

(* A schema the writer of tables states, declared as [owner]'s [part]
   ([Naming.inline] among every schema of the generation). *)
and inline t ~modifiers owner part raw =
  let n =
    Naming.inline
      ~defined:(fun n -> List.mem n t.names || t.defined n)
      owner part
  in
  match t.place { owner = ""; part = n } raw with
  | T.Inline i when i.name = n -> declare t ~modifiers i
  | _ -> refuse "%s%s is no type of its own" owner part

and declaration t ~modifiers n (form : T.form) composition =
  let alias type_ = decl modifiers (S.Typealias { name = n; type_ }) in
  match (form, single_ref composition) with
  | T.Identifier { pattern }, _ -> identifier n pattern
  | _, Some r -> alias (named t r)
  | T.Union u, None when Deviations.text_union u -> alias string_type
  | T.Union u, None -> union t ~modifiers n u
  | T.Enum { base; values }, None ->
      enumeration ~modifiers n values
        ~text:(match base with Some (T.Text _) -> true | _ -> false)
  | T.Empty { rest = T.Open; _ }, None -> alias (dictionary_of json_value)
  | T.Map { key; value }, None -> alias (map_of t n key value)
  | T.Alias ty, None -> alias (type_of t n ty)
  | T.Empty { rest; _ }, None ->
      object_ t ~modifiers n [] ~rest ~closed:(T.holds_none form)
  | T.Record { members; rest }, None ->
      object_ t ~modifiers n members ~rest ~closed:(rest = T.Closed)
  | T.Json, None -> refuse "%s: schema without a type" n

and object_ t ~modifiers n (members : T.member list) ~rest ~closed =
  let open_ =
    match rest with
    | T.Open -> true
    | T.Closed | T.Unstated -> false
    | T.Of _ ->
        refuse "%s: named and typed additional properties are unsupported" n
  in
  let seen = Hashtbl.create 16 in
  let fields =
    List.map
      (fun (member : T.member) ->
        let wire = member.wire in
        let m = member_name wire in
        if Hashtbl.mem seen m || (open_ && m = "rest") then
          refuse "%s: duplicate or reserved property %s" n m;
        Hashtbl.replace seen m ();
        let is_required = member.required in
        let nullable =
          match member.ty with T.Nullable _ -> true | _ -> false
        in
        let constant =
          match member.fixed with
          | Some value when is_required && not nullable -> (
              match value with
              | Schema.String_literal text ->
                  Some (S.Implicit_member (enum_case text))
              | _ -> Some (S.Implicit_member "value"))
          | _ -> None
        in
        let type_ = type_of t (n ^ "." ^ wire) member.ty in
        let declared =
          if (not is_required) || nullable then S.Optional type_ else type_
        in
        (wire, m, type_, is_required, constant, declared))
      members
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

(* An enumeration of [values]: of text when [text], else of one integer or
   boolean. *)
and enumeration ~modifiers n values ~text =
  if values = [] then refuse "%s: empty enumeration" n;
  if text then
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

and union t ~modifiers n (u : T.union) =
  if u.branches = [] then refuse "%s: empty union" n;
  let labels = Hashtbl.create 8 in
  let variants =
    List.map
      (fun (b : T.branch) ->
        let type_ = type_of t (n ^ "." ^ b.variant) b.ty in
        let label = String.uncapitalize_ascii b.variant in
        if Hashtbl.mem labels label then
          refuse "%s: two union members named %s" n label;
        Hashtbl.replace labels label ();
        (label, type_))
      u.branches
  in
  (match T.apart_by_pattern_only u with
  | Some (a, b) ->
      refuse
        "%s: its members %s and %s are told apart only by a pattern, which the \
         Swift SDK does not read"
        n a b
  | None -> ());
  let words ws = S.Array (S.Inline, List.map (fun w -> S.String w) ws) in
  let literal (l : Schema.literal) =
    match l with
    | Schema.String_literal s -> call (S.Implicit_member "text") [ S.String s ]
    | Schema.Int_literal i -> call (S.Implicit_member "integer") [ S.Int i ]
    | Schema.Bool_literal b -> call (S.Implicit_member "boolean") [ S.Bool b ]
  in
  let literals ls = S.Array (S.Inline, List.map literal ls) in
  let stated f = function Some v -> f v | None -> S.Nil in
  let signature (s : T.signature) =
    let kind =
      match s.kind with
      | T.Text_kind -> "text"
      | T.Integer_kind -> "integer"
      | T.Number_kind -> "number"
      | T.Boolean_kind -> "boolean"
      | T.List_kind -> "list"
      | T.Object_kind -> "object"
      | T.Null_kind -> "null"
      | T.Any_kind -> "any"
    in
    labelled (name "UnionSignature")
      [
        arg "kind" (S.Implicit_member kind);
        arg "required" (words s.required);
        arg "allowed" (stated words s.allowed);
        arg "fixed"
          (S.Array
             ( S.Inline,
               List.map
                 (fun (p, vs) ->
                   labelled (S.Implicit_member "init")
                     [ arg "property" (S.String p); arg "values" (literals vs) ])
                 s.fixed ));
        arg "values" (stated literals s.values);
      ]
  in
  let members =
    decl [ "static" ]
      (S.Property
         {
           var = false;
           name = "members";
           type_ = Some (S.Array_of (S.Array_of (S.Named "UnionSignature")));
           value =
             Some
               (S.Array
                  ( S.Lines,
                    List.map
                      (fun (b : T.branch) ->
                        S.Array (S.Lines, List.map signature b.signature))
                      u.branches ));
         })
  in
  let decoding =
    [
      assign (name "self")
        (try_
           (labelled
              (member (name "UnionSignature") "decode")
              [
                arg "from" (name "decoder");
                arg "union" (S.String n);
                arg "members" (member (name "Self") "members");
                arg "variants"
                  (S.Array
                     ( S.Lines,
                       List.map
                         (fun (label, type_) ->
                           S.Tuple
                             [
                               S.String label;
                               S.Closure
                                 {
                                   params = [ "decoder" ];
                                   layout = S.Inline;
                                   body =
                                     [
                                       S.Expr
                                         (try_
                                            (call
                                               (member (name "Self") label)
                                               [
                                                 labelled (S.Type_value type_)
                                                   [
                                                     arg "from" (name "decoder");
                                                   ];
                                               ]));
                                     ];
                                 };
                             ])
                         variants ));
              ]));
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
             (fun (label, type_) ->
               decl [] (S.Case { name = label; value = S.Associated [ type_ ] }))
             variants
           @ [
               members;
               decoding_init decoding;
               encoding_func S.Lines
                 [
                   S.Switch
                     {
                       subject = name "self";
                       layout = S.Lines;
                       cases =
                         List.map
                           (fun (label, _) ->
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
and identifier n pattern =
  let pattern =
    match pattern with
    | Some p -> p
    | None -> refuse "%s: identifier without a string pattern" n
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

let generate t = List.iter (fun n -> ignore (named t n)) t.names

(* What each component schema requires of a value: the kinds of value it may
   be, the values and the form it may take, the members it must and may carry
   and what each member must be. Every SDK holds a reply to this table before
   it reads it, so each finds the same first fault in it, names it the same
   way, and refuses it.

   The table states whatever the schemas state that some SDK's decoding
   refuses, so a payload the table passes is one every SDK decodes. Two things
   a schema states no SDK's decoding refuses, and the table leaves them out: a
   [format] (a date-time or a URI is text in every SDK) and [uniqueItems]. A
   keyword the table does not know how to state is refused, so the table
   cannot fall behind the schemas unseen.

   One list a schema states the table states otherwise: the one CommandError's
   [code] is one of, which is its [recognized] codes and no [enum]. codes.json
   reads a failure whose code the list does not name as its unrecognized
   failure, one that states none: so a reader reads such a code as absent, and
   a writer is held to the list.

   A KIND is one of object, array, string, integer, number, boolean, null. An
   integer is a number with no fractional part, as JSON Schema has it, and a
   number is any number, an integer among them.

   A SHAPE is what a value must be, and each of its parts holds where it
   applies:

   - [ref]: the value is the component of that name;
   - [kinds]: the kinds the value may be; a shape that states none allows any;
   - [recognized]: of an object's member, the texts it is read as. A reader
     reads a member holding any other text as absent; a writer holds the
     member to these as to an [enum];
   - [enum]: the value is one of these, a number by its value (1.0 is 1);
   - [pattern]: a text is a series of terms. A step is a set of code points
     ([of], ranges from and to, both included) the text's next code points
     are in; a group is alternatives ([either]), each a series of terms, the
     text's next code points being one of them. Each is repeated at least
     [min] times and at most [max] (no [max]: any number), a repetition of a
     group past its [min] taking at least one code point. A text is of the
     pattern when some way of reading it so takes all of it. It is the
     schema's pattern, searched for in the whole text as ECMA-262 reads it,
     an end the pattern does not anchor a step of any code points, spelled
     out so that no SDK reads it by a regular-expression engine of its own;
   - [minLength], [maxLength]: the fewest and most code points of a text;
   - [minimum], [maximum]: the least and greatest a number is, each allowed;
   - [minItems], [maxItems]: the fewest and most items of an array;
   - [required]: an object carries each of these members, holding null only
     where its shape in [members] allows null;
   - [members]: what an object's member must be, where the object has it and
     it is not null, by the order of the names' code points;
   - [closed]: an object carries no member but these;
   - [items]: what each item of an array must be;
   - [values]: what each value of a map must be;
   - [oneOf]: the value is one of these variants, and a [discriminator] the
     value states names the one it is, by its place;
   - [allOf]: the value is what each of these is;
   - [notAll]: sets of members an object does not carry all of: one that
     carries every member of a set, whatever each holds, is malformed. It is
     what a schema's [not] states of a [required] or an [anyOf] of them, the
     one [not] the table states;
   - [minMembers]: the fewest members an object carries;
   - [names]: what each of an object's members' names must be, a name that is
     not being a fault of that member.

   A part that can be wrong in no way is left out, and so is a union none of
   whose variants can be: what is left is what a value can be wrong in. A
   component that can be wrong in no way is the empty shape.

   A value's first fault is found in this order. Its [kinds], its [enum] and
   its bounds ([pattern], [minLength] to [maxItems], [minMembers]): the value
   is malformed. Of an object: each member [required] names, in its order,
   that it lacks; each member [members] names, by name, that it holds; each
   member [closed] does not name, by name, malformed; each member whose name
   is not of [names], by name, malformed; each set of [notAll], in its order,
   that it carries all of, the object malformed. Then [values], each by name;
   [items], each by place; [oneOf]; and [allOf], each in its order. A reader
   that meets a part it does not know refuses the table. *)

type kind = Object | Array | String | Integer | Number | Boolean | Null

let all_kinds = [ Object; Array; String; Integer; Number; Boolean; Null ]

let kind_name = function
  | Object -> "object"
  | Array -> "array"
  | String -> "string"
  | Integer -> "integer"
  | Number -> "number"
  | Boolean -> "boolean"
  | Null -> "null"

type step = { of_ : (int * int) list; min : int; max : int option }

type term = Step of step | Group of group
and group = { either : term list list; min : int; max : int option }

type discriminator = { property : string; mapping : (string * int) list }

type shape = Ref of string | Shape of body

and body = {
  kinds : kind list option;
  recognized : string list option;
  enum : Schema.literal list option;
  pattern : term list option;
  min_length : int option;
  max_length : int option;
  minimum : float option;
  maximum : float option;
  min_items : int option;
  max_items : int option;
  required : string list option;
  members : (string * shape) list;
  closed : string list option;
  items : shape option;
  values : shape option;
  one_of : shape list;
  discriminator : discriminator option;
  all_of : shape list;
  not_all : string list list;
  min_members : int option;
  names : shape option;
}

let empty =
  {
    kinds = None;
    recognized = None;
    enum = None;
    pattern = None;
    min_length = None;
    max_length = None;
    minimum = None;
    maximum = None;
    min_items = None;
    max_items = None;
    required = None;
    members = [];
    closed = None;
    items = None;
    values = None;
    one_of = [];
    discriminator = None;
    all_of = [];
    not_all = [];
    min_members = None;
    names = None;
  }

(* ── Patterns ─────────────────────────────────────────────────────────── *)

let last = 0x10FFFF

(* ECMA-262's white space and line terminators: [\s]. *)
let white_space =
  [
    (0x09, 0x0D);
    (0x20, 0x20);
    (0xA0, 0xA0);
    (0x1680, 0x1680);
    (0x2000, 0x200A);
    (0x2028, 0x2029);
    (0x202F, 0x202F);
    (0x205F, 0x205F);
    (0x3000, 0x3000);
    (0xFEFF, 0xFEFF);
  ]

(* ECMA-262's line terminators, which [.] is none of. *)
let line_terminators = [ (0x0A, 0x0A); (0x0D, 0x0D); (0x2028, 0x2029) ]
let digits = [ (0x30, 0x39) ]
let word = [ (0x30, 0x39); (0x41, 0x5A); (0x5F, 0x5F); (0x61, 0x7A) ]

(* [ranges] sorted, with those that touch or overlap made one. *)
let merged ranges =
  List.fold_left
    (fun out (from, to_) ->
      match out with
      | (first, upto) :: rest when from <= upto + 1 ->
          (first, max upto to_) :: rest
      | _ -> (from, to_) :: out)
    [] (List.sort compare ranges)
  |> List.rev

(* Every code point [ranges] leave out. *)
let complement ranges =
  let out, next =
    List.fold_left
      (fun (out, next) (from, to_) ->
        ((if from > next then (next, from - 1) :: out else out), to_ + 1))
      ([], 0) (merged ranges)
  in
  List.rev (if next <= last then (next, last) :: out else out)

let code_points text =
  let rec go acc i =
    if i >= String.length text then Array.of_list (List.rev acc)
    else
      let decoded = String.get_utf_8_uchar text i in
      go
        (Uchar.to_int (Uchar.utf_decode_uchar decoded) :: acc)
        (i + Uchar.utf_decode_length decoded)
  in
  go [] 0

exception Unspellable

(* A pattern as the terms a text of its form is: a series of steps and
   groups. A step is a single character, a set ([[...]], [[^...]], which may
   hold [\s], [\S], [\d], [\D], [\w] and [\W]), [.],
   [\s], [\S], [\d], [\D], [\w] or [\W]; a group, [(...)], is alternatives
   ([|]), each a series of its own; and each is with no quantifier or with
   [?], [*], [+], [{n}], [{n,}] or [{n,m}]. The pattern's top is a group of
   one repetition when it states alternatives there. Any other is
   unspellable. *)
let terms_of pattern =
  let n = String.length pattern in
  let starts = n > 0 && pattern.[0] = '^' in
  let ends =
    (n > if starts then 1 else 0)
    && pattern.[n - 1] = '$'
    && not (n >= 2 && pattern.[n - 2] = '\\')
  in
  let from = if starts then 1 else 0 in
  let body =
    code_points (String.sub pattern from (n - from - if ends then 1 else 0))
  in
  let length = Array.length body in
  let at i = if i < length then Some body.(i) else None in
  let is c i = at i = Some (Char.code c) in
  let among chars i =
    match at i with
    | Some c -> c < 128 && String.contains chars (Char.chr c)
    | None -> false
  in
  let single c = [ (c, c) ] in
  let escaped i =
    match at i with
    | Some c when c = Char.code 's' -> white_space
    | Some c when c = Char.code 'S' -> complement white_space
    | Some c when c = Char.code 'd' -> digits
    | Some c when c = Char.code 'D' -> complement digits
    | Some c when c = Char.code 'w' -> word
    | Some c when c = Char.code 'W' -> complement word
    | Some c when among "\\^$.|?*+()[]{}/:-" i -> single c
    | _ -> raise Unspellable
  in
  let rec set i ranges =
    match at i with
    | None -> raise Unspellable
    | Some c when c = Char.code ']' ->
        if ranges = [] then raise Unspellable else (i + 1, ranges)
    | Some c when c = Char.code '[' -> raise Unspellable
    | Some c when c = Char.code '\\' && among "sSdDwW" (i + 1) ->
        set (i + 2) (escaped (i + 1) @ ranges)
    | Some c ->
        let i, from =
          if c = Char.code '\\' then
            if among "\\][^-." (i + 1) then (i + 1, body.(i + 1))
            else raise Unspellable
          else (i, c)
        in
        if is '-' (i + 1) && at (i + 2) <> None && not (is ']' (i + 2)) then (
          let to_ = body.(i + 2) in
          if is '\\' (i + 2) || is '[' (i + 2) || to_ < from then
            raise Unspellable;
          set (i + 3) ((from, to_) :: ranges))
        else set (i + 1) ((from, from) :: ranges)
  in
  let number text =
    if text <> "" && String.for_all (fun c -> c >= '0' && c <= '9') text then
      int_of_string text
    else raise Unspellable
  in
  let quantifier i =
    match at i with
    | Some c when c = Char.code '?' -> (i + 1, 0, Some 1)
    | Some c when c = Char.code '*' -> (i + 1, 0, None)
    | Some c when c = Char.code '+' -> (i + 1, 1, None)
    | Some c when c = Char.code '{' ->
        let rec close j =
          match at j with
          | None -> raise Unspellable
          | Some c when c = Char.code '}' -> j
          | Some c when c < 128 -> close (j + 1)
          | Some _ -> raise Unspellable
        in
        let j = close (i + 1) in
        let inside =
          String.init (j - i - 1) (fun k -> Char.chr body.(i + 1 + k))
        in
        let min, max =
          match String.index_opt inside ',' with
          | None ->
              let n = number inside in
              (n, Some n)
          | Some k ->
              let upper =
                String.sub inside (k + 1) (String.length inside - k - 1)
              in
              ( number (String.sub inside 0 k),
                if upper = "" then None else Some (number upper) )
        in
        (j + 1, min, max)
    | _ -> (i, 1, Some 1)
  in
  (* The series that starts at [i], up to the [|] or [)] that ends it, and
     where that is. *)
  let rec series i acc =
    if i >= length || is '|' i || is ')' i then (i, List.rev acc)
    else
      let i, term =
        match body.(i) with
        | c when c = Char.code '(' ->
            if is '?' (i + 1) then raise Unspellable;
            let i, either = alternatives (i + 1) [] in
            if not (is ')' i) then raise Unspellable;
            let i, min, max = quantifier (i + 1) in
            (i, Group { either; min; max })
        | c ->
            let i, of_ =
              match c with
              | c when c = Char.code '[' ->
                  let negated = is '^' (i + 1) in
                  let i, ranges = set (if negated then i + 2 else i + 1) [] in
                  (i, if negated then complement ranges else merged ranges)
              | c when c = Char.code '.' -> (i + 1, complement line_terminators)
              | c when c = Char.code '\\' -> (i + 2, escaped (i + 1))
              | _ when among "^$?*+{}]" i -> raise Unspellable
              | c -> (i + 1, single c)
            in
            let i, min, max = quantifier i in
            (i, Step { of_; min; max })
      in
      if among "?*+{" i then raise Unspellable;
      series i (term :: acc)
  and alternatives i acc =
    let i, one = series i [] in
    if is '|' i then alternatives (i + 1) (one :: acc)
    else (i, List.rev (one :: acc))
  in
  let i, either = alternatives 0 [] in
  if i < length then raise Unspellable;
  (* A pattern is searched for anywhere in a text: an end it does not anchor
     is a step of any code points, as many as there are. *)
  let anywhere = Step { of_ = [ (0, last) ]; min = 0; max = None } in
  let terms =
    match either with
    | [ one ] -> one
    | either -> [ Group { either; min = 1; max = Some 1 } ]
  in
  (if starts then [] else [ anywhere ])
  @ terms
  @ if ends then [] else [ anywhere ]

(* ── Kinds ────────────────────────────────────────────────────────────── *)

(* Whether [kinds] allow a value of [kind]: a number allows an integer. *)
let allows kinds kind =
  List.mem kind kinds || (kind = Integer && List.mem Number kinds)

let union a b = List.filter (fun k -> List.mem k a || List.mem k b) all_kinds

(* [kinds] in the table's order, without an integer a number already allows. *)
let ordered kinds =
  List.filter
    (fun k -> List.mem k kinds && not (k = Integer && List.mem Number kinds))
    all_kinds

let any_kind kinds = List.for_all (allows kinds) all_kinds

let kind_of_type : Schema.type_name -> kind = function
  | String -> String
  | Object -> Object
  | Integer -> Integer
  | Array -> Array
  | Boolean -> Boolean
  | Number -> Number
  | Null -> Null

let kind_of_literal : Schema.literal -> kind = function
  | String_literal _ -> String
  | Int_literal _ -> Integer
  | Bool_literal _ -> Boolean

(* ── The derivation ───────────────────────────────────────────────────── *)

exception Refused of Decode.error

let refuse file pointer fmt =
  Printf.ksprintf
    (fun message -> raise (Refused { Decode.file; pointer; message }))
    fmt

(* A JSON Pointer's token for a member's name (RFC 6901). *)
let token name =
  String.concat "~1"
    (List.map
       (fun part -> String.concat "~0" (String.split_on_char '~' part))
       (String.split_on_char '/' name))

(* A schema as it says null ([Null_form]): beside a single type, null is one
   more kind the value may be; anywhere else the schema is a union of null and
   what it is beside null. *)
type 'a view =
  | Plain of { schema : 'a Schema.layer; null : bool }
  | Or_null of 'a Schema.layer

let view file at (schema : (Schema.t * _) Schema.layer) =
  match Null_form.without_null fst schema with
  | Error message -> refuse file at "%s" message
  | Ok None -> Plain { schema; null = false }
  | Ok (Some beside) -> (
      match beside.type_ with
      | Some [ _ ] -> Plain { schema = beside; null = true }
      | _ -> Or_null beside)

let variants file at (schema : _ Schema.layer) =
  match (schema.one_of, schema.any_of) with
  | Some _, Some _ -> refuse file at "states both oneOf and anyOf"
  | Some variants, None -> Some ("oneOf", variants)
  | None, Some variants -> Some ("anyOf", variants)
  | None, None -> None

(* What a schema reads as, given its file and where in that it is: the kinds
   of value it allows, whether it is an object closed to members it does not
   name, and its shape. *)
type reading = {
  kinds_of : string -> string -> kind list;
  closed_schema : string -> string -> bool;
  shape_of : string -> string -> shape;
}

type t = {
  shapes : (string * shape) list;
  inline :
    file:string -> pointer:string -> Schema.t -> (shape, Decode.error) result;
}

(* The sets of members a [not] says an object does not carry all of: a
   [required], or an [anyOf] of them. Any other [not] is refused: the table
   holds a [required] member to more than being there (null only where its
   shape allows null), so a [not] of a schema in general would allow what the
   schema refuses. *)
let member_sets file at (negated : Schema.t) =
  let only_required at (s : Schema.t) =
    match s with
    | Schema.Schema ({ required = Some (_ :: _ as names); _ } as l)
      when Schema.keywords l = [ "required" ] ->
        names
    | _ ->
        refuse file at
          "is a not of what is no list of required members, which the table \
           does not know how to state"
  in
  match negated with
  | Schema.Schema ({ any_of = Some parts; _ } as l)
    when Schema.keywords l = [ "anyOf" ] ->
      List.mapi
        (fun i part -> only_required (Printf.sprintf "%s/anyOf/%d" at i) part)
        parts
  | s -> [ only_required at s ]

(* [components] are each component's name, its file and its schema.
   [unrecognized] is the failure codes.json reads an unrecognized code as. *)
let derive ~ids ~unrecognized components =
  try
    let command_error =
      match
        List.find_opt (fun (name, _, _) -> name = "CommandError") components
      with
      | Some (_, file, Schema.Schema schema) -> (file, schema)
      | Some (_, file, Schema.Boolean_schema _) ->
          refuse file "" "is no schema with a code"
      | None ->
          refuse "openapi.json" "/components/schemas" "names no CommandError"
    in
    (* CommandError's code is read by its recognized codes, and no enum. *)
    let recognized, components =
      let file, schema = command_error in
      if List.mem "code" (Option.value schema.required ~default:[]) then
        refuse file "/required"
          "requires code, and codes.json reads a code its enum does not name \
           as %s, as one that states none"
          unrecognized;
      let code =
        match Option.bind schema.properties (List.assoc_opt "code") with
        | Some (Schema.Schema code) -> code
        | _ -> refuse file "/properties" "describes no code of its own"
      in
      let codes =
        match code.enum with
        | Some codes ->
            List.map
              (function
                | Schema.String_literal code -> code
                | _ ->
                    refuse file "/properties/code/enum"
                      "states a code that is no text")
              codes
        | None ->
            refuse file "/properties/code"
              "is one of no enum, and codes.json reads a code the enum does \
               not name as %s"
              unrecognized
      in
      let properties =
        List.map
          (fun (name, property) ->
            if name = "code" then (name, Schema.Schema { code with enum = None })
            else (name, property))
          (Option.get schema.properties)
      in
      ( codes,
        List.map
          (fun (name, file, s) ->
            if name = "CommandError" then
              ( name,
                file,
                Schema.Schema { schema with properties = Some properties } )
            else (name, file, s))
          components )
    in
    let file_of = Hashtbl.create 256 and name_of = Hashtbl.create 256 in
    List.iter
      (fun (name, file, schema) ->
        Hashtbl.replace file_of name (file, schema);
        Hashtbl.replace name_of file name)
      components;
    let referred (reference : Decode.reference) =
      match Decode.resolve ids reference with
      | file, "" -> (
          match Hashtbl.find_opt name_of file with
          | Some name -> name
          | None ->
              refuse reference.file reference.pointer
                "names %s, which is no component of openapi.json"
                reference.target)
      | _ ->
          refuse reference.file reference.pointer
            "names %s, a place within a component, where only a whole one is \
             named"
            reference.target
    in
    (* What a reference names: a whole component, by its name, or a place
       within one, the schema there and where it is. *)
    let target (reference : Decode.reference) =
      match Decode.resolve ids reference with
      | _, "" -> `Named (referred reference)
      | file, pointer -> (
          let within =
            match Hashtbl.find_opt name_of file with
            | Some name -> snd (Hashtbl.find file_of name)
            | None ->
                refuse reference.file reference.pointer
                  "names %s, within no component of openapi.json"
                  reference.target
          in
          match Pointer.schema within pointer with
          | Some schema -> `Within (file, pointer, schema)
          | None ->
              refuse reference.file reference.pointer
                "names %s, a place its component does not have" reference.target
          )
    in
    let component_kinds = Hashtbl.create 256 in
    let ordered_set kinds = List.filter (fun k -> List.mem k kinds) all_kinds in
    let rec read (schema : Schema.t) : reading =
      Schema.para
        ~boolean:(fun allowed ->
          let refused file at =
            refuse file at
              "allows no value, which the table does not know how to state"
          in
          {
            kinds_of =
              (fun file at -> if allowed then all_kinds else refused file at);
            closed_schema = (fun _ _ -> false);
            shape_of =
              (fun file at -> if allowed then Shape empty else refused file at);
          })
        ~schema:(fun l ->
          {
            kinds_of = kinds_of l;
            closed_schema = closed_schema l;
            shape_of = shape_of l;
          })
        schema
    and kinds_of l file at =
      match view file at l with
      | Or_null schema -> union [ Null ] (plain_kinds file at schema)
      | Plain { schema; null } ->
          let kinds = plain_kinds file at schema in
          if null then union [ Null ] kinds else kinds
    and plain_kinds file at schema =
      match Option.map target schema.ref_ with
      | Some (`Within (file, pointer, schema)) ->
          (read schema).kinds_of file pointer
      | Some (`Named name) -> (
          match Hashtbl.find_opt component_kinds name with
          | Some kinds -> kinds
          | None ->
              (* A component that refers to itself before it says its kind
                 may be any. *)
              Hashtbl.replace component_kinds name all_kinds;
              let file, schema = Hashtbl.find file_of name in
              let kinds = (read schema).kinds_of file "" in
              Hashtbl.replace component_kinds name kinds;
              kinds)
      | None -> (
          match (schema.type_, schema.all_of, variants file at schema) with
          | Some types, _, _ -> ordered_set (List.map kind_of_type types)
          | None, Some parts, _ ->
              List.fold_left
                (fun (kinds, i) (_, part) ->
                  let allowed =
                    part.kinds_of file (Printf.sprintf "%s/allOf/%d" at i)
                  in
                  ( List.filter
                      (fun k -> allows kinds k && allows allowed k)
                      all_kinds,
                    i + 1 ))
                (all_kinds, 0) parts
              |> fst
          | None, None, Some (keyword, variants) ->
              List.fold_left union []
                (List.mapi
                   (fun i (_, variant) ->
                     variant.kinds_of file
                       (Printf.sprintf "%s/%s/%d" at keyword i))
                   variants)
          | None, None, None -> (
              if
                schema.properties <> None || schema.required <> None
                || schema.additional_properties <> None
              then [ Object ]
              else if schema.items <> None then [ Array ]
              else
                match (schema.enum, schema.const) with
                | Some values, _ ->
                    ordered_set (List.map kind_of_literal values)
                | None, Some value -> [ kind_of_literal value ]
                | None, None -> all_kinds))
    and closed_schema l file at =
      match view file at l with
      | Or_null _ -> false
      | Plain { schema; _ } -> (
          match Option.map target schema.ref_ with
          | Some (`Within (file, pointer, schema)) ->
              (read schema).closed_schema file pointer
          | Some (`Named name) ->
              let file, schema = Hashtbl.find file_of name in
              (read schema).closed_schema file ""
          | None ->
              (match schema.additional_properties with
                | Some (Boolean_schema false, _) -> true
                | _ -> false)
              || schema.max_properties = Some 0
              || List.exists
                   (fun (_, part) -> part.closed_schema file at)
                   (Option.value schema.all_of ~default:[]))
    and shape_of l file at =
      match view file at l with
      | Or_null inner ->
          let kinds = union [ Null ] (plain_kinds file at inner) in
          Shape
            {
              empty with
              kinds = (if any_kind kinds then None else Some (ordered kinds));
              one_of =
                [
                  Shape { empty with kinds = Some [ Null ] };
                  plain_shape file at inner ~null:false;
                ];
            }
      | Plain { schema; null } -> plain_shape file at schema ~null
    and plain_shape file at schema ~null =
      let {
        Schema.ref_;
        comment = _;
        title = _;
        description = _;
        type_;
        format = _;
        enum;
        const;
        default = _;
        examples = _;
        properties;
        required;
        additional_properties;
        property_names;
        min_properties;
        max_properties;
        items;
        min_items;
        max_items;
        unique_items = _;
        min_length;
        max_length;
        pattern;
        minimum;
        maximum;
        all_of;
        any_of;
        one_of;
        not_;
        discriminator;
      } =
        schema
      in
      (* A [const] is an [enum] of its one value. *)
      let enum =
        match (const, enum) with
        | None, enum -> enum
        | Some value, None -> Some [ value ]
        | Some value, Some values when List.mem value values -> Some [ value ]
        | Some _, Some _ ->
            refuse file (at ^ "/const") "is none of the values its enum states"
      in
      match Option.map target ref_ with
      | Some (`Named name) -> Ref name
      | Some (`Within (file, pointer, schema)) ->
          (read schema).shape_of file pointer
      | None ->
          let kinds =
            let kinds = plain_kinds file at schema in
            if null then union [ Null ] kinds else kinds
          in
          if enum <> None && List.mem Null kinds then
            refuse file at
              "states an enum beside a type that allows null, and an enum \
               states no null";
          let count keyword = function
            | Some n when n < 0 ->
                refuse file (at ^ "/" ^ keyword) "is %d, which is no count" n
            | bound -> bound
          in
          let pattern =
            Option.map
              (fun text ->
                try terms_of text
                with Unspellable ->
                  refuse file (at ^ "/pattern")
                    "is %s, which is not a pattern the table can spell out" text)
              pattern
          in
          let names =
            List.sort String.compare
              (List.map fst (Option.value properties ~default:[]))
          in
          let members =
            List.map
              (fun name ->
                ( name,
                  (snd (List.assoc name (Option.get properties))).shape_of file
                    (at ^ "/properties/" ^ token name) ))
              names
          in
          let closed =
            match (additional_properties, max_properties) with
            | Some (Schema.Boolean_schema false, _), _ -> Some names
            | _, Some 0 when names = [] -> Some []
            | _, Some n ->
                refuse file (at ^ "/maxProperties")
                  "is %d beside %d properties, and the table states only an \
                   object that carries none"
                  n (List.length names)
            | _, None -> None
          in
          let values =
            match additional_properties with
            | Some (Schema _, value) ->
                Some (value.shape_of file (at ^ "/additionalProperties"))
            | Some (Boolean_schema _, _) | None -> None
          in
          let one_of, discriminator =
            match (variants file at schema, discriminator) with
            | None, None -> ([], None)
            | None, Some _ ->
                refuse file (at ^ "/discriminator")
                  "is beside no oneOf or anyOf"
            | Some (keyword, variants), discriminator ->
                let shapes =
                  List.mapi
                    (fun i (_, variant) ->
                      variant.shape_of file
                        (Printf.sprintf "%s/%s/%d" at keyword i))
                    variants
                in
                ( shapes,
                  Option.map
                    (fun (d : Schema.discriminator) ->
                      let at = at ^ "/discriminator" in
                      let mapping =
                        match d.mapping with
                        | Some mapping -> mapping
                        | None -> refuse file at "states no mapping"
                      in
                      let named =
                        List.map
                          (function
                            | Schema.Schema { ref_ = Some reference; _ }, _ ->
                                Some (referred reference)
                            | _ -> None)
                          variants
                      in
                      {
                        property = d.property_name;
                        mapping =
                          List.map
                            (fun (value, target) ->
                              let pointer = at ^ "/mapping/" ^ token value in
                              let name =
                                referred { Decode.target; file; pointer }
                              in
                              let rec place i = function
                                | [] ->
                                    refuse file pointer
                                      "maps %S to %s, which is none of its \
                                       variants"
                                      value target
                                | Some n :: _ when n = name -> i
                                | _ :: rest -> place (i + 1) rest
                              in
                              (value, place 0 named))
                            mapping;
                      })
                    discriminator )
          in
          let all_of =
            match all_of with
            | None -> []
            | Some parts ->
                if
                  List.length parts > 1
                  && List.exists
                       (fun (_, part) ->
                         part.closed_schema file (at ^ "/allOf"))
                       parts
                then
                  refuse file (at ^ "/allOf")
                    "has a closed part, which would refuse the other parts' \
                     members";
                List.mapi
                  (fun i (_, part) ->
                    part.shape_of file (Printf.sprintf "%s/allOf/%d" at i))
                  parts
          in
          Shape
            {
              kinds = (if any_kind kinds then None else Some (ordered kinds));
              recognized = None;
              enum;
              pattern;
              min_length = count "minLength" min_length;
              max_length = count "maxLength" max_length;
              minimum;
              maximum;
              min_items = count "minItems" min_items;
              max_items = count "maxItems" max_items;
              required =
                (match required with Some (_ :: _) -> required | _ -> None);
              members;
              closed;
              items =
                Option.map
                  (fun (_, item) -> item.shape_of file (at ^ "/items"))
                  items;
              values;
              one_of;
              discriminator;
              all_of;
              not_all =
                (match not_ with
                | None -> []
                | Some (negated, _) -> member_sets file (at ^ "/not") negated);
              min_members = count "minProperties" min_properties;
              names =
                Option.map
                  (fun (_, n) -> n.shape_of file (at ^ "/propertyNames"))
                  property_names;
            }
    in
    let unpruned =
      List.map
        (fun (name, file, schema) ->
          let shape = (read schema).shape_of file "" in
          if name <> "CommandError" then (name, shape)
          else
            match shape with
            | Shape ({ members; _ } as body) -> (
                match List.assoc_opt "code" members with
                | Some (Shape code) ->
                    ( name,
                      Shape
                        {
                          body with
                          members =
                            List.map
                              (fun (member, shape) ->
                                if member = "code" then
                                  ( member,
                                    Shape
                                      { code with recognized = Some recognized }
                                  )
                                else (member, shape))
                              members;
                        } )
                | _ ->
                    refuse file "/properties/code"
                      "is described by no shape of its own to state its \
                       recognized codes in")
            | Ref _ ->
                refuse file ""
                  "is described by no shape of its own to state its recognized \
                   codes in")
        components
    in
    (* Which components can be wrong: one is read as wrong in no way until it
       is found to be, and found again until nothing more is. *)
    let can_fault_component = Hashtbl.create 256 in
    let rec can_fault = function
      | Ref name -> Hashtbl.mem can_fault_component name
      | Shape b ->
          b.kinds <> None || b.recognized <> None || b.enum <> None
          || b.pattern <> None || b.min_length <> None || b.max_length <> None
          || b.minimum <> None || b.maximum <> None || b.min_items <> None
          || b.max_items <> None || b.closed <> None || b.required <> None
          || List.exists (fun (_, member) -> can_fault member) b.members
          || Option.fold ~none:false ~some:can_fault b.items
          || Option.fold ~none:false ~some:can_fault b.values
          || List.exists can_fault b.one_of
          || List.exists can_fault b.all_of
          || b.not_all <> [] || b.min_members <> None
          || Option.fold ~none:false ~some:can_fault b.names
    in
    let rec settle () =
      let found =
        List.filter
          (fun (name, shape) ->
            (not (Hashtbl.mem can_fault_component name)) && can_fault shape)
          unpruned
      in
      if found <> [] then (
        List.iter
          (fun (name, _) -> Hashtbl.replace can_fault_component name ())
          found;
        settle ())
    in
    settle ();
    let rec pruned = function
      | Ref _ as shape -> if can_fault shape then shape else Shape empty
      | Shape b ->
          let kept = function
            | Some shape when can_fault shape -> Some (pruned shape)
            | _ -> None
          in
          let unions = List.exists can_fault b.one_of in
          Shape
            {
              b with
              members =
                List.filter_map
                  (fun (name, member) ->
                    if can_fault member then Some (name, pruned member)
                    else None)
                  b.members;
              items = kept b.items;
              values = kept b.values;
              one_of = (if unions then List.map pruned b.one_of else []);
              discriminator = (if unions then b.discriminator else None);
              all_of = List.map pruned (List.filter can_fault b.all_of);
              names = kept b.names;
            }
    in
    let shapes =
      List.sort
        (fun (a, _) (b, _) -> String.compare a b)
        (List.map (fun (name, shape) -> (name, pruned shape)) unpruned)
    in
    let inline ~file ~pointer schema =
      try Ok (pruned ((read schema).shape_of file pointer))
      with Refused error -> Error error
    in
    Ok { shapes; inline }
  with Refused error -> Error [ error ]

(* ── As JSON ──────────────────────────────────────────────────────────── *)

let number value =
  if Float.is_integer value then `Int (Float.to_int value) else `Float value

let literal : Schema.literal -> Yojson.Safe.t = function
  | String_literal s -> `String s
  | Int_literal n -> `Int n
  | Bool_literal b -> `Bool b

let strings list = `List (List.map (fun s -> `String s) list)

(* A shape as the table writes it. [pairs] writes an object's members as
   [name, shape] pairs, for a reader whose JSON objects keep no order. *)
let rec term_json = function
  | Step step ->
      `Assoc
        ([
           ( "of",
             `List
               (List.map
                  (fun (from, to_) -> `List [ `Int from; `Int to_ ])
                  step.of_) );
           ("min", `Int step.min);
         ]
        @ Option.fold ~none:[] ~some:(fun max -> [ ("max", `Int max) ]) step.max
        )
  | Group group ->
      `Assoc
        ([
           ( "either",
             `List
               (List.map
                  (fun terms -> `List (List.map term_json terms))
                  group.either) );
           ("min", `Int group.min);
         ]
        @ Option.fold ~none:[]
            ~some:(fun max -> [ ("max", `Int max) ])
            group.max)

let rec to_json ~pairs = function
  | Ref name -> `Assoc [ ("ref", `String name) ]
  | Shape b ->
      let part name value = Option.map (fun value -> (name, value)) value in
      let list name = function
        | [] -> None
        | items -> Some (name, `List items)
      in
      let int = Option.map (fun n -> `Int n) in
      `Assoc
        (List.filter_map Fun.id
           [
             part "kinds"
               (Option.map (fun ks -> strings (List.map kind_name ks)) b.kinds);
             part "recognized" (Option.map strings b.recognized);
             part "enum"
               (Option.map (fun vs -> `List (List.map literal vs)) b.enum);
             part "pattern"
               (Option.map
                  (fun terms -> `List (List.map term_json terms))
                  b.pattern);
             part "minLength" (int b.min_length);
             part "maxLength" (int b.max_length);
             part "minimum" (Option.map number b.minimum);
             part "maximum" (Option.map number b.maximum);
             part "minItems" (int b.min_items);
             part "maxItems" (int b.max_items);
             part "required" (Option.map strings b.required);
             (match b.members with
             | [] -> None
             | members when pairs ->
                 Some
                   ( "members",
                     `List
                       (List.map
                          (fun (name, shape) ->
                            `List [ `String name; to_json ~pairs shape ])
                          members) )
             | members ->
                 Some
                   ( "members",
                     `Assoc
                       (List.map
                          (fun (name, shape) -> (name, to_json ~pairs shape))
                          members) ));
             part "closed" (Option.map strings b.closed);
             part "items" (Option.map (to_json ~pairs) b.items);
             part "values" (Option.map (to_json ~pairs) b.values);
             list "oneOf" (List.map (to_json ~pairs) b.one_of);
             part "discriminator"
               (Option.map
                  (fun d ->
                    `Assoc
                      [
                        ("property", `String d.property);
                        ( "mapping",
                          `Assoc
                            (List.map (fun (v, i) -> (v, `Int i)) d.mapping) );
                      ])
                  b.discriminator);
             list "allOf" (List.map (to_json ~pairs) b.all_of);
             list "notAll" (List.map strings b.not_all);
             part "minMembers" (int b.min_members);
             part "names" (Option.map (to_json ~pairs) b.names);
           ])

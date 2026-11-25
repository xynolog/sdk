(* Go as the generator writes it: the declarations, statements and
   expressions its writers build, and a printer that lays them out as gofmt
   does. A writer builds a file of these and never a line of Go, so what it
   writes parses: a name is checked to be one, a string is quoted by the
   printer, and every bracket the printer opens it closes.

   Layout is the printer's. Indentation is a tab a level. The specs of a
   group, the fields of a struct, the elements of a literal written a line
   each, and the bodies of adjacent funcs written on their signatures' lines
   are aligned in runs, as gofmt aligns them: each cell but the last
   padded out to its column's widest, then a space. A run ends at a blank
   line, before a comment, and on both sides of an item written over several
   lines. gofmt also ends a run at a key much longer than its neighbours';
   no table has one, and the gofmt gate would refuse the file that did. *)

(* A comment: prose wrapped to 78 columns, or a line as it is given. An empty
   line is a bare [//]. *)
type line = Prose of string | Line of string
type doc = line list

type type_ =
  | Named of string
  | Slice of type_
  | Map of type_ * type_
  | Pointer of type_
  | Generic of string * type_ list
  | Struct_type of string list * type_
      (** Of one field, on one line: gofmt keeps a struct on one line only when
          it has one field, of a type 30 columns wide at most. A field of no
          names is embedded. *)
  | Func_type of type_ list * type_ list
  | Receive of type_  (** A channel only received from: [<-chan t]. *)
  | Empty_struct  (** [struct{}]. *)

(* Items written a line each: one after another, or a blank line between. *)
type spacing = Packed | Spaced
type unary = Not | Deref | Address

(* An operand of one of these is no other operation, so none needs
   parentheses, and gofmt spaces each as it is written. *)
type binary = Eq | Ne | Ge | Add | Mul

type expr =
  | Name of string  (** [true], [false] and [nil] are names. *)
  | Quoted of string  (** As JSON quotes it, which Go reads as the same text. *)
  | Ascii of string  (** Printable ASCII, the rest escaped. *)
  | Int of int
  | Hex of int  (** Four hex digits at least. *)
  | Octal of string  (** Octal digits, written after [0o]. *)
  | Call of expr * expr list
  | Instance of expr * type_ list  (** A generic function's instance. *)
  | Convert of type_ * expr
  | Unary of unary * expr
  | Binary of expr * binary * expr  (** [a + b + c] is [(a + b) + c]. *)
  | Literal of literal

(* A composite literal: its type, or none where the enclosing literal's
   element type is implied, and its elements on one line or a line each. *)
and literal = { of_ : type_ option; elements : element list; layout : layout }
and layout = Inline | Lines of spacing
and element = { about : doc; key : expr option; value : expr }

type stmt =
  | Return of expr list
  | Do of expr
  | If of expr * stmt list
  | Switch of {
      tag : expr option;
      cases : (expr list * stmt list) list;
      default : stmt list option;
    }
  | Range of { key : string; value : string; over : expr; body : stmt list }
  | Define of string list * expr
  | Assign of expr * expr
  | Local_type of string * type_  (** [type name t], within a body. *)

type spec = { doc : doc; name : string; type_ : type_ option; value : expr }

(* A field of no names is the embedded [type_]. *)
type field = {
  doc : doc;
  names : string list;
  type_ : type_;
  tag : string option;
}

type results = Unnamed of type_ list | Named_results of (string * type_) list

type method_ = {
  m_doc : doc;
  name : string;
  params : (string * type_) list;
  results : results;
}

(* A body of statements, one statement on the signature's line, or none:
   [{}]. *)
type body = Block of stmt list | One_line of stmt | Empty

type func = {
  doc : doc;
  receiver : (string * type_) option;  (** Of no name where it is [""]. *)
  name : string;
  params : (string * type_) list;
  results : results;
  body : body;
}

type type_def =
  | Is of type_
  | Struct of { fields : field list; spacing : spacing }
  | Interface of method_ list

type decl =
  | Comment of doc  (** A comment of no declaration's. *)
  | Const of spec
  | Consts of { doc : doc; specs : spec list; spacing : spacing }
  | Var of spec
  | Vars of { doc : doc; specs : spec list; spacing : spacing }
  | Type of { doc : doc; name : string; def : type_def }
  | Aliases of { doc : doc; specs : (string * type_) list }
  | Func of func
  | Adjacent of decl list  (** Declarations with no blank line between. *)

type file = {
  header : doc;
  package : string;
  imports : string list list;  (** Groups, a blank line between. *)
  decls : decl list;
}

let prose text = [ Prose text ]

(* [text]'s lines, each a line of a comment as it is given. *)
let verbatim text = List.map (fun l -> Line l) (String.split_on_char '\n' text)
let element ?(about = []) ?key value = { about; key; value }
let item value = element value
let keyed key value = element ~key:(Name key) value
let inline ?of_ elements = Literal { of_; elements; layout = Inline }

let lines ?of_ ?(spacing = Packed) elements =
  Literal { of_; elements; layout = Lines spacing }

let call name args = Call (Name name, args)
let spec ?(doc = []) ?type_ name value = { doc; name; type_; value }

let method_ ?(doc = []) ?(results = Unnamed []) name params : method_ =
  { m_doc = doc; name; params; results }

let func ?(doc = []) ?receiver ?(params = []) ?(results = Unnamed []) name body
    =
  Func { doc; receiver; name; params; results; body }

let is_word = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true
  | _ -> false

let identifier name =
  name <> ""
  && (match name.[0] with '0' .. '9' -> false | _ -> true)
  && String.for_all is_word name

(* A name, or one qualified by what it is within ([api.Thing],
   [v.links.timing]). *)
let checked name =
  if List.for_all identifier (String.split_on_char '.' name) then name
  else invalid_arg (Printf.sprintf "Go_syntax: %S is no Go name" name)

let tabs n = String.make n '\t'
let listed f items = String.concat ", " (List.map f items)

let rec type_text = function
  | Named name -> checked name
  | Slice t -> "[]" ^ type_text t
  | Map (k, v) -> "map[" ^ type_text k ^ "]" ^ type_text v
  | Pointer t -> "*" ^ type_text t
  | Generic (name, args) -> checked name ^ "[" ^ listed type_text args ^ "]"
  | Struct_type (names, t) ->
      let typed = type_text t in
      if (if names = [] then 0 else 1) + Text.length typed > 30 then
        invalid_arg
          (Printf.sprintf
             "Go_syntax: struct{ %s } is too wide for gofmt to keep on a line"
             typed)
      else
        "struct{ "
        ^ (match names with
          | [] -> typed
          | _ -> listed checked names ^ " " ^ typed)
        ^ " }"
  | Func_type (params, results) ->
      "func(" ^ listed type_text params ^ ")" ^ results_text (Unnamed results)
  | Receive t -> "<-chan " ^ type_text t
  | Empty_struct -> "struct{}"

and results_text = function
  | Unnamed [] | Named_results [] -> ""
  | Unnamed [ one ] -> " " ^ type_text one
  | Unnamed many -> " (" ^ listed type_text many ^ ")"
  | Named_results named ->
      " (" ^ listed (fun (n, t) -> checked n ^ " " ^ type_text t) named ^ ")"

let comment ~depth (doc : doc) =
  let lead = tabs depth ^ "//" in
  List.concat_map
    (function
      | Prose text ->
          List.map
            (fun l -> lead ^ " " ^ l)
            (Text.wrapped ~lead:(lead ^ " ") ~width:78 text)
      | Line "" -> [ lead ]
      | Line text ->
          if String.contains text '\n' then
            invalid_arg
              (Printf.sprintf "Go_syntax: comment line %S is two" text)
          else [ lead ^ " " ^ text ])
    doc

let rec spans_lines = function
  | Literal { layout = Lines _; _ } -> true
  | Literal { layout = Inline; elements; _ } ->
      List.exists
        (fun (e : element) ->
          spans_lines e.value || Option.fold ~none:false ~some:spans_lines e.key)
        elements
  | Call (f, args) -> spans_lines f || List.exists spans_lines args
  | Instance (e, _) | Convert (_, e) | Unary (_, e) -> spans_lines e
  | Binary (a, _, b) -> spans_lines a || spans_lines b
  | Name _ | Quoted _ | Ascii _ | Int _ | Hex _ | Octal _ -> false

let align rows =
  let columns = List.fold_left (fun n row -> max n (List.length row)) 0 rows in
  let widths =
    List.init columns (fun i ->
        List.fold_left
          (fun w row ->
            if List.length row > i + 1 then max w (Text.length (List.nth row i))
            else w)
          0 rows)
  in
  List.map
    (fun row ->
      let last = List.length row - 1 in
      String.concat ""
        (List.mapi
           (fun i cell ->
             if i = last then cell
             else
               cell
               ^ String.make (List.nth widths i - Text.length cell) ' '
               ^ " ")
           row))
    rows

(* Consecutive items in runs: one that has a comment begins a run, and one
   written over several lines is a run of its own. *)
let runs ~commented ~spans items =
  List.fold_left
    (fun acc item ->
      match acc with
      | (last :: _ as run) :: rest
        when not (commented item || spans item || spans last) ->
          (item :: run) :: rest
      | _ -> [ item ] :: acc)
    [] items
  |> List.rev_map List.rev

(* Items a line each at [depth], each under its comment, aligned in runs. *)
let rows ~depth ~spacing ~about ~spans ~cells items =
  let run items =
    List.concat
      (List.map2
         (fun item row -> comment ~depth (about item) @ [ tabs depth ^ row ])
         items
         (align (List.map cells items)))
  in
  match spacing with
  | Packed ->
      String.concat "\n"
        (List.concat_map run
           (runs ~commented:(fun item -> about item <> []) ~spans items))
  | Spaced ->
      String.concat "\n\n"
        (List.map (fun item -> String.concat "\n" (run [ item ])) items)

let rec expr ~depth = function
  | Name name -> checked name
  | Quoted text -> Text.quoted text
  | Ascii text -> Text.ascii_quoted text
  | Int n -> string_of_int n
  | Hex n -> Printf.sprintf "0x%04x" n
  | Octal digits ->
      if
        digits <> ""
        && String.for_all (function '0' .. '7' -> true | _ -> false) digits
      then "0o" ^ digits
      else
        invalid_arg (Printf.sprintf "Go_syntax: %S is no octal number" digits)
  | Call (f, args) -> expr ~depth f ^ "(" ^ listed (expr ~depth) args ^ ")"
  | Instance (e, types) -> expr ~depth e ^ "[" ^ listed type_text types ^ "]"
  | Convert (t, e) ->
      (match t with
        | Pointer _ | Func_type _ -> "(" ^ type_text t ^ ")"
        | _ -> type_text t)
      ^ "(" ^ expr ~depth e ^ ")"
  | Unary (op, e) ->
      (match op with Not -> "!" | Deref -> "*" | Address -> "&")
      ^ operand ~depth e
  | Binary (a, op, b) ->
      let left =
        match a with
        | Binary (_, inner, _) when inner = op && (op = Add || op = Mul) ->
            expr ~depth a
        | _ -> operand ~depth a
      in
      left ^ " "
      ^ (match op with
        | Eq -> "=="
        | Ne -> "!="
        | Ge -> ">="
        | Add -> "+"
        | Mul -> "*")
      ^ " " ^ operand ~depth b
  | Literal l -> literal ~depth l

and operand ~depth = function
  | Unary _ | Binary _ ->
      invalid_arg
        "Go_syntax: an operand is another operation, which needs parentheses"
  | e -> expr ~depth e

and literal ~depth { of_; elements; layout } =
  let opening = Option.fold ~none:"" ~some:type_text of_ ^ "{" in
  match layout with
  | Inline ->
      opening
      ^ listed
          (fun (e : element) ->
            match e.key with
            | Some k -> expr ~depth k ^ ": " ^ expr ~depth e.value
            | None -> expr ~depth e.value)
          elements
      ^ "}"
  | Lines spacing ->
      let inner = depth + 1 in
      opening ^ "\n"
      ^ rows ~depth:inner ~spacing
          ~about:(fun (e : element) -> e.about)
          ~spans:(fun (e : element) -> spans_lines e.value)
          ~cells:(fun (e : element) ->
            let value = expr ~depth:inner e.value ^ "," in
            match e.key with
            | Some k -> [ expr ~depth:inner k ^ ":"; value ]
            | None -> [ value ])
          elements
      ^ "\n" ^ tabs depth ^ "}"

let rec stmt ~depth s =
  let at = tabs depth in
  let block body = String.concat "" (List.map (stmt ~depth:(depth + 1)) body) in
  let e = expr ~depth in
  match s with
  | Return [] -> at ^ "return\n"
  | Return values -> at ^ "return " ^ listed e values ^ "\n"
  | Do x -> at ^ e x ^ "\n"
  | If (cond, body) -> at ^ "if " ^ e cond ^ " {\n" ^ block body ^ at ^ "}\n"
  | Switch { tag; cases; default } ->
      at ^ "switch "
      ^ Option.fold ~none:"" ~some:(fun t -> e t ^ " ") tag
      ^ "{\n"
      ^ String.concat ""
          (List.map
             (fun (values, body) ->
               at ^ "case " ^ listed e values ^ ":\n" ^ block body)
             cases)
      ^ Option.fold ~none:""
          ~some:(fun body -> at ^ "default:\n" ^ block body)
          default
      ^ at ^ "}\n"
  | Range { key; value; over; body } ->
      at ^ "for " ^ checked key ^ ", " ^ checked value ^ " := range " ^ e over
      ^ " {\n" ^ block body ^ at ^ "}\n"
  | Define (names, value) -> at ^ listed checked names ^ " := " ^ e value ^ "\n"
  | Assign (target, value) -> at ^ e target ^ " = " ^ e value ^ "\n"
  | Local_type (name, t) ->
      at ^ "type " ^ checked name ^ " " ^ type_text t ^ "\n"

let params_text params =
  listed
    (function "", t -> type_text t | n, t -> checked n ^ " " ^ type_text t)
    params

let with_doc doc text = String.concat "\n" (comment ~depth:0 doc @ [ text ])

let spec_cells ~depth (s : spec) =
  (checked s.name :: Option.to_list (Option.map type_text s.type_))
  @ [ "= " ^ expr ~depth s.value ]

let group keyword ~doc ~spacing specs =
  with_doc doc
    (keyword ^ " (\n"
    ^ rows ~depth:1 ~spacing
        ~about:(fun (s : spec) -> s.doc)
        ~spans:(fun (s : spec) -> spans_lines s.value)
        ~cells:(spec_cells ~depth:1) specs
    ^ "\n)")

let single keyword (s : spec) =
  with_doc s.doc (keyword ^ " " ^ String.concat " " (spec_cells ~depth:0 s))

let field_cells (f : field) =
  (match f.names with
    | [] -> [ type_text f.type_ ]
    | names -> [ listed checked names; type_text f.type_ ])
  @ Option.to_list
      (Option.map
         (fun tag ->
           if String.contains tag '`' then
             invalid_arg (Printf.sprintf "Go_syntax: tag %S holds a `" tag)
           else "`" ^ tag ^ "`")
         f.tag)

let signature (f : func) =
  "func "
  ^ Option.fold ~none:""
      ~some:(fun r -> "(" ^ params_text [ r ] ^ ") ")
      f.receiver
  ^ checked f.name ^ "(" ^ params_text f.params ^ ")" ^ results_text f.results

(* A body on its signature's line, where gofmt keeps it there: the signature
   and the body's statement together under 100 columns. *)
let short_body (f : func) =
  let fits body size =
    if Text.length (signature f) + size < 100 then Some body else None
  in
  match f.body with
  | One_line s ->
      let line = String.trim (stmt ~depth:0 s) in
      fits ("{ " ^ line ^ " }") (Text.length line)
  | Empty -> fits "{}" 0
  | Block _ -> None

let func_text (f : func) =
  match short_body f with
  | Some body -> signature f ^ " " ^ body
  | None ->
      let body =
        match f.body with
        | Block body -> body
        | One_line s -> [ s ]
        | Empty -> []
      in
      signature f ^ " {\n"
      ^ String.concat "" (List.map (stmt ~depth:1) body)
      ^ "}"

(* A declaration among adjacent ones: a func whose body is on its
   signature's line, the bodies of a run of which gofmt aligns, or another. *)
type placed = Short of func * string | Long of decl

let placed = function
  | Func f as d -> (
      match short_body f with Some body -> Short (f, body) | None -> Long d)
  | d -> Long d

let rec decl = function
  | Comment doc -> String.concat "\n" (comment ~depth:0 doc)
  | Const s -> single "const" s
  | Var s -> single "var" s
  | Consts { doc; specs; spacing } -> group "const" ~doc ~spacing specs
  | Vars { doc; specs; spacing } -> group "var" ~doc ~spacing specs
  | Aliases { doc; specs } ->
      with_doc doc
        ("type (\n"
        ^ rows ~depth:1 ~spacing:Packed
            ~about:(fun _ -> [])
            ~spans:(fun _ -> false)
            ~cells:(fun (name, t) -> [ checked name; "= " ^ type_text t ])
            specs
        ^ "\n)")
  | Type { doc; name; def } ->
      with_doc doc
        ("type " ^ checked name ^ " "
        ^
        match def with
        | Is t -> type_text t
        | Struct { fields = []; _ } -> "struct{}"
        | Struct { fields; spacing } ->
            "struct {\n"
            ^ rows ~depth:1 ~spacing
                ~about:(fun (f : field) -> f.doc)
                ~spans:(fun _ -> false)
                ~cells:field_cells fields
            ^ "\n}"
        | Interface methods ->
            "interface {\n"
            ^ String.concat ""
                (List.map
                   (fun (m : method_) ->
                     String.concat ""
                       (List.map (fun l -> l ^ "\n") (comment ~depth:1 m.m_doc))
                     ^ "\t" ^ checked m.name ^ "(" ^ params_text m.params ^ ")"
                     ^ results_text m.results ^ "\n")
                   methods)
            ^ "}")
  | Func f -> with_doc f.doc (func_text f)
  | Adjacent decls ->
      rows ~depth:0 ~spacing:Packed
        ~about:(function Short ((f : func), _) -> f.doc | Long _ -> [])
        ~spans:(function Short _ -> false | Long _ -> true)
        ~cells:(function
          | Short (f, body) -> [ signature f; body ] | Long d -> [ decl d ])
        (List.map placed decls)

let imports_text = function
  | [] -> ""
  | [ [ one ] ] -> "import " ^ Text.quoted one ^ "\n\n"
  | groups ->
      "import (\n"
      ^ String.concat "\n\n"
          (List.map
             (fun paths ->
               String.concat "\n"
                 (List.map (fun p -> "\t" ^ Text.quoted p) paths))
             groups)
      ^ "\n)\n\n"

let text f =
  String.concat "\n" (comment ~depth:0 f.header)
  ^ "\n\npackage " ^ checked f.package ^ "\n\n" ^ imports_text f.imports
  ^ String.concat "\n\n" (List.map decl f.decls)
  ^ "\n"

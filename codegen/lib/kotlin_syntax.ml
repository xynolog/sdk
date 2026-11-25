(* Kotlin as the generator writes it: the declarations of a generated file,
   the types and expressions they hold, and the few statements a body
   needs, with a printer that writes them. A writer builds a file of these
   and never a line of Kotlin: a name is checked to be one, and written in
   backquotes where it is a keyword; a string is quoted and escaped by the
   printer; a comment's markers are the printer's; an operand is put in
   parentheses where it would otherwise be read as part of another; and
   every bracket the printer opens it closes.

   ktlint holds the layout, and keeps the line breaks it is given. Where a
   writer chooses one, it says so: a call's arguments on its line or one a
   line ([Inline], [Lines]), a body on its signature's line or the next
   ([Same_line], [Below]), and members a blank line apart or [Packed]. The
   rest is the printer's, as ktlint lays it out: four spaces a level, a
   blank line between top-level declarations and between members, an
   enum's annotated entries a blank line apart, several supertypes one a
   line, and the imports in ktlint's order. *)

(* A KDoc comment: [Doc] on one line, [Block] its text a line of the comment
   each, an empty one a bare [*]. *)
type doc = Doc of string | Block of string

type type_ =
  | Type of string  (** A name, or one qualified by what it is within. *)
  | Generic of string * type_ list
  | Nullable of type_
  | Star
  | Function_type of type_ list * type_

type binary = Or | And | Eq | Ge | In | Range | Plus | To
type layout = Inline | Lines

type expr =
  | Name of string  (** A name, or one qualified by what it is within. *)
  | This
  | Null
  | Bool of bool
  | Str of string  (** Every character as itself but what must be escaped. *)
  | Ascii of string  (** Printable ASCII, every other UTF-16 unit escaped. *)
  | Int of int
  | Hex of string  (** Hex digits, written after [0x]. *)
  | Char of char
  | Call of call
  | Member of expr * string  (** [e.name] *)
  | Not of expr
  | Binary of expr * binary * expr  (** [a + b + c] is [(a + b) + c]. *)
  | Class_literal of string  (** [T::class] *)
  | Reference of string * string  (** [T::name] *)
  | Lambda of string list * expr  (** [{ a -> e }], or [{ e }] with none. *)
  | Assigning of expr * expr
      (** [a = b], which is no expression: a lambda's whole body alone. *)
  | When of { subject : expr option; branches : branch list }
      (** Its last branch's conditions are [[]] for [else]. *)
  | If of expr * expr * expr  (** On one line. *)
  | Throw of expr
  | Try of { body : expr; caught : string * type_; handler : expr }

and call = {
  callee : expr;
  types : type_ list;
  args : arg list;
  layout : layout;
  lambda : expr option;  (** A trailing lambda. *)
}

and arg = { label : string option; value : expr }
and branch = { conditions : condition list; result : expr }
and condition = Equal of expr

type stmt =
  | Val of string * expr
  | Return of expr
  | If_then of expr * stmt  (** On one line. *)
  | Do of expr

type visibility = Public | Internal | Private | Default

(* [@target:name(args)]; [args] [None] writes no parentheses. *)
type annotation = {
  target : string option;
  name : string;
  args : arg list option;
}

type binding = Plain | Bound of { visibility : visibility; mutable_ : bool }

type param = {
  about : doc option;
  annotations : annotation list;
  binding : binding;
  name : string;
  type_ : type_;
  default : expr option;
}

type body = Same_line of expr | Below of expr | Block of stmt list

type kind =
  | Class
  | Data_class
  | Enum_class
  | Value_class
  | Interface
  | Sealed_interface
  | Object
  | Data_object
  | Companion_object

type super = {
  super : type_;
  super_args : arg list option;
  super_layout : layout;
}

type entry = {
  entry_about : doc option;
  entry_annotations : annotation list;
  entry : string;
  entry_args : arg list;
}

type constructor = {
  constructor_annotations : annotation list;
  constructor_visibility : visibility;
  params : param list;
  params_layout : layout;
      (** [Inline]: no parameter is documented or annotated. *)
}

type decl =
  | Property of {
      about : doc option;
      annotations : annotation list;
      visibility : visibility;
      override : bool;
      const : bool;
      mutable_ : bool;
      name : string;
      type_ : type_ option;
      value : body option;  (** [Same_line] or [Below]. *)
    }
  | Function of {
      about : doc option;
      annotations : annotation list;
      visibility : visibility;
      override : bool;
      name : string;
      params : (string * type_) list;
      returns : type_ option;
      body : body;
    }
  | Class_decl of {
      about : doc option;
      annotations : annotation list;
      visibility : visibility;
      kind : kind;
      name : string;
      constructor : constructor option;
      supers : super list;
      entries : entry list;
      members : decl list;
    }
  | Typealias of {
      about : doc option;
      visibility : visibility;
      name : string;
      type_ : type_;
    }
  | Init of stmt list
  | Packed of decl list  (** Members with no blank line between. *)

type file = {
  banner : string list;  (** Line comments, each written after a [//]. *)
  file_annotations : annotation list;  (** Each [@file:]. *)
  package : string;
  imports : string list;
  decls : decl list;
}

let arg ?label value = { label; value }

let call ?(types = []) ?(layout = Inline) ?lambda callee args =
  Call { callee; types; args = List.map arg args; layout; lambda }

let named_call ?(types = []) ?(layout = Inline) callee args =
  Call
    {
      callee;
      types;
      args = List.map (fun (label, value) -> arg ~label value) args;
      layout;
      lambda = None;
    }

let annotation ?target ?args name = { target; name; args }

let property ?about ?(annotations = []) ?(visibility = Default)
    ?(override = false) ?(const = false) ?(mutable_ = false) ?type_ ?value name
    =
  Property
    {
      about;
      annotations;
      visibility;
      override;
      const;
      mutable_;
      name;
      type_;
      value;
    }

let function_ ?about ?(annotations = []) ?(visibility = Default)
    ?(override = false) ?(params = []) ?returns name body =
  Function
    { about; annotations; visibility; override; name; params; returns; body }

let class_ ?about ?(annotations = []) ?(visibility = Default) ?constructor
    ?(supers = []) ?(entries = []) ?(members = []) kind name =
  Class_decl
    {
      about;
      annotations;
      visibility;
      kind;
      name;
      constructor;
      supers;
      entries;
      members;
    }

let constructor ?(annotations = []) ?(visibility = Default) ?(layout = Lines)
    params =
  {
    constructor_annotations = annotations;
    constructor_visibility = visibility;
    params;
    params_layout = layout;
  }

let param ?about ?(annotations = []) ?(binding = Plain) ?default name type_ =
  { about; annotations; binding; name; type_; default }

let super ?(layout = Inline) ?args type_ =
  { super = type_; super_args = args; super_layout = layout }

let entry ?about ?(annotations = []) ?(args = []) name =
  {
    entry_about = about;
    entry_annotations = annotations;
    entry = name;
    entry_args = List.map arg args;
  }

let fail fmt =
  Printf.ksprintf (fun m -> invalid_arg ("Kotlin_syntax: " ^ m)) fmt

(* Kotlin's hard keywords: a name that is one is written in backquotes. *)
let keywords =
  [
    "as";
    "break";
    "class";
    "continue";
    "do";
    "else";
    "false";
    "for";
    "fun";
    "if";
    "in";
    "interface";
    "is";
    "null";
    "object";
    "package";
    "return";
    "super";
    "this";
    "throw";
    "true";
    "try";
    "typealias";
    "typeof";
    "val";
    "var";
    "when";
    "while";
  ]

let is_word = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true
  | _ -> false

let identifier name =
  name <> ""
  && (match name.[0] with '0' .. '9' -> false | _ -> true)
  && String.for_all is_word name

let simple name =
  if not (identifier name) then fail "%S is no name" name
  else if List.mem name keywords then "`" ^ name ^ "`"
  else name

(* A name, or one qualified by what it is within, each part checked. *)
let checked name =
  String.concat "." (List.map simple (String.split_on_char '.' name))

(* [text] as a Kotlin string's contents: a backslash, a quote, a [$] and the
   control characters escaped, every other character as itself. *)
let escaped text =
  let out = Buffer.create (String.length text) in
  String.iter
    (function
      | '\\' -> Buffer.add_string out "\\\\"
      | '"' -> Buffer.add_string out "\\\""
      | '$' -> Buffer.add_string out "\\$"
      | '\n' -> Buffer.add_string out "\\n"
      | '\r' -> Buffer.add_string out "\\r"
      | '\t' -> Buffer.add_string out "\\t"
      | c when Char.code c < 0x20 ->
          Buffer.add_string out (Printf.sprintf "\\u%04x" (Char.code c))
      | c -> Buffer.add_char out c)
    text;
  "\"" ^ Buffer.contents out ^ "\""

(* [text] with only printable ASCII as itself: every other character is
   escaped as the UTF-16 units Kotlin holds it in. *)
let ascii text =
  let out = Buffer.create (String.length text) in
  let unit u = Buffer.add_string out (Printf.sprintf "\\u%04x" u) in
  let rec go i =
    if i < String.length text then begin
      let d = String.get_utf_8_uchar text i in
      if not (Uchar.utf_decode_is_valid d) then fail "%S is no UTF-8" text;
      let u = Uchar.to_int (Uchar.utf_decode_uchar d) in
      (match u with
      | 0x5C -> Buffer.add_string out "\\\\"
      | 0x22 -> Buffer.add_string out "\\\""
      | 0x24 -> Buffer.add_string out "\\$"
      | u when u >= 0x20 && u <= 0x7E -> Buffer.add_char out (Char.chr u)
      | u when u < 0x10000 -> unit u
      | u ->
          let v = u - 0x10000 in
          unit (0xD800 lor (v lsr 10));
          unit (0xDC00 lor (v land 0x3FF)));
      go (i + Uchar.utf_decode_length d)
    end
  in
  go 0;
  "\"" ^ Buffer.contents out ^ "\""

let char_literal = function
  | '\\' -> "'\\\\'"
  | '\'' -> "'\\''"
  | c when Char.code c >= 0x20 && Char.code c <= 0x7E -> Printf.sprintf "'%c'" c
  | c -> fail "the character %C is not printable ASCII" c

let indentation depth = String.make (4 * depth) ' '

(* A comment's text, with neither of a block comment's markers written as
   itself: a block comment nests in Kotlin. *)
let comment_text text =
  if String.contains text '\r' then
    fail "a comment %S holds a carriage return" text;
  Text.replace_all ~sub:"/*" ~by:"&#47;*"
    (Text.replace_all ~sub:"*/" ~by:"*&#47;" text)

let is_blank line =
  String.for_all (function ' ' | '\t' -> true | _ -> false) line

let rec trim_end text =
  let n = String.length text in
  if n > 0 && match text.[n - 1] with ' ' | '\t' | '\n' -> true | _ -> false
  then trim_end (String.sub text 0 (n - 1))
  else text

let doc_lines ~depth = function
  | Doc text ->
      if String.contains text '\n' then
        fail "a one-line doc %S is two lines" text;
      [ indentation depth ^ "/** " ^ comment_text text ^ " */" ]
  | Block text ->
      let at = indentation depth in
      (at ^ "/**")
      :: List.map
           (fun l -> if is_blank l then at ^ " *" else at ^ " * " ^ l)
           (String.split_on_char '\n' (comment_text (trim_end text)))
      @ [ at ^ " */" ]

let about_lines ~depth = function None -> [] | Some d -> doc_lines ~depth d

let rec type_ = function
  | Type name -> checked name
  | Generic (name, args) ->
      checked name ^ "<" ^ String.concat ", " (List.map type_ args) ^ ">"
  | Nullable t -> type_ t ^ "?"
  | Star -> "*"
  | Function_type (params, result) ->
      "(" ^ String.concat ", " (List.map type_ params) ^ ") -> " ^ type_ result

let binary = function
  | Or -> "||"
  | And -> "&&"
  | Eq -> "=="
  | Ge -> ">="
  | In -> "in"
  | Range -> ".."
  | Plus -> "+"
  | To -> "to"

(* How tightly an operation binds, as Kotlin's grammar ranks them: a postfix
   one (a call, a member) most, then a prefix [!], then [as?], and down to
   [||]. An expression that ends in one of its own (a lambda's body aside),
   such as [throw e], [if] or [try], ranks least: it is bare only where
   nothing follows it. *)
let rank = function
  | Or -> 1
  | And -> 2
  | Eq -> 3
  | Ge -> 4
  | In -> 5
  | To -> 7
  | Range -> 8
  | Plus -> 9

let postfix_rank = 12

let rank_of = function
  | Binary (_, op, _) -> rank op
  | Not _ -> 11
  | Throw _ | If _ | When _ | Try _ -> 0
  | _ -> postfix_rank

let rec expr ~depth e =
  match e with
  | Name name -> checked name
  | This -> "this"
  | Null -> "null"
  | Bool b -> string_of_bool b
  | Str text -> escaped text
  | Ascii text -> ascii text
  | Int n -> string_of_int n
  | Hex digits ->
      if digits <> "" && String.for_all Text.is_hex_digit digits then
        "0x" ^ digits
      else
        invalid_arg (Printf.sprintf "Kotlin_syntax: %S is no hex number" digits)
  | Char c -> char_literal c
  | Call { callee; types; args; layout; lambda } -> (
      receiver ~depth callee
      ^ (match types with
        | [] -> ""
        | ts -> "<" ^ String.concat ", " (List.map type_ ts) ^ ">")
      ^ (match (args, lambda) with
        | [], Some _ -> ""
        | _ -> arguments ~depth layout args)
      ^ match lambda with None -> "" | Some l -> " " ^ expr ~depth l)
  | Member (e, name) -> receiver ~depth e ^ "." ^ simple name
  | Not e -> "!" ^ bound ~depth ~least:11 e
  | Binary (a, op, b) ->
      (* A range is written close, as ktlint has it; every other operator spaced. *)
      let spaced = if op = Range then binary op else " " ^ binary op ^ " " in
      bound ~depth ~least:(rank op) a
      ^ spaced
      ^ right ~depth ~least:(rank op + 1) b
  | Class_literal name -> checked name ^ "::class"
  | Reference (owner, name) -> checked owner ^ "::" ^ simple name
  | Lambda ([], Assigning (target, e)) ->
      "{ " ^ expr ~depth target ^ " = " ^ expr ~depth e ^ " }"
  | Assigning _ -> fail "an assignment is written only as a lambda's body"
  | Lambda ([], body) -> (
      (* A body that spans lines is on lines of its own, as ktlint has it. *)
      let spanning = expr ~depth:(depth + 1) body in
      match String.contains spanning '\n' with
      | true ->
          "{\n"
          ^ indentation (depth + 1)
          ^ spanning ^ "\n" ^ indentation depth ^ "}"
      | false -> "{ " ^ expr ~depth body ^ " }")
  | Lambda (params, body) ->
      "{ "
      ^ String.concat ", " (List.map simple params)
      ^ " -> " ^ expr ~depth body ^ " }"
  | When { subject; branches } ->
      let at = indentation (depth + 1) in
      "when "
      ^ (match subject with None -> "" | Some s -> "(" ^ expr ~depth s ^ ") ")
      ^ "{\n"
      ^ String.concat ""
          (List.map
             (fun { conditions; result } ->
               at
               ^ (match conditions with
                 | [] -> "else"
                 | cs ->
                     String.concat ", "
                       (List.map
                          (fun (Equal e) -> expr ~depth:(depth + 1) e)
                          cs))
               ^ " -> "
               ^ expr ~depth:(depth + 1) result
               ^ "\n")
             branches)
      ^ indentation depth ^ "}"
  | If (c, a, b) ->
      "if (" ^ expr ~depth c ^ ") " ^ expr ~depth a ^ " else " ^ expr ~depth b
  | Throw e -> "throw " ^ expr ~depth e
  | Try { body; caught = name, t; handler } ->
      let inner = indentation (depth + 1) in
      "try {\n" ^ inner
      ^ expr ~depth:(depth + 1) body
      ^ "\n" ^ indentation depth ^ "} catch (" ^ simple name ^ ": " ^ type_ t
      ^ ") {\n" ^ inner
      ^ expr ~depth:(depth + 1) handler
      ^ "\n" ^ indentation depth ^ "}"

(* [e] as an operand that must bind at least [least]: in parentheses where
   it binds less. *)
and bound ~depth ~least e =
  if rank_of e >= least then expr ~depth e else "(" ^ expr ~depth e ^ ")"

(* A right operand: one that ends in an expression of its own may stand
   bare, as nothing follows it. *)
and right ~depth ~least e =
  match e with
  | Throw _ | If _ | When _ | Try _ -> expr ~depth e
  | _ -> bound ~depth ~least e

and receiver ~depth e = bound ~depth ~least:postfix_rank e

and arguments ~depth layout args =
  let one ~depth { label; value } =
    (match label with None -> "" | Some l -> simple l ^ " = ")
    ^ expr ~depth value
  in
  match (layout, args) with
  | _, [] -> "()"
  | Inline, _ -> "(" ^ String.concat ", " (List.map (one ~depth) args) ^ ")"
  | Lines, _ ->
      "(\n"
      ^ String.concat ""
          (List.map
             (fun a ->
               indentation (depth + 1) ^ one ~depth:(depth + 1) a ^ ",\n")
             args)
      ^ indentation depth ^ ")"

let rec stmt ~depth = function
  | Val (name, e) -> "val " ^ simple name ^ " = " ^ expr ~depth e
  | Return e -> "return " ^ expr ~depth e
  | If_then (c, s) -> "if (" ^ expr ~depth c ^ ") " ^ stmt ~depth s
  | Do e -> expr ~depth e

let visibility = function
  | Public -> "public "
  | Internal -> "internal "
  | Private -> "private "
  | Default -> ""

let annotation_text { target; name; args } =
  "@"
  ^ (match target with None -> "" | Some t -> simple t ^ ":")
  ^ checked name
  ^ match args with None -> "" | Some args -> arguments ~depth:0 Inline args

let annotation_lines ~depth annotations =
  List.map (fun a -> indentation depth ^ annotation_text a) annotations

let lines_text lines = String.concat "" (List.map (fun l -> l ^ "\n") lines)

let body_text ~depth = function
  | Same_line e -> " = " ^ expr ~depth e
  | Below e -> " =\n" ^ indentation (depth + 1) ^ expr ~depth:(depth + 1) e
  | Block stmts ->
      " {\n"
      ^ String.concat ""
          (List.map
             (fun s ->
               indentation (depth + 1) ^ stmt ~depth:(depth + 1) s ^ "\n")
             stmts)
      ^ indentation depth ^ "}"

let param_text ~depth { about; annotations; binding; name; type_ = t; default }
    =
  lines_text (about_lines ~depth about @ annotation_lines ~depth annotations)
  ^ indentation depth
  ^ (match binding with
    | Plain -> ""
    | Bound { visibility = v; mutable_ } ->
        visibility v ^ if mutable_ then "var " else "val ")
  ^ simple name ^ ": " ^ type_ t
  ^ (match default with None -> "" | Some d -> " = " ^ expr ~depth d)
  ^ ",\n"

let kind_text = function
  | Class -> "class"
  | Data_class -> "data class"
  | Enum_class -> "enum class"
  | Value_class -> "value class"
  | Interface -> "interface"
  | Sealed_interface -> "sealed interface"
  | Object -> "object"
  | Data_object -> "data object"
  | Companion_object -> "companion object"

let super_text ~depth { super = t; super_args; super_layout } =
  type_ t
  ^
  match super_args with
  | None -> ""
  | Some args -> arguments ~depth super_layout args

(* A member is annotated or documented: ktlint sets it a blank line apart,
   so a writer may not pack it. *)
let marked = function
  | Property { about; annotations; _ }
  | Function { about; annotations; _ }
  | Class_decl { about; annotations; _ } ->
      about <> None || annotations <> []
  | Typealias { about; _ } -> about <> None
  | Init _ | Packed _ -> true

let rec decl ~depth d =
  let at = indentation depth in
  match d with
  | Property
      {
        about;
        annotations;
        visibility = v;
        override;
        const;
        mutable_;
        name;
        type_ = t;
        value;
      } ->
      lines_text (about_lines ~depth about @ annotation_lines ~depth annotations)
      ^ at ^ visibility v
      ^ (if override then "override " else "")
      ^ (if const then "const " else "")
      ^ (if mutable_ then "var " else "val ")
      ^ simple name
      ^ (match t with None -> "" | Some t -> ": " ^ type_ t)
      ^ (match value with
        | None -> ""
        | Some (Block _) ->
            fail "the property %s has a block for its value" name
        | Some b -> body_text ~depth b)
      ^ "\n"
  | Function
      {
        about;
        annotations;
        visibility = v;
        override;
        name;
        params;
        returns;
        body;
      } ->
      lines_text (about_lines ~depth about @ annotation_lines ~depth annotations)
      ^ at ^ visibility v
      ^ (if override then "override " else "")
      ^ "fun " ^ simple name ^ "("
      ^ String.concat ", "
          (List.map (fun (p, t) -> simple p ^ ": " ^ type_ t) params)
      ^ ")"
      ^ (match returns with None -> "" | Some t -> ": " ^ type_ t)
      ^ body_text ~depth body ^ "\n"
  | Class_decl
      {
        about;
        annotations;
        visibility = v;
        kind;
        name;
        constructor;
        supers;
        entries;
        members;
      } ->
      let head =
        at ^ visibility v ^ kind_text kind
        ^ if kind = Companion_object then "" else " " ^ simple name
      in
      let constructor_text, multi_line =
        match constructor with
        | None -> ("", false)
        | Some
            {
              constructor_annotations;
              constructor_visibility;
              params;
              params_layout;
            } -> (
            let keyword =
              match (constructor_annotations, constructor_visibility) with
              | [], Default -> ""
              | annotations, v ->
                  " "
                  ^ String.concat ""
                      (List.map (fun a -> annotation_text a ^ " ") annotations)
                  ^ visibility v ^ "constructor"
            in
            match (params, params_layout) with
            | [], _ -> (keyword ^ "()", false)
            | params, Inline ->
                ( keyword ^ "("
                  ^ String.concat ", "
                      (List.map
                         (fun p ->
                           if p.about <> None || p.annotations <> [] then
                             fail
                               "the inline parameter %s is annotated or \
                                documented"
                               p.name;
                           let line = param_text ~depth:0 p in
                           String.sub line 0 (String.length line - 2))
                         params)
                  ^ ")",
                  false )
            | params, Lines ->
                ( keyword ^ "(\n"
                  ^ String.concat ""
                      (List.map (param_text ~depth:(depth + 1)) params)
                  ^ at ^ ")",
                  true ))
      in
      let supers_text =
        match supers with
        | [] -> ""
        | [ one ] -> " : " ^ super_text ~depth one
        | first :: rest when multi_line ->
            " : " ^ super_text ~depth first
            ^ String.concat ""
                (List.map
                   (fun s ->
                     ",\n" ^ indentation (depth + 1) ^ super_text ~depth s)
                   rest)
        | several ->
            " :"
            ^ String.concat ","
                (List.map
                   (fun s ->
                     "\n" ^ indentation (depth + 1) ^ super_text ~depth s)
                   several)
      in
      let entries_text =
        List.mapi
          (fun i { entry_about; entry_annotations; entry; entry_args } ->
            let marked = entry_about <> None || entry_annotations <> [] in
            (if i > 0 && marked then "\n" else "")
            ^ lines_text
                (about_lines ~depth:(depth + 1) entry_about
                @ annotation_lines ~depth:(depth + 1) entry_annotations)
            ^ indentation (depth + 1)
            ^ simple entry
            ^ (match entry_args with
              | [] -> ""
              | args -> arguments ~depth:(depth + 1) Inline args)
            ^ ",\n")
          entries
      in
      if kind <> Enum_class && entries <> [] then
        fail "%s has entries and is no enum" name;
      if kind = Enum_class && members <> [] then
        fail "the enum %s has members" name;
      lines_text (about_lines ~depth about @ annotation_lines ~depth annotations)
      ^ head ^ constructor_text ^ supers_text
      ^ (match (entries_text, members) with
        | [], [] -> ""
        | entries, [] -> " {\n" ^ String.concat "" entries ^ at ^ "}"
        | _, members ->
            " {\n" ^ members_text ~depth:(depth + 1) members ^ at ^ "}")
      ^ "\n"
  | Typealias { about; visibility = v; name; type_ = t } ->
      lines_text (about_lines ~depth about)
      ^ at ^ visibility v ^ "typealias " ^ simple name ^ " = " ^ type_ t ^ "\n"
  | Init stmts -> at ^ "init" ^ body_text ~depth (Block stmts) ^ "\n"
  | Packed members ->
      List.iter
        (fun m ->
          if marked m then fail "a packed member is annotated or documented")
        members;
      String.concat "" (List.map (decl ~depth) members)

and members_text ~depth members =
  String.concat "\n" (List.map (decl ~depth) members)

(* The imports in ktlint's order: every other first, then [java], [javax]
   and [kotlin]'s, each run in the order of their names. *)
let import_order imports =
  let run name =
    List.find_index
      (fun prefix -> String.starts_with ~prefix name)
      [ "java."; "javax."; "kotlin." ]
    |> Option.fold ~none:0 ~some:(fun i -> i + 1)
  in
  let sorted = List.sort (fun a b -> compare (run a, a) (run b, b)) imports in
  let rec distinct = function
    | a :: (b :: _ as rest) ->
        if a = b then fail "%s is imported twice" a else distinct rest
    | _ -> ()
  in
  distinct sorted;
  sorted

(* The names [decls] write unqualified, or begin a qualified name with, and
   the members they reach: what an import could supply. *)
let referenced decls =
  let first name =
    match String.index_opt name '.' with
    | None -> name
    | Some i -> String.sub name 0 i
  in
  let rec of_type = function
    | Type name -> [ first name ]
    | Generic (name, args) -> first name :: List.concat_map of_type args
    | Nullable t -> of_type t
    | Star -> []
    | Function_type (params, result) ->
        List.concat_map of_type (result :: params)
  in
  let rec of_expr = function
    | Name name | Class_literal name -> [ first name ]
    | Reference (owner, _) -> [ first owner ]
    | This | Null | Bool _ | Str _ | Ascii _ | Int _ | Hex _ | Char _ -> []
    | Call { callee; types; args; lambda; layout = _ } ->
        of_expr callee
        @ List.concat_map of_type types
        @ of_args args
        @ Option.fold ~none:[] ~some:of_expr lambda
    | Member (e, name) -> name :: of_expr e
    | Not e | Throw e -> of_expr e
    | Binary (a, _, b) -> of_expr a @ of_expr b
    | Lambda (_, e) -> of_expr e
    | Assigning (a, b) -> of_expr a @ of_expr b
    | When { subject; branches } ->
        Option.fold ~none:[] ~some:of_expr subject
        @ List.concat_map
            (fun { conditions; result } ->
              of_expr result
              @ List.concat_map (fun (Equal e) -> of_expr e) conditions)
            branches
    | If (a, b, c) -> of_expr a @ of_expr b @ of_expr c
    | Try { body; caught = _, t; handler } ->
        of_expr body @ of_type t @ of_expr handler
  and of_args args =
    List.concat_map (fun { value; label = _ } -> of_expr value) args
  in
  let rec of_stmt = function
    | Val (_, e) | Return e | Do e -> of_expr e
    | If_then (e, s) -> of_expr e @ of_stmt s
  in
  let of_annotations =
    List.concat_map (fun { name; args; target = _ } ->
        first name :: Option.fold ~none:[] ~some:of_args args)
  in
  let of_body = function
    | Same_line e | Below e -> of_expr e
    | Block stmts -> List.concat_map of_stmt stmts
  in
  let of_param { annotations; type_ = t; default; _ } =
    of_annotations annotations @ of_type t
    @ Option.fold ~none:[] ~some:of_expr default
  in
  let rec of_decl = function
    | Property { annotations; type_ = t; value; _ } ->
        of_annotations annotations
        @ Option.fold ~none:[] ~some:of_type t
        @ Option.fold ~none:[] ~some:of_body value
    | Function { annotations; params; returns; body; _ } ->
        of_annotations annotations
        @ List.concat_map (fun (_, t) -> of_type t) params
        @ Option.fold ~none:[] ~some:of_type returns
        @ of_body body
    | Class_decl { annotations; constructor; supers; entries; members; _ } ->
        of_annotations annotations
        @ Option.fold ~none:[]
            ~some:(fun { constructor_annotations; params; _ } ->
              of_annotations constructor_annotations
              @ List.concat_map of_param params)
            constructor
        @ List.concat_map
            (fun { super = t; super_args; _ } ->
              of_type t @ Option.fold ~none:[] ~some:of_args super_args)
            supers
        @ List.concat_map
            (fun { entry_annotations; entry_args; _ } ->
              of_annotations entry_annotations @ of_args entry_args)
            entries
        @ List.concat_map of_decl members
    | Typealias { type_ = t; _ } -> of_type t
    | Init stmts -> List.concat_map of_stmt stmts
    | Packed decls -> List.concat_map of_decl decls
  in
  List.sort_uniq String.compare (List.concat_map of_decl decls)

let text { banner; file_annotations; package; imports; decls } =
  lines_text (List.map (fun l -> if l = "" then "//" else "// " ^ l) banner)
  ^ lines_text
      (List.map
         (fun a -> annotation_text { a with target = Some "file" })
         file_annotations)
  ^ "\npackage " ^ checked package ^ "\n\n"
  ^ (match imports with
    | [] -> ""
    | imports ->
        lines_text
          (List.map (fun i -> "import " ^ checked i) (import_order imports))
        ^ "\n")
  ^ String.concat "\n" (List.map (decl ~depth:0) decls)

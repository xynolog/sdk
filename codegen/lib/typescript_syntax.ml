(* TypeScript as the generator writes it: the declarations of a generated
   module, the types and values they hold, and the few statements a table's
   own dispatch needs, with a printer that writes them. A writer builds a
   module of these and never a line of TypeScript: a name is checked to be
   one, a string is quoted and escaped by the printer, a comment's markers
   are the printer's, and every bracket it opens it closes.

   What a generated module holds is what Protocol derives: constants, types,
   interfaces, the table's data, and a dispatch whose body is the table.
   Logic that no table varies is the SDK's own, written by hand beside it.

   Prettier lays out what the printer writes (make generate runs it), so the
   printer states only what Prettier keeps: an object, an object type, a
   mapped type and a conditional type on one line ([Inline]) or a row a line
   ([Rows]), a comment's lines, and a blank line between top-level
   declarations. An array is written an element a line, and Prettier puts it
   on one when it fits; a string is in single quotes, as Prettier's
   configuration writes it. *)

(* [Doc] is a doc comment on one line; [Block] one of several lines; [Line]
   a line comment. [Doc_prose] and [Line_prose] are a spec's prose as a doc
   comment and as line comments, wrapped within [comment_width] columns; a
   doc of one paragraph that fits is on one line. [Gap] is a blank line,
   where a listing breaks. *)
type comment =
  | Doc of string
  | Block of string list
  | Line of string
  | Doc_prose of Text.paragraph list
  | Line_prose of Text.paragraph list
  | Gap

type layout = Inline | Rows
type key = Ident of string | Quoted of string

type type_ =
  | T_name of string
  | T_str of string
  | T_int of int
  | T_bool of bool
  | T_index of type_ * type_  (** [t[k]] *)
  | T_generic of string * type_ list
  | T_union of type_ list  (** On one line. *)
  | T_cases of case list  (** A case a line, each behind its [|]. *)
  | T_intersection of type_ list
  | T_object of layout * member list
  | T_index_signature of type_  (** [{ [key: string]: t }] *)
  | T_keyof of type_
  | T_typeof of string
  | T_paren of type_
  | T_array of type_  (** [t[]] *)
  | T_readonly of type_
  | T_predicate of string * type_  (** [name is t]: what a guard returns. *)
  | T_function of (string * type_) list * type_
      (** [(name: t, ...) => r]: what a callback a type holds is. *)
  | T_mapped of {
      layout : layout;
      readonly : bool;
      key : string;
      in_ : type_;
      value : type_;
    }  (** [{ [key in in_]: value }] *)
  | T_conditional of {
      layout : layout;
          (** [Rows] puts the [?] and the [:] each on a line of its own. *)
      check : type_;
      extends : type_;
      then_ : type_;
      else_ : type_;
    }

and case = { case_about : comment list; case : type_ }

and member = {
  about : comment list;
  readonly : bool;
  key : key;
  optional : bool;
  type_ : type_;
  member_trailing : string;
      (** A line comment's text after it, on its line; [""] for none. *)
}

type binary = And | Or | Strict_eq | Ge | Plus

type expr =
  | Name of string
  | Str of string
  | Int of int
  | Hex of string  (** Hexadecimal digits, written after [0x]. *)
  | Octal of string  (** Octal digits, written after [0o]. *)
  | Bool of bool
  | Null
  | Undefined
  | Array of element list
  | Object of { layout : layout; entries : entry list }
  | Json of Yojson.Safe.t  (** As JSON writes it, on one line. *)
  | Json_rows of Yojson.Safe.t  (** As JSON writes it, a member a line. *)
  | New of string * expr list
  | Call of expr * expr list
  | Instantiate of expr * type_ list  (** [e<t, ...>] *)
  | Member of expr * string  (** [e.name] *)
  | Index of expr * expr  (** [e[k]] *)
  | Binary of expr * binary * expr
  | Chain of binary * expr list
      (** Operands joined by one operator, each after the first on a line of its
          own. *)
  | Paren of expr
  | Template of template list

and template = Text of string | Hole of expr
and element = { element_about : comment list; value : expr; trailing : string }

and entry = {
  entry_about : comment list;
  entry_key : key;
  entry_value : expr;
  entry_trailing : string;
}

type stmt =
  | Return of expr
  | Throw of expr
  | If of expr * stmt  (** On one line. *)
  | Switch of expr * (expr * stmt) list  (** Each case on one line. *)

type param = { name : string; type_ : type_ }

(* [name extends bound]. *)
type type_param = { param : string; bound : type_ option }
type import = { type_only : bool; names : string list; from : string }

type decl =
  | Import of import
  | Comment of comment list
  | Const of {
      about : comment list;
      export : bool;
      name : string;
      annotation : type_ option;
      value : expr;
      as_const : bool;
      satisfies : type_ option;
    }
  | Type of {
      about : comment list;
      export : bool;
      name : string;
      params : type_param list;
      type_ : type_;
    }
  | Interface of {
      about : comment list;
      export : bool;
      name : string;
      members : member list;
    }
  | Function of {
      about : comment list;
      export : bool;
      name : string;
      params : param list;
      returns : type_;
      body : stmt list;
    }
  | Adjacent of decl list  (** Declarations with no blank line between. *)

type module_ = {
  banner : string list;  (** Line comments, each written after a [//]. *)
  body : decl list;
}

let element ?(about = []) ?(trailing = "") value =
  { element_about = about; value; trailing }

let entry ?(about = []) ?(trailing = "") key value =
  {
    entry_about = about;
    entry_key = key;
    entry_value = value;
    entry_trailing = trailing;
  }

let member ?(about = []) ?(readonly = false) ?(optional = false)
    ?(trailing = "") key type_ =
  { about; readonly; key; optional; type_; member_trailing = trailing }

let case ?(about = []) case = { case_about = about; case }
let array values = Array (List.map element values)
let strings texts = array (List.map (fun t -> Str t) texts)
let rows entries = Object { layout = Rows; entries }

(* [components['schemas'][name]]: a component schema's type. *)
let schema name =
  T_index (T_index (T_name "components", T_str "schemas"), T_str name)

let const ?(about = []) ?(export = true) ?annotation ?(as_const = false)
    ?satisfies name value =
  Const { about; export; name; annotation; value; as_const; satisfies }

let type_alias ?(about = []) ?(export = true) ?(params = []) name type_ =
  Type { about; export; name; params; type_ }

let import ?(type_only = false) names from = Import { type_only; names; from }

let is_word = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' | '$' -> true
  | _ -> false

let identifier name =
  name <> ""
  && (match name.[0] with '0' .. '9' -> false | _ -> true)
  && String.for_all is_word name

(* A name, or one qualified by what it is within. *)
let checked name =
  if List.for_all identifier (String.split_on_char '.' name) then name
  else invalid_arg (Printf.sprintf "Typescript_syntax: %S is no name" name)

let digits ~ok what text =
  if text <> "" && String.for_all ok text then text
  else invalid_arg (Printf.sprintf "Typescript_syntax: %S is no %s" text what)

(* A string in single quotes, with a quote, a backslash and the control
   characters escaped, and every other character as itself. *)
let literal text =
  let out = Buffer.create (String.length text + 2) in
  Buffer.add_char out '\'';
  String.iter
    (function
      | '\'' -> Buffer.add_string out "\\'"
      | '\\' -> Buffer.add_string out "\\\\"
      | '\n' -> Buffer.add_string out "\\n"
      | '\r' -> Buffer.add_string out "\\r"
      | '\t' -> Buffer.add_string out "\\t"
      | c when Char.code c < 0x20 ->
          Buffer.add_string out (Printf.sprintf "\\x%02x" (Char.code c))
      | c -> Buffer.add_char out c)
    text;
  Buffer.add_char out '\'';
  Buffer.contents out

let key = function Ident name -> checked name | Quoted text -> literal text
let indentation depth = String.make (2 * depth) ' '

let refuse_newline what text =
  if String.contains text '\n' then
    invalid_arg
      (Printf.sprintf "Typescript_syntax: %s %S is two lines" what text)

let comment_width = 80

(* [comment]'s lines at [depth]. *)
let comment_lines ~depth comment =
  let at = indentation depth in
  match comment with
  | Doc text ->
      refuse_newline "a doc comment" text;
      [ at ^ Text.doc_comment text ]
  | Line text ->
      refuse_newline "a line comment" text;
      [ at ^ "// " ^ text ]
  | Block lines ->
      List.iter (refuse_newline "a doc comment's line") lines;
      (at ^ "/**")
      :: List.map
           (fun l ->
             at ^ " *"
             ^
             if l = "" then ""
             else " " ^ Text.replace_all ~sub:"*/" ~by:"*\\/" l)
           lines
      @ [ at ^ " */" ]
  | Doc_prose paragraphs -> (
      let escape = Text.replace_all ~sub:"*/" ~by:"*\\/" in
      match paragraphs with
      | [ Text.Words text ]
        when Text.length (at ^ Text.doc_comment text) <= comment_width ->
          [ at ^ Text.doc_comment text ]
      | _ ->
          (at ^ "/**")
          :: List.map
               (fun l -> at ^ " *" ^ if l = "" then "" else " " ^ escape l)
               (Text.paragraphs ~lead:(at ^ " * ") ~width:comment_width
                  paragraphs)
          @ [ at ^ " */" ])
  | Line_prose paragraphs ->
      List.map
        (fun l -> at ^ "//" ^ if l = "" then "" else " " ^ l)
        (Text.paragraphs ~lead:(at ^ "// ") ~width:comment_width paragraphs)
  | Gap -> [ "" ]

let comments ~depth about = List.concat_map (comment_lines ~depth) about

(* A line comment after a row, on its line; [""] is none. *)
let trailing_comment = function
  | "" -> ""
  | note ->
      refuse_newline "a trailing comment" note;
      " // " ^ note

(* How tightly an operator binds, as JavaScript ranks them. *)
let precedence = function
  | Or -> 3
  | And -> 4
  | Strict_eq -> 8
  | Ge -> 9
  | Plus -> 11

let binary = function
  | And -> "&&"
  | Or -> "||"
  | Strict_eq -> "==="
  | Ge -> ">="
  | Plus -> "+"

let rec type_ ~depth = function
  | T_name name -> checked name
  | T_str text -> literal text
  | T_int n -> string_of_int n
  | T_bool b -> string_of_bool b
  | T_index (t, k) -> type_ ~depth t ^ "[" ^ type_ ~depth k ^ "]"
  | T_generic (name, args) ->
      checked name ^ "<"
      ^ String.concat ", " (List.map (type_ ~depth) args)
      ^ ">"
  | T_union ts -> String.concat " | " (List.map (type_ ~depth) ts)
  | T_cases cases ->
      String.concat ""
        (List.map
           (fun { case_about; case } ->
             "\n"
             ^ String.concat ""
                 (List.map
                    (fun l -> l ^ "\n")
                    (comments ~depth:(depth + 1) case_about))
             ^ indentation (depth + 1)
             ^ "| "
             ^ type_ ~depth:(depth + 1) case)
           cases)
  | T_intersection ts -> String.concat " & " (List.map (type_ ~depth) ts)
  | T_object (layout, members) -> object_type ~depth layout members
  | T_index_signature t -> "{ [key: string]: " ^ type_ ~depth t ^ " }"
  | T_keyof t -> "keyof " ^ type_ ~depth t
  | T_typeof name -> "typeof " ^ checked name
  | T_paren t -> "(" ^ type_ ~depth t ^ ")"
  | T_array t -> type_ ~depth t ^ "[]"
  | T_readonly t -> "readonly " ^ type_ ~depth t
  | T_predicate (name, t) -> checked name ^ " is " ^ type_ ~depth t
  | T_function (params, returns) ->
      "("
      ^ String.concat ", "
          (List.map
             (fun (name, t) -> checked name ^ ": " ^ type_ ~depth t)
             params)
      ^ ") => " ^ type_ ~depth returns
  | T_mapped { layout; readonly; key; in_; value } -> (
      let inner ~depth =
        (if readonly then "readonly " else "")
        ^ "[" ^ checked key ^ " in " ^ type_ ~depth in_ ^ "]: "
        ^ type_ ~depth value
      in
      match layout with
      | Inline -> "{ " ^ inner ~depth ^ " }"
      | Rows ->
          "{\n"
          ^ indentation (depth + 1)
          ^ inner ~depth:(depth + 1)
          ^ ";\n" ^ indentation depth ^ "}")
  | T_conditional { layout; check; extends; then_; else_ } ->
      let gap =
        match layout with
        | Inline -> " "
        | Rows -> "\n" ^ indentation (depth + 1)
      in
      type_ ~depth check ^ " extends " ^ type_ ~depth extends ^ gap ^ "? "
      ^ type_ ~depth:(depth + 1) then_
      ^ gap ^ ": "
      ^ type_ ~depth:(depth + 1) else_

and member_text ~depth m =
  (if m.readonly then "readonly " else "")
  ^ key m.key
  ^ (if m.optional then "?" else "")
  ^ ": " ^ type_ ~depth m.type_ ^ ";"

and object_type ~depth layout members =
  match (layout, members) with
  | _, [] -> "{}"
  | Inline, _ ->
      List.iter
        (fun m ->
          if m.about <> [] || m.member_trailing <> "" then
            invalid_arg "Typescript_syntax: a comment on one line")
        members;
      let texts = List.map (member_text ~depth) members in
      let joined = String.concat " " texts in
      "{ " ^ String.sub joined 0 (String.length joined - 1) ^ " }"
  | Rows, _ ->
      "{\n"
      ^ String.concat ""
          (List.map
             (fun m ->
               String.concat ""
                 (List.map
                    (fun l -> l ^ "\n")
                    (comments ~depth:(depth + 1) m.about))
               ^ indentation (depth + 1)
               ^ member_text ~depth:(depth + 1) m
               ^ trailing_comment m.member_trailing
               ^ "\n")
             members)
      ^ indentation depth ^ "}"

let rec json_rows ~depth (value : Yojson.Safe.t) =
  match value with
  | `Assoc [] -> "{}"
  | `Assoc members ->
      "{\n"
      ^ String.concat ",\n"
          (List.map
             (fun (k, v) ->
               indentation (depth + 1)
               ^ Text.quoted k ^ ": "
               ^ json_rows ~depth:(depth + 1) v)
             members)
      ^ "\n" ^ indentation depth ^ "}"
  | `List [] -> "[]"
  | `List items ->
      "[\n"
      ^ String.concat ",\n"
          (List.map
             (fun v -> indentation (depth + 1) ^ json_rows ~depth:(depth + 1) v)
             items)
      ^ "\n" ^ indentation depth ^ "]"
  | v -> Yojson.Safe.to_string v

let rec expr ~depth = function
  | Name name -> checked name
  | Str text -> literal text
  | Int n -> string_of_int n
  | Hex d ->
      "0x"
      ^ digits
          ~ok:(function
            | '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' -> true | _ -> false)
          "hexadecimal" d
  | Octal d ->
      "0o" ^ digits ~ok:(function '0' .. '7' -> true | _ -> false) "octal" d
  | Bool b -> string_of_bool b
  | Null -> "null"
  | Undefined -> "undefined"
  | Array [] -> "[]"
  | Array elements ->
      "[\n"
      ^ String.concat ""
          (List.map
             (fun e ->
               row ~depth e.element_about
                 (expr ~depth:(depth + 1) e.value ^ ",")
                 e.trailing)
             elements)
      ^ indentation depth ^ "]"
  | Object { layout; entries } -> (
      match (layout, entries) with
      | _, [] -> "{}"
      | Inline, _ ->
          "{ "
          ^ String.concat ", " (List.map (inline_entry ~depth) entries)
          ^ " }"
      | Rows, _ ->
          "{\n"
          ^ String.concat ""
              (List.map
                 (fun e ->
                   row ~depth e.entry_about
                     (key e.entry_key ^ ": "
                     ^ expr ~depth:(depth + 1) e.entry_value
                     ^ ",")
                     e.entry_trailing)
                 entries)
          ^ indentation depth ^ "}")
  | Json v -> Yojson.Safe.to_string v
  | Json_rows v -> json_rows ~depth v
  | New (name, args) ->
      "new " ^ checked name ^ "(" ^ arguments ~depth args ^ ")"
  | Call (f, args) -> expr ~depth f ^ "(" ^ arguments ~depth args ^ ")"
  | Instantiate (e, types) ->
      expr ~depth e ^ "<"
      ^ String.concat ", " (List.map (type_ ~depth) types)
      ^ ">"
  | Member (e, name) -> expr ~depth e ^ "." ^ checked name
  | Index (e, k) -> expr ~depth e ^ "[" ^ expr ~depth k ^ "]"
  | Binary (a, op, b) ->
      operand ~depth ~within:op ~left:true a
      ^ " " ^ binary op ^ " "
      ^ operand ~depth ~within:op ~left:false b
  | Chain (op, operands) ->
      String.concat
        ("\n" ^ indentation (depth + 1) ^ binary op ^ " ")
        (List.mapi
           (fun i e -> operand ~depth ~within:op ~left:(i = 0) e)
           operands)
  | Paren e -> "(" ^ expr ~depth e ^ ")"
  | Template parts ->
      "`"
      ^ String.concat ""
          (List.map
             (function
               | Text t ->
                   Text.replace_all ~sub:"`" ~by:"\\`"
                     (Text.replace_all ~sub:"${" ~by:"\\${"
                        (Text.replace_all ~sub:"\\" ~by:"\\\\" t))
               | Hole e -> "${" ^ expr ~depth e ^ "}")
             parts)
      ^ "`"

(* An operand that is another operation is written in parentheses only where
   the writer puts them ([Paren]). One left bare is written so when it binds
   tighter than the operation it is [within], or as tightly and on its left;
   any other is refused, since it would be read otherwise. *)
and operand ~depth ~within ~left = function
  | Binary (_, op, _) as e
    when precedence op > precedence within
         || (left && precedence op = precedence within) ->
      expr ~depth e
  | (Binary _ | Chain _) as e ->
      invalid_arg
        (Printf.sprintf
           "Typescript_syntax: an operand %s is another operation, which needs \
            parentheses"
           (expr ~depth e))
  | e -> expr ~depth e

and inline_entry ~depth e =
  if e.entry_about <> [] || e.entry_trailing <> "" then
    invalid_arg "Typescript_syntax: a comment on one line";
  key e.entry_key ^ ": " ^ expr ~depth e.entry_value

and arguments ~depth args = String.concat ", " (List.map (expr ~depth) args)

and row ~depth about text trailing =
  String.concat ""
    (List.map (fun l -> l ^ "\n") (comments ~depth:(depth + 1) about))
  ^ indentation (depth + 1)
  ^ text ^ trailing_comment trailing ^ "\n"

let rec stmt ~depth = function
  | Return e -> "return " ^ expr ~depth e ^ ";"
  | Throw e -> "throw " ^ expr ~depth e ^ ";"
  | If (cond, s) -> "if (" ^ expr ~depth cond ^ ") " ^ stmt ~depth s
  | Switch (subject, cases) ->
      "switch (" ^ expr ~depth subject ^ ") {\n"
      ^ String.concat ""
          (List.map
             (fun (c, s) ->
               indentation (depth + 1)
               ^ "case " ^ expr ~depth c ^ ": "
               ^ stmt ~depth:(depth + 1) s
               ^ "\n")
             cases)
      ^ indentation depth ^ "}"

let exported export = if export then "export " else ""

let import_text { type_only; names; from } =
  "import"
  ^ (if type_only then " type" else "")
  ^ " { "
  ^ String.concat ", " (List.map checked names)
  ^ " } from " ^ literal from ^ ";"

let lines_of about =
  List.map (fun l -> l ^ "\n") (comments ~depth:0 about) |> String.concat ""

let rec decl = function
  | Import i -> import_text i
  | Comment about -> String.concat "\n" (comments ~depth:0 about)
  | Const { about; export; name; annotation; value; as_const; satisfies } ->
      lines_of about ^ exported export ^ "const " ^ checked name
      ^ (match annotation with None -> "" | Some t -> ": " ^ type_ ~depth:0 t)
      ^ " = " ^ expr ~depth:0 value
      ^ (if as_const then " as const" else "")
      ^ (match satisfies with
        | None -> ""
        | Some t -> " satisfies " ^ type_ ~depth:0 t)
      ^ ";"
  | Type { about; export; name; params; type_ = t } ->
      lines_of about ^ exported export ^ "type " ^ checked name
      ^ (match params with
        | [] -> ""
        | params ->
            "<"
            ^ String.concat ", "
                (List.map
                   (fun { param; bound } ->
                     checked param
                     ^
                     match bound with
                     | None -> ""
                     | Some b -> " extends " ^ type_ ~depth:0 b)
                   params)
            ^ ">")
      ^ " ="
      ^ (match t with
        | T_cases _ -> type_ ~depth:0 t
        | T_conditional { layout = Rows; _ } ->
            "\n" ^ indentation 1 ^ type_ ~depth:1 t
        | _ -> " " ^ type_ ~depth:0 t)
      ^ ";"
  | Interface { about; export; name; members } ->
      lines_of about ^ exported export ^ "interface " ^ checked name ^ " "
      ^ object_type ~depth:0 Rows members
  | Function { about; export; name; params; returns; body } ->
      lines_of about ^ exported export ^ "function " ^ checked name ^ "("
      ^ String.concat ", "
          (List.map
             (fun (p : param) -> checked p.name ^ ": " ^ type_ ~depth:0 p.type_)
             params)
      ^ "): " ^ type_ ~depth:0 returns ^ " {\n"
      ^ String.concat ""
          (List.map (fun s -> "  " ^ stmt ~depth:1 s ^ "\n") body)
      ^ "}"
  | Adjacent decls -> String.concat "\n" (List.map decl decls)

let text m =
  String.concat ""
    (List.map (fun l -> if l = "" then "//\n" else "// " ^ l ^ "\n") m.banner)
  ^ "\n"
  ^ String.concat "\n\n" (List.map decl m.body)
  ^ "\n"

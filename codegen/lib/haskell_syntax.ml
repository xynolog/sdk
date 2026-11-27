(* Haskell as the generator writes it: a generated module's declarations, the
   types and values they hold, and the few expressions a table's own
   dispatch needs, with a printer that writes them. A writer builds a module
   of these and never a line of Haskell: a name is checked to be one, a
   string is escaped by the printer, a comment's markers are the printer's,
   and what an application takes is parenthesised where it must be.

   What a generated module holds is what Protocol derives: types, the table's
   data, and a dispatch whose body is the table. Logic that no table varies
   is the SDK's own, written by hand beside it.

   The text is ormolu's fixed point, so the SDK's format check reads a
   generated module as it reads one written by hand. A blank line parts the
   module's head, its imports and each declaration; a declaration is a line,
   or a line a clause, and only a case, a do and a record put what they hold
   on lines of their own. Imports are in ormolu's order. The module exports
   every declaration it holds, in their order. *)

type type_ =
  | T_name of string
  | T_apply of string * type_ list  (** [Map.Map Text Text] *)
  | T_list of type_
  | T_tuple of type_ list
  | T_fun of type_ * type_
  | T_promoted of string  (** A constructor as a type: ['Global]. *)
  | T_constrained of (string * string) list * type_
      (** A type its variables' classes constrain: [Show a => a -> Text]. *)

(* What a clause or an alternative matches: a constructor matches what it
   holds by a pattern each, and a variable matches anything and names it. *)
type pattern =
  | Constructor of string * pattern list
  | Var of string
  | Literal of string
  | Otherwise

type expr =
  | Name of string
  | Str of string
  | Int of int
  | List of expr list
  | Tuple of expr list
  | Apply of expr * expr list
  | Compose of expr * expr  (** [f . g] *)
  | Dollar of expr * expr  (** [f $ x] *)
  | Lambda of string * expr  (** [\x -> e] *)
  | Case of expr * (pattern * expr) list
      (** An alternative a line, indented past the line it opens on. *)
  | Infix of expr * (string * expr) list
      (** [a op b op' c]: operands left to right, of operators of one precedence
          that associate to the left, so the writer states the grouping Haskell
          reads. An operand that is itself an operation is parenthesised. *)
  | Typed of expr * type_  (** [(e :: T)] *)
  | If of expr * expr * expr  (** [if c then a else b] *)
  | Section of string * expr
      (** [(op e)]: an operator, or a function named in backticks, waiting for
          its left operand. *)
  | Do of statement list  (** A statement a line, indented past [do]. *)
  | Construct of string * (string * expr) list
      (** [C { f = e, g = e' }]: a record built by its fields' names. *)

and statement = Bind of string * expr  (** [x <- e] *) | Run of expr

type constructor = { constructor : string; fields : type_ list }
type clause = { patterns : pattern list; body : expr }

(* What an import names of a module: one name, an operator, a type with all
   of its constructors, or a type with the ones listed; and what an export
   names besides, every name another module exports. *)
type item =
  | Plain of string
  | Op of string
  | All of string
  | With of string * string list
  | Module of string

type import = {
  module_ : string;
  qualified : string option;  (** [import M qualified as Q] *)
  items : item list option;  (** [None]: the whole module. *)
}

(* [about] is a doc comment's lines, the first written behind [-- |]. A type's
   [params] are its type variables. *)
type decl =
  | Data of {
      about : string list;
      name : string;
      params : string list;
      constructors : constructor list;
      deriving : string list;
    }
  | Record of {
      about : string list;
      name : string;
      params : string list;
      constructor : string;
      fields : (string * type_) list;
      deriving : string list;
    }  (** A type of one constructor, with named fields. *)
  | Newtype of {
      about : string list;
      name : string;
      constructor : string;
      field : string option;  (** The accessor, if the field is named. *)
      type_ : type_;
      opaque : bool;
          (** Exported without its constructor, so only the module makes one. *)
      deriving : string list;
    }  (** A type of one constructor holding one value. *)
  | Gadt of {
      about : string list;
      name : string;
      params : (string * string option) list;
          (** Each type variable, and the kind it is of if stated. *)
      constructors : (string * type_) list;
    }  (** A type whose constructors each state their own type. *)
  | Reexport of string
      (** Every name the module exports, which this one imports. *)
  | Alias of { about : string list; name : string; type_ : type_ }
  | Value of {
      about : string list;
      name : string;
      type_ : type_;
      clauses : clause list;
    }
  | Values of {
      about : string list;
      type_ : type_;
      values : (string * expr) list;
    }  (** Several values of one type, under one signature. *)
  | Class of {
      about : string list;
      name : string;
      param : string;
      methods : (string * type_) list;  (** Each method's name and type. *)
    }
  | Instance of {
      context : (string * string) list;
          (** The classes a type variable is of, as [ToJSON value =>]. *)
      class_ : string;
      instance : type_;
      methods : (string * clause) list;  (** A method's clauses, in order. *)
    }
  | Private of decl
      (** A declaration the module keeps to itself: it exports none of it. *)

type module_ = {
  banner : string list;  (** Line comments, each written after a [--]. *)
  extensions : string list;
  name : string;
  imports : import list;
  body : decl list;
}

let constructor ?(fields = []) constructor = { constructor; fields }

let data ?(about = []) ?(params = []) ?(deriving = []) name constructors =
  Data { about; name; params; constructors; deriving }

let record ?(about = []) ?(params = []) ?(deriving = []) ~constructor name
    fields =
  Record { about; name; params; constructor; fields; deriving }

let instance ?(context = []) class_ instance methods =
  Instance { context; class_; instance; methods }

(* A method of one clause that takes no arguments. *)
let method_ name body = (name, { patterns = []; body })
let alias ?(about = []) name type_ = Alias { about; name; type_ }

(* A record's field for its member [key]: the record's name begun lower case
   and the member's in Pascal case. *)
let field record key = String.uncapitalize_ascii record ^ Text.pascal key

let value ?(about = []) name type_ body =
  Value { about; name; type_; clauses = [ { patterns = []; body } ] }

let import ?qualified ?items module_ = { module_; qualified; items }

let is_word = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' | '\'' -> true
  | _ -> false

let identifier name =
  name <> ""
  && (match name.[0] with 'A' .. 'Z' | 'a' .. 'z' | '_' -> true | _ -> false)
  && String.for_all is_word name

(* A name, or one qualified by the module it is of. *)
let checked name =
  if List.for_all identifier (String.split_on_char '.' name) then name
  else invalid_arg (Printf.sprintf "Haskell_syntax: %S is no name" name)

(* A type variable, or a variable a pattern binds: a name that starts lower
   case. *)
let variable name =
  match checked name with
  | name when match name.[0] with 'a' .. 'z' | '_' -> true | _ -> false ->
      name
  | name ->
      invalid_arg (Printf.sprintf "Haskell_syntax: %S is no variable" name)

(* An operator: a symbol, or a run of them, of the ones Haskell's operators
   are made of. *)
let operator symbol =
  if
    symbol <> ""
    && String.for_all
         (fun c -> String.contains "!#$%&*+./<=>?@\\^|-~:" c)
         symbol
  then symbol
  else invalid_arg (Printf.sprintf "Haskell_syntax: %S is no operator" symbol)

(* A string literal: a quote and a backslash escaped, printable ASCII as
   itself, and every other character by its code point, ended by \& so a
   digit after it is not read as more of it. *)
let literal text =
  let out = Buffer.create (String.length text + 2) in
  Buffer.add_char out '"';
  Text.fold_uchars
    (fun () u ->
      match Uchar.to_int u with
      | (0x22 | 0x5C) as c ->
          Buffer.add_char out '\\';
          Buffer.add_char out (Char.chr c)
      | c when c >= 0x20 && c <= 0x7E -> Buffer.add_char out (Char.chr c)
      | c -> Buffer.add_string out (Printf.sprintf "\\x%x\\&" c))
    () text;
  Buffer.add_char out '"';
  Buffer.contents out

let indentation depth = String.make (2 * depth) ' '
let tuple items = "(" ^ String.concat ", " items ^ ")"
let listed items = "[" ^ String.concat ", " items ^ "]"

let rec type_ = function
  | T_name name -> checked name
  | T_apply (name, args) ->
      String.concat " " (checked name :: List.map type_argument args)
  | T_list t -> "[" ^ type_ t ^ "]"
  | T_tuple ts -> tuple (List.map type_ ts)
  | T_fun (a, b) ->
      (match a with T_fun _ -> "(" ^ type_ a ^ ")" | _ -> type_ a)
      ^ " -> " ^ type_ b
  | T_promoted name -> "'" ^ checked name
  | T_constrained (context, t) -> constraint_ context ^ type_ t

and constraint_ = function
  | [] -> ""
  | cs ->
      tuple (List.map (fun (c, v) -> checked c ^ " " ^ variable v) cs) ^ " => "

and type_argument = function
  | (T_apply _ | T_fun _ | T_constrained _) as t -> "(" ^ type_ t ^ ")"
  | t -> type_ t

let rec pattern = function
  | Constructor (name, []) -> checked name
  | Constructor (name, held) ->
      "(" ^ String.concat " " (checked name :: List.map pattern held) ^ ")"
  | Var name -> variable name
  | Literal text -> literal text
  | Otherwise -> "_"

let rec expr ~depth = function
  | Name name -> checked name
  | Str text -> literal text
  | Int n -> string_of_int n
  | List items -> listed (List.map (expr ~depth) items)
  | Tuple items -> tuple (List.map (expr ~depth) items)
  | Apply (f, args) ->
      String.concat " " (applied ~depth f :: List.map (argument ~depth) args)
  | Compose (f, g) -> applied ~depth f ^ " . " ^ applied ~depth g
  | Dollar (f, x) -> applied ~depth f ^ " $ " ^ expr ~depth x
  | Lambda (name, body) -> "\\" ^ checked name ^ " -> " ^ expr ~depth body
  | Case (subject, alternatives) ->
      "case " ^ expr ~depth subject ^ " of"
      ^ String.concat ""
          (List.map
             (fun (p, body) ->
               "\n"
               ^ indentation (depth + 1)
               ^ pattern p ^ " -> "
               ^ expr ~depth:(depth + 1) body)
             alternatives)
  | Infix (first, rest) ->
      String.concat " "
        (operand ~depth first
        :: List.concat_map
             (fun (symbol, e) -> [ operator symbol; operand ~depth e ])
             rest)
  | Typed (e, t) -> "(" ^ expr ~depth e ^ " :: " ^ type_ t ^ ")"
  | If (c, a, b) ->
      "if " ^ expr ~depth c ^ " then " ^ expr ~depth a ^ " else "
      ^ expr ~depth b
  | Section (op, e) ->
      let op = if identifier op then "`" ^ op ^ "`" else operator op in
      "(" ^ op ^ " " ^ operand ~depth e ^ ")"
  | Construct (name, fields) ->
      checked name ^ " {"
      ^ String.concat ", "
          (List.map (fun (f, e) -> variable f ^ " = " ^ expr ~depth e) fields)
      ^ "}"
  | Do statements ->
      "do"
      ^ String.concat ""
          (List.map
             (fun s ->
               "\n"
               ^ indentation (depth + 1)
               ^
               match s with
               | Bind (name, e) ->
                   variable name ^ " <- " ^ expr ~depth:(depth + 1) e
               | Run e -> expr ~depth:(depth + 1) e)
             statements)

(* What an operator takes, and what is applied: an application binds tighter
   than either. *)
and applied ~depth = function
  | (Compose _ | Dollar _ | Lambda _ | Case _ | Infix _ | If _ | Do _) as e ->
      "(" ^ expr ~depth e ^ ")"
  | e -> expr ~depth e

and operand ~depth = applied ~depth

and argument ~depth = function
  | ( Apply _ | Compose _ | Dollar _ | Lambda _ | Case _ | Infix _ | If _ | Do _
    | Construct _ ) as e ->
      "(" ^ expr ~depth e ^ ")"
  | e -> expr ~depth e

let doc about =
  List.mapi
    (fun i line ->
      if String.contains line '\n' then
        invalid_arg
          (Printf.sprintf "Haskell_syntax: a doc comment's line %S is two lines"
             line);
      (if i = 0 then "-- | " else "-- ") ^ line)
    about

let item = function
  | Plain name -> checked name
  | Op symbol -> "(" ^ operator symbol ^ ")"
  | All name -> checked name ^ " (..)"
  | With (name, constructors) ->
      checked name ^ " ("
      ^ String.concat ", " (List.map checked constructors)
      ^ ")"
  | Module name -> "module " ^ checked name

(* Ormolu's order of what an import names: names before operators, each by
   its spelling. *)
let item_order = function
  | Op symbol -> (1, symbol)
  | Plain name | All name | With (name, _) | Module name -> (0, name)

let import_line { module_; qualified; items } =
  "import " ^ checked module_
  ^ (match qualified with None -> "" | Some q -> " qualified as " ^ checked q)
  ^
  match items with
  | None -> ""
  | Some items ->
      let items =
        List.sort
          (fun a b -> compare (item_order a) (item_order b))
          (List.map
             (function
               | With (name, constructors) ->
                   With (name, List.sort String.compare constructors)
               | item -> item)
             items)
      in
      " (" ^ String.concat ", " (List.map item items) ^ ")"

let exports = function
  | Data { name; _ } | Record { name; _ } | Gadt { name; _ } | Class { name; _ }
    ->
      [ All name ]
  | Newtype { name; opaque; _ } -> [ (if opaque then Plain name else All name) ]
  | Reexport name -> [ Module name ]
  | Alias { name; _ } | Value { name; _ } -> [ Plain name ]
  | Values { values; _ } -> List.map (fun (name, _) -> Plain name) values
  | Instance _ | Private _ -> []

let deriving_ classes = "deriving " ^ tuple (List.map checked classes)
let deriving_clause = function [] -> "" | classes -> " " ^ deriving_ classes

(* A record's fields a line each, ended by a comma but the last, and its
   deriving clause on a line of its own after the brace. *)
let record_lines fields deriving =
  let last = List.length fields - 1 in
  List.mapi
    (fun i (field, t) ->
      (if i = 0 then "  { " else "    ")
      ^ variable field ^ " :: " ^ type_ t
      ^ if i = last then "" else ",")
    fields
  @ "  }"
    ::
    (match deriving with
    | [] -> []
    | classes -> [ "  " ^ deriving_ classes ])

let head name params =
  String.concat " " (checked name :: List.map variable params)

let clause_line name { patterns; body } =
  String.concat " " (checked name :: List.map pattern patterns)
  ^ " = " ^ expr ~depth:0 body

let rec decl = function
  | Private d -> decl d
  | Data { about; name; params; constructors; deriving } ->
      doc about
      @ [
          "data " ^ head name params ^ " = "
          ^ String.concat " | "
              (List.map
                 (fun { constructor; fields } ->
                   String.concat " "
                     (checked constructor :: List.map type_argument fields))
                 constructors)
          ^ deriving_clause deriving;
        ]
  | Record { name; fields = []; _ } ->
      invalid_arg
        (Printf.sprintf "Haskell_syntax: the record %S has no fields" name)
  | Record { about; name; params; constructor; fields; deriving } ->
      doc about
      @ ("data " ^ head name params ^ " = " ^ checked constructor)
        :: record_lines fields deriving
  | Newtype { about; name; constructor; field; type_ = t; deriving; _ } ->
      doc about
      @ [
          "newtype " ^ checked name ^ " = " ^ checked constructor
          ^ (match field with
            | None -> " " ^ type_argument t
            | Some field -> " {" ^ variable field ^ " :: " ^ type_ t ^ "}")
          ^ deriving_clause deriving;
        ]
  | Gadt { name; constructors = []; _ } ->
      invalid_arg
        (Printf.sprintf "Haskell_syntax: the type %S has no constructors" name)
  | Gadt { about; name; params; constructors } ->
      doc about
      @ ("data "
        ^ String.concat " "
            (checked name
            :: List.map
                 (function
                   | v, None -> variable v
                   | v, Some kind ->
                       "(" ^ variable v ^ " :: " ^ checked kind ^ ")")
                 params)
        ^ " where")
        :: List.map
             (fun (constructor, t) ->
               indentation 1 ^ checked constructor ^ " :: " ^ type_ t)
             constructors
  | Reexport _ -> []
  | Alias { about; name; type_ = t } ->
      doc about @ [ "type " ^ checked name ^ " = " ^ type_ t ]
  | Value { about; name; type_ = t; clauses } ->
      doc about
      @ (checked name ^ " :: " ^ type_ t)
        :: List.map (clause_line name) clauses
  | Values { about; type_ = t; values } ->
      doc about
      @ (String.concat ", " (List.map (fun (name, _) -> checked name) values)
        ^ " :: " ^ type_ t)
        :: List.map
             (fun (name, e) -> checked name ^ " = " ^ expr ~depth:0 e)
             values
  | Class { about; name; param; methods } ->
      doc about
      @ ("class " ^ checked name ^ " " ^ variable param ^ " where")
        :: List.map
             (fun (m, t) -> indentation 1 ^ checked m ^ " :: " ^ type_ t)
             methods
  | Instance { context; class_; instance; methods } -> (
      let context =
        match context with
        | [] -> ""
        | cs ->
            tuple (List.map (fun (c, v) -> checked c ^ " " ^ variable v) cs)
            ^ " => "
      in
      let head =
        "instance " ^ context ^ checked class_ ^ " " ^ type_argument instance
        ^ " where"
      in
      let method_ ~depth (name, { patterns; body }) =
        String.concat " " (checked name :: List.map pattern patterns)
        ^ " = " ^ expr ~depth body
      in
      match methods with
      | [ m ] when not (String.contains (method_ ~depth:0 m) '\n') ->
          [ head ^ " " ^ method_ ~depth:0 m ]
      | methods ->
          head :: List.map (fun m -> indentation 1 ^ method_ ~depth:1 m) methods
      )

(* The names a module's declarations use, by namespace: each type and class
   a type, an instance or a deriving clause names, and each name, constructor
   and operator an expression or a pattern refers to, so a writer imports
   what provides them and nothing else. *)
type used = { types : string list; values : string list }

let uses body =
  let types = Hashtbl.create 64 and values = Hashtbl.create 64 in
  let type_use name = Hashtbl.replace types name () in
  let use name = Hashtbl.replace values name () in
  let rec type_ = function
    | T_name name | T_promoted name -> type_use name
    | T_apply (name, args) ->
        type_use name;
        List.iter type_ args
    | T_list t -> type_ t
    | T_tuple ts -> List.iter type_ ts
    | T_fun (a, b) ->
        type_ a;
        type_ b
    | T_constrained (context, t) ->
        List.iter (fun (c, _) -> type_use c) context;
        type_ t
  in
  let rec pattern = function
    | Constructor (name, held) ->
        use name;
        List.iter pattern held
    | Var _ | Literal _ | Otherwise -> ()
  in
  let rec expr = function
    | Name name -> use name
    | Str _ | Int _ -> ()
    | List items | Tuple items -> List.iter expr items
    | Apply (f, args) ->
        expr f;
        List.iter expr args
    | Compose (f, g) ->
        use ".";
        expr f;
        expr g
    | Dollar (f, x) ->
        use "$";
        expr f;
        expr x
    | Lambda (_, body) -> expr body
    | Case (subject, alternatives) ->
        expr subject;
        List.iter
          (fun (p, e) ->
            pattern p;
            expr e)
          alternatives
    | Infix (first, rest) ->
        expr first;
        List.iter
          (fun (symbol, e) ->
            use symbol;
            expr e)
          rest
    | Typed (e, t) ->
        expr e;
        type_ t
    | If (c, a, b) -> List.iter expr [ c; a; b ]
    | Section (op, e) ->
        use op;
        expr e
    | Do statements ->
        List.iter (function Bind (_, e) | Run e -> expr e) statements
    | Construct (name, fields) ->
        use name;
        List.iter
          (fun (f, e) ->
            use f;
            expr e)
          fields
  in
  let clause { patterns; body } =
    List.iter pattern patterns;
    expr body
  in
  let rec declaration = function
    | Private d -> declaration d
    | Data { constructors; deriving; _ } ->
        List.iter (fun c -> List.iter type_ c.fields) constructors;
        List.iter type_use deriving
    | Record { fields; deriving; _ } ->
        List.iter (fun (_, t) -> type_ t) fields;
        List.iter type_use deriving
    | Newtype { type_ = t; deriving; _ } ->
        type_ t;
        List.iter type_use deriving
    | Gadt { params; constructors; _ } ->
        List.iter (fun (_, kind) -> Option.iter type_use kind) params;
        List.iter (fun (_, t) -> type_ t) constructors
    | Reexport _ -> ()
    | Alias { type_ = t; _ } -> type_ t
    | Value { type_ = t; clauses; _ } ->
        type_ t;
        List.iter clause clauses
    | Values { type_ = t; values; _ } ->
        type_ t;
        List.iter (fun (_, e) -> expr e) values
    | Class { methods; _ } -> List.iter (fun (_, t) -> type_ t) methods
    | Instance { context; class_; instance; methods } ->
        List.iter (fun (c, _) -> type_use c) context;
        type_use class_;
        type_ instance;
        List.iter (fun (_, c) -> clause c) methods
  in
  List.iter declaration body;
  let sorted found =
    List.sort String.compare (List.of_seq (Hashtbl.to_seq_keys found))
  in
  { types = sorted types; values = sorted values }

let text m =
  let opening =
    List.map (fun l -> if l = "" then "--" else "-- " ^ l) m.banner
    @ List.map (fun e -> "{-# LANGUAGE " ^ checked e ^ " #-}") m.extensions
  in
  let header =
    "module " ^ checked m.name ^ " ("
    ^ String.concat ", " (List.map item (List.concat_map exports m.body))
    ^ ") where"
  in
  let imports =
    List.map import_line
      (List.sort (fun a b -> String.compare a.module_ b.module_) m.imports)
  in
  let blocks =
    List.filter (( <> ) [])
      ((match m.extensions with
         | [] -> [ opening @ [ header ] ]
         | _ -> [ opening; [ header ] ])
      @ (imports :: List.map decl m.body))
  in
  String.concat "\n\n" (List.map (String.concat "\n") blocks) ^ "\n"

(* Where module [name] is in the sdk checkout, under the SDK's [under]
   directory: Xynolog.Types under src is haskell/sdk/src/Xynolog/Types.hs. *)
let path ~under name =
  "haskell/sdk/" ^ under ^ "/"
  ^ String.concat "/" (String.split_on_char '.' name)
  ^ ".hs"

(* A module, written at its path under [under]. *)
let file ~under m = { Output.path = path ~under m.name; text = text m }

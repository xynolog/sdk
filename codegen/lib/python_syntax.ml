(* Python as the generator writes it: the declarations of a generated module,
   the expressions they hold, and the few statements a table's own dispatch
   needs, with a printer that writes them as ruff format leaves them. A writer
   builds a module of these and never a line of Python: a name is checked to
   be one, a string is quoted by the printer, as ruff quotes it, and every
   bracket it opens it closes.

   What a generated module holds is what Protocol derives: constants, types,
   the classes a table or a schema shapes, and the table's data. Logic that
   no table varies is the SDK's own, written by hand beside it.

   Layout is the printer's: an expression's is Python_layout's, and between
   top-level statements there is a blank line, two around a class or a
   function. *)

module L = Python_layout

type line = L.line = Prose of string | Line of string
type comment = line list
type binary = Add | Or | Ge

type expr =
  | Name of string  (** [True], [False] and [None] are names. *)
  | Str of string
  | Ascii of string  (** Printable ASCII, the rest escaped. *)
  | Int of int
  | Octal of string  (** Octal digits, written after [0o]. *)
  | Hex of string  (** Hex digits, written after [0x]. *)
  | Ellipsis
  | Binary of expr * binary * expr  (** [a + b + c] is [(a + b) + c]. *)
  | Call of expr * items
  | Subscript of expr * items
  | Tuple of items
  | List of items
  | Dict of items
  | Set of items
  | Joined of string list
      (** Strings Python joins into one, in parentheses, one a line where they
          do not fit on one. The sole argument of a call is in the call's. *)

(* A bracket's elements, one a line when [magic]: the comma after the last,
   which ruff keeps (but for a tuple of one, whose comma is its own). *)
and items = { elements : element list; magic : bool }
and element = { about : comment; label : label; value : expr }
and label = Plain | Keyword of string | Key of expr

(* A docstring: prose wrapped to 96 columns, or text as it is given. *)
type docstring = Wrapped of string | As_is of string
type spacing = Packed | Spaced

type stmt =
  | Comment of comment
  | Assign of {
      about : comment;
      target : string;
      annotation : expr option;
      value : expr option;
      doc : docstring option;
    }
  | Alias of {
      about : comment;
      name : string;
      value : expr;
      doc : docstring option;
    }
  | Return of expr
  | Do of expr
  | Pass
  | If of expr * stmt list
  | Match of expr * (expr * stmt list) list
  | Class of {
      decorators : expr list;
      name : string;
      bases : element list;
      doc : docstring option;
      spacing : spacing;
      body : stmt list;
    }
  | Def of {
      name : string;
      params : (string * expr) list;
      returns : expr;
      doc : docstring option;
      body : stmt list;
    }
  | Adjacent of stmt list
      (** Top-level statements with no blank line between. *)
  | Imports of import list list
      (** Groups, a blank line between: under [if TYPE_CHECKING:], the imports
          of types only. *)

and import = Import of string | From of string * string list

type module_ = {
  header : string list;  (** Comment lines, each written after a [#]. *)
  doc : docstring;
  imports : import list list;  (** Groups, a blank line between. *)
  body : stmt list;
}

(* [text]'s lines, each a line of a comment as it is given. *)
let verbatim text = List.map (fun l -> Line l) (String.split_on_char '\n' text)
let element ?(about = []) ?(label = Plain) value = { about; label; value }
let item value = element value
let keyword name value = element ~label:(Keyword name) value
let entry key value = element ~label:(Key key) value
let items ?(magic = false) elements = { elements; magic }
let call ?magic f elements = Call (Name f, items ?magic elements)
let sub ?magic f elements = Subscript (Name f, items ?magic elements)
let tuple ?magic elements = Tuple (items ?magic elements)

let strings ?magic texts =
  List.map (fun t -> item (Str t)) texts |> tuple ?magic

let assign ?(about = []) ?annotation ?value ?doc target =
  Assign { about; target; annotation; value; doc }

let alias ?(about = []) ?doc name value = Alias { about; name; value; doc }

(* A class's field: its name and type, a default when it has one, and what
   it is, as a docstring under it. *)
let field ?doc ?default name type_ =
  assign ~annotation:type_ ?value:default
    ?doc:(Option.map (fun d -> As_is d) doc)
    name

(* A frozen dataclass of [fields], as the SDK's rows are: built by keyword,
   never changed, and closed to subclasses. *)
let frozen_dataclass name doc fields =
  Class
    {
      decorators =
        [
          Name "final";
          call "dataclass"
            [
              keyword "frozen" (Name "True");
              keyword "slots" (Name "True");
              keyword "kw_only" (Name "True");
            ];
        ];
      name;
      bases = [];
      doc = Some (As_is doc);
      spacing = Packed;
      body = fields;
    }

let is_word = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true
  | _ -> false

let identifier name =
  name <> ""
  && (match name.[0] with '0' .. '9' -> false | _ -> true)
  && String.for_all is_word name

(* A name, or one qualified by what it is within ([channels.MARK_ADDED]). *)
let checked name =
  if List.for_all identifier (String.split_on_char '.' name) then name
  else invalid_arg (Printf.sprintf "Python_syntax: %S is no Python name" name)

(* A string as ruff writes it: in double quotes, but in single quotes when
   it holds more double quotes than single ones. [ascii] escapes every
   character outside printable ASCII. *)
let literal ~ascii text =
  let count c =
    String.fold_left (fun n d -> if d = c then n + 1 else n) 0 text
  in
  let quote = if count '"' > count '\'' then '\'' else '"' in
  let out = Buffer.create (String.length text + 2) in
  Buffer.add_char out quote;
  Text.fold_uchars
    (fun () u ->
      match Uchar.to_int u with
      | 0x5C -> Buffer.add_string out "\\\\"
      | 0x08 -> Buffer.add_string out "\\b"
      | 0x09 -> Buffer.add_string out "\\t"
      | 0x0A -> Buffer.add_string out "\\n"
      | 0x0C -> Buffer.add_string out "\\f"
      | 0x0D -> Buffer.add_string out "\\r"
      | code when code = Char.code quote ->
          Buffer.add_char out '\\';
          Buffer.add_char out quote
      | code when code < 0x20 ->
          Buffer.add_string out (Printf.sprintf "\\u%04x" code)
      | code when ascii && code >= 0x7F && code <= 0xFFFF ->
          Buffer.add_string out (Printf.sprintf "\\u%04x" code)
      | code when ascii && code > 0xFFFF ->
          Buffer.add_string out (Printf.sprintf "\\U%08x" code)
      | _ -> Buffer.add_utf_8_uchar out u)
    () text;
  Buffer.add_char out quote;
  Buffer.contents out

let rec doc = function
  | Name name -> L.Text (checked name)
  | Str text -> L.Text (literal ~ascii:false text)
  | Ascii text -> L.Text (literal ~ascii:true text)
  | Int n -> L.Text (string_of_int n)
  | Octal digits ->
      if
        digits <> ""
        && String.for_all (function '0' .. '7' -> true | _ -> false) digits
      then L.Text ("0o" ^ digits)
      else
        invalid_arg
          (Printf.sprintf "Python_syntax: %S is no octal number" digits)
  | Hex digits ->
      if digits <> "" && String.for_all Text.is_hex_digit digits then
        L.Text ("0x" ^ digits)
      else
        invalid_arg (Printf.sprintf "Python_syntax: %S is no hex number" digits)
  | Ellipsis -> L.Text "..."
  | Binary (_, op, _) as e ->
      (* A chain of one operator is one group: ruff breaks before each of its
         operators, or before none. *)
      let rec chain = function
        | Binary (a, inner, b) when inner = op && op <> Ge -> chain a @ [ b ]
        | Binary (a, _, b) -> [ a; b ]
        | e -> [ e ]
      in
      let sign = match op with Add -> "+ " | Or -> "| " | Ge -> ">= " in
      L.group
        (List.concat
           (List.mapi
              (fun i e ->
                (if i > 0 then [ L.Space; L.Text sign ] else []) @ [ operand e ])
              (chain e)))
  | Call
      ( f,
        {
          elements = [ { about = []; label = Plain; value = Joined texts } ];
          magic = false;
        } ) ->
      joined (flat f ^ "(") texts
  | Call (f, items) -> bracket (flat f ^ "(") ")" items ~sole:`Bare
  | Subscript (e, items) -> bracket (flat e ^ "[") "]" items ~sole:`Bare
  | Tuple { elements = [ one ]; _ } ->
      bracket "(" ")" (items [ one ]) ~sole:`Comma
  | Tuple items -> bracket "(" ")" items ~sole:`Broken
  | List items -> bracket "[" "]" items ~sole:`Broken
  | Dict items | Set items -> bracket "{" "}" items ~sole:`Broken
  | Joined texts -> joined "(" texts

and joined opening texts =
  L.group
    [
      L.Text opening;
      L.Indent
        [
          L.Break;
          L.group
            (List.concat
               (List.mapi
                  (fun i s ->
                    (if i > 0 then [ L.Space ] else [])
                    @ [ L.Text (literal ~ascii:false s) ])
                  texts));
        ];
      L.Break;
      L.Text ")";
    ]

(* What follows an [=], as ruff writes it: an operation, or a name or number,
   too long for its line goes in parentheses of its own; a bracket breaks
   itself, and a text can only overflow. *)
and assigned = function
  | (Binary _ | Name _ | Int _ | Octal _ | Hex _ | Ellipsis) as e ->
      L.group
        [
          L.Broken_text "(";
          L.Indent [ L.Break; doc e ];
          L.Break;
          L.Broken_text ")";
        ]
  | e -> doc e

and operand = function
  | Binary _ ->
      invalid_arg
        "Python_syntax: an operand is another operation, which needs \
         parentheses"
  | e -> doc e

and flat e = L.flat [ doc e ]

and bracket opening closing { elements; magic } ~sole =
  let element { about; label; value } =
    (if about = [] then [] else [ L.Comment about; L.Space ])
    @ [
        (match label with
        | Plain -> doc value
        | Keyword name -> L.group [ L.Text (checked name ^ "="); doc value ]
        | Key key -> L.group [ doc key; L.Text ": "; doc value ]);
      ]
  in
  let last =
    match (elements, sole) with
    | [ _ ], `Bare -> if magic then L.Broken_text "," else L.Text ""
    | [ _ ], `Comma -> L.Text ","
    | _ -> L.Broken_text ","
  in
  let rec separated = function
    | [] -> []
    | [ e ] -> element e @ [ last ]
    | e :: rest -> element e @ (L.Text "," :: L.Space :: separated rest)
  in
  match elements with
  | [] -> L.Text (opening ^ closing)
  | _ ->
      L.group
        [
          L.Text opening;
          L.Indent [ L.Break; L.group ~broken:magic (separated elements) ];
          L.Break;
          L.Text closing;
        ]

let spaces n = String.make n ' '

let comment ~indent about =
  List.map (fun l -> spaces indent ^ l) (L.comment_lines ~indent about)

let docstring ~indent = function
  | Wrapped text -> [ Text.python_docstring ~indent:(spaces indent) text ]
  | As_is text ->
      if
        String.contains text '\\'
        || Text.split ~sub:{|"""|} text |> List.length > 1
        || String.ends_with ~suffix:"\"" text
      then
        invalid_arg
          (Printf.sprintf "Python_syntax: docstring %S needs escaping" text)
      else
        List.map
          (fun l -> if l = "" then "" else spaces indent ^ l)
          (String.split_on_char '\n' ({|"""|} ^ text ^ {|"""|}))

(* [prefix] then [value], laid out from [indent]. *)
let statement ~indent prefix value =
  L.render ~indent [ L.group [ L.Text prefix; assigned value ] ]

let is_definition = function Class _ | Def _ -> true | _ -> false

(* An import too long for its line is one name a line, as ruff leaves it. *)
let import ~indent = function
  | Import name -> spaces indent ^ "import " ^ checked name
  | From (from_, names) ->
      L.render ~indent
        [
          L.group
            [
              L.Text ("from " ^ checked from_ ^ " import ");
              L.Broken_text "(";
              L.Indent
                ([ L.Break ]
                @ List.concat
                    (List.mapi
                       (fun i n ->
                         (if i > 0 then [ L.Text ","; L.Space ] else [])
                         @ [ L.Text (checked n) ])
                       names)
                @ [ L.Broken_text "," ]);
              L.Break;
              L.Broken_text ")";
            ];
        ]

let rec stmt ~indent s =
  let inner = indent + 4 in
  let at = spaces indent in
  match s with
  | Comment about -> comment ~indent about
  | Assign { about; target; annotation; value; doc = d } ->
      (* An annotation is laid out as a value is: a subscript too long for
         its line breaks, and what follows it stays after its bracket. *)
      comment ~indent about
      @ [
          L.render ~indent
            [
              L.group
                ([ L.Text (checked target) ]
                @ Option.fold ~none:[]
                    ~some:(fun a -> [ L.Text ": "; doc a ])
                    annotation
                @ Option.fold ~none:[]
                    ~some:(fun v -> [ L.Text " = "; assigned v ])
                    value);
            ];
        ]
      @ Option.fold ~none:[] ~some:(docstring ~indent) d
  | Alias { about; name; value; doc = d } ->
      comment ~indent about
      @ [ statement ~indent ("type " ^ checked name ^ " = ") value ]
      @ Option.fold ~none:[] ~some:(docstring ~indent) d
  | Return e -> [ statement ~indent "return " e ]
  | Do e -> [ statement ~indent "" e ]
  | Pass -> [ at ^ "pass" ]
  | If (cond, body) ->
      (at ^ "if " ^ flat cond ^ ":")
      :: List.concat_map (stmt ~indent:inner) body
  | Match (subject, cases) ->
      (at ^ "match " ^ flat subject ^ ":")
      :: List.concat_map
           (fun (pattern, body) ->
             (spaces inner ^ "case " ^ flat pattern ^ ":")
             :: List.concat_map (stmt ~indent:(inner + 4)) body)
           cases
  | Class { decorators; name; bases; doc = d; spacing; body } ->
      List.map (fun e -> at ^ "@" ^ flat e) decorators
      @ [
          at ^ "class " ^ checked name
          ^ (match bases with
            | [] -> ""
            | bases -> L.flat [ bracket "(" ")" (items bases) ~sole:`Bare ])
          ^ ":";
        ]
      @ (match d with
        | None -> []
        | Some d -> docstring ~indent:inner d @ if body = [] then [] else [ "" ])
      @ List.concat
          (List.mapi
             (fun i s ->
               (if i > 0 && spacing = Spaced then [ "" ] else [])
               @ stmt ~indent:inner s)
             body)
  | Def { name; params; returns; doc = d; body } ->
      (at ^ "def " ^ checked name ^ "("
      ^ String.concat ", "
          (List.map (fun (p, t) -> checked p ^ ": " ^ flat t) params)
      ^ ") -> " ^ flat returns ^ ":")
      :: (Option.fold ~none:[] ~some:(docstring ~indent:inner) d
         @ List.concat_map (stmt ~indent:inner) body)
  | Adjacent stmts -> List.concat_map (stmt ~indent) stmts
  | Imports groups ->
      List.concat
        (List.mapi
           (fun i group ->
             (if i > 0 then [ "" ] else []) @ List.map (import ~indent) group)
           groups)

let text m =
  let body =
    List.mapi
      (fun i s ->
        let gap =
          if i = 0 then ""
          else if is_definition s || is_definition (List.nth m.body (i - 1))
          then "\n\n\n"
          else "\n\n"
        in
        gap ^ String.concat "\n" (stmt ~indent:0 s))
      m.body
  in
  String.concat ""
    [
      String.concat "" (List.map (fun l -> "# " ^ l ^ "\n") m.header);
      "\n";
      String.concat "\n" (docstring ~indent:0 m.doc);
      "\n\n";
      String.concat ""
        (List.map
           (fun group ->
             String.concat "\n" (List.map (import ~indent:0) group) ^ "\n\n")
           m.imports);
      String.concat "" body;
      "\n";
    ]

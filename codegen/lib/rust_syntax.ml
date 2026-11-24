(* Rust as the generator writes it: the items of a generated file, the types
   and values they hold, and the few statements a table's own dispatch
   needs, with a printer that writes them. A writer builds a file of these
   and never a line of Rust: a name is checked to be one, a string is quoted
   and escaped by the printer, a comment's markers are the printer's, and
   every bracket it opens it closes.

   What a generated file holds is what Protocol derives: constants, types,
   the table's data, and a dispatch whose body is the table. Logic that no
   table varies is the SDK's own, written by hand beside it.

   rustfmt holds the SDK's Rust (style edition 2024, its default widths), so
   the printer lays out what it writes as rustfmt does, and a generated file
   is one rustfmt leaves as it is. The layout below is rustfmt's own rules,
   in its terms (a shape is the width left on a line, its block indent and
   the offset into the line; a list is laid out horizontally, vertically or
   mixed; a call's last argument may overflow onto the lines below), for the
   expressions a writer can build. What rustfmt would lay out by a rule not
   here the printer refuses, loudly: such a file would be one rustfmt
   rewrites. Between items is what the writer states ([Blank]); rustfmt
   keeps that as it is. *)

(* ---- Names, strings ---- *)

let keywords =
  [
    "as";
    "async";
    "await";
    "break";
    "const";
    "continue";
    "dyn";
    "else";
    "enum";
    "extern";
    "false";
    "fn";
    "for";
    "gen";
    "if";
    "impl";
    "in";
    "let";
    "loop";
    "match";
    "mod";
    "move";
    "mut";
    "pub";
    "ref";
    "return";
    "static";
    "struct";
    "trait";
    "true";
    "type";
    "unsafe";
    "use";
    "where";
    "while";
    "yield";
    "abstract";
    "become";
    "box";
    "do";
    "final";
    "macro";
    "override";
    "priv";
    "typeof";
    "unsized";
    "virtual";
    "try";
  ]

(* The keywords no raw identifier may be: a path segment's own. *)
let path_keywords = [ "crate"; "self"; "Self"; "super" ]

let is_word name =
  String.length name > 0
  && (match name.[0] with 'A' .. 'Z' | 'a' .. 'z' | '_' -> true | _ -> false)
  && String.for_all
       (function
         | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true | _ -> false)
       name
  && name <> "_"

(* An identifier as Rust spells it: a keyword is written raw. *)
let ident name =
  if not (is_word name) then invalid_arg ("Rust_syntax: not a name: " ^ name)
  else if List.mem name path_keywords then
    invalid_arg ("Rust_syntax: a path keyword is no name: " ^ name)
  else if List.mem name keywords then "r#" ^ name
  else name

(* A path's segment: a name, a path keyword, or a tuple field's index. *)
let segment s =
  if List.mem s path_keywords then s
  else if
    s <> "" && String.for_all (function '0' .. '9' -> true | _ -> false) s
  then s
  else ident s

let path segments =
  if segments = [] then invalid_arg "Rust_syntax: an empty path"
  else String.concat "::" (List.map segment segments)

(* A string literal as Rust's Debug writes it. Only ASCII: every width below
   is counted in bytes. *)
let quote text =
  let b = Buffer.create (String.length text + 2) in
  Buffer.add_char b '"';
  String.iter
    (fun c ->
      match c with
      | '"' -> Buffer.add_string b "\\\""
      | '\\' -> Buffer.add_string b "\\\\"
      | '\n' -> Buffer.add_string b "\\n"
      | '\r' -> Buffer.add_string b "\\r"
      | '\t' -> Buffer.add_string b "\\t"
      | c when Char.code c < 0x20 || Char.code c = 0x7f ->
          Buffer.add_string b (Printf.sprintf "\\u{%x}" (Char.code c))
      | c when Char.code c >= 0x80 ->
          invalid_arg ("Rust_syntax: a string that is not ASCII: " ^ text)
      | c -> Buffer.add_char b c)
    text;
  Buffer.add_char b '"';
  Buffer.contents b

let char_literal c =
  match c with
  | '\'' -> "'\\''"
  | '\\' -> "'\\\\'"
  | c when Char.code c >= 0x20 && Char.code c < 0x7f -> Printf.sprintf "'%c'" c
  | c -> invalid_arg (Printf.sprintf "Rust_syntax: a char %d" (Char.code c))

(* A float as Rust's Debug writes it; only an integral one, which the
   tables state. *)
let float_literal f =
  if Float.is_integer f && Float.abs f < 1e15 then Printf.sprintf "%.1f" f
  else invalid_arg (Printf.sprintf "Rust_syntax: a float %h" f)

(* ---- The tree ---- *)

type ty =
  | Named of string list * ty list  (** A path and its generic arguments. *)
  | Lifetime of string  (** ['a], ['_], ['static], as a generic argument. *)
  | Ref of string option * ty
  | Mut_ref of ty
  | Slice of ty
  | Array_of of ty * int
  | Tuple_of of ty list
  | Impl_of of ty
  | Dyn of ty
  | Assoc of string list  (** [Self::Payload], [D::Error] *)

type expr =
  | Int of int
  | Octal of int
  | Float of float
  | Bool of bool
  | Str of string
  | Char of char
  | Path of string list
  | Qualified of ty * ty * string list  (** [<T as U>::name] *)
  | Wild
  | Call of expr * expr list
  | Macro of string * expr list  (** [name!(args)] *)
  | Method of expr * string * expr list
  | Field of expr * string
  | Try of expr
  | Ref_of of expr
  | Deref of expr
  | Struct of string list * (string * expr) list * expr option
      (** A struct literal, its fields, and the base after [..]. *)
  | Array of expr list
  | Tuple of expr list
  | Match of expr * (expr * expr) list
  | Block of stmt list
  | If of expr * stmt list * stmt list  (** [if c { .. } else { .. }] *)
  | Return of expr
  | Binary of expr * string * expr
  | Range_inclusive of expr * expr
  | Range_from of expr  (** [n..], as a pattern *)

and stmt = Let of string * expr | Semi of expr | Tail of expr | Use of string

type vis = Pub | Pub_crate | Private

(* An attribute's meta item, as [#[...]] holds it. *)
type meta =
  | Word of string list
  | Name_value of string * expr
  | List of string list * meta list

type field = {
  doc : string list;
  attrs : meta list;
  vis : vis;
  name : string;
  ty : ty;
}

type variant = {
  v_doc : string list;
  v_attrs : meta list;
  v_name : string;
  payload : ty option;
}

type generic = Lifetime_param of string | Type_param of string * ty list
type param = Self_value | Self_ref | Param of string * ty

type fn_ = {
  f_doc : string list;
  f_attrs : meta list;
  f_vis : vis;
  const : bool;
  f_name : string;
  generics : generic list;
  params : param list;
  ret : ty option;
  body : stmt list;
}

type impl_item =
  | I_const of {
      doc : string list;
      vis : vis;
      name : string;
      ty : ty;
      value : expr option;
    }
  | I_type of string * ty
  | I_fn of fn_
  | I_blank

type struct_body = Fields of field list | Tuple_fields of ty list

type item =
  | Line_comment of string
  | Const of {
      doc : string list;
      attrs : meta list;
      vis : vis;
      name : string;
      ty : ty;
      value : expr;
    }
  | Struct_def of {
      doc : string list;
      attrs : meta list;
      vis : vis;
      name : string;
      generics : generic list;
      body : struct_body;
    }
  | Unit_struct of { doc : string list; vis : vis; name : string }
  | Enum of {
      doc : string list;
      attrs : meta list;
      vis : vis;
      name : string;
      variants : variant list;
    }
  | Impl of {
      generics : generic list;
      trait_ : ty option;
      for_ : ty;
      items : impl_item list;
    }
  | Fn of fn_
  | Type_alias of { doc : string list; vis : vis; name : string; ty : ty }
  | Macro_item of string * expr list
  | Blank

(* ---- Constructors ---- *)

let p name = Path (String.split_on_char ':' name |> List.filter (( <> ) ""))
let call name args = Call (p name, args)

let named ?(args = []) name =
  Named (String.split_on_char ':' name |> List.filter (( <> ) ""), args)

let str_ty = Ref (None, named "str")
let static_str = Ref (Some "'static", named "str")

let field ?(doc = []) ?(attrs = []) ?(vis = Pub) name ty =
  { doc; attrs; vis; name; ty }

let variant ?(doc = []) ?(attrs = []) ?payload name =
  { v_doc = doc; v_attrs = attrs; v_name = name; payload }

let fn_ ?(doc = []) ?(attrs = []) ?(vis = Private) ?(const = false)
    ?(generics = []) ?(params = []) ?ret name body =
  {
    f_doc = doc;
    f_attrs = attrs;
    f_vis = vis;
    const;
    f_name = name;
    generics;
    params;
    ret;
    body;
  }

(* ---- Types, printed on one line ---- *)

let lifetime l =
  if
    String.length l >= 2
    && l.[0] = '\''
    && (l = "'_" || is_word (String.sub l 1 (String.length l - 1)))
  then l
  else invalid_arg ("Rust_syntax: not a lifetime: " ^ l)

let rec type_text = function
  | Named (segments, []) -> path segments
  | Named (segments, args) ->
      path segments ^ "<" ^ String.concat ", " (List.map type_text args) ^ ">"
  | Lifetime l -> lifetime l
  | Ref (None, t) -> "&" ^ type_text t
  | Ref (Some l, t) -> "&" ^ lifetime l ^ " " ^ type_text t
  | Mut_ref t -> "&mut " ^ type_text t
  | Slice t -> "[" ^ type_text t ^ "]"
  | Array_of (t, n) -> Printf.sprintf "[%s; %d]" (type_text t) n
  | Tuple_of ts -> "(" ^ String.concat ", " (List.map type_text ts) ^ ")"
  | Impl_of t -> "impl " ^ type_text t
  | Dyn t -> "dyn " ^ type_text t
  | Assoc segments -> path segments

let vis_text = function
  | Pub -> "pub "
  | Pub_crate -> "pub(crate) "
  | Private -> ""

(* ---- Shapes ---- *)

let max_width = 100
let tab_spaces = 4
let fn_call_width = 60
let attr_fn_like_width = 70
let struct_lit_width = 18
let array_width = 60
let chain_width = 60
let short_array_element_width_threshold = 10
let single_line_if_else_max_width = 50

type shape = { width : int; indent : int; offset : int }

let indented indent = { width = max 0 (max_width - indent); indent; offset = 0 }
let block_indent s delta = { s with indent = s.indent + delta; offset = 0 }
let with_max_width s = { s with width = max 0 (max_width - s.indent) }
let add_offset s delta = { s with offset = s.offset + delta }

let sub_width s delta =
  if s.width >= delta then Some { s with width = s.width - delta } else None

let offset_left s delta = sub_width (add_offset s delta) delta
let used_width s = s.indent + s.offset
let rhs_overhead s = max 0 (max_width - (used_width s + s.width))
let spaces n = String.make n ' '
let newline_indent s = "\n" ^ spaces s.indent
let ( let* ) = Option.bind

(* ---- Strings' measures ---- *)

let lines s = String.split_on_char '\n' s
let contains_newline s = String.contains s '\n'
let first_line_width s = String.length (List.hd (lines s))

let last_line_width s =
  String.length (List.nth (lines s) (List.length (lines s) - 1))

let count_newlines s = List.length (lines s) - 1
let line_count s = List.length (lines s)

let trimmed_last_line_width s =
  String.length (String.trim (List.nth (lines s) (List.length (lines s) - 1)))

let first_line_ends_with s c =
  let l = List.hd (lines s) in
  l <> "" && l.[String.length l - 1] = c

let last_line_extendable s =
  let rec go i =
    if i < 0 then true
    else
      match s.[i] with
      | '(' | ')' | ']' | '}' | '?' | '>' | ' ' | '\t' -> go (i - 1)
      | '\n' -> true
      | _ -> false
  in
  go (String.length s - 1)

(* Whether a rewrite fits the shape: its first line the shape's width, every
   other line the page, and its last line what is left of the shape. *)
let fits s shape =
  match lines s with
  | [ line ] -> String.length line <= shape.width
  | first :: rest ->
      String.length first <= shape.width
      && List.for_all (fun l -> String.length l <= max_width) rest
      && last_line_width s <= used_width shape + shape.width
  | [] -> true

let wrap s shape = if fits s shape then Some s else None

(* ---- Lists ---- *)

type tactic = Horizontal | Vertical | Mixed
type trailing = Always | Vertical_only | Never

let item_width = function Some s -> String.length s | None -> 0
let item_multiline = function Some s -> contains_newline s | None -> false

let definitive_tactic ?(mixed = false) items width =
  let total =
    List.fold_left (fun n i -> n + item_width i) 0 items
    + (2 * max 0 (List.length items - 1))
  in
  if total <= width && not (List.exists item_multiline items) then Horizontal
  else if mixed then Mixed
  else Vertical

let write_list ~tactic ~trailing ~ends_with_newline ~shape items =
  let trailing_separator =
    ref
      (match trailing with
      | Always -> true
      | Vertical_only -> tactic = Vertical
      | Never -> false)
  in
  let indent_str = spaces shape.indent in
  let result = Buffer.create 128 in
  let line_len = ref 0 in
  let n = List.length items in
  let rec go i = function
    | [] -> Some ()
    | item :: rest -> (
        match item with
        | None -> None
        | Some inner ->
            let first = i = 0 and last = i = n - 1 in
            let separate = ref ((not last) || !trailing_separator) in
            let sep_len = if !separate then 1 else 0 in
            (match tactic with
            | Horizontal -> if not first then Buffer.add_char result ' '
            | Vertical ->
                if (not first) && inner <> "" && Buffer.length result > 0 then (
                  Buffer.add_char result '\n';
                  Buffer.add_string result indent_str)
            | Mixed ->
                let total = String.length inner + sep_len in
                if !line_len > 0 && !line_len + 1 + total > shape.width then (
                  Buffer.add_char result '\n';
                  Buffer.add_string result indent_str;
                  line_len := 0;
                  if ends_with_newline then trailing_separator := true)
                else if !line_len > 0 then (
                  Buffer.add_char result ' ';
                  incr line_len);
                if last && ends_with_newline then separate := trailing <> Never;
                line_len := !line_len + total);
            Buffer.add_string result inner;
            if !separate then Buffer.add_char result ',';
            go (i + 1) rest)
  in
  let* () = go 0 items in
  Some (Buffer.contents result)

(* ---- Expressions ---- *)

let rec is_simple = function
  | Int _ | Octal _ | Float _ | Bool _ | Str _ | Char _ -> true
  | Path [ _ ] -> true
  | Ref_of e | Field (e, _) | Try e | Deref e -> is_simple e
  | _ -> false

let rec can_be_overflowed e len =
  match e with
  | Match _ -> len = 1
  | Block _ -> true
  | Array _ | Struct _ -> len = 1
  | Macro _ -> len = 1
  | Call _ | Method _ | Tuple _ -> len = 1
  | Ref_of e | Try e | Deref e -> can_be_overflowed e len
  | _ -> false

let rec is_nested_call = function
  | Call _ | Macro _ -> true
  | Ref_of e | Try e | Deref e -> is_nested_call e
  | _ -> false

let rec is_method_call = function
  | Method _ -> true
  | Ref_of e | Try e | Deref e -> is_method_call e
  | _ -> false

let rec can_flatten_block_around = function
  | Match _ | Block _ | Array _ | Call _ | Method _ | Macro _ | Struct _
  | Tuple _ ->
      true
  | Ref_of e | Try e | Deref e -> can_flatten_block_around e
  | _ -> false

(* rustfmt's: a chain that may not break, while the last argument of a call
   is tried overflowed. *)
let force_one_line_chain = ref false

(* What a list of items is to rustfmt's overflow: an expression, or an
   attribute's meta item. *)
type entry = E of expr | M of meta

let entry_is_simple = function
  | E e -> is_simple e
  | M (Word _) -> true
  | M _ -> false

let entry_can_be_overflowed len = function
  | E e -> can_be_overflowed e len
  | M (Word _ | Name_value _) -> false
  | M (List _) -> len = 1

let prefer_next_line orig next =
  (not (contains_newline next))
  || count_newlines orig > count_newlines next + 1
  || (first_line_ends_with orig '(' && not (first_line_ends_with next '('))
  || (first_line_ends_with orig '{' && not (first_line_ends_with next '{'))
  || (first_line_ends_with orig '[' && not (first_line_ends_with next '['))

let atom text shape =
  if String.length text <= shape.width then Some text else None

let rec rewrite e shape =
  match e with
  | Int n -> atom (string_of_int n) shape
  | Octal n -> atom (Printf.sprintf "0o%o" n) shape
  | Float f -> atom (float_literal f) shape
  | Bool b -> atom (string_of_bool b) shape
  | Str s -> Some (quote s)
  | Char c -> atom (char_literal c) shape
  | Path segments -> atom (path segments) shape
  | Qualified (t, trait_, segments) ->
      atom
        (Printf.sprintf "<%s as %s>::%s" (type_text t) (type_text trait_)
           (path segments))
        shape
  | Wild -> atom "_" shape
  | Call (callee, args) ->
      let* callee = rewrite callee shape in
      overflow ~ident:callee ~prefix:"(" ~suffix:")"
        ~item_max_width:fn_call_width ~force:None
        (List.map (fun a -> E a) args)
        shape
  | Macro (name, args) ->
      overflow
        ~ident:(ident name ^ "!")
        ~prefix:"(" ~suffix:")" ~item_max_width:fn_call_width ~force:None
        (List.map (fun a -> E a) args)
        shape
  | Method _ | Field _ | Try _ -> chain e shape
  | Ref_of inner ->
      let* s = offset_left shape 1 in
      let* r = rewrite inner s in
      Some ("&" ^ r)
  | Deref inner ->
      let* s = offset_left shape 1 in
      let* r = rewrite inner s in
      Some ("*" ^ r)
  | Return inner ->
      let* s = offset_left shape 7 in
      let* r = rewrite inner s in
      Some ("return " ^ r)
  | Struct (segments, fields, base) -> struct_lit segments fields base shape
  | Array items ->
      overflow ~ident:"" ~prefix:"[" ~suffix:"]" ~item_max_width:array_width
        ~force:None
        (List.map (fun a -> E a) items)
        shape
  | Tuple items ->
      overflow ~ident:"" ~prefix:"(" ~suffix:")" ~item_max_width:fn_call_width
        ~force:(if List.length items = 1 then Some Always else None)
        (List.map (fun a -> E a) items)
        shape
  | Match (cond, arms) -> match_ cond arms shape
  | Block stmts -> Some (block stmts shape)
  | If (cond, then_, else_) -> if_else cond then_ else_ shape
  | Binary (l, op, r) ->
      (* Only on one line: a pair rustfmt would break is refused. *)
      let* ls = rewrite l shape in
      let* rs = rewrite r shape in
      let s = ls ^ " " ^ op ^ " " ^ rs in
      if contains_newline s then None else atom s shape
  | Range_from l ->
      let* ls = rewrite l shape in
      atom (ls ^ "..") shape
  | Range_inclusive (l, r) ->
      let* ls = rewrite l shape in
      let* rs = rewrite r shape in
      let s = ls ^ "..=" ^ rs in
      if contains_newline s then None else atom s shape

and entry_rewrite entry shape =
  match entry with E e -> rewrite e shape | M m -> meta_rewrite m shape

and meta_rewrite m shape =
  match m with
  | Word segments -> atom (path segments) shape
  | Name_value (name, value) ->
      let* v = rewrite value { shape with width = max_width } in
      Some (ident name ^ " = " ^ v)
  | List (segments, items) ->
      let* name = atom (path segments) shape in
      let* s = sub_width shape 1 in
      overflow ~ident:name ~prefix:"(" ~suffix:")"
        ~item_max_width:attr_fn_like_width ~force:(Some Never)
        (List.map (fun m -> M m) items)
        s

(* rustfmt's overflow.rs: a call's or an array's items, one line if they
   fit, else the last overflowing onto the lines below, else a line each (or
   as many as fit a line, when every item is short and simple). *)
and overflow ~ident ~prefix ~suffix ~item_max_width ~force entries shape =
  let used = String.length ident in
  let one_line_width = max 0 (shape.width - (used + 2)) in
  let one_line_shape =
    match
      let* s = offset_left shape (last_line_width ident + 1) in
      sub_width s 1
    with
    | Some s -> s
    | None -> { shape with width = 0 }
  in
  let nested_shape =
    let s = with_max_width (block_indent shape tab_spaces) in
    { s with width = max 0 (s.width - 1) }
  in
  let n = List.length entries in
  let items =
    Array.of_list (List.map (fun e -> entry_rewrite e nested_shape) entries)
  in
  let entries = Array.of_list entries in
  let tactic =
    if n = 0 then Horizontal
    else
      let last = n - 1 in
      let combine =
        n = 1
        && (match entries.(0) with E _ -> true | M _ -> false)
        && String.length ident < tab_spaces
      in
      let overflow_last = combine || entry_can_be_overflowed n entries.(last) in
      let placeholder =
        if not overflow_last then None
        else
          let saved = !force_one_line_chain in
          (match entries.(last) with
          | E e when (not combine) && is_method_call e ->
              force_one_line_chain := true
          | _ -> ());
          let arg_shape =
            if
              n = 1
              && not
                   (match entries.(0) with
                   | E e -> is_nested_call e
                   | M _ -> false)
            then Some one_line_shape
            else
              let offset = ref 0 in
              for i = 0 to n - 2 do
                offset := !offset + 2 + item_width items.(i)
              done;
              offset_left
                {
                  one_line_shape with
                  width = min item_max_width one_line_shape.width;
                }
                !offset
          in
          let result =
            let* s = arg_shape in
            let* rw = entry_rewrite entries.(last) s in
            items.(last) <- Some (List.hd (lines rw));
            Some rw
          in
          force_one_line_chain := saved;
          result
      in
      let tactic =
        definitive_tactic (Array.to_list items)
          (min one_line_width item_max_width)
      in
      match (overflow_last, tactic, placeholder) with
      | true, Horizontal, Some overflowed when n = 1 ->
          if count_newlines overflowed = 1 then
            match entry_rewrite entries.(last) nested_shape with
            | Some rw when not (contains_newline rw) -> items.(last) <- Some rw
            | _ -> items.(last) <- Some overflowed
          else items.(last) <- Some overflowed;
          Horizontal
      | true, Horizontal, Some overflowed ->
          items.(last) <- Some overflowed;
          Horizontal
      | _ ->
          items.(last) <- entry_rewrite entries.(last) nested_shape;
          if
            n = 1 && one_line_width <> 0
            && (not (item_multiline items.(0)))
            && item_width items.(0) <= one_line_width
          then Horizontal
          else
            let t =
              definitive_tactic (Array.to_list items)
                (min one_line_width item_max_width)
            in
            if
              t = Vertical
              && Array.for_all entry_is_simple entries
              && Array.for_all
                   (fun i ->
                     item_width i <= short_array_element_width_threshold)
                   items
            then Mixed
            else t
  in
  let trailing = match force with Some t -> t | None -> Vertical_only in
  let ends_with_newline = tactic = Vertical || tactic = Mixed in
  let* items_str =
    write_list ~tactic ~trailing ~ends_with_newline ~shape:nested_shape
      (Array.to_list items)
  in
  let extendable = tactic = Horizontal in
  let wrap_shape =
    { shape with width = max 0 (shape.width - last_line_width ident) }
  in
  let extend_width =
    if items_str = "" then 2 else first_line_width items_str + 1
  in
  if extendable && extend_width <= wrap_shape.width then
    Some (ident ^ prefix ^ items_str ^ suffix)
  else
    Some
      (ident ^ prefix
      ^ (if items_str = "" then "" else newline_indent nested_shape ^ items_str)
      ^ newline_indent shape ^ suffix)

(* rustfmt's struct literal: its fields on one line if they fit a short
   budget, else a field a line; a base after them takes no comma. *)
and struct_lit segments fields base shape =
  let* path_shape = sub_width shape 2 in
  let* path_str = atom (path segments) path_shape in
  if fields = [] && base = None then Some (path_str ^ " {}")
  else
    let v_shape = with_max_width (block_indent shape tab_spaces) in
    let prefix_width = String.length path_str + 3 in
    let h_shape =
      if shape.width >= prefix_width + 2 then
        Some
          {
            width = min (shape.width - prefix_width - 2) struct_lit_width;
            indent = shape.indent;
            offset = 0;
          }
      else None
    in
    let one_line_width = match h_shape with Some s -> s.width | None -> 0 in
    let field_item (name, value) =
      let* s = sub_width v_shape 1 in
      if value = Path [ name ] then atom (ident name) s
      else
        let name = ident name in
        let expr_shape = offset_left s (String.length name + 2) in
        match Option.bind expr_shape (rewrite value) with
        | Some e -> Some (name ^ ": " ^ e)
        | None ->
            let nested = indented (s.indent + tab_spaces) in
            let* e = rewrite value nested in
            Some (name ^ ":\n" ^ spaces nested.indent ^ e)
    in
    let base_item =
      match base with
      | None -> []
      | Some b ->
          [
            (let* s = offset_left v_shape 2 in
             let* r = rewrite b s in
             Some (".." ^ r));
          ]
    in
    let items = List.map field_item fields @ base_item in
    let tactic =
      match h_shape with
      | Some h -> definitive_tactic items h.width
      | None -> Vertical
    in
    let nested_shape =
      match (tactic, h_shape) with Horizontal, Some h -> h | _ -> v_shape
    in
    let trailing = if base <> None then Never else Vertical_only in
    let* fields_str =
      write_list ~tactic ~trailing ~ends_with_newline:(tactic = Vertical)
        ~shape:nested_shape items
    in
    let fields_str =
      if
        contains_newline fields_str || String.length fields_str > one_line_width
      then newline_indent v_shape ^ fields_str ^ newline_indent shape
      else " " ^ fields_str ^ " "
    in
    Some (path_str ^ " {" ^ fields_str ^ "}")

(* rustfmt's chains.rs, block indent: a receiver and what is called on it,
   on one line if it fits, else a call a line below the receiver. *)
and chain e shape =
  (* The chain's parent, and its children outermost last, each with its
     [?]s. *)
  let rec collect e tries acc =
    match e with
    | Try inner -> collect inner (tries + 1) acc
    | Method (recv, name, args) ->
        collect recv 0 ((`Method (name, args), tries) :: acc)
    | Field (recv, name) -> collect recv 0 ((`Field name, tries) :: acc)
    | parent -> ((parent, tries), acc)
  in
  let (parent, parent_tries), children = collect e 0 [] in
  let child_rewrite (kind, tries) shape =
    let* s = sub_width shape tries in
    let* r =
      match kind with
      | `Method (name, args) ->
          overflow
            ~ident:("." ^ ident name)
            ~prefix:"(" ~suffix:")" ~item_max_width:fn_call_width ~force:None
            (List.map (fun a -> E a) args)
            s
      | `Field name -> Some ("." ^ segment name)
    in
    Some (r ^ String.make tries '?')
  in
  let parent_rewrite shape =
    let* s = sub_width shape parent_tries in
    let* r = rewrite parent s in
    Some (r ^ String.make parent_tries '?')
  in
  if children = [] then parent_rewrite shape
  else
    let* root = parent_rewrite shape in
    let root_block_like =
      match parent with
      | Call _ | Macro _ | Method _ | Array _ | Struct _ | Block _ | Match _ ->
          contains_newline root
      | _ -> false
    in
    let tab_width = max 0 (tab_spaces - shape.offset) in
    let rec absorb root block_like children =
      match children with
      | child :: rest
        when String.length root <= tab_width && not (contains_newline root) -> (
          match
            let* s = offset_left shape (String.length root) in
            child_rewrite child s
          with
          | Some r ->
              let root = root ^ r in
              let block_like = last_line_extendable root in
              if rest = [] then (root, block_like, [])
              else absorb root block_like rest
          | None -> (root, block_like, children))
      | _ -> (root, block_like, children)
    in
    let root, root_block_like, children =
      absorb root root_block_like children
    in
    if children = [] then wrap root shape
    else
      let child_shape =
        with_max_width
          (if root_block_like then block_indent shape 0
           else block_indent shape tab_spaces)
      in
      let child_count = List.length children in
      let rec split = function
        | [ last ] -> ([], last)
        | c :: rest ->
            let init, last = split rest in
            (c :: init, last)
        | [] -> assert false
      in
      let init, last = split children in
      let* inits =
        List.fold_right
          (fun c acc ->
            let* acc = acc in
            let* r = child_rewrite c child_shape in
            Some (r :: acc))
          init (Some [])
      in
      let rewrites = root :: inits in
      let last_tries = snd last in
      let extendable = last_line_extendable root in
      let almost_total =
        (if extendable then last_line_width root
         else List.fold_left (fun n r -> n + String.length r) 0 rewrites)
        + last_tries
      in
      let one_line_budget =
        (if child_count = 1 then shape.width else min shape.width chain_width)
        - almost_total
      in
      let all_in_one_line =
        List.for_all (fun r -> not (contains_newline r)) rewrites
        && one_line_budget > 0
      in
      let* last_shape =
        if all_in_one_line then sub_width shape last_tries
        else if extendable then sub_width child_shape last_tries
        else sub_width child_shape (rhs_overhead shape + last_tries)
      in
      let fits_single_line = ref false in
      let last_str =
        if all_in_one_line || extendable then
          match offset_left last_shape almost_total with
          | None -> None
          | Some one_line_shape -> (
              match child_rewrite last one_line_shape with
              | None -> None
              | Some rw -> (
                  let could_fit = first_line_width rw <= one_line_budget in
                  if could_fit && line_count rw >= 5 then (
                    fits_single_line := all_in_one_line;
                    Some rw)
                  else
                    match
                      let* s =
                        sub_width child_shape (rhs_overhead shape + last_tries)
                      in
                      child_rewrite last s
                    with
                    | Some new_rw when not could_fit -> Some new_rw
                    | Some new_rw when line_count new_rw >= line_count rw ->
                        fits_single_line := could_fit && all_in_one_line;
                        Some rw
                    | Some new_rw -> Some new_rw
                    | None ->
                        fits_single_line := could_fit && all_in_one_line;
                        Some rw))
        else None
      in
      let* last_str =
        match last_str with
        | Some s -> Some s
        | None -> child_rewrite last last_shape
      in
      let* connector =
        if !fits_single_line then Some ""
        else if !force_one_line_chain then None
        else Some (newline_indent child_shape)
      in
      let result =
        String.concat ""
          (root :: List.map (fun r -> connector ^ r) (inits @ [ last_str ]))
      in
      wrap result shape

(* rustfmt's matches.rs: an arm a line, its body beside the arrow if it
   fits, else in a block on the lines below. *)
and match_ cond arms shape =
  let cond_shape =
    { shape with width = max 0 (max_width - used_width shape) }
  in
  let* cond_shape = offset_left cond_shape 6 in
  let* cond_str = rewrite cond cond_shape in
  let block_sep =
    if last_line_extendable cond_str then " "
    else if
      contains_newline cond_str || String.length cond_str + 2 > cond_shape.width
    then newline_indent shape
    else " "
  in
  let arm_shape = with_max_width (block_indent shape tab_spaces) in
  let n = List.length arms in
  let laid_out =
    List.fold_left
      (fun acc (i, arm) ->
        let* acc = acc in
        let* a = match_arm arm arm_shape ~is_last:(i = n - 1) in
        Some (acc @ [ a ]))
      (Some [])
      (List.mapi (fun i a -> (i, a)) arms)
  in
  (* A match with an arm rustfmt cannot lay out within the width it leaves
     as its source has it: an arm a line. *)
  let as_written (pat, body) =
    let unbounded = { arm_shape with width = max_int / 2 } in
    match (body, rewrite pat unbounded, rewrite body unbounded) with
    | (Block _ | Match _), _, _ -> None
    | _, Some p, Some b when not (contains_newline (p ^ b)) ->
        Some (p ^ " => " ^ b ^ ",")
    | _ -> None
  in
  let* arms_str =
    match laid_out with
    | Some arms -> Some arms
    | None ->
        List.fold_left
          (fun acc arm ->
            let* acc = acc in
            let* a = as_written arm in
            Some (acc @ [ a ]))
          (Some []) arms
  in
  Some
    ("match " ^ cond_str ^ block_sep ^ "{\n" ^ spaces arm_shape.indent
    ^ String.concat (newline_indent arm_shape) arms_str
    ^ "\n" ^ spaces shape.indent ^ "}")

and match_arm (pat, body) shape ~is_last:_ =
  let* pat_shape = sub_width shape 5 in
  let* pats_str = rewrite pat pat_shape in
  let is_block, body_is_simple_block =
    match body with
    | Block [ Tail _ ] -> (true, true)
    | Block _ -> (true, false)
    | _ -> (false, false)
  in
  if body_is_simple_block then
    invalid_arg
      "Rust_syntax: a match arm's block of one expression, which rustfmt \
       flattens";
  let extend = can_flatten_block_around body in
  let comma = if is_block then "" else "," in
  let next_line_indent =
    if is_block then shape.indent else shape.indent + tab_spaces
  in
  let combine_orig body_str = Some (pats_str ^ " => " ^ body_str ^ comma) in
  let combine_next body_str =
    if is_block then
      Some (pats_str ^ " =>" ^ "\n" ^ spaces next_line_indent ^ body_str ^ comma)
    else
      Some
        (pats_str ^ " => {" ^ "\n" ^ spaces next_line_indent ^ body_str
       ^ newline_indent shape ^ "}")
  in
  let orig_body_shape =
    let* s = offset_left shape (String.length pats_str + 4) in
    sub_width s (String.length comma)
  in
  let orig_budget =
    match orig_body_shape with Some s -> s.width | None -> 0
  in
  let orig_body = Option.bind orig_body_shape (statement_expr body) in
  match orig_body with
  | Some b
    when is_block
         || ((not (contains_newline b)) && String.length b <= orig_budget) ->
      combine_orig b
  | _ -> (
      let next_body = statement_expr body (indented next_line_indent) in
      match (orig_body, next_body) with
      | Some o, Some nb when prefer_next_line o nb -> combine_next nb
      | Some o, _ when extend && first_line_width o <= orig_budget ->
          combine_orig o
      | Some o, Some nb when contains_newline o -> combine_next nb
      | None, Some nb -> combine_next nb
      | None, None -> None
      | Some o, _ -> combine_orig o)

(* rustfmt's if-else as a block's last expression: on one line if each
   branch is one expression and the whole fits single_line_if_else_max_width,
   else each branch a block. *)
and if_else cond then_ else_ shape =
  let* cond_shape = offset_left shape 3 in
  let* cond_str = rewrite cond cond_shape in
  if contains_newline cond_str then
    invalid_arg "Rust_syntax: an if whose condition rustfmt breaks";
  let single =
    match (then_, else_) with
    | [ Tail a ], [ Tail b ] ->
        let width = min shape.width single_line_if_else_max_width in
        let fixed = String.length "if  {  } else {  }" in
        let* w =
          if width >= String.length cond_str + fixed then
            Some (width - String.length cond_str - fixed)
          else None
        in
        let* a_str = rewrite a (indented 0 |> fun s -> { s with width = w }) in
        let* w =
          if w >= String.length a_str then Some (w - String.length a_str)
          else None
        in
        let* b_str = rewrite b { (indented 0) with width = w } in
        let r =
          Printf.sprintf "if %s { %s } else { %s }" cond_str a_str b_str
        in
        if contains_newline r || String.length r > width then None else Some r
    | _ -> None
  in
  match single with
  | Some r -> Some r
  | None ->
      Some
        ("if " ^ cond_str ^ " " ^ block then_ shape ^ " else "
       ^ block else_ shape)

(* An expression as a statement: a [return] takes its [;] from the width. *)
and statement_expr e shape =
  match e with
  | Return _ ->
      let* s = sub_width shape 1 in
      rewrite e s
  | _ -> rewrite e shape

(* A block in statement position: a statement a line. *)
and block stmts shape =
  if stmts = [] then "{}"
  else
    let inner = indented (shape.indent + tab_spaces) in
    "{\n"
    ^ String.concat "\n"
        (List.map (fun s -> spaces inner.indent ^ stmt s inner) stmts)
    ^ "\n" ^ spaces shape.indent ^ "}"

and stmt s shape =
  let refuse what =
    invalid_arg
      (Printf.sprintf
         "Rust_syntax: rustfmt lays out %s otherwise (indent %d, width %d)" what
         shape.indent shape.width)
  in
  match s with
  | Use tree -> "use " ^ tree ^ ";"
  | Tail e -> (
      match rewrite e shape with Some r -> r | None -> refuse "an expression")
  | Semi e -> (
      let width = match e with Return _ -> 2 | _ -> 1 in
      match Option.bind (sub_width shape width) (rewrite e) with
      | Some r -> r ^ ";"
      | None -> refuse "a statement")
  | Let (pat, e) -> (
      match
        let* s = sub_width shape 1 in
        assign_rhs ("let " ^ pat ^ " =") e s
      with
      | Some r -> r ^ ";"
      | None -> refuse "a let")

(* rustfmt's rewrite_assign_rhs: the value beside the [=] if it fits, else
   on the line below when that is better. *)
and assign_rhs lhs e shape =
  let lw = last_line_width lhs in
  let orig_shape =
    match offset_left shape (lw + 1) with
    | Some s -> s
    | None -> { shape with width = 0; offset = shape.offset + lw + 1 }
  in
  let orig = rewrite e orig_shape in
  match orig with
  | Some s
    when (not (contains_newline s)) && String.length s <= orig_shape.width ->
      Some (lhs ^ " " ^ s)
  | _ -> (
      let new_shape =
        sub_width
          (indented (orig_shape.indent + tab_spaces))
          (rhs_overhead orig_shape)
      in
      let new_rhs = Option.bind new_shape (rewrite e) in
      let new_indent = "\n" ^ spaces (orig_shape.indent + tab_spaces) in
      match (orig, new_rhs, new_shape) with
      | Some o, Some nr, Some ns when not (fits nr { ns with width = ns.width })
        ->
          Some (lhs ^ " " ^ o)
      | Some o, Some nr, _ when prefer_next_line o nr ->
          Some (lhs ^ new_indent ^ nr)
      | None, Some nr, _ -> Some (lhs ^ new_indent ^ nr)
      | None, None, _ -> None
      | Some o, _, _ -> Some (lhs ^ " " ^ o))

(* ---- Items ---- *)

let doc_lines ~indent doc =
  List.concat_map
    (fun para ->
      List.map
        (fun line ->
          let line =
            (* rustfmt trims what ends a comment's line. *)
            let n = ref (String.length line) in
            while !n > 0 && (line.[!n - 1] = ' ' || line.[!n - 1] = '\t') do
              decr n
            done;
            String.sub line 0 !n
          in
          spaces indent ^ if line = "" then "///" else "/// " ^ line)
        (String.split_on_char '\n' para))
    doc

(* rustfmt's derive: on one line if it fits, else its paths a line below,
   as many as fit a line. *)
let derive ~indent paths =
  let shape = indented indent in
  let argument_shape = with_max_width (block_indent shape tab_spaces) in
  let one_line_budget = shape.width - 11 - 3 in
  let items = List.map (fun p -> Some p) paths in
  let tactic = definitive_tactic items argument_shape.width in
  match
    write_list ~tactic ~trailing:Always ~ends_with_newline:false
      ~shape:argument_shape items
  with
  | None -> assert false
  | Some item_str ->
      if contains_newline item_str || String.length item_str > one_line_budget
      then
        "#[derive("
        ^ newline_indent argument_shape
        ^ item_str ^ newline_indent shape ^ ")]"
      else
        "#[derive(" ^ String.sub item_str 0 (String.length item_str - 1) ^ ")]"

let attr ~indent m =
  match m with
  | List ([ "derive" ], items) ->
      derive ~indent
        (List.map
           (function
             | Word segments -> path segments
             | _ -> invalid_arg "Rust_syntax: a derive of a path")
           items)
  | m -> (
      let shape = indented indent in
      match
        let* s = offset_left shape 2 in
        meta_rewrite m s
      with
      | Some r -> "#[" ^ r ^ "]"
      | None ->
          invalid_arg "Rust_syntax: an attribute rustfmt lays out otherwise")

let attrs_lines ~indent attrs =
  List.map (fun m -> spaces indent ^ attr ~indent m) attrs

let generics_text = function
  | [] -> ""
  | gs ->
      "<"
      ^ String.concat ", "
          (List.map
             (function
               | Lifetime_param l -> lifetime l
               | Type_param (name, []) -> ident name
               | Type_param (name, bounds) ->
                   ident name ^ ": "
                   ^ String.concat " + " (List.map type_text bounds))
             gs)
      ^ ">"

let param_text = function
  | Self_value -> "self"
  | Self_ref -> "&self"
  | Param (name, t) -> ident name ^ ": " ^ type_text t

(* rustfmt's fn signature: on one line if it fits, else a parameter a line. *)
let fn_text ~indent (f : fn_) =
  let head =
    vis_text f.f_vis
    ^ (if f.const then "const " else "")
    ^ "fn " ^ ident f.f_name ^ generics_text f.generics
  in
  let ret = match f.ret with None -> "" | Some t -> " -> " ^ type_text t in
  let one_line =
    head ^ "(" ^ String.concat ", " (List.map param_text f.params) ^ ")" ^ ret
  in
  let signature =
    if indent + String.length one_line + 2 <= max_width then one_line
    else if f.params = [] then
      invalid_arg ("Rust_syntax: a signature too long: " ^ one_line)
    else
      head ^ "(\n"
      ^ String.concat ""
          (List.map
             (fun p -> spaces (indent + tab_spaces) ^ param_text p ^ ",\n")
             f.params)
      ^ spaces indent ^ ")" ^ ret
  in
  String.concat "\n"
    (doc_lines ~indent f.f_doc
    @ attrs_lines ~indent f.f_attrs
    @ [ spaces indent ^ signature ^ " " ^ block f.body (indented indent) ])

let const_text ~indent ~vis ~name ~ty value =
  let prefix = vis_text vis ^ "const " ^ ident name ^ ": " ^ type_text ty in
  if indent + String.length prefix + 2 > max_width then
    invalid_arg ("Rust_syntax: a constant's type too long: " ^ prefix);
  let shape = { (indented indent) with width = max_width - (indent + 1) } in
  match assign_rhs (prefix ^ " =") value shape with
  | Some r -> spaces indent ^ r ^ ";"
  | None ->
      invalid_arg ("Rust_syntax: a constant rustfmt lays out otherwise: " ^ name)

let impl_item_text ~indent = function
  | I_blank -> ""
  | I_type (name, t) ->
      spaces indent ^ "type " ^ ident name ^ " = " ^ type_text t ^ ";"
  | I_const { doc; vis; name; ty; value = None } ->
      String.concat "\n"
        (doc_lines ~indent doc
        @ [
            spaces indent ^ vis_text vis ^ "const " ^ ident name ^ ": "
            ^ type_text ty ^ ";";
          ])
  | I_const { doc; vis; name; ty; value = Some v } ->
      String.concat "\n"
        (doc_lines ~indent doc @ [ const_text ~indent ~vis ~name ~ty v ])
  | I_fn f -> fn_text ~indent f

(* [ty] after [head] and before [tail] at [indent], as rustfmt lays it out:
   on one line where it fits, else a generic type's arguments one to a line
   below it, each laid out so in turn. *)
let rec type_lines ~indent ~head ~tail ty =
  let one = spaces indent ^ head ^ type_text ty ^ tail in
  if String.length one <= max_width then [ one ]
  else
    match ty with
    | Named (segments, (_ :: _ as args)) ->
        (spaces indent ^ head ^ path segments ^ "<")
        :: List.concat_map
             (type_lines ~indent:(indent + tab_spaces) ~head:"" ~tail:",")
             args
        @ [ spaces indent ^ ">" ^ tail ]
    | _ -> invalid_arg ("Rust_syntax: a type too long: " ^ one)

let field_text ~indent (f : field) =
  doc_lines ~indent f.doc
  @ attrs_lines ~indent f.attrs
  @ type_lines ~indent
      ~head:(vis_text f.vis ^ ident f.name ^ ": ")
      ~tail:"," f.ty

let variant_text ~indent v =
  doc_lines ~indent v.v_doc
  @ attrs_lines ~indent v.v_attrs
  @ [
      spaces indent ^ ident v.v_name
      ^ (match v.payload with None -> "" | Some t -> "(" ^ type_text t ^ ")")
      ^ ",";
    ]

let line_comment text =
  if contains_newline text then
    invalid_arg "Rust_syntax: a line comment of lines";
  if text = "" then "//" else "// " ^ text

let item_text = function
  | Blank -> ""
  | Line_comment text -> line_comment text
  | Const { doc; attrs; vis; name; ty; value } ->
      String.concat "\n"
        (doc_lines ~indent:0 doc
        @ attrs_lines ~indent:0 attrs
        @ [ const_text ~indent:0 ~vis ~name ~ty value ])
  | Struct_def { doc; attrs; vis; name; generics; body } ->
      let head =
        vis_text vis ^ "struct " ^ ident name ^ generics_text generics
      in
      let body =
        match body with
        | Fields [] -> [ head ^ " {}" ]
        | Fields fields ->
            [ head ^ " {" ]
            @ List.concat_map (field_text ~indent:4) fields
            @ [ "}" ]
        | Tuple_fields tys ->
            [ head ^ "(" ^ String.concat ", " (List.map type_text tys) ^ ");" ]
      in
      String.concat "\n"
        (doc_lines ~indent:0 doc @ attrs_lines ~indent:0 attrs @ body)
  | Unit_struct { doc; vis; name } ->
      String.concat "\n"
        (doc_lines ~indent:0 doc
        @ [ vis_text vis ^ "struct " ^ ident name ^ ";" ])
  | Enum { doc; attrs; vis; name; variants } ->
      String.concat "\n"
        (doc_lines ~indent:0 doc
        @ attrs_lines ~indent:0 attrs
        @ [ vis_text vis ^ "enum " ^ ident name ^ " {" ]
        @ List.concat_map (variant_text ~indent:4) variants
        @ [ "}" ])
  | Impl { generics; trait_; for_; items } ->
      let head =
        "impl" ^ generics_text generics ^ " "
        ^ (match trait_ with None -> "" | Some t -> type_text t ^ " for ")
        ^ type_text for_
      in
      if String.length head + 2 > max_width then
        invalid_arg ("Rust_syntax: an impl's head too long: " ^ head);
      if items = [] then head ^ " {}"
      else
        String.concat "\n"
          ([ head ^ " {" ] @ List.map (impl_item_text ~indent:4) items @ [ "}" ])
  | Fn f -> fn_text ~indent:0 f
  | Type_alias { doc; vis; name; ty } ->
      String.concat "\n"
        (doc_lines ~indent:0 doc
        @ [ vis_text vis ^ "type " ^ ident name ^ " = " ^ type_text ty ^ ";" ])
  | Macro_item (name, args) -> (
      match
        let* s = sub_width (indented 0) 1 in
        rewrite (Macro (name, args)) s
      with
      | Some r -> r ^ ";"
      | None ->
          invalid_arg
            ("Rust_syntax: a macro rustfmt lays out otherwise: " ^ name))

(* A file: its opening comment lines, then its items. A blank line ending
   the file is none: rustfmt drops it. *)
let text ~header items =
  let items = List.rev (List.drop_while (( = ) Blank) (List.rev items)) in
  String.concat "\n" (List.map line_comment header @ List.map item_text items)
  ^ "\n"

(* One expression laid out at an indent, for the printer's tests. *)
let expr_text ?(indent = 0) e =
  match rewrite e (indented indent) with
  | Some s -> s
  | None -> invalid_arg "Rust_syntax: an expression that does not fit"

(* ---- Names as the SDK spells them ---- *)

(* [subjectClaim] as [subject_claim], and a JSON-LD keyword ([@id]) without
   its [@]. The printer writes a keyword raw. *)
let snake word =
  let n = String.length word in
  let start = ref 0 in
  while !start < n && word.[!start] = '@' do
    incr start
  done;
  let b = Buffer.create n in
  String.iteri
    (fun i c ->
      if i >= !start then
        match c with
        | 'A' .. 'Z' ->
            Buffer.add_char b '_';
            Buffer.add_char b (Char.lowercase_ascii c)
        | 'a' .. 'z' | '0' .. '9' | '_' -> Buffer.add_char b c
        | _ -> Buffer.add_char b '_')
    word;
  Buffer.contents b

(* [busRequestTimeoutMs] as [BUS_REQUEST_TIMEOUT_MS]. *)
let screaming word = String.uppercase_ascii (snake word)

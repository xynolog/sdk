(* Text as the generated files measure and spell it: a width is in code
   points, a word ends at ASCII white space, and a string literal is JSON's,
   which TypeScript, Go and Python each read as the same string, or, for Go
   and Python, one of printable ASCII. *)

let fold_uchars f init text =
  let rec go acc i =
    if i >= String.length text then acc
    else
      let decoded = String.get_utf_8_uchar text i in
      go
        (f acc (Uchar.utf_decode_uchar decoded))
        (i + Uchar.utf_decode_length decoded)
  in
  go init 0

let length text = fold_uchars (fun n _ -> n + 1) 0 text

(* [head] padded with spaces out to column [col]; a head that reaches it gets a
   single space. *)
let pad head col =
  let n = length head in
  head ^ if n < col then String.make (col - n) ' ' else " "

let is_hex_digit = function
  | '0' .. '9' | 'a' .. 'f' | 'A' .. 'F' -> true
  | _ -> false

let is_space u =
  match Uchar.to_int u with 0x09 | 0x0A | 0x0D | 0x20 -> true | _ -> false

let words text =
  let word = Buffer.create 16 in
  let flush acc =
    if Buffer.length word = 0 then acc
    else
      let w = Buffer.contents word in
      Buffer.clear word;
      w :: acc
  in
  List.rev
    (flush
       (fold_uchars
          (fun acc u ->
            if is_space u then flush acc
            else (
              Buffer.add_utf_8_uchar word u;
              acc))
          [] text))

(* [text] as comment lines behind [indent ^ marker], each as many words as fit
   within [width]. A word longer than the width has a line of its own. *)
let wrapped ~lead ~width text =
  let lines, last =
    List.fold_left
      (fun (lines, line) word ->
        if line <> "" && length (lead ^ line ^ " " ^ word) > width then
          (line :: lines, word)
        else (lines, if line = "" then word else line ^ " " ^ word))
      ([], "") (words text)
  in
  List.rev (if last = "" then lines else last :: lines)

(* Prose as a spec states it: paragraphs, each a text of words or a list of
   items. *)
type paragraph = Words of string | Items of string list

(* [paragraphs] as comment lines behind [lead], within [width]: each
   paragraph's words wrapped, an item's first line behind ["- "] and its
   others behind two spaces, and an empty line between paragraphs. *)
let paragraphs ~lead ~width paragraphs =
  let item text =
    match wrapped ~lead:(lead ^ "  ") ~width text with
    | first :: rest -> ("- " ^ first) :: List.map (fun l -> "  " ^ l) rest
    | [] -> []
  in
  List.concat
    (List.mapi
       (fun i paragraph ->
         (if i > 0 then [ "" ] else [])
         @
         match paragraph with
         | Words text -> wrapped ~lead ~width text
         | Items items -> List.concat_map item items)
       paragraphs)

let replace_all ~sub ~by text =
  let n = String.length sub and length = String.length text in
  let out = Buffer.create length in
  let rec go i =
    if i > length - n then
      Buffer.add_string out (String.sub text i (length - i))
    else if String.sub text i n = sub then (
      Buffer.add_string out by;
      go (i + n))
    else (
      Buffer.add_char out text.[i];
      go (i + 1))
  in
  go 0;
  Buffer.contents out

(* [text] in the pieces between each [sub] in it: one more than there are. *)
let split ~sub text =
  let n = String.length sub and length = String.length text in
  let rec go start i pieces =
    if i > length - n then
      List.rev (String.sub text start (length - start) :: pieces)
    else if String.sub text i n = sub then
      go (i + n) (i + n) (String.sub text start (i - start) :: pieces)
    else go start (i + 1) pieces
  in
  go 0 0 []

(* [text] as a one-line TypeScript doc comment, which a [*/] in it would end
   early. *)
let doc_comment text = "/** " ^ replace_all ~sub:"*/" ~by:"*\\/" text ^ " */"

(* A string as JSON writes it: quoted, with a quote, a backslash and the
   control characters escaped, and every other character as itself. *)
let quoted text =
  let out = Buffer.create (String.length text + 2) in
  Buffer.add_char out '"';
  String.iter
    (function
      | '"' -> Buffer.add_string out "\\\""
      | '\\' -> Buffer.add_string out "\\\\"
      | '\b' -> Buffer.add_string out "\\b"
      | '\012' -> Buffer.add_string out "\\f"
      | '\n' -> Buffer.add_string out "\\n"
      | '\r' -> Buffer.add_string out "\\r"
      | '\t' -> Buffer.add_string out "\\t"
      | c when Char.code c < 0x20 ->
          Buffer.add_string out (Printf.sprintf "\\u%04x" (Char.code c))
      | c -> Buffer.add_char out c)
    text;
  Buffer.add_char out '"';
  Buffer.contents out

(* A string as a Go or a Python literal of printable ASCII: a quote and a
   backslash escaped; backspace, tab, line feed, form feed and carriage return
   by their short escapes; and every other character outside printable ASCII
   by its code point, in four hex digits or, past the Basic Multilingual
   Plane, eight. *)
let ascii_quoted text =
  let out = Buffer.create (String.length text + 2) in
  Buffer.add_char out '"';
  fold_uchars
    (fun () u ->
      match Uchar.to_int u with
      | 0x22 -> Buffer.add_string out "\\\""
      | 0x5C -> Buffer.add_string out "\\\\"
      | 0x08 -> Buffer.add_string out "\\b"
      | 0x09 -> Buffer.add_string out "\\t"
      | 0x0A -> Buffer.add_string out "\\n"
      | 0x0C -> Buffer.add_string out "\\f"
      | 0x0D -> Buffer.add_string out "\\r"
      | code when code >= 0x20 && code < 0x7F ->
          Buffer.add_char out (Char.chr code)
      | code when code <= 0xFFFF ->
          Buffer.add_string out (Printf.sprintf "\\u%04x" code)
      | code -> Buffer.add_string out (Printf.sprintf "\\U%08x" code))
    () text;
  Buffer.add_char out '"';
  Buffer.contents out

(* A camel-case name as a constant's: upper case, with an underscore where a
   lower-case letter meets an upper-case one ([emitRetry] is [EMIT_RETRY]). *)
let upper_snake name =
  let out = Buffer.create (String.length name + 8) in
  String.iteri
    (fun i c ->
      (match c with
      | 'A' .. 'Z' when i > 0 -> (
          match name.[i - 1] with
          | 'a' .. 'z' -> Buffer.add_char out '_'
          | _ -> ())
      | _ -> ());
      Buffer.add_char out (Char.uppercase_ascii c))
    name;
  Buffer.contents out

(* [text] as a Python docstring behind [indent]: its words wrapped at 96
   columns, and one line when they wrap to one that its quotes keep within the
   140 the Python SDK's formatter allows, with the closing quotes on a line of
   their own otherwise. A backslash and a [""""] in it are escaped, and a
   closing quote of its own is kept off the docstring's. *)
let python_docstring ~indent text =
  let safe =
    replace_all ~sub:{|"""|} ~by:{|\"\"\"|}
      (replace_all ~sub:"\\" ~by:"\\\\" text)
  in
  let quotes = {|"""|} in
  match wrapped ~lead:indent ~width:96 safe with
  | [ line ] when length (indent ^ quotes ^ line ^ quotes) <= 140 ->
      let line =
        if String.ends_with ~suffix:"\"" line then line ^ " " else line
      in
      indent ^ quotes ^ line ^ quotes
  | first :: rest ->
      indent ^ quotes ^ first ^ "\n"
      ^ String.concat "" (List.map (fun l -> indent ^ l ^ "\n") rest)
      ^ indent ^ quotes
  | [] -> indent ^ quotes ^ quotes

(* A camel-case name in lower snake case: an underscore where a lower-case
   letter or a digit meets an upper-case one ([ResourceId] is
   [resource_id]). *)
let snake name =
  let out = Buffer.create (String.length name + 8) in
  String.iteri
    (fun i c ->
      (match c with
      | 'A' .. 'Z' when i > 0 -> (
          match name.[i - 1] with
          | 'a' .. 'z' | '0' .. '9' -> Buffer.add_char out '_'
          | _ -> ())
      | _ -> ());
      Buffer.add_char out (Char.lowercase_ascii c))
    name;
  Buffer.contents out

(* [job:create] as [JobCreate]: every run of letters and digits, its first
   letter upper case. *)
let pascal word =
  let b = Buffer.create (String.length word) in
  let upper = ref true in
  String.iter
    (fun c ->
      match c with
      | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' ->
          Buffer.add_char b (if !upper then Char.uppercase_ascii c else c);
          upper := false
      | _ -> upper := true)
    word;
  Buffer.contents b

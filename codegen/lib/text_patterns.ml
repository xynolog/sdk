(* What texts a schema's [pattern] admits, read as an automaton, so that two
   patterns can be shown to admit no text in common, and a value shown to be
   one a pattern refuses. A pattern is ECMA's, found anywhere in a text unless
   it is anchored. It is read over the ASCII characters and one more that
   stands for every other character: a set of characters holds that one when
   it holds any character past ASCII. Two patterns whose automata share no
   text so read share none at all, since a text both admit reads as one both
   automata admit. A pattern of a form this does not read is [None], and
   proves nothing. *)

let other = 128
let symbols = 129

type set = bool array

let none () = Array.make symbols false
let all () = Array.make symbols true

let of_chars chars =
  let s = none () in
  List.iter (fun c -> s.(Char.code c) <- true) chars;
  s

let range a b =
  let s = none () in
  for c = Char.code a to Char.code b do
    s.(c) <- true
  done;
  s

let union a b = Array.init symbols (fun i -> a.(i) || b.(i))
let complement a = Array.map not a
let meets a b = Array.exists2 ( && ) a b

(* ECMA's [\s] holds whitespace past ASCII too. *)
let whitespace =
  union
    (of_chars [ ' '; '\t'; '\n'; '\r'; '\011'; '\012' ])
    (let s = none () in
     s.(other) <- true;
     s)

let not_whitespace =
  let s = complement whitespace in
  s.(other) <- true;
  s

let digit = range '0' '9'

let word =
  union (union (range 'a' 'z') (range 'A' 'Z')) (union digit (of_chars [ '_' ]))

let line_terminators = of_chars [ '\n'; '\r' ]

(* [.]: every character but a line's end, which past ASCII includes some. *)
let dot = complement line_terminators

type node =
  | Chars of set
  | Seq of node list
  | Alt of node list
  | Repeat of node * int * int option

exception Unread

let parse pattern =
  let n = String.length pattern in
  let at = ref 0 in
  let peek () = if !at < n then Some pattern.[!at] else None in
  let next () =
    match peek () with
    | Some c ->
        incr at;
        c
    | None -> raise Unread
  in
  let literal c = if Char.code c >= 128 then raise Unread else of_chars [ c ] in
  let escape ~in_class =
    match next () with
    | 'd' -> digit
    | 'D' -> complement digit
    | 'w' -> word
    | 'W' -> complement word
    | 's' -> whitespace
    | 'S' -> not_whitespace
    | 'n' -> of_chars [ '\n' ]
    | 't' -> of_chars [ '\t' ]
    | 'r' -> of_chars [ '\r' ]
    | 'b' when in_class -> of_chars [ '\b' ]
    | c
      when not
             (('a' <= c && c <= 'z')
             || ('A' <= c && c <= 'Z')
             || ('0' <= c && c <= '9')) ->
        literal c
    | _ -> raise Unread
  in
  let class_ () =
    let negated = peek () = Some '^' in
    if negated then incr at;
    let rec members acc first =
      match next () with
      | ']' when not first -> acc
      | '\\' -> members (union acc (escape ~in_class:true)) false
      | c -> (
          match
            (peek (), if !at + 1 < n then Some pattern.[!at + 1] else None)
          with
          | Some '-', Some d when d <> ']' ->
              at := !at + 2;
              if Char.code c >= 128 || Char.code d >= 128 || d < c then
                raise Unread;
              members (union acc (range c d)) false
          | _ -> members (union acc (literal c)) false)
    in
    let set = members (none ()) true in
    if negated then complement set else set
  in
  let number () =
    let start = !at in
    while match peek () with Some '0' .. '9' -> true | _ -> false do
      incr at
    done;
    if !at = start then raise Unread;
    int_of_string (String.sub pattern start (!at - start))
  in
  let rec alternatives () =
    let first = sequence () in
    if peek () = Some '|' then (
      incr at;
      match alternatives () with
      | Alt rest -> Alt (first :: rest)
      | other -> Alt [ first; other ])
    else first
  and sequence () =
    let rec go acc =
      match peek () with
      | None | Some '|' | Some ')' -> Seq (List.rev acc)
      | Some '$' when !at = n - 1 -> Seq (List.rev acc)
      | _ -> go (quantified (atom ()) :: acc)
    in
    go []
  and atom () =
    match next () with
    | '(' ->
        if peek () = Some '?' then (
          incr at;
          if next () <> ':' then raise Unread);
        let inner = alternatives () in
        if next () <> ')' then raise Unread;
        inner
    | '[' -> Chars (class_ ())
    | '.' -> Chars dot
    | '\\' -> Chars (escape ~in_class:false)
    | '^' | '$' | '*' | '+' | '?' | '{' | ')' | ']' | '}' -> raise Unread
    | c -> Chars (literal c)
  and quantified node =
    match peek () with
    | Some '*' ->
        incr at;
        lazy_ (Repeat (node, 0, None))
    | Some '+' ->
        incr at;
        lazy_ (Repeat (node, 1, None))
    | Some '?' ->
        incr at;
        lazy_ (Repeat (node, 0, Some 1))
    | Some '{' ->
        incr at;
        let least = number () in
        let most =
          match next () with
          | '}' -> Some least
          | ',' -> (
              match peek () with
              | Some '}' ->
                  incr at;
                  None
              | _ ->
                  let most = number () in
                  if next () <> '}' then raise Unread;
                  Some most)
          | _ -> raise Unread
        in
        lazy_ (Repeat (node, least, most))
    | _ -> node
  (* A lazy quantifier admits the texts its greedy one does. *)
  and lazy_ node =
    if peek () = Some '?' then incr at;
    node
  in
  let anchored_start = n > 0 && pattern.[0] = '^' in
  if anchored_start then incr at;
  let body = alternatives () in
  let anchored_end = peek () = Some '$' in
  if anchored_end then incr at;
  if !at <> n then raise Unread;
  let anywhere = Repeat (Chars (all ()), 0, None) in
  Seq
    ((if anchored_start then [] else [ anywhere ])
    @ [ body ]
    @ if anchored_end then [] else [ anywhere ])

(* An automaton: each state's moves on a set of symbols, and the states it
   reaches on none. *)
type automaton = {
  moves : (set * int) list array;
  silent : int list array;
  start : int;
  final : int;
}

let compile node =
  let moves = ref [] and silent = ref [] and count = ref 0 in
  let state () =
    let s = !count in
    incr count;
    s
  in
  let move a set b = moves := (a, (set, b)) :: !moves in
  let link a b = silent := (a, b) :: !silent in
  (* [from] reaches the returned state through what [node] admits. *)
  let rec build from = function
    | Chars set ->
        let to_ = state () in
        move from set to_;
        to_
    | Seq nodes -> List.fold_left build from nodes
    | Alt nodes ->
        let to_ = state () in
        List.iter (fun node -> link (build from node) to_) nodes;
        to_
    | Repeat (node, least, most) -> (
        let rec times k from =
          if k = 0 then from else times (k - 1) (build from node)
        in
        let after = times least from in
        match most with
        | None ->
            let loop = state () in
            link after loop;
            link (build loop node) loop;
            loop
        | Some most ->
            let to_ = state () in
            link after to_;
            let rec optional k from =
              if k > 0 then (
                let next = build from node in
                link next to_;
                optional (k - 1) next)
            in
            optional (most - least) after;
            to_)
  in
  let start = state () in
  let final = build start node in
  let table pairs =
    Array.init !count (fun s ->
        List.filter_map (fun (a, x) -> if a = s then Some x else None) pairs)
  in
  { moves = table !moves; silent = table !silent; start; final }

let read pattern =
  match parse pattern with
  | node ->
      let n = compile node in
      if Array.length n.moves > 4096 then None else Some n
  | exception (Unread | Failure _) -> None

let closure a states =
  let seen = Hashtbl.create 16 in
  let rec go s =
    if not (Hashtbl.mem seen s) then (
      Hashtbl.replace seen s ();
      List.iter go a.silent.(s))
  in
  List.iter go states;
  Hashtbl.fold (fun s () acc -> s :: acc) seen []

(* Whether some text is admitted by both. *)
let meet a b =
  let seen = Hashtbl.create 256 in
  let rec go = function
    | [] -> false
    | (p, q) :: rest when Hashtbl.mem seen (p, q) -> go rest
    | (p, q) :: rest ->
        Hashtbl.replace seen (p, q) ();
        if p = a.final && q = b.final then true
        else
          let silent =
            List.map (fun p' -> (p', q)) a.silent.(p)
            @ List.map (fun q' -> (p, q')) b.silent.(q)
          in
          let moved =
            List.concat_map
              (fun (s, p') ->
                List.filter_map
                  (fun (t, q') -> if meets s t then Some (p', q') else None)
                  b.moves.(q))
              a.moves.(p)
          in
          go (silent @ moved @ rest)
  in
  go [ (a.start, b.start) ]

(* Whether no text is admitted by both patterns, where both are read. *)
let disjoint p q =
  match (read p, read q) with Some a, Some b -> not (meet a b) | _ -> false

(* Whether [pattern], read, refuses [text]. *)
let refuses pattern text =
  match read pattern with
  | None -> false
  | Some a ->
      let states =
        Text.fold_uchars
          (fun states u ->
            let symbol = min other (Uchar.to_int u) in
            closure a
              (List.concat_map
                 (fun s ->
                   List.filter_map
                     (fun (set, t) -> if set.(symbol) then Some t else None)
                     a.moves.(s))
                 states))
          (closure a [ a.start ]) text
      in
      not (List.mem a.final states)

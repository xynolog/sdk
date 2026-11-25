(* Where a writer of types still reads Protocol otherwise than [Typing] does:
   each one here, by name, what [Typing] says, what the writer does instead,
   and the writers that do it. Each is deleted by the commit that brings its
   writers to what [Typing] says, which changes their public names, the
   values they accept or what they write, and so is the user's to decide.
   Nothing else in a writer decides a shape. *)

module T = Typing

(* Rust and Go describe a declaration, a member and a type in place by its
   [node_description]: an [allOf]'s by what its merge says, and nothing of a
   schema beside null, where [Typing] has its [description], what the schema
   says of itself, or beside null what the schema beside it says. Python
   does so of an [allOf] in place it writes as what it merges to. *)

(* Rust, Go and OCaml hold a union every member of which is text as a
   string, where [Typing] has the union, its members told apart by their
   patterns. *)
let text_union (u : T.union) = List.for_all T.admits_only_text u.branches

(* Rust names an object in place that is closed and names no member, but
   does not say [maxProperties: 0], for its place, and Python every object in
   place that holds no member ([Typing.holds_none]), where [Typing] has the
   one empty object, as Go has. *)
let closed_empty_named (form : T.form) =
  match form with
  | T.Empty { rest = T.Closed; none = false } -> true
  | _ -> false

(* Every writer holds an object written in place that names no member and
   says nothing of others ([Unstated]), as an event's [payload] or a JSON-LD
   [@context] is, as a map of whatever members it is given, where [Typing]
   has it hold none. *)

(* Go declares a named map whose key and item types carry every constraint
   its schema states ([LastEventIds]) as a type of its own, where [Typing]
   has it an alias of the map: go/internal/required attaches what a value
   is held to to a named type. *)

(* Go and Python hold a member that may be left out and one that may be
   null alike (a pointer, [T | None]), where [Typing] has them apart
   ([member.required], [Nullable]). *)

(* Python writes a union in place, but for one a list holds, as what it
   holds, naming none of what [Typing] invents. *)

(* OCaml reads a [const] member of a component's record, or one whose
   schema's file states a [const], as its scalar, where [Typing] has the
   enumeration of its one value. *)
let ocaml_const (spec : Spec.t) ~file (wire : string) =
  let find (r : Decode.reference) =
    match List.assoc_opt (fst (Decode.resolve spec.ids r)) spec.schemas with
    | Some s -> Ok s
    | None -> Error ("$ref " ^ r.target ^ " names no schema")
  in
  let const_file (r : Decode.reference) =
    match Decode.resolve spec.ids r with
    | file, "" -> (
        match List.assoc_opt file spec.schemas with
        | Some (Schema.Schema { const = Some _; _ }) -> true
        | _ -> false)
    | _ -> false
  in
  let rec read (l : Schema.t Schema.layer) =
    match l with
    | { ref_ = Some r; _ } -> const_file r
    | { const = Some _; _ } -> true
    | { type_ = Some [ Array ]; items = Some (Schema.Schema i); _ } -> read i
    | _ -> false
  in
  match Normalize.normalize spec.ids ~find (List.assoc file spec.schemas) with
  | Ok { properties = Some properties; _ } -> (
      match List.assoc_opt wire properties with
      | Some (Schema.Schema l) -> (
          match Null_form.without_null Fun.id l with
          | Ok (Some beside) -> read beside
          | Ok None -> read l
          | Error _ -> false)
      | _ -> false)
  | _ -> false

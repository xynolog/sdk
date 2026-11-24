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

(* Rust and Go hold a union every member of which is text as a string, where
   [Typing] has the union, its members told apart by their patterns. *)
let text_union (u : T.union) = List.for_all T.admits_only_text u.branches

(* Rust decodes a union whose [discriminator] names one value per member by
   that value, and any other as the first member that fits, where [Typing]
   tells every union's members apart by their signatures: a union whose
   members state several values of it (AnchoredTextAnswer) is decoded as
   the first that fits. *)
let single_tags (u : T.union) =
  match u.tag with
  | Some { property; values }
    when List.for_all (fun v -> List.length v = 1) values ->
      Some (property, List.map List.hd values)
  | _ -> None

(* Go holds a union's value as the wire carries it, and its caller reads it
   as whichever member the caller names ([As]); only a union told apart by
   a tag says which member a value is ([ValueByDiscriminator]). [Typing]
   tells every union's members apart by their signatures. *)

(* Rust names an object in place that is closed and names no member, but
   does not say [maxProperties: 0], for its place, and Python every object in
   place that holds no member ([Typing.holds_none]), where [Typing] has the
   one empty object, as Go has. *)
let closed_empty_named (form : T.form) =
  match form with
  | T.Empty { rest = T.Closed; none = false } -> true
  | _ -> false

(* An object that says nothing of the members it does not name ([Unstated])
   holds any, as [Typing] has it. Every writer drops them where the object
   names members; TypeScript holds one that names none as holding none
   ([Record<string, never>]), and Rust and Python declare one so named as a
   type that drops them, where Go keeps them. *)

(* Go and Python hold a member that may be left out and one that may be
   null alike (a pointer, [T | None]), where [Typing] has them apart
   ([member.required], [Nullable]). *)

(* Rust holds an enumeration in place of integers, numbers or booleans as
   its scalar, dropping its values, where [Typing] has the enumeration, as
   Go declares it and Python and TypeScript hold it as its literals. *)

(* TypeScript writes every schema in place as what it holds, and Python a
   union in place but one a list holds, naming none of what [Typing]
   invents. *)

(* OCaml reads a member of a component's record as the schema of the
   component's file states it, its [allOf] merged ([Normalize]), where
   [Typing] reads it as it means: a member that a pointer into another
   file's member states, or that states no type (as an [allOf] child that
   restates its parent's member does), is kept raw, where [Typing] writes
   that member in its place, or as what it means; and a [const], or a schema whose file states one, is read as
   its scalar, where [Typing] has the enumeration of its one value. *)
type ocaml_member = As_typed | Raw | Const

let ocaml_member (spec : Spec.t) ~file (wire : string) =
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
    | { ref_ = Some r; _ } when snd (Decode.resolve spec.ids r) <> "" -> Raw
    | { ref_ = Some r; _ } when const_file r -> Const
    | { ref_ = None; type_ = None; _ } -> Raw
    | { const = Some _; _ } -> Const
    | { type_ = Some [ Array ]; items = Some (Schema.Schema i); _ } -> read i
    | _ -> As_typed
  in
  match Normalize.normalize spec.ids ~find (List.assoc file spec.schemas) with
  | Ok { properties = Some properties; _ } -> (
      match List.assoc_opt wire properties with
      | Some (Schema.Schema l) -> (
          match Null_form.without_null Fun.id l with
          | Ok (Some beside) -> read beside
          | Ok None -> read l
          | Error _ -> Raw)
      | _ -> As_typed)
  | _ -> As_typed

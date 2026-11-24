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
   says of itself, or beside null what the schema beside it says. *)

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

(* Rust names an object in place that is closed and names no member, but
   does not say [maxProperties: 0], for its place, where [Typing] has the one
   empty object. *)
let closed_empty_named (form : T.form) =
  match form with
  | T.Empty { rest = T.Closed; none = false } -> true
  | _ -> false

(* TypeScript holds an object that names no member, and says nothing of
   others, as one that holds none ([Record<string, never>]), and gives an
   object that names members and says nothing of others no index signature,
   where [Typing] has its [rest] [Unstated]. *)

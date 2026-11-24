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

(* Go and Python hold a member that may be left out and one that may be
   null alike (a pointer, [T | None]), where [Typing] has them apart
   ([member.required], [Nullable]). *)

(* TypeScript writes every schema in place as what it holds, and Python a
   union in place but one a list holds, naming none of what [Typing]
   invents. *)

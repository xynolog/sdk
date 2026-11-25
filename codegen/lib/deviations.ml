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

(* OCaml holds an enumeration of integers, numbers or booleans, a constant
   among them, as its scalar, where [Typing] has the enumeration. *)

(* Haskell declares an enumeration only where a schema states [enum], and
   holds a [const] as its scalar, where [Typing] has the enumeration of its
   one value. *)
let haskell_enumeration (s : Schema.schema) = Option.is_some s.enum

(* Haskell constructs a record or newtype written in place as a union's
   member by [Mk] and its name ([MkConformanceDriverLineAbandoned]): the
   union's constructor for it is the union's name and the member's variant,
   which is the type's name, and Haskell's constructors share one namespace,
   where [Typing] has a type constructed by its name. *)

(* Haskell declares every named schema that is no record, enumeration or
   union as a newtype, a named list or map among them, where [Typing] has it
   an alias. *)

(* Haskell reads a union as the first member that parses, where [Typing]
   tells its members apart by their signatures. *)

(* Haskell holds a schema in place that states one [allOf] as that [allOf]'s
   schema, dropping what it states beside it ([KnowledgeIndex]'s
   [spec.graph] is a [Runner]), where [Typing] merges them. *)

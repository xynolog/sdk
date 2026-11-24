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

(* Go declares a named map whose key and item types carry every constraint
   its schema states ([LastEventIds]) as a type of its own, where [Typing]
   has it an alias of the map: go/internal/required attaches what a value
   is held to to a named type. *)

(* Go and Python hold a member that may be left out and one that may be
   null alike (a pointer, [T | None]), where [Typing] has them apart
   ([member.required], [Nullable]). *)

(* Python writes a union in place, but for one a list holds, as what it
   holds, naming none of what [Typing] invents. *)

(* Kotlin describes as Rust and Go do ([node_description]), holds a union
   every member of which is text as a [String] ([text_union]), and decodes a
   union whose [discriminator] names one value per member by that value
   ([Kotlin_sdk.Types]); any other is decoded as the first member, of the
   kinds of JSON each is read from, that fits, a member that names a union
   being read from every kind, where [Typing] tells every union's members
   apart by their signatures. It holds an enumeration in place of integers, numbers or booleans,
   as a const of one is, as its scalar, dropping its values. *)

(* Swift holds an object's members in the order of their names, where
   [Typing] has the schema's order, and so takes them in that order to make
   one. It holds an [allOf] of one schema as that schema, reading past what
   is stated beside it (a const of the schema's values), where [Typing] has
   what they merge to. It names a union's member that is an object of no
   named member [empty], and the items of its member that is a list for the
   union's place and [ListItem], where [Typing] has [Object] and the union's
   place and [Item]. It decodes a union not told apart by its
   [discriminator] as the first member that decodes. It holds an
   enumeration in place of numbers as a [Double], dropping its values. *)

(* C# holds an object's members in the order of their names, where [Typing]
   has the schema's order, and so takes them in that order to make one. It
   names a union's member [Case] after its variant, and the variant of a
   member that is a list [Array], and of one that is neither a reference,
   text nor an object of named members [Object], where [Typing] has [List],
   [Integer], [Number], [Boolean] and [Empty]; the type of a member that is
   an object of no named member is the union's place and [Object], and of
   the items of one that is a list its place and [ArrayItem], where
   [Typing] has [Empty] and [Item]. It holds a member that is required, not
   null and of one string as a constant of [string], no type of its own. It
   reads a union's value as the one member it validates against, of the
   schemas it validates each value against (WireSchemas), where [Typing]
   has each member's signature. It holds an enumeration in place of
   integers, numbers or booleans as its scalar, dropping its values, and
   declares a map as a record that keeps its members
   ([AdditionalProperties]), where [Typing] has an alias. *)

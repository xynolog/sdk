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

(* Kotlin describes as Rust and Go do ([node_description]), holds a union
   every member of which is text as a [String] ([text_union]), and decodes a
   union as Rust does ([single_tags]): any union not told apart by one value
   per member is decoded as the first member, of the kinds of JSON each is
   read from, that fits, a member that names a union being read from every
   kind. It holds an enumeration in place of integers, numbers or booleans,
   as a const of one is, as its scalar, dropping its values. It declares an
   object of no member that says nothing of others ([Unstated]) as a type
   that drops them, and holds one in place as a JSON object, which keeps
   them. *)

(* Swift holds an object's members in the order of their names, where
   [Typing] has the schema's order, and so takes them in that order to make
   one. It holds an [allOf] of one schema as that schema, reading past what
   is stated beside it (a const of the schema's values), where [Typing] has
   what they merge to. It names a union's member that is an object of no
   named member [empty], and the items of its member that is a list for the
   union's place and [ListItem], where [Typing] has [Object] and the union's
   place and [Item]. It decodes a union not told apart by its
   [discriminator] as the first member that decodes. It holds an
   enumeration in place of numbers as a [Double], dropping its values. It
   declares an object of no member that says nothing of others
   ([Unstated]) as a type that drops them, and holds one in place that
   holds any ([Open]) as a dictionary. *)

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
   integers, numbers or booleans as its scalar, dropping its values; an
   object in place of no member that says nothing of others ([Unstated]) as
   JSON, which keeps them, and declares a named one as a record that drops
   them; and declares a map as a record that keeps its members
   ([AdditionalProperties]), where [Typing] has an alias. *)

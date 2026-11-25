(** How a record of {!Records} reads an object's members, the gateway having
    decoded the object as the record's schema, and writes them back: each read
    names the member it reads, and the members no read named are the record's
    [extra]. *)

type t

val start : (string * Yojson.Raw.t) list -> t

val fields_of : Yojson.Raw.t -> (string * Yojson.Raw.t) list
(** An object's members. *)

val string : Yojson.Raw.t -> string
val bool : Yojson.Raw.t -> bool

val int : Yojson.Raw.t -> int
(** An integer as the schema reads one: 1.0 is an integer. *)

val float : Yojson.Raw.t -> float
val enum : (string -> 'a option) -> Yojson.Raw.t -> 'a
val list : (Yojson.Raw.t -> 'a) -> Yojson.Raw.t -> 'a list
val nullable : (Yojson.Raw.t -> 'a) -> Yojson.Raw.t -> 'a option

val record : ((string * Yojson.Raw.t) list -> 'a) -> Yojson.Raw.t -> 'a
(** An object a record of its own reads. *)

val map : (Yojson.Raw.t -> 'a) -> Yojson.Raw.t -> (string * 'a) list
(** An object of members each of whose values [read] reads, by name. *)

val tabled : (Yojson.Safe.t -> ('a, 'error) result) -> Yojson.Raw.t -> 'a
(** A table record, which its own reader reads. *)

val raw : Yojson.Raw.t -> Yojson.Raw.t
(** A member kept as its JSON, numbers exactly. *)

val required : t -> (Yojson.Raw.t -> 'a) -> string -> 'a
val optional : t -> (Yojson.Raw.t -> 'a) -> string -> 'a Types.presence

val maybe : t -> (Yojson.Raw.t -> 'a) -> string -> 'a option
(** A member that may be absent but not null; the decoder refuses its null. *)

val rest : t -> (string * Yojson.Raw.t) list
(** The members no read named, in the object's order. *)

val json_string : string -> Yojson.Raw.t
val json_bool : bool -> Yojson.Raw.t
val json_int : int -> Yojson.Raw.t
val json_float : float -> Yojson.Raw.t
val json_enum : ('a -> string) -> 'a -> Yojson.Raw.t
val json_list : ('a -> Yojson.Raw.t) -> 'a list -> Yojson.Raw.t
val json_nullable : ('a -> Yojson.Raw.t) -> 'a option -> Yojson.Raw.t
val json_raw : Yojson.Raw.t -> Yojson.Raw.t
val json_map : ('a -> Yojson.Raw.t) -> (string * 'a) list -> Yojson.Raw.t
val json_tabled : ('a -> Yojson.Safe.t) -> 'a -> Yojson.Raw.t
val present : ('a -> Yojson.Raw.t) -> 'a Types.presence -> Yojson.Raw.t option

(** What a member of a union admits, as its schema states it: the kind of value,
    the members an object of it requires, every member it allows if it is
    closed, the values a member may take, and every value it admits if it says.
*)
type kind =
  | Text_kind
  | Integer_kind
  | Number_kind
  | Boolean_kind
  | List_kind
  | Object_kind
  | Null_kind
  | Any_kind

type literal =
  | Text_value of string
  | Integer_value of int
  | Boolean_value of bool

type signature = {
  kind : kind;
  required : string list;
  allowed : string list option;
  fixed : (string * literal list) list;
  values : literal list option;
}

val member : signature list list -> Yojson.Raw.t -> int
(** The one member of a union, by the signatures of each, that admits a value of
    the union: no two admit one value. *)

val write :
  (string * Yojson.Raw.t option) list ->
  (string * Yojson.Raw.t) list ->
  Yojson.Raw.t
(** The members stated, each but the absent, and then those of the extra that no
    stated one names. *)

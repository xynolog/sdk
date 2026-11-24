type kind = Object | Array | String | Integer | Number | Boolean | Null

(* A term of a pattern, repeated at least its min and at most its max times
   (None: any number): a step, a text's next code point in one of its ranges;
   or a group, the text's next code points one of its alternatives. *)
type term =
  | Step of (int * int) list * int * int option
  | Group of term list list * int * int option

type t = {
  reference : string option;
  kinds : kind list option;
  enum : Yojson.Raw.t list option;
  recognized : string list option;
  pattern : term list option;
  min_length : int option;
  max_length : int option;
  minimum : string option;
  maximum : string option;
  min_items : int option;
  max_items : int option;
  required : string list;
  members : (string * t) list;
  closed : string list option;
  items : t option;
  values : t option;
  variants : t list;
  discriminator : (string * (string * int) list) option;
  all_of : t list;
  not_all : string list list;
  min_members : int option;
  names : t option;
}

let any =
  {
    reference = None;
    kinds = None;
    enum = None;
    recognized = None;
    pattern = None;
    min_length = None;
    max_length = None;
    minimum = None;
    maximum = None;
    min_items = None;
    max_items = None;
    required = [];
    members = [];
    closed = None;
    items = None;
    values = None;
    variants = [];
    discriminator = None;
    all_of = [];
    not_all = [];
    min_members = None;
    names = None;
  }

let reference name = { any with reference = Some name }

let object_ ?(required = []) ?(members = []) ?closed () =
  { any with kinds = Some [ Object ]; required; members; closed }

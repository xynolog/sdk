(** Membership of a raw field that may be absent: absent, null or a value. *)
type 'a presence = Absent | Null | Present of 'a

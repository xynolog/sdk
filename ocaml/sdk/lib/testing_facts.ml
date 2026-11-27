(* Generated from client/testing.json. Do not edit.
   Regenerate: make generate (codegen/lib/testing/ocaml.ml) *)

type fault_action =
  | Deliver
  | Drop_reply
  | Delay of int
  | Duplicate_reply
  | Reject_emit

type delivery_op = Write | Transition

let delivery_op_name = function Write -> "write" | Transition -> "transition"
let every_delivery_op = [ Write; Transition ]

let fault_actions random =
  match Random.State.int random 5 with
  | 0 -> Deliver
  | 1 -> Drop_reply
  | 2 -> Delay (0 + Random.State.int random 6)
  | 3 -> Duplicate_reply
  | 4 -> Reject_emit
  | _ -> assert false

let schedule_length = (1, 8)
let slack = 4

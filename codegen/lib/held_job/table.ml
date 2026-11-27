(* Each handed of client/surface.json's worker that names a record: a value
   of that client type, whose properties are the handed's first members, in
   order, each taking nothing (Protocol's reader holds them to that). An
   SDK's handed has the record whole beside them, and each of those members
   is the record's property of its name. *)

type t = {
  handed : string;  (** The handed, as client/surface.json names it. *)
  record : string;  (** The client type it holds. *)
}

let file = "client/surface.json"

let all (spec : Spec.t) =
  List.filter_map
    (fun (w : Tables.Client_surface.worker_item) ->
      Option.map (fun record -> { handed = w.handed; record }) w.record)
    spec.tables.client_surface.worker

(* Why an SDK with no type of a handed refuses it. *)
let refusal ~sdk (t : t) =
  Printf.sprintf
    "%s: %s's %s names the record %s, and the %s SDK has no type of it" file
    "worker" t.handed t.record sdk

(* What an SDK whose types of a handed are its own names it by: [held],
   given the handed's name in client/surface.json, or a refusal of one it
   has no type of. *)
let types ~sdk held (t : t) =
  match held t.handed with
  | Some types -> types
  | None -> Definitions.refuse "%s" (refusal ~sdk t)

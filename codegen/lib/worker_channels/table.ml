(* The constants of client/surface.json that are the channels a stream names
   (a constant's [names]): the reply channels of each operation it names,
   then each other channel it names, every one of bus/registry.json, which
   Protocol's reader holds them to. *)

module R = Tables.Bus_registry

let file = "client/surface.json"

type t = {
  member : string;  (** The constant, as client/surface.json names it. *)
  replies_of : string list;  (** Each operation, by its request channel. *)
  others : string list;  (** Each other channel it names. *)
  channels : string list;
      (** Each channel it names, by its name in bus/registry.json: each
          operation's result then its failure, then each of [others]. *)
}

let replies (registry : R.t) request =
  match
    List.find_opt
      (fun (o : R.operations_item) -> o.request = request)
      registry.operations
  with
  | Some o -> [ o.result; o.failure ]
  | None -> invalid_arg ("Worker_channels: no operation " ^ request)

let all (spec : Spec.t) =
  List.concat_map
    (fun (m : Tables.Client_surface.modules_item) ->
      List.filter_map
        (function
          | Tables.Client_surface.Constant { member; names = Some names; _ } ->
              Some
                {
                  member;
                  replies_of = names.replies_of;
                  others = names.channels;
                  channels =
                    List.concat_map
                      (replies spec.tables.bus_registry)
                      names.replies_of
                    @ names.channels;
                }
          | Reader _ | Function _ | Type _ | Constant { names = None; _ } ->
              None)
        m.members)
    spec.tables.client_surface.modules

let series = function
  | [] -> ""
  | [ one ] -> one
  | many ->
      let rev = List.rev many in
      String.concat ", " (List.rev (List.tl rev)) ^ " and " ^ List.hd rev

(* What a constant names, in words: "the replies of job:claim, then job:queued
   and job:cancel-requested". *)
let described (t : t) =
  "the replies of " ^ series t.replies_of
  ^ match t.others with [] -> "" | others -> ", then " ^ series others

let doc (t : t) =
  "The channels a stream names for " ^ file ^ "'s " ^ t.member ^ ": "
  ^ described t ^ "."

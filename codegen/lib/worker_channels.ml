(* The constants of client/surface.json that are the channels a stream names
   (a constant's [names]): the reply channels of each operation it names,
   then each other channel it names, every one of bus/registry.json. Each
   SDK writes each as its bus registry spells those channels. *)

type t = {
  member : string;  (** The constant, as client/surface.json names it. *)
  replies_of : string list;  (** Each operation, by its request channel. *)
  channels : string list;
}

let all (spec : Spec.t) =
  List.concat_map
    (fun (m : Tables.Client_surface.modules_item) ->
      List.filter_map
        (function
          | Tables.Client_surface.Constant { member; names = Some names; _ } ->
              Some
                { member; replies_of = names.replies_of; channels = names.channels }
          | Reader _ | Function _ | Type _ | Constant { names = None; _ } -> None)
        m.members)
    spec.tables.client_surface.modules

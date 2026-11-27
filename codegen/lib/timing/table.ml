(* The timing a client keeps, as each SDK writes it: every entry of the table,
   of the kind its name says. A name ending in Ms is a duration, in Retry a
   retry budget, in Count a count. *)

let file = "client/timing.json"

type value =
  | Duration of int  (** Milliseconds. *)
  | Budget of { attempts : int; initial_delay_ms : int; max_delay_ms : int }
  | Count of int

(** A record of what a caller may set, as a row's [override] names it. A row
    overridden elsewhere, at a member of a client type or a maker's parameter,
    is in neither. *)
type record = Client | Transport

type entry = {
  name : string;
  docs : string;
  value : value;
  record : record option;
}

type t = entry list

let records = [ Client; Transport ]

let record_name = function
  | Client -> "ClientTiming"
  | Transport -> "TransportTiming"

let record_docs record =
  Printf.sprintf
    "What a caller may set of the timing a %s keeps: each member is the entry \
     of protocol/specs/src/%s that its name says, and has the table's value \
     unless the caller states another."
    (match record with Client -> "client" | Transport -> "transport")
    file

let members record (t : t) = List.filter (fun e -> e.record = Some record) t

type kind = Of_duration | Of_budget | Of_count

(* The kind a name says: camel case, ending in Ms, Retry or Count. A name
   begins in lower case, so none is its suffix alone. *)
let kind name =
  let ends suffix = String.ends_with ~suffix name in
  let camel =
    name <> ""
    && (match name.[0] with 'a' .. 'z' -> true | _ -> false)
    && String.for_all
         (function 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false)
         name
  in
  if not camel then None
  else if ends "Ms" then Some Of_duration
  else if ends "Retry" then Some Of_budget
  else if ends "Count" then Some Of_count
  else None

let derive (table : Tables.Client_timing.t) =
  let refusals = ref [] in
  let refuse pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let stated = Hashtbl.create 64 in
  let entries =
    List.mapi
      (fun i (item : Tables.Client_timing.timing_item) ->
        let at = Printf.sprintf "/timing/%d" i in
        (match Hashtbl.find_opt stated item.name with
        | Some j ->
            refuse (at ^ "/name")
              (Printf.sprintf "is %s, which /timing/%d states already" item.name
                 j)
        | None -> Hashtbl.replace stated item.name i);
        let whole ~at ~what n =
          if n <= 0 then refuse at (Printf.sprintf "is %d: %s" n what)
        in
        let value : value option =
          match (kind item.name, item.value) with
          | None, _ ->
              refuse (at ^ "/name")
                (Printf.sprintf
                   "is %s, which says neither a duration, a budget nor a \
                    count: a name is camel case, ending in Ms, Retry or Count"
                   item.name);
              None
          | Some Of_duration, Integer ms ->
              whole ~at:(at ^ "/value")
                ~what:"a duration is a whole number of milliseconds above zero"
                ms;
              Some (Duration ms)
          | Some Of_count, Integer n ->
              whole ~at:(at ^ "/value")
                ~what:"a count is a whole number above zero" n;
              Some (Count n)
          | Some Of_budget, Object b ->
              if b.attempts < 1 then
                refuse (at ^ "/value/attempts")
                  (Printf.sprintf "is %d: a budget allows one attempt at least"
                     b.attempts);
              let delay =
                "a delay is a whole number of milliseconds above zero"
              in
              whole
                ~at:(at ^ "/value/initialDelayMs")
                ~what:delay b.initial_delay_ms;
              whole ~at:(at ^ "/value/maxDelayMs") ~what:delay b.max_delay_ms;
              if b.initial_delay_ms > b.max_delay_ms then
                refuse (at ^ "/value")
                  (Printf.sprintf
                     "starts its backoff at %d ms, above its ceiling of %d"
                     b.initial_delay_ms b.max_delay_ms);
              Some
                (Budget
                   {
                     attempts = b.attempts;
                     initial_delay_ms = b.initial_delay_ms;
                     max_delay_ms = b.max_delay_ms;
                   })
          | Some Of_duration, Object _ ->
              refuse (at ^ "/value")
                "is an object: a duration is a whole number of milliseconds \
                 above zero";
              None
          | Some Of_count, Object _ ->
              refuse (at ^ "/value")
                "is an object: a count is a whole number above zero";
              None
          | Some Of_budget, Integer n ->
              refuse (at ^ "/value")
                (Printf.sprintf
                   "is %d: a budget is attempts, initialDelayMs and maxDelayMs"
                   n);
              None
        in
        let record =
          match item.override with
          | Some "client" -> Some Client
          | Some "transport" -> Some Transport
          | Some _ | None -> None
        in
        Option.map
          (fun value -> { name = item.name; docs = item.docs; value; record })
          value)
      table.timing
  in
  match List.rev !refusals with
  | [] -> Ok (List.filter_map Fun.id entries)
  | refusals -> Error refusals

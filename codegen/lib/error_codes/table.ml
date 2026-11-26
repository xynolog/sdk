(* The failure vocabularies as the Go, Python and TypeScript SDKs write them:
   each vocabulary's codes, the bus code each of the wire's own codes
   (CommandError.code) becomes, and the transport code each HTTP status
   becomes. *)

open Tables.Errors_codes

let file = "errors/codes.json"

(* The bus vocabulary's member of the table. *)
let bus_member = "busRequest"

(* What every transport code states alike, whatever status it is read from. *)
let transport_code_and_docs : transport_codes_item -> string * string = function
  | Status { code; docs; _ }
  | Status_from { code; docs; _ }
  | No_status { code; docs } ->
      (code, docs)

type code = {
  code : string;
  docs : string;
  go : string;  (** The Go constant's name: its type's, then the code's. *)
}

type vocabulary = {
  member : string;  (** The vocabulary's member of the table. *)
  name : string;  (** The type's name in Python and TypeScript. *)
  go_name : string;  (** The type's name in Go. *)
  docs : string;
  codes : code list;
}

type t = {
  bus : vocabulary;
  wire : (string * code) list;
      (** Each wire code and the bus code it becomes, in the bus vocabulary's
          order. *)
  unrecognized : code;  (** What a failure that states no code becomes. *)
  transport : vocabulary;
  exact : (int * code) list;
      (** Each status and the transport code it becomes, in the table's order.
      *)
  from : (int * code) option;
      (** The status every one at or above which becomes the code. *)
  unclassified : code;  (** What any other status becomes. *)
  limit_refusals : (int * string * code) list;
      (** Each gateway refusal of a limit, by its status and LimitRefusal code,
          that is the transport code too (a transport code's [limitRefusals]).
      *)
  others : vocabulary list;
      (** The vocabularies that state nothing but their codes. *)
  control : vocabulary;  (** The control plane's codes. *)
}

(* Each vocabulary by its member of the table: its type's name in Python and
   TypeScript, and in Go, Rust, Kotlin and Swift. *)
(* A code's part after its last dot, which names its Go constant: lower-case
   words of letters and digits joined by hyphens. *)
let segment code =
  match String.rindex_opt code '.' with
  | Some i -> String.sub code (i + 1) (String.length code - i - 1)
  | None -> code

let is_segment segment =
  List.for_all
    (fun word ->
      word <> ""
      && String.for_all
           (function 'a' .. 'z' | '0' .. '9' -> true | _ -> false)
           word)
    (String.split_on_char '-' segment)

let pascal segment =
  String.concat ""
    (List.map String.capitalize_ascii (String.split_on_char '-' segment))

(* The wire's own codes, CommandError.code's, in the order it names them:
   the table's [wire] members are its enumeration. *)
let wire_codes = List.map command_error_code_value command_error_code_all

let derive (table : Tables.Errors_codes.t) =
  let refusals = ref [] in
  let refuse pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  (* Each vocabulary's codes, each stated once and each a distinct Go
     constant. *)
  let vocabulary ~member ~docs codes =
    let name, go_name = Code_names.named member in
    let stated = Hashtbl.create 16 and constants = Hashtbl.create 16 in
    let codes =
      List.mapi
        (fun i (code, docs) ->
          let at = Printf.sprintf "/%s/codes/%d/code" member i in
          let go = go_name ^ pascal (segment code) in
          (match Hashtbl.find_opt stated code with
          | Some j ->
              refuse at
                (Printf.sprintf "is %s, which /%s/codes/%d states already" code
                   member j)
          | None -> (
              Hashtbl.replace stated code i;
              if not (is_segment (segment code)) then
                refuse at
                  (Printf.sprintf
                     "is %s, whose last part names no Go constant: it is \
                      lower-case words of letters and digits joined by hyphens"
                     code)
              else
                match Hashtbl.find_opt constants go with
                | Some j ->
                    refuse at
                      (Printf.sprintf
                         "is %s in Go, which /%s/codes/%d is already" go member
                         j)
                | None -> Hashtbl.replace constants go i));
          { code; docs; go })
        codes
    in
    { member; name; go_name; docs; codes }
  in
  let bus =
    vocabulary ~member:bus_member ~docs:table.bus_request.docs
      (List.map
         (fun (c : codes_item) -> (c.code, c.docs))
         table.bus_request.codes)
  in
  let restated =
    List.concat
      (List.mapi
         (fun i (stated : codes_item) ->
           match stated.wire with
           | None -> []
           | Some wire ->
               [ (i, command_error_code_value wire, List.nth bus.codes i) ])
         table.bus_request.codes)
  in
  List.iteri
    (fun n (i, wire, _) ->
      let at = Printf.sprintf "/%s/codes/%d/wire" bus_member i in
      List.iteri
        (fun m (_, earlier, (first : code)) ->
          if m < n && earlier = wire then
            refuse at
              (Printf.sprintf "is %s, which %s restates already" wire first.code))
        restated)
    restated;
  List.iter
    (fun declared ->
      if not (List.exists (fun (_, wire, _) -> wire = declared) restated) then
        refuse
          ("/" ^ bus_member ^ "/codes")
          (Printf.sprintf "restates no code as CommandError.code's %s" declared))
    wire_codes;
  let named ~at ~vocabulary:(v : vocabulary) name =
    match List.find_opt (fun (c : code) -> c.code = name) v.codes with
    | Some code -> Some code
    | None ->
        refuse at (Printf.sprintf "is %s, which is none of its codes" name);
        None
  in
  let unrecognized =
    named
      ~at:("/" ^ bus_member ^ "/unrecognizedFailure")
      ~vocabulary:bus table.bus_request.unrecognized_failure
  in
  (match
     List.find_opt
       (fun (c : codes_item) -> c.code = table.bus_request.unrecognized_failure)
       table.bus_request.codes
   with
  | Some { wire = Some wire; _ } ->
      refuse
        ("/" ^ bus_member ^ "/unrecognizedFailure")
        (Printf.sprintf
           "is %s, which restates the wire's %s: an unrecognized failure is no \
            recognized one"
           table.bus_request.unrecognized_failure
           (command_error_code_value wire))
  | Some { wire = None; _ } | None -> ());
  let transport =
    vocabulary ~member:"transport" ~docs:table.transport.docs
      (List.map transport_code_and_docs table.transport.codes)
  in
  let mapped =
    List.mapi
      (fun i (stated : transport_codes_item) ->
        (i, stated, List.nth transport.codes i))
      table.transport.codes
  in
  let exact =
    List.filter_map
      (fun (i, statuses, code) ->
        match statuses with
        | Status { status; _ } -> Some (i, status, code)
        | Status_from _ | No_status _ -> None)
      mapped
  and ranges =
    List.filter_map
      (fun (i, statuses, code) ->
        match statuses with
        | Status_from { status_from; _ } -> Some (i, status_from, code)
        | Status _ | No_status _ -> None)
      mapped
  in
  List.iteri
    (fun n (i, status, _) ->
      List.iteri
        (fun m (_, earlier, (first : code)) ->
          if m < n && earlier = status then
            refuse
              (Printf.sprintf "/transport/codes/%d/status" i)
              (Printf.sprintf "is %d, which %s is read from already" status
                 first.code))
        exact;
      List.iter
        (fun (_, from, (range : code)) ->
          if status >= from then
            refuse
              (Printf.sprintf "/transport/codes/%d/status" i)
              (Printf.sprintf "is %d, which is in %s's statuses, from %d" status
                 range.code from))
        ranges)
    exact;
  let from =
    match ranges with
    | [] -> None
    | (_, status, code) :: rest ->
        List.iter
          (fun (i, _, _) ->
            refuse
              (Printf.sprintf "/transport/codes/%d/statusFrom" i)
              "is a second range of statuses: a status falls in one")
          rest;
        Some (status, code)
  in
  let unclassified =
    named ~at:"/transport/unclassified" ~vocabulary:transport
      table.transport.unclassified
  in
  List.iter
    (fun (i, statuses, (code : code)) ->
      match statuses with
      | No_status _ when code.code <> table.transport.unclassified ->
          refuse
            (Printf.sprintf "/transport/codes/%d" i)
            (Printf.sprintf
               "is %s, which no status is read as, and which is not the \
                unclassified code"
               code.code)
      | (Status _ | Status_from _) when code.code = table.transport.unclassified
        ->
          refuse
            (Printf.sprintf "/transport/codes/%d" i)
            (Printf.sprintf
               "is %s, the unclassified code, which a status is read as already"
               code.code)
      | Status _ | Status_from _ | No_status _ -> ())
    mapped;
  let plain ~member (v : Tables.Errors_codes.job) =
    vocabulary ~member ~docs:v.docs
      (List.map
         (fun (c : Tables.Errors_codes.job_codes_item) -> (c.code, c.docs))
         v.codes)
  in
  let others =
    [
      plain ~member:"job" table.job;
      plain ~member:"session" table.session;
      plain ~member:"signIn" table.sign_in;
      plain ~member:"kbIdentity" table.kb_identity;
      plain ~member:"spanRefusal" table.span_refusal;
    ]
  in
  match (List.rev !refusals, unrecognized, unclassified) with
  | [], Some unrecognized, Some unclassified ->
      Ok
        {
          bus;
          wire = List.map (fun (_, wire, code) -> (wire, code)) restated;
          unrecognized;
          transport;
          exact = List.map (fun (_, status, code) -> (status, code)) exact;
          from;
          unclassified;
          limit_refusals =
            List.concat_map
              (fun (stated, (code : code)) ->
                match stated with
                | Status { limit_refusals = Some refusals; _ } ->
                    List.map
                      (fun (r : limit_refusals_item) ->
                        (r.status, limit_refusal_code_value r.code, code))
                      refusals
                | Status _ | Status_from _ | No_status _ -> [])
              (List.combine table.transport.codes transport.codes);
          others;
          control =
            vocabulary ~member:"control" ~docs:table.control.docs
              (List.map
                 (fun (c : Tables.Errors_codes.control_codes_item) ->
                   (c.code, c.docs))
                 table.control.codes);
        }
  | refusals, _, _ -> Error refusals

(* Every vocabulary, in the table's order. *)
let vocabularies t = (t.bus :: t.transport :: t.others) @ [ t.control ]

(* The codes of the vocabulary [member] names among [vocabularies], as the
   texts a schema's [enum] states ([x-xynolog-codes]). *)
let enum vocabularies member =
  Option.map
    (fun (v : vocabulary) ->
      List.map (fun (c : code) -> Schema.String_literal c.code) v.codes)
    (List.find_opt (fun (v : vocabulary) -> v.member = member) vocabularies)

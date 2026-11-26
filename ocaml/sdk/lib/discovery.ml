open Eio.Std

type discovery_state =
  | Absent of Enums.Discovery_absent_reason.t
  | Managed of Records.Discovered_kb.t list

type discovery_read = Read of discovery_state | Unchanged
type discovery_transport = unit -> discovery_read

type discovery_diff = {
  state : discovery_state;
  added : Records.Discovered_kb.t list;
  updated : Records.Discovered_kb.t list;
  removed : Records.Discovered_kb.t list;
  duplicated : (string * int) list;
}

let discovery_interval = Client_timing.discovery_interval_ms

let parse_discovery_document source =
  match Strict_json.parse source with
  | Error _ -> Absent Not_json
  | Ok _ -> (
      match Yojson.Safe.from_string source with
      | `Assoc fields -> (
          match List.assoc_opt "version" fields with
          | Some (`Int version)
            when not (List.mem version Registry_facts.discovery_versions) ->
              Absent Unsupported_version
          | _ -> (
              match Models.decode Models.discovery_document source with
              | Error _ -> Absent Invalid
              | Ok model ->
                  Managed (Records.Discovery_document.of_model model).kbs))
      | _ -> Absent Invalid)

let text_discovery read () =
  try
    Read
      (match read () with
      | None -> Absent Not_found
      | Some text -> parse_discovery_document text)
  with Sys_error _ | Unix.Unix_error _ | Eio.Io _ -> Read (Absent Unreadable)

let file_discovery ~state_directory =
  let path = state_directory ^ Discovery_url_path.discovery_url_path in
  text_discovery (fun () ->
      try
        let fd = Unix.openfile path [ Unix.O_RDONLY; Unix.O_CLOEXEC ] 0 in
        let stream = Unix.in_channel_of_descr fd in
        Some
          (Fun.protect
             ~finally:(fun () -> close_in_noerr stream)
             (fun () -> In_channel.input_all stream))
      with Unix.Unix_error (Unix.ENOENT, _, _) -> None)

let http_discovery fetch =
  let etag = ref None in
  fun () ->
    try
      match fetch ~etag:!etag with
      | 304, _, _ -> Unchanged
      | 200, next, source ->
          etag := next;
          Read (parse_discovery_document source)
      | 404, _, _ ->
          etag := None;
          Read (Absent Not_found)
      | _ ->
          etag := None;
          Read (Absent Unreadable)
    with Eio.Io _ ->
      etag := None;
      Read (Absent Unreadable)

let discovery_diff previous state =
  let entries = function Managed entries -> entries | Absent _ -> [] in
  let before = Option.fold ~none:[] ~some:entries previous
  and after = entries state in
  let address (kb : Records.Discovered_kb.t) =
    (String.lowercase_ascii kb.host, kb.port)
  in
  let at key entries = List.filter (fun kb -> address kb = key) entries in
  let added = List.filter (fun kb -> at (address kb) before = []) after in
  let removed = List.filter (fun kb -> at (address kb) after = []) before in
  let updated =
    List.filter
      (fun kb ->
        let key = address kb in
        let old = at key before in
        old <> [] && List.sort compare old <> List.sort compare (at key after))
      after
  in
  let duplicated =
    List.filter_map
      (fun kb ->
        let key = address kb in
        if List.length (at key after) > 1 then Some key else None)
      after
    |> List.sort_uniq compare
  in
  let changed =
    match (previous, state) with
    | Some (Managed _), Managed _ -> false
    | Some (Absent a), Absent b -> a <> b
    | _ -> true
  in
  if changed || added <> [] || removed <> [] || updated <> [] then
    Some { state; added; updated; removed; duplicated }
  else None

let subscribe_discovery ~sw ~clock ?(interval_ms = discovery_interval) transport
    ~on_change =
  if interval_ms <= 0 then invalid_arg "discovery interval must be positive";
  let stopped, stop = Promise.create () in
  let rec loop previous =
    let previous =
      match transport () with
      | Unchanged -> previous
      | Read state ->
          Option.iter on_change (discovery_diff previous state);
          Some state
    in
    let due =
      Mtime.add_span (Clock.monotonic_now clock) Mtime.Span.(interval_ms * ms)
      |> Option.value ~default:Mtime.max_stamp
    in
    Clock.sleep_until clock due;
    loop previous
  in
  Fiber.fork_daemon ~sw (fun () ->
      Fiber.first (fun () -> loop None) (fun () -> Promise.await stopped);
      `Stop_daemon);
  fun () -> if not (Promise.is_resolved stopped) then Promise.resolve stop ()

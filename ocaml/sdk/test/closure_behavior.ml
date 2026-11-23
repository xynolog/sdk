open Xynolog

let check = Alcotest.(check string)
let json = Yojson.Safe.to_string

(* Shared bus/log-cases.json. Exercise the emitted line, including nested redaction. *)
let log (row : Protocol_cases.Bus_log_cases.cases_item) =
  let channel = Option.value row.channel ~default:"test" in
  let prefix = "[bus EMIT] " ^ channel ^ " " in
  let line = Bus_log.line "EMIT" ~channel (`Assoc row.payload) in
  check row.why (prefix ^ json (`Assoc row.shown)) line

(* Shared kb-identity/cases.json. An SDK derives identity from a domain
   declared by the gateway, as distinct from reading the launcher's YAML. *)
let kb (row : Protocol_cases.Kb_identity_cases.cases_item) =
  match (row.domain, row.did, row.resource) with
  | Some domain, Some did, Some resource ->
      check "DID" did (Identity.knowledge_base_did domain);
      check "audience" resource (Identity.resource domain)
  | _ ->
      Alcotest.fail
        (row.why ^ ": a row with a domain states its DID and audience")

(* Shared principals/cases.json. *)
let principal kind (row : Protocol_cases.Principals_cases.people_item) =
  check row.why row.did
    (Identity.principal ~domain:row.domain ~kind row.subject)

(* Shared media-types/cases.json. *)
let clone (row : Protocol_cases.Media_types_cases.clone_format_item) =
  check row.why row.format
    (Media_types.clone_format (Option.value row.source ~default:""))

let filename (row : Protocol_cases.Media_types_cases.storage_file_name_item) =
  check row.why row.file_name
    (Media_types.storage_file_name ~name:row.name ~format:row.format)

let text_source (row : Protocol_cases.Media_types_cases.text_source_item) =
  let source =
    match Media_types.text_source row.format with
    | Decode -> "decode"
    | Pdf_text_layer -> "pdf-text-layer"
    | No_text -> "none"
  in
  check "source" row.text_source source;
  Alcotest.(check bool)
    "geometry" row.yields_geometry
    (Media_types.yields_geometry row.format);
  Alcotest.(check bool)
    "derived" row.derives_text
    (Media_types.derives_text row.format)

let bytes hex =
  String.split_on_char ' ' hex
  |> List.filter (fun byte -> byte <> "")
  |> List.map (fun byte ->
      String.make 1 (Char.chr (int_of_string ("0x" ^ byte))))
  |> String.concat ""

let decode ~content_type data =
  match Text_encoding.decode ~content_type data with
  | Ok value -> `String value
  | Error (Unsupported_charset name | Unsupported_media_type name) ->
      `Assoc [ ("refused", `String name) ]

(* Shared text/decode-cases.json. *)
let decode_case (row : Protocol_cases.Text_decode_cases.cases_item) =
  let why, content_type, data, expected =
    match row with
    | Text { why; content_type; bytes = data; text } ->
        (why, content_type, data, `String text)
    | Refused { why; content_type; bytes = data; refused } ->
        (why, content_type, data, `Assoc [ ("refused", `String refused) ])
  in
  check why (json expected) (json (decode ~content_type (bytes data)))

(* Shared text/encoding-cases.json. Exercise every spelling and every byte. *)
let encoding (row : Protocol_cases.Text_encoding_cases.cases_item) =
  let labels =
    match row with
    | Every_byte { labels; _ } | Bytes { labels; _ } | Refused { labels; _ } ->
        labels
  in
  List.iter
    (fun label ->
      let data, expected =
        match row with
        | Every_byte { every_byte; _ } ->
            (String.init 256 Char.chr, `String every_byte)
        | Refused _ -> ("sample", `Assoc [ ("refused", `String label) ])
        | Bytes { bytes = data; text; _ } -> (bytes data, `String text)
      in
      let content_type =
        "text/plain; charset=\" " ^ String.uppercase_ascii label ^ "\t\""
      in
      check label (json expected) (json (decode ~content_type data)))
    labels

let cases name rows run =
  List.map
    (fun row -> Alcotest.test_case (name row) `Quick (fun () -> run row))
    rows

module Media = Protocol_cases.Media_types_cases
module Principals = Protocol_cases.Principals_cases

let () =
  let kb_rows =
    List.filter
      (fun (row : Protocol_cases.Kb_identity_cases.cases_item) ->
        Option.is_some row.domain)
      Protocol_cases.Kb_identity_cases.table.cases
  in
  let decode_name : Protocol_cases.Text_decode_cases.cases_item -> string =
    function
    | Text { why; _ } | Refused { why; _ } -> why
  in
  let encoding_name : Protocol_cases.Text_encoding_cases.cases_item -> string =
    function
    | Every_byte { encoding; _ }
    | Bytes { encoding; _ }
    | Refused { encoding; _ } ->
        encoding
  in
  Alcotest.run "OCaml remaining shared tables"
    [
      ( "bus logs",
        cases
          (fun (row : Protocol_cases.Bus_log_cases.cases_item) -> row.why)
          Protocol_cases.Bus_log_cases.table.cases log );
      ( "knowledge base identity",
        cases
          (fun (row : Protocol_cases.Kb_identity_cases.cases_item) -> row.why)
          kb_rows kb );
      ( "clone formats",
        cases
          (fun (row : Media.clone_format_item) -> row.why)
          Media.table.clone_format clone );
      ( "storage filenames",
        cases
          (fun (row : Media.storage_file_name_item) -> row.why)
          Media.table.storage_file_name filename );
      ( "text sources",
        cases
          (fun (row : Media.text_source_item) -> row.why)
          Media.table.text_source text_source );
      ( "people",
        cases
          (fun (row : Principals.people_item) -> row.why)
          Principals.table.people
          (principal Identity.Person) );
      ( "agents",
        cases
          (fun (row : Principals.people_item) -> row.why)
          Principals.table.agents (principal Identity.Agent) );
      ( "decode",
        cases decode_name Protocol_cases.Text_decode_cases.table.cases
          decode_case );
      ( "encodings",
        cases encoding_name Protocol_cases.Text_encoding_cases.table.cases
          encoding );
    ]

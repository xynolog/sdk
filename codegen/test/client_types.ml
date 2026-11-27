(* The client types' and the testing kit's writers: what each writes of a
   shape it can state, and each shape it refuses. *)

open Xynolog_codegen
module M = Client_types.Model
module W = Client_types.Haskell
module T = Tables.Client_testing

let case name test = Alcotest.test_case name `Quick test
let member ?(required = true) name held = { M.name; held; required }

let refused = function
  | Ok _ -> Alcotest.fail "wrote what it should refuse"
  | Error (_ :: _) -> ()
  | Error [] -> Alcotest.fail "refused, naming nothing"

let shapes list name = Option.map Result.ok (List.assoc_opt name list)

let refused_frame members =
  shapes
    [
      ("FrameRefusalReason", M.Words [ "lacks"; "malformed" ]);
      ( "JobEvent",
        Union
          {
            tag = "kind";
            branches = [ ("refused", [ member "data" (Inline members) ]) ];
          } );
      ( "UploadProgress",
        Union
          {
            tag = "phase";
            branches = [ ("started", [ member "totalBytes" (Scalar Integer) ]) ];
          } );
    ]

let text (file : Output.file) = file.text

let contains needle haystack =
  let n = String.length needle and h = String.length haystack in
  let rec at i =
    i + n <= h && (String.sub haystack i n = needle || at (i + 1))
  in
  at 0

let fault name kind holds : T.fault_actions_item =
  { name; kind; docs = "d"; holds }

let table ~records =
  {
    T.comment = "c";
    fault_actions =
      [ fault "Deliver" "deliver" []; fault "Delay" "delay" [ "ms" ] ];
    delay_ms = { docs = "d"; minimum = 0; maximum = 5 };
    schedule_length = { docs = "d"; minimum = 1; maximum = 8 };
    slack = { docs = "d"; times = 4 };
    delivery_ops = { docs = "d"; ops = [ "write"; "transition" ] };
    records;
  }

let kit_records =
  [
    {
      T.name = "RequestLogEntry";
      docs = "d";
      members = [ "channel"; "action"; "correlationId"; "retryKey"; "payload" ];
    };
    {
      name = "LivenessScenario";
      docs = "d";
      members = [ "outputs"; "settlements" ];
    };
    {
      name = "LivenessSpec";
      docs = "d";
      members =
        [
          "setup";
          "timeoutMs";
          "retryBudget";
          "cases";
          "schedules";
          "makeResponse";
        ];
    };
  ]

(* The client types the Haskell SDK adapts, ReconciledSpan [reconciled]
   and AnchorMethod the words [methods]. *)
let adapted_names =
  [
    "QuotedText";
    "TextSpan";
    "ReconciledSpan";
    "AnchorMethod";
    "MatchQuality";
    "PdfCoordinate";
    "IssuedTokens";
    "DeviceCode";
    "BeginAuthorizationOptions";
  ]

(* Each client type read whole: an object whose one member is a whole number
   of at least zero. *)
let read_whole _ =
  Ok
    (Schema.Schema
       {
         Schema.empty with
         type_ = Some [ Object ];
         properties =
           Some
             [
               ( "start",
                 Schema.Schema
                   {
                     Schema.empty with
                     type_ = Some [ Integer ];
                     minimum = Some 0.;
                   } );
             ];
       })

let adapted reconciled ~methods =
  shapes
    [
      ("QuotedText", M.Fields [ member "exact" (Scalar String) ]);
      ("TextSpan", M.Fields [ member "start" (Scalar Integer) ]);
      ("ReconciledSpan", reconciled);
      ("AnchorMethod", M.Words methods);
      ("MatchQuality", M.Words [ "fuzzy" ]);
      ("PdfCoordinate", M.Fields [ member "page" (Scalar Integer) ]);
      ("IssuedTokens", M.Fields [ member "access" (Scalar String) ]);
      ("DeviceCode", M.Fields [ member "expiresIn" (Scalar Integer) ]);
      ( "BeginAuthorizationOptions",
        M.Fields
          [ member "target" (Named { name = "HttpEndpoint"; union = false }) ]
      );
    ]

(* ReconciledSpan as Protocol states it: a union on how it was anchored,
   whose fuzzy branch alone says how well it matched, holding [quality]. *)
let reconciled_union quality : M.shape =
  Union
    {
      tag = "anchorMethod";
      branches =
        [
          ("unique-match", [ member "start" (Scalar Integer) ]);
          ( "fuzzy-match",
            [ member "start" (Scalar Integer); member "matchQuality" quality ]
          );
        ];
    }

let cases =
  [
    case "a refused frame's report is stated by Protocol's FrameRefusal"
      (fun () ->
        match
          W.operation_reports
            ~shape:
              (refused_frame
                 [
                   member "channel" (Scalar String);
                   member "member" (Scalar String);
                   member "reason"
                     (Named { name = "FrameRefusalReason"; union = false });
                 ])
        with
        | Ok file ->
            Alcotest.(check bool)
              "the reason is the generated FrameRefusal's" true
              (contains "\"reason\" .= frameRefusalReason value0" (text file))
        | Error errors ->
            Alcotest.failf "refused: %s"
              (String.concat "; " (List.map Decode.error_to_string errors)));
    case "a record's optional member is refused" (fun () ->
        refused
          (W.pending_annotation
             ~shape:
               (shapes
                  [
                    ( "PendingAnnotation",
                      M.Fields
                        [ member ~required:false "selector" (Scalar String) ] );
                  ])));
    case "an adapter states a list as its schema read whole" (fun () ->
        let list =
          Schema.Schema
            {
              Schema.empty with
              type_ = Some [ Array ];
              items =
                Some
                  (Schema.Schema { Schema.empty with type_ = Some [ String ] });
            }
        in
        match
          W.adapters ~names:[ "Things" ]
            ~whole:(fun _ -> Ok list)
            ~shape:(shapes [ ("Things", M.Items (Scalar String)) ])
        with
        | Ok
            [
              ( "Things",
                Schema.Schema { title = Some "Things"; items = Some _; _ } );
            ] ->
            ()
        | Ok _ -> Alcotest.fail "Things is not its list, titled"
        | Error _ -> Alcotest.fail "refused");
    case "an adapter states an object as its schema read whole" (fun () ->
        match
          W.adapters ~names:adapted_names ~whole:read_whole
            ~shape:
              (adapted
                 (M.Fields [ member "start" (Scalar Integer) ])
                 ~methods:[ "unique-match" ])
        with
        | Ok adapters -> (
            match List.assoc_opt "TextSpan" adapters with
            | Some
                (Schema.Schema
                   { title = Some "TextSpan"; properties = Some properties; _ })
              -> (
                match List.assoc_opt "start" properties with
                | Some
                    (Schema.Schema
                       { type_ = Some [ Integer ]; minimum = Some 0.; _ }) ->
                    ()
                | _ -> Alcotest.fail "start is not the integer read whole")
            | _ -> Alcotest.fail "no TextSpan titled and of properties")
        | Error _ -> Alcotest.fail "refused");
    case
      "an adapter states a union as its branches, each a type closed on its tag"
      (fun () ->
        match
          W.adapters ~names:adapted_names ~whole:read_whole
            ~shape:
              (adapted
                 (reconciled_union
                    (Named { name = "MatchQuality"; union = false }))
                 ~methods:[ "fuzzy-match"; "unique-match" ])
        with
        | Ok adapters ->
            let branches =
              [
                ("ReconciledSpanUniqueMatch", "unique-match", [ "start" ]);
                ( "ReconciledSpanFuzzyMatch",
                  "fuzzy-match",
                  [ "start"; "matchQuality" ] );
              ]
            in
            (match List.assoc_opt "ReconciledSpan" adapters with
            | Some (Schema.Schema { one_of = Some refs; _ }) ->
                Alcotest.(check (list string))
                  "its branches"
                  (List.map (fun (b, _, _) -> b ^ ".json") branches)
                  (List.map
                     (function
                       | Schema.Schema { ref_ = Some r; _ } -> r.target
                       | _ -> "a branch names no type")
                     refs)
            | _ -> Alcotest.fail "no ReconciledSpan of branches");
            List.iter
              (fun (branch, word, members) ->
                match List.assoc_opt branch adapters with
                | Some
                    (Schema.Schema
                       {
                         properties = Some p;
                         required = Some r;
                         additional_properties =
                           Some (Schema.Boolean_schema false);
                         _;
                       }) -> (
                    Alcotest.(check (list string))
                      (branch ^ "'s members")
                      ("anchorMethod" :: members)
                      (List.map fst p);
                    Alcotest.(check (list string))
                      (branch ^ " requires them")
                      (List.map fst p) r;
                    match List.assoc_opt "anchorMethod" p with
                    | Some
                        (Schema.Schema
                           { enum = Some [ Schema.String_literal w ]; _ }) ->
                        Alcotest.(check string) (branch ^ "'s tag") word w
                    | _ -> Alcotest.fail "the tag is no one word")
                | _ -> Alcotest.fail (branch ^ " is no closed object"))
              branches
        | Error _ -> Alcotest.fail "refused");
    case "a secret proof whose grant is not the client assertion's is refused"
      (fun () ->
        refused
          (W.service_proof ~grant_type:"client_credentials"
             [ member "grant_type" (Word [ "password" ]) ]));
    case "the kit's records are typed member for member" (fun () ->
        match Testing.Haskell.file (table ~records:kit_records) with
        | Ok file ->
            Alcotest.(check bool)
              "the spec holds its clock" true
              (contains "    livenessClock :: RetryOptions" file.Output.text)
        | Error _ -> Alcotest.fail "refused");
    case "a record member Haskell gives no type is refused" (fun () ->
        refused
          (Testing.Haskell.file
             (table
                ~records:
                  (List.map
                     (fun (r : T.records_item) ->
                       if r.name = "LivenessScenario" then
                         { r with members = r.members @ [ "deadline" ] }
                       else r)
                     kit_records))));
    case "a member Haskell types that the table no longer has is refused"
      (fun () ->
        refused
          (Testing.Haskell.file
             (table
                ~records:
                  (List.map
                     (fun (r : T.records_item) ->
                       if r.name = "RequestLogEntry" then
                         {
                           r with
                           members = List.filter (( <> ) "retryKey") r.members;
                         }
                       else r)
                     kit_records))));
    case "a record member TypeScript gives no type is refused" (fun () ->
        refused
          (Testing.Typescript.file
             (table
                ~records:
                  (List.map
                     (fun (r : T.records_item) ->
                       if r.name = "LivenessScenario" then
                         { r with members = r.members @ [ "deadline" ] }
                       else r)
                     kit_records))));
    case "a fault holding other than one delay is refused" (fun () ->
        refused
          (Testing.Table.derive
             {
               (table ~records:kit_records) with
               fault_actions = [ fault "Burst" "burst" [ "count" ] ];
             }));
    case "a delay whose maximum is below its minimum is refused" (fun () ->
        let t = table ~records:kit_records in
        refused
          (Testing.Table.derive
             { t with delay_ms = { t.delay_ms with minimum = 5; maximum = 4 } }));
  ]

let () = Alcotest.run "client_types" [ ("the writers", cases) ]

open Xynolog
module J = Yojson.Safe.Util

let field = J.member
let text value = `String value
let nullable f value = Option.fold ~none:`Null ~some:f value

let rec normalized = function
  | `Assoc fields ->
      `Assoc
        (List.sort compare
           (List.map (fun (name, value) -> (name, normalized value)) fields))
  | `List values -> `List (List.map normalized values)
  | `Float value when Float.is_integer value && abs_float value < 1e15 ->
      `Int (int_of_float value)
  | value -> value

let check label expected actual =
  Alcotest.(check string)
    label
    (Yojson.Safe.to_string (normalized expected))
    (Yojson.Safe.to_string (normalized actual))

module Frames = Protocol_cases.Bus_frame_cases
module Readers = Protocol_cases.Annotations_reader_cases
module Resource_cases = Protocol_cases.Resources_reader_cases
module Builders = Protocol_cases.Annotations_builder_cases
module Ids = Protocol_cases.Annotations_id_cases
module Reconcile = Protocol_cases.Annotations_reconcile_cases
module Locate = Protocol_cases.Annotations_pdf_locate_cases
module Job_retry = Protocol_cases.Jobs_retry_cases

let request_routing ~request ~member source =
  let open Eio.Std in
  match request with
  | None -> ()
  | Some (verdict : Frames.request) ->
      Eio_main.run @@ fun env ->
      Switch.run @@ fun sw ->
      let read, write = Eio.Process.pipe ~sw (Eio.Stdenv.process_mgr env) in
      let clock =
        Clock.make
          ~monotonic:(Eio_mock.Clock.Mono.make ())
          ~wall:(Eio_mock.Clock.make ())
          ~jitter:(Random.State.make [| 1 |])
      in
      let seen, observe = Promise.create () in
      let operation = Bus_registry.Operations.browse_resource_requested in
      let global = Bus.reply_channels_for operation in
      let sub =
        Subscription.start ~sw ~clock ~client_id:"test" ~global ~scopes:[]
          ~connect:(fun ~sw:_ _ ->
            Ok (Eio.Buf_read.of_flow ~max_size:65536 read))
          ~on_event:(fun _ ->
            if not (Promise.is_resolved seen) then Promise.resolve observe ())
          ()
      in
      let request =
        Fiber.fork_promise ~sw (fun () ->
            Subscription.request sub ~normalize_refusals:true
              ~correlation_id:"c-1"
              Bus_registry.Operations.browse_resource_requested ~send:(fun () ->
                Eio.Flow.copy_string source write))
      in
      Fun.protect
        ~finally:(fun () ->
          Subscription.close sub;
          Subscription.await_closed sub)
        (fun () ->
          let arrived =
            Fiber.first
              (fun () ->
                Promise.await seen;
                true)
              (fun () ->
                Eio.Time.sleep (Eio.Stdenv.clock env) 1.;
                false)
          in
          Alcotest.(check bool) "frame arrived" true arrived;
          if verdict = Fails then
            match Promise.await_exn request with
            | Error (Subscription.Frame_refusal fault) ->
                Alcotest.(check string)
                  "request fault member" member fault.member
            | _ -> Alcotest.fail "request did not receive the frame fault"
          else
            Alcotest.(check bool)
              "request is still pending" false
              (Promise.is_resolved request))

(* The channels the table's delivered frames are read on by type. *)
let typed_channels =
  let open Bus_registry in
  List.map
    (fun (Channel channel) -> name channel)
    [
      Channel Channels.beckon_focus;
      Channel Channels.browse_resource_failed;
      Channel Channels.gather_failed;
    ]

(* Shared cases from bus/frame-cases.json. *)
let frame (row : Frames.cases_item) =
  let source, request, member =
    match row with
    | Delivered { frame; _ } ->
        (Yojson.Safe.to_string (Frames.bus_frame_json frame), None, "")
    | Frame_refused { frame; request; member; _ } ->
        (Yojson.Safe.to_string frame, request, member)
    | Line_refused { data; request; member; _ } -> (data, request, member)
  in
  let message = "event: bus-event\ndata: " ^ source ^ "\n\n" in
  request_routing ~request ~member message;
  let input = Eio.Flow.string_source message in
  let raw =
    Wire_stream.read (Eio.Buf_read.of_flow ~max_size:65536 input) |> Option.get
  in
  let refused ~member ~reason ~told ~correlation_id =
    match Wire_stream.normalized raw with
    | Error fault ->
        Alcotest.(check string) "member" member fault.member;
        Alcotest.(check string)
          "reason"
          (Frames.frame_refusal_reason_value reason)
          (Enums.Frame_refusal_reason.to_string fault.reason);
        Alcotest.(check string)
          "recipient" (Frames.told_value told)
          (if Option.is_some fault.route then "readers" else "failure-report");
        Alcotest.(check (option string))
          "correlation" correlation_id
          (Option.bind fault.route (fun route -> route.correlation_id))
    | Ok _ -> Alcotest.fail "the frame was not refused"
  in
  match row with
  | Frame_refused { member; reason; told; correlation_id; _ } ->
      refused ~member ~reason ~told ~correlation_id
  | Line_refused { member; reason; told; _ } ->
      refused ~member ~reason ~told ~correlation_id:None
  | Delivered { frame = expected; read; _ } -> (
      (* Envelope acceptance is distinct from the typed payload result. *)
      match Result.get_ok raw with
      | Wire_stream.Frame { route; payload; _ } -> (
          Alcotest.(check string) "channel" expected.channel route.channel;
          Alcotest.(check (option string))
            "correlation" expected.correlation_id route.correlation_id;
          Alcotest.(check (option string))
            "scope" expected.scope
            (Option.map Identifiers.Resource_id.to_string route.scope);
          match (List.mem route.channel typed_channels, payload) with
          | true, Ok payload ->
              (* A frame that states no read is read as its payload. *)
              check "read"
                (Option.value read ~default:expected.payload)
                (Yojson.Safe.from_string (Bus_registry.encode payload))
          | true, Error _ ->
              Alcotest.fail "the typed reader refused the payload"
          | false, _ when Option.is_some read ->
              Alcotest.fail "a read is stated on a channel not read by type"
          | false, _ -> ()))

(* Protocol's first delivered frame, its payload carrying a trace: the
   frame's trace is read from it, and its payload is read without it. *)
let traced () =
  let frame =
    match
      List.find_map
        (function Frames.Delivered { frame; _ } -> Some frame | _ -> None)
        Frames.table.cases
    with
    | Some frame -> frame
    | None -> Alcotest.fail "bus/frame-cases.json delivers no frame"
  in
  let carrier =
    `Assoc
      [ ("traceparent", `String "00-a-b-01"); ("tracestate", `String "k=v") ]
  in
  let payload =
    match frame.payload with
    | `Assoc members -> `Assoc ((Bus_registry.trace_field, carrier) :: members)
    | _ -> Alcotest.fail "a delivered frame's payload is no object"
  in
  let source =
    Yojson.Safe.to_string (Frames.bus_frame_json { frame with payload })
  in
  let input =
    Eio.Flow.string_source ("event: bus-event\ndata: " ^ source ^ "\n\n")
  in
  match
    Wire_stream.read (Eio.Buf_read.of_flow ~max_size:65536 input) |> Option.get
  with
  | Ok (Wire_stream.Frame { trace; _ }) ->
      Alcotest.(check (option (pair string (option string))))
        "trace"
        (Some ("00-a-b-01", Some "k=v"))
        (Option.map (fun (t : Wire_stream.trace) -> (t.parent, t.state)) trace)
  | _ -> Alcotest.fail "the traced frame was not delivered"

(* Shared cases from annotations/reader-cases.json. *)
let annotation (row : Readers.cases_item) =
  let module A = Annotations in
  let annotation =
    Models.decode Models.annotation (Yojson.Safe.to_string row.annotation)
    |> Result.get_ok |> A.of_model
  in
  let selection = A.target_selector annotation in
  let reads = row.reads in
  let strings = Alcotest.(list string)
  and optional = Alcotest.(option string) in
  let flag label expected actual =
    Alcotest.(check bool) label expected actual
  in
  Alcotest.(check optional)
    "bodySource" reads.body_source (A.body_source annotation);
  Alcotest.(check string)
    "targetSource" reads.target_source
    (A.target_source annotation);
  check "targetSelector"
    (nullable Fun.id reads.target_selector)
    (nullable Fun.id selection);
  flag "isBodyResolved" reads.is_body_resolved (A.is_body_resolved annotation);
  flag "isHighlight" reads.is_highlight (A.is_highlight annotation);
  flag "isReference" reads.is_reference (A.is_reference annotation);
  flag "isAssessment" reads.is_assessment (A.is_assessment annotation);
  flag "isComment" reads.is_comment (A.is_comment annotation);
  flag "isTag" reads.is_tag (A.is_tag annotation);
  Alcotest.(check optional)
    "commentText" reads.comment_text
    (A.comment_text annotation);
  flag "isStubReference" reads.is_stub_reference
    (A.is_stub_reference annotation);
  flag "isResolvedReference" reads.is_resolved_reference
    (A.is_resolved_reference annotation);
  Alcotest.(check string) "exactText" reads.exact_text (A.exact_text selection);
  Alcotest.(check string)
    "annotationExactText" reads.annotation_exact_text
    (A.annotation_exact_text annotation);
  check "textQuoteSelector"
    (nullable Fun.id reads.text_quote_selector)
    (nullable
       (fun s -> Selector.to_json (TextQuoteSelector s))
       (Option.bind selection A.text_quote_selector));
  Alcotest.(check strings)
    "entityTypes" reads.entity_types
    (A.entity_types annotation);
  Alcotest.(check optional)
    "tagCategory" reads.tag_category
    (A.tag_category annotation);
  Alcotest.(check optional)
    "tagSchemaId" reads.tag_schema_id
    (A.tag_schema_id annotation)

(* Shared cases from resources/reader-cases.json. *)
let resource (row : Resource_cases.cases_item) =
  let decode resource =
    Models.decode Models.resource_descriptor (Yojson.Safe.to_string resource)
  in
  match row with
  | Refused { resource; member; reason; _ } -> (
      match decode resource with
      | Error (Models.Invalid_payload fault) ->
          Alcotest.(check string) "member" member fault.member;
          Alcotest.(check string)
            "reason"
            (Resource_cases.reason_value reason)
            (Enums.Frame_refusal_reason.to_string fault.reason)
      | _ -> Alcotest.fail "the resource was not refused")
  | Read
      { resource; primary_representation; primary_media_type; entity_types; _ }
    -> (
      match decode resource with
      | Ok model ->
          check "primary representation"
            (nullable Fun.id primary_representation)
            (nullable
               (fun value ->
                 Yojson.Safe.from_string
                   (Yojson.Raw.to_string (Records.Representation.to_json value)))
               (Resources.primary_representation model));
          Alcotest.(check (option string))
            "primary media type" primary_media_type
            (Resources.primary_media_type model);
          Alcotest.(check (list string))
            "entity types" entity_types
            (Resources.entity_types model)
      | Error _ -> Alcotest.fail "the resource was refused")

let parse schema value =
  Models.decode schema (Yojson.Safe.to_string value) |> Result.get_ok

(* A quoted text the model leaves as the JSON of Protocol's own schema. *)
let quote value : Records.Quoted_text.t =
  {
    exact = J.to_string (field "exact" value);
    prefix = J.to_string_option (field "prefix" value);
    suffix = J.to_string_option (field "suffix" value);
  }

let motivation value =
  Enums.Motivation.of_string (Builders.motivation_value value) |> Option.get

(* Shared deterministic IDs from annotations/id-cases.json. *)
let identity (row : Ids.cases_item) =
  let actual =
    Annotation_id.derive ~resource_id:row.resource_id
      ~motivation:(Ids.motivation_value row.motivation)
      ~anchor:row.anchor row.body
  in
  Alcotest.(check string) "id" row.id actual

(* A span's offset, which a refused case may state as no integer. *)
let offset value = if Float.is_integer value then int_of_float value else -1

(* A span the model leaves as the JSON of Protocol's own schema. *)
let span_of_json value : Records.Text_span.t =
  let { Records.Quoted_text.exact; prefix; suffix } = quote value in
  {
    start = offset (J.to_number (field "start" value));
    end_ = offset (J.to_number (field "end" value));
    exact;
    prefix;
    suffix;
  }

let span_of_row ({ start; end_; exact; prefix; suffix } : Builders.span) :
    Records.Text_span.t =
  { start = offset start; end_ = offset end_; exact; prefix; suffix }

let created = "2026-01-01T00:00:00.000Z"

(* What a builder made, held to the annotation a case states, or to the
   refusal it states. *)
let built expected build =
  match build () with
  | Ok model -> (
      match expected with
      | `Annotation annotation ->
          let fields =
            Yojson.Safe.from_string (Models.encode model) |> J.to_assoc
          in
          check "created" (text created) (List.assoc "created" fields);
          check "annotation" annotation
            (`Assoc (List.remove_assoc "created" fields))
      | `Refused _ -> Alcotest.fail "the builder made a refused span")
  | Error _ -> Alcotest.fail "builder produced an invalid annotation"
  | exception Annotations.Span_refused { code } -> (
      match expected with
      | `Refused refused ->
          Alcotest.(check string)
            "refusal" refused
            (Error_codes.Span_refusal.code code)
      | `Annotation _ -> Alcotest.fail "the builder refused the span")

(* Shared span builders from annotations/builder-cases.json. *)
let span_builder (row : Builders.cases_item) =
  let module A = Annotations in
  let build ~resource_id ~motivation:m ~generator ~body content selection () =
    A.annotation_of_span ~created
      ~resource:(Identifiers.Resource_id.of_string resource_id |> Result.get_ok)
      ~motivation:(motivation m)
      ~generator:(Builders.generator_json generator)
      ?body content selection
  in
  match row with
  | Text_built
      { text; resource_id; generator; motivation; span; body; annotation; _ } ->
      built (`Annotation annotation)
        (build ~resource_id ~motivation ~generator ~body (A.Text text)
           (span_of_json span))
  | Text_refused
      { text; resource_id; generator; motivation; span; body; refused; _ } ->
      built (`Refused refused)
        (build ~resource_id ~motivation ~generator ~body (A.Text text)
           (span_of_row span))
  | Pdf_built
      {
        anchored;
        resource_id;
        generator;
        motivation;
        span;
        body;
        annotation;
        _;
      } ->
      built (`Annotation annotation)
        (build ~resource_id ~motivation ~generator ~body
           (A.Pdf (parse Models.anchored_text anchored))
           (span_of_json span))
  | Pdf_refused
      { anchored; resource_id; generator; motivation; span; body; refused; _ }
    ->
      built (`Refused refused)
        (build ~resource_id ~motivation ~generator ~body
           (A.Pdf (parse Models.anchored_text anchored))
           (span_of_row span))

(* Shared whole-resource builders from annotations/builder-cases.json. *)
let resource_builder (row : Builders.resources_item) =
  built (`Annotation row.annotation) (fun () ->
      Annotations.annotation_of_resource ~created
        ~resource:
          (Identifiers.Resource_id.of_string row.resource_id |> Result.get_ok)
        ~motivation:(motivation row.motivation)
        ?generator:(Option.map Builders.generator_json row.generator)
        ?body:row.body ())

(* Shared Unicode anchors from annotations/reconcile-cases.json. *)
let reconcile (row : Reconcile.cases_item) =
  let module A = Annotations in
  let actual = A.reconcile row.text (quote row.quoted) in
  let to_json (result : Records.Reconciled_span.t) =
    let field name value =
      Option.to_list (Option.map (fun value -> (name, text value)) value)
    in
    let span ~start ~end_ ~exact ~prefix ~suffix anchor_method quality =
      `Assoc
        ([
           ("start", `Int start);
           ("end", `Int end_);
           ("exact", text exact);
           ("anchorMethod", text (Enums.Anchor_method.to_string anchor_method));
         ]
        @ field "prefix" prefix @ field "suffix" suffix
        @ field "matchQuality"
            (Option.map Enums.Match_quality.to_string quality))
    in
    match result with
    | UniqueMatch { start; end_; exact; prefix; suffix } ->
        span ~start ~end_ ~exact ~prefix ~suffix
          Enums.Anchor_method.Unique_match None
    | ContextRecovered { start; end_; exact; prefix; suffix } ->
        span ~start ~end_ ~exact ~prefix ~suffix
          Enums.Anchor_method.Context_recovered None
    | FirstOfMany { start; end_; exact; prefix; suffix } ->
        span ~start ~end_ ~exact ~prefix ~suffix
          Enums.Anchor_method.First_of_many None
    | FuzzyMatch { start; end_; exact; prefix; suffix; match_quality } ->
        span ~start ~end_ ~exact ~prefix ~suffix Enums.Anchor_method.Fuzzy_match
          (Some match_quality)
  in
  check "reconciled span"
    (nullable Fun.id row.reconciled)
    (nullable to_json actual)

(* SDK geometry cases from annotations/pdf-locate-cases.json. *)
let pdf (row : Locate.cases_item) =
  let module A = Annotations in
  let read item =
    Records.Pdf_text_item.of_model
      (Result.get_ok
         (Models.decode Models.pdf_text_item (Yojson.Safe.to_string item)))
  in
  let entries =
    List.map
      (fun raw -> (read raw, raw))
      (J.to_list (field "items" row.anchored))
  in
  let overlaps, rectangles =
    A.locate_pdf (List.map fst entries) row.span.start row.span.end_
  in
  check "overlaps" (`List row.overlapping)
    (`List (List.map (fun item -> List.assq item entries) overlaps));
  let expected (r : Locate.pdf_coordinate) =
    (r.page, [ r.x; r.y; r.width; r.height ])
  and actual (r : Records.Pdf_coordinate.t) =
    (r.page, [ r.x; r.y; r.width; r.height ])
  in
  Alcotest.(check (list (pair int (list (float 0.)))))
    "rectangles"
    (List.map expected row.rects)
    (List.map actual rectangles);
  Alcotest.(check (list string))
    "fragments" row.fragments
    (List.map A.fragment rectangles)

(* Shared failure retry decisions from jobs/retry-cases.json. *)
let retry (row : Job_retry.cases_item) =
  let classification =
    Option.map
      (fun c ->
        Enums.Failure_class.of_string (Job_retry.failure_class_value c)
        |> Option.get)
      row.failure_class
  in
  Alcotest.(check bool)
    "retries" row.retries
    (Claims.will_retry_after ~retry_count:row.retry_count
       ~max_retries:row.max_retries classification)

(* Each row, a test case by its why. *)
let cases rows why test =
  List.map
    (fun row -> Alcotest.test_case (why row) `Quick (fun () -> test row))
    rows

let () =
  Alcotest.run "OCaml reader helpers"
    [
      ( "frames",
        cases Frames.table.cases
          (function
            | Frames.Delivered { why; _ }
            | Frame_refused { why; _ }
            | Line_refused { why; _ } ->
                why)
          frame
        @ [ Alcotest.test_case "a frame's trace" `Quick traced ] );
      ( "annotations",
        cases Readers.table.cases
          (fun (r : Readers.cases_item) -> r.why)
          annotation );
      ( "resources",
        cases Resource_cases.table.cases
          (function
            | Resource_cases.Read { why; _ } | Refused { why; _ } -> why)
          resource );
      ( "span builders",
        cases Builders.table.cases
          (function
            | Builders.Text_built { why; _ }
            | Text_refused { why; _ }
            | Pdf_built { why; _ }
            | Pdf_refused { why; _ } ->
                why)
          span_builder );
      ( "resource builders",
        cases Builders.table.resources
          (fun (r : Builders.resources_item) -> r.why)
          resource_builder );
      ( "annotation ids",
        cases Ids.table.cases (fun (r : Ids.cases_item) -> r.why) identity );
      ( "reconciliation",
        cases Reconcile.table.cases
          (fun (r : Reconcile.cases_item) -> r.why)
          reconcile );
      ( "PDF locations",
        cases Locate.table.cases (fun (r : Locate.cases_item) -> r.why) pdf );
      ( "job retry",
        cases Job_retry.table.cases
          (fun (r : Job_retry.cases_item) -> r.why)
          retry );
    ]

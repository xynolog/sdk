(* Generated from protocol/specs/src/bus/frame-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type bus_frame = {
  channel : string;
  correlation_id : string option;
  payload : Yojson.Safe.t;
  scope : string option;
}

let bus_frame_json (r : bus_frame) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("channel", (fun s -> `String s) r.channel);
         Option.map
           (fun v -> ("correlationId", (fun s -> `String s) v))
           r.correlation_id;
         Option.Some ("payload", Fun.id r.payload);
         Option.map (fun v -> ("scope", (fun s -> `String s) v)) r.scope;
       ])

type delivered = {
  why : string;
  frame : bus_frame;
  read : Yojson.Safe.t option;
}

let delivered_json (r : delivered) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("frame", bus_frame_json r.frame);
         Option.map (fun v -> ("read", Fun.id v)) r.read;
       ])

type frame_refusal_reason = Lacks | Malformed

let frame_refusal_reason_value = function
  | (Lacks : frame_refusal_reason) -> "lacks"
  | (Malformed : frame_refusal_reason) -> "malformed"

let frame_refusal_reason_json v = `String (frame_refusal_reason_value v)

type told = Readers | Failure_report

let told_value = function
  | (Readers : told) -> "readers"
  | (Failure_report : told) -> "failure-report"

let told_json v = `String (told_value v)

type request = Fails | Waits

let request_value = function
  | (Fails : request) -> "fails"
  | (Waits : request) -> "waits"

let request_json v = `String (request_value v)

type frame_refused = {
  why : string;
  frame : Yojson.Safe.t;
  refused : bool;
  member : string;
  reason : frame_refusal_reason;
  told : told;
  correlation_id : string option;
  request : request option;
}

let frame_refused_json (r : frame_refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("frame", Fun.id r.frame);
         Option.Some ("refused", (fun b -> `Bool b) r.refused);
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("reason", frame_refusal_reason_json r.reason);
         Option.Some ("told", told_json r.told);
         Option.map
           (fun v -> ("correlationId", (fun s -> `String s) v))
           r.correlation_id;
         Option.map (fun v -> ("request", request_json v)) r.request;
       ])

type line_refused = {
  why : string;
  data : string;
  refused : bool;
  member : string;
  reason : frame_refusal_reason;
  told : told;
  request : request option;
}

let line_refused_json (r : line_refused) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("data", (fun s -> `String s) r.data);
         Option.Some ("refused", (fun b -> `Bool b) r.refused);
         Option.Some ("member", (fun s -> `String s) r.member);
         Option.Some ("reason", frame_refusal_reason_json r.reason);
         Option.Some ("told", told_json r.told);
         Option.map (fun v -> ("request", request_json v)) r.request;
       ])

type cases_item =
  | Delivered of delivered
  | Frame_refused of frame_refused
  | Line_refused of line_refused

let cases_item_json = function
  | (Delivered v : cases_item) -> delivered_json v
  | (Frame_refused v : cases_item) -> frame_refused_json v
  | (Line_refused v : cases_item) -> line_refused_json v

type t = { comment : string; cases : cases_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "What a stream's reader takes for a frame, and who it tells of one it \
        refuses, as every SDK's reader must. A frame is the JSON object the \
        `data` line of a `bus-event` message carries, and it carries what \
        BusFrame (specs/src/components/schemas/BusFrame.json) names and \
        nothing more: its `channel` and its `payload`, and its `correlationId` \
        and its `scope` when it has them. THE RULE. A reader holds every frame \
        to BusFrame before it delivers it. A frame BusFrame allows is \
        delivered, with its channel, payload, correlationId and scope as it \
        states them. A frame BusFrame does not allow is refused, and the \
        stream goes on to what else it carries. It is refused for its first \
        fault, found as every SDK finds a value's first fault (the \
        consumer-owned generator): a member it lacks (`lacks`), or a member \
        that is not what BusFrame allows (`malformed`), a member BusFrame does \
        not name among them; a `data` line that is no JSON object is itself \
        `malformed`. BusFrame takes any object for a payload, so a frame whose \
        payload is not its channel's is delivered by the stream and refused by \
        its channel's typed reader, for the payload's first fault. A FAULT is \
        named by its way from the frame (`member`: the names of the members it \
        is within, and its own, joined by dots; empty for the frame itself), \
        so a fault of the frame and a fault of its payload are told apart: one \
        of the payload's is within `payload` (`payload.resourceId`), and the \
        payload itself is `payload`. WHO IS TOLD (`told`). A refused frame \
        that names its readers is told to them (`readers`): one whose \
        `channel` is a text of at least one character, and that carries no \
        `scope` or one that is a resource's id. Its channel's typed reader \
        gives a frame refusal in its place, as it gives one for a frame whose \
        payload is not its channel's: naming the channel, the member and the \
        reason, and, where the refusal is said in words, saying `a frame on ` \
        and the channel, ` is not that channel's: ` and then the fault in the \
        words every SDK says one in. Every other refused frame names no \
        reader, whatever its first fault: one that is no JSON object, that \
        carries no `channel` or one that is not a text of at least one \
        character, or that carries a `scope` that is not a resource's id. It \
        is told to the transport's failure report (`failure-report`): as \
        `error`, with no status, saying `the stream carried what is not a \
        frame: ` and then its first fault. Every case told to its readers is \
        on `beckon:focus`, which every runner reads by type, but a request's \
        (below). A FAILURE'S CODE. A failure's `code` that is none of the \
        codes CommandError names (its `recognized` codes in the table) is read \
        as absent, as specs/src/errors/codes.json reads it \
        (`busRequest.unrecognizedFailure`, the same as a failure that states \
        none): the stream delivers the frame as it states it, and its \
        channel's typed reader reads its payload with no code and every other \
        member kept, and refuses it for no fault of its code. A request whose \
        reply that failure is fails with the failure as read. These cases are \
        on `browse:resource-failed`, the failure channel of \
        `browse:resource-requested`, whose payload is a CommandError, and on \
        `gather:failed`, whose payload is a CommandError and more \
        (GatherFailed), which their runner reads by type as it reads \
        `beckon:focus`. THE CORRELATION ID. A refusal carries the frame's \
        `correlationId` whenever it can be read: when the frame carries one \
        BusFrame allows, a text of at least one character. It carries none \
        when the frame carries none, and none when the frame's is not what \
        BusFrame allows, whatever the frame's first fault. A REQUEST awaiting \
        the reply a refusal's correlation id names, on the refusal's channel, \
        is told of it at once, and fails with it, as it fails for a reply \
        whose payload is not its channel's: in words, `a frame on ` and the \
        channel, ` is not that channel's: ` and the fault, as a typed reader \
        says one. A frame whose correlationId cannot be read reaches no \
        request: the request awaiting its reply goes on awaiting it. A CASE is \
        a `frame` that is delivered, with what its channel's typed reader \
        reads of its payload (`read`) where that is not the payload as the \
        frame states it; or a `frame`, or for a line that is no JSON its \
        `data`, `refused`: true, its first fault's `member` and `reason`, who \
        is `told`, and the `correlationId` its refusal carries, when it \
        carries one. A case may state a `request`: what becomes of a request \
        awaiting the reply `c-1` on the frame's channel when the line is \
        carried, `fails`, told of the refusal at once, or `waits`, told \
        nothing. A runner whose requests choose their own correlation ids \
        makes its request and carries the frame with that request's id in \
        place of `c-1`. A request's case is on `browse:resource-result`, the \
        result channel of `browse:resource-requested`, which its runner reads \
        by type as it reads `beckon:focus`.";
     cases =
       [
         (Delivered
            ({
               why =
                 "a frame that carries its channel and its payload is delivered";
               frame =
                 ({
                    channel = "beckon:focus";
                    correlation_id = None;
                    payload =
                      `Assoc
                        [
                          ("resourceId", `String "res-1");
                          ("annotationId", `String "a-1");
                        ];
                    scope = None;
                  }
                   : bus_frame);
               read = None;
             }
              : delivered)
           : cases_item);
         (Delivered
            ({
               why =
                 "a frame that carries every member BusFrame names is \
                  delivered with each";
               frame =
                 ({
                    channel = "browse:resource-result";
                    correlation_id = Some "c-1";
                    payload = `Assoc [ ("response", `Assoc []) ];
                    scope = Some "res-1";
                  }
                   : bus_frame);
               read = None;
             }
              : delivered)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame that carries no channel is refused, naming the \
                  channel, and names no reader";
               frame =
                 `Assoc
                   [ ("payload", `Assoc [ ("resourceId", `String "res-1") ]) ];
               refused = true;
               member = "channel";
               reason = (Lacks : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose channel is not a text is refused, naming the \
                  channel, and names no reader";
               frame =
                 `Assoc
                   [
                     ("channel", `Int 7);
                     ("payload", `Assoc [ ("resourceId", `String "res-1") ]);
                   ];
               refused = true;
               member = "channel";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Line_refused
            ({
               why =
                 "a line that is no JSON is refused as malformed, and names no \
                  reader";
               data = "{\"channel\": \"beckon:focus\", \"payload\": {";
               refused = true;
               member = "";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               request = None;
             }
              : line_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame that carries a member BusFrame does not name is \
                  refused, naming the member, and told to its channel's \
                  readers";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("payload", `Assoc [ ("resourceId", `String "res-1") ]);
                     ("addedByALaterGateway", `Bool true);
                   ];
               refused = true;
               member = "addedByALaterGateway";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose scope is no resource's id is refused, naming \
                  the scope, and names no reader";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("payload", `Assoc [ ("resourceId", `String "res-1") ]);
                     ("scope", `String "not an id");
                   ];
               refused = true;
               member = "scope";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose scope is not a text is refused, naming the \
                  scope, and names no reader";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                     ("scope", `Int 7);
                   ];
               refused = true;
               member = "scope";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose scope is empty is refused, naming the scope, \
                  and names no reader";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                     ("scope", `String "");
                   ];
               refused = true;
               member = "scope";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose scope is null carries a scope, and null is no \
                  resource's id: it is refused, naming the scope, and names no \
                  reader";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                     ("scope", `Null);
                   ];
               refused = true;
               member = "scope";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose scope is no resource's id names no reader, \
                  though its first fault is another member";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("correlationId", `Int 7);
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                     ("scope", `String "not an id");
                   ];
               refused = true;
               member = "correlationId";
               reason = (Malformed : frame_refusal_reason);
               told = (Failure_report : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose correlationId is not a text is refused, naming \
                  the correlationId, and told to its channel's readers";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("correlationId", `Int 7);
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                   ];
               refused = true;
               member = "correlationId";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose correlationId is empty is refused, naming the \
                  correlationId, and told to its channel's readers";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("correlationId", `String "");
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `String "res-1");
                           ("annotationId", `String "a-1");
                         ] );
                   ];
               refused = true;
               member = "correlationId";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame that carries no payload is refused, naming the \
                  payload, and told to its channel's readers";
               frame = `Assoc [ ("channel", `String "beckon:focus") ];
               refused = true;
               member = "payload";
               reason = (Lacks : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose payload is no object is refused, naming the \
                  payload, and told to its channel's readers";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("payload", `String "res-1");
                   ];
               refused = true;
               member = "payload";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose payload lacks a member its channel's schema \
                  requires is refused by its channel's reader, naming the \
                  member within the payload";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("payload", `Assoc [ ("annotationId", `String "a-1") ]);
                   ];
               refused = true;
               member = "payload.resourceId";
               reason = (Lacks : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose payload has a member its channel's schema does \
                  not allow is refused by its channel's reader, naming the \
                  member within the payload";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ( "payload",
                       `Assoc
                         [
                           ("resourceId", `Int 7);
                           ("annotationId", `String "a-1");
                         ] );
                   ];
               refused = true;
               member = "payload.resourceId";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame with a fault of its own and one in its payload is \
                  refused for its own";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("payload", `Assoc [ ("annotationId", `String "a-1") ]);
                     ("addedByALaterGateway", `Bool true);
                   ];
               refused = true;
               member = "addedByALaterGateway";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame refused for its payload carries its correlationId, \
                  which can be read";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("correlationId", `String "c-1");
                     ("payload", `String "res-1");
                   ];
               refused = true;
               member = "payload";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = Some "c-1";
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a frame whose payload is not its channel's is refused by its \
                  channel's reader, carrying its correlationId";
               frame =
                 `Assoc
                   [
                     ("channel", `String "beckon:focus");
                     ("correlationId", `String "c-1");
                     ("payload", `Assoc [ ("annotationId", `String "a-1") ]);
                   ];
               refused = true;
               member = "payload.resourceId";
               reason = (Lacks : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = Some "c-1";
               request = None;
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a reply whose correlationId can be read, refused for a \
                  member BusFrame does not name, is told to the request \
                  awaiting it at once, which fails with it";
               frame =
                 `Assoc
                   [
                     ("channel", `String "browse:resource-result");
                     ("correlationId", `String "c-1");
                     ("payload", `Assoc [ ("response", `Assoc []) ]);
                     ("addedByALaterGateway", `Bool true);
                   ];
               refused = true;
               member = "addedByALaterGateway";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = Some "c-1";
               request = Some (Fails : request);
             }
              : frame_refused)
           : cases_item);
         (Frame_refused
            ({
               why =
                 "a reply whose correlationId is not a text is refused for it, \
                  carries none, and reaches no request: the request awaiting \
                  its reply goes on awaiting it";
               frame =
                 `Assoc
                   [
                     ("channel", `String "browse:resource-result");
                     ("correlationId", `Int 7);
                     ("payload", `Assoc [ ("response", `Assoc []) ]);
                   ];
               refused = true;
               member = "correlationId";
               reason = (Malformed : frame_refusal_reason);
               told = (Readers : told);
               correlation_id = None;
               request = Some (Waits : request);
             }
              : frame_refused)
           : cases_item);
         (Delivered
            ({
               why =
                 "a failure whose code is none CommandError names is \
                  delivered, and its channel's typed reader reads it with no \
                  code, its message and its details kept, as it reads a \
                  failure that states no code";
               frame =
                 ({
                    channel = "browse:resource-failed";
                    correlation_id = None;
                    payload =
                      `Assoc
                        [
                          ("message", `String "the resource is gone");
                          ("details", `String "res-1");
                          ("code", `String "not-invented-yet");
                        ];
                    scope = None;
                  }
                   : bus_frame);
               read =
                 Some
                   (`Assoc
                      [
                        ("message", `String "the resource is gone");
                        ("details", `String "res-1");
                      ]);
             }
              : delivered)
           : cases_item);
         (Delivered
            ({
               why =
                 "a failure whose code is one CommandError names is read with \
                  its code";
               frame =
                 ({
                    channel = "browse:resource-failed";
                    correlation_id = None;
                    payload =
                      `Assoc
                        [
                          ("message", `String "the resource is gone");
                          ("code", `String "not-found");
                        ];
                    scope = None;
                  }
                   : bus_frame);
               read = None;
             }
              : delivered)
           : cases_item);
         (Delivered
            ({
               why =
                 "a failure that is a CommandError and more is read so too: \
                  its code that is none CommandError names is left out, and \
                  what it is more is kept";
               frame =
                 ({
                    channel = "gather:failed";
                    correlation_id = None;
                    payload =
                      `Assoc
                        [
                          ("message", `String "no context");
                          ("annotationId", `String "a-1");
                          ("code", `String "not-invented-yet");
                        ];
                    scope = None;
                  }
                   : bus_frame);
               read =
                 Some
                   (`Assoc
                      [
                        ("message", `String "no context");
                        ("annotationId", `String "a-1");
                      ]);
             }
              : delivered)
           : cases_item);
       ];
   }
    : t)

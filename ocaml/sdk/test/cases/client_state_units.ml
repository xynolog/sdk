(* Generated from protocol/specs/src/client/state-units.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type fixtures = { context : Yojson.Safe.t; generation : Yojson.Safe.t }

let fixtures_json (r : fixtures) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("context", Fun.id r.context);
         Option.Some ("generation", Fun.id r.generation);
       ])

type answers = Refuses | Never | Jobs

let answers_value = function
  | (Refuses : answers) -> "refuses"
  | (Never : answers) -> "never"
  | (Jobs : answers) -> "jobs"

let answers_json v = `String (answers_value v)

type transport = {
  answers : answers;
  replies : (string * Yojson.Safe.t list) list option;
  delay_ms : int option;
}

let transport_json (r : transport) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("answers", answers_json r.answers);
         Option.map
           (fun v ->
             ( "replies",
               (fun l ->
                 `Assoc
                   (List.map
                      (fun (k, v) ->
                        (k, (fun l -> `List (List.map Fun.id l)) v))
                      l))
                 v ))
           r.replies;
         Option.map (fun v -> ("delayMs", (fun n -> `Int n) v)) r.delay_ms;
       ])

type object_ = { timing : string; times : float option; plus_ms : int option }

let object__json (r : object_) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("timing", (fun s -> `String s) r.timing);
         Option.map (fun v -> ("times", (fun f -> `Float f) v)) r.times;
         Option.map (fun v -> ("plusMs", (fun n -> `Int n) v)) r.plus_ms;
       ])

type pass = Integer of int | Object of object_

let pass_json = function
  | (Integer v : pass) -> (fun n -> `Int n) v
  | (Object v : pass) -> object__json v

type made_value = {
  resource_id : string option;
  locale : string option;
  delay_ms : pass option;
  debounce_ms : int option;
  initial_query : string option;
}

let made_value_json (r : made_value) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.map
           (fun v -> ("resourceId", (fun s -> `String s) v))
           r.resource_id;
         Option.map (fun v -> ("locale", (fun s -> `String s) v)) r.locale;
         Option.map (fun v -> ("delayMs", pass_json v)) r.delay_ms;
         Option.map (fun v -> ("debounceMs", (fun n -> `Int n) v)) r.debounce_ms;
         Option.map
           (fun v -> ("initialQuery", (fun s -> `String s) v))
           r.initial_query;
       ])

type say = {
  say : string;
  correlation_id : string option;
  payload : Yojson.Safe.t;
}

let say_json (r : say) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("say", (fun s -> `String s) r.say);
         Option.map
           (fun v -> ("correlationId", (fun s -> `String s) v))
           r.correlation_id;
         Option.Some ("payload", Fun.id r.payload);
       ])

type deliver = {
  deliver : string;
  correlation_id : string option;
  payload : Yojson.Safe.t;
}

let deliver_json (r : deliver) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("deliver", (fun s -> `String s) r.deliver);
         Option.map
           (fun v -> ("correlationId", (fun s -> `String s) v))
           r.correlation_id;
         Option.Some ("payload", Fun.id r.payload);
       ])

type answer = {
  answer : string;
  nth : int;
  reply : string;
  payload : Yojson.Safe.t;
}

let answer_json (r : answer) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("answer", (fun s -> `String s) r.answer);
         Option.Some ("nth", (fun n -> `Int n) r.nth);
         Option.Some ("reply", (fun s -> `String s) r.reply);
         Option.Some ("payload", Fun.id r.payload);
       ])

type queue_reply = { queue_reply : string; response : Yojson.Safe.t }

let queue_reply_json (r : queue_reply) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("queueReply", (fun s -> `String s) r.queue_reply);
         Option.Some ("response", Fun.id r.response);
       ])

type invoke = {
  invoke : string;
  of_ : string;
  args : (string * Yojson.Safe.t) list;
}

let invoke_json (r : invoke) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("invoke", (fun s -> `String s) r.invoke);
         Option.Some ("of", (fun s -> `String s) r.of_);
         Option.Some
           ( "args",
             (fun l -> `Assoc (List.map (fun (k, v) -> (k, Fun.id v)) l)) r.args
           );
       ])

type steps_item_pass = { pass : pass }

let steps_item_pass_json (r : steps_item_pass) =
  `Assoc (List.filter_map Fun.id [ Option.Some ("pass", pass_json r.pass) ])

type dispose = { dispose : string }

let dispose_json (r : dispose) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("dispose", (fun s -> `String s) r.dispose) ])

type answer_search = { answer_search : int; results : string list option }

let answer_search_json (r : answer_search) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("answerSearch", (fun n -> `Int n) r.answer_search);
         Option.Some
           ( "results",
             (function
               | Option.None -> `Null
               | Option.Some v ->
                   (fun l -> `List (List.map (fun s -> `String s) l)) v)
               r.results );
       ])

type expect = { expect : (string * (string * Yojson.Safe.t) list) list }

let expect_json (r : expect) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "expect",
             (fun l ->
               `Assoc
                 (List.map
                    (fun (k, v) ->
                      ( k,
                        (fun l ->
                          `Assoc (List.map (fun (k, v) -> (k, Fun.id v)) l))
                          v ))
                    l))
               r.expect );
       ])

type sent_payloads = { sent : string; payloads : Yojson.Safe.t list }

let sent_payloads_json (r : sent_payloads) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("sent", (fun s -> `String s) r.sent);
         Option.Some
           ("payloads", (fun l -> `List (List.map Fun.id l)) r.payloads);
       ])

type sent_count = { sent : string; count : int }

let sent_count_json (r : sent_count) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("sent", (fun s -> `String s) r.sent);
         Option.Some ("count", (fun n -> `Int n) r.count);
       ])

type nothing_sent = { nothing_sent : bool }

let nothing_sent_json (r : nothing_sent) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("nothingSent", (fun b -> `Bool b) r.nothing_sent) ])

type correlation_id_object = { sent : string; nth : int }

let correlation_id_object_json (r : correlation_id_object) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("sent", (fun s -> `String s) r.sent);
         Option.Some ("nth", (fun n -> `Int n) r.nth);
       ])

type correlation_id = String of string | Object of correlation_id_object

let correlation_id_json = function
  | (String v : correlation_id) -> (fun s -> `String s) v
  | (Object v : correlation_id) -> correlation_id_object_json v

type heard_item = {
  channel : string;
  correlation_id : correlation_id option;
  payload : Yojson.Safe.t;
}

let heard_item_json (r : heard_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("channel", (fun s -> `String s) r.channel);
         Option.map
           (fun v -> ("correlationId", correlation_id_json v))
           r.correlation_id;
         Option.Some ("payload", Fun.id r.payload);
       ])

type heard = { heard : heard_item list }

let heard_json (r : heard) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ("heard", (fun l -> `List (List.map heard_item_json l)) r.heard);
       ])

type ended = { ended : (string * string list) list }

let ended_json (r : ended) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "ended",
             (fun l ->
               `Assoc
                 (List.map
                    (fun (k, v) ->
                      (k, (fun l -> `List (List.map (fun s -> `String s) l)) v))
                    l))
               r.ended );
       ])

type bus_destroyed = { bus_destroyed : bool }

let bus_destroyed_json (r : bus_destroyed) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("busDestroyed", (fun b -> `Bool b) r.bus_destroyed) ])

type searched = { searched : string list }

let searched_json (r : searched) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "searched",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.searched );
       ])

type steps_item =
  | String
  | Say of say
  | Deliver of deliver
  | Answer of answer
  | Queue_reply of queue_reply
  | Invoke of invoke
  | Pass of steps_item_pass
  | Dispose of dispose
  | Answer_search of answer_search
  | Expect of expect
  | Sent_payloads of sent_payloads
  | Sent_count of sent_count
  | Nothing_sent of nothing_sent
  | Heard of heard
  | Ended of ended
  | Bus_destroyed of bus_destroyed
  | Searched of searched

let steps_item_json = function
  | (String : steps_item) -> `String "settle"
  | (Say v : steps_item) -> say_json v
  | (Deliver v : steps_item) -> deliver_json v
  | (Answer v : steps_item) -> answer_json v
  | (Queue_reply v : steps_item) -> queue_reply_json v
  | (Invoke v : steps_item) -> invoke_json v
  | (Pass v : steps_item) -> steps_item_pass_json v
  | (Dispose v : steps_item) -> dispose_json v
  | (Answer_search v : steps_item) -> answer_search_json v
  | (Expect v : steps_item) -> expect_json v
  | (Sent_payloads v : steps_item) -> sent_payloads_json v
  | (Sent_count v : steps_item) -> sent_count_json v
  | (Nothing_sent v : steps_item) -> nothing_sent_json v
  | (Heard v : steps_item) -> heard_json v
  | (Ended v : steps_item) -> ended_json v
  | (Bus_destroyed v : steps_item) -> bus_destroyed_json v
  | (Searched v : steps_item) -> searched_json v

type cases_item = {
  unit : string;
  case : string;
  transport : transport;
  made : (string * made_value) list;
  listen : string list option;
  steps : steps_item list;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("unit", (fun s -> `String s) r.unit);
         Option.Some ("case", (fun s -> `String s) r.case);
         Option.Some ("transport", transport_json r.transport);
         Option.Some
           ( "made",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, made_value_json v)) l))
               r.made );
         Option.map
           (fun v ->
             ("listen", (fun l -> `List (List.map (fun s -> `String s) l)) v))
           r.listen;
         Option.Some
           ("steps", (fun l -> `List (List.map steps_item_json l)) r.steps);
       ])

type t = {
  comment : string;
  notices : (string * Yojson.Safe.t) list;
  fixtures : fixtures;
  cases : cases_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "notices",
             (fun l -> `Assoc (List.map (fun (k, v) -> (k, Fun.id v)) l))
               r.notices );
         Option.Some ("fixtures", fixtures_json r.fixtures);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for what a client's state units do: each case builds units \
        over a scripted transport, drives them, and states what they hold and \
        what they said. Every SDK runs these cases against its own units, so a \
        unit means one thing in every SDK; specs/src/client/surface.json's \
        `stateUnits` names the units and their members, and this table holds \
        what they do. A case names its `unit` (a row of `stateUnits`) and what \
        it is (`case`); an SDK that lacks the unit, as its own repository \
        records, does not run its cases. `transport` is what answers the \
        client's requests: `answers` is `refuses` (every request is refused at \
        once), `never` (every request reaches the gateway and is answered only \
        by an `answer` step) or `jobs` (`job:create` is answered `{\"jobId\": \
        \"job-1\"}`, `job:status-requested` with job-1 running, and anything \
        else is refused at once); `replies` queues responses by operation, \
        each given before the rule; `delayMs` holds every reply that long. The \
        client's stream carries the replies and the broadcasts, never the \
        requests it sent. `made` names each unit the case builds, with what it \
        is built from: a gather, mark or beckon unit its `resourceId`, a yield \
        unit its `locale`, a hover dwell its `delayMs`, saying what is hovered \
        through the client's `beckon.hover`, and a search pipeline its \
        `debounceMs` and `initialQuery`, each the pipeline's own when the case \
        states none, searching with the case's search, which records each \
        query it is asked and gives its answers when a step says. The \
        session's signals are made from nothing. `listen` names channels of \
        the client's bus read from the moment the units are made. `steps` run \
        in order. Driving: `say` publishes on the client's own bus, as a \
        signal or a job event is; `deliver` gives the client a frame from the \
        wire, as another participant's is; `answer` replies to the `nth` \
        request sent on a channel, on `reply`, under that request's \
        correlation id; `queueReply` queues the next response to an operation; \
        `invoke` calls a method of the unit `of` names, with `args` by the \
        method's parameter names; `\"settle\"` lets what is ready run, and \
        what that makes ready, until nothing more is, and moves no time; \
        `pass` settles, then moves the clock, letting what falls due run to \
        its end as it does; `dispose` disposes the named unit; `answerSearch` \
        gives the `nth` query the case's search was asked an answer: its \
        `results`, or null for one still on its way (a query that was \
        abandoned has nobody to give it to). Checking: `expect` states, for \
        each named unit, what members hold now (it lets nothing run first); \
        `sent` lists every request sent on a channel so far, or gives their \
        `count`; `nothingSent` says no request was sent; `heard` lists exactly \
        what the `listen` channels carried since the units were made or since \
        the last `heard`, once what is ready has run; `ended` names members \
        whose readers have ended; `busDestroyed` says whether the client's bus \
        has ended; `searched` lists every query the case's search has been \
        asked so far. A duration is milliseconds, or `{\"timing\": <a name of \
        specs/src/client/timing.json>}` with `times` and `plusMs` to scale and \
        move it. Values are as the wire writes them, compared exactly: a state \
        holding a wire model is written as the wire writes it, ids are \
        strings, none is null, and a search pipeline's state is `{\"results\": \
        [\226\128\166], \"isSearching\": \226\128\166}`. Two forms compare \
        less: `{\"$has\": {\226\128\166}}` matches an object holding at least \
        those members, and a state holding an error is written `{\"code\": \
        \226\128\166}`, `{\"message\": \226\128\166}` or both, and compared on \
        those; a case states a message only where the wire wrote it, never one \
        an SDK or its test double writes. `{\"$fixture\": name}` is the \
        table's fixture of that name. A `heard` entry gives the frame's \
        `channel`, its `payload` and its `correlationId`, which is absent when \
        the frame carries none, or `{\"sent\": <channel>, \"nth\": <n>}` for \
        the id a request carried. What a case cannot state stays a test of the \
        SDK's own: the axioms, which each SDK's harness checks, and how often \
        a state wakes its readers, which differs by language. `notices` states \
        each notice the session's signals raise, as a case gives it and \
        expects it: SessionEnded, PermissionDenied and KbIdentityConflict, \
        each a record with no member it does not state. \
        specs/src/client/surface.json's `sessionNotices` module says where \
        each SDK declares them. The consumer-owned generator writes them for \
        every SDK it has a writer of them for; an SDK that states them by hand \
        is held to them only by value, through the cases it runs. Nothing \
        holds this table yet to client/surface.json, the bus registry or the \
        timing table: that a case's `unit` is a row of `stateUnits`, that each \
        channel it names is the bus registry's, that each `timing` is a name \
        of the timing table, and that every notice a case gives or expects is \
        one of `notices`, no check reads.";
     notices =
       [
         ( "SessionEnded",
           `Assoc
             [
               ("title", `String "SessionEnded");
               ("type", `String "object");
               ("description", `String "A session ended, and why.");
               ("additionalProperties", `Bool false);
               ( "properties",
                 `Assoc
                   [
                     ( "reason",
                       `Assoc
                         [
                           ( "$ref",
                             `String
                               "https://xynolog.org/protocol/SessionEndReason.json"
                           );
                           ("description", `String "Why it ended.");
                         ] );
                   ] );
               ("required", `List [ `String "reason" ]);
             ] );
         ( "PermissionDenied",
           `Assoc
             [
               ("title", `String "PermissionDenied");
               ("type", `String "object");
               ( "description",
                 `String "A request was refused for lack of permission." );
               ("additionalProperties", `Bool false);
               ( "properties",
                 `Assoc
                   [
                     ( "detail",
                       `Assoc
                         [
                           ("type", `List [ `String "string"; `String "null" ]);
                           ( "description",
                             `String
                               "The refusal's own message, untranslated; null \
                                when it gave none." );
                         ] );
                   ] );
               ("required", `List [ `String "detail" ]);
             ] );
         ( "KbIdentityConflict",
           `Assoc
             [
               ("title", `String "KbIdentityConflict");
               ("type", `String "object");
               ( "description",
                 `String
                   "A different knowledge base answers at a registered \
                    address. Both dids, because neither alone says what to do: \
                    a person has to recognise which knowledge base they \
                    registered and which one answers." );
               ("additionalProperties", `Bool false);
               ( "properties",
                 `Assoc
                   [
                     ( "expectedDid",
                       `Assoc
                         [
                           ("type", `String "string");
                           ("description", `String "The did the entry records.");
                         ] );
                     ( "observedDid",
                       `Assoc
                         [
                           ("type", `String "string");
                           ( "description",
                             `String
                               "The did the knowledge base that answered \
                                reported." );
                         ] );
                   ] );
               ( "required",
                 `List [ `String "expectedDid"; `String "observedDid" ] );
             ] );
       ];
     fixtures =
       ({
          context =
            `Assoc
              [
                ( "focus",
                  `Assoc
                    [
                      ("kind", `String "resource");
                      ( "resource",
                        `Assoc
                          [
                            ("@context", `String "https://schema.org");
                            ("@id", `String "res-1");
                            ("name", `String "A resource");
                            ( "representations",
                              `List
                                [
                                  `Assoc [ ("mediaType", `String "text/plain") ];
                                ] );
                          ] );
                    ] );
                ("graph", `Assoc [ ("nodes", `List []); ("edges", `List []) ]);
                ("metadata", `Assoc []);
              ];
          generation =
            `Assoc
              [
                ("title", `String "A title");
                ("storageUri", `String "file://generated.md");
                ("context", `Assoc [ ("$fixture", `String "context") ]);
              ];
        }
         : fixtures);
     cases =
       [
         ({
            unit = "match";
            case =
              "runs the search it is asked for, and answers under the asker's \
               id after the wire's reply";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "match:search-results" ];
            steps =
              [
                (String : steps_item);
                (Nothing_sent ({ nothing_sent = true } : nothing_sent)
                  : steps_item);
                (Say
                   ({
                      say = "match:search-requested";
                      correlation_id = Some "asked-1";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("referenceId", `String "ref-1");
                            ( "context",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "match:search-requested";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ("referenceId", `String "ref-1");
                                    ("resourceId", `String "res-1");
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Answer
                   ({
                      answer = "match:search-requested";
                      nth = 0;
                      reply = "match:search-results";
                      payload =
                        `Assoc
                          [
                            ("referenceId", `String "ref-1");
                            ("response", `List []);
                          ];
                    }
                     : answer)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "match:search-results";
                             correlation_id =
                               Some
                                 (Object
                                    ({
                                       sent = "match:search-requested";
                                       nth = 0;
                                     }
                                      : correlation_id_object)
                                   : correlation_id);
                             payload =
                               `Assoc
                                 [
                                   ("referenceId", `String "ref-1");
                                   ("response", `List []);
                                 ];
                           }
                            : heard_item);
                          ({
                             channel = "match:search-results";
                             correlation_id =
                               Some (String "asked-1" : correlation_id);
                             payload =
                               `Assoc
                                 [
                                   ("referenceId", `String "ref-1");
                                   ("response", `List []);
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "match";
            case =
              "says a search that failed, with its reference and the reason, \
               under the asker's id";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "match:search-failed" ];
            steps =
              [
                (Say
                   ({
                      say = "match:search-requested";
                      correlation_id = Some "asked-1";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("referenceId", `String "ref-1");
                            ( "context",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Answer
                   ({
                      answer = "match:search-requested";
                      nth = 0;
                      reply = "match:search-failed";
                      payload =
                        `Assoc
                          [
                            ("referenceId", `String "ref-1");
                            ("message", `String "the index is down");
                          ];
                    }
                     : answer)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "match:search-failed";
                             correlation_id =
                               Some
                                 (Object
                                    ({
                                       sent = "match:search-requested";
                                       nth = 0;
                                     }
                                      : correlation_id_object)
                                   : correlation_id);
                             payload =
                               `Assoc
                                 [
                                   ("referenceId", `String "ref-1");
                                   ("message", `String "the index is down");
                                 ];
                           }
                            : heard_item);
                          ({
                             channel = "match:search-failed";
                             correlation_id =
                               Some (String "asked-1" : correlation_id);
                             payload =
                               `Assoc
                                 [
                                   ("referenceId", `String "ref-1");
                                   ("message", `String "the index is down");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "match";
            case =
              "says a search never answered as failed, at the request's \
               deadline";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "match:search-failed" ];
            steps =
              [
                (Say
                   ({
                      say = "match:search-requested";
                      correlation_id = Some "asked-1";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("referenceId", `String "ref-1");
                            ( "context",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "busRequestTimeoutMs";
                              times = None;
                              plus_ms = Some (-1000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Pass ({ pass = (Integer 2000 : pass) } : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "match:search-failed";
                             correlation_id =
                               Some (String "asked-1" : correlation_id);
                             payload =
                               `Assoc
                                 [
                                   ( "$has",
                                     `Assoc [ ("referenceId", `String "ref-1") ]
                                   );
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "match";
            case = "disposed, runs nothing, and leaves the client's bus alone";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Say
                   ({
                      say = "match:search-requested";
                      correlation_id = Some "asked-1";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("referenceId", `String "ref-1");
                            ( "context",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Nothing_sent ({ nothing_sent = true } : nothing_sent)
                  : steps_item);
                (Bus_destroyed ({ bus_destroyed = false } : bus_destroyed)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "beckon";
            case = "holds what is hovered, and a hover of none clears it";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({
                      expect = [ ("unit", [ ("hoveredAnnotationId", `Null) ]) ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "beckon:hover";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-1") ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ("unit", [ ("hoveredAnnotationId", `String "ann-1") ]);
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "beckon:hover";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `Null) ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect = [ ("unit", [ ("hoveredAnnotationId", `Null) ]) ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "beckon";
            case = "sparkles what is hovered, and nothing when nothing is";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:sparkle" ];
            steps =
              [
                (Say
                   ({
                      say = "beckon:hover";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-1") ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "beckon:hover";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `Null) ];
                    }
                     : say)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:sparkle";
                             correlation_id = None;
                             payload =
                               `Assoc [ ("annotationId", `String "ann-1") ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "beckon";
            case =
              "turns the focus to an annotation that is opened, here or by \
               another participant";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:focus" ];
            steps =
              [
                (Say
                   ({
                      say = "browse:click";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-1") ];
                    }
                     : say)
                  : steps_item);
                (Deliver
                   ({
                      deliver = "browse:click";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-2") ];
                    }
                     : deliver)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:focus";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("annotationId", `String "ann-1");
                                 ];
                           }
                            : heard_item);
                          ({
                             channel = "beckon:focus";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("annotationId", `String "ann-2");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Expect
                   ({
                      expect = [ ("unit", [ ("hoveredAnnotationId", `Null) ]) ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "beckon";
            case = "focus says the focus";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:focus" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "focus";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-7") ];
                    }
                     : invoke)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:focus";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("annotationId", `String "ann-7");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "beckon";
            case =
              "disposed, hears nothing and says nothing, and leaves the \
               client's bus alone";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:sparkle"; "beckon:focus" ];
            steps =
              [
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Say
                   ({
                      say = "beckon:hover";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-1") ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "browse:click";
                      correlation_id = None;
                      payload = `Assoc [ ("annotationId", `String "ann-1") ];
                    }
                     : say)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "focus";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Ended
                   ({ ended = [ ("unit", [ "hoveredAnnotationId" ]) ] } : ended)
                  : steps_item);
                (Expect
                   ({
                      expect = [ ("unit", [ ("hoveredAnnotationId", `Null) ]) ];
                    }
                     : expect)
                  : steps_item);
                (Bus_destroyed ({ bus_destroyed = false } : bus_destroyed)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case =
              "a pointer that rests hovers, and one that leaves stops at once";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = None;
                              plus_ms = Some (-2);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Pass ({ pass = (Integer 4 : pass) } : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:hover";
                             correlation_id = None;
                             payload =
                               `Assoc [ ("annotationId", `String "ann-1") ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Invoke ({ invoke = "leave"; of_ = "unit"; args = [] } : invoke)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:hover";
                             correlation_id = None;
                             payload = `Assoc [ ("annotationId", `Null) ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case = "a pointer that passes over hovers nothing";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke ({ invoke = "leave"; of_ = "unit"; args = [] } : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case = "a pointer that moves on hovers only where it rests";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-2") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:hover";
                             correlation_id = None;
                             payload =
                               `Assoc [ ("annotationId", `String "ann-2") ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case = "an annotation already hovered is not said again";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:hover";
                             correlation_id = None;
                             payload =
                               `Assoc [ ("annotationId", `String "ann-1") ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case = "disposed, forgets the rest it was waiting out";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "hoverDwell";
            case =
              "disposed, says nothing more, not even the pointer leaving what \
               it hovered";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms =
                       Some
                         (Object
                            ({
                               timing = "hoverDelayMs";
                               times = None;
                               plus_ms = None;
                             }
                              : object_)
                           : pass);
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "beckon:hover" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-2") ];
                    }
                     : invoke)
                  : steps_item);
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Invoke ({ invoke = "leave"; of_ = "unit"; args = [] } : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "enter";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-3") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "hoverDelayMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "beckon:hover";
                             correlation_id = None;
                             payload =
                               `Assoc [ ("annotationId", `String "ann-1") ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case = "begins with nothing, and asks for nothing";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `Null);
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Nothing_sent ({ nothing_sent = true } : nothing_sent)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "asks for an annotation's context of its own resource, and holds \
               it";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool true);
                              ("error", `Null);
                              ("annotationId", `String "ann-1");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "gather:requested";
                      payloads =
                        [
                          `Assoc
                            [
                              ("annotationId", `String "ann-1");
                              ("resourceId", `String "res-1");
                              ( "options",
                                `Assoc [ ("contextWindow", `Int 2000) ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Answer
                   ({
                      answer = "gather:requested";
                      nth = 0;
                      reply = "gather:complete";
                      payload =
                        `Assoc
                          [
                            ("annotationId", `String "ann-1");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "context",
                                `Assoc [ ("$fixture", `String "context") ] );
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `String "ann-1");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case = "takes the window it is asked for";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args =
                        [
                          ("annotationId", `String "ann-1");
                          ("contextWindow", `Int 500);
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "gather:requested";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "options",
                                      `Assoc [ ("contextWindow", `Int 500) ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "takes the contexts it is asked for, a context left out as well \
               as one asked for";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args =
                        [
                          ("annotationId", `String "ann-1");
                          ("includeSourceContext", `Bool false);
                          ("includeTargetContext", `Bool true);
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "gather:requested";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "options",
                                      `Assoc
                                        [
                                          ("includeSourceContext", `Bool false);
                                          ("includeTargetContext", `Bool true);
                                          ("contextWindow", `Int 2000);
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "holds the failure of a gather, and the next one clears it and \
               the context the last one left";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Answer
                   ({
                      answer = "gather:requested";
                      nth = 0;
                      reply = "gather:failed";
                      payload =
                        `Assoc
                          [
                            ("annotationId", `String "ann-1");
                            ("message", `String "no such annotation");
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ( "error",
                                `Assoc
                                  [ ("message", `String "no such annotation") ]
                              );
                              ("annotationId", `String "ann-1");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-2") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool true);
                              ("error", `Null);
                              ("annotationId", `String "ann-2");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer
                   ({
                      answer = "gather:requested";
                      nth = 1;
                      reply = "gather:complete";
                      payload =
                        `Assoc
                          [
                            ("annotationId", `String "ann-2");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-3") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool true);
                              ("error", `Null);
                              ("annotationId", `String "ann-3");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case = "fails a gather never answered, at the request's deadline";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "busRequestTimeoutMs";
                              times = None;
                              plus_ms = Some (-1000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("loading", `Bool true) ]) ] }
                     : expect)
                  : steps_item);
                (Pass ({ pass = (Integer 2000 : pass) } : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("loading", `Bool false);
                              ( "error",
                                `Assoc [ ("code", `String "bus.timeout") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "a resource's gather is loading when the call returns, and then \
               holds the context";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `Null);
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool true);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "gather:resource-requested";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc [ ("resourceId", `String "res-9") ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Answer
                   ({
                      answer = "gather:resource-requested";
                      nth = 0;
                      reply = "gather:resource-complete";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-9");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `Null);
                              ( "resourceContext",
                                `Assoc [ ("$fixture", `String "context") ] );
                              ("resourceLoading", `Bool false);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "a resource's gather holds its failure, and the next one clears \
               it";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Answer
                   ({
                      answer = "gather:resource-requested";
                      nth = 0;
                      reply = "gather:resource-failed";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-9");
                            ("message", `String "no such resource");
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `Null);
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ( "resourceError",
                                `Assoc
                                  [ ("message", `String "no such resource") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `Null);
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool true);
                              ("resourceError", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case = "keeps an annotation's gather and a resource's apart";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Answer
                   ({
                      answer = "gather:resource-requested";
                      nth = 0;
                      reply = "gather:resource-failed";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-9");
                            ("message", `String "no such resource");
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("context", `Null);
                              ("loading", `Bool true);
                              ("error", `Null);
                              ("annotationId", `String "ann-1");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ( "resourceError",
                                `Assoc
                                  [ ("message", `String "no such resource") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer
                   ({
                      answer = "gather:requested";
                      nth = 0;
                      reply = "gather:complete";
                      payload =
                        `Assoc
                          [
                            ("annotationId", `String "ann-1");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "context",
                                `Assoc [ ("$fixture", `String "context") ] );
                              ("loading", `Bool false);
                              ("error", `Null);
                              ("annotationId", `String "ann-1");
                              ("resourceContext", `Null);
                              ("resourceLoading", `Bool false);
                              ( "resourceError",
                                `Assoc
                                  [ ("message", `String "no such resource") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "gather";
            case =
              "disposed, is inert, an answer that comes later lands nowhere, \
               and it leaves the client's bus alone";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-1") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Answer
                   ({
                      answer = "gather:requested";
                      nth = 0;
                      reply = "gather:complete";
                      payload =
                        `Assoc
                          [
                            ("annotationId", `String "ann-1");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (Answer
                   ({
                      answer = "gather:resource-requested";
                      nth = 0;
                      reply = "gather:resource-complete";
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-9");
                            ( "response",
                              `Assoc [ ("$fixture", `String "context") ] );
                          ];
                    }
                     : answer)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherAnnotation";
                      of_ = "unit";
                      args = [ ("annotationId", `String "ann-2") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "gatherResource";
                      of_ = "unit";
                      args = [ ("resourceId", `String "res-9") ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Ended
                   ({ ended = [ ("unit", [ "context"; "resourceContext" ]) ] }
                     : ended)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [ ("context", `Null); ("resourceContext", `Null) ]
                          );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_count
                   ({ sent = "gather:requested"; count = 1 } : sent_count)
                  : steps_item);
                (Sent_count
                   ({ sent = "gather:resource-requested"; count = 1 }
                     : sent_count)
                  : steps_item);
                (Bus_destroyed ({ bus_destroyed = false } : bus_destroyed)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case =
              "begins idle, and a query of nothing but spaces searches for \
               nothing";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("query", `String "");
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "   ") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [] } : searched) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case =
              "waits for the query to stay the same, and holds the query as it \
               is typed";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "p") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "p") ]) ] }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "pa") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "pa") ]) ] }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "par") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "par") ]) ] }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "pari") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "pari") ]) ] }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "paris") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "paris") ]) ] }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [] } : searched) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [ "paris" ] } : searched) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case = "waits as long as it was told";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = Some 2000;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "paris") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass ({ pass = (Integer 1900 : pass) } : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [] } : searched) : steps_item);
                (Pass ({ pass = (Integer 200 : pass) } : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [ "paris" ] } : searched) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case =
              "begun with a query, searches for it without the spaces around \
               it once it has settled";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some " paris ";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String " paris ") ]) ] }
                     : expect)
                  : steps_item);
                (Searched ({ searched = [] } : searched) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [ "paris" ] } : searched) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case =
              "is searching until its results are known, and follows them after";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some "paris";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool true);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 0; results = None } : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool true);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({
                      answer_search = 0;
                      results = Some [ "Paris"; "Paris, Texas" ];
                    }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ( "results",
                                      `List
                                        [
                                          `String "Paris";
                                          `String "Paris, Texas";
                                        ] );
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 0; results = Some [ "Paris" ] }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List [ `String "Paris" ]);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case = "a new query abandons the search before it";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some "paris";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "rome") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [ "paris"; "rome" ] } : searched)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool true);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 0; results = Some [ "Paris" ] }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool true);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 1; results = Some [ "Rome" ] }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List [ `String "Rome" ]);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case = "a query already searched for is not searched for again";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some "paris";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 0; results = Some [ "Paris" ] }
                     : answer_search)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "pari") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "paris") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Searched ({ searched = [ "paris" ] } : searched) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List [ `String "Paris" ]);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case =
              "a query that is cleared has no results, and abandons its search";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some "paris";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Answer_search
                   ({ answer_search = 0; results = Some [ "Paris" ] }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Answer_search
                   ({
                      answer_search = 0;
                      results = Some [ "Paris"; "Paris, Texas" ];
                    }
                     : answer_search)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "state",
                                `Assoc
                                  [
                                    ("results", `List []);
                                    ("isSearching", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Searched ({ searched = [ "paris" ] } : searched) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "search";
            case = "disposed, is inert";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = Some "paris";
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Invoke
                   ({
                      invoke = "setQuery";
                      of_ = "unit";
                      args = [ ("value", `String "rome") ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "searchDebounceMs";
                              times = None;
                              plus_ms = Some 2;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Ended ({ ended = [ ("unit", [ "query"; "state" ]) ] } : ended)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("query", `String "paris") ]) ] }
                     : expect)
                  : steps_item);
                (Searched ({ searched = [] } : searched) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "begins idle, and generates in its locale unless a language is \
               stated";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "fr";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("title", `String "A title");
                                ("storageUri", `String "file://generated.md");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                                ("language", `String "de");
                                ("maxTokens", `Int 900);
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("title", `String "A title");
                                ("storageUri", `String "file://generated.md");
                                ( "context",
                                  `Assoc [ ("$fixture", `String "context") ] );
                                ("language", `String "");
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ("jobType", `String "yield");
                                    ( "params",
                                      `Assoc
                                        [
                                          ( "$has",
                                            `Assoc
                                              [ ("language", `String "fr") ] );
                                        ] );
                                  ] );
                            ];
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ("jobType", `String "yield");
                                    ( "params",
                                      `Assoc
                                        [
                                          ("title", `String "A title");
                                          ( "storageUri",
                                            `String "file://generated.md" );
                                          ( "context",
                                            `Assoc
                                              [
                                                ("$fixture", `String "context");
                                              ] );
                                          ("language", `String "de");
                                          ("maxTokens", `Int 900);
                                        ] );
                                  ] );
                            ];
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ("jobType", `String "yield");
                                    ( "params",
                                      `Assoc
                                        [
                                          ( "$has",
                                            `Assoc
                                              [ ("language", `String "fr") ] );
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "shows a run's progress, and keeps it with the outcome when the \
               run ends";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool true);
                              ("progress", `Assoc [ ("percentage", `Int 5) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 95);
                            ("progress", `Assoc [ ("percentage", `Int 95) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool true);
                              ("progress", `Assoc [ ("percentage", `Int 95) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ( "result",
                              `Assoc
                                [
                                  ("resourceId", `String "res-new");
                                  ("resourceName", `String "New");
                                  ("truncated", `Bool true);
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Assoc [ ("percentage", `Int 95) ]);
                              ( "outcome",
                                `Assoc
                                  [
                                    ("resourceId", `String "res-new");
                                    ("resourceName", `String "New");
                                    ("truncated", `Bool true);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case = "holds its job's id from the queue's answer to the job's end";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (Answer
                   ({
                      answer = "job:create";
                      nth = 0;
                      reply = "job:created";
                      payload =
                        `Assoc
                          [
                            ("response", `Assoc [ ("jobId", `String "job-1") ]);
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("jobId", `String "job-1");
                              ("isGenerating", `Bool false);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ( "result",
                              `Assoc
                                [
                                  ("resourceId", `String "res-new");
                                  ("resourceName", `String "New");
                                  ("truncated", `Bool false);
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "forgets the id of a job that fails, and of the last run when \
               another begins";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case = "has no outcome from a completion that carries no generation";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Assoc [ ("percentage", `Int 5) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "clears the progress of a run that fails, and holds why it ended";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool true);
                              ("progress", `Assoc [ ("percentage", `Int 5) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc
                                  [
                                    ("code", `String "job.failed");
                                    ("message", `String "the model refused");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "keeps a cancelled run's progress and says it was cancelled, \
               until it is dismissed";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Queue_reply
                   ({
                      queue_reply = "job:status-requested";
                      response =
                        `Assoc
                          [
                            ("jobId", `String "job-1");
                            ("type", `String "yield");
                            ("status", `String "cancelled");
                            ("userId", `String "did:web:example.org:users:alice");
                            ("created", `String "2026-10-01T00:00:00.000Z");
                          ];
                    }
                     : queue_reply)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Assoc [ ("percentage", `Int 40) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.cancelled") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case = "begins each run without the last one's progress";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Queue_reply
                   ({
                      queue_reply = "job:status-requested";
                      response =
                        `Assoc
                          [
                            ("jobId", `String "job-1");
                            ("type", `String "yield");
                            ("status", `String "cancelled");
                            ("userId", `String "did:web:example.org:users:alice");
                            ("created", `String "2026-10-01T00:00:00.000Z");
                          ];
                    }
                     : queue_reply)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Assoc [ ("percentage", `Int 40) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "keeps generating through an attempt that will be tried again";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "busy");
                            ("willRetry", `Bool true);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool true);
                              ("progress", `Assoc [ ("percentage", `Int 5) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "stops generating when a run stalls, and holds that it stalled";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                          ("stallDeadlineMs", `Int 5000);
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool true);
                              ("progress", `Assoc [ ("percentage", `Int 5) ]);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass ({ pass = (Integer 6000 : pass) } : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.stalled") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case =
              "holds why a run failed until it is dismissed or another begins, \
               and a retried attempt is no failure";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.failed") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.failed") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("error", `String "busy");
                            ("willRetry", `Bool true);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case = "dismissed, or begun again, clears what the last run left";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 95);
                            ("progress", `Assoc [ ("percentage", `Int 95) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ( "result",
                              `Assoc
                                [
                                  ("resourceId", `String "res-new");
                                  ("resourceName", `String "New");
                                  ("truncated", `Bool false);
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Assoc [ ("percentage", `Int 95) ]);
                              ( "outcome",
                                `Assoc
                                  [
                                    ("resourceId", `String "res-new");
                                    ("resourceName", `String "New");
                                    ("truncated", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false);
                              ("progress", `Null);
                              ("outcome", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 95);
                            ("progress", `Assoc [ ("percentage", `Int 95) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ( "result",
                              `Assoc
                                [
                                  ("resourceId", `String "res-new");
                                  ("resourceName", `String "New");
                                  ("truncated", `Bool false);
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "outcome",
                                `Assoc
                                  [
                                    ("resourceId", `String "res-new");
                                    ("resourceName", `String "New");
                                    ("truncated", `Bool false);
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("outcome", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "yield";
            case = "disposed, is inert, and leaves the client's bus alone";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = Some "en";
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "yield");
                            ("percentage", `Int 5);
                            ("progress", `Assoc [ ("percentage", `Int 5) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "generate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("$fixture", `String "generation") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Ended
                   ({ ended = [ ("unit", [ "isGenerating"; "progress" ]) ] }
                     : ended)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("isGenerating", `Bool false); ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_count ({ sent = "job:create"; count = 1 } : sent_count)
                  : steps_item);
                (Bus_destroyed ({ bus_destroyed = false } : bus_destroyed)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "holds the annotation a selection asks for, until it is cancelled";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("pendingAnnotation", `Null);
                              ("delegatingMotivation", `Null);
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "highlighting");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "hello");
                                        ] );
                                    ("motivation", `String "highlighting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "cancelPending"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("pendingAnnotation", `Null) ]) ] }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case = "carries a selector of several as it was given";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `List
                                [
                                  `Assoc
                                    [
                                      ("type", `String "TextPositionSelector");
                                      ("start", `Int 3);
                                      ("end", `Int 8);
                                    ];
                                  `Assoc
                                    [
                                      ("type", `String "TextQuoteSelector");
                                      ("exact", `String "hello");
                                      ("prefix", `String "oh ");
                                      ("suffix", `String " there");
                                    ];
                                  `Assoc
                                    [
                                      ("type", `String "SvgSelector");
                                      ("value", `String "<svg/>");
                                    ];
                                  `Assoc
                                    [
                                      ("type", `String "FragmentSelector");
                                      ("value", `String "page=2");
                                      ( "conformsTo",
                                        `String
                                          "http://tools.ietf.org/rfc/rfc3778" );
                                    ];
                                ] );
                            ("motivation", `String "linking");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `List
                                        [
                                          `Assoc
                                            [
                                              ( "type",
                                                `String "TextPositionSelector"
                                              );
                                              ("start", `Int 3);
                                              ("end", `Int 8);
                                            ];
                                          `Assoc
                                            [
                                              ( "type",
                                                `String "TextQuoteSelector" );
                                              ("exact", `String "hello");
                                              ("prefix", `String "oh ");
                                              ("suffix", `String " there");
                                            ];
                                          `Assoc
                                            [
                                              ("type", `String "SvgSelector");
                                              ("value", `String "<svg/>");
                                            ];
                                          `Assoc
                                            [
                                              ( "type",
                                                `String "FragmentSelector" );
                                              ("value", `String "page=2");
                                              ( "conformsTo",
                                                `String
                                                  "http://tools.ietf.org/rfc/rfc3778"
                                              );
                                            ];
                                        ] );
                                    ("motivation", `String "linking");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "creates what is submitted, and it stops being pending once \
               recorded";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies =
                   Some
                     [
                       ( "mark:create-request",
                         [ `Assoc [ ("annotationId", `String "ann-new") ] ] );
                     ];
                 delay_ms = Some 1000;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "commenting");
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "mark:submit";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ("motivation", `String "commenting");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ( "body",
                              `List
                                [
                                  `Assoc
                                    [
                                      ("type", `String "TextualBody");
                                      ("value", `String "a comment");
                                      ("purpose", `String "commenting");
                                    ];
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "mark:create-request";
                      payloads =
                        [
                          `Assoc
                            [
                              ("resourceId", `String "res-1");
                              ( "request",
                                `Assoc
                                  [
                                    ("motivation", `String "commenting");
                                    ( "target",
                                      `Assoc
                                        [
                                          ("source", `String "res-1");
                                          ( "selector",
                                            `Assoc
                                              [
                                                ( "type",
                                                  `String "TextQuoteSelector" );
                                                ("exact", `String "hello");
                                              ] );
                                        ] );
                                    ( "body",
                                      `List
                                        [
                                          `Assoc
                                            [
                                              ("type", `String "TextualBody");
                                              ("value", `String "a comment");
                                              ("purpose", `String "commenting");
                                            ];
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "hello");
                                        ] );
                                    ("motivation", `String "commenting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass ({ pass = (Integer 1002 : pass) } : steps_item_pass)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("pendingAnnotation", `Null) ]) ] }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "keeps its pending annotation when another creation is recorded";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "commenting");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Deliver
                   ({
                      deliver = "mark:create-ok";
                      correlation_id = Some "somebody-else";
                      payload =
                        `Assoc
                          [
                            ( "response",
                              `Assoc [ ("annotationId", `String "ann-other") ]
                            );
                          ];
                    }
                     : deliver)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "hello");
                                        ] );
                                    ("motivation", `String "commenting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "says a creation that failed, and keeps the annotation pending";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:create-error" ];
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "commenting");
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "mark:submit";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ("motivation", `String "commenting");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ( "body",
                              `List
                                [
                                  `Assoc
                                    [
                                      ("type", `String "TextualBody");
                                      ("value", `String "a comment");
                                      ("purpose", `String "commenting");
                                    ];
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:create-error";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ( "$has",
                                     `Assoc [ ("resourceId", `String "res-1") ]
                                   );
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "hello");
                                        ] );
                                    ("motivation", `String "commenting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates the job it is asked for, on its own resource, and \
               shows its progress";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("motivation", `String "commenting");
                                ("instructions", `String "the dates");
                                ("tone", `String "scholarly");
                                ("density", `Int 3);
                                ("language", `String "fr");
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "commenting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ("jobType", `String "mark");
                              ("resourceId", `String "res-1");
                              ( "params",
                                `Assoc
                                  [
                                    ("motivation", `String "commenting");
                                    ("instructions", `String "the dates");
                                    ("tone", `String "scholarly");
                                    ("density", `Int 3);
                                    ("language", `String "fr");
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "commenting");
                              ("progress", `Assoc [ ("percentage", `Int 40) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Assoc [ ("percentage", `Int 40) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "holds its delegated job's id from the queue's answer to the \
               job's end";
            transport =
              ({ answers = (Never : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (Answer
                   ({
                      answer = "job:create";
                      nth = 0;
                      reply = "job:created";
                      payload =
                        `Assoc
                          [
                            ("response", `Assoc [ ("jobId", `String "job-1") ]);
                          ];
                    }
                     : answer)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "forgets the id of a delegated job that fails, and of the last \
               job when another is asked for";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("jobId", `String "job-1") ]) ] }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case = "begins each delegated job without the last one's progress";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Assoc [ ("percentage", `Int 40) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "clears a delegated job that fails, and says no silence of it";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "keeps a cancelled job's progress and its motivation, and says \
               it was cancelled";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 60);
                            ("progress", `Assoc [ ("percentage", `Int 60) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Queue_reply
                   ({
                      queue_reply = "job:status-requested";
                      response =
                        `Assoc
                          [
                            ("jobId", `String "job-1");
                            ("type", `String "mark");
                            ("status", `String "cancelled");
                            ("userId", `String "did:web:example.org:users:alice");
                            ("created", `String "2026-10-01T00:00:00.000Z");
                          ];
                    }
                     : queue_reply)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Assoc [ ("percentage", `Int 60) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("progressMotivation", `String "highlighting");
                              ( "failure",
                                `Assoc [ ("code", `String "job.cancelled") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "clears the motivation of a failed job's progress, and says why \
               it ended";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 30);
                            ("progress", `Assoc [ ("percentage", `Int 30) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("progressMotivation", `Null);
                              ( "failure",
                                `Assoc [ ("code", `String "job.failed") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "holds the motivation its progress is of until the progress is \
               dismissed";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({ expect = [ ("unit", [ ("progressMotivation", `Null) ]) ] }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [ ("progressMotivation", `String "highlighting") ]
                          );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 100);
                            ("progress", `Assoc [ ("percentage", `Int 100) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Assoc [ ("percentage", `Int 100) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [ ("progressMotivation", `String "highlighting") ]
                          );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("progressMotivation", `Null) ]) ] }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "commenting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [ ("progressMotivation", `String "commenting") ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "holds why a job ended until it is dismissed or another begins, \
               and a completion is no failure";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.failed") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Say
                   ({
                      say = "job:fail";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("error", `String "the model refused");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "failure",
                                `Assoc [ ("code", `String "job.failed") ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({ expect = [ ("unit", [ ("failure", `Null) ]) ] } : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates a highlighting job, holds its motivation, and says \
               that motivation has gone quiet";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "params",
                                      `Assoc
                                        [
                                          ("motivation", `String "highlighting");
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "highlighting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates a commenting job, holds its motivation, and says that \
               motivation has gone quiet";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("motivation", `String "commenting");
                                ("tone", `String "scholarly");
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "commenting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "params",
                                      `Assoc
                                        [
                                          ("motivation", `String "commenting");
                                          ("tone", `String "scholarly");
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "commenting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates a assessing job, holds its motivation, and says that \
               motivation has gone quiet";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("motivation", `String "assessing");
                                ("tone", `String "critical");
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "assessing");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "params",
                                      `Assoc
                                        [
                                          ("motivation", `String "assessing");
                                          ("tone", `String "critical");
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "assessing");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates a linking job, holds its motivation, and says that \
               motivation has gone quiet";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("motivation", `String "linking");
                                ("entityTypes", `List [ `String "Person" ]);
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "linking");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "params",
                                      `Assoc
                                        [
                                          ("motivation", `String "linking");
                                          ( "entityTypes",
                                            `List [ `String "Person" ] );
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "linking");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "delegates a tagging job, holds its motivation, and says that \
               motivation has gone quiet";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc
                              [
                                ("motivation", `String "tagging");
                                ("schemaId", `String "s1");
                                ("categories", `List [ `String "claim" ]);
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "tagging");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ( "params",
                                      `Assoc
                                        [
                                          ("motivation", `String "tagging");
                                          ("schemaId", `String "s1");
                                          ( "categories",
                                            `List [ `String "claim" ] );
                                        ] );
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "tagging");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case = "clears a delegated job that could not be started";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "says once that a delegated job has gone quiet, and keeps \
               following it";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some (-1000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass ({ pass = (Integer 2000 : pass) } : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "highlighting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Assoc [ ("percentage", `Int 0) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 3.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Say
                   ({
                      say = "job:complete";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `Null);
                              ("progress", `Assoc [ ("percentage", `Int 0) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "counts a delegated job's silence from the last thing it said";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some (-10000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 10);
                            ("progress", `Assoc [ ("percentage", `Int 10) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some (-10000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 20);
                            ("progress", `Assoc [ ("percentage", `Int 20) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some (-10000);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 30);
                            ("progress", `Assoc [ ("percentage", `Int 30) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Assoc [ ("percentage", `Int 30) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "highlighting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Assoc [ ("percentage", `Int 30) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 50);
                            ("progress", `Assoc [ ("percentage", `Int 50) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = None;
                              plus_ms = Some 1000;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "highlighting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "counts a delegated job's silence past a frame on its channels \
               that is refused, and says it once, when it falls due";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Deliver
                   ({
                      deliver = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : deliver)
                  : steps_item);
                (String : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Pass ({ pass = (Integer 1 : pass) } : steps_item_pass)
                  : steps_item);
                (Heard
                   ({
                      heard =
                        [
                          ({
                             channel = "mark:delegate-timeout";
                             correlation_id = None;
                             payload =
                               `Assoc
                                 [
                                   ("resourceId", `String "res-1");
                                   ("motivation", `String "highlighting");
                                 ];
                           }
                            : heard_item);
                        ];
                    }
                     : heard)
                  : steps_item);
                (Deliver
                   ({
                      deliver = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                          ];
                    }
                     : deliver)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [ ("delegatingMotivation", `String "highlighting") ]
                          );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case =
              "units of two resources on one client each answer for their own, \
               and what is asked of one moves no other";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies =
                   Some
                     [
                       ( "mark:create-request",
                         [ `Assoc [ ("annotationId", `String "ann-new") ] ] );
                       ("job:create", [ `Assoc [ ("jobId", `String "job-a") ] ]);
                     ];
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "first",
                  ({
                     resource_id = Some "res-a";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
                ( "second",
                  ({
                     resource_id = Some "res-b";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-a");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "highlighting");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "first",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "hello");
                                        ] );
                                    ("motivation", `String "highlighting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Expect
                   ({
                      expect = [ ("second", [ ("pendingAnnotation", `Null) ]) ];
                    }
                     : expect)
                  : steps_item);
                (Say
                   ({
                      say = "mark:submit";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-a");
                            ("motivation", `String "commenting");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ( "body",
                              `List
                                [
                                  `Assoc
                                    [
                                      ("type", `String "TextualBody");
                                      ("value", `String "a comment");
                                      ("purpose", `String "commenting");
                                    ];
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "mark:create-request";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc [ ("resourceId", `String "res-a") ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "first";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Sent_payloads
                   ({
                      sent = "job:create";
                      payloads =
                        [
                          `Assoc
                            [
                              ( "$has",
                                `Assoc
                                  [
                                    ("jobType", `String "mark");
                                    ("resourceId", `String "res-a");
                                  ] );
                            ];
                        ];
                    }
                     : sent_payloads)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "first",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progressMotivation", `String "highlighting");
                            ] );
                          ( "second",
                            [
                              ("delegatingMotivation", `Null);
                              ("progressMotivation", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({ invoke = "dismissProgress"; of_ = "second"; args = [] }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "first",
                            [
                              ("delegatingMotivation", `String "highlighting");
                              ("progressMotivation", `String "highlighting");
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case = "acts on what it hears in the order it was said";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "first");
                                ] );
                            ("motivation", `String "highlighting");
                          ];
                    }
                     : say)
                  : steps_item);
                (Invoke
                   ({ invoke = "cancelPending"; of_ = "unit"; args = [] }
                     : invoke)
                  : steps_item);
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "last");
                                ] );
                            ("motivation", `String "commenting");
                          ];
                    }
                     : say)
                  : steps_item);
                (String : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "pendingAnnotation",
                                `Assoc
                                  [
                                    ( "selector",
                                      `Assoc
                                        [
                                          ("type", `String "TextQuoteSelector");
                                          ("exact", `String "last");
                                        ] );
                                    ("motivation", `String "commenting");
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "mark";
            case = "disposed, is inert, and leaves the client's bus alone";
            transport =
              ({ answers = (Jobs : answers); replies = None; delay_ms = None }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = Some "res-1";
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = Some [ "mark:delegate-timeout"; "mark:create-error" ];
            steps =
              [
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (String : steps_item);
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Say
                   ({
                      say = "mark:requested";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ("motivation", `String "commenting");
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "mark:submit";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("source", `String "res-1");
                            ("motivation", `String "commenting");
                            ( "selector",
                              `Assoc
                                [
                                  ("type", `String "TextQuoteSelector");
                                  ("exact", `String "hello");
                                ] );
                            ( "body",
                              `List
                                [
                                  `Assoc
                                    [
                                      ("type", `String "TextualBody");
                                      ("value", `String "a comment");
                                      ("purpose", `String "commenting");
                                    ];
                                ] );
                          ];
                    }
                     : say)
                  : steps_item);
                (Say
                   ({
                      say = "job:report-progress";
                      correlation_id = None;
                      payload =
                        `Assoc
                          [
                            ("resourceId", `String "res-1");
                            ("jobId", `String "job-1");
                            ("jobType", `String "mark");
                            ("percentage", `Int 40);
                            ("progress", `Assoc [ ("percentage", `Int 40) ]);
                          ];
                    }
                     : say)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "requestDelegate";
                      of_ = "unit";
                      args =
                        [
                          ( "params",
                            `Assoc [ ("motivation", `String "highlighting") ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "delegateSilenceMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass);
                    }
                     : steps_item_pass)
                  : steps_item);
                (Ended
                   ({
                      ended =
                        [
                          ( "unit",
                            [
                              "pendingAnnotation";
                              "delegatingMotivation";
                              "progress";
                            ] );
                        ];
                    }
                     : ended)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("pendingAnnotation", `Null); ("progress", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Heard ({ heard = [] } : heard) : steps_item);
                (Sent_count ({ sent = "job:create"; count = 1 } : sent_count)
                  : steps_item);
                (Sent_count
                   ({ sent = "mark:create-request"; count = 0 } : sent_count)
                  : steps_item);
                (Bus_destroyed ({ bus_destroyed = false } : bus_destroyed)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "sessionSignals";
            case = "begins with nothing raised";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("sessionEnded", `Null);
                              ("permissionDenied", `Null);
                              ("kbIdentityConflict", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "sessionSignals";
            case = "raises each notice, and acknowledging one clears it alone";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "notifySessionEnded";
                      of_ = "unit";
                      args = [ ("reason", `String "expired") ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "sessionEnded",
                                `Assoc [ ("reason", `String "expired") ] );
                              ("permissionDenied", `Null);
                              ("kbIdentityConflict", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "notifyPermissionDenied";
                      of_ = "unit";
                      args = [ ("detail", `String "only an admin may do that") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "notifyKbIdentityConflict";
                      of_ = "unit";
                      args =
                        [
                          ( "conflict",
                            `Assoc
                              [
                                ("expectedDid", `String "did:web:kb.example.org");
                                ( "observedDid",
                                  `String "did:web:other.example.org" );
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "sessionEnded",
                                `Assoc [ ("reason", `String "expired") ] );
                              ( "permissionDenied",
                                `Assoc
                                  [
                                    ( "detail",
                                      `String "only an admin may do that" );
                                  ] );
                              ( "kbIdentityConflict",
                                `Assoc
                                  [
                                    ( "expectedDid",
                                      `String "did:web:kb.example.org" );
                                    ( "observedDid",
                                      `String "did:web:other.example.org" );
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "acknowledgeSessionEnded";
                      of_ = "unit";
                      args = [];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("sessionEnded", `Null);
                              ( "permissionDenied",
                                `Assoc
                                  [
                                    ( "detail",
                                      `String "only an admin may do that" );
                                  ] );
                              ( "kbIdentityConflict",
                                `Assoc
                                  [
                                    ( "expectedDid",
                                      `String "did:web:kb.example.org" );
                                    ( "observedDid",
                                      `String "did:web:other.example.org" );
                                  ] );
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "acknowledgePermissionDenied";
                      of_ = "unit";
                      args = [];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "acknowledgeKbIdentityConflict";
                      of_ = "unit";
                      args = [];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("sessionEnded", `Null);
                              ("permissionDenied", `Null);
                              ("kbIdentityConflict", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "sessionSignals";
            case =
              "says a session ended for its credential being refused, and a \
               permission refused with no detail";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Invoke
                   ({
                      invoke = "notifySessionEnded";
                      of_ = "unit";
                      args = [ ("reason", `String "refused") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "notifyPermissionDenied";
                      of_ = "unit";
                      args = [ ("detail", `Null) ];
                    }
                     : invoke)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ( "sessionEnded",
                                `Assoc [ ("reason", `String "refused") ] );
                              ("permissionDenied", `Assoc [ ("detail", `Null) ]);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
         ({
            unit = "sessionSignals";
            case = "disposed, ends every notice and raises nothing more";
            transport =
              ({
                 answers = (Refuses : answers);
                 replies = None;
                 delay_ms = None;
               }
                : transport);
            made =
              [
                ( "unit",
                  ({
                     resource_id = None;
                     locale = None;
                     delay_ms = None;
                     debounce_ms = None;
                     initial_query = None;
                   }
                    : made_value) );
              ];
            listen = None;
            steps =
              [
                (Dispose ({ dispose = "unit" } : dispose) : steps_item);
                (Invoke
                   ({
                      invoke = "notifySessionEnded";
                      of_ = "unit";
                      args = [ ("reason", `String "expired") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "notifyPermissionDenied";
                      of_ = "unit";
                      args = [ ("detail", `String "no") ];
                    }
                     : invoke)
                  : steps_item);
                (Invoke
                   ({
                      invoke = "notifyKbIdentityConflict";
                      of_ = "unit";
                      args =
                        [
                          ( "conflict",
                            `Assoc
                              [
                                ("expectedDid", `String "did:web:kb.example.org");
                                ( "observedDid",
                                  `String "did:web:other.example.org" );
                              ] );
                        ];
                    }
                     : invoke)
                  : steps_item);
                (Ended
                   ({
                      ended =
                        [
                          ( "unit",
                            [
                              "sessionEnded";
                              "permissionDenied";
                              "kbIdentityConflict";
                            ] );
                        ];
                    }
                     : ended)
                  : steps_item);
                (Expect
                   ({
                      expect =
                        [
                          ( "unit",
                            [
                              ("sessionEnded", `Null);
                              ("permissionDenied", `Null);
                              ("kbIdentityConflict", `Null);
                            ] );
                        ];
                    }
                     : expect)
                  : steps_item);
              ];
          }
           : cases_item);
       ];
   }
    : t)

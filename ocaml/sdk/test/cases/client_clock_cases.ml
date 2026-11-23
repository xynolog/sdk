(* Generated from protocol/specs/src/client/clock-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type subject =
  | Degraded_stream
  | Device_grant
  | Discovery
  | Handoff_linger
  | Held_job_stall
  | Invalidation_window
  | Job_follower
  | Job_poll
  | Job_poll_timeout
  | Refused_bus_request
  | Refused_stream
  | Renewal
  | Save_debounce
  | Scope_let_go
  | Scope_taken
  | Timed_out_bus_request
  | Unanswered_emit
  | Unanswered_request
  | Unanswered_stream

let subject_value = function
  | (Degraded_stream : subject) -> "degradedStream"
  | (Device_grant : subject) -> "deviceGrant"
  | (Discovery : subject) -> "discovery"
  | (Handoff_linger : subject) -> "handoffLinger"
  | (Held_job_stall : subject) -> "heldJobStall"
  | (Invalidation_window : subject) -> "invalidationWindow"
  | (Job_follower : subject) -> "jobFollower"
  | (Job_poll : subject) -> "jobPoll"
  | (Job_poll_timeout : subject) -> "jobPollTimeout"
  | (Refused_bus_request : subject) -> "refusedBusRequest"
  | (Refused_stream : subject) -> "refusedStream"
  | (Renewal : subject) -> "renewal"
  | (Save_debounce : subject) -> "saveDebounce"
  | (Scope_let_go : subject) -> "scopeLetGo"
  | (Scope_taken : subject) -> "scopeTaken"
  | (Timed_out_bus_request : subject) -> "timedOutBusRequest"
  | (Unanswered_emit : subject) -> "unansweredEmit"
  | (Unanswered_request : subject) -> "unansweredRequest"
  | (Unanswered_stream : subject) -> "unansweredStream"

let subject_json v = `String (subject_value v)

type counted = { counted : int }

let counted_json (r : counted) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("counted", (fun n -> `Int n) r.counted) ])

type object_ = { timing : string; times : float option; plus_ms : int option }

let object__json (r : object_) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("timing", (fun s -> `String s) r.timing);
         Option.map (fun v -> ("times", (fun f -> `Float f) v)) r.times;
         Option.map (fun v -> ("plusMs", (fun n -> `Int n) v)) r.plus_ms;
       ])

type pass_pass = Integer of int | Object of object_

let pass_pass_json = function
  | (Integer v : pass_pass) -> (fun n -> `Int n) v
  | (Object v : pass_pass) -> object__json v

type pass = { pass : pass_pass }

let pass_json (r : pass) =
  `Assoc
    (List.filter_map Fun.id [ Option.Some ("pass", pass_pass_json r.pass) ])

type item_steps_item = Settle | Act

let item_steps_item_value = function
  | (Settle : item_steps_item) -> "settle"
  | (Act : item_steps_item) -> "act"

let item_steps_item_json v = `String (item_steps_item_value v)

type steps_item =
  | String of item_steps_item
  | Counted of counted
  | Pass of pass

let steps_item_json = function
  | (String v : steps_item) -> item_steps_item_json v
  | (Counted v : steps_item) -> counted_json v
  | (Pass v : steps_item) -> pass_json v

type given = {
  retry_after_seconds : int option;
  lifetime_seconds : int option;
  interval_seconds : int option;
  answers : string list option;
}

let given_json (r : given) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.map
           (fun v -> ("retryAfterSeconds", (fun n -> `Int n) v))
           r.retry_after_seconds;
         Option.map
           (fun v -> ("lifetimeSeconds", (fun n -> `Int n) v))
           r.lifetime_seconds;
         Option.map
           (fun v -> ("intervalSeconds", (fun n -> `Int n) v))
           r.interval_seconds;
         Option.map
           (fun v ->
             ("answers", (fun l -> `List (List.map (fun s -> `String s) l)) v))
           r.answers;
       ])

type cases_item = {
  subject : subject;
  case : string;
  steps : steps_item list;
  given : given option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("subject", subject_json r.subject);
         Option.Some ("case", (fun s -> `String s) r.case);
         Option.Some
           ("steps", (fun l -> `List (List.map steps_item_json l)) r.steps);
         Option.map (fun v -> ("given", given_json v)) r.given;
       ])

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
       "AUTHORITY for the time a Xynolog client keeps: every wait it makes, \
        every interval it measures and every jitter it draws follows a clock \
        and a random source its caller controls, so a caller who moves the \
        clock sees each wait end when this table says, and not a millisecond \
        before. How a caller controls them is each ecosystem's own: the \
        runtime's test clock where the runtime owns time (Go's \
        testing/synctest, Tokio's paused clock, the running asyncio loop's \
        clock, a JavaScript test runner's fake timers), and public parameters \
        of the standard types where the ecosystem's waits take them (Kotlin a \
        CoroutineContext, a TimeSource and a Random; Swift a Clock and a \
        RandomNumberGenerator; C# a TimeProvider and a Random); \
        specs/src/client/surface.json's `clock` section names each SDK's. What \
        is outside it: a reading of the wall clock, which compares now with an \
        instant a server stated (a token's `exp`) or stamps a record, reads \
        the platform's wall clock, which moving the caller's clock need not \
        move; and the randomness of a secret (a PKCE verifier, a nonce, a \
        client assertion's `jti`), which stays the platform's cryptographic \
        source. Every SDK runs these cases in its own process, on its own \
        controlled clock, at the timings specs/src/client/timing.json states, \
        never overridden: moving a clock an hour costs nothing. The \
        conformance drivers, which are other processes on real time, do not \
        run them. Every jitter a case draws is the lowest its source can give, \
        so the equal jitter of a step is half the step. A case names its \
        `subject`, which says what the runner builds and what it counts, and \
        what it is (`case`); `given` states what a subject leaves open. Every \
        network a subject speaks over is faked in the runner's process, and \
        answers at once unless the subject says otherwise. Subjects: \
        `refusedStream`: a transport whose gateway refuses every subscribe \
        with 503, with a `Retry-After` of `given.retryAfterSeconds` when \
        stated; it counts subscribe requests. `unansweredStream`: a transport \
        whose gateway never answers a subscribe; it counts subscribe requests. \
        `degradedStream`: as `refusedStream`; it counts the times the \
        transport's state has become `degraded`. `scopeTaken`: a transport \
        whose gateway answers every subscribe with a stream it holds open, \
        carrying no resource's scope; `act` takes a resource's scope; it \
        counts subscribe requests. `scopeLetGo`: as `scopeTaken`, taking a \
        resource's scope once its stream is open, as the case begins; `act` \
        lets it go; it counts subscribe requests. `handoffLinger`: as \
        `scopeTaken`; it counts the connections the client has closed. \
        `renewal`: a session signed in on an access token issued now, by the \
        wall clock, that lives `given.lifetimeSeconds`, whose issuer renews it \
        every time with a token that lives as long, issued when it renews, and \
        whose gateway accepts every token; it counts renewals. `deviceGrant`: \
        a sign-in by the device grant whose issuer answers the device \
        authorization with a code that lives 900 seconds and an `interval` of \
        `given.intervalSeconds` (none when absent), and answers each ask of \
        its token endpoint with the next of `given.answers`, as an `error` \
        beside a 400, the last repeating; it counts asks of the token \
        endpoint. `heldJobStall`: a worker's claims, over a transport that \
        answers `job:claim` with one job, claimed at the case's start; the job \
        reports nothing but what `act` reports, a progress report of that job; \
        it counts the stalls the claims' `stalled` says. `discovery`: \
        `subscribeDiscovery` given `discoveryIntervalMs` as its interval, over \
        a discovery transport that answers its first read with one managed \
        knowledge base and every read after it as unchanged, whose changes are \
        read as they come; it counts reads. `invalidationWindow`: a client \
        observing the `events` query of one resource \
        (specs/src/client/refresh.json), whose every `browse:events-requested` \
        is answered; `act` delivers from the wire a `mark:added` frame of that \
        resource, which refetches the key; it counts `browse:events-requested` \
        requests sent. `saveDebounce`: a cache that keeps its values, through \
        a storage that records each save; `act` sets a value; it counts saves. \
        `jobFollower`: a client's `mark.delegate`, whose follower keeps no \
        stall deadline, over a transport that answers `job:create` with a job \
        and every `job:status-requested` with that job `running`; the job says \
        nothing but what `act` delivers from the wire, a progress report of \
        that job; it counts `job:status-requested` requests sent. \
        `unansweredRequest`: the gateway's health check (`healthCheck`), over \
        a network that never answers it; it counts the times it has failed as \
        unanswered. `unansweredEmit`: one emit, over a network that never \
        answers `POST /bus/emit`; it counts the emit's attempts. \
        `refusedBusRequest`: one bus request of a resource's events \
        (`browse:events-requested`), made with the deadline a request has \
        unasked (`busRequestTimeoutMs`), over a transport whose gateway \
        answers every subscribe with a stream it holds open and refuses every \
        `POST /bus/emit` with 503, with a `Retry-After` of \
        `given.retryAfterSeconds`; it counts the emit's attempts. \
        `timedOutBusRequest`: as `refusedBusRequest`; it counts the times the \
        request has failed as timed out. `jobPoll`: a client's \
        `job.pollUntilComplete` of one job, naming no interval and no limit of \
        its own, over a transport that answers every `job:status-requested` \
        with that job `running`; it counts `job:status-requested` requests \
        sent. `jobPollTimeout`: as `jobPoll`; it counts the times the poll has \
        failed as timed out. The subject is built, and set going, as the case \
        begins. `steps` run in order: `\"settle\"` lets what is ready run, and \
        what that makes ready, until nothing more is, and moves no time; \
        `pass` settles, then moves the clock, letting what falls due run as it \
        does; `\"act\"` does the subject's action, then settles; `counted` \
        states how many times what the subject counts has happened since the \
        case began, once what is ready has run. A duration is milliseconds, or \
        `{\"timing\": <a name of specs/src/client/timing.json>}` with `times` \
        and `plusMs` to scale and move it, the name of a retry budget followed \
        by `.` and one of its members (`emitRetry.initialDelayMs`). A case \
        states each wait's end as a pair: nothing at a millisecond before it, \
        and the thing counted at it.";
     cases =
       [
         ({
            subject = (Refused_stream : subject);
            case =
              "a stream the gateway refuses is opened again after half of \
               reconnectMs, then after half of twice it: the backoff doubles";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Refused_stream : subject);
            case = "the backoff stops doubling at maxReconnectMs";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 4 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = Some 4.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 5 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "maxReconnectMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 5 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 6 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "maxReconnectMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 6 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 7 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Refused_stream : subject);
            case =
              "a refusal's Retry-After is a floor on the wait before the \
               stream is opened again";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 9999 : pass_pass) } : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = Some 10;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Unanswered_stream : subject);
            case =
              "a subscribe the gateway never answers has failed at \
               streamOpenTimeoutMs, and the stream is opened again on the \
               backoff";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "streamOpenTimeoutMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Degraded_stream : subject);
            case =
              "a stream that has been reconnecting for degradedThresholdMs is \
               degraded";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "degradedThresholdMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = Some 10;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Scope_taken : subject);
            case =
              "a scope taken is carried by a new stream once \
               reconnectDebounceMs has passed";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectDebounceMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Scope_let_go : subject);
            case =
              "a scope let go is dropped by a new stream once lazyRemoveMs has \
               passed";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectDebounceMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "lazyRemoveMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Handoff_linger : subject);
            case =
              "the stream a handoff superseded is read for lingerMs after its \
               successor opens, and closed then";
            steps =
              [
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "reconnectDebounceMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "lingerMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Renewal : subject);
            case =
              "a token that lives fifteen seconds is renewed after \
               minRefreshDelayMs, the floor, and so is each one after it";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "minRefreshDelayMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "minRefreshDelayMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = None;
                   lifetime_seconds = Some 15;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Renewal : subject);
            case =
              "a token that lives an hour is renewed refreshBeforeExpMs before \
               it expires, and not two seconds sooner: its claims are whole \
               seconds, so it may have been issued up to a second before now, \
               and the wall clock its expiry is read against moves on while \
               the case runs";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "refreshBeforeExpMs";
                              times = Some (-1.);
                              plus_ms = Some 3598000;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 2000 : pass_pass) } : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = None;
                   lifetime_seconds = Some 3600;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Device_grant : subject);
            case =
              "an issuer that states no interval is asked every devicePollMs, \
               the first time too";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = None;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = Some [ "authorization_pending" ];
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Device_grant : subject);
            case =
              "an issuer that states an interval of none is asked no oftener \
               than devicePollFloorMs";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollFloorMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = None;
                   lifetime_seconds = None;
                   interval_seconds = Some 0;
                   answers = Some [ "authorization_pending" ];
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Device_grant : subject);
            case =
              "slow_down lengthens the wait by deviceSlowDownMs, for every ask \
               after it";
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "deviceSlowDownMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "devicePollMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "deviceSlowDownMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = None;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = Some [ "slow_down"; "authorization_pending" ];
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Held_job_stall : subject);
            case =
              "a held job is said to have stalled at the first check at which \
               its silence is longer than heldJobStallMs, and only once";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallCheckMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallCheckMs";
                              times = Some 3.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Held_job_stall : subject);
            case = "a progress report starts the held job's silence again";
            steps =
              [
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallCheckMs";
                              times = Some 10.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "heldJobStallCheckMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Discovery : subject);
            case =
              "the discovery document is read at once, and again after each \
               interval";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "discoveryIntervalMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "discoveryIntervalMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Invalidation_window : subject);
            case =
              "the first invalidation of a key refetches at once, those inside \
               its window refetch once when it closes, and one after the \
               window at once";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "invalidationWindowMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "invalidationWindowMs";
                              times = Some 2.;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Counted ({ counted = 4 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Save_debounce : subject);
            case = "a cache saves its values saveDebounceMs after they changed";
            steps =
              [
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "saveDebounceMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Save_debounce : subject);
            case =
              "the wait before a save starts again at each change, so a burst \
               of changes is one save";
            steps =
              [
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "saveDebounceMs";
                              times = Some 0.5;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "saveDebounceMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Job_follower : subject);
            case =
              "a followed job silent for jobSilenceMs is asked for its status, \
               then every jobStatusPollMs, and a frame of it starts the \
               silence again";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobSilenceMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobStatusPollMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (String (Act : item_steps_item) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobSilenceMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Unanswered_request : subject);
            case =
              "a request the gateway never answers fails at \
               httpRequestTimeoutMs, and is not made again";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "httpRequestTimeoutMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Unanswered_emit : subject);
            case =
              "each attempt of an emit the gateway never answers ends at \
               emitTimeoutMs, and the next is made on emitRetry's backoff, \
               which doubles";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "emitTimeoutMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "emitRetry.initialDelayMs";
                              times = Some 0.5;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "emitTimeoutMs";
                              times = None;
                              plus_ms = None;
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "emitRetry.initialDelayMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Refused_bus_request : subject);
            case =
              "a bus request's emit the gateway refuses is made again once the \
               refusal's Retry-After has passed, and given up when the \
               request's deadline falls due at busRequestTimeoutMs: the \
               attempt the next Retry-After puts after the deadline is never \
               made, nor any after it";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 19999 : pass_pass) } : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "busRequestTimeoutMs";
                              times = None;
                              plus_ms = Some (-20000);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 10000 : pass_pass) } : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 20000 : pass_pass) } : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = Some 20;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Timed_out_bus_request : subject);
            case =
              "a bus request whose emit the gateway refuses fails as timed out \
               at busRequestTimeoutMs, while its emit still has attempts left: \
               the request's deadline covers its emit";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "busRequestTimeoutMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given =
              Some
                ({
                   retry_after_seconds = Some 20;
                   lifetime_seconds = None;
                   interval_seconds = None;
                   answers = None;
                 }
                  : given);
          }
           : cases_item);
         ({
            subject = (Job_poll : subject);
            case =
              "a job's pollUntilComplete that names no interval asks for the \
               job's status at once, then every jobPollMs";
            steps =
              [
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobPollMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobPollMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 2 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 3 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
         ({
            subject = (Job_poll_timeout : subject);
            case =
              "a job's pollUntilComplete that names no limit fails as timed \
               out at jobPollTimeoutMs from its first ask, not at an ask after \
               it";
            steps =
              [
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass
                   ({
                      pass =
                        (Object
                           ({
                              timing = "jobPollTimeoutMs";
                              times = None;
                              plus_ms = Some (-1);
                            }
                             : object_)
                          : pass_pass);
                    }
                     : pass)
                  : steps_item);
                (Counted ({ counted = 0 } : counted) : steps_item);
                (Pass ({ pass = (Integer 1 : pass_pass) } : pass) : steps_item);
                (Counted ({ counted = 1 } : counted) : steps_item);
              ];
            given = None;
          }
           : cases_item);
       ];
   }
    : t)

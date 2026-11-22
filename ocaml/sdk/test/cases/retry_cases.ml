(* Generated from protocol/specs/src/retry/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type boot = { why : string; rule : string; status : int; retries : bool }

let boot_json (r : boot) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("rule", (fun s -> `String s) r.rule);
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.Some ("retries", (fun b -> `Bool b) r.retries);
       ])

type job = { why : string; rule : string; status : int; retries : bool }

let job_json (r : job) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("rule", (fun s -> `String s) r.rule);
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.Some ("retries", (fun b -> `Bool b) r.retries);
       ])

type transport = {
  why : string;
  rule : string;
  status : int option;
  method_ : string option;
  keyed : bool option;
  retries : bool;
}

let transport_json (r : transport) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("rule", (fun s -> `String s) r.rule);
         Option.map (fun v -> ("status", (fun n -> `Int n) v)) r.status;
         Option.map (fun v -> ("method", (fun s -> `String s) v)) r.method_;
         Option.map (fun v -> ("keyed", (fun b -> `Bool b) v)) r.keyed;
         Option.Some ("retries", (fun b -> `Bool b) r.retries);
       ])

type refresh = {
  why : string;
  rule : string;
  status : int option;
  retries : bool;
}

let refresh_json (r : refresh) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("rule", (fun s -> `String s) r.rule);
         Option.map (fun v -> ("status", (fun n -> `Int n) v)) r.status;
         Option.Some ("retries", (fun b -> `Bool b) r.retries);
       ])

type rules_item =
  | Boot of boot
  | Job of job
  | Transport of transport
  | Refresh of refresh

let rules_item_json = function
  | (Boot v : rules_item) -> boot_json v
  | (Job v : rules_item) -> job_json v
  | (Transport v : rules_item) -> transport_json v
  | (Refresh v : rules_item) -> refresh_json v

type retry_after_item = {
  why : string;
  header : string option;
  ms : int option;
}

let retry_after_item_json (r : retry_after_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some
           ( "header",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.header );
         Option.Some
           ( "ms",
             (function
               | Option.None -> `Null | Option.Some v -> (fun n -> `Int n) v)
               r.ms );
       ])

type t = {
  comment : string;
  rules : rules_item list;
  retry_after : retry_after_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("rules", (fun l -> `List (List.map rules_item_json l)) r.rules);
         Option.Some
           ( "retryAfter",
             (fun l -> `List (List.map retry_after_item_json l)) r.retry_after
           );
       ])

let table : t =
  ({
     comment =
       "Whether a failed request is worth another attempt, as every \
        implementation must answer it. retry/rules.json states what each rule \
        retries, as sets; each row here is an example of them, and the reader \
        holds every row to them. `rules`: the four named rules, each for one \
        context, asked about a response's `status`, the request's `method`, \
        and whether it carries an `Idempotency-Key` (`keyed`); a row that \
        omits `status` or `method` leaves it unstated, and one that omits \
        `keyed` states a request with no key. `boot`: a boot pass or a bus \
        request, where the peer is usually seconds from ready. `job`: a job's \
        retry budget, where not retrying discards paid work. `transport`: an \
        HTTP client's request, retried only when a repeat cannot cause a \
        second effect: its method cannot, or it carries an `Idempotency-Key`, \
        whose repeat the server answers as it answered the first. A 401 is not \
        retried by any rule: a refused credential is renewed before any rule \
        is asked (contract/TRANSPORT-CONTRACT.md \194\167 A refused \
        credential), and the same token gets the same answer. `refresh`: \
        exchanging a refresh token at its issuer, where the issuer's answer is \
        the verdict and its absence never is. `retryAfter`: the wait a \
        `Retry-After` header states, in milliseconds, when it gives whole \
        seconds, the form the gateway sends; `ms` is null when it states none. \
        Every SDK runs `retryAfter` and every rule it keeps, and names each \
        rule it does not keep and why. `job` is the worker's: an SDK may leave \
        it out, and every worker runs it.";
     rules =
       [
         (Boot
            ({
               why = "429 is the server saying not now";
               rule = "boot";
               status = 429;
               retries = true;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why = "503 is a promise to recover";
               rule = "boot";
               status = 503;
               retries = true;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why = "504 is a promise to recover";
               rule = "boot";
               status = 504;
               retries = true;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why =
                 "500 is an unclassified fault: replaying it inside a boot \
                  pass re-runs whatever broke it";
               rule = "boot";
               status = 500;
               retries = false;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why = "401 means the gateway is up and refused";
               rule = "boot";
               status = 401;
               retries = false;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why = "400 will be refused again";
               rule = "boot";
               status = 400;
               retries = false;
             }
              : boot)
           : rules_item);
         (Boot
            ({
               why =
                 "422 is a key used for another request, and will be refused \
                  again";
               rule = "boot";
               status = 422;
               retries = false;
             }
              : boot)
           : rules_item);
         (Job
            ({
               why = "408 is a timeout";
               rule = "job";
               status = 408;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "429 is the server saying not now";
               rule = "job";
               status = 429;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why =
                 "500 is retried here where boot refuses it: the alternative \
                  is discarding paid work";
               rule = "job";
               status = 500;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why =
                 "502 is a gateway that got no good answer from behind it: the \
                  next attempt may";
               rule = "job";
               status = 502;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "503 is a promise to recover";
               rule = "job";
               status = 503;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "504 is a promise to recover";
               rule = "job";
               status = 504;
               retries = true;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "400 will be refused again";
               rule = "job";
               status = 400;
               retries = false;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "401 will be refused again";
               rule = "job";
               status = 401;
               retries = false;
             }
              : job)
           : rules_item);
         (Job
            ({
               why = "404 will be refused again";
               rule = "job";
               status = 404;
               retries = false;
             }
              : job)
           : rules_item);
         (Transport
            ({
               why =
                 "a 401 on a POST is not retried: a refused credential is \
                  renewed, never retried";
               rule = "transport";
               status = Some 401;
               method_ = Some "POST";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 401 on a GET is not retried either: the method makes no \
                  difference to a refused credential";
               rule = "transport";
               status = Some 401;
               method_ = Some "GET";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 401 with no method stated is not retried";
               rule = "transport";
               status = Some 401;
               method_ = None;
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 502 on a POST is not retried: it may already have been \
                  processed, and a repeat writes twice";
               rule = "transport";
               status = Some 502;
               method_ = Some "POST";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 502 on a POST that carries an Idempotency-Key is retried: \
                  whatever the first did, the repeat is answered as it was";
               rule = "transport";
               status = Some 502;
               method_ = Some "POST";
               keyed = Some true;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 503 on a keyed POST is retried";
               rule = "transport";
               status = Some 503;
               method_ = Some "POST";
               keyed = Some true;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 400 on a keyed POST will be refused again: a key makes a \
                  repeat harmless, not a refused request acceptable";
               rule = "transport";
               status = Some 400;
               method_ = Some "POST";
               keyed = Some true;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 422 on a keyed POST is a key used for another request, and \
                  is refused again";
               rule = "transport";
               status = Some 422;
               method_ = Some "POST";
               keyed = Some true;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a keyed request is retried with no method stated: the key, \
                  not the method, is what makes the repeat harmless";
               rule = "transport";
               status = Some 503;
               method_ = None;
               keyed = Some true;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 502 on a GET is retried";
               rule = "transport";
               status = Some 502;
               method_ = Some "GET";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 504 on a GET is retried";
               rule = "transport";
               status = Some 504;
               method_ = Some "GET";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 503 on a PUT is retried: PUT is idempotent";
               rule = "transport";
               status = Some 503;
               method_ = Some "PUT";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 500 on a DELETE is retried: DELETE is idempotent";
               rule = "transport";
               status = Some 500;
               method_ = Some "DELETE";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 429 on a POST is not retried by this rule";
               rule = "transport";
               status = Some 429;
               method_ = Some "POST";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 429 on a GET is retried";
               rule = "transport";
               status = Some 429;
               method_ = Some "GET";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 413 on a GET is retried";
               rule = "transport";
               status = Some 413;
               method_ = Some "GET";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "the method is read in any case";
               rule = "transport";
               status = Some 408;
               method_ = Some "get";
               keyed = None;
               retries = true;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "a 404 on a GET will be refused again";
               rule = "transport";
               status = Some 404;
               method_ = Some "GET";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why =
                 "a 500 with no method stated is not retried: unstated reads \
                  as unsafe";
               rule = "transport";
               status = Some 500;
               method_ = None;
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Transport
            ({
               why = "no status is not retried by this rule";
               rule = "transport";
               status = None;
               method_ = Some "GET";
               keyed = None;
               retries = false;
             }
              : transport)
           : rules_item);
         (Refresh
            ({
               why =
                 "no response at all is the network, not the issuer: the \
                  session survives a lost packet";
               rule = "refresh";
               status = None;
               retries = true;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why =
                 "400 is the issuer refusing the grant: terminal on the first \
                  answer";
               rule = "refresh";
               status = Some 400;
               retries = false;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why = "401 is the issuer refusing the client";
               rule = "refresh";
               status = Some 401;
               retries = false;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why =
                 "404 on the token endpoint is a misconfiguration, not a \
                  promise to recover: unclassified is terminal";
               rule = "refresh";
               status = Some 404;
               retries = false;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why = "408 is not now";
               rule = "refresh";
               status = Some 408;
               retries = true;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why = "429 is not now";
               rule = "refresh";
               status = Some 429;
               retries = true;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why =
                 "500 is retried here where boot refuses it: one idempotent \
                  exchange has no side effect to replay";
               rule = "refresh";
               status = Some 500;
               retries = true;
             }
              : refresh)
           : rules_item);
         (Refresh
            ({
               why = "503 is not now";
               rule = "refresh";
               status = Some 503;
               retries = true;
             }
              : refresh)
           : rules_item);
       ];
     retry_after =
       [
         ({ why = "whole seconds"; header = Some "5"; ms = Some 5000 }
           : retry_after_item);
         ({
            why = "zero seconds is a stated wait of none";
            header = Some "0";
            ms = Some 0;
          }
           : retry_after_item);
         ({
            why = "surrounding whitespace is not part of the value";
            header = Some " 7 ";
            ms = Some 7000;
          }
           : retry_after_item);
         ({ why = "no header states no wait"; header = None; ms = None }
           : retry_after_item);
         ({
            why = "an empty header states no wait";
            header = Some "";
            ms = None;
          }
           : retry_after_item);
         ({
            why = "the HTTP-date form is not the form the gateway sends";
            header = Some "Wed, 21 Oct 2026 07:28:00 GMT";
            ms = None;
          }
           : retry_after_item);
         ({
            why = "a fraction is not whole seconds";
            header = Some "1.5";
            ms = None;
          }
           : retry_after_item);
         ({
            why = "a negative number is not a wait";
            header = Some "-1";
            ms = None;
          }
           : retry_after_item);
       ];
   }
    : t)

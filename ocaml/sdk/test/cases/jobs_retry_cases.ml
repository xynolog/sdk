(* Generated from protocol/specs/src/jobs/retry-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type failure_class = Transient | Deterministic | Withheld

let failure_class_value = function
  | (Transient : failure_class) -> "transient"
  | (Deterministic : failure_class) -> "deterministic"
  | (Withheld : failure_class) -> "withheld"

let failure_class_json v = `String (failure_class_value v)

type cases_item = {
  why : string;
  retry_count : int;
  max_retries : int;
  failure_class : failure_class option;
  retries : bool;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("retryCount", (fun n -> `Int n) r.retry_count);
         Option.Some ("maxRetries", (fun n -> `Int n) r.max_retries);
         Option.map
           (fun v -> ("failureClass", failure_class_json v))
           r.failure_class;
         Option.Some ("retries", (fun b -> `Bool b) r.retries);
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
       "Whether a failed attempt is retried, as every implementation of the \
        retry predicate must answer it: the dispatcher's queue acts on the \
        answer, and a worker reports it on job:fail as willRetry, so the two \
        must never disagree. A retry is allowed exactly when failureClass is \
        neither \"deterministic\" nor \"withheld\" and retryCount < \
        maxRetries, on the record before the failure is applied \
        (contract/JOBS.md, Retries). Every SDK's `willRetryAfter`, spelled in \
        its own convention, runs every case and fails on any difference; the \
        dispatcher decides with an SDK's, and has none of its own. \
        `failureClass` absent means the failure was not classified. Add a case \
        here before changing an implementation.";
     cases =
       [
         ({
            why = "a transient failure with budget left";
            retry_count = 0;
            max_retries = 1;
            failure_class = Some (Transient : failure_class);
            retries = true;
          }
           : cases_item);
         ({
            why = "an unclassified failure is treated as transient";
            retry_count = 0;
            max_retries = 1;
            failure_class = None;
            retries = true;
          }
           : cases_item);
         ({
            why = "the budget is spent";
            retry_count = 1;
            max_retries = 1;
            failure_class = Some (Transient : failure_class);
            retries = false;
          }
           : cases_item);
         ({
            why = "an unclassified failure with the budget spent";
            retry_count = 1;
            max_retries = 1;
            failure_class = None;
            retries = false;
          }
           : cases_item);
         ({
            why =
              "a deterministic failure, whatever budget is left: the same \
               request cannot succeed a second time";
            retry_count = 0;
            max_retries = 3;
            failure_class = Some (Deterministic : failure_class);
            retries = false;
          }
           : cases_item);
         ({
            why =
              "an answer the provider withheld, whatever budget is left: the \
               same request is withheld again";
            retry_count = 0;
            max_retries = 3;
            failure_class = Some (Withheld : failure_class);
            retries = false;
          }
           : cases_item);
         ({
            why =
              "a withheld answer after an earlier retry, with budget still left";
            retry_count = 1;
            max_retries = 3;
            failure_class = Some (Withheld : failure_class);
            retries = false;
          }
           : cases_item);
         ({
            why = "no retries were ever budgeted (a generation job)";
            retry_count = 0;
            max_retries = 0;
            failure_class = Some (Transient : failure_class);
            retries = false;
          }
           : cases_item);
         ({
            why = "budget left after an earlier retry";
            retry_count = 1;
            max_retries = 3;
            failure_class = None;
            retries = true;
          }
           : cases_item);
       ];
   }
    : t)

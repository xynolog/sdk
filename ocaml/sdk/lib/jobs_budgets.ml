(* Generated from protocol/specs/src/jobs/budgets.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type job_type = Mark | Yield

let job_type_value = function
  | (Mark : job_type) -> "mark"
  | (Yield : job_type) -> "yield"

let job_type_json v = `String (job_type_value v)

type budgets_item = { job_type : job_type; max_retries : int }

let budgets_item_json (r : budgets_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("jobType", job_type_json r.job_type);
         Option.Some ("maxRetries", (fun n -> `Int n) r.max_retries);
       ])

type t = { comment : string; budgets : budgets_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("budgets", (fun l -> `List (List.map budgets_item_json l)) r.budgets);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the retry budget of each job type (JOBS.md \194\167 The \
        record): the `maxRetries` the dispatcher writes into a new job's \
        record, by its type. One row for each JobType. Whether a failed \
        attempt is retried within the budget is jobs/retry-cases.json's.";
     budgets =
       [
         ({ job_type = (Mark : job_type); max_retries = 1 } : budgets_item);
         ({ job_type = (Yield : job_type); max_retries = 0 } : budgets_item);
       ];
   }
    : t)

(* Generated from protocol/specs/src/dispatcher/messages.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type command_error_code =
  | Peer_unavailable
  | Not_found
  | Unauthorized
  | None_pending

let command_error_code_value = function
  | (Peer_unavailable : command_error_code) -> "peer-unavailable"
  | (Not_found : command_error_code) -> "not-found"
  | (Unauthorized : command_error_code) -> "unauthorized"
  | (None_pending : command_error_code) -> "none-pending"

let command_error_code_json v = `String (command_error_code_value v)

type refusals_item = {
  name : string;
  operation : string;
  code : command_error_code option;
  situation : string;
  message : string;
}

let refusals_item_json (r : refusals_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("operation", (fun s -> `String s) r.operation);
         Option.map (fun v -> ("code", command_error_code_json v)) r.code;
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
       ])

type failure_class = Transient | Deterministic | Withheld

let failure_class_value = function
  | (Transient : failure_class) -> "transient"
  | (Deterministic : failure_class) -> "deterministic"
  | (Withheld : failure_class) -> "withheld"

let failure_class_json v = `String (failure_class_value v)

type errors_item = {
  name : string;
  situation : string;
  error : string;
  failure_class : failure_class;
}

let errors_item_json (r : errors_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("error", (fun s -> `String s) r.error);
         Option.Some ("failureClass", failure_class_json r.failure_class);
       ])

type t = {
  comment : string;
  refusals : refusals_item list;
  errors : errors_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "refusals",
             (fun l -> `List (List.map refusals_item_json l)) r.refusals );
         Option.Some
           ("errors", (fun l -> `List (List.map errors_item_json l)) r.errors);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the words of the dispatcher's own refusals (JOBS.md \
        \194\167 Channels): for each situation it refuses an operation in \
        itself, the operation, the `message` of the CommandError it replies \
        with on the operation's failure channel, and its `code` where it \
        carries one, word for word. A refusal the dispatcher relays carries \
        the relayed words, not these: a vocabulary read's failure (for an \
        Archivist that is not connected, gateway/messages.json's failure \
        `peer-unavailable`), and the store's error. A text's `{name}` is \
        filled as the row's `situation` says. `errors` is each error the \
        dispatcher writes into a job's record on its own, with its failure \
        class.";
     refusals =
       [
         ({
            name = "create-without-user";
            operation = "job:create";
            code = None;
            situation =
              "A `job:create` with no `_userId` (check 1). The gateway stamps \
               `_userId` on every frame it accepts, so only a frame that \
               reached the bus around it is refused so.";
            message = "_userId is required (injected by bus gateway)";
          }
           : refusals_item);
         ({
            name = "entity-type-not-registered";
            operation = "job:create";
            code = None;
            situation =
              "A `mark` linking job, or a `yield` job, naming entity types \
               that are not registered (checks 2 and 5): `{types}` is each \
               that is not, in the order the job names them, joined by `, `.";
            message = "Entity type not registered: {types}";
          }
           : refusals_item);
         ({
            name = "tag-schema-not-registered";
            operation = "job:create";
            code = None;
            situation =
              "A `mark` tagging job whose `schemaId` names no registered tag \
               schema (check 3): `{schemaId}` is the `schemaId`.";
            message = "Tag schema not registered: {schemaId}";
          }
           : refusals_item);
         ({
            name = "yield-parameter";
            operation = "job:create";
            code = None;
            situation =
              "A `yield` job given parameters GenerationJobParams does not \
               name (check 4): `{params}` is each, in the order the job gives \
               them, joined by `, `.";
            message = "a yield job takes no parameter {params}";
          }
           : refusals_item);
         ({
            name = "not-a-worker";
            operation = "job:claim";
            code = Some (Unauthorized : command_error_code);
            situation =
              "A `job:claim` whose `_roles` does not hold the worker role, \
               checked before the queue is consulted.";
            message =
              "job:claim refused: the caller is not a worker for this \
               knowledge base";
          }
           : refusals_item);
         ({
            name = "none-pending";
            operation = "job:claim";
            code = Some (None_pending : command_error_code);
            situation =
              "A `job:claim` from a worker that no pending job matches: a \
               decline, not an error.";
            message = "No pending job matches the claim";
          }
           : refusals_item);
         ({
            name = "claim-without-user";
            operation = "job:claim";
            code = None;
            situation =
              "A `job:claim` from a worker with no `_userId`, checked after \
               the transition, which leaves the job `running`. The gateway \
               stamps `_userId` on every frame it accepts, so only a frame \
               that reached the bus around it is refused so.";
            message = "job:claim missing _userId (gateway injection)";
          }
           : refusals_item);
         ({
            name = "job-not-found";
            operation = "job:status-requested";
            code = None;
            situation =
              "A `job:status-requested` naming a job the queue holds no record \
               of: never created, or deleted by retention.";
            message = "Job not found";
          }
           : refusals_item);
       ];
     errors =
       [
         ({
            name = "presumed-dead";
            situation =
              "The dead-worker sweep's, for a running job with no write for \
               `staleRunningMs`: `{minutes}` is `staleRunningMs` divided by \
               60000, as the shortest decimal that reads back as that number, \
               with no `.0` when it is whole.";
            error =
              "worker presumed dead \226\128\148 no progress within {minutes} \
               minutes";
            failure_class = (Transient : failure_class);
          }
           : errors_item);
       ];
   }
    : t)

(* Generated from protocol/specs/src/worker/messages.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type own_boot_refusal = { name : string; situation : string; refusal : string }

let own_boot_refusal_json (r : own_boot_refusal) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("refusal", (fun s -> `String s) r.refusal);
       ])

type shared_boot_refusal = {
  name : string;
  situation : string;
  boot_refusal : string;
}

let shared_boot_refusal_json (r : shared_boot_refusal) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("bootRefusal", (fun s -> `String s) r.boot_refusal);
       ])

type boot_item =
  | Own_boot_refusal of own_boot_refusal
  | Shared_boot_refusal of shared_boot_refusal

let boot_item_json = function
  | (Own_boot_refusal v : boot_item) -> own_boot_refusal_json v
  | (Shared_boot_refusal v : boot_item) -> shared_boot_refusal_json v

type reasons_item = { name : string; situation : string; line : string }

let reasons_item_json (r : reasons_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("line", (fun s -> `String s) r.line);
       ])

type job = { mark : string; yield : string }

let job_json (r : job) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("mark", (fun s -> `String s) r.mark);
         Option.Some ("yield", (fun s -> `String s) r.yield);
       ])

type errors_item = { name : string; situation : string; error : string }

let errors_item_json (r : errors_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("error", (fun s -> `String s) r.error);
       ])

type details_item = { name : string; situation : string; detail : string }

let details_item_json (r : details_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("detail", (fun s -> `String s) r.detail);
       ])

type waits_item = { name : string; situation : string; said : string }

let waits_item_json (r : waits_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("said", (fun s -> `String s) r.said);
       ])

type log_level = Error | Warn | Info | Http | Debug

let log_level_value = function
  | (Error : log_level) -> "error"
  | (Warn : log_level) -> "warn"
  | (Info : log_level) -> "info"
  | (Http : log_level) -> "http"
  | (Debug : log_level) -> "debug"

let log_level_json v = `String (log_level_value v)

type smelter_messages_logged_item = {
  name : string;
  level : log_level;
  situation : string;
  message : string;
  fields : (string * string) list;
  carries : string list;
}

let smelter_messages_logged_item_json (r : smelter_messages_logged_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("level", log_level_json r.level);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("message", (fun s -> `String s) r.message);
         Option.Some
           ( "fields",
             (fun l ->
               `Assoc (List.map (fun (k, v) -> (k, (fun s -> `String s) v)) l))
               r.fields );
         Option.Some
           ( "carries",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.carries );
       ])

type t = {
  comment : string;
  boot : boot_item list;
  reasons : reasons_item list;
  job : job;
  errors : errors_item list;
  details : details_item list;
  waits : waits_item list;
  logged : smelter_messages_logged_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("boot", (fun l -> `List (List.map boot_item_json l)) r.boot);
         Option.Some
           ("reasons", (fun l -> `List (List.map reasons_item_json l)) r.reasons);
         Option.Some ("job", job_json r.job);
         Option.Some
           ("errors", (fun l -> `List (List.map errors_item_json l)) r.errors);
         Option.Some
           ("details", (fun l -> `List (List.map details_item_json l)) r.details);
         Option.Some
           ("waits", (fun l -> `List (List.map waits_item_json l)) r.waits);
         Option.Some
           ( "logged",
             (fun l -> `List (List.map smelter_messages_logged_item_json l))
               r.logged );
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the words of a Worker service's refusals to start, of \
        the errors it fails a job with, and of the messages it logs that a \
        reader of its output relies on (WORKER-SERVICE.md), word for word. A \
        text's `{name}` is filled as the row's `situation` says, and nothing \
        else in it varies; a hole whose words the situation says vary is some \
        text on one line. `boot` is each refusal to start, written in \
        service-environment/boot-refusals.json's `line`, once, to stderr, \
        before the service exits with that table's `exitCode`: a row that \
        names `bootRefusal` is that table's refusal of that name, its \
        `{service}` `worker` and its `{schema}` `WorkerConfig`; any other row \
        is the worker's own. `reasons` is each line of the `{reasons}` of \
        `invalid`. `job` is how an error names the job, by its type, as \
        `{job}`. `errors` is each error a job is failed with whose words a \
        clause of WORKER-SERVICE.md names; an error no clause names is the \
        implementation's to word; an error that repeats what another said (the \
        record's refusal of a resource or of a commit, the claim's of a job \
        the worker stopped holding) is that one's words, not these. `logged` \
        is each message a Worker service logs, at its `level`, with the facts \
        named in `fields`, each of the form given, and the facts named in \
        `carries` beside them.";
     boot =
       [
         (Shared_boot_refusal
            ({
               name = "unnamed";
               situation =
                 "Started without `--config <path>` or `--config=<path>` \
                  naming a path.";
               boot_refusal = "unnamed";
             }
              : shared_boot_refusal)
           : boot_item);
         (Shared_boot_refusal
            ({
               name = "unreadable";
               situation = "The path names no file the service can read.";
               boot_refusal = "unreadable";
             }
              : shared_boot_refusal)
           : boot_item);
         (Shared_boot_refusal
            ({
               name = "not-json";
               situation = "The file is not JSON.";
               boot_refusal = "not-json";
             }
              : shared_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "invalid";
               situation =
                 "The document is not a WorkerConfig: `{path}` is the path as \
                  it was given, and `{reasons}` one line of `reasons`, for the \
                  first way it is not.";
               refusal =
                 "{path} is not a worker configuration document (WorkerConfig):\n\
                  {reasons}";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "key-unset";
               situation = "`XYNOLOG_OIDC_CLIENT_KEY` is unset or empty.";
               refusal =
                 "XYNOLOG_OIDC_CLIENT_KEY is not set in the worker's \
                  environment: a worker signs in as a service account";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "key-unreadable";
               situation =
                 "`XYNOLOG_OIDC_CLIENT_KEY` is not a PEM private key the \
                  service can read without a passphrase.";
               refusal =
                 "XYNOLOG_OIDC_CLIENT_KEY in the worker's environment is not \
                  an unencrypted PEM private key";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "key-not-rsa";
               situation =
                 "`XYNOLOG_OIDC_CLIENT_KEY` is a private key that is not RSA.";
               refusal =
                 "XYNOLOG_OIDC_CLIENT_KEY in the worker's environment is not \
                  an RSA key: a worker signs its assertions with RS256";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "api-key-unset";
               situation =
                 "An engine names, by its `apiKeyEnv`, a variable that is \
                  unset or empty: `{knowledgeBase}` is the index of its \
                  knowledge base in `knowledgeBases`, and `{engine}` its index \
                  in that one's `engines`, each in decimal digits.";
               refusal =
                 "knowledgeBases[{knowledgeBase}].engines[{engine}].apiKeyEnv \
                  names a variable that is not set in the worker's environment";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "domain-twice";
               situation =
                 "Two of `knowledgeBases` name one `domain`: `{later}` is the \
                  index of the later, and `{earlier}` of the earlier, each in \
                  decimal digits.";
               refusal =
                 "knowledgeBases[{later}].domain is the domain of \
                  knowledgeBases[{earlier}]: a worker serves a knowledge base \
                  once";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "none-admits";
               situation =
                 "Every knowledge base refused the service before any was \
                  confirmed.";
               refusal =
                 "No knowledge base admits this worker: each of its \
                  knowledgeBases refused it";
             }
              : own_boot_refusal)
           : boot_item);
         (Own_boot_refusal
            ({
               name = "cannot-listen";
               situation =
                 "The service cannot listen on its `port`: `{port}` is the \
                  port, in decimal digits, and `{why}` the system's reason, \
                  which varies.";
               refusal = "Cannot listen on port {port}: {why}";
             }
              : own_boot_refusal)
           : boot_item);
       ];
     reasons =
       [
         ({
            name = "missing";
            situation =
              "An object without a member its schema requires: `{member}` is \
               the member's name.";
            line = "  Missing required property: {member}";
          }
           : reasons_item);
         ({
            name = "other";
            situation =
              "Any other way the document is not its schema's: `{member}` is \
               the names on the way from the document to the member, joined by \
               `.`, with no index of an array.";
            line = "  {member}: is not what the schema states";
          }
           : reasons_item);
       ];
     job = ({ mark = "mark ({motivation})"; yield = "yield" } : job);
     errors =
       [
         ({
            name = "unextractable";
            situation =
              "A job on a resource whose media type has no text the worker can \
               read: `{resourceId}` is the resource, and `{mediaType}` its \
               media type.";
            error =
              "Cannot run {job} on resource {resourceId}: media type \
               '{mediaType}' has no extractable text to analyze";
          }
           : errors_item);
         ({
            name = "not-settled";
            situation =
              "A job on a resource whose anchored text the Smelter has not yet \
               settled: `{resourceId}` is the resource.";
            error =
              "Anchored text not yet derived for resource {resourceId} \
               \226\128\148 Smelter has not settled; retrying";
          }
           : errors_item);
         ({
            name = "anchored-declined";
            situation =
              "A job on a resource the anchored-text consult declines: \
               `{resourceId}` is the resource, and `{declined}` what the \
               consult answered, `no-map` or `unknown`.";
            error =
              "Cannot run {job} on resource {resourceId}: anchored-text \
               consult returned '{declined}'";
          }
           : errors_item);
         ({
            name = "not-served";
            situation =
              "A job of a motivation the engine that took it does not serve.";
            error = "Worker not configured for job: {job}";
          }
           : errors_item);
         ({
            name = "no-processor";
            situation = "A tagging job handed over without the schema it names.";
            error = "No processor for job: {job}";
          }
           : errors_item);
         ({
            name = "window-too-small";
            situation =
              "A model whose window leaves a piece 64 tokens or fewer: \
               `{contextTokens}` is the window, `{scaffoldTokens}` the tokens \
               of the prompt without its piece, and `{inputBudget}` what is \
               left, each in decimal digits.";
            error =
              "Inference window too small for detection: context \
               {contextTokens} tokens minus scaffold {scaffoldTokens} leaves \
               an input budget of {inputBudget} (need > 64). Use a model with \
               a larger context window or reduce the prompt scaffold.";
          }
           : errors_item);
         ({
            name = "ollama-refused";
            situation =
              "An Ollama engine's generation refused: `{status}` is the \
               status, and `{body}` the body, as it was sent.";
            error = "Ollama API error ({status}): {body}";
          }
           : errors_item);
         ({
            name = "anthropic-refused";
            situation =
              "An Anthropic engine's request refused: `{said}` is what its \
               client says of the refusal, which varies, and carries the \
               refusal's status and the words of its body's `error.message`.";
            error = "{said}";
          }
           : errors_item);
         ({
            name = "unreadable";
            situation =
              "An answer that cannot be read: `{detail}` is one of `details`, \
               and `{stopReason}` why the model stopped, `end_turn` where an \
               Ollama engine's says `stop`.";
            error =
              "Structured response could not be read: {detail} (stop_reason: \
               {stopReason})";
          }
           : errors_item);
         ({
            name = "wait-stated";
            situation =
              "A refusal whose stated wait is over 120 seconds: `{failure}` is \
               the refusal's error, `anthropic-refused` or \
               `anthropic-limits-refused`, and `{said}` one of `waits`.";
            error =
              "{failure}; the provider said to wait ({said}), which is longer \
               than the 120 seconds this driver waits";
          }
           : errors_item);
         ({
            name = "withheld";
            situation =
              "An answer the provider withheld: `{why}` is ` ({category})` \
               where it states a category and `: {explanation}` where it \
               states an explanation, in that order, each left out where it \
               states none.";
            error = "The provider withheld its answer: refusal{why}";
          }
           : errors_item);
         ({
            name = "no-structured-outputs";
            situation =
              "A mark job on an Anthropic model the Models API does not report \
               strict structured outputs for: `{model}` is the model.";
            error =
              "Model '{model}' does not report support for strict structured \
               outputs (Models API capabilities.structured_outputs). It is \
               refused: a generation the provider does not hold to the schema \
               can come back unreadable. Give the agent that does this work a \
               model that reports supported: true.";
          }
           : errors_item);
         ({
            name = "ollama-limits-refused";
            situation =
              "`/api/show` refused: `{model}` is the model, `{status}` the \
               status, and `{said}` the body, as it was sent.";
            error =
              "Failed to discover model limits for '{model}' from Ollama's \
               /api/show: refused with status {status}: {said}";
          }
           : errors_item);
         ({
            name = "anthropic-limits-refused";
            situation =
              "The Models API refused: `{model}` is the model, `{status}` the \
               status, and `{said}` what `anthropic-refused` says of the \
               refusal.";
            error =
              "Failed to discover model limits for '{model}' from the Models \
               API: refused with status {status}: {said}";
          }
           : errors_item);
         ({
            name = "no-context-length";
            situation =
              "`/api/show` answered with no context length: `{model}` is the \
               model.";
            error = "/api/show reports no context length for '{model}'";
          }
           : errors_item);
         ({
            name = "unsupported-output";
            situation =
              "A yield job for a media type the worker does not generate: \
               `{mediaType}` is the job's `outputMediaType`, and \
               `{generatable}` each media type media-types/registry.json says \
               is generatable, in its order, joined by ` or `.";
            error =
              "Unsupported outputMediaType for generation: {mediaType}. \
               Generation produces {generatable}.";
          }
           : errors_item);
         ({
            name = "over-window";
            situation =
              "A yield job whose prompt and length are together over its \
               model's window: `{promptTokens}` is the tokens of the prompt, \
               `{maxTokens}` the job's `maxTokens`, `{model}` the model, and \
               `{contextTokens}` its window, each number in decimal digits.";
            error =
              "The prompt (~{promptTokens} tokens) and the {maxTokens} tokens \
               asked for are together over the context window of '{model}' \
               ({contextTokens} tokens)";
          }
           : errors_item);
       ];
     details =
       [
         ({
            name = "not-json";
            situation = "An answer that is not JSON.";
            detail = "response is not valid JSON";
          }
           : details_item);
         ({
            name = "not-array";
            situation =
              "An answer that is JSON and not an array: `{kind}` is what it \
               is, `object`, `string`, `number`, `boolean` or `null`.";
            detail = "parsed to {kind}, not an array";
          }
           : details_item);
         ({
            name = "empty";
            situation = "An answer with no text.";
            detail = "response is empty";
          }
           : details_item);
       ];
     waits =
       [
         ({
            name = "seconds";
            situation = "A `retry-after` of `{seconds}`, as it was sent.";
            said = "retry-after: {seconds}";
          }
           : waits_item);
         ({
            name = "milliseconds";
            situation =
              "A `retry-after-ms` of `{milliseconds}`, as it was sent.";
            said = "retry-after-ms: {milliseconds}";
          }
           : waits_item);
       ];
     logged =
       [
         ({
            name = "confirmed";
            level = (Info : log_level);
            situation =
              "A knowledge base confirmed: `{domain}` is its domain, and \
               `{did}` the DID it names the worker by.";
            message = "Knowledge base confirmed";
            fields = [ ("domain", "{domain}"); ("did", "{did}") ];
            carries = [];
          }
           : smelter_messages_logged_item);
         ({
            name = "refused";
            level = (Error : log_level);
            situation =
              "A knowledge base that refused the worker: `{domain}` is its \
               domain. `reason` says why.";
            message = "Knowledge base refused the worker";
            fields = [ ("domain", "{domain}") ];
            carries = [ "reason" ];
          }
           : smelter_messages_logged_item);
         ({
            name = "trouble";
            level = (Warn : log_level);
            situation =
              "A knowledge base in trouble, which the worker starts again: \
               `{domain}` is its domain. `error` says what the trouble was, \
               and `waitMs` how long it waits, in milliseconds.";
            message = "Knowledge base in trouble \226\128\148 starting it again";
            fields = [ ("domain", "{domain}") ];
            carries = [ "error"; "waitMs" ];
          }
           : smelter_messages_logged_item);
       ];
   }
    : t)

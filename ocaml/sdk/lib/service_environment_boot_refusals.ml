(* Generated from protocol/specs/src/service-environment/boot-refusals.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type service_telemetry_telemetry_services_item =
  | Archivist
  | Dispatcher
  | Gateway
  | Librarian
  | Smelter
  | Weaver
  | Worker

let service_telemetry_telemetry_services_item_value = function
  | (Archivist : service_telemetry_telemetry_services_item) -> "archivist"
  | (Dispatcher : service_telemetry_telemetry_services_item) -> "dispatcher"
  | (Gateway : service_telemetry_telemetry_services_item) -> "gateway"
  | (Librarian : service_telemetry_telemetry_services_item) -> "librarian"
  | (Smelter : service_telemetry_telemetry_services_item) -> "smelter"
  | (Weaver : service_telemetry_telemetry_services_item) -> "weaver"
  | (Worker : service_telemetry_telemetry_services_item) -> "worker"

let service_telemetry_telemetry_services_item_json v =
  `String (service_telemetry_telemetry_services_item_value v)

type refusals_item = { name : string; situation : string; refusal : string }

let refusals_item_json (r : refusals_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("refusal", (fun s -> `String s) r.refusal);
       ])

type members_item = { name : string; situation : string; line : string }

let members_item_json (r : members_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("situation", (fun s -> `String s) r.situation);
         Option.Some ("line", (fun s -> `String s) r.line);
       ])

type t = {
  comment : string;
  services : service_telemetry_telemetry_services_item list;
  line : string;
  exit_code : int;
  refusals : refusals_item list;
  members : members_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "services",
             (fun l ->
               `List (List.map service_telemetry_telemetry_services_item_json l))
               r.services );
         Option.Some ("line", (fun s -> `String s) r.line);
         Option.Some ("exitCode", (fun n -> `Int n) r.exit_code);
         Option.Some
           ( "refusals",
             (fun l -> `List (List.map refusals_item_json l)) r.refusals );
         Option.Some
           ("members", (fun l -> `List (List.map members_item_json l)) r.members);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for what a service that reads a configuration document \
        writes when it will not start on that document or on its environment: \
        `line`, once, to stderr, with the refusal in place of `{refusal}`, and \
        then it exits with `exitCode` without ever serving. `services` is each \
        service that refuses so; each refusal is one of `refusals`, word for \
        word, with each `{name}` filled as the row's `situation` says and \
        nothing else varying. `{service}` is the service's name, as `services` \
        writes it, and `{schema}` its document's schema: `GatewayConfig`, \
        `ArchivistConfig` or `DispatcherConfig`. The refusals are checked in \
        the order they are listed, and the first that fails is the one \
        written. A refusal never carries a value of the document or of the \
        environment: it names members and variables.";
     services =
       [
         (Gateway : service_telemetry_telemetry_services_item);
         (Archivist : service_telemetry_telemetry_services_item);
         (Dispatcher : service_telemetry_telemetry_services_item);
       ];
     line = "[fatal] {refusal}";
     exit_code = 1;
     refusals =
       [
         ({
            name = "unnamed";
            situation =
              "Started without `--config <path>` or `--config=<path>` naming a \
               path.";
            refusal =
              "The {service}'s configuration document is not named: start it \
               with --config <path>";
          }
           : refusals_item);
         ({
            name = "unreadable";
            situation =
              "The path names no file the service can read: `{path}` is the \
               path as it was given, and `{reason}` the system's reason, which \
               varies.";
            refusal =
              "Cannot read the {service}'s configuration document at {path} \
               ({reason}). The launcher writes it; a {service} started another \
               way is given one ({schema} in protocol/specs/).";
          }
           : refusals_item);
         ({
            name = "not-json";
            situation =
              "The file is not JSON: `{path}` is the path as it was given, and \
               `{reason}` the parser's reason, which varies.";
            refusal = "{path} is not JSON: {reason}";
          }
           : refusals_item);
         ({
            name = "invalid";
            situation =
              "The document is not its schema's: `{path}` is the path as it \
               was given, and `{members}` is one line of `members` for each \
               way it is not, each on a line of its own.";
            refusal =
              "{path} is not a {service} configuration document ({schema}):\n\
               {members}";
          }
           : refusals_item);
         ({
            name = "no-service-account";
            situation =
              "`XYNOLOG_OIDC_CLIENT_ID` or `XYNOLOG_OIDC_CLIENT_SECRET` is \
               unset or empty: `{missing}` is each that is, in that order, \
               joined by ` and `.";
            refusal =
              "{missing} not set \226\128\148 this {service} has no service \
               account to sign in with.\n\
               The launcher passes both for each service it starts; a \
               {service} started another way needs the client its realm \
               registers for it (XYNOLOG_OIDC_CLIENT_ID=xynolog-{service}).";
          }
           : refusals_item);
         ({
            name = "unset";
            situation =
              "A member of the document names an environment variable that is \
               unset or empty: `{field}` is the member's JSON pointer, and \
               `{name}` the variable.";
            refusal =
              "{field} names the environment variable {name}, which is not set";
          }
           : refusals_item);
       ];
     members =
       [
         ({
            name = "missing";
            situation =
              "An object without a member its schema requires: `{pointer}` is \
               the object's JSON pointer, `/` for the document itself, and \
               `{member}` the member.";
            line = "  {pointer} is missing {member}";
          }
           : members_item);
         ({
            name = "undeclared";
            situation =
              "An object with members its schema does not declare: `{pointer}` \
               is the object's JSON pointer, `/` for the document itself, and \
               `{members}` the members, joined by `, `.";
            line = "  {pointer} does not declare {members}";
          }
           : members_item);
         ({
            name = "other";
            situation =
              "Any other way a member is not its schema's: `{pointer}` is the \
               member's JSON pointer, and `{why}` the validator's words, which \
               vary and never carry the member's value.";
            line = "  {pointer} {why}";
          }
           : members_item);
       ];
   }
    : t)

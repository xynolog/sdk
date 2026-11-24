(* Generated from protocol/specs/src/service-telemetry/log-lines.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type services_item = Archivist | Dispatcher | Gateway

let services_item_value = function
  | (Archivist : services_item) -> "archivist"
  | (Dispatcher : services_item) -> "dispatcher"
  | (Gateway : services_item) -> "gateway"

let services_item_json v = `String (services_item_value v)

type json = {
  first : string list;
  request_id : string;
  trace : string list;
  last : string;
}

let json_json (r : json) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ("first", (fun l -> `List (List.map (fun s -> `String s) l)) r.first);
         Option.Some ("requestId", (fun s -> `String s) r.request_id);
         Option.Some
           ("trace", (fun l -> `List (List.map (fun s -> `String s) l)) r.trace);
         Option.Some ("last", (fun s -> `String s) r.last);
       ])

type logger = { services : services_item list; json : json; simple : string }

let logger_json (r : logger) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some
           ( "services",
             (fun l -> `List (List.map services_item_json l)) r.services );
         Option.Some ("json", json_json r.json);
         Option.Some ("simple", (fun s -> `String s) r.simple);
       ])

type parts_item = { part : string; text : string; characters : int option }

let parts_item_json (r : parts_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("part", (fun s -> `String s) r.part);
         Option.Some ("text", (fun s -> `String s) r.text);
         Option.map (fun v -> ("characters", (fun n -> `Int n) v)) r.characters;
       ])

type bus = { line : string; parts : parts_item list; ops : string list }

let bus_json (r : bus) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("line", (fun s -> `String s) r.line);
         Option.Some
           ("parts", (fun l -> `List (List.map parts_item_json l)) r.parts);
         Option.Some
           ("ops", (fun l -> `List (List.map (fun s -> `String s) l)) r.ops);
       ])

type supervisor = { line : string; counted : string }

let supervisor_json (r : supervisor) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("line", (fun s -> `String s) r.line);
         Option.Some ("counted", (fun s -> `String s) r.counted);
       ])

type t = {
  comment : string;
  logger : logger;
  bus : bus;
  supervisor : supervisor;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some ("logger", logger_json r.logger);
         Option.Some ("bus", bus_json r.bus);
         Option.Some ("supervisor", supervisor_json r.supervisor);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the lines a service writes to its log, and for the \
        supervisor's line it reads. THE LOGGER of a service whose document \
        names a LogFormat writes one line to stdout for each thing it logs at \
        or above its LogLevel. A `json` line is one JSON object: its `first` \
        members, the level's name in lower case and the message; then the \
        fields the line was logged with; then `requestId`, the request's id \
        (gateway/response-headers.json's `requestId`), on a line logged while \
        a request was answered; then the active trace's id and span's id in \
        lower-case hex, 32 and 16 digits, on a line logged inside one; and \
        `last`, the moment in UTC as RFC 3339 with milliseconds. A `simple` \
        line is `simple`, with `{timestamp}` the moment in UTC as `YYYY-MM-DD \
        hh:mm:ss`, `{LEVEL}` the level's name in upper case, and then, when \
        the line has any fields, a space and the JSON object of them, \
        `requestId` and the trace's among them. THE BUS LOG (EVENT-BUS.md \
        \194\167 Wire format: the bus log), switched on by XYNOLOG_BUS_LOG, \
        writes one line for each frame its process sends or receives: `line`, \
        with `{op}` one of `ops` and `{channel}` the frame's channel, or \
        `content` for an upload or a read of bytes; then each of `parts` there \
        is one of, with the first `characters` of it; then a space and the \
        payload, as bus/log-cases.json says it is shown. THE SUPERVISOR writes \
        `line` each time it starts the service, with `{time}` the moment in \
        UTC as `YYYY-MM-DDThh:mm:ssZ`, `{name}` SUPERVISE_NAME and `{count}` \
        the rapid failures so far, to the file SUPERVISE_EVENTS names; a \
        service counts each line of that file that holds `counted` as one of \
        its lives.";
     logger =
       ({
          services =
            [
              (Archivist : services_item);
              (Dispatcher : services_item);
              (Gateway : services_item);
            ];
          json =
            ({
               first = [ "level"; "message" ];
               request_id = "requestId";
               trace = [ "trace_id"; "span_id" ];
               last = "timestamp";
             }
              : json);
          simple = "{timestamp} [{LEVEL}] {message}";
        }
         : logger);
     bus =
       ({
          line = "[bus {op}] {channel}";
          parts =
            [
              ({
                 part = "the frame's scope";
                 text = " scope={scope}";
                 characters = None;
               }
                : parts_item);
              ({
                 part = "the frame's correlationId";
                 text = " cid={correlationId}";
                 characters = Some 8;
               }
                : parts_item);
              ({
                 part = "the active trace's id";
                 text = " trace={traceId}";
                 characters = Some 8;
               }
                : parts_item);
            ];
          ops = [ "EMIT"; "RECV"; "SSE"; "PUT"; "GET" ];
        }
         : bus);
     supervisor =
       ({
          line =
            "[supervise {time}] starting {name} (rapid failures so far: \
             {count})";
          counted = "starting {name}";
        }
         : supervisor);
   }
    : t)

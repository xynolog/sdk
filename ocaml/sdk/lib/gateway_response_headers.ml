(* Generated from protocol/specs/src/gateway/response-headers.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type every_item = { name : string; value : string }

let every_item_json (r : every_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("value", (fun s -> `String s) r.value);
       ])

type headers_item = { name : string; value : string }

let headers_item_json (r : headers_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("value", (fun s -> `String s) r.value);
       ])

type echoes_item = { name : string; of_ : string }

let echoes_item_json (r : echoes_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("of", (fun s -> `String s) r.of_);
       ])

type preflight = {
  status : int;
  headers : headers_item list;
  echoes : echoes_item list;
  vary : string;
}

let preflight_json (r : preflight) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("status", (fun n -> `Int n) r.status);
         Option.Some
           ("headers", (fun l -> `List (List.map headers_item_json l)) r.headers);
         Option.Some
           ("echoes", (fun l -> `List (List.map echoes_item_json l)) r.echoes);
         Option.Some ("vary", (fun s -> `String s) r.vary);
       ])

type t = {
  comment : string;
  every : every_item list;
  request_id : string;
  absent : string list;
  preflight : preflight;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("every", (fun l -> `List (List.map every_item_json l)) r.every);
         Option.Some ("requestId", (fun s -> `String s) r.request_id);
         Option.Some
           ( "absent",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.absent );
         Option.Some ("preflight", preflight_json r.preflight);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the headers the gateway puts on every response it sends \
        (TRANSPORT-HTTP.md \194\167 Every response): on every route, whatever \
        its status, a success, an error, bytes and a stream alike. `every` is \
        each header every response carries, with its value, exactly: the \
        security headers, and CORS that is open to every origin. `requestId` \
        is the header that names the request: a new UUID for each request, in \
        lower case with hyphens, which each line the gateway logs while it \
        answers the request carries as its `requestId` \
        (service-telemetry/log-lines.json). `absent` is each header no \
        response carries: the API is bearer-only, so no origin can ride a \
        browser's ambient credentials. `preflight` is how the gateway answers \
        an `OPTIONS` request, before it routes it and whatever its path: with \
        its `status` and no body, every header of `every` and `requestId`, \
        each of its `headers`, and, when the request carries the header an \
        `echoes` entry names, that entry's header with the request header's \
        value, and then a `Vary` of `vary`.";
     every =
       [
         ({ name = "Access-Control-Allow-Origin"; value = "*" } : every_item);
         ({ name = "X-Frame-Options"; value = "DENY" } : every_item);
         ({ name = "X-Content-Type-Options"; value = "nosniff" } : every_item);
         ({
            name = "Strict-Transport-Security";
            value = "max-age=31536000; includeSubDomains";
          }
           : every_item);
         ({
            name = "Content-Security-Policy";
            value =
              "default-src 'none'; frame-ancestors 'none'; base-uri 'none'; \
               form-action 'none'";
          }
           : every_item);
         ({ name = "X-XSS-Protection"; value = "1; mode=block" } : every_item);
         ({ name = "Referrer-Policy"; value = "no-referrer" } : every_item);
         ({
            name = "Permissions-Policy";
            value =
              "camera=(), geolocation=(), microphone=(), payment=(), usb=(), \
               interest-cohort=()";
          }
           : every_item);
       ];
     request_id = "X-Request-ID";
     absent = [ "Access-Control-Allow-Credentials" ];
     preflight =
       ({
          status = 204;
          headers =
            [
              ({
                 name = "Access-Control-Allow-Methods";
                 value = "GET,HEAD,PUT,POST,DELETE,PATCH";
               }
                : headers_item);
            ];
          echoes =
            [
              ({
                 name = "Access-Control-Allow-Headers";
                 of_ = "Access-Control-Request-Headers";
               }
                : echoes_item);
            ];
          vary = "Access-Control-Request-Headers";
        }
         : preflight);
   }
    : t)

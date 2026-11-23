(* Generated from protocol/specs/src/session/gateway-url-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  endpoint : Yojson.Safe.t;
  origin : string option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("endpoint", Fun.id r.endpoint);
         Option.Some
           ( "origin",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.origin );
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
       "The origin of a knowledge base's gateway, made from its HTTP endpoint, \
        as every SDK must make it: what a session sends its requests to and \
        opens its stream at. Every SDK runs every case against what it makes \
        the origin with, and fails on a difference. A host is a host's name or \
        it is refused, and a refused host is never put into a URL: a host's \
        name is labels of ASCII letters, digits and hyphens with a dot between \
        each two, every label 1 to 63 characters long and none beginning or \
        ending with a hyphen. A dotted address and `localhost` are such names; \
        a host with a slash, a colon, a space, a query, a bracket or a letter \
        outside ASCII is not. The origin is the protocol, `://`, the host in \
        lowercase and nothing else done to it, `:` and the port, written even \
        when it is the protocol's own. READING A CASE. `endpoint` is an \
        HttpEndpoint (components/schemas/HttpEndpoint.json), and `origin` the \
        gateway's origin, or null when the host is refused.";
     cases =
       [
         ({
            why = "this machine, over HTTP";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "localhost");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = Some "http://localhost:4000";
          }
           : cases_item);
         ({
            why =
              "a host's name is put in lowercase, and the port is written even \
               when it is the protocol's own";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "KB.Example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            origin = Some "https://kb.example.org:443";
          }
           : cases_item);
         ({
            why = "a dotted address is a host's name, kept as it is written";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "127.0.0.1");
                  ("port", `Int 8080);
                  ("protocol", `String "http");
                ];
            origin = Some "http://127.0.0.1:8080";
          }
           : cases_item);
         ({
            why =
              "a host of digits alone is a name like any other: it is kept as \
               it is written, not read as an address";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "10");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = Some "http://10:4000";
          }
           : cases_item);
         ({
            why = "a hyphen inside a label is a name's";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "a-b.c");
                  ("port", `Int 4000);
                  ("protocol", `String "https");
                ];
            origin = Some "https://a-b.c:4000";
          }
           : cases_item);
         ({
            why = "a label of 63 characters is a label";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ( "host",
                    `String
                      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.org"
                  );
                  ("port", `Int 4000);
                  ("protocol", `String "https");
                ];
            origin =
              Some
                "https://aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.org:4000";
          }
           : cases_item);
         ({
            why = "an empty host is no name";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a path is no part of a host";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org/path");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a port is no part of a host";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb:4000");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a query is no part of a host";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb?x=1");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a label does not begin with a hyphen";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "-kb.org");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a label does not end with a hyphen";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb-.org");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a label is not empty, between two dots";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb..org");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a label is not empty, after a last dot";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.org.");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a space is no part of a name";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "a b");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a label of 64 characters is too long";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ( "host",
                    `String
                      "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
                  );
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "a letter outside ASCII is no part of a name";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "\195\188ber.example.org");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
         ({
            why = "an address in brackets is no name";
            endpoint =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "[::1]");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            origin = None;
          }
           : cases_item);
       ];
   }
    : t)

(* Generated from protocol/specs/src/session/registry-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  one : Yojson.Safe.t;
  other : Yojson.Safe.t;
  same_place : bool;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("one", Fun.id r.one);
         Option.Some ("other", Fun.id r.other);
         Option.Some ("samePlace", (fun b -> `Bool b) r.same_place);
       ])

type open_resource_order_item = {
  why : string;
  open_ : Yojson.Safe.t list;
  shown : string list;
}

let open_resource_order_item_json (r : open_resource_order_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("open", (fun l -> `List (List.map Fun.id l)) r.open_);
         Option.Some
           ("shown", (fun l -> `List (List.map (fun s -> `String s) l)) r.shown);
       ])

type t = {
  comment : string;
  cases : cases_item list;
  open_resource_order : open_resource_order_item list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("cases", (fun l -> `List (List.map cases_item_json l)) r.cases);
         Option.Some
           ( "openResourceOrder",
             (fun l -> `List (List.map open_resource_order_item_json l))
               r.open_resource_order );
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for when a registry of knowledge bases takes two endpoints \
        for one place: the rule its sign-in looks up the entries at an address \
        by, before the did the knowledge base reports decides which of them is \
        signed in; and for the order a registry shows the resources open in a \
        knowledge base in. Every SDK runs every case of both tables against \
        its registry's own rule, and fails on a difference. A gateway is one \
        place with another when the two have one origin, as \
        specs/src/session/gateway-url-cases.json makes it: the same protocol, \
        the same host once each is put in lowercase, and the same port. An \
        entry at another origin is another place, though only the protocol \
        differs: the session would talk to the entry's address, which the \
        sign-in's read never proved. A knowledge base the host process has \
        loaded is the place its id names. A gateway and a loaded knowledge \
        base are never one place. READING A CASE. In `cases`, `one` and \
        `other` are each a KbEndpoint (components/schemas/KbEndpoint.json), \
        and `samePlace` whether a registry takes them for one place. In \
        `openResourceOrder`, `open` is a list of open resources as a registry \
        keeps them (specs/src/session/stored.json's `openResource`), and \
        `shown` the ids of the same resources in the order a registry shows \
        them: by place, and two in one place by when each was opened, first \
        first.";
     cases =
       [
         ({
            why = "the same protocol, host and port is one place";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            other =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            same_place = true;
          }
           : cases_item);
         ({
            why =
              "another protocol is another place, though the host and the port \
               are the same";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            other =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 4000);
                  ("protocol", `String "https");
                ];
            same_place = false;
          }
           : cases_item);
         ({
            why = "another host is another place";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            other =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.net");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            same_place = false;
          }
           : cases_item);
         ({
            why = "another port is another place";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "localhost");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            other =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "localhost");
                  ("port", `Int 4001);
                  ("protocol", `String "http");
                ];
            same_place = false;
          }
           : cases_item);
         ({
            why =
              "a host written in other letter case is the same host: the \
               origin puts it in lowercase";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "KB.Example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            other =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "kb.example.org");
                  ("port", `Int 443);
                  ("protocol", `String "https");
                ];
            same_place = true;
          }
           : cases_item);
         ({
            why = "a loaded knowledge base is the place its id names";
            one = `Assoc [ ("kind", `String "local"); ("kbId", `String "kb-a") ];
            other =
              `Assoc [ ("kind", `String "local"); ("kbId", `String "kb-a") ];
            same_place = true;
          }
           : cases_item);
         ({
            why = "another loaded knowledge base is another place";
            one = `Assoc [ ("kind", `String "local"); ("kbId", `String "kb-a") ];
            other =
              `Assoc [ ("kind", `String "local"); ("kbId", `String "kb-b") ];
            same_place = false;
          }
           : cases_item);
         ({
            why = "a gateway and a loaded knowledge base are never one place";
            one =
              `Assoc
                [
                  ("kind", `String "http");
                  ("host", `String "localhost");
                  ("port", `Int 4000);
                  ("protocol", `String "http");
                ];
            other =
              `Assoc
                [ ("kind", `String "local"); ("kbId", `String "localhost") ];
            same_place = false;
          }
           : cases_item);
       ];
     open_resource_order =
       [
         ({
            why =
              "the place each has decides, though they were opened the other \
               way round";
            open_ =
              [
                `Assoc
                  [
                    ("id", `String "opened-first");
                    ("name", `String "Opened first");
                    ("openedAt", `Int 1000);
                    ("order", `Int 1);
                  ];
                `Assoc
                  [
                    ("id", `String "opened-second");
                    ("name", `String "Opened second");
                    ("openedAt", `Int 2000);
                    ("order", `Int 0);
                  ];
              ];
            shown = [ "opened-second"; "opened-first" ];
          }
           : open_resource_order_item);
         ({
            why =
              "two in one place are shown by when each was opened, first first";
            open_ =
              [
                `Assoc
                  [
                    ("id", `String "opened-second");
                    ("name", `String "Opened second");
                    ("openedAt", `Int 2000);
                    ("order", `Int 0);
                  ];
                `Assoc
                  [
                    ("id", `String "opened-first");
                    ("name", `String "Opened first");
                    ("openedAt", `Int 1000);
                    ("order", `Int 0);
                  ];
              ];
            shown = [ "opened-first"; "opened-second" ];
          }
           : open_resource_order_item);
         ({
            why =
              "places decide first and open times only within a place, \
               whatever the order kept";
            open_ =
              [
                `Assoc
                  [
                    ("id", `String "c");
                    ("name", `String "C");
                    ("openedAt", `Int 3000);
                    ("order", `Int 2);
                    ("mediaType", `String "text/plain");
                  ];
                `Assoc
                  [
                    ("id", `String "b");
                    ("name", `String "B");
                    ("openedAt", `Int 5000);
                    ("order", `Int 0);
                    ("storageUri", `String "file://docs/b.md");
                  ];
                `Assoc
                  [
                    ("id", `String "a");
                    ("name", `String "A");
                    ("openedAt", `Int 4000);
                    ("order", `Int 0);
                  ];
                `Assoc
                  [
                    ("id", `String "d");
                    ("name", `String "D");
                    ("openedAt", `Int 1000);
                    ("order", `Int 2);
                  ];
              ];
            shown = [ "a"; "b"; "d"; "c" ];
          }
           : open_resource_order_item);
       ];
   }
    : t)

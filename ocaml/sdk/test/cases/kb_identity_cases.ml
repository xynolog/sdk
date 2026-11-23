(* Generated from protocol/specs/src/kb-identity/cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type cases_item = {
  why : string;
  dir : string;
  config : string option;
  refused : bool;
  name : string option;
  domain : string option;
  did : string option;
  resource : string option;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("dir", (fun s -> `String s) r.dir);
         Option.Some
           ( "config",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.config );
         Option.Some ("refused", (fun b -> `Bool b) r.refused);
         Option.Some
           ( "name",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.name );
         Option.Some
           ( "domain",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.domain );
         Option.Some
           ( "did",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.did );
         Option.Some
           ( "resource",
             (function
               | Option.None -> `Null | Option.Some v -> (fun s -> `String s) v)
               r.resource );
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
       "The knowledge base's identity as every reader must compute it from \
        <dir>/.xynolog/config.yaml, the project file ProjectConfig.json holds. \
        Every reader of the file runs every case against the name, domain, DID \
        and resource it reads, and fails on any difference; every SDK runs \
        each case that has a domain against its derivation of the DID and of \
        the resource from it, the resource being the audience the gateway's \
        tokens must carry. `config` null means the file is absent; `refused` \
        true means the file does not hold to ProjectConfig.json, and every \
        reader of it refuses it; `name` null means a refused file names \
        nothing; `domain`, `did` and `resource` null mean no identity is \
        declared. Add a case here before changing any reader.";
     cases =
       [
         ({
            why = "the shape xynolog init writes";
            dir = "arxiv-kb";
            config =
              Some
                "project:\n\
                \  name: \"ArXiv Research Papers\"\n\n\
                 git:\n\
                \  sync: true\n\n\
                 site:\n\
                \  # Permanent did:web identity for everything this KB mints.\n\
                \  domain: \"example.org:test-kb\"\n\
                \  siteName: \"ArXiv Research Papers\"\n";
            refused = false;
            name = Some "ArXiv Research Papers";
            domain = Some "example.org:test-kb";
            did = Some "did:web:example.org:test-kb";
            resource = Some "https://example.org/test-kb";
          }
           : cases_item);
         ({
            why = "no project file: the directory name, and no identity";
            dir = "bare-kb";
            config = None;
            refused = false;
            name = Some "bare-kb";
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why = "plain scalars, and a version, which names nothing";
            dir = "plain-kb";
            config =
              Some
                "project:\n\
                \  name: Plain\n\
                \  version: 0.1.0\n\
                 git:\n\
                \  sync: false\n\
                 site:\n\
                \  domain: example.github.io:plain-kb\n\
                \  siteName: Plain\n";
            refused = false;
            name = Some "Plain";
            domain = Some "example.github.io:plain-kb";
            did = Some "did:web:example.github.io:plain-kb";
            resource = Some "https://example.github.io/plain-kb";
          }
           : cases_item);
         ({
            why = "a comment is not part of the value";
            dir = "comment-kb";
            config =
              Some
                "project:\n\
                \  name: Commented # a note\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domain: example.github.io:comment-kb # permanent\n\
                \  siteName: Commented\n";
            refused = false;
            name = Some "Commented";
            domain = Some "example.github.io:comment-kb";
            did = Some "did:web:example.github.io:comment-kb";
            resource = Some "https://example.github.io/comment-kb";
          }
           : cases_item);
         ({
            why = "escapes in a double-quoted value are decoded";
            dir = "escape-kb";
            config =
              Some
                "project:\n\
                \  name: \"A \\\"quoted\\\" KB\"\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domain: example.github.io:escape-kb\n\
                \  siteName: Quoted\n";
            refused = false;
            name = Some "A \"quoted\" KB";
            domain = Some "example.github.io:escape-kb";
            did = Some "did:web:example.github.io:escape-kb";
            resource = Some "https://example.github.io/escape-kb";
          }
           : cases_item);
         ({
            why = "a flow mapping is the same mapping";
            dir = "flow-kb";
            config =
              Some
                "project: { name: Flow }\n\
                 git: { sync: true }\n\
                 site: { domain: \"example.github.io:flow-kb\", siteName: Flow }\n";
            refused = false;
            name = Some "Flow";
            domain = Some "example.github.io:flow-kb";
            did = Some "did:web:example.github.io:flow-kb";
            resource = Some "https://example.github.io/flow-kb";
          }
           : cases_item);
         ({
            why = "a multi-segment domain becomes a multi-segment path";
            dir = "deep-kb";
            config =
              Some
                "project:\n\
                \  name: Deep\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domain: example.org:group:deep-kb\n\
                \  siteName: Deep\n";
            refused = false;
            name = Some "Deep";
            domain = Some "example.org:group:deep-kb";
            did = Some "did:web:example.org:group:deep-kb";
            resource = Some "https://example.org/group/deep-kb";
          }
           : cases_item);
         ({
            why = "a site without a domain is refused";
            dir = "nodomain-kb";
            config =
              Some
                "project:\n\
                \  name: No Domain\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  siteName: No Domain\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why =
              "a domain with white space in it is refused: no DID holds it, \
               and it would be stamped into every event the knowledge base \
               records";
            dir = "spaced-domain-kb";
            config =
              Some
                "project:\n\
                \  name: Spaced\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domain: \"example.github.io:spaced kb\"\n\
                \  siteName: Spaced\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why = "an empty name is refused";
            dir = "empty-name-kb";
            config =
              Some
                "project:\n\
                \  name: \"\"\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domain: example.github.io:empty-name-kb\n\
                \  siteName: Empty\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why = "a sync written as text is refused";
            dir = "text-sync-kb";
            config =
              Some
                "project:\n\
                \  name: Text Sync\n\
                 git:\n\
                \  sync: \"yes\"\n\
                 site:\n\
                \  domain: example.github.io:text-sync-kb\n\
                \  siteName: Text Sync\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why = "a key the schema does not name is refused";
            dir = "misspelled-kb";
            config =
              Some
                "project:\n\
                \  name: Misspelled\n\
                 git:\n\
                \  sync: true\n\
                 site:\n\
                \  domian: example.github.io:misspelled-kb\n\
                \  siteName: Misspelled\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
         ({
            why = "a file that is not YAML is refused";
            dir = "broken-kb";
            config = Some "project: [\n";
            refused = true;
            name = None;
            domain = None;
            did = None;
            resource = None;
          }
           : cases_item);
       ];
   }
    : t)

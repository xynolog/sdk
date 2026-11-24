(* Generated from protocol/specs/src/worker/answer-formats.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type formats_item = { name : string; about : string; element : Yojson.Safe.t }

let formats_item_json (r : formats_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some ("about", (fun s -> `String s) r.about);
         Option.Some ("element", Fun.id r.element);
       ])

type t = { comment : string; formats : formats_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ("formats", (fun l -> `List (List.map formats_item_json l)) r.formats);
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for what a Worker service asks a model to answer in \
        (WORKER-SERVICE.md \194\167 The request, \194\167 The five kinds of \
        mark job): the JSON Schema of one element of the array a detection \
        asks for. `formats` has one row for each motivation a `mark` job takes \
        (MarkJobParams), named by it, and `count`, the count a linking job \
        asks of each piece beside its extraction. A request asks for an array \
        of `element`: on an Ollama engine as `format`, `{\"type\": \"array\", \
        \"items\": <element>}` (D1), and on an Anthropic one as \
        `output_config`, `{\"format\": {\"type\": \"json_schema\", \"schema\": \
        {\"type\": \"array\", \"items\": <element>}}}` (D20), the element \
        written as it is here, member for member. A generation (a `yield` job) \
        asks for no format: its answer is the document.";
     formats =
       [
         ({
            name = "highlighting";
            about =
              "A highlight: the passage, and up to 64 characters before and \
               after it (K1).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc
                      [
                        ("exact", `Assoc [ ("type", `String "string") ]);
                        ("prefix", `Assoc [ ("type", `String "string") ]);
                        ("suffix", `Assoc [ ("type", `String "string") ]);
                      ] );
                  ("required", `List [ `String "exact" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
         ({
            name = "commenting";
            about =
              "A comment: the passage, the comment, and what stands before and \
               after (K2).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc
                      [
                        ("exact", `Assoc [ ("type", `String "string") ]);
                        ("comment", `Assoc [ ("type", `String "string") ]);
                        ("prefix", `Assoc [ ("type", `String "string") ]);
                        ("suffix", `Assoc [ ("type", `String "string") ]);
                      ] );
                  ("required", `List [ `String "exact"; `String "comment" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
         ({
            name = "assessing";
            about =
              "An assessment: the passage, the assessment, and what stands \
               before and after (K3).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc
                      [
                        ("exact", `Assoc [ ("type", `String "string") ]);
                        ("assessment", `Assoc [ ("type", `String "string") ]);
                        ("prefix", `Assoc [ ("type", `String "string") ]);
                        ("suffix", `Assoc [ ("type", `String "string") ]);
                      ] );
                  ("required", `List [ `String "exact"; `String "assessment" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
         ({
            name = "linking";
            about =
              "A mention: the passage, the entity type it is a mention of, and \
               what stands before and after (K4).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc
                      [
                        ("exact", `Assoc [ ("type", `String "string") ]);
                        ("entityType", `Assoc [ ("type", `String "string") ]);
                        ("prefix", `Assoc [ ("type", `String "string") ]);
                        ("suffix", `Assoc [ ("type", `String "string") ]);
                      ] );
                  ("required", `List [ `String "exact"; `String "entityType" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
         ({
            name = "tagging";
            about =
              "A passage of the category asked for, and what stands before and \
               after (K7).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc
                      [
                        ("exact", `Assoc [ ("type", `String "string") ]);
                        ("prefix", `Assoc [ ("type", `String "string") ]);
                        ("suffix", `Assoc [ ("type", `String "string") ]);
                      ] );
                  ("required", `List [ `String "exact" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
         ({
            name = "count";
            about =
              "The count a linking job asks of a piece beside its extraction: \
               how many mentions of the type it holds (K4).";
            element =
              `Assoc
                [
                  ("type", `String "object");
                  ( "properties",
                    `Assoc [ ("count", `Assoc [ ("type", `String "integer") ]) ]
                  );
                  ("required", `List [ `String "count" ]);
                  ("additionalProperties", `Bool false);
                ];
          }
           : formats_item);
       ];
   }
    : t)

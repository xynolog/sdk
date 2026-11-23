(* Generated from protocol/specs/src/jobs/filter-cases.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type job_type = Mark | Yield

let job_type_value = function
  | (Mark : job_type) -> "mark"
  | (Yield : job_type) -> "yield"

let job_type_json v = `String (job_type_value v)

type motivation = Assessing | Commenting | Highlighting | Linking | Tagging

let motivation_value = function
  | (Assessing : motivation) -> "assessing"
  | (Commenting : motivation) -> "commenting"
  | (Highlighting : motivation) -> "highlighting"
  | (Linking : motivation) -> "linking"
  | (Tagging : motivation) -> "tagging"

let motivation_json v = `String (motivation_value v)

type params = {
  motivation : motivation option;
  schema_id : string option;
  categories : string list option;
  title : string option;
  storage_uri : string option;
  output_media_type : string option;
  tone : string option;
  language : string option;
  entity_types : string list option;
  resource_id : string option;
}

let params_json (r : params) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.map (fun v -> ("motivation", motivation_json v)) r.motivation;
         Option.map (fun v -> ("schemaId", (fun s -> `String s) v)) r.schema_id;
         Option.map
           (fun v ->
             ("categories", (fun l -> `List (List.map (fun s -> `String s) l)) v))
           r.categories;
         Option.map (fun v -> ("title", (fun s -> `String s) v)) r.title;
         Option.map
           (fun v -> ("storageUri", (fun s -> `String s) v))
           r.storage_uri;
         Option.map
           (fun v -> ("outputMediaType", (fun s -> `String s) v))
           r.output_media_type;
         Option.map (fun v -> ("tone", (fun s -> `String s) v)) r.tone;
         Option.map (fun v -> ("language", (fun s -> `String s) v)) r.language;
         Option.map
           (fun v ->
             ( "entityTypes",
               (fun l -> `List (List.map (fun s -> `String s) l)) v ))
           r.entity_types;
         Option.map
           (fun v -> ("resourceId", (fun s -> `String s) v))
           r.resource_id;
       ])

type job = { job_type : job_type; params : params }

let job_json (r : job) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("jobType", job_type_json r.job_type);
         Option.Some ("params", params_json r.params);
       ])

type cases_item = {
  why : string;
  filter : Yojson.Safe.t;
  job : job;
  matches : bool;
}

let cases_item_json (r : cases_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("why", (fun s -> `String s) r.why);
         Option.Some ("filter", Fun.id r.filter);
         Option.Some ("job", job_json r.job);
         Option.Some ("matches", (fun b -> `Bool b) r.matches);
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
       "Whether a job matches a filter, as every implementation must answer \
        it: the Dispatcher choosing the next job a claim takes, and a party \
        checking an announcement against its own claim before it asks. A \
        filter is a partial job description (JobFilter). A job matches when \
        every field the filter states equals the job's at the same path; what \
        the filter leaves out is not compared. `job` is the description as it \
        is announced or held: its `jobType` and its `params`. Each \
        implementation runs every case and fails on a difference. Add a case \
        here before changing any of them.";
     cases =
       [
         ({
            why = "a mark filter takes a mark job of its motivation";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "tagging") ]);
                ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = Some (Tagging : motivation);
                      schema_id = Some "irac";
                      categories = Some [ "Issue" ];
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = true;
          }
           : cases_item);
         ({
            why = "a mark filter takes no mark job of another motivation";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "tagging") ]);
                ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = Some (Highlighting : motivation);
                      schema_id = None;
                      categories = None;
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = false;
          }
           : cases_item);
         ({
            why = "a mark filter takes no yield job";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "tagging") ]);
                ];
            job =
              ({
                 job_type = (Yield : job_type);
                 params =
                   ({
                      motivation = None;
                      schema_id = None;
                      categories = None;
                      title = Some "Ouranos";
                      storage_uri = Some "file://generated/ouranos.md";
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = false;
          }
           : cases_item);
         ({
            why =
              "a yield filter takes every yield job, whatever it is asked to \
               make";
            filter = `Assoc [ ("jobType", `String "yield") ];
            job =
              ({
                 job_type = (Yield : job_type);
                 params =
                   ({
                      motivation = None;
                      schema_id = None;
                      categories = None;
                      title = Some "Ouranos";
                      storage_uri = Some "file://generated/ouranos.md";
                      output_media_type = Some "application/pdf";
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = true;
          }
           : cases_item);
         ({
            why = "a yield filter takes no mark job";
            filter = `Assoc [ ("jobType", `String "yield") ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = Some (Commenting : motivation);
                      schema_id = None;
                      categories = None;
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = false;
          }
           : cases_item);
         ({
            why = "a filter's parameter the job does not state is no match";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "tagging") ]);
                ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = None;
                      schema_id = None;
                      categories = None;
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = false;
          }
           : cases_item);
         ({
            why = "a parameter the filter does not state is not compared";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "commenting") ]);
                ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = Some (Commenting : motivation);
                      schema_id = None;
                      categories = None;
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = Some "scholarly";
                      language = Some "de";
                      entity_types = None;
                      resource_id = None;
                    }
                     : params);
               }
                : job);
            matches = true;
          }
           : cases_item);
         ({
            why = "what the Dispatcher adds to a job it holds is not compared";
            filter =
              `Assoc
                [
                  ("jobType", `String "mark");
                  ("params", `Assoc [ ("motivation", `String "linking") ]);
                ];
            job =
              ({
                 job_type = (Mark : job_type);
                 params =
                   ({
                      motivation = Some (Linking : motivation);
                      schema_id = None;
                      categories = None;
                      title = None;
                      storage_uri = None;
                      output_media_type = None;
                      tone = None;
                      language = None;
                      entity_types = Some [ "Person" ];
                      resource_id = Some "res-1";
                    }
                     : params);
               }
                : job);
            matches = true;
          }
           : cases_item);
       ];
   }
    : t)

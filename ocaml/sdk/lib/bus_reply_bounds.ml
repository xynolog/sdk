(* Generated from protocol/specs/src/bus/reply-bounds.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type by = { by : string }

let by_json (r : by) =
  `Assoc
    (List.filter_map Fun.id [ Option.Some ("by", (fun s -> `String s) r.by) ])

type grows = { grows : string }

let grows_json (r : grows) =
  `Assoc
    (List.filter_map Fun.id
       [ Option.Some ("grows", (fun s -> `String s) r.grows) ])

type value_value = By of by | Grows of grows

let value_value_json = function
  | (By v : value_value) -> by_json v
  | (Grows v : value_value) -> grows_json v

type t = {
  comment : string;
  replies : (string * (string * value_value) list) list;
}

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "replies",
             (fun l ->
               `Assoc
                 (List.map
                    (fun (k, v) ->
                      ( k,
                        (fun l ->
                          `Assoc
                            (List.map (fun (k, v) -> (k, value_value_json v)) l))
                          v ))
                    l))
               r.replies );
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for how large each answer on the bus can be. A bus message \
        is bounded by its question: an answer whose size follows a document or \
        a collection is read over HTTP. Every list or map an operation's reply \
        carries is bounded by its own schema (`maxItems`, `maxProperties`), or \
        is named here: `by` a member of the request (an array, so the answer \
        is no larger than what was asked, or an integer with a `maximum`), or \
        as one that `grows`, saying with what. A `grows` entry is an answer \
        not yet bounded. Lists inside a resource's descriptor or an annotation \
        are the record's, bounded by the write that made them, and are not \
        walked. The reader in reader/ holds the registry to this table both \
        ways: a list it names that is gone or bounded fails, and so does a \
        reply's list it does not name.";
     replies =
       [
         ( "browse:resources-requested",
           [
             ( "response.resources",
               (Grows
                  ({
                     grows =
                       "with the knowledge base: a page whose `limit` states \
                        no maximum";
                   }
                    : grows)
                 : value_value) );
           ] );
         ( "browse:annotation-history-requested",
           [
             ( "response.events",
               (Grows ({ grows = "with the annotation's history" } : grows)
                 : value_value) );
           ] );
         ( "browse:events-requested",
           [
             ( "response.events",
               (Grows
                  ({
                     grows =
                       "with the resource's history: the request's `limit` \
                        states no maximum";
                   }
                    : grows)
                 : value_value) );
           ] );
         ( "browse:entity-types-requested",
           [
             ( "response.entityTypes",
               (Grows
                  ({ grows = "with the knowledge base's entity types" } : grows)
                 : value_value) );
           ] );
         ( "browse:tag-schemas-requested",
           [
             ( "response.tagSchemas",
               (Grows
                  ({ grows = "with the knowledge base's tag schemas" } : grows)
                 : value_value) );
           ] );
         ( "browse:engines-requested",
           [
             ( "response.engines",
               (Grows ({ grows = "with the knowledge base's engines" } : grows)
                 : value_value) );
           ] );
         ( "browse:profiles-requested",
           [ ("response.profiles", (By ({ by = "dids" } : by) : value_value)) ]
         );
         ( "browse:directory-requested",
           [
             ( "response.entries",
               (Grows
                  ({ grows = "with one directory of the working tree" } : grows)
                 : value_value) );
           ] );
         ( "gather:requested",
           [
             ( "response.focus.suggestedReferences",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.focus.content.related",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.graph.nodes",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.graph.edges",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.semanticContext.similar",
               (Grows ({ grows = "with the passages the recall ranks" } : grows)
                 : value_value) );
             ( "response.semanticContext.excludedEntityTypes",
               (Grows
                  ({ grows = "with the entity types the recall excluded" }
                    : grows)
                 : value_value) );
             ( "response.metadata.entityTypes",
               (Grows
                  ({ grows = "with the focal anchor's entity types" } : grows)
                 : value_value) );
             ( "response.metadata.entityTypeFrequencies",
               (Grows
                  ({ grows = "with the knowledge base's entity types" } : grows)
                 : value_value) );
           ] );
         ( "gather:resource-requested",
           [
             ( "response.focus.suggestedReferences",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.focus.content.related",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.graph.nodes",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.graph.edges",
               (Grows
                  ({ grows = "with the focus's neighbourhood in the graph" }
                    : grows)
                 : value_value) );
             ( "response.semanticContext.similar",
               (Grows ({ grows = "with the passages the recall ranks" } : grows)
                 : value_value) );
             ( "response.semanticContext.excludedEntityTypes",
               (Grows
                  ({ grows = "with the entity types the recall excluded" }
                    : grows)
                 : value_value) );
             ( "response.metadata.entityTypes",
               (Grows
                  ({ grows = "with the focal anchor's entity types" } : grows)
                 : value_value) );
             ( "response.metadata.entityTypeFrequencies",
               (Grows
                  ({ grows = "with the knowledge base's entity types" } : grows)
                 : value_value) );
           ] );
         ( "gather:referenced-by-requested",
           [
             ( "response.referencedBy",
               (Grows
                  ({
                     grows =
                       "with the annotations elsewhere that refer to the \
                        resource";
                   }
                    : grows)
                 : value_value) );
           ] );
         ( "gather:limits-requested",
           [
             ( "response.limits",
               (Grows
                  ({ grows = "with the engines the service holds a client for" }
                    : grows)
                 : value_value) );
           ] );
         ( "job:limits-requested",
           [
             ( "response.limits",
               (Grows
                  ({ grows = "with the engines the service holds a client for" }
                    : grows)
                 : value_value) );
           ] );
         ( "match:limits-requested",
           [
             ( "response.limits",
               (Grows
                  ({ grows = "with the engines the service holds a client for" }
                    : grows)
                 : value_value) );
           ] );
         ( "job:status-requested",
           [
             ( "response.progress.completedItems",
               (Grows
                  ({ grows = "with the items the job has finished" } : grows)
                 : value_value) );
             ( "response.progress.requestParams",
               (Grows ({ grows = "with the job's parameters" } : grows)
                 : value_value) );
             ( "response.result.byCategory",
               (Grows ({ grows = "with the tagging job's categories" } : grows)
                 : value_value) );
           ] );
         ( "job:claim",
           [
             ( "response.metadata.completedUnits",
               (Grows
                  ({ grows = "with the units the job has finished" } : grows)
                 : value_value) );
             ( "response.metadata.unitCursors",
               (Grows ({ grows = "with the units the job has begun" } : grows)
                 : value_value) );
             ( "response.params.schema.tags",
               (Grows ({ grows = "with the tag schema's tags" } : grows)
                 : value_value) );
             ( "response.progress.completedItems",
               (Grows
                  ({ grows = "with the items the job has finished" } : grows)
                 : value_value) );
             ( "response.progress.requestParams",
               (Grows ({ grows = "with the job's parameters" } : grows)
                 : value_value) );
           ] );
         ( "mark:commit",
           [
             ( "response.annotationIds",
               (By ({ by = "annotations" } : by) : value_value) );
           ] );
         ( "match:search-requested",
           [ ("response", (By ({ by = "limit" } : by) : value_value)) ] );
         ( "match:resources-requested",
           [
             ("response.resources", (By ({ by = "limit" } : by) : value_value));
           ] );
       ];
   }
    : t)

(* Generated from protocol/specs/src/archivist/default-entity-types.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type t = { comment : string; entity_types : string list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "entityTypes",
             (fun l -> `List (List.map (fun s -> `String s) l)) r.entity_types
           );
       ])

let table : t =
  ({
     comment =
       "AUTHORITY for the vocabulary an Archivist seeds at boot (ARCHIVIST.md \
        \194\167 Boot and shutdown, step 8): each of `entityTypes` that the \
        `__system__` stream has not recorded is added, in this order, as a \
        `frame:entity-type-added` sent by the knowledge base itself \
        (`did:web:<domain>`), before the Archivist subscribes to its channels; \
        its facts are the first it publishes.";
     entity_types =
       [
         "Person";
         "Organization";
         "Location";
         "Event";
         "Concept";
         "Product";
         "Technology";
         "Date";
         "Author";
       ];
   }
    : t)

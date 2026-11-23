(* Generated from protocol/specs/src/client/types/SearchState.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/SearchState.json");
      ("title", `String "SearchState");
      ("type", `String "object");
      ( "description",
        `String
          "A search pipeline's state: the results of the last query answered, \
           and whether a query is still on its way. What a result is, is the \
           search's source's." );
      ( "properties",
        `Assoc
          [
            ( "results",
              `Assoc
                [
                  ("type", `String "array");
                  ( "description",
                    `String
                      "The last answered query's results, as its source gives \
                       them." );
                ] );
            ( "isSearching",
              `Assoc
                [
                  ("type", `String "boolean");
                  ("description", `String "Whether a query is on its way.");
                ] );
          ] );
      ("required", `List [ `String "results"; `String "isSearching" ]);
      ("additionalProperties", `Bool false);
    ]

(* Generated from protocol/specs/src/client/types/CacheState.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/CacheState.json");
      ("title", `String "CacheState");
      ( "description",
        `String
          "Where a live query's key stands, told apart by `status`, \
           CacheStatus's (contract/CACHE-SEMANTICS.md): pending, with no value \
           yet; ready, with its value, a V; or failed, with the SDK's error. A \
           V is what the query holds, the cache's." );
      ("x-xynolog-typeParameters", `List [ `String "V" ]);
      ( "oneOf",
        `List
          [
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "No value yet.");
                ( "properties",
                  `Assoc
                    [
                      ( "status",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "pending" ]);
                          ] );
                    ] );
                ("required", `List [ `String "status" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "The key holds a value.");
                ( "properties",
                  `Assoc
                    [
                      ( "status",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "ready" ]);
                          ] );
                      ( "value",
                        `Assoc
                          [
                            ("x-xynolog-typeParameter", `String "V");
                            ("description", `String "The value the key holds.");
                          ] );
                    ] );
                ("required", `List [ `String "status"; `String "value" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ( "description",
                  `String "The key holds no value, and its fetch failed." );
                ( "properties",
                  `Assoc
                    [
                      ( "status",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "failed" ]);
                          ] );
                      ( "error",
                        `Assoc
                          [
                            ( "$comment",
                              `String
                                "The failure: the SDK's own error, which no \
                                 schema states." );
                          ] );
                    ] );
                ("required", `List [ `String "status"; `String "error" ]);
                ("additionalProperties", `Bool false);
              ];
          ] );
    ]

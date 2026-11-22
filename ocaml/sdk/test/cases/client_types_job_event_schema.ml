(* Generated from protocol/specs/src/client/types/JobEvent.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/JobEvent.json");
      ("title", `String "JobEvent");
      ( "description",
        `String
          "What a delegation reports as its job goes, told apart by `kind`: \
           the queue's naming of the job first, its progress, and last, its \
           failure, a frame refused, or its completion. Each operation that \
           delegates completes with its own verb's completion, a branch of \
           JobCompleteCommand." );
      ( "oneOf",
        `List
          [
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "The queue took the job.");
                ( "properties",
                  `Assoc
                    [
                      ( "kind",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "created" ]);
                          ] );
                      ( "data",
                        `Assoc
                          [
                            ( "$ref",
                              `String
                                "https://xynolog.org/protocol/JobCreatedResultResponse.json"
                            );
                          ] );
                    ] );
                ("required", `List [ `String "kind"; `String "data" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "The job's progress.");
                ( "properties",
                  `Assoc
                    [
                      ( "kind",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "progress" ]);
                          ] );
                      ( "data",
                        `Assoc
                          [
                            ( "$ref",
                              `String
                                "https://xynolog.org/protocol/JobProgress.json"
                            );
                          ] );
                    ] );
                ("required", `List [ `String "kind"; `String "data" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "The job failed.");
                ( "properties",
                  `Assoc
                    [
                      ( "kind",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "failed" ]);
                          ] );
                      ( "data",
                        `Assoc
                          [
                            ( "$ref",
                              `String
                                "https://xynolog.org/protocol/JobFailCommand.json"
                            );
                          ] );
                    ] );
                ("required", `List [ `String "kind"; `String "data" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ( "description",
                  `String
                    "A frame of the job's was refused: its channel, the member \
                     at fault, and why." );
                ( "properties",
                  `Assoc
                    [
                      ( "kind",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "refused" ]);
                          ] );
                      ( "data",
                        `Assoc
                          [
                            ("type", `String "object");
                            ( "properties",
                              `Assoc
                                [
                                  ( "channel",
                                    `Assoc
                                      [
                                        ("type", `String "string");
                                        ( "description",
                                          `String
                                            "The channel the frame came on." );
                                      ] );
                                  ( "member",
                                    `Assoc
                                      [
                                        ("type", `String "string");
                                        ( "description",
                                          `String
                                            "The member at fault, named by its \
                                             way from the frame." );
                                      ] );
                                  ( "reason",
                                    `Assoc
                                      [
                                        ( "$ref",
                                          `String
                                            "https://xynolog.org/protocol/FrameRefusalReason.json"
                                        );
                                      ] );
                                ] );
                            ( "required",
                              `List
                                [
                                  `String "channel";
                                  `String "member";
                                  `String "reason";
                                ] );
                            ("additionalProperties", `Bool false);
                          ] );
                    ] );
                ("required", `List [ `String "kind"; `String "data" ]);
                ("additionalProperties", `Bool false);
              ];
            `Assoc
              [
                ("type", `String "object");
                ("description", `String "The job completed.");
                ( "properties",
                  `Assoc
                    [
                      ( "kind",
                        `Assoc
                          [
                            ("type", `String "string");
                            ("enum", `List [ `String "complete" ]);
                          ] );
                      ( "data",
                        `Assoc
                          [
                            ( "$ref",
                              `String
                                "https://xynolog.org/protocol/JobCompleteCommand.json"
                            );
                          ] );
                    ] );
                ("required", `List [ `String "kind"; `String "data" ]);
                ("additionalProperties", `Bool false);
              ];
          ] );
      ("discriminator", `Assoc [ ("propertyName", `String "kind") ]);
    ]

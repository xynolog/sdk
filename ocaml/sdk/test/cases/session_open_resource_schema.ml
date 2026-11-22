(* Generated from protocol/specs/src/session/OpenResource.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

let schema : Yojson.Safe.t =
  `Assoc
    [
      ("$schema", `String "https://json-schema.org/draft/2020-12/schema");
      ("$id", `String "https://xynolog.org/protocol/OpenResource.json");
      ("title", `String "OpenResource");
      ("type", `String "object");
      ( "description",
        `String
          "A resource open in a knowledge base: which resource, the name it is \
           shown by, when it was opened and its place among the others open \
           there. A registry shows them by their places, and two in one place \
           by when each was opened, first first." );
      ( "properties",
        `Assoc
          [
            ( "id",
              `Assoc
                [
                  ( "$ref",
                    `String "https://xynolog.org/protocol/ResourceId.json" );
                  ("description", `String "The resource.");
                ] );
            ( "name",
              `Assoc
                [
                  ("type", `String "string");
                  ("description", `String "The name the resource is shown by.");
                ] );
            ( "openedAt",
              `Assoc
                [
                  ("type", `String "integer");
                  ("minimum", `Int 0);
                  ( "description",
                    `String
                      "When the resource was opened, in milliseconds since the \
                       Unix epoch. Opening it again while it is open changes \
                       neither this nor its place." );
                ] );
            ( "order",
              `Assoc
                [
                  ("type", `String "integer");
                  ("minimum", `Int 0);
                  ( "description",
                    `String
                      "The resource's place among those open in the knowledge \
                       base. One opened is given the place after the last \
                       taken, so a place freed by closing one is not given \
                       twice; a move gives each its place in the new order, \
                       counted from 0." );
                ] );
            ( "mediaType",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "The resource's media type, which its icon is chosen by. \
                       Absent when it is not known." );
                ] );
            ( "storageUri",
              `Assoc
                [
                  ("type", `String "string");
                  ( "description",
                    `String
                      "Where the resource is in the knowledge base's working \
                       tree, as a URI (file://docs/overview.md). Absent when \
                       it is not known." );
                ] );
          ] );
      ( "required",
        `List
          [ `String "id"; `String "name"; `String "openedAt"; `String "order" ]
      );
    ]

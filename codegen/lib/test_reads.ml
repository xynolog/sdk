(* The files of Protocol other than the case tables they run that an SDK's
   tests read, which the case-data group writes for them as it writes a case table's
   rows: a table, as values of its model; a schema, as the JSON it is, for a
   test that holds an SDK's own type to the members the schema states. Each
   with the SDK's tests that read it, each a file under the SDK's directory
   that names the module the group writes (coverage_census.exe). *)

type read = Table of string | Schema of string

let file = function Table file | Schema file -> file

let reads : Coverage_sdk.t -> (read * string list) list = function
  | Ocaml ->
      [
        ( Table "client/timing.json",
          [
            "ocaml/sdk/test/registry_behavior.ml";
            "ocaml/sdk/test/state_behavior.ml";
          ] );
        (Table "client/state-units.json", [ "ocaml/sdk/test/state_behavior.ml" ]);
        (Table "client/surface.json", [ "ocaml/sdk/test/surface_behavior.ml" ]);
        ( Schema "client/types/SearchState.json",
          [ "ocaml/sdk/test/client_types_census.ml" ] );
        ( Schema "client/types/JobEvent.json",
          [ "ocaml/sdk/test/client_types_census.ml" ] );
        ( Schema "client/types/CacheState.json",
          [ "ocaml/sdk/test/client_types_census.ml" ] );
        ( Schema "session/StoredSession.json",
          [ "ocaml/sdk/test/registry_behavior.ml" ] );
        ( Schema "session/OpenResource.json",
          [ "ocaml/sdk/test/registry_behavior.ml" ] );
        (Schema "sign-in-store/SignIn.json", [ "ocaml/sdk/test/sign_in.ml" ]);
      ]
  | Typescript ->
      [
        ( Table "client/state-units.json",
          [ "typescript/sdk/src/__tests__/state-cases.test.ts" ] );
        ( Table "client/surface.json",
          [
            "typescript/sdk/src/__tests__/client-surface.test.ts";
            "typescript/sdk/src/__tests__/state-cases.test.ts";
          ] );
        ( Table "client/timing.json",
          [
            "typescript/sdk/src/__tests__/clock-cases.test.ts";
            "typescript/sdk/src/__tests__/state-cases.test.ts";
          ] );
        ( Table "errors/codes.json",
          [ "typescript/core/src/__tests__/builder-cases.test.ts" ] );
        ( Table "identifiers/kinds.json",
          [ "typescript/core/src/__tests__/identifiers.test.ts" ] );
        ( Table "media-types/registry.json",
          [ "typescript/core/src/__tests__/media-type-registry.test.ts" ] );
        ( Table "session/client-assertion-cases.json",
          [ "typescript/sdk/src/__tests__/worker-skill.test.ts" ] );
        ( Table "session/stored.json",
          [
            "typescript/core/src/__tests__/cache-cases.test.ts";
            "typescript/sdk/src/session/__tests__/persisted-cases.test.ts";
            "typescript/sdk/src/session/__tests__/stored-table.test.ts";
          ] );
        ( Table "sign-in-store/owner-only.json",
          [ "typescript/sdk/src/session/__tests__/sign-in-store.test.ts" ] );
        ( Schema "client/types/JobEvent.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/SearchState.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/CacheState.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/EngineWithLimits.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/PutBinaryRequest.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/ResourceRepresentation.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "client/types/ResourceRepresentationStream.json",
          [ "typescript/sdk/src/__tests__/client-types-census.test.ts" ] );
        ( Schema "components/schemas/BrowseResourcesRequest.json",
          [ "typescript/core/src/__tests__/bus-invariants.test.ts" ] );
        ( Schema "components/schemas/BusEmitRequest.json",
          [ "typescript/core/src/__tests__/correlated-reply-wire.test.ts" ] );
        ( Schema "components/schemas/BusSubscribeRequest.json",
          [ "typescript/core/src/__tests__/correlated-reply-wire.test.ts" ] );
        ( Schema "components/schemas/ListResourcesResponse.json",
          [ "typescript/core/src/__tests__/bus-invariants.test.ts" ] );
        ( Schema "components/schemas/MatchResourcesResponse.json",
          [ "typescript/core/src/__tests__/bus-invariants.test.ts" ] );
        ( Schema "session/OpenResource.json",
          [ "typescript/sdk/src/session/__tests__/stored-table.test.ts" ] );
        ( Schema "session/StoredSession.json",
          [ "typescript/sdk/src/session/__tests__/stored-table.test.ts" ] );
      ]
  | Python | Rust | Go | Csharp | Haskell | Kotlin | Swift -> []

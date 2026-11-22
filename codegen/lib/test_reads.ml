(* The files of Protocol other than its case tables that an SDK's tests read,
   which the case-data group writes for them as it writes a case table's
   rows: a table, as values of its model; a schema, as the JSON it is, for a
   test that holds an SDK's own type to the members the schema states. *)

type read = Table of string | Schema of string

let reads : Coverage_sdk.t -> read list = function
  | Ocaml ->
      [
        Table "client/timing.json";
        Table "client/state-units.json";
        Table "client/surface.json";
        Table "session/stored.json";
        Schema "client/types/SearchState.json";
        Schema "client/types/JobEvent.json";
        Schema "session/StoredSession.json";
        Schema "session/OpenResource.json";
        Schema "sign-in-store/SignIn.json";
      ]
  | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Swift -> []

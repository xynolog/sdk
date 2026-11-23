(* sdk's coverage of Protocol's case tables: for each case table of the pinned
   Protocol, what each SDK does about it. A test named here runs every case of
   its table; a table no test of an SDK runs is absent from that SDK, or not
   yet reached by it, and says why. coverage_census.exe holds this to the
   pinned Protocol and to this checkout. *)

open Coverage_sdk

type coverage =
  (* The SDK's tests that run the table, each a file under the SDK's directory
     that reads the table (coverage_census.exe). *)
  | Run_by of string list
  (* The SDK has no counterpart of what the table states, with why. *)
  | Absent of string
  (* The SDK has a counterpart, and does not run the table yet, with why. *)
  | Not_yet_reached of string

(* Each case table, by its path under specs/src. *)
let tables : (string * (Coverage_sdk.t -> coverage)) list =
  [
    ( "annotations/builder-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/core/src/__tests__/builder-cases.test.ts";
              "typescript/sdk/src/__tests__/annotation-builders.test.ts";
              "typescript/sdk/src/__tests__/worker-skill.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_annotation_builders.py" ]
      | Rust ->
          Run_by
            [ "rust/sdk/tests/builder_cases.rs"; "rust/sdk/tests/readme.rs" ]
      | Go -> Run_by [ "go/annotations/builders_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/AnnotationBuildersTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "annotations/id-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/id-cases.test.ts" ]
      | Python ->
          Run_by
            [
              "python/sdk/tests/test_annotation_ids.py";
              "python/sdk/tests/test_readme.py";
            ]
      | Rust -> Run_by [ "rust/sdk/src/annotations/id.rs" ]
      | Go -> Run_by [ "go/annotations/id_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/AnnotationIdsTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "annotations/pdf-locate-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/pdf-locate-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_pdf_locate.py" ]
      | Rust -> Run_by [ "rust/sdk/src/annotations/locate.rs" ]
      | Go -> Run_by [ "go/annotations/locate_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/PdfLocateTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "annotations/reader-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/core/src/__tests__/annotation-reader-cases.test.ts";
              "typescript/sdk/src/__tests__/annotation-readers.test.ts";
            ]
      | Python ->
          Run_by
            [
              "python/sdk/tests/test_annotation_builders.py";
              "python/sdk/tests/test_annotations.py";
            ]
      | Rust ->
          Run_by
            [
              "rust/sdk/tests/annotation_reader_cases.rs";
              "rust/sdk/tests/builder_cases.rs";
            ]
      | Go -> Run_by [ "go/annotations/readers_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/AnnotationReadersTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "annotations/reconcile-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/reconcile-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_reconcile.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/reconcile_cases.rs" ]
      | Go -> Run_by [ "go/annotations/reconcile_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/ReconcileCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "archivist/shard-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The Archivist files keys in its own stores; no SDK files or reads \
             a shard." );
    ( "bus/event-id-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The gateway's own: it gives each bus-event its id, and an SDK \
             hands an id back only to resume after it." );
    ( "bus/frame-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/http-transport/src/transport/__tests__/frame-cases.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_frame_cases.py" ]
      | Rust -> Run_by [ "rust/http-transport/src/actor.rs" ]
      | Go -> Run_by [ "go/frame_cases_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/FrameCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/FrameCases.hs" ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/http/FrameCasesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/FrameCasesTests.swift" ]
    );
    ( "bus/log-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/bus-log-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_bus_log.py" ]
      | Rust -> Run_by [ "rust/sdk/src/bus_log.rs" ]
      | Go -> Run_by [ "go/buslog_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/BusLogTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/BusLogCases.hs" ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/bus/BusLogTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/TransportTablesTests.swift" ]
    );
    ( "client/clock-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/sdk/src/__tests__/clock-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_clock_cases.py" ]
      | Rust -> Run_by [ "rust/http-transport/tests/clock_cases.rs" ]
      | Go -> Run_by [ "go/clock_cases_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/ClockCasesTests.cs" ]
      | Haskell ->
          Run_by
            [
              "haskell/sdk/test/ClockCases.hs";
              "haskell/sdk/test/HeldCases.hs";
              "haskell/sdk/test/DelegationCases.hs";
              "haskell/sdk/test/SessionCases.hs";
              "haskell/sdk/test/IssuerCases.hs";
            ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/ClockCasesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/registry_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/ClockCasesTests.swift" ]
    );
    ( "control/request-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The launcher answers control requests, and Desktop sends them; no \
             SDK speaks xynolog control." );
    ( "follower/follow-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "A follower of the record is a service's (the Weaver's, the \
             Smelter's); no SDK follows the record's logs." );
    ( "graph/codec-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The graph's codecs are the graph store's and its readers', in the \
             services; no SDK reads or writes a graph store." );
    ( "graph/database-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The launcher names a knowledge base's graph database; no SDK \
             opens a graph store." );
    ( "jobs/filter-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/job-filter.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_claims.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/job_filter.rs" ]
      | Go -> Run_by [ "go/claims_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/WorkerTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/WorkerCases.hs" ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/jobs/JobTablesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/worker_filters.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/WorkerTablesTests.swift" ] );
    ( "jobs/retry-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/sdk/src/__tests__/job-claims.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_claims.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/job_retry_cases.rs" ]
      | Go -> Run_by [ "go/claims_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/WorkerTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/WorkerCases.hs" ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/jobs/JobTablesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/WorkerTablesTests.swift" ] );
    ( "kb-identity/cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/core/src/__tests__/kb-identity-agreement.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_identity.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/tables.rs" ]
      | Go -> Run_by [ "go/identity_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/IdentityTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/IdentityCases.hs" ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/identity/IdentityTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/SessionTablesTests.swift" ] );
    ( "librarian/derive-views-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/derive-views-cases.test.ts" ]
      | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml | Swift ->
          Absent
            "Only the Browser, through the TypeScript SDK, reads views off a \
             knowledge graph in a client; the Librarian and the worker read \
             their own." );
    ( "librarian/knowledge-graph-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Librarian's own: no SDK builds a knowledge graph." );
    ( "librarian/prompt-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Librarian's own: no SDK writes the Librarian's prompts."
    );
    ( "librarian/reply-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The Librarian's own: no SDK reads a model's reply for the \
             Librarian." );
    ( "librarian/score-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Librarian's own: no SDK answers a reference search." );
    ( "librarian/search-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The Librarian's own: no SDK answers a search of resources by text."
    );
    ( "librarian/window-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Librarian's own: no SDK cuts the text around a selection."
    );
    ( "media-types/cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/media-type-registry.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_media_types.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/media_types.rs" ]
      | Go -> Run_by [ "go/mediatypes/mediatypes_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/RepresentationTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/TextCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/mediatypes/MediaTypesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/MediaTypesTests.swift" ]
    );
    ( "principals/cases.json",
      function
      | Typescript ->
          Absent
            "No TypeScript code names a principal: the gateway, in Rust, mints \
             every DID it acts for."
      | Python -> Run_by [ "python/sdk/tests/test_identity.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/tables.rs" ]
      | Go -> Run_by [ "go/identity_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/IdentityTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/IdentityCases.hs" ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/identity/IdentityTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/SessionTablesTests.swift" ] );
    ( "principals/kind-cases.json",
      function
      | Typescript ->
          Absent
            "No TypeScript code reads a DID's kind: the record, in Rust, \
             attributes every write, and the Browser reads the agents the \
             record gives it."
      | Python ->
          Absent
            "No Python code reads a DID's kind: the Librarian names principals \
             from the record's profiles, and the worker states its own \
             generator."
      | Rust -> Run_by [ "rust/sdk/tests/tables.rs" ]
      | Go ->
          Absent
            "No Go code reads a DID's kind: the launcher and the Go SDK name \
             the knowledge base and its people, and read no principal's DID."
      | Csharp ->
          Absent
            "The C# SDK builds principal DIDs and does not read a principal \
             kind from a DID."
      | Haskell -> Absent "Haskell code reads no principal's kind from a DID."
      | Kotlin ->
          Absent
            "No Kotlin code reads a DID's kind: the Kotlin SDK builds the DIDs \
             of a knowledge base's people and agents, and reads no principal's \
             kind."
      | Ocaml -> Absent "OCaml code reads no principal's kind from a DID."
      | Swift ->
          Absent
            "No Swift code reads a DID's kind: the Swift SDK builds the DIDs \
             of a knowledge base's people and agents, and reads no principal's \
             kind." );
    ( "principals/naming-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The Archivist and the Librarian name the principals a reply \
             mentions; no SDK does." );
    ( "resources/reader-cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/core/src/__tests__/resource-reader-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_resource_readers.py" ]
      | Rust ->
          Run_by
            [
              "rust/sdk/src/resources.rs";
              "rust/sdk/tests/resource_reader_cases.rs";
            ]
      | Go -> Run_by [ "go/resources_test.go" ]
      | Csharp ->
          Run_by
            [ "csharp/sdk/tests/Xynolog.Tests/ResourceReaderCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/ResourceCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/resources/ResourceReadersTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/helper_behavior.ml" ]
      | Swift ->
          Run_by
            [ "swift/sdk/Tests/XynologTests/ResourceReaderCasesTests.swift" ] );
    ( "retry/cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/retry-agreement.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_retry.py" ]
      | Rust ->
          Run_by [ "rust/sdk/src/retry.rs"; "rust/sdk/tests/retry_cases.rs" ]
      | Go -> Run_by [ "go/retry_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/RetryTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/Main.hs" ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/retry/RetryCasesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/completion_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/TransportTablesTests.swift" ]
    );
    ( "session/cache-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/core/src/__tests__/cache-cases.test.ts";
              "typescript/sdk/src/__tests__/cache-cases.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_cache_cases.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/cache_cases.rs" ]
      | Go -> Run_by [ "go/cache_cases_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/CacheCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/CacheDocumentCases.hs" ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/storage/CacheCasesTest.kt" ]
      | Ocaml ->
          Not_yet_reached
            "OCaml's Storage_persister keeps every query's values and the \
             stream's places in one document under one key: it is to keep one \
             document per persisted query, as stored.json's `cacheDocument`, \
             and the places as its `lastEventIds`, under the keys these cases \
             name, and to run every case through it."
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/CacheCasesTests.swift" ]
    );
    ( "session/cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/session-agreement.test.ts" ]
      | Python ->
          Run_by
            [
              "python/sdk/tests/test_session.py";
              "python/sdk/tests/test_session_tables.py";
            ]
      | Rust ->
          Run_by
            [ "rust/sdk/tests/session.rs"; "rust/sdk/tests/session_cases.rs" ]
      | Go -> Run_by [ "go/session_test.go"; "go/token_test.go" ]
      | Csharp ->
          Run_by
            [
              "csharp/sdk/tests/Xynolog.Tests/SessionTests.cs";
              "csharp/sdk/tests/Xynolog.Tests/TokenTests.cs";
            ]
      | Haskell ->
          Run_by
            [
              "haskell/sdk/test/TokenStorageCases.hs";
              "haskell/sdk/test/SessionCases.hs";
            ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/session/SessionCasesTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/session_renewal.ml" ]
      | Swift ->
          Run_by
            [
              "swift/sdk/Tests/XynologTests/SessionCasesTests.swift";
              "swift/sdk/Tests/XynologTests/SessionTablesTests.swift";
            ] );
    ( "session/client-assertion-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/core/src/__tests__/client-assertion-cases.test.ts";
              "typescript/core/src/__tests__/key-credential.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_client_assertion_cases.py" ]
      | Rust -> Run_by [ "rust/http-transport/tests/client_assertion_cases.rs" ]
      | Go -> Run_by [ "go/clientassertion_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/ServiceTokenTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/ClientAssertionCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/http/ClientAssertionCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/sign_in.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/IssuerTests.swift" ] );
    ( "session/gateway-url-cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/gateway-url-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_gateway_url.py" ]
      | Rust -> Run_by [ "rust/sdk/src/session/knowledge_base.rs" ]
      | Go -> Run_by [ "go/endpoint_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/GatewayTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/GatewayCases.hs" ]
      | Kotlin ->
          Run_by [ "kotlin/sdk/src/test/kotlin/xynolog/http/GatewayUrlTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/registry_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/SessionTablesTests.swift" ] );
    ( "session/open-resource-cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/xynolog-browser.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_registry.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/browser.rs" ]
      | Go -> Run_by [ "go/registry/browser_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/RegistryTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/OpenResourceCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/registry/OpenResourcesTest.kt";
            ]
      | Ocaml ->
          Not_yet_reached
            "OCaml's registry is to run these cases over a scripted knowledge \
             base, as the others do."
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/RegistryTablesTests.swift" ] );
    ( "session/persisted-cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/persisted-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_persisted_cases.py" ]
      | Rust -> Run_by [ "rust/http-transport/tests/persisted_cases.rs" ]
      | Go -> Run_by [ "go/registry/persisted_cases_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/PersistedCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/PersistedCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/registry/PersistedCasesTest.kt";
            ]
      | Ocaml ->
          Not_yet_reached
            "OCaml keeps every query's values and the stream's places in one \
             document under one key (Storage_persister): it is to keep them as \
             this table says, one key per persisted query and the places \
             beside them, for one person, with personKey on the stored \
             session, the persisted list, forgetting that deletes every key of \
             the person, a replaced sign-in forgetting the person it named, \
             the check before each write of a session the SDK builds, and the \
             scope's place taken only from a PersistedEventId."
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/PersistedCasesTests.swift" ] );
    ( "session/registry-cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/registry-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_registry_cases.py" ]
      | Rust -> Run_by [ "rust/sdk/src/session/browser.rs" ]
      | Go -> Run_by [ "go/registry/same_place_test.go" ]
      | Csharp -> Run_by [ "csharp/sdk/tests/Xynolog.Tests/RegistryTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/RegistryCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/registry/RegistryCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/registry_behavior.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/RegistryTablesTests.swift" ] );
    ( "session/registry-errors-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/sdk/src/session/__tests__/registry-errors-cases.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_registry_errors_cases.py" ]
      | Rust -> Run_by [ "rust/sdk/tests/browser.rs" ]
      | Go -> Run_by [ "go/registry/registry_errors_cases_test.go" ]
      | Csharp ->
          Run_by
            [ "csharp/sdk/tests/Xynolog.Tests/RegistryErrorsCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/RegistryErrorsCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/registry/RegistryErrorsCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/registry_behavior.ml" ]
      | Swift ->
          Run_by
            [ "swift/sdk/Tests/XynologTests/RegistryErrorsCasesTests.swift" ] );
    ( "sign-in-store/cases.json",
      function
      | Typescript ->
          Run_by
            [ "typescript/sdk/src/session/__tests__/sign-in-store.test.ts" ]
      | Python ->
          Run_by
            [
              "python/sdk/tests/test_sign_in_store.py";
              "python/sdk/tests/test_state_dir.py";
            ]
      | Rust ->
          Run_by
            [
              "rust/http-transport/src/oauth/tests.rs";
              "rust/sdk/tests/sign_in_store.rs";
            ]
      | Go -> Run_by [ "go/signinstore_test.go"; "go/statedir_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/SignInStoreTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/SignInStoreCases.hs" ]
      | Kotlin ->
          Run_by
            [ "kotlin/sdk/src/test/kotlin/xynolog/signin/SignInStoreTest.kt" ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/sign_in.ml" ]
      | Swift ->
          Run_by [ "swift/sdk/Tests/XynologTests/SignInStoreTests.swift" ] );
    ( "smelter/extraction-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Smelter's own: no SDK derives a PDF's text." );
    ( "smelter/reconcile-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Smelter's own: no SDK plans a Smelter's work." );
    ( "stack/cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The launcher reads the stack's documents; no SDK does." );
    ( "text/chunk-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The cutting is Xynolog's worker's own choice, as the table says: \
             no SDK has it." );
    ( "text/decode-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/decode-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_decode_cases.py" ]
      | Rust ->
          Run_by
            [ "rust/sdk/src/resources.rs"; "rust/sdk/tests/decode_cases.rs" ]
      | Go -> Run_by [ "go/resources_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/RepresentationTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/TextCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/resources/DecodeCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift ->
          Run_by
            [ "swift/sdk/Tests/XynologTests/DecodeRepresentationTests.swift" ]
    );
    ( "text/encoding-cases.json",
      function
      | Typescript ->
          Run_by [ "typescript/core/src/__tests__/decode-cases.test.ts" ]
      | Python -> Run_by [ "python/sdk/tests/test_decode_cases.py" ]
      | Rust ->
          Run_by
            [ "rust/sdk/src/resources.rs"; "rust/sdk/tests/decode_cases.rs" ]
      | Go -> Run_by [ "go/resources_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/RepresentationTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/TextCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/resources/DecodeCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/test/closure_behavior.ml" ]
      | Swift ->
          Run_by
            [ "swift/sdk/Tests/XynologTests/DecodeRepresentationTests.swift" ]
    );
    ( "text/offset-cases.json",
      function
      | Typescript ->
          Run_by
            [
              "typescript/core/src/__tests__/offset-cases.test.ts";
              "typescript/react-ui/src/lib/__tests__/code-point-offsets.test.ts";
            ]
      | Python -> Run_by [ "python/sdk/tests/test_offsets.py" ]
      | Rust -> Run_by [ "rust/sdk/src/text_offsets.rs" ]
      | Go -> Run_by [ "go/annotations/offsets_test.go" ]
      | Csharp ->
          Run_by [ "csharp/sdk/tests/Xynolog.Tests/AnnotationCasesTests.cs" ]
      | Haskell -> Run_by [ "haskell/sdk/test/AnnotationCases.hs" ]
      | Kotlin ->
          Run_by
            [
              "kotlin/sdk/src/test/kotlin/xynolog/annotations/OffsetCasesTest.kt";
            ]
      | Ocaml -> Run_by [ "ocaml/sdk/probes/capabilities.ml" ]
      | Swift -> Run_by [ "swift/sdk/Tests/XynologTests/AnnotationTests.swift" ]
    );
    ( "vectors/payload-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The vector index's stores write and read its points; no SDK \
             reaches the index." );
    ( "vectors/store-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "The vector index's stores answer these histories; no SDK reaches \
             the index." );
    ( "vectors/token-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The launcher mints Qdrant tokens; no SDK reaches a Qdrant." );
    ( "weaver/fold-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent "The Weaver's own: no SDK folds the record into the graph." );
    ( "worker/chunk-plan-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "Xynolog's worker plans its own pieces; no SDK asks a model about \
             a text." );
    ( "worker/citation-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "Xynolog's worker resolves its own citations; no SDK generates \
             text under cite." );
    ( "worker/failure-class-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "Xynolog's worker and its inference drivers classify its failures; \
             an SDK's worker reports the class its handler gives." );
    ( "worker/parser-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "Xynolog's worker reads a model's reply into its items; no SDK \
             reads one." );
    ( "worker/prompt-cases.json",
      function
      | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Ocaml
      | Swift ->
          Absent
            "Xynolog's worker writes its own prompts; no SDK asks a model \
             about a text." );
  ]

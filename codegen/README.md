# Codegen

The generator that reads the pinned Protocol's specs and writes every SDK's
generated code, and cli's and images'. It is a Dune project on the OCaml
toolchain that
[`build-tools/ocaml/toolchain.json`](https://github.com/xynolog/build-tools/blob/main/ocaml/toolchain.json)
pins, and `build-tools/ocaml/check-toolchain.py` holds it to the same pins as
the OCaml SDK.

## The model

The generator reads the pinned Protocol through Protocol's own reader,
[`protocol/reader`](https://github.com/xynolog/protocol/tree/main/reader), which `protocol` here links to and
dune vendors. The reader reads every file of `specs/src` into OCaml types, and
refuses what it does not know. An unknown member, a duplicate member, a wrong
type and a missing member are each a refusal that names the file and the JSON
Pointer of the value refused; nothing is defaulted.

- `Decode`, `Schema` and `Openapi` (`xynolog-protocol.schema`): the strict
  decoder, a JSON Schema as Protocol writes it, and the two OpenAPI
  documents.
- `Tables` and `Spec` (`xynolog-protocol`): one model per table, derived at
  build time from the schema beside it; and every file accounted for, every
  `$ref` resolved to a file of the kind its place calls for, and every table
  what its schema says.

`lib/` opens both libraries, and keeps what is the generator's own:

- `Normalize`: what an `allOf` means, its parts merged keyword by keyword
  into the one schema they describe, which every group's writers read and
  none decides itself. `Inherited` is which schema states each property it
  merges, so a writer names a type for the schema that states it.

## The groups

A group writes one subject's files, in every language it has, from the
model, and refuses a spec that breaks a rule its files rely on. Each group
belongs to a target, the repository whose files it writes: `Groups.sdk`
lists this one's, and `Groups.cli` cli's ([below](#clis-groups)). Each
group's modules are a directory of `lib/`, with one module per language it
writes:

- `bus`: every SDK's bus vocabulary, from `bus/registry.json`.
  `Bus.Registry` holds the registry to the bus's rules and derives what the
  languages share; `Bus.Typescript`, `Bus.Go` and `Bus.Python` write
  `typescript/core/src`'s bus files, `go/bus`'s `_gen.go` files and
  `python/sdk/src/xynolog`'s `channels.py` and `operations.py`, and
  `Bus.Csharp` C#'s `BusDescriptors.g.cs`.
- `required`: what each component schema requires of a value, the table
  every SDK holds a reply to before it reads it. `Required.Shape` derives it
  and states its rules. `Required.Table` writes it as JSON for Go, and
  `Required.Typescript`, `Required.Python`, `Required.Rust`,
  `Required.Kotlin`, `Required.Csharp` and `Required.Haskell` write it for
  theirs, C#'s with each payload type the bus registry makes, Haskell's with
  each bus channel's
  payload and each HTTP operation's reply, which `Required.Event` derives
  for every reader of a channel's events. `Required.Go` holds it to the
  types the `go-types` group declares.
- `unicode-case`: the code points Unicode gives the Cased and the
  Case_Ignorable property, for the C#, Kotlin and Go SDKs, whose runtimes
  give neither. `Ucd` reads them from Unicode's own
  `DerivedCoreProperties.txt`, which [`ucd/`](ucd) holds;
  `Unicode_case.Kotlin`, `Unicode_case.Csharp` and `Unicode_case.Go` write
  Kotlin's, C#'s and Go's range tables.
- `encodings`: the Encoding Standard's labels, its single-byte encodings and
  the encodings whose labels are refused, from `text/encoding-cases.json`,
  for the readers of a resource's text whose platform lacks them.
  `Encodings.Table` holds the table to its rules: an encoding is among its
  own labels, a label names one encoding and is one a reader can match, and
  a single-byte encoding is 256 characters. `Encodings.Go` and
  `Encodings.Python` write the labels and the single-byte encodings, and
  `Encodings.Typescript` the refused encodings, which the platform's
  `TextDecoder` decodes all the same.
- `error-codes`: the codes a client reports a failure under, from
  `errors/codes.json`, for the Go, Python, TypeScript, OCaml and Haskell
  SDKs. `Error_codes.Table` holds the table to the wire's own codes
  (`CommandError.code`), each restated once, and to its statuses: one per
  code, at most one open range, and every code but the unclassified one read
  from a status. `Error_codes.Go`, `Error_codes.Python` and
  `Error_codes.Typescript` write each vocabulary, the bus code a wire code
  becomes and the transport code a status becomes. `Error_codes.Haskell`
  writes every vocabulary, the control plane's with them, and discovery's
  absent reasons as one more.
- `timing`: the durations, retry budgets and counts a client waits and
  retries by, from `client/timing.json`, for the Go, Python, TypeScript,
  OCaml and Haskell SDKs. `Timing.Table` holds each entry to the kind its name says (a name
  ending in Ms is a duration, in Retry a budget, in Count a count), states
  each once, and holds a budget's backoff at or below its ceiling.
  `Timing.Go`, `Timing.Python` and `Timing.Typescript` write each SDK's
  constants; `Timing.Haskell` writes Haskell's, and the settings
  `Xynolog.Timing.Settings` overrides.
- `cache-refresh`: what a client's live queries hold, and what each event on
  the bus, the reopening of a dropped stream and an event that cannot be read
  does to them, from `client/refresh.json`, for the Go, Python, TypeScript
  and Haskell SDKs. `Cache_refresh.Table` holds the table to the registry's
  operations, the gateway's GETs, the component each query's value names and
  each channel's events: each way to what a row names ends at the component
  its slot is, and a row a passing frame triggers only refetches what
  `reopened` refetches too. `Cache_refresh.Go`, `Cache_refresh.Python`,
  `Cache_refresh.Typescript` and `Cache_refresh.Haskell` write each SDK's
  table, Haskell's with the live conformance driver's queries;
  `Cache_refresh.Csharp` the name of each query, which the C# SDK's live
  queries are keyed by.
- `identifiers`: the kinds of id, from `identifiers/kinds.json` and each
  kind's schema, for the Go, Python and TypeScript SDKs: a type of its own
  per kind, made only through the kind's pattern. `Identifiers.Table` holds
  each kind to a string schema with a pattern.
- `oauth-clients`: the client ids a client signs in as and the scope it asks
  for, from `session/oauth.json`, for the Go, Python, TypeScript, OCaml and
  Haskell SDKs. A client is named in lowercase letters, once.
- `telemetry`: every span and metric an SDK's transports export, from
  `sdk-telemetry/telemetry.json`, for the Go, Python, OCaml and Kotlin SDKs;
  the name of each, for the TypeScript, C#, Haskell and Rust SDKs, whose
  transports name each by it; and every attribute key, for those and Swift.
  A span's kind
  is one of OTLP's, a metric a counter, a span's name holds no placeholder
  but `{channel}`, and no two rows or keys are one Go or Python name.
- `sign-in`: the sign-in store's entry, from `sign-in-store/SignIn.json`, and
  how its directory and files are kept to their owner, from
  `sign-in-store/owner-only.json`, for the Go, Python, TypeScript, OCaml and
  Haskell SDKs; TypeScript's and Haskell's with the names
  `sign-in-store/README.md` gives the store's files, and Haskell's native
  binding with the one byte of the lock file a Windows writer locks. `Sign_in.Flat` holds the entry to a flat schema (every property a
  described string, some of them a date-time), `Sign_in.Owner_only` each
  mode to four octal digits and each access list to one place for the owner,
  and `Sign_in.Contract` the README to one name for each.
- `media-types`: the types a knowledge base admits and what can be done with
  each, from `media-types/registry.json`, for the Go, Python, TypeScript and
  Haskell SDKs, Haskell's beside the Encoding Standard's labels. A row is a
  base media type stated once, with an extension, a label and a word of each
  vocabulary; an alias is another spelling of a row's extension; and the rows
  are the `SupportedMediaType` enum's members, no more and no fewer.
- `stored`: what a client keeps for its person, from `session/stored.json`,
  for the Python and Haskell SDKs: the store's keys and prefixes, an open
  resource, the last event ids, the cache document, and the queries a client
  keeps, which are the refresh table's persisted queries, by the identifier
  each is keyed by. The stored session is a table record (`Table_records`),
  which each SDK's types write. A key is a camel-case `…Key` stated once, and no key begins with a
  prefix; a cache document is a version and its entries, each a key, a value
  and a whole-number stamp.
- `locales`: every language an SDK's interface speaks, from
  `locales/registry.json`, for the TypeScript SDK. A code is two or three
  lower-case letters stated once, with a native and an English name.
- `job-storage`: the stream, subjects, consumer and bucket jobs are kept in,
  from `jobs/storage.json`, with the `JobType` enum and the motivations
  `MarkJobParams` is told apart by, for the TypeScript SDK.
- `limits`: each gateway operation's `x-xynolog-limits` and each component
  property's `maxItems`, from `openapi.json`, for the TypeScript SDK.
- `worker-channels`: each constant of `client/surface.json` that is the
  channels a stream names (`jobClaimChannels`, `jobCommitChannels`), each
  operation's result and failure channel from `bus/registry.json` then each
  other channel, for every SDK but Haskell, whose `haskell-sdk` group writes
  them from the same resolution.
- `connection-states`: each state of a client's stream with the states it
  moves to, from `client/connection-states.json`, over each SDK's generated
  `ConnectionState`, for the Go, Python, Rust, TypeScript, Kotlin and Swift
  SDKs; the `haskell-sdk` group writes Haskell's from the same table.
- `client-types`: the shapes an SDK hands its callers that no wire message
  carries, from `client/types`, and the form a service account posts with a
  client secret, from `session/ClientSecretForm.json`, for the Haskell SDK:
  the reconciled span's and the sign-in's types as the `haskell-sdk` group
  reads them, the pending annotation's and the search state's records, the
  events a delegation and an upload report, and the secret proof. A type is
  words, an object's members (with those of each type it is all of) or a
  union told apart by one member, and a member is a scalar, a word of an
  enum, another schema, an open list or an object stated in place; anything
  else is refused. The secret proof's grant is the client assertion's.
- `testing`: the testing kit's facts, from `client/testing.json`, for the
  Haskell and OCaml SDKs: the faults, the bounds they and a schedule are
  drawn in, the slack, the delivery steps and, for Haskell, the kit's
  records, each member of the Haskell type the writer gives it. A member
  the table has and the writer types not, or the reverse, is refused.
- `ocaml-sdk`: the OCaml SDK's modules that no other group's table owns: the
  string enums, the selector and the records of the component schemas, what
  its HTTP transport says, the bus's channels and the namespace methods that
  are one channel or operation each, and the facts of tables no group writes
  for it, with the repository's `LICENSE`, which its package ships. The
  `required`, `identifiers`, `timing`, `error-codes`, `cache-refresh`,
  `encodings`, `oauth-clients`, `telemetry`, `sign-in` and `media-types`
  groups each write the OCaml SDK's module of their own table.
- `case-data`: each table an SDK's tests run or read, as typed values of the
  model Protocol's reader derives from its schema
  (`Xynolog_protocol_model`), and each schema they read, as its JSON, in the
  SDK's test tree: the OCaml SDK's `test/cases`, the `Protocol_cases`
  library, and, for each TypeScript package whose tests read it,
  `src/__tests__/cases` of that package, whose `rootDir` its `src/` is. A
  row the model does not describe is refused by its JSON
  Pointer. It writes data alone: a test keeps its own loop, which says how a
  row becomes a call on the SDK, so an SDK's tests read no file of Protocol,
  and a change to a table's shape is a compile error in each SDK that runs
  it. An SDK it has no writer for yet reads Protocol's tables where the
  checkout holds them.
- `swift-sdk`: the Swift SDK's `Generated/Models.swift`, a model of every
  component schema and the sign-in store's entry with the tables as typed
  values, and its tests' `Generated/TestBridge.swift`, a round trip through
  each model by its schema's name. `Swift_sdk.Models` declares the schemas,
  `Swift_sdk.Table_decls` the tables, from the other groups' derivations
  where they hold the same data, and `Swift_sdk.Spec_values` the tables
  Swift holds as Protocol writes them, which the census holds to Protocol's
  own members; and its `Generated/ServiceTables.swift`, each of the
  services' tables (`Roots.service_tables`) as its schema's model, read
  from the table's text.
- `haskell-sdk`: the Haskell SDK's modules that no other group's table owns:
  a model of every schema it reads or writes, from the gateway's components,
  the client registry's records, the stored session's, the HTTP routes'
  bodies and the bus's envelopes, each `allOf` merged into one object, a
  module per cycle of references, with `Xynolog.Types`, the schemas it
  validates against, each `allOf` in them merged, and the round trips its
  tests drive; its HTTP routes and
  what a refused credential is, from the reference transport; its
  transport's facts, from `TRANSPORT-HTTP.md`; its bus's channels and
  operations, with each operation's failure; the worker's channels and
  records, from `typescript/sdk/src/claims.ts`; the facts of tables no group
  writes for it; and its manifest, with the repository's `LICENSE`. A
  schema that states a keyword the SDK's validator does not read is refused,
  as is a model module no schema makes any more. The `error-codes`, `timing`,
  `cache-refresh`, `oauth-clients`, `sign-in`, `media-types`, `stored`,
  `client-types`, `testing`, `required` and `unicode-case` groups each write
  the Haskell SDK's module of their own table.
- `csharp-sdk`: the C# SDK's models of the component schemas, of the
  schemas it reads beside them and of the records Protocol states in its
  tables (`Table_records`), each with its converter
  (`Csharp_sdk.Models`), every schema they are made from as the SDK
  validates a value against it, the code each of the wire's failure codes
  becomes, and the tables the SDK reads as Protocol writes them. The `bus`,
  `required`, `unicode-case` and `identifiers` groups each write the C#
  SDK's file of their own table. `Csharp_syntax` is the C# they are built
  of, laid out as `dotnet format` leaves it.
- `kotlin-sdk`: the Kotlin SDK's types of the component schemas and of the
  sign-in store's entry, a file each under `xynolog/types`, and the kinds of
  id in `xynolog/identifiers` (`Kotlin_sdk.Types`), in
  `kotlin/sdk/src/generated/kotlin`; a file there that no schema writes is
  refused. The `bus`, `required`, `unicode-case`, `encodings`,
  `error-codes`, `timing`, `cache-refresh`, `oauth-clients`, `telemetry`,
  `sign-in` and `media-types` groups each write the Kotlin SDK's file of
  their own table. `Kotlin_syntax` is the Kotlin they are built of, laid out
  as ktlint leaves it.
- `go-types`: the Go SDK's package `api` (`go/api/types_gen.go`), a type for
  every component schema, every record Protocol states in its tables
  (`Table_records`), and every schema they reach but the kinds of id, which
  `identifiers` writes. A union embeds the hand-written generic
  `union` (`go/api/union.go`); `Go_syntax` is the Go it is built of, laid out
  as gofmt leaves it. It reads the schemas as Rust's types do, through `View`
  (a `$ref`'s schema, a union's members) and `Definitions.meant` (an `allOf`
  as `Normalize` merges it), and names what it writes in place by `Naming`.
- `typescript-types`: the TypeScript SDK's `components['schemas']`
  (`typescript/core/src/types.ts`), each component schema as a type written
  as the schema states it, and each kind of id branded. `Typescript_syntax`
  is the TypeScript it is built of, and Prettier lays it out.
- `python-types`: the Python SDK's `xynolog/types.py`, a frozen `WireModel`
  for every component schema and every record Protocol states in its tables
  (`Table_records`), with every schema they reach, that is an object, and a
  type alias for every other, but the kinds of id, which it imports from
  `xynolog.identifiers`. A
  model states types and no rules: what a value must be beyond its type is
  the `required` table's. What a schema writes in place is named by
  `Naming`, and each declaration follows every one it names, so pydantic
  builds each model as the module runs. `Python_syntax` is the Python it is
  built of.
- `contracts`: [`CONTRACTS.md`](../CONTRACTS.md), every kind of contract
  the pinned Protocol states, how many items it has, and how many of them
  each SDK declares. `Contracts` counts them in what the other groups write,
  by the name each writer gives an item, and in the SDK's own files where
  the SDK writes a kind by hand. A declaration counts, and a literal counts
  only as a member of the named type that holds its vocabulary (a
  TypeScript union or record, a Python `Literal`), never as a string
  anywhere in a file.

### cli's groups

cli's launcher (`xynolog/cli`) validates what it reads against Protocol's
schemas and reads it through Go types of their shape. `lib/cli/` writes
them, into a cli checkout, from the Protocol that checkout pins:

- `control`: the control API's types and the schemas a control message is
  read against, from `control/methods.json`, with the control group of
  `errors/codes.json` (`internal/launcher/control_*_gen.go`).
- `stack`: the stack's documents' types and their schemas, from `stack/`
  and `kb-identity/ProjectConfig.json` (`internal/launcher/stack/*_gen.go`).
- `mcp-tools`: the tools `xynolog mcp` serves, each with self-contained
  input and output schemas, from cli's own `internal/launcher/verbs/mcp-tools.json`,
  which `Cli.Mcp_tools_table` reads strictly, and the components it names
  (`internal/launcher/verbs/mcp_tools_gen.go`).

A type states a schema's shape and none of its rules, which are the
validator's; a schema is embedded as Protocol writes it. A schema the Go
SDK declares a type for (a component, or a discovery document) is that
type, `api.X`, named as `go-types` names it (`Cli.Schemas.api_type`), so
the launcher restates none of the SDK's types. `test/cli_groups.exe` runs
the groups against the Protocol sdk pins, with a table of every mcp-tools
form, and holds the table's refusals; cli's own drift gate holds the files
to what cli commits.

cli runs the generator the SDK bundle carries (`make codegen`), at the sdk
commit its `sdk.lock` pins, against its own checkout:
`xynolog-codegen generate cli ROOT`. The binary is linked statically, so
it runs in any Linux container.

### images' groups

images' services (`xynolog/images`) embed and serve Protocol's documents
whole, and read every schema through the Rust SDK's types
(`xynolog::types`), which declare one for each schema Protocol states.
`lib/images/` writes the documents and the archivist's waits, into an
images checkout, from the Protocol that checkout pins:

- `bundles`: the gateway's and the archivist's OpenAPI documents, as the
  reader bundles them (`Bundle`), and the gateway's component schemas and
  the services' as JSON Schema draft 7 (`Documents.definitions`)
  (`packages/rust/core/src/generated/`).
- `archivist-waits`: how long a service waits on the archivist to connect
  and to answer, from `archivist/openapi.json`
  (`shared/python/service/src/xynolog_service/_archivist_waits.py`).

The reader bundles the files as JSON, not through the model, so a document
keeps every member Protocol writes; a service serves it as it is. What
else images' services once took from a table of their own (each channel's
attributes, the job queue's stream and bucket) is the Rust SDK's
(`channels`, `job_storage`). `test/images_groups.exe` runs the groups
against the Protocol sdk pins; images' own drift gate holds the files to
what images commits, running `xynolog-codegen generate images ROOT` as cli
does.

`Text` measures and spells text: a width in code points, a word ended by
ASCII white space, a string as JSON writes it or as a Go or Python literal
of printable ASCII, a camel-case name in upper or lower snake case, and a
comment as Go, Python and TypeScript write one. `Ocaml_syntax` builds an
OCaml module as compiler-libs' Parsetree, prints it with Pprintast and lays
it out with ocamlformat-lib, so a generated module is one the SDK's
`dune build @fmt` leaves as it is. `Python_layout` lays a Python
statement out as ruff's formatter does at the SDK's line length, so a
generated module is one `ruff format` leaves as it is. `Swift_syntax` is
the Swift a writer builds, printed as swift-format 6.4.2 lays it out under
`swift/sdk/.swift-format` through `Swift_layout`, so a generated Swift file
is that formatter's fixed point. `Banner` is the line
each generated file opens with, naming the module that writes it; a
generated Python module also names the lint rules it is exempt from (a long
line, an ambiguous character, the order of its imports and of its `__all__`,
and an exemption it does not use), and every other rule holds it. `Output` is
the drift gate.

## Coverage

Protocol's tables name no consumer: which SDK runs or has what Protocol
states is sdk's to record, so renaming a test, or an SDK gaining an item of
the client surface, is a change here alone. [`lib/coverage_sdk.ml`](lib/coverage_sdk.ml)
names the SDKs the records speak of.

- [`lib/case_coverage.ml`](lib/case_coverage.ml): for each case table of
  the pinned Protocol and each SDK, the tests that run it, or why the SDK
  runs none: absent, where the SDK has no counterpart of what the table
  states, or not yet reached, where it has one and does not run the table
  yet. A test named there runs every case of its table.
- [`lib/test_reads.ml`](lib/test_reads.ml): the files of Protocol other
  than its case tables that each SDK's tests read, tables and schemas,
  which `case-data` writes for them too, each with the tests that read it.
- [`test/surface_coverage.ml`](test/surface_coverage.ml): each item of the
  client surface (`client/surface.json`) some SDK lacks, with each SDK that
  lacks it and why: absent, or not yet reached. An item it does not name is
  one every SDK has.

`coverage_census.exe` holds them. Its case tables are the model's tables
whose file name ends in `cases.json` (`specs/README.md`, "Case tables"), and
it names each of them and no other. Its SDKs are the Makefile's `LANGUAGES`,
and the compiler holds every table to a coverage for each one. A named test
is a file this checkout has under the SDK's directory, and it names the
module `case-data` writes its table's rows to, or, for an SDK the group has
no writer for, its table's path; so is each test `test_reads.ml` names, of
the module its table or schema is written to. `case-data` writes a module
for the tests named so and no other, so each module it writes is read,
and each directory it writes holds no module it does not write.
Every surface item named is one the
surface has, named once, and each SDK lacking it once; that an SDK has an
item named nowhere is its own surface test's to hold. The readers
`annotations/reader-cases.json` names are the annotations module's readers
that no SDK lacks.

## Running it

```sh
make test-codegen
```

builds the project, checks its formatting, runs its tests, and reads the
pinned Protocol with `xynolog-codegen read`, in the toolchain's container.
`coverage_census.exe` holds the coverage records to the pinned Protocol
and to the checkout. `boundary_census.exe` holds the imports between
generated and hand-written modules in TypeScript's core and Python's SDK to
one direction: no base module a generated one imports at run time comes back
to it, and the generated modules are those the groups write.
`protocol_paths_census.exe` holds every sdk file the pinned Protocol names,
as `sdk/<path>` or as a link into this repository, to the files this checkout
has. `contracts_census.exe` holds every SDK to every item of every contract
`CONTRACTS.md` counts, and names each item an SDK does not declare.

```sh
make generate
make check-generated
```

run every group of this repository (`xynolog-codegen generate sdk`).
`xynolog-codegen generate` writes each OCaml group's files
into the checkout, a TypeScript file as it prints it, and Prettier then lays
those out, at the version `typescript/package.json` pins. check-generated
does the same in a copy of the checkout and fails when a file the generator
names differs from the committed one.

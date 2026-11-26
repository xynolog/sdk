(* The required group: what each root schema ([Roots])
   requires of a value, the
   table every SDK holds a reply to before it reads it. Shape derives it, and
   Event what an event on each bus channel is; Table, Typescript, Python,
   Haskell, Ocaml and Kotlin write it; Go holds it to what package api
   declares. *)

module Shape = Shape
module Event = Event
module Table = Table
module Typescript = Typescript
module Python = Python
module Haskell = Haskell
module Go = Go
module Ocaml = Ocaml
module Kotlin = Kotlin
module Csharp = Csharp
module Rust = Rust

let refusal file pointer message = { Decode.file; pointer; message }

(* A schema as the table reads it: each file it refers to that no generation
   names written in its place ([Schema_names.in_place]), and each schema
   within it that closes what it composes read as the one object it means
   ([Normalize.closed_within]). *)
let whole (spec : Spec.t) =
  let in_place = Schema_names.in_place spec in
  let find =
    Definitions.schema_of ~ids:spec.ids
      ~schemas:(Hashtbl.of_seq (List.to_seq spec.schemas))
  in
  fun schema ->
    Result.bind (in_place schema) (Normalize.closed_within spec.ids ~find)

(* Each root ([Roots]): its name, its file and its schema, read whole
   ([whole]). *)
let components (spec : Spec.t) =
  let in_place = whole spec in
  List.map
    (fun (name, (reference : Decode.reference)) ->
      match Decode.resolve spec.Spec.ids reference with
      | file, "" -> (
          match List.assoc_opt file spec.schemas with
          | Some schema ->
              Result.map_error (refusal file "")
                (Result.map
                   (fun schema -> (name, file, schema))
                   (in_place schema))
          | None ->
              Error
                (refusal reference.file reference.pointer
                   (Printf.sprintf "names %s, which is no JSON Schema"
                      reference.target)))
      | _ ->
          Error
            (refusal reference.file reference.pointer
               (Printf.sprintf "names %s, a place within a file"
                  reference.target)))
    (Roots.all spec)

(* Each table record ([Table_records]), by its title, read where the table
   states it; each client type every SDK generates
   ([Definitions.generated_client_types]), by its file's stem; and why a
   client found no launcher (client/discovery-absent.json), as the one text
   of its reasons each SDK states it as. *)
let records (spec : Spec.t) =
  let in_place = whole spec in
  let read (title, file, schema) =
    Result.map_error (refusal file "")
      (Result.map (fun schema -> (title, file, schema)) (in_place schema))
  in
  let file_of key =
    match String.index_opt key '#' with
    | Some at -> String.sub key 0 at
    | None -> key
  in
  let client_types =
    List.map
      (fun name ->
        let file = Roots.client_types ^ name ^ ".json" in
        match List.assoc_opt file spec.schemas with
        | Some schema -> read (name, file, schema)
        | None -> Error (refusal file "" "is no JSON Schema"))
      (Definitions.generated_client_types spec)
  in
  let discovery_absent =
    Ok
      ( "DiscoveryAbsentReason",
        "client/discovery-absent.json",
        Schema.Schema
          {
            Schema.empty with
            type_ = Some [ Schema.String ];
            enum =
              Some
                (List.map
                   (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                     Schema.String_literal r.reason)
                   spec.tables.client_discovery_absent.reasons);
          } )
  in
  match Table_records.all spec with
  | Error message -> [ Error (refusal "" "" message) ]
  | Ok records ->
      List.map
        (fun (key, title, schema) -> read (title, file_of key, schema))
        records
      @ client_types @ [ discovery_absent ]

(* Each gateway operation's reply: the schema of its one successful
   response's one content, by its operationId, capitalized. *)
let replies (spec : Spec.t) (derivation : Shape.t) =
  List.concat_map
    (fun (_, (reference : Decode.reference)) ->
      let file, _ = Decode.resolve spec.Spec.ids reference in
      let item = List.assoc file spec.path_items in
      List.filter_map
        (fun (method_, operation) ->
          Option.map
            (fun (operation : Openapi.operation) ->
              let at = "/" ^ method_ in
              let name = String.capitalize_ascii operation.operation_id in
              match
                List.filter
                  (fun (status, _) -> String.starts_with ~prefix:"2" status)
                  operation.responses
              with
              | [
               ( status,
                 Openapi.Inline { content = Some [ (media, content) ]; _ } );
              ] ->
                  Result.map
                    (fun shape -> (name, shape))
                    (derivation.inline ~file
                       ~pointer:
                         (Printf.sprintf "%s/responses/%s/content/%s/schema" at
                            status (Shape.token media))
                       content.schema)
              | [ (status, Openapi.Inline _) ] ->
                  Error
                    (refusal file
                       (at ^ "/responses/" ^ status)
                       "is a success with no one content to hold a reply to")
              | [ (status, Openapi.Ref _) ] ->
                  Error
                    (refusal file
                       (at ^ "/responses/" ^ status)
                       "is a success stated elsewhere, which the table does \
                        not read")
              | _ ->
                  Error
                    (refusal file (at ^ "/responses")
                       "states no one success to hold a reply to"))
            operation)
        [ ("get", item.get); ("put", item.put); ("post", item.post) ])
    spec.gateway.paths

let collect results =
  List.fold_right
    (fun result collected ->
      match (result, collected) with
      | Ok value, Ok values -> Ok (value :: values)
      | Ok _, Error errors -> Error errors
      | Error error, Ok _ -> Error [ error ]
      | Error error, Error errors -> Error (error :: errors))
    results (Ok [])

(* Each root schema and each table record, with its file. *)
let roots (spec : Spec.t) = collect (components spec @ records spec)

(* What each of [roots] requires, by its name. *)
let derive_roots (spec : Spec.t) roots =
  Result.bind
    (Error_codes.Table.derive ~rpc_codes:spec.tables.control_rpc_codes
       spec.tables.errors_codes) (fun codes ->
      Shape.derive ~ids:spec.ids
        ~unrecognized:spec.tables.errors_codes.bus_request.unrecognized_failure
        ~vocabularies:(Error_codes.Table.vocabularies codes)
        roots)

(* What each root schema and each table record requires, by its name. *)
let derive (spec : Spec.t) = Result.bind (roots spec) (derive_roots spec)

let files ~root (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* derivation = derive spec in
  let shapes = derivation.shapes in
  let known name = List.mem_assoc name shapes in
  let* channels =
    collect
      (List.map
         (fun (c : Tables.Bus_registry.channels_item) ->
           Result.map
             (fun shape -> (Bus.Registry.name c, shape))
             (Event.channel ~known c))
         spec.tables.bus_registry.channels)
  in
  let* http = collect (replies spec derivation) in
  let* csharp = Csharp.file derivation spec.tables.bus_registry in
  match Go.check ~declared:(Go_types.declared spec) shapes with
  | [] ->
      let* kotlin =
        Kotlin_sdk.written ~from_:"openapi.json" (fun () -> Kotlin.file shapes)
      in
      Ok
        ([
           Table.file shapes;
           Typescript.file shapes;
           Python.file shapes;
           Haskell.file ~shapes ~channels ~http;
           Rust.file shapes;
           kotlin;
           csharp;
         ]
        @ Ocaml.files shapes)
  | refusals -> Error refusals

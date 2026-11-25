(* The Kotlin SDK's tables as the generator writes them, and what each writer
   refuses that no group's derivation does. A refusal a derivation makes is
   that group's to test: a union whose members declare different stamps, and
   an operation's channel on a resource's scope, in groups.ml (the bus
   registry's); a query persisted false, one with no value and one whose
   value is no component nor named member by member, in cache_refresh.ml. *)

open Xynolog_codegen
module Types = Kotlin_sdk.Types
module Refresh = Cache_refresh.Table

let case name test = Alcotest.test_case name `Quick test
let holds ~sub text = List.length (Text.split ~sub text) > 1

let contains ~sub text =
  if not (holds ~sub text) then Alcotest.failf "expected\n%s\nin\n%s" sub text

let schema_of text =
  match
    Decode.run ~file:"schema.json" (Yojson.Safe.from_string text) Schema.decode
  with
  | Ok (schema, _) -> schema
  | Error error -> Alcotest.fail (Decode.error_to_string error)

(* What [write] refuses, which must say [sub]. *)
let refuses ~sub write =
  match write () with
  | _ -> Alcotest.failf "expected a refusal saying %s" sub
  | exception Kotlin_sdk.Names.Refused message -> contains ~sub message

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

(* The Kotlin types of [schemas], each a component of that name. *)
let types schemas =
  Types.spec
    [
      Typing.make
        (Fixture.definitions schemas)
        ~roots:(List.map fst schemas) ~identifiers:[] ~keys:[];
    ]

(* ── The channels ──────────────────────────────────────────────────────── *)

let channel name schema =
  Printf.sprintf
    {|{"channel":%S,"shape":"schema","schema":%S,"validate":%S,"docs":{"lead":[],"trailing":""},"schemaDocs":{"lead":[],"trailing":""}}|}
    name schema schema

(* A registry of one limits operation and the events [events], each a channel
   and its payload's schema, which every client hears. *)
let registry events =
  let names = List.map fst events in
  let quoted list = String.concat "," (List.map (Printf.sprintf "%S") list) in
  let operation =
    [ "demo:limits-requested"; "demo:limits-result"; "demo:limits-failed" ]
  in
  Yojson.Safe.from_string
    (Printf.sprintf
       {|{"$comment":"c",
          "channelOrder":{"eventMap":[%s],"schemas":[]},
          "channels":[%s],
          "operations":[{"request":"demo:limits-requested","result":"demo:limits-result","failure":"demo:limits-failed","answeredBy":"archivist","docs":{"lead":[],"trailing":""}}],
          "docs":{"eventName":["P."],"enrichedEvents":["P."],"channelSchemas":["P."],"emittableChannel":["P."]},
          "inProcess":{"doc":["P."],"channels":[]},
          "kind":{"doc":["P."],"command":[],"event":[%s]},
          "audience":{"doc":["P."],"everyone":[%s],"scoped":[],"declared":[]},
          "effect":{"doc":["P."],"writes":["demo:limits-requested"],"reads":[]},
          "trace":{"meaning":"Where a relayed frame carries its trace.","field":"_carried"},
          "stamps":{"meaning":"The members of a payload the gateway writes.","emitter":"_userId","roles":"_roles"}}|}
       (quoted (operation @ names))
       (String.concat ","
          (List.map2 channel operation
             [ "DemoRequest"; "DemoResult"; "CommandError" ]
          @ List.map (fun (name, schema) -> channel name schema) events))
       (quoted names) (quoted names))

let object_schema = {|{"type":"object"}|}

let schemas =
  [
    ("DemoRequest", object_schema);
    ("DemoResult", object_schema);
    ("CommandError", object_schema);
    ( "A",
      {|{"type":"object","required":["kind"],"properties":{"_userId":{"type":"string"},"kind":{"type":"string","enum":["a"]}}}|}
    );
    ( "B",
      {|{"type":"object","required":["kind"],"properties":{"kind":{"type":"string","enum":["b"]}}}|}
    );
    ("Either", {|{"oneOf":[{"$ref":"./A.json"},{"$ref":"./B.json"}]}|});
  ]

(* The Channels.kt of a registry of [events], whose payloads are of
   [schemas]: written when it is called. *)
let channels_file ?(schemas = schemas) events () =
  match
    Decode.run ~file:Bus.Registry.file (registry events)
      Tables.Bus_registry.decode
  with
  | Error error -> Alcotest.fail (Decode.error_to_string error)
  | Ok (reg, _) -> (
      let component name = Option.map schema_of (List.assoc_opt name schemas) in
      match Bus.Registry.derive ~ids ~component ~user_field:"_userId" reg with
      | Error errors ->
          Alcotest.fail
            (String.concat "\n" (List.map Decode.error_to_string errors))
      | Ok bus ->
          (Bus.Kotlin.channels_file ~component ~types:(types schemas) bus).text)

let channels =
  [
    case "a channel carries the stamps its payload declares" (fun () ->
        let text = channels_file [ ("x:a", "A"); ("x:b", "B") ] () in
        contains
          ~sub:{|Channel<A> = Channel("x:a", A.serializer(), setOf("_userId"))|}
          text;
        contains
          ~sub:{|Channel<B> = Channel("x:b", B.serializer(), emptySet())|} text);
    case "a payload named as a type of xynolog.channels is refused" (fun () ->
        refuses
          ~sub:
            "x:response carries Response, which xynolog.channels names a type \
             of its own"
          (channels_file
             ~schemas:(("Response", object_schema) :: schemas)
             [ ("x:response", "Response") ]));
  ]

(* ── The refresh table ─────────────────────────────────────────────────── *)

let refresh_schemas =
  [
    ( "A",
      {|{"type":"object","properties":{"m":{"type":"array","items":{"type":"string"}},"n":{"type":"object","properties":{"o":{"type":"string"}}}}}|}
    );
    ("B", {|{"type":"object","properties":{"n":{"type":"string"}}}|});
  ]

let query ?per ?(persisted = true) ?(members = []) ~component name :
    Refresh.query =
  (* The type the derivation gives a value is the other SDKs'; the Kotlin
     types type it again. *)
  {
    name;
    docs = String.capitalize_ascii name ^ ".";
    per;
    persisted;
    value = { component; members; type_ = Text };
  }

let held name kind : Refresh.trigger =
  {
    name;
    kind;
    docs = "";
    rows =
      [
        {
          when_ = None;
          reach = Held;
          resource = None;
          annotation = None;
          carries = None;
          refetches = [];
          writes = [];
          removes = [];
        };
      ];
  }

let refresh_file queries =
  (Cache_refresh.Kotlin.file ~types:(types refresh_schemas)
     {
       queries;
       triggers = [ held "reopened" Reopened; held "unreadable" Unreadable ];
     })
    .text

let refresh =
  [
    case
      "the queries a client keeps, in the table's order, each by its key and \
       value" (fun () ->
        let text =
          refresh_file
            [
              query ~per:Resource ~component:"B" "b";
              query ~per:Filters ~persisted:false ~component:"B" "c";
              query ~members:[ "m" ] ~component:"A" "a";
            ]
        in
        contains ~sub:"    val b: Cache<ResourceId, xynolog.types.B>\n" text;
        contains
          ~sub:"    val a: Cache<String, kotlin.collections.List<String>>\n"
          text;
        if holds ~sub:"val c:" text then Alcotest.failf "c is kept:\n%s" text;
        contains
          ~sub:
            "internal val PERSISTED_QUERIES: List<KeptQuery<*, *>> = listOf(\n\
            \    KeptQuery(CacheQuery.B, ResourceId.serializer(), \
             serializer<xynolog.types.B>(), KeptCaches::b),\n\
            \    KeptQuery(CacheQuery.A, WholeKeySerializer, \
             serializer<kotlin.collections.List<String>>(), KeptCaches::a),\n\
             )\n"
          text);
    case "a persisted query kept per filters is refused" (fun () ->
        refuses ~sub:"a is persisted, and kept per filters" (fun () ->
            refresh_file [ query ~per:Filters ~component:"B" "a" ]));
    case "a persisted value that is no one member of its component is refused"
      (fun () ->
        refuses
          ~sub:"a is persisted, and its value n.o names no one member of A"
          (fun () ->
            refresh_file [ query ~members:[ "n"; "o" ] ~component:"A" "a" ]));
  ]

let () =
  Alcotest.run "kotlin tables" [ ("channels", channels); ("refresh", refresh) ]

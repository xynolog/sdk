(* The telemetry group: every span and metric an SDK's transports export
   (protocol/specs/src/sdk-telemetry/telemetry.json), its kind or instrument,
   what it means, and its attributes, for the Go, Python, OCaml and Kotlin
   SDKs; the name of each, for the TypeScript, C#, Haskell and Rust SDKs; and
   every attribute key a row lists, for those and the Swift SDK, whose SDK
   group writes its spans and metrics.

   A metric's instrument is a counter, and a span's name holds no placeholder
   but {channel}. A row says what it means and lists each attribute once;
   those not marked `only` are the ones every one carries. No two rows, nor
   two attribute keys, are the same Go or Python name. *)

module T = Tables.Sdk_telemetry_telemetry
module Kotlin = Kotlin

let file = "sdk-telemetry/telemetry.json"

type row = {
  name : string;
  kind : string;  (** A span's kind, or a metric's instrument. *)
  meaning : string;
  all : string list;
  always : string list;
}

type t = {
  spans : row list;
  metrics : row list;
  keys : string list;  (** Every attribute key a row lists, once, in order. *)
}

(* A dotted, underscored name as a Go identifier behind [prefix]:
   content.size_bytes is keyContentSizeBytes. *)
let go_identifier prefix name =
  prefix
  ^ String.concat ""
      (List.map
         (fun word ->
           if word = "id" then "ID" else String.capitalize_ascii word)
         (String.split_on_char '_'
            (String.map (function '.' -> '_' | c -> c) (Channel.without name))))

(* The words of an attribute key: content.size_bytes is content, size and
   bytes. Every SDK names a key by them, so two keys of the same words would
   be one name in each; the Go names refuse them. *)
let key_words key =
  String.split_on_char '_' (String.map (function '.' -> '_' | c -> c) key)

let key_pascal key =
  String.concat "" (List.map String.capitalize_ascii (key_words key))

let key_upper key = String.uppercase_ascii (String.concat "_" (key_words key))

(* A row's Python constant: its name, without what stands for the channel, in
   upper snake case, each run of what is not a letter or digit an
   underscore. *)
let python_constant name =
  let out = Buffer.create 32 in
  String.iter
    (fun c ->
      match c with
      | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' -> Buffer.add_char out c
      | _ ->
          if
            Buffer.length out = 0
            || Buffer.nth out (Buffer.length out - 1) <> '_'
          then Buffer.add_char out '_')
    (Text.upper_snake (Channel.without name));
  Buffer.contents out

let python_key key = "ATTR_" ^ key_upper key

let derive (table : T.t) =
  let refusals = ref [] in
  let refuse pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let row at ~name ~kind ~meaning keys =
    if name = "" then refuse (at ^ "/name") "is empty";
    if meaning = "" then refuse (at ^ "/meaning") "is empty";
    List.iteri
      (fun i (key, _) ->
        if key = "" then
          refuse (Printf.sprintf "%s/attributes/%d/key" at i) "is empty"
        else
          match List.find_index (fun (k, _) -> k = key) keys with
          | Some j when j < i ->
              refuse
                (Printf.sprintf "%s/attributes/%d/key" at i)
                (Printf.sprintf "is %s, which /attributes/%d states already" key
                   j)
          | _ -> ())
      keys;
    {
      name;
      kind;
      meaning;
      all = List.map fst keys;
      always =
        List.filter_map (fun (k, only) -> if only then None else Some k) keys;
    }
  in
  let spans =
    List.mapi
      (fun i (s : T.spans_item) ->
        let at = Printf.sprintf "/spans/%d" i in
        if String.contains (Channel.without s.name) '{' then
          refuse (at ^ "/name")
            (Printf.sprintf "is %s, which has a placeholder but %s" s.name
               Channel.placeholder);
        row at ~name:s.name
          ~kind:(T.service_telemetry_telemetry_kind_value s.kind)
          ~meaning:s.meaning
          (List.map
             (fun (a : T.service_telemetry_telemetry_attributes_item) ->
               (a.key, Option.is_some a.only))
             s.attributes))
      table.spans
  in
  let metrics =
    List.mapi
      (fun i (m : T.metrics_item) ->
        let at = Printf.sprintf "/metrics/%d" i in
        let instrument =
          T.service_telemetry_telemetry_instrument_value m.instrument
        in
        (match m.instrument with
        | Counter -> ()
        | Up_down_counter | Gauge | Histogram ->
            refuse (at ^ "/instrument")
              (Printf.sprintf "is %S, which is none of counter" instrument));
        row at ~name:m.name ~kind:instrument ~meaning:m.meaning
          (List.map
             (fun (a : T.service_telemetry_telemetry_attributes_item) ->
               (a.key, Option.is_some a.only))
             m.attributes))
      table.metrics
  in
  let distinct what names =
    let rec go seen = function
      | [] -> ()
      | n :: rest ->
          if List.mem n seen then
            refuse ""
              (Printf.sprintf "two of its names would be the %s %s" what n);
          go (n :: seen) rest
    in
    go [] names
  in
  let keys =
    List.sort_uniq compare (List.concat_map (fun r -> r.all) (spans @ metrics))
  in
  distinct "Go identifier"
    (List.map (fun r -> go_identifier "span" r.name) spans
    @ List.map (fun r -> go_identifier "metric" r.name) metrics
    @ List.map (go_identifier "key") keys);
  distinct "Python constant"
    (List.map (fun r -> python_constant r.name) (spans @ metrics)
    @ List.map python_key keys);
  match List.rev !refusals with
  | [] -> Ok { spans; metrics; keys }
  | errors -> Error errors

let go (t : t) =
  let module G = Go_syntax in
  let span_kind = function
    | "internal" -> "trace.SpanKindInternal"
    | "server" -> "trace.SpanKindServer"
    | "client" -> "trace.SpanKindClient"
    | "producer" -> "trace.SpanKindProducer"
    | _ -> "trace.SpanKindConsumer"
  in
  let row type_ doc prefix r fields =
    G.Var
      (G.spec ~doc:(G.prose doc)
         (go_identifier prefix r.name)
         (G.inline ~of_:(G.Named type_)
            (G.keyed "name" (G.Quoted r.name) :: fields)))
  in
  {
    Output.path = "go/telemetry_gen.go";
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from \
                protocol/specs/src/sdk-telemetry/telemetry.json — DO NOT \
                EDIT.\n\n\
                Regenerate: make generate (" ^ Banner.writer __FILE__
             ^ ")\nThe Python table is generated from the same table.");
          package = "xynolog";
          imports =
            [
              [
                "go.opentelemetry.io/otel/attribute";
                "go.opentelemetry.io/otel/trace";
              ];
            ];
          decls =
            [
              G.Const
                (G.spec
                   ~doc:
                     [
                       G.Line
                         "telemetryChannel stands for the bus channel in a \
                          span's name.";
                     ]
                   "telemetryChannel" (G.Quoted Channel.placeholder));
            ]
            @ List.map
                (fun r ->
                  row "telemetrySpan" r.meaning "span" r
                    [ G.keyed "kind" (G.Name (span_kind r.kind)) ])
                t.spans
            @ List.map
                (fun r ->
                  row "telemetryMetric"
                    (r.meaning ^ " A " ^ r.kind ^ ".")
                    "metric" r
                    [ G.keyed "meaning" (G.Quoted r.meaning) ])
                t.metrics
            @ [
                G.Comment [ G.Line "The attributes the rows carry." ];
                G.Adjacent
                  (List.map
                     (fun k ->
                       G.Const
                         (G.spec ~type_:(G.Named "attribute.Key")
                            (go_identifier "key" k) (G.Quoted k)))
                     t.keys);
              ];
        };
  }

let python (t : t) =
  let module P = Python_syntax in
  let literal values =
    P.sub "Literal"
      (List.map (fun v -> P.item (P.Str v)) (List.sort_uniq compare values))
  in
  let constant r = python_constant r.name in
  let row type_ field r =
    P.assign ~about:[ Prose r.meaning ] ~annotation:(P.Name "Final")
      ~value:
        (P.call ~magic:true type_
           [
             P.keyword "name" (P.Str r.name);
             P.keyword field (P.Str r.kind);
             P.keyword "attributes" (P.strings r.all);
             P.keyword "always" (P.strings r.always);
           ])
      (constant r)
  in
  let keys = P.sub "tuple" [ P.item (P.Name "str"); P.item P.Ellipsis ] in
  let table name type_ rows =
    P.assign
      ~annotation:
        (P.sub "Final"
           [
             P.item (P.sub "tuple" [ P.item (P.Name type_); P.item P.Ellipsis ]);
           ])
      ~value:
        (P.tuple ~magic:true
           (List.map (fun r -> P.item (P.Name (constant r))) rows))
      name
  in
  {
    Output.path = "python/sdk/src/xynolog/telemetry_table.py";
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:"protocol/specs/src/sdk-telemetry/telemetry.json" __FILE__;
          doc =
            As_is
              "The telemetry a Xynolog SDK's transports export, when the \
               process they run\n\
               in exports at all: every span and metric, its kind, and the \
               attributes it\n\
               carries.\n\n\
               The table is every SDK's: the conformance suite holds each to \
               it from outside.\n\
               A span's name may hold `{channel}`, which stands for the bus \
               channel.\n";
          imports =
            [
              [
                P.From ("dataclasses", [ "dataclass" ]);
                P.From ("typing", [ "Final"; "Literal"; "final" ]);
              ];
            ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List
                     (P.items ~magic:true
                        (List.map
                           (fun n -> P.item (P.Str n))
                           (List.sort compare
                              ([
                                 "METRICS";
                                 "SPANS";
                                 "Instrument";
                                 "MetricRow";
                                 "SpanKindName";
                                 "SpanRow";
                               ]
                              @ List.map constant (t.spans @ t.metrics)
                              @ List.map python_key t.keys)))));
              P.alias
                ~about:
                  [
                    Line
                      "The kinds of span the table states, by OTLP's names for \
                       them.";
                  ]
                "SpanKindName"
                (literal (List.map (fun r -> r.kind) t.spans));
              P.alias
                ~about:[ Line "The instruments the table states." ]
                "Instrument"
                (literal (List.map (fun r -> r.kind) t.metrics));
              P.frozen_dataclass "SpanRow" "A span an SDK exports."
                [
                  P.field "name" (P.Name "str");
                  P.field "kind" (P.Name "SpanKindName");
                  P.field "attributes" keys
                    ~doc:"Every attribute it may carry. It carries no other.";
                  P.field "always" keys
                    ~doc:"The attributes every one of them carries.";
                ];
              P.frozen_dataclass "MetricRow" "A metric an SDK exports."
                [
                  P.field "name" (P.Name "str");
                  P.field "instrument" (P.Name "Instrument");
                  P.field "attributes" keys
                    ~doc:
                      "Every attribute a data point of it may carry. It \
                       carries no other.";
                  P.field "always" keys
                    ~doc:"The attributes every data point of it carries.";
                ];
            ]
            @ List.map (row "SpanRow" "kind") t.spans
            @ List.map (row "MetricRow" "instrument") t.metrics
            @ [
                table "SPANS" "SpanRow" t.spans;
                table "METRICS" "MetricRow" t.metrics;
              ]
            @ List.map
                (fun k ->
                  P.assign ~annotation:(P.Name "Final") ~value:(P.Str k)
                    (python_key k))
                t.keys;
        };
  }

(* A row's or an attribute key's name in the OCaml SDK: the name without
   what stands for the channel, its dots underscores. *)
let ocaml_name name = Text.replace_all ~sub:"." ~by:"_" (Channel.without name)

(* The rows as the OCaml SDK names them (ocaml/sdk/lib/telemetry_facts.ml): a
   span's name, its channel left for the caller, and its kind; a metric's
   name; and every attribute key, each by its name with the channel and the
   dots dropped. *)
let ocaml (t : t) =
  let module O = Ocaml_syntax in
  O.implementation ~path:"ocaml/sdk/lib/telemetry_facts.ml"
    ~banner:(Banner.ocaml ~from_:file __FILE__)
    (List.map
       (fun (r : row) ->
         O.let_ (ocaml_name r.name)
           (O.tuple
              [
                O.string
                  (Text.replace_all ~sub:Channel.placeholder ~by:"" r.name);
                O.construct ("Telemetry." ^ String.capitalize_ascii r.kind);
              ]))
       t.spans
    @ List.map
        (fun (r : row) -> O.let_ (ocaml_name r.name) (O.string r.name))
        t.metrics
    @ List.map
        (fun key -> O.let_ ("attr_" ^ ocaml_name key) (O.string key))
        t.keys)

let about = "An attribute key a row of the telemetry table lists."

(* A row's name by the words of its name without what stands for the
   channel, which the name itself keeps, for the caller to put the Channel.placeholder
   in place of. *)
let row_pascal (r : row) = key_pascal (Channel.without r.name)
let row_upper (r : row) = key_upper (Channel.without r.name)
let span_constant r = "SPAN_" ^ row_upper r
let metric_constant r = "METRIC_" ^ row_upper r
let haskell_span r = "span" ^ row_pascal r
let haskell_metric r = "metric" ^ row_pascal r

let typescript_names (t : t) =
  let module T = Typescript_syntax in
  let row name (r : row) =
    T.const name ~about:[ Doc r.meaning ] (T.Str r.name)
  in
  {
    Output.path = "typescript/observability/src/telemetry-names.ts";
    text =
      T.text
        {
          banner =
            Banner.typescript_lines
              ~authority:[ "protocol/specs/src/" ^ file ]
              __FILE__;
          body =
            T.const "TELEMETRY_CHANNEL"
              ~about:[ Doc "What stands for the bus channel in a span's name." ]
              (T.Str Channel.placeholder)
            :: List.map (fun r -> row (span_constant r) r) t.spans
            @ List.map (fun r -> row (metric_constant r) r) t.metrics;
        };
  }

let typescript (t : t) =
  let module T = Typescript_syntax in
  {
    Output.path = "typescript/observability/src/telemetry-keys.ts";
    text =
      T.text
        {
          banner =
            Banner.typescript_lines
              ~authority:[ "protocol/specs/src/" ^ file ]
              __FILE__;
          body =
            List.map
              (fun k ->
                T.const ("ATTR_" ^ key_upper k) ~about:[ Doc about ] (T.Str k))
              t.keys;
        };
  }

let csharp (t : t) =
  let module C = Csharp_syntax in
  {
    Output.path = "csharp/sdk/src/Xynolog/Generated/TelemetryKeys.g.cs";
    text =
      C.text
        {
          header = Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog";
          decls =
            [
              C.Type
                {
                  attributes = [];
                  modifiers = [ Internal; Static ];
                  kind = Class;
                  name = "TelemetryKeys";
                  params = None;
                  base = None;
                  body =
                    Some
                      ( Packed,
                        List.map
                          (fun k ->
                            C.Field
                              {
                                modifiers = [ Internal; Const ];
                                type_ = C.T "string";
                                name = key_pascal k;
                                value = Some (C.Str k);
                              })
                          t.keys );
                };
            ];
        };
  }

let csharp_names (t : t) =
  let module C = Csharp_syntax in
  let constant name value =
    C.Field
      {
        modifiers = [ Internal; Const ];
        type_ = C.T "string";
        name;
        value = Some (C.Str value);
      }
  in
  let class_ name fields =
    C.Type
      {
        attributes = [];
        modifiers = [ Internal; Static ];
        kind = Class;
        name;
        params = None;
        base = None;
        body = Some (Packed, fields);
      }
  in
  {
    Output.path = "csharp/sdk/src/Xynolog/Generated/TelemetryNames.g.cs";
    text =
      C.text
        {
          header = Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog";
          decls =
            [
              class_ "TelemetrySpans"
                (constant "Channel" Channel.placeholder
                :: List.map (fun r -> constant (row_pascal r) r.name) t.spans);
              class_ "TelemetryMetrics"
                (List.map (fun r -> constant (row_pascal r) r.name) t.metrics);
            ];
        };
  }

let swift (t : t) =
  let module S = Swift_syntax in
  {
    Output.path = "swift/sdk/Sources/Xynolog/Generated/TelemetryKeys.swift";
    text =
      S.print
        {
          S.banner = Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            List.mapi
              (fun i k ->
                ( (if i = 0 then S.Blank else S.Line),
                  {
                    S.doc = Text.wrapped ~lead:"/// " ~width:100 about;
                    modifiers = [ "public" ];
                    body =
                      S.Property
                        {
                          var = false;
                          name = "attribute" ^ key_pascal k;
                          type_ = None;
                          value = Some (S.String k);
                        };
                  } ))
              t.keys;
        };
  }

let haskell (t : t) =
  let module H = Haskell_syntax in
  Haskell_sdk.file ~under:"generated"
    {
      H.banner = Banner.lines ~from_:file __FILE__;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Internal.Generated.TelemetryKeys";
      imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
      body =
        List.map
          (fun k ->
            H.value ("attribute" ^ key_pascal k) (T_name "Text") (Str k))
          t.keys;
    }

let haskell_names (t : t) =
  let module H = Haskell_syntax in
  let row name (r : row) =
    H.value
      ~about:(Text.wrapped ~lead:"-- | " ~width:80 r.meaning)
      (name r) (T_name "Text") (Str r.name)
  in
  Haskell_sdk.file ~under:"generated"
    {
      H.banner = Banner.lines ~from_:file __FILE__;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Internal.Generated.TelemetryNames";
      imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
      body =
        H.value
          ~about:[ "What stands for the bus channel in a span's name." ]
          "telemetryChannel" (T_name "Text") (Str Channel.placeholder)
        :: List.map (row haskell_span) t.spans
        @ List.map (row haskell_metric) t.metrics;
    }

(* The table as the Rust telemetry crate reports it
   (rust/telemetry/src/lib.rs): a constant per span, per metric and per
   attribute key, each named by its words. *)
let rust (t : t) =
  let module R = Rust_syntax in
  let constant ?(doc = []) name value =
    R.Const
      { doc; attrs = []; vis = Pub; name; ty = R.str_ty; value = R.Str value }
  in
  let row name (r : row) = constant ~doc:[ r.meaning ] (name r) r.name in
  {
    Output.path = "rust/telemetry/src/generated/table.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_:("protocol/specs/src/" ^ file) __FILE__)
        (constant
           ~doc:[ "What stands for the bus channel in a span's name." ]
           "CHANNEL" Channel.placeholder
         :: List.map (row span_constant) t.spans
        @ List.map (row metric_constant) t.metrics
        @ List.map
            (fun k -> constant ~doc:[ about ] ("ATTR_" ^ key_upper k) k)
            t.keys);
  }

let files ~root:_ (spec : Spec.t) =
  let table = spec.tables.sdk_telemetry_telemetry in
  Result.bind (derive table) (fun t ->
      Result.map
        (fun kotlin ->
          [
            go t;
            python t;
            ocaml t;
            kotlin;
            typescript t;
            typescript_names t;
            csharp t;
            csharp_names t;
            swift t;
            haskell t;
            haskell_names t;
            rust t;
          ])
        (Kotlin_sdk.written ~from_:file (fun () ->
             Kotlin.file ~from_:file
               ~keys:(List.map (fun k -> (python_key k, k)) t.keys)
               table)))
